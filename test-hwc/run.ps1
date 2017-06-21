﻿$ErrorActionPreference = "Stop";
trap { $host.SetShouldExit(1) }

$env:GOPATH = $PWD
$env:PATH = $env:GOPATH + "/bin;C:/go/bin;" + $env:PATH

Install-WindowsFeature Web-WHC
Install-WindowsFeature Web-Webserver
Install-WindowsFeature Web-WebSockets
Install-WindowsFeature AS-Web-Support
Install-WindowsFeature AS-NET-Framework
Install-WindowsFeature Web-WHC
Install-WindowsFeature Web-ASP

cd $env:GOPATH/src/code.cloudfoundry.org/hwc

Write-Host "Installing Ginkgo"
go.exe install ./vendor/github.com/onsi/ginkgo/ginkgo
if ($LastExitCode -ne 0) {
    throw "Ginkgo installation process returned error code: $LastExitCode"
}

ginkgo.exe -r -race -keepGoing
if ($LastExitCode -ne 0) {
    throw "Testing hwc returned error code: $LastExitCode"
}
