## Overview

This repository provides the base components required to setup a DevOps base lab in UDF.  This lab can be used to practice and created automation and DevOps content. 

## Prerequisites 

1. Access to the F5 Unified Demo Framework (UDF)
2. Chrome browser 

## Environment

The UDF blueprint consists of the following resources:

- 2 x BIG-IP virtual appliances (15.0.x)
- 1 Ubuntu 18 application server running: 
    - NGINX
- 1 Ubuntu 18 client server running: 
    - Coder (Web based VS Code) 
    - Docker 
        - f5-cli container
    - Sphinx

## Networking

| Component | Management Subnet (10.1.1.0/24) | Internal Subnet (10.1.10.0/24) | External Subnet (10.1.20.0/24) | Additional IPs | 
|-----------|---------------------------------|--------------------------------|--------------------------------|---------------|
| Client Server | 10.1.1.4 | 10.1.10.4 | 10.1.20.4 | none |
| App Server | 10.1.1.5 | 10.1.10.5 | none | none |
| BIG-IP1 | 10.1.1.6 | 10.1.10.6 | 10.1.20.6 | 10.1.20.20 |
| BIG-IP2 | 10.1.1.7 | 10.1.10.7 | 10.1.20.6 | 10.1.20.10 | 

## Setup: 

View the [lab documentation](https://f5solutionsengineering.github.io/UDF-DevOps-Base/).