using namespace System.Net

# Input bindings are passed in via param block
param($Request, $TriggerMetadata)

# Get request details
$GitHubIssueDetails = @(
    $Request.Body.issue.number
    $Request.Body.issue.title
    $Request.Body.issue.html_url # Link to GitHub Issue
    $Request.Body.issue.comments_url # Link to GitHub Issue API
)

$Strings = @(
    "Request empty or not json, check GitHub webhook content type."
    "Triggered .via GitHub webhook, non-issue open event, no action taken."
    "Thanks for reporting - this issue is under review. This is a Microsoft Internal DevOps Bug ID #"
)

# Throw error if no request.body.action
if (!$Request.Body.action) {throw $Strings[0]}

# Write output after a non issue open event
if ($Request.Body.action -ne "Opened") {Write-Output $Strings[1]}

# Work item details
$WorkItemType = "bug"
$WorkItemTitle = '{0} - {1}' -f $GitHubIssueDetails
$Uri = $env:ADOOrganization + $env:ADOProjectName + "/_apis/wit/workitems/$" + $WorkItemType + "?api-version=5.1"

if($Request.Body.action -eq "Opened"){

    # ADO POST body
    $BodyObjectADO = @(
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
            value   = "$env:ADOProjectName\$env:ADOAreaPath"
        }
        @{
            op      = 'add'
            path    = '/fields/System.IterationPath'
            value   = "$env:ADOProjectName\$env:ADOItterationPath"
        }
        @{
            op      = 'add'
            path    = '/relations/-'
            value   = @{
                rel     = 'System.LinkTypes.Hierarchy-Reverse'
                url     = $env:ADOParentWorkItem
            }
        }
    ) | ConvertTo-Json

    # Create ADO Work Item
    $AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($env:AzureDevOpsPAT)"))}
    Try {$ADOWorkItem = Invoke-RestMethod -Uri $uri -Method POST -Headers $AzureDevOpsAuthenicationHeader -ContentType "application/json-patch+json" -Body $BodyObjectADO}
    Catch {throw $_.Exception.Message}

    # GitHub POST body
    $BodyObjectGitHub = @{
        body = "{0} <a href={1}/{2}/_workitems/edit/{3}/>{3}</a>" -f $strings[2], $env:ADOOrganization, $env:ADOProjectName, $ADOWorkItem.id
    } | ConvertTo-Json

    # Create GitHub comment
    $GitHubHeader = @{authorization = "Token $env:GitHubPAT"}
    Try {Invoke-RestMethod -Uri $GitHubIssueDetails[3] -Method Post -ContentType "application/json-patch+json" -Headers $GitHubHeader -Body $BodyObjectGitHub}
    Catch {throw $_.Exception.Message}
}