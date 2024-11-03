##################      Ansible Master server setup          ################

#IAM role,policy and instance profile for Ansible Master server.

resource "aws_iam_role" "ansible-master-ec2-role" {

    name = "ansible-master-ec2-role"
    assume_role_policy = templatefile("${path.module}/policies/ec2-trust-policy.json.tpl", {} )
  
}
resource "aws_iam_policy" "ansible-master-ec2-iam-policy" {
      name        = "ansible-master-ec2-iam-policy"
      description = "Policy for Ansible master server to access SSM Parameter Store"
      policy      = templatefile("${path.module}/policies/ansible-master-server.json.tpl", {account_number = var.account_number})


}
resource "aws_iam_policy_attachment" "ansible-master-ec2-policy-attachment" {
    name = "ec2-policy-attachment"
    policy_arn = aws_iam_policy.ansible-master-ec2-iam-policy.arn
    roles = [ aws_iam_role.ansible-master-ec2-role.name ]
  
}

resource "aws_iam_instance_profile" "ansible-master-ec2-instance-profile" {
    name = "ansible-master-ec2-instance-profile"
    role = aws_iam_role.ansible-master-ec2-role.name
  
}

# Create an SSM Parameter Store to store ansible public key
resource "aws_ssm_parameter" "public_key_parameter" {
  name  = "ansible-master-public-key"
  type  = "String"
  value = " " # Placeholder value; can be updated later
    lifecycle {
    ignore_changes = [value]  # Ignore changes to the value attribute
  }
}

# Security Group for Ansible Master EC2 instance
resource "aws_security_group" "ansible_master_sg" {
  name        = "ansible-master-sg"
  description = "Allow SSH access for Ansible Master EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to restrict access to specific IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ansible-master-ec2" {
    instance_type = var.instance_type
    ami = data.aws_ami.amzlinux2023.id
    key_name = var.key_name
    vpc_security_group_ids = [ aws_security_group.ansible_master_sg.id ]
    user_data = templatefile("${path.module}/userdata/ansible-master-user-data.tpl", {} )
    iam_instance_profile = aws_iam_instance_profile.ansible-master-ec2-instance-profile.name
    tags = {
      Name = "ansible-master-ec2"
    }
  
}

################################ Ansible Managed Nodes ##############################

#IAM role,policy and instance profile for Ansible Managed server.

resource "aws_iam_role" "ansible-managed-ec2-role" {

    name = "ansible-managed-ec2-role"
    assume_role_policy = templatefile("${path.module}/policies/ec2-trust-policy.json.tpl", {} )
  
}
resource "aws_iam_policy" "ansible-managed-ec2-iam-policy" {
      name        = "ansible-managed-ec2-iam-policy"
      description = "Policy for Ansible managed server to access SSM Parameter Store"
      policy      = templatefile("${path.module}/policies/ansible-managed-server.json.tpl", {account_number = var.account_number})


}
resource "aws_iam_policy_attachment" "ansible-managed-ec2-policy-attachment" {
    name = "ec2-policy-attachment"
    policy_arn = aws_iam_policy.ansible-managed-ec2-iam-policy.arn
    roles = [ aws_iam_role.ansible-managed-ec2-role.name ]
  
}

resource "aws_iam_instance_profile" "ansible-managed-ec2-instance-profile" {
    name = "ansible-managed-ec2-instance-profile"
    role = aws_iam_role.ansible-managed-ec2-role.name
  
}

# Security Group for Ansible Managed EC2 instance
resource "aws_security_group" "ansible_managed_sg" {
  name        = "ansible-manged-sg"
  description = "Allow SSH ,HTTP and 8080 access for Ansible Managed EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to restrict access to specific IPs
  }

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to restrict access to specific IPs
  }

    ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to restrict access to specific IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ansible-managed-amazon-linux-server1" {
    instance_type = var.instance_type
    ami = data.aws_ami.amzlinux2023.id
    key_name = var.key_name
    vpc_security_group_ids = [ aws_security_group.ansible_managed_sg.id]
    user_data = templatefile("${path.module}/userdata/ansible-managed-server-user-data.tpl", {} )
    iam_instance_profile = aws_iam_instance_profile.ansible-managed-ec2-instance-profile.name
    tags = {
      Name = "ansible-managed-Amazon-linux-server-1"
    }
  
}

resource "aws_instance" "ansible-managed-rhel-server1" {
    instance_type = var.instance_type
    ami = data.aws_ami.rhel_latest.id
    key_name = var.key_name
    vpc_security_group_ids = [ aws_security_group.ansible_managed_sg.id]
    user_data = templatefile("${path.module}/userdata/ansible-managed-server-rhel-userdata.tpl", {} )
    iam_instance_profile = aws_iam_instance_profile.ansible-managed-ec2-instance-profile.name
    tags = {
      Name = "ansible-managed-rhel-server-1"
    }
  
}

# Create Ansible inventory dynamically and upload it
resource "null_resource" "generate_ansible_inventory" {
  provisioner "local-exec" {
   
    command = "bash ${path.module}/ansible-folder/generate_inventory.sh"  # Update to your actual script path
  }

  # This triggers the provisioner whenever the resource is created or updated
  triggers = {
    current_time = timestamp()
  }
}

# Upload the playbook and inventory folder to the Ansible Master server
resource "null_resource" "upload_ansible_folder" {
  depends_on = [null_resource.generate_ansible_inventory] # Ensure the inventory is generated first

  provisioner "file" {
    source      = "./ansible-folder/" # Path to the generated inventory file
    destination = "/home/ec2-user" # Change to your desired destination path on the Ansible master
    connection {
      type        = "ssh"
      user        = "ec2-user" # Change this to the appropriate user
      private_key = file("/Users/rahulranjan/Downloads/terraform-key.pem") # Path to your SSH private key
      host        = aws_instance.ansible-master-ec2.public_ip # Public IP of the Ansible master
    }
  }

  # This triggers the upload whenever the inventory file is created or updated
  triggers = {
    current_time = timestamp()
  }
}