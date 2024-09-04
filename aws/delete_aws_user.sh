#!/bin/bash

# Prompt for username
read -p "Enter the username of the AWS user to delete: " username

# Function to check if user exists
check_user_exists() {
    aws iam get-user --user-name "$username" &> /dev/null
    return $?
}

# Check if user exists
if ! check_user_exists; then
    echo "User $username does not exist. Exiting."
    exit 1
fi

# Remove login profile if it exists
if aws iam get-login-profile --user-name "$username" &> /dev/null; then
    echo "Removing login profile..."
    aws iam delete-login-profile --user-name "$username"
fi

# List and detach all attached user policies
echo "Detaching user policies..."
for policy in $(aws iam list-attached-user-policies --user-name "$username" --query 'AttachedPolicies[*].PolicyArn' --output text); do
    aws iam detach-user-policy --user-name "$username" --policy-arn "$policy"
done

# List and remove all inline user policies
echo "Removing inline user policies..."
for policy in $(aws iam list-user-policies --user-name "$username" --query 'PolicyNames[*]' --output text); do
    aws iam delete-user-policy --user-name "$username" --policy-name "$policy"
done

# Delete access keys
echo "Deleting access keys..."
for key in $(aws iam list-access-keys --user-name "$username" --query 'AccessKeyMetadata[*].AccessKeyId' --output text); do
    aws iam delete-access-key --user-name "$username" --access-key-id "$key"
done

# Delete the user
echo "Deleting user..."
if aws iam delete-user --user-name "$username"; then
    echo "User $username has been successfully deleted."
else
    echo "Failed to delete user $username. Please check for any remaining attached resources."
fi