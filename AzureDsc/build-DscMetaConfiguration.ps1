#load the settings
$settings = get-content "$psscriptroot\build-DscMetaConfiguration.Settings.json" |
    convertfrom-json

#run the command
. "$psscriptroot\build-DscMetaConfiguration.definition.ps1" @settings