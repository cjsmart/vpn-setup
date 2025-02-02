#!/bin/bash
set -euo pipefail

# Print usage
usage() {
  echo "Usage: $0 -u <username> -h <host>"
  echo "  -u  Remote machine username"
  echo "  -h  Remote machine IP address or hostname"
  exit 1
}

# Check the number of arguments
if [ $# -eq 0 ]; then
  usage
fi

# Parse command line arguments
while getopts ":u:h:" opt; do
  case $opt in
    u) USERNAME="$OPTARG" ;;
    h) HOST="$OPTARG" ;;
    *) usage ;;
  esac
done

# Ensura the both parameters are set
if [ -z "$USERNAME" ] || [ -z "$HOST" ]; then
  echo "Error: username and remote machine address must be set."
  usage
fi

# Run Ansible-playbooks
echo "Running bootstrap.yml as $USERNAME on $HOST..."
ansible-playbook -i "$HOST," -u "$USERNAME" bootstrap.yml

if [ $? -eq 0 ]; then
  echo "bootstrap.yml completed successfully."
else
  echo "Error while executing bootstrap.yml."
  exit 1
fi

echo "Running playbook.yml as $USERNAME on $HOST..."
ansible-playbook -i "$HOST," playbook.yml

if [ $? -eq 0 ]; then
  echo "playbook.yml completed successfully."
else
  echo "Error while executing playbook.yml."
  exit 1
fi

echo "All playbooks completed successfully."
exit 0
