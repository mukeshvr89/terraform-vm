#!/bin/bash

# Set variables
RESOURCE_GROUP="my-resource-group"
VM_NAMES=("vm-0" "vm-1" "vm-2" "vm-3" "vm-4")  # Add all VM names here

# Function to start all VMs
start_vms() {
    for VM_NAME in "${VM_NAMES[@]}"; do
        echo "Starting VM: $VM_NAME..."
        az vm start --resource-group $RESOURCE_GROUP --name $VM_NAME
        echo "$VM_NAME started successfully!"
    done
}

# Function to stop all VMs
stop_vms() {
    for VM_NAME in "${VM_NAMES[@]}"; do
        echo "Stopping VM: $VM_NAME..."
        az vm stop --resource-group $RESOURCE_GROUP --name $VM_NAME
        echo "$VM_NAME stopped successfully!"
    done
}

# User input to choose action
echo "Choose an option:"
echo "1) Start all VMs"
echo "2) Stop all VMs"
read -p "Enter choice [1-2]: " choice

case $choice in
    1) start_vms ;;
    2) stop_vms ;;
    *) echo "Invalid option. Please enter 1 or 2." ;;
esac
