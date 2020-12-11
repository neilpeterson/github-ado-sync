## Solution depolyment parameters

| Parameter | Type | Description |
|---|---|---|
| GitHubPAT | securestring | GitHub personal access token. |
| AzureDevOpsPAT | securestring | Azure DevOps personal access token. |
| ADOOrganization | string | Azure DevOps organization name. |
| ADOProjectName | string | Azure DevOps project name. |
| EmailAddress | string | Email address where function failure alerts will be sent. |
| RemoveSourceControll | bool | When true, will run a script to remove the function source control integration. |

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
    ADOProjectName=arm-template-validation-pipelines EmailAddress=nepeters@microsoft.com
```

```azurecli
az deployment group create \
    --resource-group github-ado-sync \
    --template-uri https://raw.githubusercontent.com/neilpeterson/github-ado-sync/master/deployment/azuredeploy.json \
    --parameters GitHubPAT=<> AzureDevOpsPAT=<> ADOOrganization=https://nepeters-devops.visualstudio.com/ \
    ADOProjectName=arm-template-validation-pipelines EmailAddress=nepeters@microsoft.com RemoveSourceControll=true
```