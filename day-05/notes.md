🧠 INTERVIEW ANSWER (IMPORTANT)

If asked:

👉 “What does terraform plan do?”

Answer:

It generates an execution plan by comparing the desired configuration with the current state and shows what changes Terraform will perform before applying them.

💣 IMPORTANT LESSON
Always know WHERE you are executing commands

Local machine ≠ Server

# Day 5 — April 23

## 🎯 Goal

Provision a fully usable EC2 instance using Terraform with:

* SSH access
* Security group configuration
* Automated nginx installation
* Public web access

---

## ✅ What I Built

Using Terraform, I created:

```text
Terraform → AWS → EC2
                 → Key Pair (SSH access)
                 → Security Group (ports 22, 80)
                 → user_data (auto install nginx)
```

Result:

* SSH access working
* Nginx installed automatically
* Website accessible via browser

---

## 🧱 Terraform Configuration (Key Components)

### 🔹 Provider

```hcl
provider "aws" {
  region = "us-east-1"
}
```

---

### 🔹 Key Pair

```hcl
resource "aws_key_pair" "devops_key" {
  key_name   = "devops-key-day5"
  public_key = file("~/.ssh/devops/devops-key.pub")
}
```

👉 Enables SSH authentication

---

### 🔹 Security Group

```hcl
resource "aws_security_group" "devops_sg" {
  name = "devops-sg"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

👉 Acts as firewall

---

### 🔹 EC2 Instance + user_data

```hcl
resource "aws_instance" "devops_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.devops_key.key_name
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  user_data = <<-EOF
#!/bin/bash
apt update -y
apt install nginx -y
systemctl start nginx
systemctl enable nginx
EOF

  tags = {
    Name = "devops-server-day5"
  }
}
```

---

## ⚙️ Commands Used

```bash
terraform init
terraform plan
terraform apply
terraform destroy

ssh -i ~/.ssh/devops/devops-key.pem ubuntu@<IP>

sudo systemctl status nginx
sudo ss -tuln | grep 80
curl localhost
```

---

## 🔍 Debugging Journey (IMPORTANT)

---

### ❌ Error 1 — Duplicate Key Pair

```text
InvalidKeyPair.Duplicate
```

#### Cause:

Key already existed in AWS

#### Fix:

* Renamed key OR reused existing key

---

### ❌ Error 2 — user_data Syntax Error

```text
Invalid expression / Invalid block definition
```

#### Cause:

Improper heredoc formatting

#### Fix:

```hcl
user_data = <<-EOF
#!/bin/bash
...
EOF
```

---

### ❌ Error 3 — Ran Commands on Local Machine

#### Cause:

Forgot to SSH into EC2

#### Fix:

* Always check environment using `hostname`

---

### ❌ Error 4 — netstat Not Found

```text
command not found
```

#### Cause:

Modern Linux doesn’t include netstat

#### Fix:

```bash
sudo ss -tuln
```

---

### ❌ Error 5 — curl localhost failed initially

#### Root Cause:

user_data script didn’t execute correctly

---

### ❌ Error 6 — Browser not working

#### Root Cause:

Security group issue (port 80 not allowed)

---

## 🧠 Debugging Framework Used

```text
1. SSH works?
2. Service running?
3. Port open?
4. Local curl works?
5. External access works?
```

---

## 🌐 Request Flow

```text
Browser
  ↓
Internet
  ↓
Security Group
  ↓
EC2 Instance
  ↓
Port 80
  ↓
Nginx
  ↓
Response
```

---

## 💣 Key Learnings

* Terraform can create infra but usability requires proper config
* Security group controls external access
* user_data automates server setup
* Internal success + external failure = network issue
* OS matters (Ubuntu uses apt, Amazon Linux uses yum)
* Always verify execution environment (local vs remote)

---

## 🔁 Lifecycle Management

```bash
terraform apply   → create infra
terraform destroy → delete infra
```

---

## 🧠 Concepts Mastered

* Infrastructure as Code (IaC)
* SSH authentication using key pairs
* Security groups (firewall rules)
* Bootstrapping using user_data
* Layered debugging

---

# 🎤 INTERVIEW QUESTIONS (VERY IMPORTANT)

---

## 🔹 Q1: What is user_data?

👉 Script that runs automatically when EC2 instance boots

---

## 🔹 Q2: Why was your EC2 not accessible initially?

👉 Missing security group rules and key pair configuration

---

## 🔹 Q3: Difference between .pem and .pub?

👉 .pem = private key (used for SSH)
👉 .pub = public key (stored in AWS)

---

## 🔹 Q4: Why did curl localhost work but browser didn’t?

👉 Internal traffic worked, but external traffic was blocked by security group

---

## 🔹 Q5: What does Terraform plan do?

👉 Shows execution plan before applying changes

---

## 🔹 Q6: Why is Terraform state important?

👉 Tracks infrastructure created by Terraform

---

## 🔹 Q7: How does SSH authentication work?

👉 AWS stores public key → user connects using private key → keys match → access granted

---

## 🔹 Q8: What happens if port 80 is not open?

👉 Web traffic cannot reach server

---

## 🔹 Q9: How does Terraform know resource dependencies?

👉 Implicit references (e.g., security group ID used in EC2)

---

## 🔹 Q10: What is the difference between internal and external traffic?

👉 Internal = within EC2 (localhost)
👉 External = from internet via security group

---

## ⚠️ Improvements Needed

* Write reusable Terraform modules
* Use variables instead of hardcoding
* Improve debugging speed

---

## 🚀 Next Step (Day 6)

* variables.tf
* outputs.tf
* modular Terraform code
* cleaner architecture
