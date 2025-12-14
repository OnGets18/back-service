# Fix Port 3000 Access Issue

## Problem
The container is running, but the API at `http://44.200.42.211:3000` is not accessible from outside.

## Solution: Open Port 3000 in Security Group

You opened port 22 for SSH, but you also need to open port 3000 for the API.

### Steps:

1. **Go to EC2 Console:**
   - https://console.aws.amazon.com/ec2/
   - Find your instance (IP: 44.200.42.211)
   - Click on it

2. **Open Security Tab:**
   - Click the **Security** tab
   - Click on the security group link

3. **Edit Inbound Rules:**
   - Click **Edit inbound rules**
   - Click **Add rule**
   - Configure:
     - **Type:** Custom TCP
     - **Protocol:** TCP
     - **Port range:** `3000`
     - **Source:** `0.0.0.0/0` (or your specific IP for security)
     - **Description:** Allow API access on port 3000
   - Click **Save rules**

## Verify

After adding the rule, test:

```bash
curl http://44.200.42.211:3000
curl http://44.200.42.211:3000/api
```

Both should work now!

## Security Note

If you want to be more secure, you can:
- Restrict Source to your specific IP instead of `0.0.0.0/0`
- Use a load balancer with HTTPS
- Add authentication to your API

