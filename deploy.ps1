$webClient = new-object net.webclient

$download = $webClient.DownloadString("https://raw.githubusercontent.com/Wyamio/Wyam/master/RELEASE")

[string] $version = $download
$version = $version.Trim([Char]0).Trim(([char]10));
$call = ("https://github.com/Wyamio/Wyam/releases/download/$version/Wyam-$version.zip")
echo $call
try{
    $tempFile2 = [IO.Path]::GetTempFileName()
    $tempFile = ("$tempFile2.zip")
    $webClient.DownloadFile( $call , $tempFile)
    Remove-Item $env:WYAM_PATH -ErrorAction Ignore -Recurse
    unzip $tempFile -d $env:WYAM_PATH
    Write-Host 'Succsess'
}
finally{
    Remove-Item $tempFile2
    Remove-Item $tempFile
}