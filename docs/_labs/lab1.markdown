---
name: Lab1
title: Lab1 - F5 CLI Demo
description: Demonstrates the new F5 CLI to configure an application on the BIG-IP.
layout: page
tags: 
    - f5-cli
    - AS3
---
## Overview

In this demo we will deploy applications to the F5 BIG-IP
using the new [F5 CLI][F5 CLI].

## Prerequisites

1. Access to the F5 Unified Demo Framework (UDF)
2. Chrome browser
3. Finished the Setup Process in the [UDF DevOps Base documentation][UDF DevOps Base documentation]

## Environment

In this lab we will deploy an HTTP application on the F5 BIG-IP.  This lab will
leverage the following F5 components:

* [F5 BIG-IP][F5 BIG-IP]
* [F5 Automation Toolchain][F5 Automation Toolchain]
* [F5 CLI][F5 CLI]

## Setup

1. Ensure you have the latest version of the code from GitHub

        cd ~/projects/UDF-DevOps-Base
        git pull

2. Set the BIG-IP password as an environment variable:

    > **NOTE**: The BIG-IP password can be found on the BIG-IP1 and BIG-IP2 documentation pages inside the UDF deployment

        export bigip_pwd=replaceme

3. login to the BIG-IP (using the F5-CLI container)

    > **Note**: If the F5-CLI container is not running, start is with the 'docker start nifty_nash' command 
        
        docker exec -it nifty_nash f5 login --authentication-provider bigip --host 10.1.1.6 --user admin --password $bigip_pwd

4. Verify the Application Service 3 Extension is installed

        docker exec -it nifty_nash f5 bigip extension as3 verify

5. Issue AS3 Declaration

        docker exec -it nifty_nash f5 bigip extension as3 create --declaration /f5-cli/labs/lab1/http.as3.json
6. Edit the docker container

        exit

## Testing

For testing we will use Chef InSpec_.
This tool is commonly used in automated deployments and offers
a wide variaty of both infrastructure and application testing options.

Test that the deployment was successful:

  > **NOTE**: If you are still in the F5 CLI container, you will need to either exit or open a new terminal

    cd ~/projects/UDF-DevOps-Base/labs/lab1
    inspec exec test/app

While InSpec has proven that the application is working some of you
are still itching to check it in the browser... so we have included
a containered version of Firefox to view applications inside our
test environment.

1. In the UDF Components list, Click the Access dropdowm on the Client System
2. Click FIREFOX
3. In the Firefox browser, enter http://10.1.20.20 in the address bar

You should now see the NGINX demo application.

## Cleanup

To cleanup the lab we need to remove the AS3 declaration deployed to the BIG-IP.  Run the following command in the f5-cli docker container

    docker exec -it nifty_nash f5 bigip extension as3 delete --auto-approve


[F5 CLI]: https://clouddocs.f5.com/sdk/f5-cli/
[UDF DevOps Base documentation]: https://udf-devops-base.readthedocs.io/en/latest/
[F5 BIG-IP]: https://www.f5.com/products/big-ip-services/virtual-editions
[F5 Automation Toolchain]: https://www.f5.com/products/automation-and-orchestration
[InSpec]: https://www.inspec.io/