# GitHub ADO Sync

This solution deploys an HTTP triggered Azure Function (PowerShell) and all supporting infrastructure. The function is activated by a GitHub repository webhook each time a GitHub issue is created. The function creates an Azure DevOps Boards work item and updates the GitHub issue with these details. An Azure Monitor alert is also created, which sends an email to a specified email address when a function failure occurs.

## Configuration

Once deployed, copy the Azure Function Url and use it as the **Payload URL** value on a GitHub webhook.

## Solution deployment parameters

| Parameter | Type | Description |
|---|---|---|
| GitHubPAT | securestring | GitHub personal access token. |
| AzureDevOpsPAT | securestring | Azure DevOps personal access token. |
| ADOOrganization | string | Azure DevOps organization name. |
| ADOProjectName | string | Azure DevOps project name. |
| ADOAreaPath | string | Azure DevOps area path for the raised bugs. |
| ADOItterationPath | string | Azure DevOps iteration path for the raised bugs. |
| ADOParentWorkItem | string | The Azure DevOps URL for a parent work item for the raised bug. |
| EmailAddress | string | Email address where function failure alerts will be sent. |
| RemoveSourceControll | bool | When true, removes source control integration. |

## Solution deployment

### Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fneilpeterson%2Fgithub-ado-sync%2Fmaster%2Fdeployment%2Fazuredeploy.json" target="_blank">
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
    ADOProjectName=arm-template-validation-pipelines EmailAddress=nepeters@microsoft.com ADOAreaPath=test-area-path \
    ADOItterationPath=test-iteration-path \
    ADOParentWorkItem=https://dev.azure.com/nepeters-devops/arm-template-validation-pipelines/_apis/wit/workItems/238
```

Add `RemoveSourceControll=true` to remove source controll integration.

```azurecli
az deployment group create \
    --resource-group github-ado-sync \
    --template-uri https://raw.githubusercontent.com/neilpeterson/github-ado-sync/master/deployment/azuredeploy.json \
    --parameters GitHubPAT=<> AzureDevOpsPAT=<> ADOOrganization=https://nepeters-devops.visualstudio.com/ \
    ADOProjectName=arm-template-validation-pipelines EmailAddress=nepeters@microsoft.com ADOAreaPath=test-area-path \
    ADOItterationPath=test-iteration-path \
    ADOParentWorkItem=https://dev.azure.com/nepeters-devops/arm-template-validation-pipelines/_apis/wit/workItems/238 \
    RemoveSourceControll=true
```