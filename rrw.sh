#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

output_file="$1"
current_dir=$(pwd)

# Clear the output file if it exists
> "$output_file"

# Find all files and read their content
find . -type f | while read -r file; do
    # Skip the output file itself
    if [[ "$(realpath "$file")" == "$(realpath "$output_file")" ]]; then
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

