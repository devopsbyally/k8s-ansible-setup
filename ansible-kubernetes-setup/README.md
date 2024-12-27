# Kubernetes Setup Using kubeadm, Terraform, Ansible, and Shell Script

This project automates the setup of a Kubernetes cluster using **kubeadm** for cluster management, **Terraform** for provisioning EC2 instances, **Ansible** for configuring and installing Kubernetes, and a **Shell Script** to orchestrate the entire process.

## Project Structure

- **terraform/**: Terraform configuration files to provision EC2 instances for the Kubernetes cluster.
- **ansible_inventory**: Ansible inventory file containing the IP addresses of master and worker nodes.
- **kubernetes_setup.yml**: Ansible playbook to install Kubernetes on master and worker nodes.
- **kubernetes_worker_setup.yml**: Ansible playbook to configure worker nodes and join them to the Kubernetes cluster.
- **deploy_k8s.sh**: Shell script to automate the entire process from provisioning to configuration.

## Prerequisites

Ensure the following tools are installed on your local system:

- **Terraform**: To provision the infrastructure.
- **Ansible**: To configure Kubernetes.
- **kubeadm**: For Kubernetes cluster setup.
- **AWS CLI**: To interact with AWS resources.
- **jq**: To parse JSON outputs from Terraform.
- **bash**: To execute the shell script.

Also, ensure you have an AWS account with credentials configured.

## Setup Steps

1. Clone the repository and navigate to the project directory:
   ```bash
   git clone <repository-url>
   cd <project-directory>
Edit terraform/variables.tf to set your AWS region, instance types, and other configurations.

Initialize and apply the Terraform configurations:

bash
Copy code
cd terraform
terraform init
terraform apply
Update the ansible_inventory file with the IPs of the EC2 instances created by Terraform.

Run the shell script to configure Kubernetes:

bash
Copy code
./deploy_k8s.sh
Verification
After the script completes, verify the Kubernetes cluster:

Check the nodes:

bash
Copy code
kubectl get nodes
Example Output:

css
Copy code
NAME                STATUS   ROLES           AGE   VERSION
k8s-master-node     Ready    control-plane   76s   v1.30.8
k8s-worker-node-1   Ready    <none>          19s   v1.30.8
k8s-worker-node-2   Ready    <none>          17s   v1.30.8
Check the pods:

bash
Copy code
kubectl get pods -A
Example Output:

sql
Copy code
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
kube-system   coredns-55cb58b774-4zmfn                  1/1     Running   0          2m29s
kube-system   kube-apiserver-k8s-master-node            1/1     Running   0          2m45s
...
Notes
The setup uses Weave Net as the default CNI plugin for Kubernetes networking.
Ensure proper IAM permissions are configured for the AWS account to provision resources using Terraform.
License
This project is licensed under the MIT License. See the LICENSE file for details.

typescript
Copy code

Replace `<repository-url>` and `<project-directory>` with the appropriate values for your project. Let me know if you need any additional changes!





