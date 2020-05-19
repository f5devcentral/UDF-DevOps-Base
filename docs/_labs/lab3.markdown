---
name: Lab3
title: Lab3 - F5 Application Service Templates
description: F5 Application Services Templates (FAST) are an easy and effective way to deploy applications on the BIG-IP system using AS3.
The FAST Extension provides a toolset for templating and managing AS3 Applications on BIG-IP.
layout: page
tags: 
    - fast
    - AS3
---
## Overview

In this lab, we will leverage F5 Application Service Templates ([FAST][FAST], to help streamline application deployments.

## Prerequisites

1. Access to the F5 Unified Demo Framework (UDF)
2. Chrome browser
3. Finished the Lab0 setup process in the [UDF DevOps Base documentation][UDF DevOps Base documentation]

## Environment

In this lab we will deploy an HTTP application on the F5 BIG-IP.  This lab will
leverage the following components:

* [F5 BIG-IP][F5 BIG-IP]
* [F5 Automation Toolchain][F5 Automation Toolchain]
* [FAST Extension][FAST]I]
* [InSpec][InSpec]

## Setup
Ensure you havce the latest version of the lab from GitHub then open the lab2 folder:

    cd ~/projects/UDF-DevOps-Base
    git pull
    cd labs/lab3

Ensure FAST is running and read:

        curl -sku admin:$bigip_pwd  https://10.1.1.6/mgmt/shared/fast/info | jq

## Exploring FAST templates

FAST provides some default templates to get you started:
* HTTP/HTTPS
* TCP
* UDP
* Simple WAF

In this lab we will take a look at the HTTP templates. 

1. Create lab3a.json, this will be our POST payload:

        {
          "name": "bigip-fast-templates/http",
          "parameters": {
            "tenant_name": "demo",
            "app_name": "lab3a",
            "virtual_address": "10.1.20.20",
            "virtual_port": 443,
            "enable_pool": true, 
            "pool_members": ["10.1.10.5", "10.1.10.10"],
            "pool_port": 8080,
            "enable_snat": false, 
            "enable_tls_server": false, 
            "enable_tls_client": false, 
            "make_http_profile": false, 
            "enable_persistence": false, 
            "enable_acceleration": false, 
            "enable_compression": false, 
            "enable_multiplex": false
          }
        }

2. Post the payload:

        export bigip_pwd=enteryourpassword
        fast_task_id=$(curl -sku admin:$bigip_pwd  https://10.1.1.6/mgmt/shared/fast/applications -X POST --header "Content-Type: application/json" -d "@lab3a.json" | jq '.message[0].id' -r)

3. Check the response:

        curl -sku admin:$bigip_pwd  https://10.1.1.6/mgmt/shared/fast/tasks/$fast_task_id


## Cleanup

TBD


[F5 CLI]: https://clouddocs.f5.com/sdk/f5-cli/
[UDF DevOps Base documentation]: https://udf-devops-base.readthedocs.io/en/latest/
[F5 BIG-IP]: https://www.f5.com/products/big-ip-services/virtual-editions
[F5 Automation Toolchain]: https://www.f5.com/products/automation-and-orchestration
[InSpec]: https://www.inspec.io/
[FAST]