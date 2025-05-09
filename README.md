# Infrastructure Setup

This project uses Terraform for infrastructure provisioning and Ansible for configuration management.

## Prerequisites

- Terraform >= 1.0.0
- Ansible >= 6.0.0
- Python >= 3.10
- DigitalOcean API token
- SSH key uploaded to DigitalOcean

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/paysoko-assessment.git
cd paysoko-assessment
```

### 2. Set up environment variables

```bash
export DO_TOKEN=your_digitalocean_token
export SSH_KEY_NAME=your_ssh_key_name
export DO_SPACES_ACCESS_KEY_ID=your_spaces_access_key
export DO_SPACES_ACCESS_KEY_SECRET=your_spaces_secret_key
export DB_PASSWORD=your_database_password
```

### 3. Install pre-commit hooks (optional)

```bash
pip install pre-commit
pre-commit install --hook-type pre-push
```

### 4. Install Ansible collections

```bash
ansible-galaxy collection install community.docker
```

### 5. Provision infrastructure with Terraform

```bash
cd infrastructure/terraform
terraform init
terraform plan  # Review changes
terraform apply  # Create resources
```

### 6. Configure servers with Ansible

```bash
cd ../ansible
cp inventory.ini.example inventory/hosts.yml  # Create and update with your IPs

# Update with values from terraform output
# Example: ansible_host for bastion, nodejs_app IPs, etc.

# Run playbook
ansible-playbook -i inventory/hosts.yml setup.yml
```

### 7. Deploy applications

```bash
# Deploy user-service
ansible-playbook -i inventory/hosts.yml deploy.yml -e "service=user-service version=v1.0.0"

# Deploy task-service
ansible-playbook -i inventory/hosts.yml deploy.yml -e "service=task-service version=v1.0.0"
```

## Directory Structure

```
infrastructure/
├── terraform/       # Infrastructure as Code
└── ansible/         # Configuration management
    ├── inventory/   # Server inventory
    ├── templates/   # Configuration templates
    ├── setup.yml    # Initial server setup
    └── deploy.yml   # Blue-green deployment
```

## Common Tasks

- **Update infrastructure**: Make changes to Terraform files, then run `terraform plan` and `terraform apply`
- **Server reconfiguration**: Make changes to Ansible playbooks, then run the relevant playbook
- **Deploy new version**: Run `deploy.yml` with service name and version
- **Rollback deployment**: Run `deploy.yml` with rollback=true flag

## Notes

- The bastion host is used as a jump box to access private network servers
- Blue-green deployment ensures zero downtime during updates
- Terraform state is stored in DigitalOcean Spaces bucket