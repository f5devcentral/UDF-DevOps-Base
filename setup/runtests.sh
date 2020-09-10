#!/bin/bash
as3_version=3.22.0-2
do_version=1.15.0-3
for i in {6..7} 
do
    inspec exec tests/bigips \
    --input bigip_address=10.1.1.$i password=$BIGIP_PWD do_version=$do_version \
    as3_version=$as3_version
done