# data-engineering-course
This repo will be used to track my progress in data-engineering-zoomcamp course and relevant home-works, projects, etc

## Index
- [data-engineering-course](#data-engineering-course)
  - [Index](#index)
  - [Setup: Google Cloud Platform (GCP)](#setup-google-cloud-platform-gcp)
    - [Creating GCP Project](#creating-gcp-project)
    - [Creating Service Account and Downloading Credentials](#creating-service-account-and-downloading-credentials)
  - [Environment Setup in GCP VM](#environment-setup-in-gcp-vm)
    - [Running Local Docker for Terraform, and Executing Terraform](#running-local-docker-for-terraform-and-executing-terraform)
    - [Creating SSH Key with User `de` and Adding Public Key to VM Metadata](#creating-ssh-key-with-user-de-and-adding-public-key-to-vm-metadata)
    - [Creating SSH Profile in Mac and How to SSH to the VM](#creating-ssh-profile-in-mac-and-how-to-ssh-to-the-vm)

## Setup: Google Cloud Platform (GCP)

### Creating GCP Project
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Click on the project dropdown and select **"New Project"**.
3. Enter the project name and billing account, then click **"Create"**.

### Creating Service Account and Downloading Credentials
1. In the Google Cloud Console, navigate to **"IAM & Admin"** > **"Service Accounts"**.
2. Click **"Create Service Account"**.
3. Enter a name and description for the service account, then click **"Create"**.
4. Assign the necessary roles:
   - **"Compute Admin"** for Compute Engine
   - **"Storage Admin"** for Google Cloud Storage
   - **"BigQuery Admin"** for BigQuery
5. Click **"Continue"**.
6. Click **"Done"** to finish creating the service account.
7. Click on the newly created service account and navigate to the **"Keys"** tab.
8. Click **"Add Key"** > **"Create New Key"**, select **"JSON"**, and click **"Create"**.
9. Download the JSON file and save it securely.

## Environment Setup in GCP VM

### Running Local Docker for Terraform, and Executing Terraform
Follow the instructions in the [Terraform README](./terraform/README.md).

### Creating SSH Key with User `de` and Adding Public Key to VM Metadata
1. Generate an SSH key pair:
   ```sh
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/de_vm -C "de"
   ```
2. Copy the public key:
   ```sh
   cat ~/.ssh/de_vm.pub
   ```
3. In the Google Cloud Console, navigate to **"Compute Engine"** > **"Metadata"**.
4. Click on the **"SSH Keys"** tab and add the copied public key.

### Creating SSH Profile in Mac and How to SSH to the VM
1. Open the SSH config file:
   ```sh
   nano ~/.ssh/config
   ```
2. Add the following configuration:
   ```plaintext
   Host de-vm
     HostName <VM_EXTERNAL_IP>
     User de
     IdentityFile ~/.ssh/de_vm
   ```
3. Save and close the file.
4. Connect to the VM using the SSH profile:
   ```sh
   ssh de-vm
   ```
