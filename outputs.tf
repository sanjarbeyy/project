output "my_eip" {
  value = { for k, v in aws_eip.nat : k => v.public_ip }
}

#  output "access_key_id" {
#    value = aws_iam_access_key.sysadmin1_access_key.id
#    sensitive = true
# }

# output "secret_access_key" {
#    value = aws_iam_access_key.sysadmin1_access_key.secret
#    sensitive = true
# }

# output "bastion_ip_address" {                            
#     value = aws_instance.bastion.public_ip          
# }