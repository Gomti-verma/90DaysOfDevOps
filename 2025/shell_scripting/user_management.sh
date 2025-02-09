#!/bin/bash

# Display usage function
usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -c, --create    Create a new user account"
  echo "  -d, --delete    Delete an existing user account"
  echo "  -r, --reset     Reset the password for an existing user"
  echo "  -l, --list      List all user accounts"
  echo "  -h, --help      Display this help message"
  exit 1
}

# Create a new account
create_account() {
  read -p "Enter new username: " username
  read -sp "Enter new password: " password
  echo

  # Check if the username already exists
  if id "$username" &>/dev/null; then
    echo "Error: Username '$username' already exists."
    exit 1
  fi

  # Create the user
  useradd "$username"
  echo "$username:$password" | chpasswd

  # Provide feedback
  echo "Account created successfully for '$username'."
}

# Delete an account
delete_account() {
  read -p "Enter username to delete: " username

  # Check if the username exists
  if ! id "$username" &>/dev/null; then
    echo "Error: User '$username' does not exist."
    exit 1
  fi

  # Delete the user
  userdel "$username"

  # Provide feedback
  echo "User '$username' deleted successfully."
}

# Reset password for an existing account
reset_password() {
  read -p "Enter username to reset password: " username

  # Check if the username exists
  if ! id "$username" &>/dev/null; then
    echo "Error: User '$username' does not exist."
    exit 1
  fi

  read -sp "Enter new password: " password
  echo

  # Reset the password
  echo "$username:$password" | chpasswd

  # Provide feedback
  echo "Password for user '$username' reset successfully."
}

# List all user accounts
list_accounts() {
  echo "Listing all user accounts:"
  cut -d: -f1,3 /etc/passwd
}

# If no arguments are passed, show usage
if [ $# -eq 0 ]; then
  usage
fi

# Parse the command-line arguments
case "$1" in
  -c|--create)
    create_account
    ;;
  -d|--delete)
    delete_account
    ;;
  -r|--reset)
    reset_password
    ;;
  -l|--list)
    list_accounts
    ;;
  -h|--help)
    usage
    ;;
  *)
    echo "Invalid option"
    usage
    ;;
esac

