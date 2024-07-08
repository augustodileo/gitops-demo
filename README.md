# GitOps Demo Repository

This repository demonstrates a GitOps workflow using Terraform and GitHub Actions to manage the creation and deployment of Kubernetes clusters and applications.

## Table of Contents
- [GitOps Demo Repository](#gitops-demo-repository)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
    - [Terraform Modules](#terraform-modules)
  - [Environment Configuration](#environment-configuration)
  - [GitHub Actions / Workflows](#github-actions--workflows)
    - [Repository Structure / Behavior](#repository-structure--behavior)
    - [Workflows](#workflows)
  - [Contributing](#contributing)

## Overview

This repository contains Terraform configurations, ArgoCD Kubernetes manifests and GitHub Actions workflows to automate the provisioning and management of Kubernetes clusters and the deployment of applications to those clusters. The workflow is designed to ensure that infrastructure changes are safely managed and can be promoted from development to production environments.

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

3. **Create Terraform Infrastructure:**
   ```sh
    cd terraform/main
    terraform init
   ```   
   
   ```sh
    terraform plan \
      -var 'applications_list=["prometheus","grafana"]' \
      -var "cluster_name=test" \
      -var "kubeconfig_path=/Users/macbookpro/Documents/Dev/gitops-demo/terraform/dev/main/kubeconfig-test.yaml" \
      -var "path=argocd/dev" \
      -var "repo_url=augustodileo/gitops-demo" \
      -var "target_revision=main"
   ```   

   ```sh
   terraform apply \
      -var 'applications_list=["prometheus","grafana"]' \
      -var "cluster_name=test" \
      -var "kubeconfig_path=/Users/macbookpro/Documents/Dev/gitops-demo/terraform/dev/main/kubeconfig-test.yaml" \
      -var "path=argocd/dev" \
      -var "repo_url=augustodileo/gitops-demo" \
      -var "target_revision=main"
   ```   

The outcome of these commands will be a K8S cluster (in this case we are using KinD) with the applications in argocd/dev. The idea is to be able to deploy the infrastructure and the applications as code

### Terraform Modules

- **terraform/main:**
  - **Inputs:**
    - `applications_list` (required): List of application names.
    - `cluster_name` (required): Name of the Kubernetes cluster.
    - `kubeconfig_path` (optional): Optional kubeconfig path, default is an empty string.
    - `path` (required): Path of the applications folder.
    - `repo_url` (required): Environment of the application.
    - `target_revision` (required): Branch or tag for the application manifest.
  - **Description:** Main Terraform module that orchestrates the entire deployment of the infrastructure, including the creation of the Kubernetes cluster and deployment of applications.

- **terraform/modules/kind:**
  - **Inputs:**
    - `cluster_name` (required): Specifies the name of the Kubernetes cluster.
    - `kubeconfig_path` (optional): If provided, the kubeconfig file for the cluster will be saved at this path.
  - **Outputs:**
    - `kubeconfig_content`: The content of the kubeconfig file for the created cluster.
    - `kubeconfig_path`: The path where the kubeconfig file is saved.

  - **Description:** This module is used to create a KinD (Kubernetes in Docker) cluster. It can be replaced with other Kubernetes modules for AKS, EKS, etc.

- **terraform/modules/argocd_installation:**
  - **Inputs:**
    - `namespace` (required): The namespace where ArgoCD will be installed.
    - `repository` (required): The repository URL for ArgoCD Helm charts.
    - `app` (required): A map containing the application configuration, including:
      - `name`: The name of the application.
      - `version`: The version of the application.
      - `chart`: The chart name.
      - `create_namespace`: Whether to create a new namespace.
      - `wait`: Whether to wait for the application to be fully deployed.
      - `deploy`: Deployment configuration.
  - **Outputs:**
    - `argocd_namespace`: The namespace where ArgoCD is installed.
    - `argocd_initial_admin_password`: The initial admin password for ArgoCD.

  - **Description:** This module installs ArgoCD in the Kubernetes cluster, setting it up to manage application deployments.

- **terraform/modules/argocd_project:**
  **Inputs:**
  - `name` (required): The name of the ArgoCD project.
  - `argocd_namespace` (required): The namespace where ArgoCD is installed.
  - `source_repos` (required): A list of source repositories allowed for the project.
  - `destination` (required): The destination configuration for the project, including server and namespace.
  - `cluster_resource_whitelist_group` (required): Group for cluster resource whitelisting.
  - `cluster_resource_whitelist_kind` (required): Kind for cluster resource whitelisting.

  **Outputs:**
  - `project_name`: The name of the created ArgoCD project.

  - **Description:** This module defines and configures an ArgoCD project, specifying which repositories and destinations it can use and manage.

- **terraform/modules/argocd_application:**
  - **Inputs:**
    - `application` (required): The name of the ArgoCD application.
    - `argocd_namespace` (required): The namespace where ArgoCD is installed.
    - `repo_url` (required): The repository URL containing the application manifests.
    - `path` (required): The path within the repository to the application manifests.
    - `project` (required): The ArgoCD project this application belongs to.
    - `target_revision` (required): The git branch or tag to use for the application manifests.
  - **Outputs:**
    - `application_name`: The name of the created ArgoCD application.

  - **Description:** This module defines and deploys an application in ArgoCD, linking it to the specified repository, path, and project.

## Environment Configuration

Configure environments in your GitHub repository settings. For each environment (e.g., `dev`, `prod`), you can set secrets and environment variables specific to that environment.

## GitHub Actions / Workflows

### Repository Structure / Behavior

```
.github
├── actions
│   ├── create-infrastructure
│   ├── destroy-infrastructure
├── workflows
│   ├── deploy-infrastructure.yaml
│   ├── promote-branch.yaml
│   └── test-infrastructure.yaml
argocd
├── dev
│   ├── app1
│   └── app2
├── prod
│   ├── app1
│   └── app2
terraform
├── dev
│   ├── main
├── prod
│   ├── main
.gitignore
README.md
```

The repository is organized by technology and environment, ensuring each part of the stack can operate independently. This structure allows for clear visibility of what is being deployed in each cluster.

- **Terraform Folder**: Contains all Infrastructure as Code (IaC) configurations for creating and managing infrastructure.
- **ArgoCD Folder**: Houses application manifests that Terraform uses to deploy applications via the ArgoCD provider.

Changes to the repository follow a controlled and streamlined process:

- **Branch Creation and PR:**
  - Modifications to the repository should be made in branches only modifying the `dev` folders.
  - When a Pull Request (PR) is opened, the `test-infrastructure` workflow is triggered. This workflow tests the infrastructure changes by deploying a temporary infrastructure for your specific branch and environment.

- **Testing and Promotion:**
  - If the tests in the `test-infrastructure` workflow pass, you will be able to merge the PR, and when merged the `promote-branch` workflow will be triggered. This workflow creates a new branch and PR to promote the changes to the `prod` environment.
  - The `test-infrastructure` workflow is triggered again to test the infrastructure, since now will be modifying the `prod` folders, will test the `prod` environment.

- **Deploying to Main:**
  - There are two persistent infrastructures that are not cleaned up:
    - `dev`
    - `prod`
  - The `deploy-infrastructure` workflow runs whenever there is a push to the `main` branch. This workflow performs a `terraform init`, `plan`, and `apply` for the respective environment (`dev` or `prod`), ensuring that the state is saved in the corresponding S3 path. This represents the actual infrastructure of the project.

**NOTE:** Each branch has its own state in the bucket, ensuring isolated deployment and testing of the infrastructure. When testing the infrastructure on a PR that modifies `prod` folders, it does not affect the actual production infrastructure. The `dev` and `prod` infrastructures are only modified when changes are pushed to the `main` branch touching their respective folders, triggering the `deploy-infrastructure` workflow.

### Workflows

- **Create Infrastructure Action:**
   - **Workflow File**: `.github/actions/create-infrastructure.yml`
   - **Description**: Initializes and applies Terraform configuration for the terraform/${{ github.environment }}/main folder.
   - 
-  **Destroy Infrastructure Action:**
   - **Workflow File**: `.github/actions/destroy-infrastructure.yml`
   - **Description**: Initializes and destroys Terraform configuration for the terraform/${{ github.environment }}/main folder.
  
-  **Promote Branch Workflow:**
   - **Workflow File**: `.github/workflows/promote-branch.yml`
   - **Description**: Creates a new branch and PR to promote changes from `dev` to `prod` after successful tests.

-  **Test Infrastructure Workflow:**
   - **Workflow File**: `.github/workflows/test-infrastructure.yml`
   - **Description**: Orchestrates the entire process of creating infrastructure, deploying the applications, running tests, and cleaning up resources. It includes calls to the Create Infrastructure and Destroy Infrastructure actions.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes.