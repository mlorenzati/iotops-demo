# IoTops Demo

Codebase for an automated IoT platform PoC using Azure, Terraform, and GitHub Actions.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
  - [Install Required Tools](#install-required-tools)
  - [Azure Setup](#azure-setup)
  - [GitHub Setup](#github-setup)
  - [Deploy Infrastructure](#deploy-infrastructure)
- [Device Preparation](#device-preparation)
  - [Install Docker](#install-docker)
  - [Install Azure IoT Edge Runtime](#install-azure-iot-edge-runtime)
  - [Configure IoT Edge Device](#configure-iot-edge-device)
- [Troubleshooting](#troubleshooting)
- [References](#references)

## Prerequisites

Before you begin, ensure you have the following installed on your local machine:

- **Azure CLI** (version 2.0 or later): Used to interact with Azure services.
- **Terraform** (version 0.13 or later): Infrastructure as Code tool for provisioning Azure resources.
- **Docker**: Required for running containerized applications.
- **Azure IoT Edge Runtime**: For deploying modules to IoT Edge devices.
- **GitHub Account**: For accessing and configuring the repository and Actions.

## Setup Instructions

### Install Required Tools

#### Install Azure CLI

- **Windows**:

  Download and install from [Azure CLI Installer](https://aka.ms/installazurecliwindows).

- **macOS**:

  ```bash
  brew update && brew install azure-cli
  ```

- **Linux**:

  ```bash
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  ```

#### Install Terraform

Download the appropriate package for your OS from the [Terraform Downloads Page](https://www.terraform.io/downloads.html), and follow the installation instructions.

Alternatively, using a package manager:

- **macOS (Homebrew)**:

  ```bash
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
  ```

- **Windows (Chocolatey)**:

  ```powershell
  choco install terraform
  ```

#### Install Docker

Refer to the official Docker installation guide: [Get Docker](https://docs.docker.com/get-docker/)

#### Install Azure IoT Edge Runtime

Installation steps are provided in the [Device Preparation](#device-preparation) section.

### Azure Setup

1. **Login to Azure CLI**

   ```bash
   az login
   ```

   If you have multiple subscriptions, list them using:

   ```bash
   az account list --output table
   ```

2. **Set the Desired Azure Subscription**

   ```bash
   az account set --subscription "your-subscription-id-or-name"
   ```

3. **Create a Resource Group**

   The Terraform configuration expects a resource group named `iotops-demo`. Create it using:

   ```bash
   az group create --name iotops-demo --location "brazilsouth"
   ```

4. **Create a Storage Account and Blob Container**

   The Terraform backend requires a storage account named `iotopstfstate` and a blob container named `tfstate`. Create them using:

   ```bash
   # Create Storage Account
   az storage account create \
     --name iotopstfstate \
     --resource-group iotops-demo \
     --location "brazilsouth" \
     --sku Standard_LRS \
     --kind StorageV2

   # Retrieve Storage Account Key
   ACCOUNT_KEY=$(az storage account keys list \
     --resource-group iotops-demo \
     --account-name iotopstfstate \
     --query "[0].value" -o tsv)

   # Create Blob Container
   az storage container create \
     --name tfstate \
     --account-name iotopstfstate \
     --account-key $ACCOUNT_KEY
   ```

   **Note**: The storage account name must be globally unique. If `iotopstfstate` is already taken, choose another name and update `provider.tf` accordingly.

### GitHub Setup

1. **Fork the Repository**

   - Fork this repository to your own GitHub account.

2. **Create a GitHub Environment**

   - In your GitHub repository, go to **Settings** > **Environments**.
   - Click **New environment** and name it `iotops-demo` (or your preferred environment name).

3. **Set `AZURE_CREDENTIALS` Secret**

   - **Create a Service Principal** with Contributor role:

     ```bash
     az ad sp create-for-rbac \
      --name "github-actions-sp" \
      --role contributor \
      --scopes /subscriptions/$(az account show --query id -o tsv) \
      --sdk-auth

     ```

     Replace `{subscription-id}` with your Azure subscription ID. The command will output a JSON object containing your credentials.

   - **Add Secret to GitHub**:

     - In your GitHub repository, go to **Settings** > **Secrets and variables** > **Actions**.
     - Click **New repository secret**.
     - Set the name as `AZURE_CREDENTIALS` and paste the JSON output from the previous step.

4. **Update GitHub Actions Workflow**

   Ensure that the environment name in your GitHub Actions workflow (`deploy-infrastructure.yml`) matches the one you created.

### Deploy Infrastructure

The deployment is automated using GitHub Actions.

1. **Trigger the Workflow**

   - Go to the **Actions** tab in your GitHub repository.
   - Select the **Deploy Infrastructure** workflow.
   - Click **Run workflow**.
   - Choose the environment (e.g., `iotops-demo`) and click **Run workflow**.

2. **Monitor the Deployment**

   - The workflow will execute and provision the Azure resources defined in the Terraform configuration.
   - You can monitor the progress and view logs directly in the Actions tab.

3. **Verify Deployment**

   - After the workflow completes, verify that the resources have been created in your Azure subscription.
   - You can check via the Azure Portal or using the Azure CLI:

     ```bash
     az iot hub list --resource-group iotops-demo --output table
     ```

## Device Preparation

Prepare your IoT Edge device by installing Docker and Azure IoT Edge runtime.

### Install Docker

You can use the provided script or install manually.

#### Using the Script

Run the following script on your device:

```bash
chmod +x scripts/install-docker.sh
./scripts/install-docker.sh
```

#### Manual Installation

Refer to the [official Docker installation guide](https://docs.docker.com/engine/install/).

### Install Azure IoT Edge Runtime

You can use the provided script or install manually.

#### Using the Script

Run the following script on your device:

```bash
chmod +x scripts/install-iot-edge.sh
./scripts/install-iot-edge.sh
```

#### Manual Installation

1. **Register Microsoft Package Repository**

   ```bash
   curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > ./microsoft-prod.list
   sudo cp ./microsoft-prod.list /etc/apt/sources.list.d/
   curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
   sudo cp ./microsoft.gpg /etc/apt/trusted.gpg.d/
   ```

2. **Install the IoT Edge Security Daemon**

   ```bash
   sudo apt-get update
   sudo apt-get install moby-engine moby-cli iotedge
   ```

### Configure IoT Edge Device

1. **Retrieve Device Connection String**

   - After deploying the infrastructure, retrieve the device connection string from your IoT Hub.
   - Use the Azure CLI:

     ```bash
     az iot hub device-identity connection-string show --hub-name {your-iot-hub-name} --device-id {your-device-id}
     ```

2. **Update IoT Edge Configuration**

   Edit the IoT Edge configuration file:

   ```bash
   sudo nano /etc/iotedge/config.yaml
   ```

   Replace the `provisioning` section with your device connection string:

   ```yaml
   provisioning:
     source: "manual"
     device_connection_string: "{your-device-connection-string}"
   ```

3. **Restart IoT Edge Service**

   ```bash
   sudo systemctl restart iotedge
   ```

4. **Verify Installation**

   Check the status of the IoT Edge runtime:

   ```bash
   sudo iotedge check
   ```

   List running modules:

   ```bash
   sudo iotedge list
   ```

## Troubleshooting

- **Terraform Errors**: If you encounter errors during Terraform initialization or deployment, ensure that your Azure credentials are correctly configured and that the resource names are unique.
- **Docker Issues**: Verify that Docker is running properly on your device by running `sudo docker run hello-world`.
- **IoT Edge Runtime**: If the IoT Edge runtime fails to start, check the logs:

  ```bash
  journalctl -u iotedge --no-pager --no-full
  ```

- **GitHub Actions Failures**: Review the logs in the GitHub Actions tab to identify any issues during the workflow execution.

## References

- [Azure IoT Edge Documentation](https://docs.microsoft.com/en-us/azure/iot-edge/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)
- [Docker Documentation](https://docs.docker.com/)

---