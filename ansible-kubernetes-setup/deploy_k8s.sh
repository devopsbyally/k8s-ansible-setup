#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define paths
TERRAFORM_DIR="terraform"
INVENTORY_FILE="ansible_inventory"
COMMON_TAGS="common"
MASTER_TAGS="master"

# Step 1: Navigate to Terraform directory and run `terraform plan`
echo "Running Terraform plan..."
cd $TERRAFORM_DIR
terraform init
terraform plan -out=tfplan

# Step 2: If plan is successful, apply it
echo "Applying Terraform changes..."
terraform apply -auto-approve tfplan



# Step 3: Extract IPs from Terraform outputs and update Ansible inventory file
echo "Updating Ansible inventory file..."
MASTER_IP=$(terraform output -raw master_public_ip)
WORKER_NODE1_IP=$(terraform output -raw workernode1_public_ip )
WORKER_NODE2_IP=$(terraform output -raw workernode2_public_ip )
# Step 5: Navigate back to the original directory
cd ..
# Verify variables are set
echo "Master IP: $MASTER_IP" 
echo "Worker Node 1 IP: $WORKER_NODE1_IP"
echo "Worker Node 2 IP: $WORKER_NODE2_IP"
# Step 4: update the ansible inventory file

# Update master IP
sed -i '' "s/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\(.*node_name=k8s-master-node\)/${MASTER_IP}\1/" $INVENTORY_FILE

# Update worker node 1 IP
sed -i '' "/node_name=k8s-worker-node-1/s/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/${WORKER_NODE1_IP}/" $INVENTORY_FILE

# Update worker node 2 IP
sed -i '' "/node_name=k8s-worker-node-2/s/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/${WORKER_NODE2_IP}/" $INVENTORY_FILE

echo "Updated Ansible inventory:"
cat $INVENTORY_FILE
#wait for 30 second to validate your ansible inventory file
sleep 30

# Step 5: Run the common tag tasks for installing depedencies software on master and workers node

# Set environment variable to disable host key checking
export ANSIBLE_HOST_KEY_CHECKING=False

echo "Running Ansible playbook with common tags..."
ansible-playbook -i $INVENTORY_FILE kubernetes_setup.yml --tags "$COMMON_TAGS"

# Step 6: If the common tags succeed, run the master tag tasks
echo "Running Ansible playbook with master tags..."
ansible-playbook -i $INVENTORY_FILE kubernetes_setup.yml --tags "$MASTER_TAGS"

# Step 7: Playbook to join the worker node 

echo "Running Ansible playbook to join worker node..."

ansible-playbook -i $INVENTORY_FILE kubernetes_worker_setup.yml

echo "Kubernetes setup complete!"