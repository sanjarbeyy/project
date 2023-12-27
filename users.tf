resource "aws_iam_user" "sysadmin1" {
  name = "sysadmin1"

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_access_key" "sysadmin1" {
  user = aws_iam_user.sysadmin1.name
}

# resource "aws_iam_user_policy_attachment" "sysadmin1_policy" {
#   user       = aws_iam_user.sysadmin1.name
#   policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
# }

# resource "aws_iam_virtual_mfa_device" "sysadmin1_mfa_device" {
#   virtual_mfa_device_name = "sysadmin1_mfa_device"
#   user_name = aws_iam_user.sysadmin1.id
# }

resource "aws_iam_user" "sysadmin2" {
  name = "sysadmin2"

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_access_key" "sysadmin2" {
  user = aws_iam_user.sysadmin2.name
}

# resource "aws_iam_virtual_mfa_device" "mfa_device" {
#   for_each = var.iam_user_names
#   virtual_mfa_device_name = "mfa_device"
#   user_name               = [aws_aim_user.sysadmin1, aws_aim_user.sysadmin2]
# }


resource "aws_iam_user" "dbadmin1" {
  name = "dbadmin1"

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_access_key" "dbadmin1" {
  user = aws_iam_user.dbadmin1.name
}

resource "aws_iam_user" "dbadmin2" {
  name = "dbadmin2"

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_access_key" "dbadmin2" {
  user = aws_iam_user.dbadmin2.name
}

resource "aws_iam_user" "monitor1" {
  name = "monitor1"

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_access_key" "monitor1" {
  user = aws_iam_user.monitor1.name
}

resource "aws_iam_user" "monitor2" {
  name = "monitor2"

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_access_key" "monitor2" {
  user = aws_iam_user.monitor2.name
}

resource "aws_iam_user" "monitor3" {
  name = "monitor3"

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_access_key" "monitor3" {
  user = aws_iam_user.monitor3.name
}

resource "aws_iam_user" "monitor4" {
  name = "monitor4"

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_access_key" "monitor4" {
  user = aws_iam_user.monitor4.name
}

resource "aws_iam_group" "system_admins" {
  name = "system-administrators"
}

resource "aws_iam_group" "database_admins" {
  name = "database-administrators"
}

resource "aws_iam_group" "monitoring_group" {
  name = "monitoring-group"
}

resource "aws_iam_group_membership" "database_admins" {
  name  = "database_administrators"
  users = [aws_iam_user.dbadmin1.name, aws_iam_user.dbadmin2.name, ]
  group = aws_iam_group.database_admins.name
}

resource "aws_iam_group_membership" "system_admins" {
  name  = "system_adminstrators"
  users = [aws_iam_user.sysadmin1.name, aws_iam_user.sysadmin2.name]
  group = aws_iam_group.system_admins.name
}

resource "aws_iam_group_membership" "monitoring_group" {
  name  = "monitoring-group"
  users = [aws_iam_user.monitor1.name, aws_iam_user.monitor2.name, aws_iam_user.monitor3.name, aws_iam_user.monitor4.name]
  group = aws_iam_group.monitoring_group.name
}

# locals {
#    sysadmin1_keys_csv = "access_key,secret_key\n${aws_iam_access_key.sysadmin1_access_key.id},${aws_iam_access_key.achintha_access_key.secret}"
#  }


# resource "local_file" "sysadmin1_keys" {
#  content  = local.sysadmin1_keys_csv
#    filename = "asysadmin1-keys.csv"
# }