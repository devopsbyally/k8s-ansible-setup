output "managed-node-amazon-linux-server1-ip" {
    value = aws_instance.ansible-managed-amazon-linux-server1.private_ip
  
}

output "managed-node-rhel-server1-ip" {
    value = aws_instance.ansible-managed-rhel-server1.private_ip
  
}