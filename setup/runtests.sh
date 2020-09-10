#!/bin/bash

echo "------------ TESTING BIGIPS ------------"

as3_version=3.22.0
do_version=1.15.0
ts_version=1.14.0
fast_version=1.3.0
for i in {6..7} 
do
    inspec exec tests/bigips --input bigip_address=10.1.1.6 password=$BIGIP_PWD \
    do_version=$do_version as3_version=$as3_version ts_version=$ts_version \
    fast_version=$fast_version
done

echo "------------ TESTING APP SERVERS ------------"
inspec exec tests/appservers

echo "------------ TESTING CLIENT SERVER ------------"
inspec exec tests/clientserver