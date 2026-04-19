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
aws configure
aws s3 ls
terraform -v
docker run hello-world
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

### 🔹 IAM

Used to control access in AWS. IAM user is safer than root because permissions can be limited.

### 🔹 Terraform

Infrastructure as Code tool used to create AWS resources like EC2, VPC using configuration files.

### 🔹 Docker

Used to package and run applications in containers for consistent environments.

---

## 🔐 AWS CLI Flow (Important)

When running `aws s3 ls`:

1. CLI reads credentials from ~/.aws/credentials
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


