# Update GitHub Secrets for New EC2 Instance

## New Instance Details
- **IP Address:** `44.200.42.211`
- **Username:** `ubuntu` (confirmed - SSH works)
- **SSH Key:** `~/.ssh/aws-new` (same key)

## Update GitHub Secrets

1. **Go to GitHub Secrets:**
   - https://github.com/OnGets18/back-service/settings/secrets/actions

2. **Update `ec2_host` secret:**
   - Find `ec2_host` secret
   - Click **Update**
   - Change value from `98.84.25.68` to `44.200.42.211`
   - Click **Update secret**

3. **Verify `ec2_user` secret:**
   - Find `ec2_user` secret
   - Should be `ubuntu` (if not, update it)
   - If it's `ec2-user`, click **Update** and change to `ubuntu`

4. **Verify `ec2_ssh_key` secret:**
   - Should already be set with your private key
   - No changes needed if using the same key

## Test Deployment

After updating secrets, test the deployment:

```bash
# From your local machine
./deploy-to-ec2.sh
```

Or push to master branch and GitHub Actions will deploy automatically!

## Verify Application

After deployment:

```bash
# Test API
curl http://44.200.42.211:3000

# Test Swagger
curl http://44.200.42.211:3000/api
```

## Security Group Check

Make sure your new EC2 instance security group allows:
- **SSH (port 22)** from `0.0.0.0/0` (or GitHub Actions IPs)
- **HTTP (port 3000)** from `0.0.0.0/0` (for API access)

