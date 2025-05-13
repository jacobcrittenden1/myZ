$organization = "ZionsETO"
$project = "EDA"
$pat = "CiGCBnqBesO2yG3kJo3jFHOA46GV5ZvIkbvUPS9RVlJLu5WRGx4IJQQJ99BDACAAAAAi8os2AAASAZDO1iN2"
$oldIterationPath = "EDA\PI\PI026\026.04"
$newIterationPath = "EDA\PI\PI026\026.03"
 
$base64AuthInfo  = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($pat)"))
 
 
$workItemsUrl = "https://dev.azure.com/$organization/dts/releaseengineering/_apis/wit/wiql?api-version=7.1"
$query = @{
    query = "SELECT [System.Id], [System.Title], [System.AreaPath], [System.IterationPath], [System.State]
FROM WorkItems
WHERE [System.TeamProject] = 'EDA'
  AND [System.AreaPath] = 'EDA\ReleaseEngineering'
  AND [System.IterationPath] = '$oldIterationPath'
  AND [System.State] NOT IN ('Closed', 'Removed', 'Resolved')
ORDER BY [System.Id]"
} | ConvertTo-Json
 
$response = Invoke-RestMethod -Uri $workItemsUrl -Method Post -Headers  @{Authorization=("Basic {0}" -f $base64AuthInfo); "Content-Type"="application/json"} -Body $query
$workItemIds = $response.workItems | ForEach-Object { $_.id }
 
 
# Update each work item to the new iteration
if($workItemIds.count -gt 0) {
    foreach ($witId in $workItemIds) {
        $updateUrl = "https://dev.azure.com/$organization/$project/_apis/wit/workitems/$($witId)?api-version=6.0"
        $body = @(
            @{
                op = "add"
                path = "/fields/System.IterationPath"
                value = "$newIterationPath"
            }
        )
 
        Invoke-RestMethod -Uri $updateUrl -Method Patch -Body (ConvertTo-Json -InputObject $body) -ContentType "application/json-patch+json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
        Write-Output "Work item $witId moved to $newIterationPath"
    }
}