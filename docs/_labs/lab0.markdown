---
name: Lab0
title: Lab0 - Initial Setup
description: Initial setup of the UDF deployment.  In this lab you will install the F5 Automation Toolchain (ATC) and F5 Application Service Templates (FAST) extensions.  Next, you will onboard the BIG-IP using the F5-CLI and Declarative Onboarding. 
layout: lab
edit_date: 05/21/2020
lab_time: 20 mins
tags: 
    - f5-cli
    - DO
---
## Setup

1. Log in to the [Unified Demo Framework Portal](https://udf.f5.com)
2. Deploy the DevOps Base blueprint

    > **Note:** For more information on deploying a UDF blueprint, please reference the [UDF documentation](https://help.udf.f5.com/en/)
3. Under components, click the access dropdown on the client system, then click VS CODE
4. Open a new [terminal](https://code.visualstudio.com/docs/editor/integrated-terminal) in VS Code
5. Start the F5 CLI Docker container and make sure it's running
    
    ```bash 
    docker start f5-cli
    docker ps
    ```

    You should now see a container named _f5-cli_ with an image source of _f5devcentral/f5-cli:latest_

6. Set the BIG-IP password as an environment variable:

    > **Note:** Obtain the BIG-IP password on the BIG-IP1 and BIG-IP2 documentation pages inside the UDF deployment
        
    ```bash
    export bigip_pwd=replaceme
    ```

7. Fork the UDF-Devops-Base repository

    The labs for this UDF blueprint can be found on [GitHub](https://github.com/F5SolutionsEngineering/UDF-DevOps-Base).  You will need to fork this repository into your own GitHub environmnent. 
    
    For information on how to do this, please visit the [GitHub documentation page](https://help.github.com/en/github/getting-started-with-github/fork-a-repo#fork-an-example-repository).

8. Checkout Forked Repository

    To conduct the labs, you will need to check our your forked version of the repository:

    ```bash
    cd ~/projects

    # replace your GitHub username
    git clone https://github.com/<githubusername>/UDF-DevOps-Base.git
    ```

9. Get Latest Version of the Lab

    The labs in the UDF-DevOps-Base repository are constantly being updated and new labs are being added.  If it has been awhile since you forked the repository then now is a good time to update your local copy:

    ```bash
    git remote add upstream https://github.com/F5SolutionsEngineering/UDF-DevOps-Base.git
    git fetch upstream
    git merge upstream/master
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
    export fast_version=1.0.0
    ```

2. Install ATC on BIG-IP1 and BIG-IP2:

    The client machine has the F5-CLI docker container installed.  We will use this container to install and interact with the 

    > **Note**: If the F5-CLI Docker container is not running, start it with the 'docker start f5-cli' command
    
    ```bash
    for i in {6..7} 
    do
        # authenticate to the BIG-IP
        docker exec -it f5-cli f5 login --authentication-provider bigip --host 10.1.1.$i --user admin --password $bigip_pwd

        # install the do, as3 and ts extensions
        docker exec -it f5-cli f5 bigip extension do install --version $do_version
        docker exec -it f5-cli f5 bigip extension as3 install --version $as3_version
        docker exec -it f5-cli f5 bigip extension ts install --version $ts_version
    done
    ```

2. Install FAST on BIG-IP1 and BIG-IP2:

    ```bash
    for i in {6..7} 
    do
        # move to a temporary directory 
        cd /tmp

        # set the FAST RPM name
        FN=f5-appsvcs-templates-1.0.0-1.noarch.rpm
        
        # download the FAST RPM
        wget https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v$fast_version/$FN
        
        # set information for curl
        CREDS=admin:$bigip_pwd
        IP=10.1.1.$i
        LEN=$(wc -c $FN | awk 'NR==1{print $1}')

        # upload the FAST RPM
        curl -kvu $CREDS https://$IP/mgmt/shared/file-transfer/uploads/$FN \
        -H 'Content-Type: application/octet-stream' \
        -H "Content-Range: 0-$((LEN - 1))/$LEN" -H "Content-Length: $LEN" \
        -H 'Connection: keep-alive' --data-binary @$FN

        # install the FAST RPM
        DATA="{\"operation\":\"INSTALL\",\"packageFilePath\":\"/var/config/rest/downloads/$FN\"}"
        curl -kvu $CREDS "https://$IP/mgmt/shared/iapp/package-management-tasks" \
        -H "Origin: https://$IP" -H 'Content-Type: application/json;charset=UTF-8' --data $DATA
    done
    ```

## Test the ATC and FAST Extensions
An important, but often overlooked, part of automation is the creation of test cases to ensure the automation achieved the desired outcome. In this lab, we will leverage the Chef [InSpec][InSpec] tool.  InSpec is based on Ruby and provides a framework to test infrastructure deployed in a public or private cloud.

> **Note:** You should see the InSpec test run twice, once for each BIG-IP, and all tests should be green.

```bash
cd ~/projects/UDF-DevOps-Base/labs/lab0
for i in {6..7} 
do
    inspec exec https://github.com/F5SolutionsEngineering/big-ip-atc-ready.git \
    --input bigip_address=10.1.1.$i password=$bigip_pwd do_version=$do_version \
    as3_version=$as3_version ts_version=$ts_version fast_version=$fast_version
done
```

## Onboard the BIG-IP

Now that the BIG-IP1 and BIG-IP2 ATC and FAST extension tests have passed, it's time to perform the onboarding steps.  To onboard the BIG-IP appliances we will leverage the F5 Automation Toolchain's [Declarative Onboarding][DO] extension.

1. Examine the DO declaration

    Open the _bigip1.do.json_ declaration and examine the onboarding settings.  Some settings to note:

      * how the hostname is set
      * how the name servers are set
      * how BIG-IP modules are provisioned
      * how VLANS and Self-IPs are configured

2. Add a Default User Shell

    While the provided DO declaration is a good starting point, it is missing one important configuration that allows us to run InSpec tests against the BIG-IP.  The admin user needs to have a bash shell instead of the default TMSH shell. 

    2.1. For this step, I want you to use the [Declarative Onboarding][DO] documentation located on [clouddocs.f5.com](https://clouddocs.f5.com) to set the admin user's default shell to bash.

      > **Hint:** The DO schema object you need to add is _User_

    2.2. When you're ready to test your solution run the following command:
    
      > **Note:** the test should output true for each declaration

      ```bash
      bash check_my_answer.sh
      ``` 

    If you are stuck on this exercise, there is an example<sup>[1](#doexample)</sup> in the [Declarative Onboarding][DO] documentation.

    Once you have updated the admin user's default shell in both _bigip1.do.json_ and _bigip2.do.json_ files and the test script passes you are ready to proceed to the next step. 

3. Onboard BIG-IP1 and BIG-IP1:

    ```bash
    COUNTER=1
    for i in {6..7}
    do  
        # authenticate to the BIG-IP
        docker exec -it f5-cli f5 login --authentication-provider bigip \
        --host 10.1.1.$i --user admin --password $bigip_pwd

        # POST the DO declaration
        docker exec -it f5-cli f5 bigip extension do create --declaration \
        /f5-cli/projects/UDF-DevOps-Base/labs/lab0/bigip$COUNTER.do.json

        # increment counter
        let COUNTER=COUNTER+1
    done
    ```

4. Test the Onboarding Process

    Run the following InSpec profile to test that the BIG-IP is correctly configured:

    > **Note:** You should see the InSpec test run twice, once for each BIG-IP, and all tests should be green.

    ```bash
    for i in {6..7}
    do
      inspec exec do-ready -t ssh://admin@10.1.1.$i --password=$bigip_pwd \
      --input internal_sip=$10.1.10.$i external_sip=10.1.20.$i 
    done
    ```

[DO]: https://clouddocs.f5.com/products/extensions/f5-declarative-onboarding/latest/

## Conclusion
You have successfully completed Lab0 and your environment is now ready to run other labs.  Have fun and good luck!

---

#### Footnotes:
<small><a name="doexample">1</a>: Declarative Onboarding example of setting the admin users shell can be found [here](https://clouddocs.f5.com/products/extensions/f5-declarative-onboarding/latest/bigip-examples.html?highlight=bash#standalone-declaration).  Note, you do not need the password attribute from this example. <small>
