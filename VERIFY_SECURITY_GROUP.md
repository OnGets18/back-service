# Verify Security Group Configuration

## SSH Connection Still Timing Out

If SSH is still timing out after opening port 22, check these:

### 1. Verify Security Group is Attached to Instance

1. Go to EC2 Console → Your instance (44.200.42.211)
2. Click **Security** tab
3. **Check which security group is listed**
4. Make sure you edited the **correct** security group (the one attached to the instance)

### 2. Verify SSH Rule Exists

In the security group, check inbound rules:
- **Type:** SSH (or Custom TCP)
- **Port:** 22
- **Source:** `0.0.0.0/0`
- **Status:** Should show as active

### 3. Check Network ACLs

Network ACLs can also block traffic:

1. Go to VPC Console → Network ACLs
2. Find the Network ACL for your subnet
3. Check inbound rules allow:
   - Port 22 (SSH) from 0.0.0.0/0
   - Or all traffic from 0.0.0.0/0

### 4. Verify Instance is Running

1. Check EC2 Console
2. Instance state should be "Running"
3. Status checks should be "2/2 checks passed"

### 5. Test SSH from Your Local Machine

```bash
ssh -i ~/.ssh/aws-new ubuntu@44.200.42.211
```

If this works but GitHub Actions doesn't, it might be:
- GitHub Actions IPs are blocked
- Security group rule hasn't propagated yet (can take a few minutes)

### 6. Alternative: Use EC2 Instance Connect

If SSH continues to fail, we can modify the deployment to use EC2 Instance Connect or AWS Systems Manager instead of direct SSH.

