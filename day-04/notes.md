# Day 4 — April 22

## 🎯 Goal

Understand Infrastructure as Code (IaC) using Terraform by creating, managing, and destroying an EC2 instance without using AWS Console.

---

## ✅ What I Did

* Set up Terraform project structure
* Wrote Terraform configuration to create EC2
* Fixed multiple real-world errors (provider, region, disk space)
* Successfully created EC2 using Terraform
* Attempted SSH (failed intentionally due to missing config)
* Destroyed infrastructure using Terraform

---

## 🧱 Project Setup

```bash
cd devops-journey-30days
mkdir day-04
cd day-04
touch main.tf
```

---

## 💻 Terraform Code

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "devops_server" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-server"
  }
}
```

---

## 🧠 Concept Breakdown

### 🔹 Provider

Defines cloud platform and region.

```hcl
provider "aws" {
  region = "us-east-1"
}
```

👉 Terraform uses AWS APIs via this

---

### 🔹 Resource

Defines what infrastructure to create.

```hcl
resource "aws_instance" "devops_server"
```

* `aws_instance` → EC2
* `devops_server` → Terraform internal name

---

### 🔹 AMI

Specifies OS image for EC2.

👉 Must match region
👉 Copied from existing EC2 instance

---

### 🔹 Instance Type

Defines compute size.

```text
t2.micro = free tier
```

---

### 🔹 Tags

Used for naming and identification in AWS Console.

---

## ⚙️ Commands Used

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

---

## 🔄 Terraform Workflow

```text
1. Write code (main.tf)
2. terraform init → setup provider
3. terraform plan → preview changes
4. terraform apply → create resources
5. terraform destroy → delete resources
```

---

## 💣 Key Concept: Terraform = Desired State

```text
You describe what you want → Terraform makes it real
```

Not scripting. Not step-by-step.

---

## 📂 Terraform State

File:

```text
terraform.tfstate
```

Tracks:

* What Terraform created
* Current infrastructure state

---

## ❌ Errors Faced & Fixes

---

### 🔴 Error 1: Wrong Provider (`aws-instance`)

```text
provider hashicorp/aws-instance not found
```

#### Cause:

Incorrect naming

#### Fix:

Use:

```text
aws_instance (resource)
aws (provider)
```

---

### 🔴 Error 2: No Space Left on Device

```text
no space left on device
```

#### Cause:

Terraform provider download needs disk space

#### Fix:

```bash
rm -rf .terraform
brew cleanup
```

---

### 🔴 Error 3: Invalid Region

```text
invalid AWS Region: us-east-01
```

#### Cause:

Typo

#### Fix:

```text
us-east-1
```

---

### 🔴 Error 4: SSH Timeout

```text
Connection timed out
```

#### Cause:

* No security group defined
* No port 22 access
* No key pair attached

#### Insight:

```text
Infra created ≠ usable infra
```

---

## 🔍 Networking Understanding

```text
SSH → Internet → AWS → ❌ blocked (no SG rule)
```

Failure occurred before reaching EC2

---

## 🧠 Key Learnings

* Terraform reads `.tf` files, not “runs” them
* Infrastructure is declared, not scripted
* Region and AMI must match
* State file is critical for tracking infra
* Creating infra is easy; making it usable requires configuration
* Missing security group = network-level failure
* Missing key pair = authentication failure

---

## 🔁 Lifecycle Management

```bash
terraform apply   → create infra
terraform destroy → delete infra
```

👉 Always clean up to avoid cost

---

## 💡 Mental Model

```text
Code (main.tf) → Terraform → AWS API → EC2 created
             ↓
       terraform.tfstate
```

---

## 📈 Self Evaluation

Understanding: X/10
Confidence: X/10

---

## ⚠️ What Needs Improvement

* Need to automate SSH access
* Need to define security groups via Terraform
* Need to auto-install applications (nginx)

---

## 🚀 Next Step (Day 5)

* Add key pair in Terraform
* Add security group (port 22 + 80)
* Auto install nginx using user_data
* Fully usable server via Terraform

## 📅 Day 04 – Terraform + Git Mistake (Real DevOps Learning)

### 🚨 Problem Faced

While pushing code to GitHub, I encountered this error:

```
File terraform-provider-aws_v6.42.0_x5 is 862 MB
This exceeds GitHub's file size limit of 100 MB
```

---

### 🔍 Root Cause

Terraform automatically created:

```
.terraform/providers/...
```

This directory contains:

* Provider binaries (compiled files)
* OS-specific dependencies
* Large files (hundreds of MB)

👉 These should **NEVER be committed to Git**

---

### ❌ Mistake

I accidentally committed:

```
day-04/.terraform/providers/.../terraform-provider-aws
```

Which caused:

* GitHub push rejection
* Repository corruption risk
* Poor DevOps practice

---

### ✅ Solution (Step-by-Step)

#### 1. Identify the large file

```
git rev-list --objects --all | grep terraform-provider
```

---

#### 2. Remove file from Git history

```
git filter-repo --path day-04/.terraform --invert-paths
```

---

#### 3. Force push cleaned repo

```
git push origin main --force
```

---

### 🛡️ Prevention (.gitignore)

Added:

```
.terraform/
*.tfstate
*.tfstate.backup
```

---

### 🧠 Key Learnings

* `.terraform/` is a **generated directory**, not source code
* Never commit:

  * Terraform providers
  * State files
  * binaries
* Git history matters — deleting a file is not enough
* Use tools like `git filter-repo` to clean history

---

### 💡 DevOps Best Practice

Always check before pushing:

```
git status
git diff --staged
```

---

### 🔥 Real-World Insight

This is a common mistake in DevOps projects.

👉 Fixing it properly demonstrates:

* Git expertise
* Infrastructure awareness
* Production-level thinking

---

### 🚀 Improvement for Future

* Set up `.gitignore` before starting Terraform
* Use clean repo structure
* Validate commits before push

---

