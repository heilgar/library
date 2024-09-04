#!/bin/bash

# Prompt for username
read -p "Enter the username for the new AWS admin user: " username

# Prompt for password
read -s -p "Enter the password for the new AWS admin user: " password
echo

# Create the user
if aws iam create-user --user-name "$username"; then
    echo "User $username created successfully."
else
    echo "Failed to create user $username. Exiting."
    exit 1
fi

# Create login profile (this sets up console access)
if aws iam create-login-profile --user-name "$username" --password "$password" --password-reset-required; then
    echo "Login profile created successfully. User will be required to change password on first login."
else
    echo "Failed to create login profile. Exiting."
    exit 1
fi

# Attach AdministratorAccess policy
if aws iam attach-user-policy --user-name "$username" --policy-arn arn:aws:iam::aws:policy/AdministratorAccess; then
    echo "AdministratorAccess policy attached successfully."
else
    echo "Failed to attach AdministratorAccess policy. Exiting."
    exit 1
fi

echo "Admin user $username has been created with full console access."
echo "Please ensure you set up Multi-Factor Authentication (MFA) for this user as soon as possible."