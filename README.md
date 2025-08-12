“This project deploys a 2-tier application (web + database) on AWS using Terraform and AWS free tier resources.”

# AWS Two-Tier App Terraform Deployment

## Project Overview
This project uses Terraform to deploy a two-tier architecture on AWS:
- An EC2 instance running **Nginx** as a web server.
- Security groups configured to allow SSH and HTTP access.
- Terraform manages all the infrastructure as code for easy repeatability.

## Prerequisites
- AWS account with appropriate permissions.
- Terraform installed (version X.X.X).
- AWS CLI configured (optional but recommended).
- EC2 key pair for SSH access (e.g., `terraform-key-mumbai.pem`).
- Your public IP whitelisted for SSH access in security group.

## How to Run

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/aws_two_tier_app.git
   cd aws_two_tier_app/terraform

2. Replace variables in variables.tf or use terraform.tfvars file:

. key_name = your EC2 key pair name

. ssh_allowed_ip = your current public IP (get it from whatismyip)

3. Initialize Terraform:

bash

terraform init

4. Apply Terraform configuration:

bash

terraform apply
Confirm by typing yes.

5. Once apply is done, note the public IP output.

Open your browser and visit:

cpp

http://<your-ec2-public-ip>
You should see the Nginx welcome page.

Screenshots

Screenshot of the Nginx default page served by the EC2 instance.

`![Nginx Welcome Page](./terraform/nginx-welcome.png)

Cleanup
To destroy all resources and avoid billing:

bash

terraform destroy
Type yes to confirm.

Destroy complete! Resources: 7 destroyed.


Notes
Make sure your .pem key file permissions are secure.

This Terraform code is for learning/demo purpose — do not use in production without security review.

Author
Sathya Pillai Sudalai
GitHub: https://github.com/PillaiSathya


