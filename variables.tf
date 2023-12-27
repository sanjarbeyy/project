variable "public_subnets" {
  type = map(object({
    name              = string,
    cidr_block        = string,
    availability_zone = string
  }))

  default = {
  }
}
variable "private_subnets" {
  type = map(object({
    name              = string,
    cidr_block        = string,
    availability_zone = string
  }))

  default = {
  }
}
variable "prefix" {
  type    = string
  default = "GoGreen-project"

}
variable "nat-rta" {
  type = map(object({
    route_table_id = string,
    subnet_id      = string
  }))
  default = {
  }
}
variable "security-groups" {
  description = "A map of security groups with their rules"
  type = map(object({
    description = string
    ingress_rules = optional(list(object({
      description     = optional(string)
      priority        = optional(number)
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      security_groups = optional(list(string))
    })))
    egress_rules = list(object({
      description     = optional(string)
      priority        = optional(number)
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = list(string)
      security_groups = optional(list(string))
    }))
  }))
}


variable "key_name" {
  type    = string
  default = ""
}

# variable "aws_iam_virtual_mfa_device" {
#   type = map(object({
#     user_name = string
#   }))
#   default = {
#   }
# }
# AWS IAM policy for the MFA device. If not provided a generic one will be created.

# variable "iam_user_names" {
#   type    = list(string)
#   default = ["sysadmin1", "sysadmin2"]
# }
#############################################################
variable "max_password_age" {
  type        = number
  default     = 90
  description = "The number of days that an user password is valid."
}

variable "password_reuse_prevention" {
  type        = number
  default     = 3
  description = "The number of previous passwords that users are prevented from reusing."
}

variable "hard_expiry" {
  type        = string
  default     = false
  description = "Whether users are prevented from setting a new password after their password"
}

# variable "vpc_id" {
#   type    = string
#   default = "vpc"
# }
# locals {
#   ALB_WEB_sg_name  = "ALB_WEB_sg"
#   ALB_APP_sg_name  = "ALB_APP_sg"
#   WEB_EC2_sg_name  = "WEB_EC2_sg"
#   APP_EC2_sg_name  = "APP_EC2_sg"
#   database_sg_name = "database_sg"
#   bastion_sg_name  = "bastion_sg"
# }