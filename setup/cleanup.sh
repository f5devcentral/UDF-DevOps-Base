#!/bin/bash

# remove Git configurations
git config --global --unset user.name
git config --global --unset user.email

# remove projects
rm -rf ~/projects/*

# remove history
history -c