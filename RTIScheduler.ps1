<#

    .SYNOPSIS
    RTI Scheduler Automation for Arkansas Public Schools
    Author: Craig Millsap, CAMTech Computer Service, LLC.

#>

$currentPath=(Split-Path ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path)

if (!(Test-Path $currentPath\settings.ps1)) {
    Write-Host "Error: settings.ps1 file not found. Please use the settings-sample.ps1 as an example."
    exit(1)
}

. $currentPath\settings.ps1

if ([int](Get-Date -Format MM) -ge 7) {
    $schoolyear = [int](Get-Date -Format yyyy) + 1
} else {
    $schoolyear = [int](Get-Date -Format yyyy)
}

if (!(Test-Path $currentPath\exports\RTI_Scheduler)) {
    New-Item -Name "RTI_SCheduler" -ItemType Directory -Path "$currentPath\exports\"
}

try {

    Connect-ToCognos

    if (Test-Path "$currentPath\schools.csv") {
        #if you need to override anything out of Cognos you can use the same format as Clever schools.csv
        $eschool_buildings = Import-CSV -Path "$currentPath\schools.csv" | Select-Object School_id,School_name
    } else {
        $eschool_buildings = Get-CogSchool | Select-Object School_id,School_name
    }
    
} catch {
    Write-Error "Failed to connect to Cognos."
    exit 1
}

$eschool_buildings | ForEach-Object {

    if ($rti_building_numbers.Keys -notcontains "$($PSItem.School_name)") {
        #building not specified in the $rti_building_numbers
        return
    }

    $eschool_building_number = $PSItem.School_id
    $rti_building_number = $rti_building_numbers.$($PSItem.School_name)

    @('Courses','Instructors','Students','Schedule','Performance') | ForEach-Object {
    
        $report = $PSItem
        $filePath = "$($currentPath)\exports\RTI_Scheduler\$($rti_building_number)-$($report).csv"
        $url = "https://www.rtischeduler.com/sync-api/$($rti_building_number)/$($($PSItem).ToLower())"

        if (Test-Path $filePath) {
            $fileHash = (Get-FileHash -Path $filePath).Hash
        }

        if ($SharedCognosFolder) {
            Save-CognosReport -report "$report" -cognosfolder "_Shared Data File Reports\RTI Scheduler Files\23.9.7" -TeamContent -reportparams "&p_year=$($schoolyear)&p_building=$eschool_building_number" -savepath "$currentPath\exports\RTI_Scheduler" -TrimCSVWhiteSpace -FileName "$($rti_building_number)-$($report).csv"
        } else {
            Save-CognosReport -report "$report" -cognosfolder "RTI Scheduler Files" -reportparams "&p_year=$($schoolyear)&p_building=$eschool_building_number" -savepath "$currentPath\exports\RTI_Scheduler" -TrimCSVWhiteSpace -FileName "$($rti_building_number)-$($report).csv"
        }

        if ($fileHash -eq (Get-FileHash -Path $filePath).Hash) {
            Write-Output "Info: $($PSItem).csv has not changed."
            return
        }

        $response = Invoke-RestMethod -Uri $url `
            -Method Post `
            -Headers @{ "rti-api-token" = "$($RTIToken)" } `
            -Form @{
                'upload' = Get-Item -Path "$filePath"
            }
        
        Write-Output $response.logs
        
    }
}
