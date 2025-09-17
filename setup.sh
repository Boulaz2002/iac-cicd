#!/usr/bin/env bash
set -euo pipefail

echo "📦 Setting up IaC + CI/CD project structure..."

# --- directories ---
mkdir -p infra .github/workflows
touch README.md

# --- .gitignore ---
cat > .gitignore <<'EOF'
# Python
__pycache__/
*.pyc
*.pyo
*.pyd
*.db

# Virtual env
venv/
.venv/

# Environment files
.env
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl

# Docker
*.log
*.pid
*.sock
node_modules/
dist/
build/

# IDE
.vscode/
.idea/
EOF

# --- .env.example ---
cat > .env.example <<'EOF'
# FastAPI
ENV=dev
PORT=8000

# Database
POSTGRES_USER=backup_user
POSTGRES_PASSWORD=backup_pass
POSTGRES_DB=backup_db
POSTGRES_HOST=backup_db
POSTGRES_PORT=5432

# AWS
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_DEFAULT_REGION=us-east-1
AWS_S3_BUCKET=backup-dashboard-dev

# ESXi
ESXI_HOST=192.168.1.100
ESXI_USER=root
ESXI_PASS=yourpassword
ESXI_DATASTORE=datastore1
EOF

# --- Terraform: provider.tf ---
cat > infra/provider.tf <<'EOF'
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
EOF

# --- Terraform: main.tf ---
cat > infra/main.tf <<'EOF'
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "backup-dashboard-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "backup-dashboard-subnet" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "backup_api" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = { Name = "backup-dashboard-api" }
}

resource "aws_s3_bucket" "backup" {
  bucket        = "backup-dashboard-${var.env}"
  force_destroy = true
}
EOF

# --- Terraform: variables.tf ---
cat > infra/variables.tf <<'EOF'
variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "default"
}

variable "env" {
  default = "dev"
}
EOF

# --- Terraform: outputs.tf ---
cat > infra/outputs.tf <<'EOF'
output "ec2_public_ip" {
  value = aws_instance.backup_api.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.backup.bucket
}
EOF

# --- GitHub Actions Workflow ---
cat > .github/workflows/terraform.yml <<'EOF'
name: Terraform Deploy

on:
  push:
    paths:
      - 'infra/**'
      - '.github/workflows/terraform.yml'
  workflow_dispatch:

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Terraform Init
        run: terraform -chdir=infra init

      - name: Terraform Plan
        run: terraform -chdir=infra plan

      - name: Terraform Apply
        run: terraform -chdir=infra apply -auto-approve
EOF

echo "✅ Project scaffolding complete!"

