[cmdletbinding()]
Param(
    [string[]]$computername = $env:computername,
    [System.Management.Automation.PSCredential]$credential
)
Process{
    #set up some splats
    $sessionParams = @{Computername = $computername}
    if($credential){$sessionParams.Add('Credential',$credential)}
    if($computername.count -eq 1 -and $computername -eq $env:computername){
        $sessionParams
    }

    #build the metaConfigurations
    . "$psscriptroot\build-DscMetaConfiguration.ps1" -computername $computername
    
    #verify that each server has WMF5.1 installed
    $PsSession = new-pssession @sessionParams
    invoke-command $PsSession -scriptblock {
        if($PSVersionTable.PSVersion.Major -lt 5){
            invoke-webrequest -uri "https://www.microsoft.com/en-us/download/confirmation.aspx?id=54616" -outfile $env:temp\WMF_Install.msi
        }
    }

    #push the DscConfiguration
    set-DscLocalConfigurationManager -path $env:UserProfile\Desktop\DscMetaConfigs
}