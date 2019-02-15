$dockerName = "chrome"
$env:path = "$env:ProgramFiles\VcXsrv;$env:path"
($vcxsrv = Get-Process vcxsrv ) > $null
if ([string]::IsNullOrEmpty($vcxsrv)) { 
    vcxsrv -multiwindow -ac
}
if (![string]::IsNullOrEmpty($dockerName)) {
    $dockerps=(docker ps --filter "name=$dockerName" --quiet)
    if ([string]::IsNullOrEmpty($dockerps)) {
        docker start $dockerName
    }
}