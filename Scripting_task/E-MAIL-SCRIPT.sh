#!/bin/bash

# 📧 Email Validation Script
# This script reads email data from a file, checks for validity, and identifies odd/even IDs.

# Function: Validate if an email address is in a proper format
validate_email() {
    local email_address="$1"
    [[ "$email_address" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# File to process 📄
INPUT_FILE="emails.txt"

# Ensure the input file exists
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "❌ Error: Input file '$INPUT_FILE' not found!"
    exit 1
fi

# Process each line in the input file
while IFS=',' read -r user_name user_email user_id; do
    # Trim any extra spaces from the inputs
    user_name=$(echo "$user_name" | xargs)
    user_email=$(echo "$user_email" | xargs)
    user_id=$(echo "$user_id" | xargs)

    # Validate the ID is a number and determine if it's odd or even
    if [[ -n "$user_id" && "$user_id" =~ ^[0-9]+$ ]]; then
        if (( user_id % 2 == 0 )); then
            id_type="even"
        else
            id_type="odd"
        fi

        # Validate the email address
        if validate_email "$user_email"; then
            echo "✅ User: $user_name | Email: $user_email | ID: $user_id ($id_type number)"
        else
            echo "⚠️ Warning: Invalid email address for user '$user_name'."
        fi
    else
        echo "⚠️ Warning: Invalid or missing ID for user '$user_name'."
    fi

done < "$INPUT_FILE"

# Completion message
echo "🎉 Processing complete!"
