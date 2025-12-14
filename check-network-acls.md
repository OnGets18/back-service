# Check Network ACLs and Routing

## Current Status
✅ Security group `sg-0e03d8dd513aef0fa` is attached  
✅ Security group allows SSH (port 22) from 0.0.0.0/0  
❌ SSH connection times out  
❌ Ping fails (100% packet loss)  

## This Suggests: Network ACLs or Routing Issue

Since ping also fails, the issue is likely at the network level, not just SSH.

## Check Network ACLs

1. **Go to VPC Console:**
   - https://console.aws.amazon.com/vpc/
   - Click **Network ACLs** in left menu

2. **Find Your Subnet's ACL:**
   - Your subnet: `subnet-0a2f1962900121278`
   - Find the Network ACL associated with this subnet
   - Click on it

3. **Check Inbound Rules:**
   - Should allow:
     - Rule 100: All traffic (0.0.0.0/0) - Type: All traffic, Action: Allow
     - OR at minimum:
       - SSH (port 22) from 0.0.0.0/0
       - ICMP (for ping) from 0.0.0.0/0

4. **Check Outbound Rules:**
   - Should allow all traffic outbound

## Check Route Table

1. **Go to VPC Console:**
   - Click **Route tables** in left menu

2. **Find Route Table for Your Subnet:**
   - Your subnet: `subnet-0a2f1962900121278`
   - Find the route table associated with this subnet

3. **Verify Routes:**
   - Should have:
     - `0.0.0.0/0` → `igw-xxxxx` (Internet Gateway)
     - This allows the instance to reach the internet

## Check Internet Gateway

1. **Go to VPC Console:**
   - Click **Internet gateways** in left menu
   - Verify there's an IGW attached to your VPC: `vpc-0a78914fbf7379099`

## Quick Test: Try AWS Systems Manager

If SSH continues to fail, you can use AWS Systems Manager Session Manager:

1. **Attach IAM Role to Instance:**
   - Go to EC2 → Your instance → Actions → Security → Modify IAM role
   - Attach a role with `AmazonSSMManagedInstanceCore` policy

2. **Connect via Systems Manager:**
   - Go to Systems Manager → Session Manager
   - Start a session with your instance
   - This bypasses SSH and works through AWS API

## Alternative: Check Instance from AWS Console

1. **Use EC2 Instance Connect:**
   - In EC2 Console, select your instance
   - Click **Connect** button
   - Try **EC2 Instance Connect** (browser-based SSH)
   - This will help determine if it's a network issue or SSH service issue

