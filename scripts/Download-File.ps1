<# 
.SYNOPSIS
    Downloads a file showing the progress of the download
.DESCRIPTION
    This Script will download a file locally while showing the progress of the download 
.EXAMPLE
    .\Download-File.ps1 'http:\\someurl.com\somefile.zip'
.EXAMPLE
    .\Download-File.ps1 'http:\\someurl.com\somefile.zip' 'C:\Temp\somefile.zip'
.PARAMETER url
    url to be downloaded
.PARAMETER localFile
    the local filename where the download should be placed
.NOTES
    FileName     : Download-File.ps1
    Author       : CrazyDave
    LastModified : 18 Jan 2011 9:39 AM PST
#Requires -Version 2.0 
#> 
<# 
param(
    [Parameter(Mandatory=$true)]
    [String] $url,
    [Parameter(Mandatory=$false)]
    [String] $localFile = (Join-Path $pwd.Path $url.SubString($url.LastIndexOf('/'))) 
)
#> 
param(
    [Parameter(Mandatory=$true)]
    [String] $url,
    [Parameter(Mandatory=$false)]
    [String] $localFile = (Join-Path $pwd.Path $url.SubString($url.LastIndexOf('/'))) 
)

begin {

	$client = New-Object System.Net.WebClient
    $Global:downloadComplete = $false

    $eventDataComplete = Register-ObjectEvent $client DownloadFileCompleted `
        -SourceIdentifier WebClient.DownloadFileComplete `
        -Action {$Global:downloadComplete = $true}
    $eventDataProgress = Register-ObjectEvent $client DownloadProgressChanged `
        -SourceIdentifier WebClient.DownloadProgressChanged `
        -Action { $Global:DPCEventArgs = $EventArgs }    
}

process {
    Write-Progress -Activity 'Downloading file' -Status $url
    $client.DownloadFileAsync($url, $localFile)
    
    while (!($Global:downloadComplete)) {                
        $pc = $Global:DPCEventArgs.ProgressPercentage
        if ($pc -ne $null) {
            Write-Progress -Activity 'Downloading file' -Status $url -PercentComplete $pc
        }
    }
	
    Write-Progress -Activity 'Downloading file' -Status $url -Complete
}

end {
    Unregister-Event -SourceIdentifier WebClient.DownloadProgressChanged
    Unregister-Event -SourceIdentifier WebClient.DownloadFileComplete
    $client.Dispose()
    $Global:downloadComplete = $null
    $Global:DPCEventArgs = $null
    Remove-Variable client
    Remove-Variable eventDataComplete
    Remove-Variable eventDataProgress
    [GC]::Collect()    
}