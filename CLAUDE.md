# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is "triggered-ts" - a cloud infrastructure project for deploying TeamSpeak servers on AWS using containerized deployment. Despite the "-ts" suffix, this is not a TypeScript project but refers to TeamSpeak.

## Common Commands

### Infrastructure Management
```bash
# Bootstrap initial infrastructure (S3 bucket + DynamoDB for Terraform state)
tf -chdir=initial-infra init
tf -chdir=initial-infra apply --auto-approve

# Main infrastructure deployment
tf -chdir=infra init
tf -chdir=infra plan
tf -chdir=infra apply

# Destroy infrastructure
tf -chdir=infra destroy
```

### Docker Operations
```bash
# Build TeamSpeak Docker image
docker build -t teamspeak ./teamspeak

# Build for specific platform (required for ECR)
docker build --platform linux/amd64 -t teamspeak ./teamspeak

# Tag and push to ECR (done automatically by GitHub Actions)
docker tag teamspeak:latest 905418283206.dkr.ecr.eu-west-1.amazonaws.com/teamspeak:latest
docker push 905418283206.dkr.ecr.eu-west-1.amazonaws.com/teamspeak:latest
```

## Architecture

### Infrastructure Layer (Terraform)
- **AWS Provider**: 4.58.0, deployed to eu-west-1
- **State Management**: S3 backend with DynamoDB locking
- **Networking**: Custom VPC with public subnets and security groups
- **Container Platform**: ECS with EC2 launch type
- **Registry**: ECR for Docker image storage

### Application Layer
- **TeamSpeak Server**: Official TeamSpeak 3.13 Docker image
- **Networking**: 
  - Port 9987/UDP (voice)
  - Port 10011/TCP (ServerQuery)
  - Port 30033/TCP (file transfer)

### CI/CD Pipeline
- **GitHub Actions** for automated builds and deployments
- **ECR Integration** for Docker image publishing
- **Terraform Automation** triggered on main branch changes

## Directory Structure

- `/infra/` - Main Terraform configuration for AWS resources
- `/initial-infra/` - Bootstrap infrastructure for Terraform state management
- `/teamspeak/` - Docker configuration for TeamSpeak server
- `/.github/workflows/` - CI/CD pipeline definitions

## Key Configuration Files

- `infra/providers.tf` - AWS provider and S3 backend configuration
- `infra/deployment.tf` - ECS cluster, service, and task definitions
- `infra/networking.tf` - VPC, subnets, and security group setup
- `infra/ecr.tf` - ECR repository configuration
- `teamspeak/Dockerfile` - TeamSpeak container configuration

## Development Notes

- All infrastructure changes should be made through Terraform
- Docker images are automatically built and pushed to ECR via GitHub Actions
- The project uses commit hash tagging for Docker images
- Terraform state is stored remotely in S3 with DynamoDB locking
- Infrastructure is designed for public internet access to TeamSpeak ports

## Cost Optimizations

The infrastructure includes several cost optimization features:
- **Fargate over EC2**: Uses ECS Fargate instead of EC2 for pay-per-use pricing
- **Right-sized resources**: 256 CPU units and 512MB memory for minimal TeamSpeak requirements
- **Container Insights disabled**: Reduces CloudWatch costs
- **Minimal log retention**: 1-day log retention to minimize storage costs
- **ECR lifecycle policy**: Keeps only 5 most recent Docker images
- **Budget alerts**: $10 monthly budget with 80% and 100% threshold alerts
- **Health monitoring**: CloudWatch alarms for service availability

To enable email alerts, set the `alert_email` variable when applying Terraform.