
# UDF DevOps Base

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

## Setup: F5 Employees

1. Login to the Unified Demo Framework
2. Deploy the DevOps Base blueprint

    > **_NOTE:_** For more information on deploying a UDF blueprint, please reference the [UDF documentation](https://help.udf.f5.com/en/)
3. Under components, click the access dropdown on the client system, then click VS CODE
4. Open a new [terminal](https://code.visualstudio.com/docs/editor/integrated-terminal) in VS Code
5. Launch the F5 CLI Docker container docker 
    
        run -it -v "$HOME/.f5_cli:/root/.f5_cli" -v "$(pwd):/f5-cli" f5devcentral/f5-cli:latest /bin/bash

6. Set the BIG-IP password as an environment variable:

    > **_NOTE:_** the BIG-IP password can be found on the BIG-IP1 and BIG-IP2 documentation pages inside the UDF deployment
        
        export bigip_pwd=replaceme
7. Onboard BIG-IP1
    7.1. authenticate the F5-CLI against BIG-IP1:
        
        f5 login --authentication-provider bigip --host 10.1.1.6 --user admin --password $bigip_pwd

    7.2. verify Declarative Onboarding is installed and ready:
        
        f5 bigip extension do verify

    7.3. configure DO for BIG-IP1:
        
        f5 bigip extension do create --declaration /f5-cli/projects/UDF-DevOps-Base/declarations/bigip1.do.json

8. Onboard BIG-IP2
    8.1. authenticate the F5-CLI against BIG-IP1:
        
        f5 login --authentication-provider bigip --host 10.1.1.7 --user admin --password $bigip_pwd

    8.2. verify Declarative Onboarding is installed and ready:
        
        f5 bigip extension do verify
    8.3. configure DO for BIG-IP2:
        
        f5 bigip extension do create --declaration /f5-cli/projects/UDF-DevOps-Base/declarations/bigip2.do.json

Setup: F5 Customers
-------------------
No setup is required since the solution will be offered as a training course

Cleanup
-------
If you are using this blueprint to create other blueprints you may need to clean up the BIG-IP configuration before requesting the blueprint promotion.

1. Launch the F5 CLI Docker container docker 
    
        run -it -v "$HOME/.f5_cli:/root/.f5_cli" -v "$(pwd):/f5-cli" f5devcentral/f5-cli:latest /bin/bash

2. Set the BIG-IP password as an environment variable:

    > **_NOTE:_** the BIG-IP password can be found on the BIG-IP1 and BIG-IP2 documentation pages inside the UDF deployment
    
        export bigip_pwd=replacement

3. Onboard Base BIG-IP1
    3.1. authenticate the F5-CLI against BIG-IP1:
        
            f5 login --authentication-provider bigip --host 10.1.1.6 --user admin --password $bigip_pwd

    3.2. verify Declarative Onboarding is installed and ready:
        
            f5 bigip extension do verify

    3.3. configure DO for BIG-IP1:
            
            f5 bigip extension do create --declaration /f5-cli/projects/UDF-DevOps-Base/declarations/base.do.json

#. Onboard Base BIG-IP2
    #. authenticate the F5-CLI against BIG-IP1:
        
            f5 login --authentication-provider bigip --host 10.1.1.7 --user admin --password $bigip_pwd

    #. verify Declarative Onboarding is installed and ready:
        
            f5 bigip extension do verify

    #. configure DO for BIG-IP2:

            f5 bigip extension do create --declaration /f5-cli/projects/UDF-DevOps-Base/declarations/base.do.json
