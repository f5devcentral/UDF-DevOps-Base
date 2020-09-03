# UDF DevOps Base Setup

This directory contains automation scripts to configure the base Unified Demo Framework blueprint and is not part of the coursework. 

## Initial Setup

### Install Ansible on the Client Ubuntu server
```bash
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update
sudo apt install ansible -y
```
### Configure Ansible host file
```bash
sudo bash -c '/bin/cat <<EOF > /etc/ansible/hosts 
[servers]
client ansible_host=10.1.1.4
app ansible_host=10.1.1.5

[bigip]
bigip1 ansible_host=10.1.1.6
bigip2 ansible_host=10.1.1.7

[all:vars]
ansible_python_interpreter=/usr/bin/python3 
EOF'
```

## Setup Ubuntu servers
```bash
ansible-playbook --limit servers ubuntu.yml
```

## Install NGINX
```bash
ansible-playbook --limit servers nginx.yml
```

## Install Docker
```bash
ansible-playbook --limit servers docker.yml
```