[string] $version = (curl -UseBasicParsing https://raw.githubusercontent.com/Wyamio/Wyam/master/RELEASE).Content
$version = $version.Trim([Char]0).Trim(([char]10));
$call = ("https://github.com/Wyamio/Wyam/releases/download/$version/Wyam-$version.zip")

try{
    $tempFile2 = [IO.Path]::GetTempFileName()
    $tempFile = ("$tempFile2.zip")
    Invoke-WebRequest $call -OutFile $tempFile
    Remove-Item ".\wyam" -ErrorAction Ignore -Recurse
    Expand-Archive -Path $tempFile -DestinationPath ".\Wyam"
}
finally{
    Remove-Item $tempFile
    Remove-Item $tempFile
}