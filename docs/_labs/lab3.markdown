---
name: Lab3
title: Lab3 - F5 Application Service Templates
description: F5 Application Services Templates (FAST) are an easy and effective way to deploy applications on the BIG-IP system using AS3. The FAST Extension provides a toolset for templating and managing AS3 Applications on BIG-IP.
layout: lab
edit_date: 05/21/2020
lab_time: 20 mins
tags: 
    - fast
    - AS3
---
## Overview

In this lab, we will leverage F5 Application Service Templates ([FAST][FAST]), to help streamline application deployments.

## Prerequisites

1. Access to the F5 Unified Demo Framework (UDF)
2. Chrome browser
3. Finished the Lab0 setup process in the [UDF DevOps Base documentation][UDF DevOps Base documentation]

## Environment

In this lab, we will deploy two HTTP applications on the F5 BIG-IP.  This lab will
leverage the following components and tools:

* [F5 BIG-IP][F5 BIG-IP]
* [F5 Automation Toolchain][F5 Automation Toolchain]
* [FAST Extension][FAST]
* [InSpec][InSpec]

## Deploy Our First Application
Ensure you have the latest version of the lab from GitHub then open the lab3 folder:

  ```bash
  cd ~/projects/UDF-DevOps-Base
  git pull
  cd labs/lab3
  ```

Ensure FAST is running and read:

  ```bash
  curl -sku admin:$bigip_pwd  https://10.1.1.6/mgmt/shared/fast/info | jq
  ```

## Exploring FAST templates

FAST provides some default templates to get you started:
* HTTP/HTTPS
* TCP
* UDP
* Simple WAF

In this lab, we will take a look at the HTTP templates. 

1. Create _lab3a.json_, this will be our POST payload:
  ```json
    {
      "name": "bigip-fast-templates/http",
      "parameters": {
        "tenant_name": "demo",
        "app_name": "lab3a",
        "virtual_address": "10.1.20.20",
        "virtual_port": 80,
        "enable_pool": true, 
        "pool_members": ["10.1.10.5", "10.1.10.10"],
        "pool_port": 80,
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
  ```

  In this YAML file, we're setting the following variables:

  * Tenant Name
  * App Name
  * Virtual Address
  * Virtual Port
  * Pool members
  * Pool port
  * everything else is a required attribute of this template

2. Post the payload:

  ```bash
  # replace with your BIG-IP password
  export bigip_pwd=enteryourpassword

  fast_task_id=$(curl -sku admin:$bigip_pwd  https://10.1.1.6/mgmt/shared/fast/applications -X POST --header "Content-Type: application/json" -d "@lab3a.json" | jq '.message[0].id' -r)
  ```

3. Check the response:

  ```bash
  curl -sku admin:$bigip_pwd  https://10.1.1.6/mgmt/shared/fast/tasks/$fast_task_id
  ```

    You should see a 200 response if everything was successful.

Congratulations, you have now deployed your first FAST application!! 

One of the advantages FAST templates have over native AS3 is that FAST manages compiling all the applications of a tenant together when building the AS3 declaration.  For customers that are new to automation, FAST provides an ideal starting point.  We'll take a look at this in the next section.

## Deploy Our Second Application
A unique feature of FAST is that it treats each application separately, and it will handle stitching everything together to build a proper AS3 declaration.  

In this exercise, we will deploy our second application on port 8080.


1. Create _lab3b.json_, this will be our POST payload:

  ```json
  {
    "name": "bigip-fast-templates/http",
    "parameters": {
      "tenant_name": "demo",
      "app_name": "lab3b",
      "virtual_address": "10.1.20.20",
      "virtual_port": 8080,
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
  ```

  Everything in this data file looks similar to lab3a except for the _virtual_port_ and the _pool_port_.  You could further simplify this type of deployment by building your own templates that remove some of the common attributes that do not apply to your environment.

2. Post the payload:

  ```bash
  fast_task_id=$(curl -sku admin:$bigip_pwd  https://10.1.1.6/mgmt/shared/fast/applications -X POST --header "Content-Type: application/json" -d "@lab3b.json" | jq '.message[0].id' -r)
```

3. Check the response:

  ```bash
  curl -sku admin:$bigip_pwd  https://10.1.1.6/mgmt/shared/fast/tasks/$fast_task_id
  ```

## Testing

For testing we will use Chef [InSpec][InSpec].
This tool is commonly used in automated deployments and offers
a wide variety of both infrastructure and application testing options.

Test that the deployment was successful:

```bash
cd ~/projects/UDF-DevOps-Base/labs/lab3
inspec exec test/app
```

## Cleanup

To cleanup the environment, we'll remove the two applications we deployed:

```bash
curl -sku admin:$bigip_pwd -X DELETE https://10.1.1.6/mgmt/shared/fast/applications/demo/lab3a
curl -sku admin:$bigip_pwd -X DELETE https://10.1.1.6/mgmt/shared/fast/applications/demo/lab3b 
```


[F5 CLI]: https://clouddocs.f5.com/sdk/f5-cli/
[UDF DevOps Base documentation]: https://udf-devops-base.readthedocs.io/en/latest/
[F5 BIG-IP]: https://www.f5.com/products/big-ip-services/virtual-editions
[F5 Automation Toolchain]: https://www.f5.com/products/automation-and-orchestration
[InSpec]: https://www.inspec.io/
[FAST]: https://clouddocs.f5.com/products/extensions/f5-appsvcs-templates/latest/