# UDF DevOps Base Setup

This directory contains automation scripts to configure the base Unified Demo Framework blueprint and is not part of the coursework. 

## Install NGINX
```bash
ansible-playbook -i hosts nginx.yml
```

## Install Docker
```bash
ansible-playbook -i hosts docker.yml
```