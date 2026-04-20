# Day 2 — April 20

## 🎯 Goal

Understand how to create and access a real server (EC2), deploy a web server (Nginx), and expose it to the internet.

---

## ✅ What I Did

* Launched EC2 instance (Ubuntu, t2.micro)
* Created and used SSH key (`.pem`) for secure login
* Connected to EC2 using SSH
* Installed Nginx web server
* Accessed server via browser using public IP
* Modified default web page
* Stopped instance safely to save cost

---

## 🧱 Step-by-Step Workflow

1. Created EC2 instance from AWS Console
2. Generated key pair (`devops-key.pem`)
3. Connected using SSH:

   ```bash
   ssh -i ~/.ssh/devops/devops-key.pem ubuntu@<PUBLIC_IP>
   ```
4. Installed Nginx:

   ```bash
   sudo apt update
   sudo apt install nginx -y
   ```
5. Started Nginx:

   ```bash
   sudo systemctl start nginx
   ```
6. Verified in browser:

   ```
   http://<PUBLIC_IP>
   ```

---

## 💻 Commands Used

```bash
ssh -i ~/.ssh/devops/devops-key.pem ubuntu@<IP>
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl status nginx
curl localhost
curl http://<PUBLIC_IP>
sudo nano /var/www/html/index.nginx-debian.html
chmod 400 devops-key.pem
```

---

## ❌ Errors Faced + Fixes

### 🔴 Error 1: Wrong file path for `.pem`

* Error: "No such file or directory"
* Cause: Running command from wrong directory
* Fix: Used full path:

  ```bash
  ~/.ssh/devops/devops-key.pem
  ```

---

### 🔴 Error 2: Running commands on Mac instead of EC2

* Error: Java runtime error when running `apt`
* Cause: Command executed on local machine
* Fix: SSH into EC2 before running commands

---

### 🔴 Error 3: netstat / ss not found

* Cause: Minimal Ubuntu image
* Fix:

  ```bash
  sudo apt install net-tools -y
  ```

---

### 🔴 Error 4: SSH authenticity prompt

* Cause: First-time connection
* Fix: Typed `yes` to trust host

---

## 🧠 Key Concepts

---

### 🔹 What is EC2?

A virtual server in AWS that runs Linux/Windows and can host applications.

---

### 🔹 What is SSH?

Secure Shell protocol used to remotely access and control a server.

* Encrypted connection
* Executes commands on remote machine

---

### 🔹 What is Nginx?

A web server that:

* Listens on port 80
* Serves web pages to users

---

### 🔹 What is Public IP?

Address used to access EC2 from the internet.

---

### 🔹 What is Security Group?

Acts like a firewall:

* Controls incoming/outgoing traffic
* Port 80 → allows HTTP
* Port 22 → allows SSH

---

## 🌐 Request Flow (VERY IMPORTANT)

```text
Browser → Internet → EC2 Public IP → Port 80 → Security Group → Nginx → Response
```

---

## 🔐 Why `chmod 400`?

* Restricts key permissions
* Required by SSH for security
* Prevents others from accessing private key

---

## 🔍 Internal vs External Testing

```bash
curl localhost
```

👉 Tests inside server

```bash
curl http://<PUBLIC_IP>
```

👉 Tests from outside world

---

## 🧪 Debugging Learned

* If site not loading:

  * Check Nginx status
  * Check port 80 open
  * Check security group
  * Check correct IP

---

## ✍️ Custom Page Change

Edited file:

```bash
/var/www/html/index.nginx-debian.html
```

Updated content and verified in browser.

---

## 💰 Cost Awareness

* Used free-tier EC2 (t2.micro)
* Stopped instance after work to avoid charges
* Used OS shutdown for safe stopping

---

## 🔗 Big Picture Understanding

```text
AWS CLI → Access AWS
EC2 → Server
SSH → Connect to server
Nginx → Serve application
Browser → Access application
```

---

## ⚠️ What I Didn’t Fully Understand

* (Write honestly)

---

## 📈 Self Evaluation

Understanding: X/10
Confidence: X/10
