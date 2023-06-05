##Pilow64##Setting parameters so the user can put in any file and port range they want.param ( [Parameter (Mandatory=$true)] [string]$File,        [Parameter()] $Ports = 10..15)Write-Host $Ports

##Setting the lockation to find the files.
Start-Transcript -Path .\Desktop-log.txt
$ErrorActionPreference = 'silentlycontinue'
Set-Location $PSScriptRoot

##Setting/creating the varibales.
$ip_num = 0
$ip_array = @()
$port_num = 0
$port_array = @()

##Making it so it will take both the list and line txt.
($ips = get-content -path $File) | forEach {$ip_array+=$_ -split ","}
($ports)  | forEach {$port_array+=$_}

##Pings the addresses and tells if it is connected.
forEach($address in $ip_array){

    $ip_num++
    $port_num = 0
    write-host "space"
    write-host $address, "-", ([System.Net.NetworkInformation.Ping]::new().Send($Address)).Status
    Write-Progress "Scanning address" $address -PercentComplete (($ip_num/$ip_array.count)*100)

    ##Test the address if it is connected or not.
    if(Test-Connection -ComputerName $address){

        ##In the stated port range it scans for each address.
        forEach($port in $port_array){

            $port_num++
            Write-Progress -Id 1 "scanning ports" $port -PercentComplete (($port_num/$port.count)*100)
            $fact = new-object System.Net.Sockets.TcpClient($address, $port)

            ##Tell whether it is open or not.
            if($fact.Connected){
                "port $port is open"
                $fact.close()
            }
            else{
                "port $port is not open"
            }
        }
    }
}

Stop-Transcript