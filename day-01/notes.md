# Day 1 - April 19


## 🎯 Goal

Set up DevOps environment and understand core tools (AWS CLI, IAM, Terraform, Docker).

---

## ✅ What I Did

* Created GitHub repo: devops-journey-30days
* Installed AWS CLI, Terraform, Docker Desktop
* Created IAM user (devops-user)
* Configured AWS CLI using `aws configure`
* Verified AWS connection using `aws s3 ls`
* Fixed Docker issue (daemon not running)

---

## 💻 Commands Used

```bash
aws configure - Store creds locally. ~/.aws/credentials and ~/.aws/config
aws s3 ls - If it returns empty or list of S3 buckets, it's good and set
terraform -v
docker run hello-world - CLI sends request to Docker Deamon and it pulls image from internet to run the container and prints output.
mkdir day-01
touch notes.md
```

---

## ❌ Errors Faced + Fixes

### Error:

Docker command failed with:
"cannot connect to docker daemon"

### Root Cause:

Docker CLI was installed but Docker daemon was not running because Docker Desktop was not installed.

### Fix:

Installed Docker Desktop and started it.

### Learning:

Docker CLI and Docker daemon are separate. CLI communicates with daemon via docker.sock.

---

## 🧠 Key Concepts

### 🔹 AWS CLI

Tool to interact with AWS using terminal. It sends API requests to AWS services using credentials.
Why do we use CLI? Becasue we automate things, integrate with scripts, and using it in CI/CD

### 🔹 IAM

Used to control access in AWS. IAM user is safer than root because permissions can be limited.

### 🔹 Terraform

Tool to provision or create infrastructure using Code. Used to create AWS resources like EC2, VPC using configuration files.
Why we use Terraform rather creating infra manually? - Because companies want repeatable set ups, version controlled infra, and no manual mistakes.

### 🔹 Docker

Used to package and run applications in containers for consistent environments.

---

## 🔐 AWS CLI Flow (Important)

When running `aws s3 ls`:

1. CLI reads credentials from ~/.aws/credentials to authenticate user.
2. Signs request using secret key (SigV4)
3. Sends request to S3 service
4. AWS validates and returns response

---

## 🔒 Security Understanding

* Root account should not be used because it has full access
* If access key is leaked:

  * Attacker can create/delete resources
  * Immediate action:

    * Delete/disable key
    * Rotate credentials
    * Check logs (CloudTrail)

---

## 🐳 Docker Understanding

* Docker CLI sends commands
* Docker daemon executes them
* Communication happens via `/var/run/docker.sock`
* On Mac, daemon runs via Docker Desktop

---

## 🔗 Big Picture Flow

AWS CLI → Access AWS
Terraform → Create infrastructure
SSH → Connect to server
Docker → Run application

---

## Github commands to create and push repo
git init 
git add .
git commit -m 
Create repo
Connect local -> github
git remote add origin
git branch -m main
git push -u origin main

---

## Workflow - 3 layers

Layer 1 - Set up AWS account and access (Becasue without access, you won't be able to create anything)
IAM and AWS CLI

Layer 2 - Create infrastructure using Terraform
command: terraform apply (creates server in AWS)

Layer 3 - Application in Docker for consistent environment

---

## Connection flow - How this workflow works in BTS

Terraform creates EC2 -> SSH - Connects to EC2 -> Install docker on EC2 -> Run container on EC2 -> Access app via browser

---

## ? How do you deploy an app in AWS ?

Answer it. 



