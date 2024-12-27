resource "aws_security_group" "kubernetes_control_plane_sg" {
  name        = "kubernetes-control-plane-sg"
  description = "Security group for Kubernetes control plane"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }


  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "kubernetes_worker_node_sg" {
  name        = "kubernetes-worker-node-sg"
  description = "Security group for Kubernetes worker nodes"

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = 10256
    to_port     = 10256
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "master" {
  ami           = data.aws_ami.rhel_latest.id
  instance_type = var.master_instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [ aws_security_group.kubernetes_control_plane_sg.id]

  tags = {
    Name = "k8s-master-node"
  }

}

resource "aws_instance" "workers" {
  count         = 2
  ami           = data.aws_ami.rhel_latest.id
  instance_type = var.worker_instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [ aws_security_group.kubernetes_worker_node_sg.id]

  tags = {
    Name = "k8s-worker-${count.index + 1}"
  }

}

