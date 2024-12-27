# Kubernetes Setup Using kubeadm, Terraform, Ansible, and Shell Script

This project automates the setup of a Kubernetes cluster using **kubeadm** for cluster management, **Terraform** for provisioning EC2 instances (master and worker nodes), **Ansible** for configuring and installing Kubernetes, and a **Shell Script** to orchestrate the entire process.

## Project Structure

- **terraform/**: Contains Terraform configuration files to provision EC2 instances for master and worker nodes.
- **ansible_inventory**: The Ansible inventory file that contains the IP addresses of the master and worker nodes.
- **kubernetes_setup.yml**: Ansible playbook to install Kubernetes on the master and worker nodes.
- **kubernetes_worker_setup.yml**: Ansible playbook to configure the worker nodes and join them to the Kubernetes cluster.
- **deploy_k8s.sh**: Shell script that orchestrates the entire process, from provisioning EC2 instances to configuring Kubernetes.

## Prerequisites

Ensure you have the following tools installed before running this project:

- **Terraform**: For provisioning the infrastructure.
- **Ansible**: For configuring the Kubernetes cluster.
- **kubeadm**: For setting up Kubernetes.
- **AWS CLI**: To interact with AWS resources.
- **jq**: For processing JSON outputs from Terraform.
- **bash**: To execute the shell script.

Also, ensure you have an AWS account and your AWS credentials configured.

[ec2-user@k8s-master-node ~]$ kubectl get nodes
NAME                STATUS   ROLES           AGE   VERSION
k8s-master-node     Ready    control-plane   76s   v1.30.8
k8s-worker-node-1   Ready    <none>          19s   v1.30.8
k8s-worker-node-2   Ready    <none>          17s   v1.30.8

[ec2-user@k8s-master-node ~]$ kubectl get pods -A
NAMESPACE     NAME                                      READY   STATUS    RESTARTS        AGE
kube-system   coredns-55cb58b774-4zmfn                  1/1     Running   0               2m29s
kube-system   coredns-55cb58b774-5mzxp                  1/1     Running   0               2m29s
kube-system   etcd-k8s-master-node                      1/1     Running   0               2m45s
kube-system   kube-apiserver-k8s-master-node            1/1     Running   0               2m45s
kube-system   kube-controller-manager-k8s-master-node   1/1     Running   0               2m46s
kube-system   kube-proxy-hrz6j                          1/1     Running   0               2m29s
kube-system   kube-proxy-kmslk                          1/1     Running   0               111s
kube-system   kube-proxy-prx4z                          1/1     Running   0               109s
kube-system   kube-scheduler-k8s-master-node            1/1     Running   0               2m45s
kube-system   weave-net-rdng6                           2/2     Running   1 (73s ago)     111s
kube-system   weave-net-sggbl                           2/2     Running   0               109s
kube-system   weave-net-tx7m4                           2/2     Running   1 (2m16s ago)   2m21s