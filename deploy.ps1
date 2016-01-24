[string] $version = (curl https://raw.githubusercontent.com/Wyamio/Wyam/master/RELEASE).Content
$version = $version.Trim([Char]0).Trim(([char]10));
$call = ("https://github.com/Wyamio/Wyam/releases/download/$version/Wyam-$version.zip")

$tempFile = [IO.Path]::GetTempFileName()
$tempFile = ("$tempFile.zip")
Invoke-WebRequest $call -OutFile $tempFile
Expand-Archive -Path $tempFile -DestinationPath ".\Wyam"
Remove-Item $tempFile