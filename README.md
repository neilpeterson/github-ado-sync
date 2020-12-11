# Sync GitHub issues with Azure DevOps Boards

This solution deploys an Azure Function (PowerShell) that creates an Azure DevOps Boards work item for each GitHub issue raised on a named repository. All supporting infrastructure is also deployed. An Azure Monitor alert is created that sends an email to a named address when a function failure occurs.

**Source Control**

Once deployed, the Azure Function is connected to the GitHub repository, where the function is stored and configured for manual sync. The ARM template includes logic to remove this source control integration. See the parameters and examples for details on how to deploy without source control integration.

**Configuration**

Once deployed, copy the Azure Function Url and use the value in a GitHub webhook.

## Solution depolyment parameters

| Parameter | Type | Description |
|---|---|---|
| GitHubPAT | securestring | GitHub personal access token. |
| AzureDevOpsPAT | securestring | Azure DevOps personal access token. |
| ADOOrganization | string | Azure DevOps organization name. |
| ADOProjectName | string | Azure DevOps project name. |
| AreaPath | string | Azure DevOps area path for the raised bugs. |
| ItterationPath | string | Azure DevOps itteration path for the raised bugs. |
| ADOParentWorkItem | string | The Azure DevOps URL for a parent work item for the raised bug. |
| EmailAddress | string | Email address where function failure alerts will be sent. |
| RemoveSourceControll | bool | When true, removes source control integration. |

## Solution deployment

### Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsamples%2Fmaster%2FOperationalExcellence%2Fazure-function-powershell%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>  

### Azure CLI

Create a resource group for the deployment.

```azurecli
az group create --name github-ado-sync-104 --location eastus
```

Run the following command to initiate the deployment.

```azurecli
az deployment group create \
    --resource-group github-ado-sync-104 \
    --template-uri https://raw.githubusercontent.com/neilpeterson/github-ado-sync/master/deployment/azuredeploy.json \
    --parameters GitHubPAT=<> AzureDevOpsPAT=<> ADOOrganization=https://nepeters-devops.visualstudio.com/ \
    ADOProjectName=arm-template-validation-pipelines EmailAddress=nepeters@microsoft.com AreaPath=test-area-path ItterationPath=test-iteration-path ADOParentWorkItem=https://dev.azure.com/nepeters-devops/arm-template-validation-pipelines/_apis/wit/workItems/238
```

Add `RemoveSourceControll=true` to remove source controll integration.

```azurecli
az deployment group create \
    --resource-group github-ado-sync-102 \
    --template-uri https://raw.githubusercontent.com/neilpeterson/github-ado-sync/master/deployment/azuredeploy.json \
    --parameters GitHubPAT=<> AzureDevOpsPAT=<> ADOOrganization=https://nepeters-devops.visualstudio.com/ \
    ADOProjectName=arm-template-validation-pipelines EmailAddress=nepeters@microsoft.com AreaPath=test-area-path ItterationPath=test-iteration-path ADOParentWorkItem=https://dev.azure.com/nepeters-devops/arm-template-validation-pipelines/_apis/wit/workItems/238 RemoveSourceControll=true
```