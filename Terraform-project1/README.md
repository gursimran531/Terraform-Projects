# My First Terraform Project: An AWS EC2 Web Server 🚀

Hey there! Welcome to my first real dive into the world of Terraform and AWS. This project is all about learning by doing. I've put together a script that automatically spins up a Linux EC2 web server on a brand-new, secure VPC.

It was a fantastic way to get my hands dirty with Infrastructure as Code (IaC) and figure out how all the pieces, like VPCs, subnets, and modules, fit together.

[![Terraform](https://img.shields.io/badge/Terraform-v1.2.0-623CE4?logo=terraform&logoColor=white)](https://developer.hashicorp.com/terraform/docs) [![AWS Provider](https://img.shields.io/badge/AWS%20Provider-v6.10-FF9900?logo=amazon-aws&logoColor=white)](https://registry.terraform.io/providers/hashicorp/aws/latest)

***

## ✅ What's Inside?

This isn't just any script; it's packed with some cool features:

* **Fresh Infrastructure:** Creates a completely new Virtual Private Cloud (VPC), so we don't mess with any existing setups.
* **Internet-Ready:** It automatically sets up a public subnet, an Internet Gateway, and all the necessary route tables so your server can actually connect to the internet.
* **Always the Latest OS:** The script is smart! It automatically finds and uses the most recent Amazon Linux 2 AMI, so you're always up-to-date.
* **You're in Control:** You can easily change the EC2 instance type (like `t2.micro` or something bigger) right when you run the script.
* **Clean & Tidy Code:** I've organized the EC2 instance part into its own module. It just feels cleaner that way!
* **Easy Access:** Once it's done, the script gives you the public IP address, so you can connect to your new web server right away.

***

## 📊 Architecture Diagram

<p align="center">
  <img src="./diagrams/Terraform_Project1.drawio.svg" alt="Week 1 Terraform AWS Project" width="500"/>
</p>

***

## 🛠️ Let's Get This Running

Ready to build some infrastructure? Here’s what you’ll need to do.

### Prerequisites

First, make sure you have these tools installed and ready to go:
1.  **Terraform:** If you don't have it, you can [install it from here](https://learn.hashicorp.com/tutorials/terraform/install-cli).
2.  **An AWS Account:** You'll need an account with permissions to create all the resources mentioned above.
3.  **AWS CLI Configured:** Make sure your credentials are set up. If not, just run `aws configure` in your terminal.

### Step-by-Step Guide

1.  **Clone This Project**
    ```bash
    # Clone the repository to your local machine
    git clone https://github.com/gursimran531/Terraform-Projects.git
    cd Terraform-project1
    ```

2.  **Initialize Terraform**
    This is a crucial first step. It tells Terraform to download the necessary plugins to talk to AWS.

    ```bash
    terraform init
    ```

3.  **Apply the Magic!**
    This is where the action happens. Terraform will show you everything it's about to create. You'll be asked to enter an instance type (try `t2.micro` if you're not sure). Just type `yes` to approve, and watch it go!

    <p align="center">
      <img src="./gif/terraform.gif" alt="TERRAFORM GIF" width="150"/>
    </p>


    ```bash
    terraform apply
    ```

***

## 🤔 My Challenges & Key Takeaways

Every project has its hurdles, and this one was no exception! Here are a couple of the biggest things I learned.

### Challenge 1: The Mystery of the Ever-Changing AMI

When I first started, I was stuck on how to pick the right Amazon Machine Image (AMI). Hardcoding an ID felt wrong because they get outdated so fast. After some digging, I found the perfect solution: a Terraform `data` source.

You can actually tell Terraform to **query AWS for the latest Amazon Linux 2 image**. By filtering by the owner (`amazon`) and using a wildcard in the name, it grabs the newest version every single time. No more outdated images!

```hcl
# This little block of code saves so much hassle!
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
```

### Challenge 2: AI Is Cool, But Docs Are King

My first instinct with any error was to just throw it into an AI chatbot. And while AI is an amazing tool for getting ideas, I quickly realized it sometimes gave me code for older versions of the AWS provider. This just led to more confusion and more errors.

The big "aha!" moment was when I started cross-referencing everything with the **official Terraform Registry documentation**. The docs are always up-to-date and have the final say on how a resource should be configured.

**My new motto:** Use AI for brainstorming, but always trust the official docs as the ultimate source of truth.

***

## 📁 Project Structure

Here’s a quick look at how the files are organized:

```text
├── main.tf          # The heart of the project: VPC, Subnet, IGW, etc.
├── variables.tf     # Where we define inputs like the instance_type.
├── outputs.tf       # Defines what info we get back, like the public_ip.
└── modules
└── ec2          # The neat little module for our EC2 instance.
├── main.tf
├── variables.tf
└── outputs.tf
```

***

## ⚙️ Inputs & Outputs

### Inputs  

| Name               | Description                                           | Type     | Default      |
| ------------------ | ----------------------------------------------------- | -------- | ------------ |
| `instance_type`    | Specify instance type for EC2 instance.               | `string` | `t2.micro`   |
| `vpc_cidr_block`   | Specify the CIDR block to be used for the VPC.        | `string` | `10.0.0.0/16` |
| `subnet_cidr_block`| Specify the CIDR block to be associated with Subnet.  | `string` | `10.0.1.0/24` |
| `subnet_id`        | Subnet ID to be associated with EC2 instance.         | `string` | —            |
| `vpc_id`           | VPC ID to be associated with EC2 instance.            | `string` | —            |
| `key_name`         | SSH key pair ID for EC2 Instance.                     | `string` | —            |

---

### Outputs  

| Name             | Description                                                             |
| ---------------- | ----------------------------------------------------------------------- |
| `public_ip`      | The public IP address of the EC2 instance of the module EC2.            |
| `ec2_instance_id`| The ID of the EC2 instance.                                             |
| `ec2_public_ip`  | The public IP address of the EC2 instance at the time of creation.      |


***

## 🧹 Time to Clean Up

Don't forget this last step! To avoid any surprise bills from AWS, make sure you destroy all the resources you created when you're finished.

```bash
terraform destroy
