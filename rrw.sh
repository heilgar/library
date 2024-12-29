#!/bin/bash

# Initialize empty array for ignore patterns
declare -a ignore_patterns=(".git/")

# Function to display usage
show_usage() {
    echo "Usage: $0 [options] <output_file>"
    echo "Options:"
    echo "  -i, --ignore PATTERN   Specify patterns to ignore (can be used multiple times)"
    echo "                         Example: -i '.git/' -i '*.log' -i 'dist/'"
    exit 1
}


# Function to check if a file should be ignored
should_ignore() {
    local file="$1"

    # Always ignore the .git directory
    if [[ "$file" == *"/.git/"* ]] || [[ "$file" == ".git/"* ]]; then
        return 0
    fi

    # Check against each ignore pattern
    for pattern in "${ignore_patterns[@]}"; do
        if [[ "$file" == *"$pattern"* ]]; then
            return 0  # Should ignore (true)
        fi
    done

    return 1  # Should not ignore (false)
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--ignore)
            if [[ -z "$2" ]]; then
                echo "Error: Ignore pattern is missing"
                show_usage
            fi
            ignore_patterns+=("$2")
            shift 2
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            if [[ -n "$output_file" ]]; then
                echo "Error: Too many arguments"
                show_usage
            fi
            output_file="$1"
            shift
            ;;
    esac
done

# Check if output file is provided
if [[ -z "$output_file" ]]; then
    echo "Error: Output file is required"
    show_usage
fi

# Display ignore patterns if any are set
if [ ${#ignore_patterns[@]} -gt 0 ]; then
    echo "Ignoring patterns:"
    printf '  %s\n' "${ignore_patterns[@]}"
fi

# Clear the output file if it exists
> "$output_file"

# Find all files and read their content
find . -type f | while read -r file; do

    # Skip if file matches any ignore pattern
    if should_ignore "$file"; then
        continue
    fi

    # Skip the output file itself
    if [[ "$(realpath "$file")" == "$(realpath "$output_file")" ]]; then
        continue
    fi

    # Check if the file is ignored by .gitignore
    if git check-ignore -q "$file"; then
        continue
    fi

    # Get the relative path and determine if it's in the current directory or nested
    relative_path="${file#./}"

    # Print the header based on the file's location
    if [[ "$file" == "./$relative_path" ]]; then
        echo "-- $relative_path" >> "$output_file"  # Current directory
    else
        echo "-- $relative_path" >> "$output_file"  # Nested path
    fi

    echo "" >> "$output_file"  # Add a newline for separation
    cat "$file" >> "$output_file"  # Append the content of the file
    echo "" >> "$output_file"  # Add a newline after the content
    echo "----------------------------------------" >> "$output_file"  # Separator
    echo "" >> "$output_file"  # Add a newline after the separator
done

echo "File contents have been written to $output_file."

