## Overview

This repository provides the base components required to setup a DevOps base lab in the F5 Unified Demo Framework.  This lab can be used to practice and created automation and DevOps content. 

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

## Setup: 

View the [lab documentation](https://f5devcentral.github.io/UDF-DevOps-Base/).

## Support
For support, please open a GitHub issue.  Note, the code in this repository is community supported and is not supported by F5 Networks.  For a complete list of supported projects please reference [SUPPORT.md](support.md).

## Community Code of Conduct
Please refer to the [F5 DevCentral Community Code of Conduct](code_of_conduct.md).


## License
[Apache License 2.0](LICENSE)

## Copyright
Copyright 2014-2020 F5 Networks Inc.


### F5 Networks Contributor License Agreement

Before you start contributing to any project sponsored by F5 Networks, Inc. (F5) on GitHub, you will need to sign a Contributor License Agreement (CLA).

If you are signing as an individual, we recommend that you talk to your employer (if applicable) before signing the CLA since some employment agreements may have restrictions on your contributions to other projects.
Otherwise by submitting a CLA you represent that you are legally entitled to grant the licenses recited therein.

If your employer has rights to intellectual property that you create, such as your contributions, you represent that you have received permission to make contributions on behalf of that employer, that your employer has waived such rights for your contributions, or that your employer has executed a separate CLA with F5.

If you are signing on behalf of a company, you represent that you are legally entitled to grant the license recited therein.
You represent further that each employee of the entity that submits contributions is authorized to submit such contributions on behalf of the entity pursuant to the CLA.