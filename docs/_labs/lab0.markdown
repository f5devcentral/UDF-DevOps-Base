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
7. Fork the UDF-Devops-Base repository

    The labs for this UDF blueprint can be found on [GitHub](https://github.com/F5SolutionsEngineering/UDF-DevOps-Base).  You will need to fork this repository into your own GitHub environmnent. 
    
    For information on how to do this, please visit the [GitHub documentation page](https://help.github.com/en/github/getting-started-with-github/fork-a-repo#fork-an-example-repository).

8. Checkout Forked Repository

    To conduct the labs, you will need to check our your forked version of the repository:

    ```bash
    cd ~/projects
    ```

9. Get Latest Version of the Lab
    ```bash
    git remote add upstream https://github.com/F5SolutionsEngineering/UDF-DevOps-Base.git
    git fetch upstream
    git merge upstream/master
    ```

    # replace your GitHub username
    git clone https://github.com/<githubusername>/UDF-DevOps-Base.git
    ```

9. Change into the Lab0 directory:

    ```bash
    cd ~/projects/UDF-DevOps-Base/labs/lab0
    ```

## Install BIG-IP ATC and FAST extension
In preperation for further labs we need to install the F5 Automation Toolchain and the F5 Application Service Templates extensions.

1. Set the BIG-IP password and ATC versions as an environment variables:

    > **NOTE**: Obtain the BIG-IP password on the BIG-IP1 and BIG-IP2 documentation pages inside the UDF deployment

    ```bash
    export bigip_pwd=replaceme
    export as3_version=3.19.1
    export do_version=1.12.0
    export ts_version=1.11.0
    ```

2. Install ATC on BIG-IP1 and BIG-IP2:

    > **Note**: If the F5-CLI Docker container is not running, start it with the 'docker start f5-cli' command
    
    ```bash
    docker start f5-cli
    for in in {6..7} 
    do
        docker exec -it f5-cli f5 login --authentication-provider bigip --host 10.1.1.$i --user admin --password $bigip_pwd
        docker exec -it f5-cli f5 bigip extension do install --version $do_version
        docker exec -it f5-cli f5 bigip extension as3 install --version $as3_version
        docker exec -it f5-cli f5 bigip extension ts install --version $ts_version
    done
    ```

2. Install FAST on BIG-IP1 and BIG-IP2:

    ```bash
    for i in {6..7} 
    do
        cd /tmp
        FN=f5-appsvcs-templates-1.0.0-1.noarch.rpm
        wget https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.0.0/$FN
        CREDS=admin:$bigip_pwd
        IP=10.1.1.$i
        LEN=$(wc -c $FN | awk 'NR==1{print $1}')
        curl -kvu $CREDS https://$IP/mgmt/shared/file-transfer/uploads/$FN -H 'Content-Type: application/octet-stream' -H "Content-Range: 0-$((LEN - 1))/$LEN" -H "Content-Length: $LEN" -H 'Connection: keep-alive' --data-binary @$FN
        DATA="{\"operation\":\"INSTALL\",\"packageFilePath\":\"/var/config/rest/downloads/$FN\"}"
        curl -kvu $CREDS "https://$IP/mgmt/shared/iapp/package-management-tasks" -H "Origin: https://$IP" -H 'Content-Type: application/json;charset=UTF-8' --data $DATA
    done
    ```

## Test the ATC and FAST Extensions
An important, but often overlooked, part of automation is the creation of test cases to ensure the automation achieved the desired outcome. In this lab, we will leverage the Chef [InSpec][InSpec] tool.  InSpec is based on Ruby and provides a framework to test infrastructure deployed in a public or private cloud.

```bash
cd ~/projects/UDF-DevOps-Base/labs/lab0
for i in {6..7} 
do
    inspec exec https://github.com/F5SolutionsEngineering/big-ip-atc-ready.git \
    --input bigip_address=10.1.1.6 password=$bigip_pwd do_version=$do_version \
    as3_version=$as3_version ts_version=$ts_version
done
```

## Onboard the BIG-IP

1. Onboard BIG-IP1
    1.1. authenticate the F5-CLI against BIG-IP1:
        
        docker exec -it f5-cli f5 login --authentication-provider bigip --host 10.1.1.6 --user admin --password $bigip_pwd

    1.2. verify the Declarative Onboarding installation:
        
        docker exec -it f5-cli f5 bigip extension do verify

    1.3. configure DO for BIG-IP1:
        
        docker exec -it f5-cli f5 bigip extension do create --declaration /f5-cli/projects/UDF-DevOps-Base/declarations/bigip1.do.json

2. Onboard BIG-IP2

    2.1. authenticate the F5-CLI against BIG-IP1:
        
        docker exec -it f5-cli f5 login --authentication-provider bigip --host 10.1.1.7 --user admin --password $bigip_pwd

    2.2. verify the Declarative Onboarding installation:
        
        docker exec -it f5-cli f5 bigip extension do verify

    2.3. configure DO for BIG-IP2:
        
        docker exec -it f5-cli f5 bigip extension do create --declaration /f5-cli/projects/UDF-DevOps-Base/declarations/bigip2.do.json


## Testing

Your BIG-IPs are now ready to accept AS3 declarations.