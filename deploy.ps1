[string] $version = (curl https://raw.githubusercontent.com/Wyamio/Wyam/master/RELEASE).RawContent
$match=[Regex]::Match($version,"\r\n\r\n(?<version>[^\n\r]+)",[System.Text.RegularExpressions.RegexOptions]::Singleline );
$version =$match.Groups["version"].Value;
$version = $version.Trim([Char]0).Trim(([char]10));
$call = ("https://github.com/Wyamio/Wyam/releases/download/$version/Wyam-$version.zip")
echo $call
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