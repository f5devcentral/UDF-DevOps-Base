#!/bin/bash
# Check that the user shell is set correctly in lab0
echo "Test user shell is set to bash: result should say true"
echo "Check bigip1.do.json"
jq '.Common | del(.class) | map(select(.class == "User")) | .[].shell == "bash"' bigip1.do.json
echo "Check bigip2.do.json"
jq '.Common | del(.class) | map(select(.class == "User")) | .[].shell == "bash"' bigip2.do.json