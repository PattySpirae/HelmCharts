#!/bin/bash

# Prompt for username and node name
read -p "Enter installation name: " username
read -p "Enter installation location: " nodeName

# Validate user input
if [ -z "$username" ] || [ -z "$nodeName" ]; then
  echo "Error: Installation name and/or location cannot be empty."
  exit 1
fi

# Add entry to /etc/hosts file
echo "10.43.251.91    ${username}-wmw.local" | sudo tee -a /etc/hosts > /dev/null


# Create a copy of values.yaml (avoid modifying original)
cp /home/mgkmaster/HelmCharts/helm/wmw/values.yaml.1 /home/mgkmaster/HelmCharts/helm/wmw/values.yaml

# Update values.yaml with nodeSelector
sed -i "s/location/$nodeName/" /home/mgkmaster/HelmCharts/helm/wmw/values.yaml

# Check if values.yaml was updated successfully
if [ $? -ne 0 ]; then
  echo "Error: Failed to update values.yaml."
  exit 1
fi

# Install the Helm chart
helm install "$username" wmw 

# Check if Helm installation was successful (optional)
if [ $? -ne 0 ]; then
  echo "Error: Helm installation failed."
fi

echo "Helm chart '$username' installed successfully on node '$nodeName'."
