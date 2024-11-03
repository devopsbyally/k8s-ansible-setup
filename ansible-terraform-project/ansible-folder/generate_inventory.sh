#!/bin/bash

# Get the IP addresses of the managed nodes
amazon_linux_ip=$(terraform output -raw managed-node-amazon-linux-server1-ip)
rhel_ip=$(terraform output -raw managed-node-rhel-server1-ip)

# Create the Ansible inventory file
cat <<EOF > ansible-folder/ansible-inventory-folder/ansible_inventory
[mangednodes]
$amazon_linux_ip
$rhel_ip

[amazon_linux]
$amazon_linux_ip

[rhel]
$rhel_ip

EOF

echo "Ansible inventory file created: ansible_inventory"
