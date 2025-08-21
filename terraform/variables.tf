variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ssh_allowed_ip" {
  description = "Your IP for SSH access (use /32). Find your public IP at whatismyip.me"
  type        = string
  default     = "92.97.12.223/32" # change to your_ip/32 for security
}

variable "key_name" {
  description = "Existing AWS key pair name to use for EC2 (create one in AWS console or via CLI)"
  type        = string
  default     = ""
}


# Private subnets for RDS
variable "private_subnet1_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet2_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

# RDS settings (we'll pass username/password via tfvars, not commit)
variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" { type = string }

variable "db_password" { type = string }

