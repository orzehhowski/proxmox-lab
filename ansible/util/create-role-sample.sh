#!/usr/bin/env bash
# create_role.sh
# Creates Ansible Role basic structure: defaults/, handlers/, tasks/, templates/
# Usage: ./create_role.sh role_name
# Execute in /ansible directory!

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <role_name>"
    exit 1
fi

role_name="$1"

mkdir -p "roles/${role_name}"

for dir in defaults handlers tasks templates; do
    mkdir -p "roles/${role_name}/${dir}"
done

for dir in defaults handlers tasks; do
    touch "roles/${role_name}/${dir}/main.yml"
done