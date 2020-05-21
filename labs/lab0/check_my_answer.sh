#!/bin/bash
echo "Check bigip1.do.json"
jq '.Common | del(.class) | map(select(.class == "User")) | .[].shell == "bash"' bigip1.do.json
echo "Check bigip2.do.json"
jq '.Common | del(.class) | map(select(.class == "User")) | .[].shell == "bash"' bigip2.do.json