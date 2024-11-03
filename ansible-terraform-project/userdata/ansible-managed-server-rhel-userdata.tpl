#!/bin/bash

# Log file location
LOG_FILE="/var/log/user-data.log"

# Redirect all output to the log file and console
exec > >(tee -a $LOG_FILE) 2>&1
echo "$(date +"%Y-%m-%d %H:%M:%S") - Starting AWS CLI installation script."

# Check if AWS CLI is already installed
if command -v aws &> /dev/null; then
    echo "AWS CLI is already installed: $(aws --version)"
else
    echo "AWS CLI not found. Installing AWS CLI..."

    # Install unzip if not installed
    if ! command -v unzip &> /dev/null; then
        echo "Installing unzip..."
        yum install -y unzip
    fi

    # Download and install the AWS CLI
    echo "Downloading AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip

    echo "Installing AWS CLI..."
    sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

    # Check if AWS CLI is installed correctly
    if /usr/local/bin/aws --version &> /dev/null; then
        echo "AWS CLI installed successfully."
    else
        echo "AWS CLI installation failed."
        exit 1
    fi

    # Add AWS CLI to PATH
    echo "Adding AWS CLI to PATH..."
    export PATH=$PATH:/usr/local/bin
    echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bash_profile
    source ~/.bash_profile

    # Verify installation
    echo "Verifying AWS CLI installation..."
    if command -v aws &> /dev/null; then
        echo "AWS CLI is available: $(aws --version)"
    else
        echo "AWS CLI is not accessible after installation."
        exit 1
    fi
fi

# Install jq 

sudo yum install jq -y

# Fetch the public key from SSM Parameter Store
echo "$(date +"%Y-%m-%d %H:%M:%S") - Fetching public key from SSM Parameter Store..."
PUBLIC_KEY=$(aws ssm get-parameter --name "ansible-master-public-key" --output json | jq -r '.Parameter.Value')

if [ $? -eq 0 ]; then
  echo "Public key downloaded successfully."
else
  echo "Failed to download public key from SSM Parameter Store."
  exit 1
fi

# Add the public key to the authorized_keys for the ec2-user
echo "$PUBLIC_KEY" >> /home/ec2-user/.ssh/authorized_keys

if [ $? -eq 0 ]; then
  echo "Public key added to authorized_keys."
else
  echo "Failed to add public key to authorized_keys."
  exit 1
fi

echo "$(date +"%Y-%m-%d %H:%M:%S") - User data script completed."
