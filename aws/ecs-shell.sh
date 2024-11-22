#!/bin/bash

echo "Checking AWS CLI installation..."
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found"
    exit 1
fi

select_from_list() {
    PS3="Enter selection number: "
    select item in "$@"; do
        if [[ -n $item ]]; then
            echo "$item"
            break
        fi
    done
}

echo "Fetching ECS clusters..."
clusters_json=$(aws ecs list-clusters 2>&1)
if [ $? -ne 0 ]; then
    echo "Error fetching clusters: $clusters_json"
    exit 1
fi

# Cross-platform array population
IFS=$'\n' read -r -d '' -a clusters < <(echo "$clusters_json" | jq -r '.clusterArns[]' | cut -d'/' -f2 && printf '\0')
if [ ${#clusters[@]} -eq 0 ]; then
    echo "No ECS clusters found"
    exit 1
fi

echo "Please select a cluster:"
selected_cluster=$(select_from_list "${clusters[@]}")
echo "Selected cluster: $selected_cluster"

echo "Fetching services for cluster $selected_cluster..."
services_json=$(aws ecs list-services --cluster "$selected_cluster" 2>&1)
if [ $? -ne 0 ]; then
    echo "Error fetching services: $services_json"
    exit 1
fi

IFS=$'\n' read -r -d '' -a services < <(echo "$services_json" | jq -r '.serviceArns[]' | cut -d'/' -f3 && printf '\0')
if [ ${#services[@]} -eq 0 ]; then
    echo "No services found in cluster $selected_cluster"
    exit 1
fi

echo "Please select a service:"
selected_service=$(select_from_list "${services[@]}")
echo "Selected service: $selected_service"

echo "Fetching tasks for service $selected_service..."
tasks_json=$(aws ecs list-tasks --cluster "$selected_cluster" --service-name "$selected_service" 2>&1)
if [ $? -ne 0 ]; then
    echo "Error fetching tasks: $tasks_json"
    exit 1
fi

IFS=$'\n' read -r -d '' -a tasks < <(echo "$tasks_json" | jq -r '.taskArns[]' | cut -d'/' -f3 && printf '\0')
if [ ${#tasks[@]} -eq 0 ]; then
    echo "No running tasks found for service $selected_service"
    exit 1
fi

echo "Please select a task:"
selected_task=$(select_from_list "${tasks[@]}")
echo "Selected task: $selected_task"

echo "Fetching containers for task $selected_task..."
containers_json=$(aws ecs describe-tasks --cluster "$selected_cluster" --tasks "$selected_task" 2>&1)
if [ $? -ne 0 ]; then
    echo "Error fetching containers: $containers_json"
    exit 1
fi

IFS=$'\n' read -r -d '' -a containers < <(echo "$containers_json" | jq -r '.tasks[0].containers[].name' && printf '\0')
if [ ${#containers[@]} -eq 0 ]; then
    echo "No containers found in task $selected_task"
    exit 1
fi

echo "Please select a container:"
selected_container=$(select_from_list "${containers[@]}")
echo "Selected container: $selected_container"

echo "Initiating shell connection..."
aws ecs execute-command \
    --cluster "$selected_cluster" \
    --task "$selected_task" \
    --container "$selected_container" \
    --command "/bin/bash" \
    --interactive

