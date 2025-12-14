# Check Route Table Configuration

## Current Status
✅ Security Group: Allows SSH from 0.0.0.0/0  
✅ Network ACL: Allows all traffic inbound/outbound  
❌ SSH connection still times out  
❌ Ping fails  

## Next: Check Route Table

Since Network ACLs are correct, check if the route table has proper internet gateway route.

### Steps:

1. **Go to VPC Console:**
   - https://console.aws.amazon.com/vpc/
   - Click **Route tables** in left menu

2. **Find Route Table for Your Subnet:**
   - Your subnet: `subnet-0a2f1962900121278`
   - Look for route table associated with this subnet

3. **Check Routes:**
   - Should have a route: `0.0.0.0/0` → `igw-xxxxx` (Internet Gateway)
   - This allows the instance to reach the internet

4. **If Route is Missing:**
   - Click **Edit routes**
   - Add route: `0.0.0.0/0` → Select your Internet Gateway
   - Save

## Alternative: Check Instance SSH Service

If routing is correct, the SSH service on the instance might be down:

1. **Use EC2 Instance Connect:**
   - Go to EC2 Console → Your instance
   - Click **Connect** button
   - Try **EC2 Instance Connect** (browser-based)
   - This bypasses network issues

2. **Or Use AWS Systems Manager:**
   - Attach IAM role with `AmazonSSMManagedInstanceCore` to instance
   - Go to Systems Manager → Session Manager
   - Start session with your instance

## If EC2 Instance Connect Works

If EC2 Instance Connect works but SSH from your machine doesn't, it might be:
- Your local network/firewall blocking outbound SSH
- Your ISP blocking port 22
- Try from a different network (mobile hotspot)

## Quick Test: Check Instance Status

1. In EC2 Console, check instance **Status checks**
2. Should show: "2/2 checks passed"
3. If "System status check" fails, the instance might have issues


