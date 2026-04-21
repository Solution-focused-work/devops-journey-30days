# Day 3 — April 21

## 🎯 Goal

Understand how systems fail in real-world scenarios and learn how to debug issues across network, application, and configuration layers.

---

## ✅ What I Did

* Restarted EC2 and reconnected via SSH
* Verified baseline system (Nginx + browser working)
* Simulated 3 real-world failure scenarios:

  1. Network failure (Security Group misconfiguration)
  2. Application failure (Nginx stopped)
  3. Port misconfiguration (Nginx running on 8080)
* Debugged each issue step-by-step
* Restored system after each failure
* Learned structured debugging approach

---

## 🧱 Baseline Setup (Before Breaking)

```bash
ssh -i ~/.ssh/devops/devops-key.pem ubuntu@<PUBLIC_IP>
sudo systemctl status nginx
curl localhost
```

Browser:

```
http://<PUBLIC_IP>
```

👉 Confirmed system was working before testing failures

---

## 💻 Commands Used

```bash
sudo systemctl status nginx
sudo systemctl stop nginx
sudo systemctl start nginx
sudo systemctl restart nginx

curl localhost
curl localhost:8080

sudo nano /etc/nginx/sites-available/default
sudo netstat -tuln | grep 80
sudo netstat -tuln | grep 8080
```

---

## 💣 Failure Scenario 1 — Network Failure (Security Group)

### 🔧 Action

* Removed HTTP (port 80) rule from Security Group

---

### ❌ Result

* Browser → ❌ failed
* curl localhost → ✅ still worked

---

### 🧠 Root Cause

```text
Request reached AWS network but was blocked at Security Group (firewall)
```

* Security Group denied inbound traffic on port 80
* Request never reached EC2

---

### 🔍 Key Learning

* Security Group acts as a firewall
* It filters external inbound traffic
* Internal traffic is NOT affected

---

### 🔁 Fix

* Re-added rule:

  ```
  HTTP → Port 80 → 0.0.0.0/0
  ```

---

## 💣 Failure Scenario 2 — Application Failure (Nginx Down)

### 🔧 Action

```bash
sudo systemctl stop nginx
```

---

### ❌ Result

* Browser → ❌ failed
* curl localhost → ❌ failed

---

### 🧠 Root Cause

```text
Request reached EC2 but no application was running to handle it
```

* No process listening on port 80
* Application layer failure

---

### 🔍 Key Learning

* Server can be running but app can be down
* Need to check service status separately

---

### 🔁 Fix

```bash
sudo systemctl start nginx
```

---

## 💣 Failure Scenario 3 — Port Misconfiguration

### 🔧 Action

Edited config:

```bash
sudo nano /etc/nginx/sites-available/default
```

Changed:

```text
listen 80;
→ listen 8080;
```

Restarted nginx:

```bash
sudo systemctl restart nginx
```

---

### ❌ Result

* http://<IP> → ❌ failed
* http://<IP>:8080 → ❌ initially failed

---

### 🧠 Debugging Steps

1. Verified nginx running ✅
2. Checked port:

```bash
netstat -tuln | grep 8080
```

→ confirmed nginx listening on 8080

3. Tested internally:

```bash
curl localhost:8080
```

→ worked ✅

---

### 🧠 Root Cause

```text
Security Group was not allowing port 8080
```

* App was running
* But firewall blocked external access

---

### 🔁 Fix

Added rule:

```text
Custom TCP → Port 8080 → 0.0.0.0/0
```

---

### ✅ Result

* http://<IP>:8080 → working

---

## 🧠 Core Debugging Framework

```text
1. Is EC2 running?
2. Can I SSH?
3. Is service running?
4. Is port open?
5. Is firewall allowing?
6. Is correct port used?
```

---

## 🌐 Request Flow Understanding

```text
Browser
  ↓
Internet
  ↓
Security Group (Firewall)
  ↓
EC2 (Server)
  ↓
Port (80 / 8080)
  ↓
Application (Nginx)
  ↓
Response
```

---

## 🔍 Internal vs External Requests

### Internal:

```bash
curl localhost
```

* Does NOT go through AWS network
* Bypasses Security Group

---

### External:

```text
http://<PUBLIC_IP>
```

* Goes through:

  * Internet
  * Security Group
  * EC2

---

## 💣 Key Concepts Learned

* Security Group = firewall (controls inbound traffic)
* Internal traffic bypasses security group
* Service running ≠ service accessible
* Port configuration must match firewall rules
* Debugging must follow a structured approach

---

## ❌ Errors Faced

### 1. SSH Permission Denied

* Cause: Wrong path / incorrect key usage
* Fix: Correct key path

---

### 2. Confusion between internal vs external failure

* Fixed by using curl vs browser comparison

---

### 3. Port 8080 not accessible

* Cause: Security group not updated
* Fix: Added inbound rule

---
