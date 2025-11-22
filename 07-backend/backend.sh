#!/bin/bash
component=$1
environment=$2
sudo dnf install ansible -y
sudo pip3.9 install --upgrade pip
sudo pip3.9 install botocore boto3
#pip3.9 install botocore boto3
ansible-pull -i localhost, -U https://github.com/sid2417/ansible-role-miniproject-tf-bykithu.git main.yaml -e component=$component -e env=$environment