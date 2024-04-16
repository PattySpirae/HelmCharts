#!/bin/bash
 
# Prompt the user to input the username
read -p "Enter the username: " username
 
# Check if username is provided
if [ -z "$username" ]; then
	echo "Error: Username cannot be empty."
	exit 1
fi
cp wmw/values.yaml.1 wmw/values.yaml
# Install the Helm chart with the provided username
sed -i "s|{{ .Values.username }}|$username|g" wmw/values.yaml
helm install "$username" wmw --set username="$username"