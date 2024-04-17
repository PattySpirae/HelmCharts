#!/bin/bash

# Prompt for username and node name
read -p "Enter the username (installation name): " username
read -p "Enter the target node name: " nodeName

# Validate user input
if [ -z "$username" ] || [ -z "$nodeName" ]; then
  echo "Error: Username and node name cannot be empty."
  exit 1
fi

# Create a copy of values.yaml (avoid modifying original)
cp wmw/values.yaml.1 wmw/values.yaml

# Update values.yaml with node name
sed -i "s/nodename: \"nodename\"/nodename: \"$nodeName\"/g" wmw/values.yaml

# Check if values.yaml was updated successfully
if [ $? -ne 0 ]; then
  echo "Error: Failed to update values.yaml."
  exit 1
fi

# Install the Helm chart
helm install "$username" wmw --set nodeSelector.node-name="$nodeName"

# Check if Helm installation was successful (optional)
if [ $? -ne 0 ]; then
  echo "Error: Helm installation failed."
fi

echo "Helm chart '$username' installed successfully on node '$nodeName'."
