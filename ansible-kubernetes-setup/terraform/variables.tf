variable "aws_region" {
    type = string
    default = "us-east-1"
  
}
variable "master_instance_type" {
  default = "t2.medium"
}

variable "worker_instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  default     = " " 
}

variable "key_name" {
  description = "Key pair for accessing the instances"

}
