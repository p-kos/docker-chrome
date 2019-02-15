param(
    [String]$timezone = "", 
    [String]$downloadsFolder = ""
)

$choco=(get-command choco).Path
if ([string]::IsNullOrEmpty($choco)){
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
if ( ![System.IO.File]::Exists("$env:ProgramFiles\VcXsrv\vcxsrv.exe") ) {
    choco install vcxsrv
}
$ip=(netsh interface ip show config name="vEthernet (DockerNAT)" | findstr "IP Address")
$ip=$ip.Replace("IP Address:","").Trim()+":0.0";
if ([string]::IsNullOrEmpty($timezone)) {
    $timezone="Europe/London"
}
if ([string]::IsNullOrEmpty($downloadsFolder)) {
    if ([string]::IsNullOrEmpty($USERPROFILE)) {
        $downloadsFolder=[Environment]::GetFolderPath("MyDocuments");
    }
    else{
        $downloadsFolder="$USERPROFILE/Downloads";
    }
}
docker create --name=chrome --net=host -v ${downloadsFolder}:/root/Downloads -e TZ=$timezone -e DISPLAY=$ip pkos/chrome