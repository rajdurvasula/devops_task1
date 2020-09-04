# Terraform script to launch Apache HTTP service
- Jenkins pipeline script to launch EC2 instance using Terraform template.
- Uses Ansible playbook to install and configure Apache HTTP service
- Uses Git Web hook to trigger pipeline

## Updates
- Use Jenkins SSH credential as parameter for Terraform script