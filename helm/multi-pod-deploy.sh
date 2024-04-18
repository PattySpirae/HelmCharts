#!/bin/bash

# Define the three sets of variables
installations=(
  "sonic mgk1-virtual-machine"
  "charge mgk2-virtual-machine"
  "hertz mgk3-virtual-machine"
)

# Loop over the installations array
for installation in "${installations[@]}"; do
  # Split the installation string into username and nodeName
  IFS=' ' read -r username nodeName <<< "$installation"

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
    echo "Error: installation failed."
  fi

  echo "$username installed successfully on $nodeName."
done
