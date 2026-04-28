#!/bin/bash
set -e

# Azure Functions Core Tools (npm avoids apt repo architecture mismatch issues)
npm install -g azure-functions-core-tools@4

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
