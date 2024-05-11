
# Microservice1

## Overview

This repository contains the infrastructure configuration, deployment files, and GitHub Actions workflows for Microservice1, a component of a larger microservices architecture.

### Infrastructure Setup

The Terraform scripts included in this repository are responsible for setting up the infrastructure components needed to deploy Microservice1 to an AKS (Azure Kubernetes Service) cluster. The setup includes the following components:

- **Provider and Terraform Settings**: Configuration for the required providers and versions.
- **Resource Group**: Creation of a resource group to contain all the resources.
- **Virtual Network and Subnet**: Definition of a virtual network and subnet specifically for the AKS cluster.
- **AKS Cluster**: Provisioning of an AKS cluster with a system-assigned identity and Calico network policy for enhanced security and performance.
- **Azure Container Registry (ACR)**: Optional creation of an ACR for storing private Docker images.

### Deployment YAMLs

The deployment YAML files define the deployment settings for Microservice1's frontend applications. These files specify the number of replicas, container specifications, and resource limits. The frontend listens on port 3000.

### Service YAMLs

The service YAML files define Kubernetes services to expose the applications. The frontend service exposes port 5000, both using a LoadBalancer to allow external access.

**Note:** Ensure to replace `<your_acr_name>` with the actual name of your Azure Container Registry and adjust the image tags as necessary. These files should be placed in a directory (e.g., `k8s/`) and referenced in your CI/CD pipeline for deployment to AKS.

## GitHub Actions Workflow

The GitHub Actions workflow included in this repository automates the process of building Docker images and deploying Microservice1 to the AKS cluster. Here's a breakdown of the workflow steps:

1. **Build and Push Docker Images**: Uses the `docker/build-push-action@v2` action to build the Docker image from the specified Dockerfile (`./Dockerfile.backend`) and context (current directory `.`). It tags the built image with the provided tag (`${{ secrets.ACR_NAME }}.azurecr.io/yourbackendapp:latest`) and pushes it to the specified Azure Container Registry (ACR).
  
2. **Deploy to AKS**: After the Docker image is pushed to ACR, the workflow triggers the deployment job. It checks out the code again, sets up the Azure CLI with the necessary credentials, initializes and applies Terraform for infrastructure setup, installs `kubectl` using the Azure CLI to interact with the Kubernetes cluster, and updates the Kubernetes deployment by applying the YAML files in the `k8s/` directory, which reference the newly pushed Docker image.

This workflow streamlines the process of building, pushing, and deploying Microservice1 to the AKS cluster, ensuring efficient continuous integration and deployment.
