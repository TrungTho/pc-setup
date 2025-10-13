# This is an AI-generated tf code, for TESTING PURPOSE ONLY
# THIS WILL PUBLIC YOUR VM TO THE INTERNET
# Please consider to use it with your own judgement

# --- 1. AWS Provider and Required Providers ---
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # Required for local key generation
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    # Required to save the private key file locally
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "platform-sandbox"
}

# --- 2. Variables ---
variable "region" {
  description = "The AWS region to deploy resources into."
  default     = "us-east-1" # Set your preferred region
}

variable "key_pair_name" {
  description = "The name for the new EC2 Key Pair."
  type        = string
  default     = "terraform-generated-key"
}

# --- 3. Key Pair Generation Resources ---

# 3a. Generate a new private key locally
resource "tls_private_key" "instance_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 3b. Register the public key with AWS
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.instance_key.public_key_openssh
}

# 3c. Save the private key to a local file
resource "local_file" "private_key" {
  content  = tls_private_key.instance_key.private_key_pem
  filename = "${var.key_pair_name}.pem"
  # Set permissions for security (Read/Write for owner only)
  file_permission = "0600"
}

# # --- 4. Data Source for latest Ubuntu AMI with SSM ---
# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners      = ["099720109477"]

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# --- 4. Data Source for latest Windows Server 2022 Base AMI ---
data "aws_ami" "windows_2022" {
  most_recent = true
  # Official AWS owner ID for Windows AMIs in most regions (Amazon)
  owners = ["801119661308"]

  filter {
    name = "name"
    # This pattern matches the standard, non-container, full Desktop Experience
    # Windows Server 2022 image.
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ----------------------------------------------------------------------------------

# --- 5. VPC and Networking Resources ---
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "My-Public-VPC" }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  # Set to false to avoid double public IP assignment (the EIP handles public IP)
  map_public_ip_on_launch = false
  tags                    = { Name = "Public-Subnet-1" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "Public-IGW" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = { Name = "Public-Route-Table" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_and_ssm_traffic"
  description = "Allow inbound SSH and all outbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "Allow-SSH" }
}

# ----------------------------------------------------------------------------------

# --- 7. IAM Role for SSM Access ---
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2_ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role" "ssm_role" {
  name = "ec2_ssm_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
    }],
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ----------------------------------------------------------------------------------

# --- 8. Elastic IP (EIP) for Static Public IP ---

# Allocate a static Elastic IP address
resource "aws_eip" "static_ip" {
  domain = "vpc"
  tags = {
    Name = "My-Static-Public-IP"
  }
}

# --- 9. EC2 Instance Creation ---
resource "aws_instance" "public_instance" {
  ami           = data.aws_ami.windows_2022.id
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.public.id

  # Use the GENERATED key pair name
  key_name = aws_key_pair.generated_key.key_name

  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Ensure the instance does NOT get a separate public IP address from the subnet settings,
  # as we are attaching a dedicated EIP.
  associate_public_ip_address = false

  root_block_device {
    volume_size           = 60
    volume_type           = "gp3"
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [
      associate_public_ip_address,
      # Also helpful to ignore these block attributes that often drift
      credit_specification,
    ]
  }

  tags = {
    Name = "Public-SSH-Static-IP-Instance"
  }
}

# --- 10. EIP Association: Link the STATIC IP to the instance ---
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.public_instance.id
  allocation_id = aws_eip.static_ip.id
}

# --- 11. Outputs ---
output "instance_public_ip" {
  description = "The STATIC Elastic IP address to use for SSH."
  value       = aws_eip.static_ip.public_ip
}

output "private_key_file" {
  description = "The name of the private key file saved locally. Use this with SSH -i."
  value       = local_file.private_key.filename
}

output "instance_id" {
  description = "The id of the created instance"
  value       = aws_instance.public_instance.id
}
