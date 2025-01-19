# AWS EKS Cluster Infrastructure

This repository contains the Terraform code to set up and manage an AWS EKS (Elastic Kubernetes Service) cluster and its associated infrastructure.

## Project Structure

The repository is organized into the following files and directories:

### Root Directory

- `backend.tf`: Configuration for the backend to store the Terraform state.
- `main.tf`: The main Terraform configuration to create the EKS cluster and associated resources.
- `provider.tf`: Specifies the Terraform provider settings for AWS.
- `variables.tf`: Defines the variables used in the Terraform scripts.
- `.gitignore`: A file to specify which files should be ignored by Git.

### Modules Directory

The `modules/` directory contains reusable Terraform modules to manage specific AWS resources:

- **EKS**: Module for setting up the AWS EKS cluster.
- **IAM**: Module for managing IAM roles, policies, and service accounts.
- **NatGw**: Module for creating NAT Gateways.
- **NodeGroup**: Module for creating EKS node groups.
- **VPC**: Module for setting up a VPC (Virtual Private Cloud) for the cluster.

## Prerequisites

Before using this repository, ensure you have the following prerequisites:

- **Terraform**: Version 1.0 or higher
- **AWS CLI**: Configured with the appropriate access credentials
- **AWS Account**: Required for provisioning resources in AWS
- **kubectl**: To interact with the EKS cluster once created
- **S3 Bucket**: A pre-existing S3 bucket for storing Terraform state.
- **DynamoDB Table**: A pre-existing DynamoDB table with a partition key of `LockId`.

## Setup

1. **Create the Backend Infrastructure (S3 and DynamoDB)**:

   Before proceeding with Terraform initialization, you need to create the S3 bucket and DynamoDB table manually:

   - **S3 Bucket**: Create an S3 bucket where the Terraform state will be stored.
   - **DynamoDB Table**: Create a DynamoDB table for state locking with the following configurations:
     - Table Name: `terraform-locks`
     - Partition Key: `LockId` (Type: String)

2. **Clone the repository**:

   ```bash
   git clone https://github.com/<your-repo>/AWS-EKS-cluster.git
   cd AWS-EKS-cluster
   ```

3. **Configure backend.tf**:

    In the backend.tf file, update the following values to match your pre-existing S3 bucket and DynamoDB table:

    * bucket: Set this to the name of your created S3 bucket.
    * dynamodb_endpoint: Set this to the endpoint of your DynamoDB table.

    Example of the updated backend.tf configuration:

    ```bash
    terraform {
    backend "s3" {
        bucket         = "<your-s3-bucket-name>"
        key            = "terraform.tfstate"
        region         = "<aws-region>"
        dynamodb_table = "<your-dynamodb-table-name>"
        encrypt        = true
        }
    }
    ```
    Make sure to replace \<your-s3-bucket-name>, \<aws-region>, and \<your-dynamodb-table-name> with your actual values.


4. **Create .terraform.tfvars:**
    You should create a .terraform.tfvars file in the root of your repository (this file should not be committed to GitHub). This file contains the variable values specific to your AWS setup.
    Example content for the .terraform.tfvars file:

    ```bash
    vpc_cidr_block      = "<your-vpc-cidr-block>"
    project_name        = "<your-project-name>"
    pub_sub1_cidr_block = "<your-public-subnet1-cidr-block>"
    pub_sub2_cidr_block = "<your-public-subnet2-cidr-block>"
    prv_sub1_cidr_block = "<your-private-subnet1-cidr-block>"
    prv_sub2_cidr_block = "<your-private-subnet2-cidr-block>"
    ```
    Make sure to replace the placeholder values with your actual CIDR blocks and project name. This file will be used by Terraform to configure your AWS VPC and subnets.

    **Note:** Make sure to add .terraform.tfvars to your .gitignore file so that it is not committed to version control.

5. **Initialize Terraform:**

    Initialize Terraform with the updated backend configuration. This step will configure the remote backend (S3 and DynamoDB) for storing the Terraform state and locking.

    ```bash
    terraform init
    ```
6. **Review and modify the configuration:**

    Open the variables.tf file and review or modify the variable values to match your desired AWS environment. You can configure settings like region, instance types, and other infrastructure parameters.

7. **Apply the Terraform plan:**

    Run the following command to apply the Terraform configuration and provision the resources in AWS.

    ```bash
    terraform apply
    ```
    Terraform will prompt you to confirm before creating the resources. Type yes to proceed.

8. **Authenticate kubectl with the EKS cluster:**

    After the EKS cluster is provisioned, use the following command to configure kubectl to interact with your newly created EKS cluster:

    ```bash
    aws eks --region <region> update-kubeconfig --name <eks-cluster-name>
    ```
    Replace \<region> with the appropriate AWS region and \<eks-cluster-name> with the name of your EKS cluster.

## Notes
* The backend.tf file is configured to use a remote backend for storing the Terraform state in an S3 bucket and managing state locks via DynamoDB. Ensure that you have the proper permissions to access and manage these resources.
* The infrastructure provisioning will create a VPC, NAT Gateway, EKS cluster, IAM roles, and EKS node groups.
* Adjust the configuration in the variables.tf file as needed, including region, instance types, EKS settings, etc.
* The modules in the modules/ directory provide reusable Terraform code for managing EKS, IAM roles, VPC, and other resources. Each module is self-contained and can be adjusted to fit specific needs.

## Cleanup
To destroy the resources created by Terraform, you can run the following command:

```bash
terraform destroy
```
Terraform will prompt you to confirm that you want to delete the resources. Type yes to proceed.

## License
This project is licensed under the MIT License - see the LICENSE file for details.