# Instance IP
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

# Output the Elastic IP
output "static_ip" {
  value = aws_eip.web_static_ip.public_ip
  description = "The static IP address of the instance"
}


# Output the SSH Key Name
output "ssh_key_name" {
  value       = aws_key_pair.web_key.key_name
  description = "The name of the SSH key used for the instance"
}

# Output the SSH Key Public Content
# output "ssh_key_public" {
#   value       = aws_key_pair.web_key.public_key
#   description = "The public key used for SSH access"
# }

# Output for SSH Connection Command
output "ssh_connection" {
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_eip.web_static_ip.public_ip}"
  description = "Command to connect to the instance via SSH"
}