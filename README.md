# Sync GitHub issues with Azure DevOps Boards

This solution deploys an Azure Function (PowerShell) that creates an Azure DevOps Boards work item for each GitHub issue raised on a named repository. An Azure Monitor alert is also created that sends an email to a named address when a function failure occurs.

## Configuration

Once deployed, copy the Azure Function Url and use it as the **Payload URL** value in a GitHub webhook.

## Solution deployment parameters

| Parameter | Type | Description |
|---|---|---|
| GitHubPAT | securestring | GitHub personal access token. |
| AzureDevOpsPAT | securestring | Azure DevOps personal access token. |
| ADOOrganization | string | Azure DevOps organization name. |
| ADOProjectName | string | Azure DevOps project name. |
| AreaPath | string | Azure DevOps area path for the raised bugs. |
| ItterationPath | string | Azure DevOps iteration path for the raised bugs. |
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
az group create --name github-ado-sync --location eastus
```

Run the following command to initiate the deployment.

```azurecli
az deployment group create \
    --resource-group github-ado-sync \
    --template-uri https://raw.githubusercontent.com/neilpeterson/github-ado-sync/master/deployment/azuredeploy.json \
    --parameters GitHubPAT=<> AzureDevOpsPAT=<> ADOOrganization=https://nepeters-devops.visualstudio.com/ \
    ADOProjectName=arm-template-validation-pipelines EmailAddress=nepeters@microsoft.com AreaPath=test-area-path \
    ItterationPath=test-iteration-path \
    ADOParentWorkItem=https://dev.azure.com/nepeters-devops/arm-template-validation-pipelines/_apis/wit/workItems/238
```

Add `RemoveSourceControll=true` to remove source controll integration.

```azurecli
az deployment group create \
    --resource-group github-ado-sync \
    --template-uri https://raw.githubusercontent.com/neilpeterson/github-ado-sync/master/deployment/azuredeploy.json \
    --parameters GitHubPAT=<> AzureDevOpsPAT=<> ADOOrganization=https://nepeters-devops.visualstudio.com/ \
    ADOProjectName=arm-template-validation-pipelines EmailAddress=nepeters@microsoft.com AreaPath=test-area-path \
    ItterationPath=test-iteration-path \
    ADOParentWorkItem=https://dev.azure.com/nepeters-devops/arm-template-validation-pipelines/_apis/wit/workItems/238 \
    RemoveSourceControll=true
```