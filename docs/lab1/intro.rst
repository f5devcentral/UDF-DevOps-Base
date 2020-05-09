============
F5 CLI Demo
============

Overview
--------
In this demo we will deploy applications to the F5 BIG-IP
using the new `F5 CLI`_

Prerequisites
-------------
1. Access to the F5 Unified Demo Framework (UDF)
2. Chrome browser
3. Finished the Setup Process in the `UDF DevOps Base documentation`_

Environment
-----------
In this lab we will deploy an HTTP application on the F5 BIG-IP.  This lab will
leverage the following F5 components:

* `F5 BIG-IP`_
* `F5 Automation Toolchain`_
* `F5 CLI`_

Setup
-----
1. Ensure you have the latest version of the code from GitHub

  .. code-block:: bash

    cd ~/projects/UDF-DevOps-Base
    git pull

2. Launch the F5 CLI Docker container docker

  If you do not have an instance of the F5 CLI docker container running then:

  .. code-block:: bash

    run -it -v "$HOME/.f5_cli:/root/.f5_cli" -v "$(pwd):/f5-cli" f5devcentral/f5-cli:latest /bin/bash
    cd /f5-cli/projects/labs/lab1

  Otherwise, attack to your running instance of the F5 CLI container

3. login to the BIG-IP

  .. code-block:: bash

    f5 login --authentication-provider bigip --host 10.1.1.6 --user admin --password $bigip_pwd

4. Verify the Application Service 3 Extension is installed

  .. code-block:: bash

    f5 bigip extension as3 verify

5. Issue AS3 Declaration

  .. code-block:: bash

    f5 bigip extension as3 create --declaration http.as3.json

Testing
-------
For testing we will use Chef InSpec_.
This tool is commonly used in automated deployments and offers
a wide variaty of both infrastructure and application testing options.

Test that the deployment was successful

  .. note:: 

    If you are still in the F5 CLI container, you will need to either exit or open a new terminal

  .. code-block:: bash

    cd ~/projects/UDF-DevOps-Base/labs/lab1
    inspec exec test/app

Cleanup
-------
To cleanup the lab we need to remove the AS3 declaration deployed to the BIG-IP

.. code-block:: bash

  f5 bigip extension as3 delete --auto-approve


.. _F5 CLI: https://clouddocs.f5.com/sdk/f5-cli/
.. _UDF DevOps Base documentation: https://udf-devops-base.readthedocs.io/en/latest/
.. _F5 BIG-IP: https://www.f5.com/products/big-ip-services/virtual-editions
.. _F5 Automation Toolchain: https://www.f5.com/products/automation-and-orchestration
.. _InSpec: https://www.inspec.io/
