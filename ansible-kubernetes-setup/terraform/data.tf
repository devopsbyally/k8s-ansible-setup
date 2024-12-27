# Get latest AMI ID for Red Hat Enterprise Linux
data "aws_ami" "rhel_latest" {
  most_recent = true
  owners      = ["309956199498"] # Red Hat's official account ID

  filter {
    name   = "name"
    values = ["RHEL-9*-GP3"] # Change this to match the naming convention for RHEL AMIs
  }
  
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}