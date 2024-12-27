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
- **AWS CLI**: To interact with AWS resources.
- **jq**: To parse JSON outputs from Terraform.
- **bash**: To execute the shell script.

## Setup and Execution

### Steps : The deploy_k8s.sh shell script automates the entire process

1. Provisions EC2 instances using Terraform.
2. Updates the ansible_inventory file with IP addresses of the provisioned nodes.
3. Runs the Ansible playbooks for setting up Kubernetes on the master and worker nodes.

# Kubernetes Cluster Setup and Status

Once the deploy_k8s.sh shell script run successfully Kubernetes cluster configuration and the current status of nodes and pods in the cluster looks like belows:

## Cluster Nodes

The Kubernetes cluster consists of one master node and two worker nodes. Below is the status of the nodes:

| Node Name           | Status | Roles           | Age   | Kubernetes Version |
|---------------------|--------|-----------------|-------|---------------------|
| k8s-master-node     | Ready  | control-plane   | 76s   | v1.30.8            |
| k8s-worker-node-1   | Ready  | <none>          | 19s   | v1.30.8            |
| k8s-worker-node-2   | Ready  | <none>          | 17s   | v1.30.8            |

## Cluster Pods

The cluster has several system pods running across different nodes. Below is the status of the pods in the `kube-system` namespace:

| Namespace   | Pod Name                                | Ready | Status  | Restarts | Age    |
|-------------|-----------------------------------------|-------|---------|----------|--------|
| kube-system | coredns-55cb58b774-4zmfn               | 1/1   | Running | 0        | 2m29s  |
| kube-system | coredns-55cb58b774-5mzxp               | 1/1   | Running | 0        | 2m29s  |
| kube-system | etcd-k8s-master-node                   | 1/1   | Running | 0        | 2m45s  |
| kube-system | kube-apiserver-k8s-master-node         | 1/1   | Running | 0        | 2m45s  |
| kube-system | kube-controller-manager-k8s-master-node| 1/1   | Running | 0        | 2m46s  |
| kube-system | kube-proxy-hrz6j                       | 1/1   | Running | 0        | 2m29s  |
| kube-system | kube-proxy-kmslk                       | 1/1   | Running | 0        | 111s   |
| kube-system | kube-proxy-prx4z                       | 1/1   | Running | 0        | 109s   |
| kube-system | kube-scheduler-k8s-master-node         | 1/1   | Running | 0        | 2m45s  |
| kube-system | weave-net-rdng6                        | 2/2   | Running | 1 (73s ago) | 111s |
| kube-system | weave-net-sggbl                        | 2/2   | Running | 0        | 109s   |
| kube-system | weave-net-tx7m4                        | 2/2   | Running | 1 (2m16s ago) | 2m21s |

## Key Observations

- All nodes are in the `Ready` state, indicating they are active and functioning correctly.
- System pods such as `coredns`, `etcd`, `kube-apiserver`, `kube-controller-manager`, and `kube-scheduler` are running on the master node.
- Network-related pods (`weave-net`) and `kube-proxy` are running on both master and worker nodes.
- No pod is in a failed or crash loop state.

## Notes

- The cluster is running Kubernetes version **v1.30.8**.
- The Weave Net pods have minor restarts, likely due to initialization, but they are now stable.

## Commands to Reproduce

You can verify the cluster status using the following commands:
```bash
kubectl get nodes
kubectl get pods -A












