# SSH Connection Troubleshooting

## Current Issue
SSH is timing out from both:
- GitHub Actions
- Your local machine

This means the security group rule for port 22 is not working correctly.

## Step-by-Step Fix

### 1. Check Which Security Group is Attached

1. Go to EC2 Console: https://console.aws.amazon.com/ec2/
2. Find your instance (search for IP: 44.200.42.211)
3. Click on the instance
4. Click **Security** tab
5. **Note the security group name/ID** (e.g., `sg-xxxxx`)

### 2. Edit the CORRECT Security Group

1. Click on the security group link (the one attached to your instance)
2. Click **Inbound rules** tab
3. Click **Edit inbound rules**
4. Check if SSH rule exists:
   - If NO SSH rule: Click **Add rule**
   - If SSH rule exists but source is wrong: Click **Edit** on that rule
5. Configure:
   - **Type:** SSH
   - **Protocol:** TCP
   - **Port:** 22
   - **Source:** `0.0.0.0/0`
   - **Description:** Allow SSH
6. **IMPORTANT:** Click **Save rules** button at the bottom

### 3. Wait a Few Seconds

Security group changes can take 10-30 seconds to propagate.

### 4. Test Again

```bash
ssh -i ~/.ssh/aws-new ubuntu@44.200.42.211
```

### 5. Common Mistakes

- ❌ Editing the wrong security group (not the one attached to instance)
- ❌ Not clicking "Save rules" after editing
- ❌ Adding rule but source is restricted (not 0.0.0.0/0)
- ❌ Multiple security groups attached (need to check all of them)

### 6. Verify Multiple Security Groups

If your instance has multiple security groups:
- Check ALL of them
- At least ONE must allow SSH from 0.0.0.0/0

## Alternative: Use EC2 Instance Connect

If SSH continues to fail, you can deploy manually using EC2 Instance Connect:
1. Go to EC2 Console → Your instance
2. Click **Connect** button
3. Use **EC2 Instance Connect** (browser-based)
4. Run deployment commands manually

