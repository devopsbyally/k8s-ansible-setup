output "master_public_ip" {
  value = aws_instance.master.public_ip
}

output "workernode1_public_ip" {
  value = aws_instance.workers[0].public_ip
}
output "workernode2_public_ip" {
  value = aws_instance.workers[1].public_ip
}