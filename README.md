
---

## 📂 Project 2: Infrastructure as Code with Terraform & CI/CD
`iac-cicd/README.md`

```markdown
# Infrastructure as Code with Terraform & CI/CD  

End-to-end **AWS infrastructure automation** using **Terraform** and **GitHub Actions**.  

---

## 🚀 Features
- Terraform modules for **VPC, EC2, IAM, S3**  
- **Remote state management** (S3 + DynamoDB)  
- CI/CD with **GitHub Actions** for plan/apply  
- Secure IAM roles & policies  
- Cost-efficient, reproducible infra  

---

## 🛠 Tech Stack
- **Infra as Code:** Terraform  
- **Cloud:** AWS (EC2, VPC, IAM, S3, CloudWatch)  
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
