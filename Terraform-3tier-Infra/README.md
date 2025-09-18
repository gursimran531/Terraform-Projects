
# Terraform Three-Tier Infrastructure: Scalable AWS Architecture 🏗️

Welcome to my latest Terraform project! This time, I’ve gone beyond the basics and built a **three-tier architecture** on AWS—exactly how production-grade systems are designed. With a dedicated public layer, application layer, and data layer, this project reflects how modern cloud-native applications are deployed securely and at scale.

This project also highlights how combining **AI-driven brainstorming** with **official documentation** became my biggest win in navigating challenges and making this infrastructure production-ready.

[![Terraform](https://img.shields.io/badge/Terraform-v1.5+-623CE4?logo=terraform&logoColor=white)](https://developer.hashicorp.com/terraform/docs) [![AWS Provider](https://img.shields.io/badge/AWS%20Provider-v6.10-FF9900?logo=amazon-aws&logoColor=white)](https://registry.terraform.io/providers/hashicorp/aws/latest)

***

## ✅ What's Inside?

This is not just another Terraform project—it’s a **multi-tier, scalable architecture** designed with real-world patterns:

* **🌐 Custom VPC with Multi-AZ Support:** Isolated networking with public, private-app, and private-db subnets
* **🚪 NAT Gateway:** One per AZ for high availability and secure outbound access from private subnets
* **🖥️ Application Load Balancer (ALB):** Internet-facing entry point in public subnets
* **📦 Auto Scaling Group:** Multiple EC2 instances in private subnets, bootstrapped with Nginx
* **🗄️ RDS Database (Multi-AZ):** A production-ready data layer isolated in DB subnets
* **🔐 Security Groups:** Layered security—ALB only accepts Internet traffic, app only accepts from ALB, DB only accepts from app
* **⚙️ GitHub Actions CI/CD:** Automated Terraform plan/apply pipelines
* **📊 Monitoring:** CloudWatch alarms, logs, and metrics for observability
* **🧩 Modular Design:** Separate modules for VPC, ALB, ASG, RDS, and monitoring
* **🎯 Multi-Environment Ready:** `dev/`, `stage/`, and `prod/` environments with separate state files

***

## 📊 Architecture Diagram

<p align="center">
  <img src="./diagrams/Terraform-3tier.drawio.svg" alt="Three-Tier Terraform AWS Architecture" width="600"/>
</p>

***

## 🛠️ Let's Get This Running

### Prerequisites

1. **Terraform:** [Install here](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. **AWS Account:** Permissions for VPC, EC2, RDS, ALB, NAT, IAM
3. **AWS CLI Configured:** `aws configure` with valid credentials
4. **Terraform Cloud or S3 Backend:** For remote state and locking
5. **GitHub Secrets Configured:** AWS credentials or Terraform Cloud token

### Step-by-Step Guide

1. **Clone the Repo**
   ```bash
   git clone <your-repo-url>
   cd Terraform-3tier-Infra/environments/dev
   ```

2. **Configure Variables**
   ```bash
   cp dev.tfvars.example dev.tfvars
   # Edit with your values (key pair, db password, instance sizes, etc.)
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Plan Deployment**
   ```bash
   terraform plan -var-file="dev.tfvars"
   ```

5. **Apply Deployment**
   ```bash
   terraform apply -var-file="dev.tfvars"
   ```

6. **Access Your App**
   - Get your fully working domain name from Route 53 (see Terraform outputs).
   - Visit the domain in your browser to see your Nginx-powered app running securely!

***

## 🤔 My Challenges & Key Takeaways  

This project wasn’t just about writing Terraform—it was about **debugging like a real cloud engineer**. Here are the key challenges I faced and how I solved them:  

### Challenge 1: Private Instances + User Data Scripts Not Working 😵  
My private EC2 instances were launching, but the user data scripts weren’t installing anything. At first, I thought Terraform was broken, but the real issue was **no internet + blocked outbound traffic**.  

✅ **Solution:** Fixed the **NAT Gateway routing** so private instances had internet, then debugged using `/var/log/cloud-init-output.log`. Finally realized my **security group was blocking outbound**, and once that was fixed, everything ran smoothly.  

### Challenge 2: Terratest Errors That Made No Sense 🤯  
Running Terratest gave me confusing errors like `declared and not used: body` and `invalid character 'c' looking for beginning of value`. I assumed my infra was failing, but the issue was actually my **Go test code + output parsing**.  

✅ **Solution:** I updated my Go test to handle plain string outputs correctly (like a domain name instead of JSON). After that, tests could deploy, validate the website, and cleanly destroy the infra without issues.  

### Challenge 3: AI + Docs = The Real MVPs 🤝  
I’ve said this in past projects too (multiple times lolz), but it stood out again here: **AI is amazing for quick answers and debugging**, but the **docs are the only place to confirm the truth**.  

✅ **Solution:** My approach was to use **AI for speed** and **docs for accuracy**. Together, this combo saved me hours and gave me confidence that I wasn’t building something on shaky ground.  

---

### 🔐 Major Step : Secrets Management 
Migrating secrets to HashiCorp Cloud Platform (HCP) variables was a huge leap for production security! No more hardcoded secrets—now everything is managed securely out of source control, which is key for real-world deployments. I securely stored my AWS credentials and DB password in HCP as secrets, ensuring these sensitive values are never exposed in code or configuration files. Using HCP for secrets management dramatically increases security for this project.

***


## 🧰 Extra Tooling I Used  

This wasn’t just plain Terraform—I made sure to improve quality and maintainability with extra tooling:  

- **📖 terraform-docs:** Automatically generated input/output tables so the project is well-documented and easy to onboard.  
- **🔎 TFLint:** Caught common mistakes and enforced AWS/Terraform best practices before applying code.  
- **✅ Terratest:** Verified deployments by actually spinning up infra, testing it, and then destroying it safely.  

These tools made the project feel more like **real production engineering** rather than just a student exercise.  

## 📁 Project Structure

```text
Terraform-3tier-Infra/
├── ci
│   └── github-actions
│       └── terraform.yml
├── environments
│   ├── dev
│   │   ├── dev.auto.tfvars
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── provider.tf
│   │   ├── scripts
│   │   │   └── nginx-cw.sh
│   │   └── variables.tf
│   ├── prod
│   └── stage
├── modules
│   ├── alb
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── asg_app
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── dns
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── monitoring
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── rds
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── test
│   │   └── test
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── tests
    ├── integration
    │   └── main_test.go
    └── unit
        ├── .tflint.hcl
        └── validate.sh
```

***

## ⚙️ Inputs & Outputs

### Root Module Inputs


| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_subnets"></a> [app\_subnets](#input\_app\_subnets) | The CIDR block and AZs for the app subnets | `map(string)` | <pre>{<br/>  "us-east-1a": "10.0.4.0/24",<br/>  "us-east-1b": "10.0.5.0/24"<br/>}</pre> | no |
| <a name="input_asg_instance_type"></a> [asg\_instance\_type](#input\_asg\_instance\_type) | The instance type for the EC2 instances | `string` | `"t2.micro"` | no |
| <a name="input_awsregion"></a> [awsregion](#input\_awsregion) | The AWS region to deploy resources in | `string` | `"us-east-1"` | no |
| <a name="input_create_dns_zone"></a> [create\_dns\_zone](#input\_create\_dns\_zone) | Specify to create DNS zone (true or false) | `bool` | `false` | no |
| <a name="input_create_rds"></a> [create\_rds](#input\_create\_rds) | Specify to create RDS (true or false) | `bool` | `false` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the database | `string` | `"mydb"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | The master password for the database | `string` | n/a | yes |
| <a name="input_db_subnets"></a> [db\_subnets](#input\_db\_subnets) | The CIDR block and AZs for the db subnets | `map(string)` | <pre>{<br/>  "us-east-1a": "10.0.6.0/24",<br/>  "us-east-1b": "10.0.7.0/24"<br/>}</pre> | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | The master username for the database | `string` | `"admin"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain name for the Route 53 zone | `string` | `"techscholarrentals.click"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for the deployment | `string` | `"dev"` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The AMI ID for the EC2 instances | `string` | `""` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Whether to create a Multi-AZ RDS instance | `bool` | `true` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | The CIDR block and AZs for the public subnets | `map(string)` | <pre>{<br/>  "us-east-1a": "10.0.1.0/24",<br/>  "us-east-1b": "10.0.2.0/24"<br/>}</pre> | no |
| <a name="input_rds_instance_type"></a> [rds\_instance\_type](#input\_rds\_instance\_type) | The instance type for the RDS instance | `string` | `"db.t3.micro"` | no |
| <a name="input_user_data_file"></a> [user\_data\_file](#input\_user\_data\_file) | Path to the user data script file | `string` | `"./scripts/nginx-cw.sh"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |

### Root Module Outputs

| Name | Description |
|------|-------------|
| <a name="output_Domain_Website"></a> [Domain\_Website](#output\_Domain\_Website) | The domain name for the website |
| <a name="output_alb_website"></a> [alb\_website](#output\_alb\_website) | The DNS name of the ALB |
| <a name="output_cw_log_group"></a> [cw\_log\_group](#output\_cw\_log\_group) | The name of the CloudWatch log group |
| <a name="output_iam_profile"></a> [iam\_profile](#output\_iam\_profile) | The ARN of the IAM instance profile |
| <a name="output_rds_endpoint"></a> [rds\_endpoint](#output\_rds\_endpoint) | The endpoint of the RDS instance |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | The name of the S3 bucket for monitoring |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |

***

## 🔒 Security Features

- 🔒 Least Privilege Security Groups
- 🛡️ NAT Gateway isolation per AZ
- 🚨 No direct Internet exposure for app servers
- 💾 Encrypted RDS storage
- 🧑‍💻 IAM roles instead of hardcoded credentials
- ☁️ Terraform Cloud or S3 backend with locking

***

## 🧹 Time to Clean Up

To avoid charges, always destroy your infrastructure when done:

```bash
terraform destroy
```

***
