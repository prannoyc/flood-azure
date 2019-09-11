#ErrorActionPreference = 'Stop'
#$ProgressPreference = 'SilentlyContinue'
#Set-StrictMode -Version Latest

$access_token = $env:MY_FLOOD_TOKEN
$flood_uuid = $env:MY_FLOOD_UUID
$api_url = "https://api.flood.io"

$uri = "$api_url/floods/$flood_uuid"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($access_token)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{
    'Authorization' = $basicAuthValue
}

$responseGrid = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers
$outGridID = $responseGrid._embedded.grids[0].uuid
Write-Output "Grid ID is: $outGridID"

