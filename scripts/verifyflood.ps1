#ErrorActionPreference = 'Stop'
#$ProgressPreference = 'SilentlyContinue'
#Set-StrictMode -Version Latest

$access_token = $env:MY_FLOOD_TOKEN
$flood_uuid = $env:MY_FLOOD_UUID
$api_url = "https://api.flood.io"

$bytes = [System.Text.Encoding]::ASCII.GetBytes($access_token)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{
    'Authorization' = $basicAuthValue
}

#get the Grid ID
try {
    
    $uri = "$api_url/floods/$flood_uuid"
    $responseGrid = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers
    $outGridID = $responseGrid._embedded.grids[0].uuid
    Write-Output ">> Grid ID is: $outGridID"

}
catch {
    $responseBody = ""
    $errorMessage = $_.Exception.Message
    if (Get-Member -InputObject $_.Exception -Name 'Response') {
        write-output $_.Exception.Response
       
        try {
            $result = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($result, [System.Text.Encoding]::ASCII)
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            $responseBody = $reader.ReadToEnd();
            Write-Output "response body: $responseBody"
        }
        catch {
            Throw "An error occurred while calling REST method at: $uri. Error: $errorMessage. Cannot get more information."
        }
    }
    Throw "An error occurred while calling REST method at: $uri. Error: $errorMessage. Response body: $responseBody"

}

#wait for Grid to start successfully
write-output ">> Waiting for Grid ($outGridID) to start ..."
do{

    $uri = "$api_url/grids/$outGridID"
    $responseStatus = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers
    $currentGridStatus = $responseStatus.status

    if($currentGridStatus -eq "started"){
        write-output ">> The Grid has successfully started."
    }

    if($currentGridStatus -eq "starting"){
        Start-Sleep -Seconds 10
    }

}while($currentGridStatus -eq "starting")

#wait for the Flood to complete successfully
write-output ">> Waiting for the Flood ($flood_uuid) to execute and complete ..."
do{

    $uri = "$api_url/floods/$flood_uuid"
    $responseStatus = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers
    $currentFloodStatus = $responseStatus.status

    if($currentFloodStatus -eq "finished"){
        write-output ">> The Flood has finished."
    }

    if($currentFloodStatus -eq "running"){
        Start-Sleep -Seconds 10
    }

}while($currentGridStatus -eq "running")

