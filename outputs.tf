###########################
## Define module outputs ##
###########################

# Notice how we refer to the resource's attribute(s) that will be newly created
output "instance_public_dns" {
  value = aws_instance.app_server.public_dns
}
