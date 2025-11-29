#!/bin/bash
component=$1
environment=$2
dnf install ansible -y
pip3.9 install --upgrade pip
pip3.9 install botocore boto3
ansible-pull -i localhost, -U https://github.com/sid2417/ansible-dynamic-inventory-tfnew-bykithu.git main.yaml -e component=$component -e env=$environment