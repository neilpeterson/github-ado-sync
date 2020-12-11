
| Parameter | Type | Description |

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
    --parameters GitHubPAT=<replace> AzureDevOpsPAT=<replace> ADOOrganization=https://nepeters-devops.visualstudio.com/ \
    emailAddress=nepeters@microsoft.com ADOProjectName=arm-template-validation-pipelines
```

```azurecli
az deployment group create \
    --resource-group github-ado-sync \
    --template-uri https://raw.githubusercontent.com/neilpeterson/github-ado-sync/master/deployment/azuredeploy.json \
    --parameters GitHubPAT=<replace> AzureDevOpsPAT=<replace> ADOOrganization=https://nepeters-devops.visualstudio.com/ \
    emailAddress=nepeters@microsoft.com ADOProjectName=arm-template-validation-pipelines RemoveSourceControll=false
```