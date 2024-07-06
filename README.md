# GitOps Demo Repository

This repository demonstrates a GitOps workflow using Terraform and GitHub Actions to manage the creation and deployment of Kubernetes clusters and applications.

## Table of Contents
- [GitOps Demo Repository](#gitops-demo-repository)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Directory Structure](#directory-structure)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Environment Configuration](#environment-configuration)
  - [GitHub Actions / Workflows](#github-actions--workflows)
    - [Repository Behavior](#repository-behavior)
    - [Workflows](#workflows)
  - [Contributing](#contributing)

## Overview

This repository contains Terraform configurations and GitHub Actions workflows to automate the provisioning and management of Kubernetes clusters and the deployment of applications to those clusters. The workflow is designed to ensure that infrastructure changes are safely managed and can be promoted from development to production environments.

## Directory Structure

```
.github
├── actions
│   ├── create-application
│   ├── create-cluster
│   ├── destroy-application
│   └── destroy-cluster
├── workflows
│   ├── deploy-infrastructure.yaml
│   ├── promote-branch.yaml
│   └── test-infrastructure.yaml
argocd-applications
├── app1
│   ├── dev
│   └── prod
terraform
├── applications
└── cluster
.gitignore
README.md
```

## Prerequisites

- AWS account with appropriate permissions to create S3 buckets, DynamoDB tables, and manage other resources.

Note: This setup uses AWS resources for demonstration, but it can be adapted to use any cloud provider that supports Terraform backend.

## Setup

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/gitops-demo.git
   cd gitops-demo
   ```

2. **Configure AWS Credentials:**
   Ensure that you have the following variables and secrets set in your GitHub repository settings:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_BUCKET`
   - `AWS_REGION`
   - `AWS_DYNAMODB_TABLE`

3. **Deploy Terraform Cluster:**
   ```sh
    cd terraform/cluster
    terraform init
   ```   
   
   ```sh
    terraform plan -var="cluster_name=your-cluster-name"
   ```   

   ```sh
    terraform apply -var="cluster_name=your-cluster-name" -auto-approve
   ```   

3. **Deploy Terraform Applications:**
   ```sh
    cd terraform/applications
    terraform init
   ```   
   
   ```sh
    terraform plan -var="kubeconfig_path=/absolute/path/to/your/kubeconfig.yaml"
   ```   

   ```sh
    terraform apply -var="kubeconfig_path=/absolute/path/to/your/kubeconfig.yaml" -auto-approve

   ```   

### Terraform Folder Description

- **terraform/cluster:**
  This folder contains the Terraform code to create a Kubernetes cluster using Kind. It defines the configuration for the cluster nodes and generates a kubeconfig file to access the cluster.

- **terraform/applications:**
  This folder contains the Terraform code to deploy applications onto the Kubernetes cluster using Helm and Argo CD. Initially, it installs Argo CD in the cluster and configures it to manage application deployments through the Argo CD provider.


## Environment Configuration

Configure environments in your GitHub repository settings. For each environment (e.g., `dev`, `prod`), you can set secrets and environment variables specific to that environment.

## GitHub Actions / Workflows

### Repository Behavior

The repository is designed to ensure that all modifications follow a streamlined and controlled process. The workflow is as follows:

- **Branch Creation and PR:**
  - Modifications to the repository should be made in branches only modifying the `dev` folders.
  - When a Pull Request (PR) is opened, the `test-infrastructure` workflow is triggered. This workflow tests the infrastructure changes by deploying a temporary infrastructure for your specific branch and environment.

- **Testing and Promotion:**
  - If the tests in the `test-infrastructure` workflow pass, you will be able to merge the PR, and when merged the `promote-branch` workflow will be triggered. This workflow creates a new branch and PR to promote the changes to the `prod` environment.
  - The `test-infrastructure` workflow is triggered again to test the infrastructure, since now will be modifying the `prod` folders, will test the `prod` environment.

- **Deploying to Main:**
  - There are two persistent infrastructures that are not cleaned up:
    - `dev` (for the GitHub environment) / `main` (for the GitHub branch)
    - `prod` (for the GitHub environment) / `main` (for the GitHub branch)
  - The `deploy-infrastructure` workflow runs whenever there is a push to the `main` branch. This workflow performs a `terraform init`, `plan`, and `apply` for the respective environment (`dev` or `prod`), ensuring that the state is saved in the corresponding S3 path. This represents the actual infrastructure of the project.

**NOTE:** Each branch has its own state in the bucket, ensuring isolated deployment and testing of the infrastructure. When testing the infrastructure on a PR that modifies `prod` folders, it does not affect the actual production infrastructure. The `dev` and `prod` infrastructures are only modified when changes are pushed to the `main` branch touching their respective folders, triggering the `deploy-infrastructure` workflow.

### Workflows

- **Create Cluster Action:**
   - **Workflow File**: `.github/actions/create-cluster.yml`
   - **Description**: Initializes and applies Terraform configuration for cluster creation. Outputs the kubeconfig content.

-  **Deploy Application Action:**
   - **Workflow File**: `.github/actions/deploy-application.yml`
   - **Description**: Deploys the application using Terraform, using the kubeconfig from the Create Cluster action.

-  **Destroy Application Action:**
   - **Workflow File**: `.github/actions/destroy-application.yml`
   - **Description**: Destroys the application using Terraform.

-  **Destroy Cluster Action:**
   - **Workflow File**: `.github/actions/destroy-cluster.yml`
   - **Description**: Destroys the cluster using Terraform.

-  **Promote Branch Workflow:**
   - **Workflow File**: `.github/workflows/promote-branch.yml`
   - **Description**: Creates a new branch and PR to promote changes from `dev` to `prod` after successful tests.

-  **Test Infrastructure Workflow:**
   - **Workflow File**: `.github/workflows/test-infrastructure.yml`
   - **Description**: Orchestrates the entire process of creating infrastructure, deploying the application, running tests, and cleaning up resources. It includes calls to the Create Cluster, Deploy Application, Destroy Application, and Destroy Cluster actions.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes.