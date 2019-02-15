# Dockerized Chrome for Windows/Mac

## Manual installation and run for Windows

### Install Chocolatey

First need to install chocolatey.

    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

### Install VcXsrv

    choco install vcxsrv

### Start VcXServ

VcXServ can get started by UI or with the following command

    cd %ProgramFiles%
    cd VcXsrv
    vcxsrv -multiwindow -ac

## Create a docker container

    docker create --name=chrome --net=host -e TZ=<timezone> -v <Path/to/Downloads>:/root/Downloads -e DISPLAY=<ip>:0.0 pkos/chrome

- \<timezone> : Your timezone, this is optional
- \<PathToDownloads>: Path to your downloads folder
- \<ip>: in order to show chrome in your docker host screen you need your DockerNAT ip, can get using ifconfig/ipconfig (depending Mac or Windows)

### Get docker IP

if you don't know it run `ipconfig` find the  `Ethernet adapter vEthernet (DockerNAT)` and grab the IP

Or you can run:

    netsh interface ip show config name="vEthernet (DockerNAT)" | findstr "IP Address"

and you will receive the IP information as following:

        IP Address:                           10.0.75.1

### Start chrome

    docker start chrome

### Stop chrome

    docker stop chrome

## Automatic Installation

In the case you have the scripts for install and run.

### Installation

#### Windows

    .\install.ps1 -timezone "America/La_Paz" -downloadsFolder "[path\to\downloads]"

Where `-timezone` is optional, it should be your timezone e.g. Europe/London

And `-downloadsFolder` is your downloads folder

#### Mac

Add the permissions (only the first time)

    chmod a+x install.sh

Then run

    ./install.sh

### Start program

#### Windows
Run in powershell the script `start.ps1` with the following parameter

    .\start.ps1

You can create a shortcut and on the **target** field add the following:

    C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "[Path\To\start.ps1]"

#### Mac

Add the permissions (only the first time)

    chmod a+x start.sh

Then run

    ./start.sh

## Installation for Mac

### Install Xquartz

First you have to install xquartz, try installing from brew

    brew install xquartz

if you can't find the package try with

    cd ~/Downloads
    wget https://dl.bintray.com/xquartz/downloads/XQuartz-2.7.11.dmg
    hdiutil attach XQuartz-2.7.11.dmg
    cd /Volumes/XQuartz-2.7.11/
    sudo installer -pkg XQuartz.pkg -target /

## Run socat

    socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &

## Find you ip

Find your ip using `ifconfig` or you can run the command below to grab it and save into `$ip` variable  

    ip="$(ifconfig | grep inet | grep -v inet6 | grep -v 127.0.0.1 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | grep -v 255)"

## Create your chrome image

    docker create --rm --name=chrome -e DISPLAY="$ip:0.0" -v <PathToDownloads>:/root/Downloads pkos/x-chrome

- Where `$ip` is your IP got from previous command.
- TZ=  it is your time zone (e.g. America/La_Paz) this is optional
- \<PathToDownloads> is your path for downloads, e.g. ~/Downloads

## Run and configure xquartz

run xquartz

    open -a Xquartz

It will start a white console, if you are running for the first time please check **Allow connections from network clients** going to Preferences > Security

![xquartz configuration](https://github.com/p-kos/docker-chrome/raw/master/xquartzConfig.png)

## Start chrome

    docker start chrome

## Stop chrome

    docker stop chrome
