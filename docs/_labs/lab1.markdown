---
name: Lab1
title: Lab1 - F5 CLI Demo
description: Demonstrates the new F5 CLI to configure an application on the BIG-IP.
layout: lab
edit_date: 05/21/2020
lab_time: 15 mins
tags: 
    - f5-cli
    - AS3
---
## Overview

In this demo, we will deploy applications to the F5 BIG-IP
using the new [F5 CLI][F5 CLI].  The purpose of this lab is to demonstrate how to leverage the F5 Automation Toolchain without the need for a complementing tool like Ansible. 

## Prerequisites

1. Access to the F5 Unified Demo Framework (UDF)
2. Chrome browser
3. Finished the Setup Process in the [UDF DevOps Base documentation][UDF DevOps Base documentation]

## Environment

In this lab, we will deploy an HTTP application on the F5 BIG-IP.  This lab will
leverage the following components and tools:

* [F5 BIG-IP][F5 BIG-IP]
* [F5 Automation Toolchain][F5 Automation Toolchain]
* [F5 CLI][F5 CLI]
* [InSpec][InSpec]

## Setup

1. Ensure you have the latest version of the code from GitHub

        cd ~/projects/UDF-DevOps-Base
        git pull
        cd labs/lab1

2. Set the BIG-IP password as an environment variable:

    > **NOTE**: Obtain the BIG-IP password on the BIG-IP1 and BIG-IP2 documentation pages inside the UDF deployment

        export bigip_pwd=replaceme

3. login to the BIG-IP (using the F5-CLI container)

    > **Note**: If the F5-CLI Docker container is not running, start it with the 'docker start f5-cli' command 

    Let's examine the various components of this command:

    |Command|Description|
    |-------|-----------|
    | ```docker exec -it f5-cli``` | tells Docker to execute the following command in the f5-cli container |
    | ```f5 login``` | tell the F5 CLI to perform a login action |
    | ```--authentication-provider bigip``` | F5 CLI supports multiple F5 products, so this states we are targeting a BIG-IP instance|
    | ```--host 10.1.1.6``` | the BIG-IP instance, this can be an IP or hostname |
    | ```--user admin --password``` | the authentication information the F5 CLI will send to the BIG-IP|


    execute the following command in your terminal:
        
        docker exec -it f5-cli f5 login --authentication-provider bigip --host 10.1.1.6 --user admin --password $bigip_pwd
    
    You should see a message stating _"Logged in successfully"_

4. Verify the Application Service 3 Extension is installed

    This command also leverages the Docker exec feature, but we are now telling the F5 CLI to target a BIG-IP, obtain the version of AS3 installed and that AS3 is ready:

        docker exec -it f5-cli f5 bigip extension as3 verify

    We are looking for version 3.19.1 or higher in the response.

5. Examine the AS3 declaration

    Open the _http.as3.json_ AS3 declaration and determine the following things:

    * What type of application are we deploying?
    * What port will the BIG-IP Virtual Server use?
    * What port will the pool members listen on?


6. Issue AS3 Declaration

    The final step is to send the _http.as3.json_ AS3 declaration to the BIG-IP.  Again, this command leverages the Docker exec feature, but we are now telling the F5 CLI to create an AS3 application on the BIG-IP and to use the declaration located at _/f5-cli/projects/UDF-DevOps-Base/labs/lab1/http.as3.json_.  For more information, please reference the [F5-CLI documentation](https://clouddocs.f5.com/sdk/f5-cli/).

        docker exec -it f5-cli f5 bigip extension as3 create --declaration /f5-cli/projects/UDF-DevOps-Base/labs/lab1/http.as3.json

    You should receive a result code of 200.

## Testing

An important, but often overlooked, part of automation is the creation of test cases to ensure the automation achieved the desired outcome. In this lab, we will leverage the Chef [InSpec][InSpec] tool.  InSpec is based on Ruby and provides a framework to test infrastructure deployed in a public or private cloud.  InSpec tests are also natively supported in Azure compliance automation. 

### Test that the deployment was successful

  In this test, InSpec will check that the application at http://10.1.20.20 is accessible and contains the phrase "Hello World".

    cd ~/projects/UDF-DevOps-Base/labs/lab1
    inspec exec test/app

### Visual validation
While InSpec has proven that the application is working some of you
are still itching to check it in the browser... so we have included
a containerized version of Firefox to view applications inside our
test environment.

1. In the UDF Components list, Click the Access drop-down on the Client System
2. Click FIREFOX
3. In the Firefox browser, enter http://10.1.20.20 in the address bar

You should now see the NGINX demo application.

## Cleanup

To cleanup the lab, we need to remove the AS3 declaration deployed to the BIG-IP.  

This command leverages the Docker exec feature and tells the F5 CLI to target a BIG-IP then delete all AS3 declarations:

    docker exec -it f5-cli f5 bigip extension as3 delete --auto-approve


[F5 CLI]: https://clouddocs.f5.com/sdk/f5-cli/
[UDF DevOps Base documentation]: https://udf-devops-base.readthedocs.io/en/latest/
[F5 BIG-IP]: https://www.f5.com/products/big-ip-services/virtual-editions
[F5 Automation Toolchain]: https://www.f5.com/products/automation-and-orchestration
[InSpec]: https://www.inspec.io/