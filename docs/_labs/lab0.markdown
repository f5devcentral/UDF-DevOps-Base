---
name: Lab0
title: Lab0 - Initial Setup
description: Initial setup of the UDF deployment
layout: page
tags: 
    - f5-cli
    - DO
---
## Setup

1. Log in to the [Unified Demo Framework Portal](https://udf.f5.com)
2. Deploy the DevOps Base blueprint

    > **_NOTE:_** For more information on deploying a UDF blueprint, please reference the [UDF documentation](https://help.udf.f5.com/en/)
3. Under components, click the access dropdown on the client system, then click VS CODE
4. Open a new [terminal](https://code.visualstudio.com/docs/editor/integrated-terminal) in VS Code
5. Start the F5 CLI Docker container and make sure it's running
    
        docker start f5-cli
        docker ps

6. Set the BIG-IP password as an environment variable:

    > **_NOTE:_** Obtain the BIG-IP password on the BIG-IP1 and BIG-IP2 documentation pages inside the UDF deployment
        
        export bigip_pwd=replaceme
7. Onboard BIG-IP1
    7.1. authenticate the F5-CLI against BIG-IP1:
        
        docker exec -it f5-cli f5 login --authentication-provider bigip --host 10.1.1.6 --user admin --password $bigip_pwd

    7.2. verify the Declarative Onboarding installation:
        
        docker exec -it f5-cli f5 bigip extension do verify

    7.3. configure DO for BIG-IP1:
        
        docker exec -it f5-cli f5 bigip extension do create --declaration /f5-cli/projects/UDF-DevOps-Base/declarations/bigip1.do.json

8. Onboard BIG-IP2

    8.1. authenticate the F5-CLI against BIG-IP1:
        
        docker exec -it f5-cli f5 login --authentication-provider bigip --host 10.1.1.7 --user admin --password $bigip_pwd

    8.2. verify the Declarative Onboarding installation:
        
        docker exec -it f5-cli f5 bigip extension do verify

    8.3. configure DO for BIG-IP2:
        
        docker exec -it f5-cli f5 bigip extension do create --declaration /f5-cli/projects/UDF-DevOps-Base/declarations/bigip2.do.json

Your BIG-IPs are now ready to accept AS3 declarations.