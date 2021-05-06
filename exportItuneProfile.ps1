# Connect-MSGraph
 $uri = "https://graph.microsoft.com/beta/deviceManagement/intents"
        $securityConfigs = (Invoke-MSGraphRequest -Url $uri -HttpMethod GET).Value 
        $returnReport = @()
        $differentiatingSettings = @()
     #   $originalProfileName="DefenderBase"  #set the profile to query
          $originalProfileName="CloudPCbase"  #set the profile to query
        foreach ($config in $securityConfigs) {
            Write-Host -ForegroundColor Red $config.displayName
            if ($config.displayName -eq $originalProfileName) {
                Write-Host -ForegroundColor Green $config.displayName
                Write-Host -ForegroundColor Green $config.Id
                $originalConfigSettings = Invoke-MSGraphRequest -Url "https://graph.microsoft.com/beta/deviceManagement/intents/$($config.id)/settings"
                $originalSettings = @()
 $originalSettings = @()
                foreach ($originalConfigSetting in $originalConfigSettings.value) {
                    $originalConfigSettingDisplayName = $originalConfigSetting.definitionId -replace "deviceConfiguration--","" -replace "admx--",""  -replace "_"," "
                    $originalConfigSetting = [PSCustomObject]@{ SettingName = $originalConfigSettingDisplayName; Value = $originalConfigSetting.valueJson; Id = $originalConfigSetting.id }
                    $originalSettings += $originalConfigSetting
                }
                $originalSettingsCount = $originalSettings.count
                $returnReport += "Original Security Configuration Name: $($config.displayName)"
                $returnReport += "Original Settings Count: $originalSettingsCount"
                Write-host  -ForegroundColor Green $returnReport
                $originalSettings |export-csv -Path $originalProfileName".csv" -NoTypeInformation
                }
                }