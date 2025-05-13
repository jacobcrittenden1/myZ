$organization = "ZionsETO"
$project = "EDA"
$pat = "CiGCBnqBesO2yG3kJo3jFHOA46GV5ZvIkbvUPS9RVlJLu5WRGx4IJQQJ99BDACAAAAAi8os2AAASAZDO1iN2"
$oldIterationPath = "EDA\PI\PI026\026.04"
$newIterationPath = "EDA\PI\PI026\026.03"
 
$base64AuthInfo  = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($pat)"))
 
 
$workItemsUrl = "https://dev.azure.com/$organization/eda/releaseengineering/_apis/wit/wiql?api-version=7.1"
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


Write-Host "Work Item IDs: $workItemIds"


