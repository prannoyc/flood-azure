#ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
Set-StrictMode -Version Latest

$access_token = "$(flood_api_token)"
$api_url = "https://api.flood.io"
$script_path = '01-shopping-cart/cart1.ts';

# local testing
# $ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
# $access_token = "flood_dev_98d84da5f689fb3171c2d2d5fd802450dc57dec2357b"
# $api_url="http://10.0.2.2:3000"
# $script_path = "$ScriptDirectory\jmeter_1000rpm.jmx";

$uri = "$api_url/api/floods?flood[tool]=flood-chrome&flood[threads]=1&flood[project]=Default&flood[privacy]=public&flood[name]=myAzureTest&flood[grids][][infrastructure]=demand&flood[grids][][instance_quantity]=1&flood[grids][][region]=us-east-1&flood[grids][][instance_type]=m5.xlarge&flood[grids][][stop_after]=60"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($access_token)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{
    'Authorization' = $basicAuthValue
}

$fileBytes = [System.IO.File]::ReadAllBytes($script_path);
$fileEnc = [System.Text.Encoding]::GetEncoding('UTF-8').GetString($fileBytes);
$boundary = [System.Guid]::NewGuid().ToString();
$LF = "`r`n";
$contentType = "multipart/form-data; boundary=`"$boundary`""
$payload = (
    "--$boundary",
    "Content-Disposition: form-data; name=`"flood_files[]`"; filename=`"jmeter_1000rpm.jmx`"",
    "Content-Type: application/octet-stream$LF",
    $fileEnc,
    "--$boundary--$LF"
) -join $LF

# Write-Output $payload

try {
    Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -ContentType $contentType -Body $payload
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