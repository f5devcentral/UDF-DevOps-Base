---
name: Lab2
title: Lab2 - Jinja2 Templates
description: Demonstrates the ability of Jinja2 to create dynamic AS3 declarations.  While this lab uses the F5-CLI, the same logic applies when using Jinaj2 with Ansible. 
layout: lab
edit_date: 05/21/2020
lab_time: 20 mins
tags: 
    - f5-cli
    - AS3
    - jinja2
---
## Overview

In this lab, we leverage [Jinja2](https://jinja.palletsprojects.com/en/2.11.x/), a powerful template engine, to generate dynamic AS3 declarations.  A few advantages dynamic template provide you and your team:

#### Code Reuse 
A common development mistake made at the beginning of your automation journey is to repeat logic.  While this may seem harmless, it can lead to unexpected results, and tedious refactor efforts when small changes are required.  Principals like Don't Repeat Yourself ([DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)) can help you avoid this common mistake.  We will implement the DRY method by using Jinja2 templates. 

#### Simplified Logic
As you implement DRY in your automation projects, you may find that some templates are complex and hard to read.  Jinja2 can leverage [include statements](https://jinja.palletsprojects.com/en/2.11.x/templates/#include) to break your templates down into smaller components.  

#### Extensibility
Ideally, you will start your automation path by offering a few common deployment patterns such as HTTP, HTTPS, TCP, and UDP.  As your skills grow, you will find it easier to extend your deployment patterns to include new offerings with minimal effort.  The ease of adding new services is the result of building your automation foundation on templates and the DRY principal. 

## Prerequisites

1. Access to the F5 Unified Demo Framework (UDF)
2. Chrome browser
3. Finished the Lab0 setup process in the [UDF DevOps Base documentation][UDF DevOps Base documentation]

## Environment

In this lab, we will deploy two HTTP applications on the F5 BIG-IP.  This lab will
leverage the following components and tools:

* [F5 BIG-IP][F5 BIG-IP]
* [F5 Automation Toolchain][F5 Automation Toolchain]
* [F5 CLI][F5 CLI]
* [Jinja2 CLI][Jinja2 CLI]
* [InSpec][InSpec]

## Setup
Ensure you have the latest version of the lab from GitHub then open the lab2 folder:

    cd ~/projects/UDF-DevOps-Base
    git pull
    cd labs/lab2

## Create AS3 Declaration

1. Create a YAML data file called _lab2a.yml_ in the lab2 directory:

    ```yaml
    virtualAddresses: 10.1.20.20
    serverAddresses: 10.1.10.5
    ```

2. Open the lab2a.as3.j2 template file and examine it.
    
    * It should look familiar to the declaration from lab1 
    * What type of application are we deploying?
    * What port will the BIG-IP Virtual Server use?
    * What port will the pool members listen on?

3. Create the AS3 declaration using Jinja2:

    ```bash
    jinja2 lab2a.as3.j2 lab2a.yml > lab2a.as3.json
    ```

4. Open the new AS3 declaration in VS Code and examine it:

    * Similar to the declaration from lab1 

        ```
        diff lab2a.as3.json ../lab1/http.as3.json
        ```
    * Virtual Server IP now set
    * Pool member IP now set

Congratulations, you have created your Jinja2 template and AS3 declaration!  However, you have undoubtedly noticed that this declaration does not scale or work well in a production environment due to static assignments.  Let's fix that!

## Looping over Variables

To make our Jinja2 template a little more useful, we are going to introduce [Jinja filters](https://jinja.palletsprojects.com/en/2.11.x/templates/#filters).  The filter allows us to add multiple virtual addresses and pool members.

1. Create a new yaml data file called _lab2b.yml_:

    ```yaml
    virtualAddresses:
        - 10.1.20.20
    serverAddresses:
        - 10.1.10.5
        - 10.1.20.10
    ```

2. Create the AS3 declaration using Jinja2

    ```bash
    jinja2 lab2b.as3.j2 lab2b.yml > lab2b.as3.json
    ```

3. Open the AS3 declaration and examine it:

    * virtualAddresses now supports the correct data type based on the AS3 schema
    * serverAddresses now supports the correct data type based on the AS3 schema
    * You can now dynamically added and removed by modifying the data file

## Multiple Applications
Now we will extend the Jinja2 template to support multiple applications under the demo tenant.

1. Create a new yaml data file called _lab2c.yml_:

    ```yaml
    apps: 
    - 
        name: test1.f5demos.com
        serverAddresses: 
        - "10.1.10.5"
        - "10.1.10.10"
        servicePort: 80
        virtualAddresses: 
        - "10.1.20.20"
        virtualPort: 80
    - 
        name: test2.f5demos.com
        serverAddresses: 
        - "10.1.10.5"
        - "10.1.10.10"
        servicePort: 8080
        virtualAddresses: 
        - "10.1.20.20"
        virtualPort: 8080
    ```

2. Create the AS3 declaration using Jinja2

    ```bash
    jinja2 lab2c.as3.j2 lab2c.yml > lab2c.as3.json
    ```

3. Open the AS3 declaration and examine it:

    * You should see multiple applications under the demo tenant
        * test1.f5demos.com should listen on port 80
        * test2.f5demos.com should listen on port 8080
        
At this point, we are closer to what a production example would look like.  However, what happens when we add a new deployment type?    Let's take a look at that next.

## DRY in Action
So far, we have created two HTTP applications using Jinaj2 and AS3.  However, if we add another deployment type, say TCP, we will start repeating code between the templates.  We can fix this by breaking up our existing template into smaller components.  

1. Create a new data file called _lab2d.yml_:

    ```yaml
    apps: 
    - 
        name: test1.f5demos.com
        type: http
        serverAddresses: 
        - "10.1.10.5"
        - "10.1.10.10"
        servicePort: 80
        virtualAddresses: 
        - "10.1.20.20"
        virtualPort: 80
    - 
        name: test2.f5demos.com
        type: http
        serverAddresses: 
        - "10.1.10.5"
        - "10.1.10.10"
        servicePort: 8080
        virtualAddresses: 
        - "10.1.20.20"
        virtualPort: 8080
    ```

2. Examine the two template files:
    * _lab2d-tenant.as3.j2_ - creates the Tenant class
    * _lab2d-http.as3.j2_ - creates the HTTP classes

3. Create the AS3 declaration using Jinja2

    ```bash
    jinja2 lab2d-tenant.as3.j2 lab2d.yml > lab2d.as3.json
    ```
4. Open the AS3 declaration and examine it:

    * You should see multiple applications under the demo tenant
        * test1.f5demos.com should listen on port 80
        * test2.f5demos.com should listen on port 8080

## Issue AS3 Declaration to BIG-IP

1. Set the BIG-IP password as an environment variable:

    > **NOTE**: The BIG-IP password can be found on the BIG-IP1 and BIG-IP2 documentation pages inside the UDF deployment

    ```bash
    export bigip_pwd=replaceme
    ```

2. login to the BIG-IP (using the F5-CLI container)

    > **Note**: If the F5-CLI container is not running, start it with the 'docker start f5-cli' command 
        
    ```bash
    docker exec -it f5-cli f5 login --authentication-provider bigip --host 10.1.1.6 --user admin --password $bigip_pwd
    ```


3. Verify the Application Service 3 Extension is installed

    ```bash
    docker exec -it f5-cli f5 bigip extension as3 verify
    ```

4. Issue AS3 Declaration

    ```bash
    docker exec -it f5-cli f5 bigip extension as3 create --declaration /f5-cli/projects/UDF-DevOps-Base/labs/lab2/lab2d.as3.json
    ```

## Testing

For testing, we will use Chef [InSpec][InSpec].
This tool is commonly used in automated deployments and offers
a wide variety of both infrastructure and application testing options.

Test that the deployment was successful:

```bash
cd ~/projects/UDF-DevOps-Base/labs/lab2
inspec exec test/app
```

## Cleanup

To cleanup the lab, we need to remove the AS3 declaration deployed to the BIG-IP.  Run the following command in the f5-cli docker container

```bash
docker exec -it f5-cli f5 bigip extension as3 delete --auto-approve
```


[F5 CLI]: https://clouddocs.f5.com/sdk/f5-cli/
[UDF DevOps Base documentation]: https://udf-devops-base.readthedocs.io/en/latest/
[F5 BIG-IP]: https://www.f5.com/products/big-ip-services/virtual-editions
[F5 Automation Toolchain]: https://www.f5.com/products/automation-and-orchestration
[InSpec]: https://www.inspec.io/
[Jinja2 CLI]: https://pypi.org/project/jinja2-cli/