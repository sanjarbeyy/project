resource "aws_vpc" "vpc" {
  cidr_block           = "54.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    name = "${var.prefix}-vpc"
  }
}
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = var.public_subnets
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true # To ensure the instance gets a public IP

  tags = {
    Name = "${each.value.name}-public-subnet"
  }
}
resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.vpc.id
  for_each          = var.private_subnets
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  # map_public_ip_on_launch = true # To ensure the instance gets a public IP

  tags = {
    Name = "${each.value.name}-private-subnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-public-rt"
  }
}
resource "aws_route_table_association" "rta" {
  for_each  = var.public_subnets
  subnet_id = aws_subnet.public_subnets[each.key].id
  #subnet_id      = [module.subnets.subnet_ids["public_subnets"]]
  route_table_id = aws_route_table.rt.id
}
resource "aws_nat_gateway" "ngw" {
  for_each      = var.public_subnets
  subnet_id     = aws_subnet.public_subnets[each.key].id
  allocation_id = aws_eip.nat[each.key].id
}
resource "aws_eip" "nat" {
  for_each = var.public_subnets
  domain   = "vpc"
}
resource "aws_route_table" "rt-nat" {
  vpc_id   = aws_vpc.vpc.id
  for_each = aws_nat_gateway.ngw
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[each.key].id
  }
  tags = {
    Name = "${var.prefix}-private-rt"
  }
}
resource "aws_route_table_association" "rt-nat" {
  for_each  = var.nat-rta
  subnet_id = aws_subnet.private_subnets[each.value.subnet_id].id
  #subnet_id      = [module.subnets.subnet_ids["public_subnets"]]
  route_table_id = aws_route_table.rt-nat[each.value.route_table_id].id
}

module "security-groups" {
  source          = "app.terraform.io/sanjarbey/security-groups/aws"
  version         = "2.0.0"
  vpc_id          = aws_vpc.vpc.id
  security_groups = var.security-groups
}

resource "aws_iam_account_password_policy" "password_policy" {
  minimum_password_length      = 8
  hard_expiry                  = var.hard_expiry
  require_lowercase_characters = true
  require_numbers              = true
  require_uppercase_characters = true
  require_symbols              = true
  max_password_age             = var.max_password_age
  password_reuse_prevention    = var.password_reuse_prevention
}


resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon-linux2.id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.bastion_subnet.id
  vpc_security_group_ids      = [module.security-groups.security_group_id["bastion_sg"]]
  associate_public_ip_address = true
}

resource "aws_key_pair" "bastion_key_pair" {
  key_name   = "bastion-key"
  public_key = file("~/.ssh/cloud2024.pem.pub")
}

resource "aws_subnet" "bastion_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "54.0.254.0/24"
  availability_zone = "us-west-1a"
}

resource "aws_security_group_rule" "alb_web_to_web" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.security-groups.security_group_id["ALB_WEB_sg"]
  security_group_id = module.security-groups.security_group_id["WEB_EC2_sg"]  
}

resource "aws_security_group_rule" "to_alb_app" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.security-groups.security_group_id["WEB_EC2_sg"]
  security_group_id = module.security-groups.security_group_id["ALB_APP_sg"]
}

resource "aws_security_group_rule" "app_elb_to_web" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.security-groups.security_group_id["ALB_APP_sg"]
  security_group_id = module.security-groups.security_group_id["APP_EC2_sg"]
  
}

