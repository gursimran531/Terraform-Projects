
# 🌍 Terraform Projects Portfolio  

<p align="center">
  <img src="./Terraform-2tier-Infra/pictures/Terraform-AWS.avif" alt="Terraform AWS Projects" width="600"/>
</p>

Welcome to my **Terraform Projects** repository 🚀.  
This repo is a collection of Infrastructure as Code (IaC) projects I’ve built using **Terraform on AWS**.  

Each project demonstrates progressively more complex **cloud infrastructure concepts** — starting from a single EC2 instance, moving up to secure VPC networking, and eventually multi-tier production-like architectures.  

---

## 📌 Projects Overview  

### 1️⃣ [Project 1 – Basic EC2 Instance](./Terraform-project1/)  
- **Goal:** Provision an EC2 instance in the default VPC.  
- **Concepts Covered:**  
  - Terraform basics (providers, resources, variables, outputs)  
  - EC2 provisioning with tagging  
  - Using modules for clean structure  

---

### 2️⃣ [Project 2 – Secure 2-Tier Infrastructure](./Terraform-2tier-Infra/)  
- **Goal:** Design a secure VPC with private/public subnets, NAT gateway, and a bastion host.  
- **Concepts Covered:**  
  - Custom VPC, subnets, route tables  
  - Internet Gateway + NAT Gateway for private subnet access  
  - Bastion host in public subnet for secure SSH access  
  - App server in private subnet (reachable via Bastion only)  
  - Dynamic tagging, variable validation, best practices  

---

### 🔜 Project 3 – Advanced 3-Tier Architecture (Coming Soon)  
- **Goal:** Build a production-style infra with load balancer, auto-scaling EC2s, and RDS database.  
- **Concepts to be Covered:**  
  - Application Load Balancer in public subnet  
  - Auto-scaling group for app servers in private subnet  
  - RDS database in isolated subnet  
  - More advanced modules and reusability  

---

## 🛠️ Tech Stack  
- **Terraform** (Infrastructure as Code)  
- **AWS** (EC2, VPC, Subnets, IGW, NAT, SG, etc.)  
- **Git/GitHub** (Version control & portfolio hosting)  

---

## 📖 How to Use  
1. Clone the repo:  
   ```bash
   git clone https://github.com/gursimran531/Terraform-Projects.git
   cd Terraform-Projects
   ```  
2. Navigate into a project folder (e.g., Project 2).  
3. Initialize and apply:  
   ```bash
   terraform init
   terraform apply
   ```  

---

## 📌 Notes  
- All projects are built for **learning and portfolio purposes**.  
- They follow **Terraform best practices** (modules, variables, outputs, tagging).  
- Security group rules are configured with safe defaults (SSH restricted to my IP).  

---

## 🌟 Author  
👤 **Gursimran Singh**  
- Cloud Engineer | Terraform | AWS | DevOps Enthusiast  
