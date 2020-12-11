using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Get request details
$GitHubIssueDetails = @(
    $Request.Body.issue.number
    $Request.Body.issue.title
    $Request.Body.issue.html_url # Link to GitHub Issue
    $Request.Body.issue.comments_url # Link to GitHub Issue API
)

# ADO details
$AzureDevOpsPAT = $env:AzureDevOpsPAT
$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($AzureDevOpsPAT)")) }
$ADOOrganization = $env:ADOOrganization
$ADOProjectName = $env:ADOProjectName
$ADOAreaPath = $env:ADOAreaPath
$ADOItterationPath = $env:ADOItterationPath
$ADOParentWorkItem = $env:ADOParentWorkItem

# GitHub details
$GitHubPAT = $env:GitHubPAT

# Work item details
$WorkItemType = "bug"
$WorkItemTitle = '{0} - {1}' -f $GitHubIssueDetails
$uri = $ADOOrganization + $ADOProjectName + "/_apis/wit/workitems/$" + $WorkItemType + "?api-version=5.1"


if($Request.Body.action -eq "Opened"){

    # ADO POST body
    $bodyObjectADO = @(
        @{
            op      = 'add'
            path    = '/fields/System.Title'
            value   = $($WorkItemTitle)
        }
        @{
            op      = 'add'
            path    = '/fields/Microsoft.VSTS.TCM.ReproSteps'
            value   = "<a href={2}>{2}</a>" -f $GitHubIssueDetails
        }
        @{
            op      = 'add'
            path    = '/fields/System.AreaPath'
            value   = "$ADOProjectName\$ADOAreaPath"
        }
        @{
            op      = 'add'
            path    = '/fields/System.IterationPath'
            value   = "$ADOProjectName\$ADOItterationPath"
        }
        @{
            op      = 'add'
            path    = '/relations/-'
            value   = @{
                rel     = 'System.LinkTypes.Hierarchy-Reverse'
                url     = $ADOParentWorkItem
            }
        }
    )

    # Create ADO Work Item
    $bodyADO = ConvertTo-Json -InputObject $bodyObjectADO
    $ADOWorkItem = Invoke-RestMethod -Uri $uri -Method POST -Headers $AzureDevOpsAuthenicationHeader -ContentType "application/json-patch+json" -Body $bodyADO

    # GitHub POST body
    $bodyObjectGitHub = @{
        body    = "Thanks for reporting - this issue is under review.  This is a Microsoft Internal DevOps Bug ID AB#<a href={0}/{1}/_workitems/edit/{2}/>{2}</a>" -f $ADOOrganization, $ADOProjectName, $ADOWorkItem.id
    }

    # Create GitHub comment
    $GitHubHeader = @{authorization = "Token $GitHubPAT"}
    $bodyGitHub = ConvertTo-Json -InputObject $bodyObjectGitHub
    Invoke-RestMethod -Uri $GitHubIssueDetails[3] -Method Post -ContentType "application/json-patch+json" -Headers $GitHubHeader -Body $bodyGitHub
}