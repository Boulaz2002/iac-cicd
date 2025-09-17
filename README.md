# 🚀 Infrastructure as Code with Terraform & CI/CD

End-to-end **hybrid infrastructure automation** using **Terraform** and **GitHub Actions**, across **AWS cloud** and **on-premises environments** (e.g., VMware ESXi).

---

## ✨ Features
- Terraform modules for:
  - **Cloud:** VPC, EC2, IAM, S3, CloudWatch  
  - **On-Premises:** VMware ESXi VMs, local networking, storage
- **Remote state management** with S3 + DynamoDB
- CI/CD with **GitHub Actions** for `plan`/`apply`
- Secure IAM roles, policies, and credentials
- Cost-efficient, reproducible infra across **cloud + datacenter**
- Unified workflows for hybrid deployments

---

## 🛠 Tech Stack
- **Infra as Code:** Terraform  
- **Cloud:** AWS (EC2, VPC, IAM, S3, CloudWatch)  
- **On-Premises:** VMware ESXi, local servers  
- **CI/CD:** GitHub Actions (OIDC integration)  

---

## ⚙️ Setup

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply infra
terraform apply
