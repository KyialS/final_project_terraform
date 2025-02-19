# Terraform Project: Infrastructure as Code (IaC) Setup

## Description

This Terraform project is designed to create a modular and scalable infrastructure using Infrastructure as Code (IaC) principles. The project facilitates the provisioning of networking resources, autoscaling configurations, and deployment environments. The infrastructure is organized into child modules, each serving specific functionalities to ensure a well-structured and manageable setup.

## Project Structure

### 1. Networking Module

- **Objective**: Create networking resources, including public and private subnets.
- **Features**:
  - **Public Subnets**: Allows dynamic creation based on specified CIDR blocks.
  - **Private Subnets**: Includes a single NAT gateway, dynamically configured based on provided CIDR blocks.

### 2. Autoscaling Module

- **Objective**: Implement autoscaling functionalities for application scalability.
- **Features**:
  - **Launch Template**: Configurable with default AMI and user-specified AMI.
  - **Security Groups**: Includes dynamic ingress and egress rules attached to the launch template. Additional input variable for supplementary security groups.

### 3. Environments

#### Dev Environment

- **Networking**:
  - Utilizes the networking module to create public and private subnets.
  - Configured with three CIDR blocks for each subnet type.
- **Autoscaling**:
  - Uses the autoscaling module to deploy an Apache web server with a user data script to private subnets.
- **Public ALB Module**:
  - Implements an Application Load Balancer (ALB) to route incoming traffic to the autoscaling group.
- **Outputs**:
  - The CLI displays the DNS name of the ALB for accessing the Apache web page.

#### Prod Environment

- **Static Website Hosting**:
  - Configures an S3 bucket and associated resources to host a static website.
- **Outputs**:
  - After creation, the CLI provides the DNS name of the static website for access through a browser.



