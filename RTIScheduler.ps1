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

& ..\CognosDownload.ps1 -report schools -cognosfolder "_Shared Data File Reports\Clever Files" -ShowReportDetails -TrimCSVWhiteSpace -TeamContent -savepath "$currentPath"

$rtifiles = @('Students','Instructors','Courses','Performance','Schedule')

$eschool_buildings = Import-CSV .\schools.csv | Select-Object School_id,School_name
#$buildings = ($eschool_buildings | Select-Object -ExpandProperty School_id) -join '&p_building='

$eschool_buildings | ForEach-Object {

    if ($rti_building_numbers.Keys -notcontains "$($PSItem.School_name)") {
        #building not specified in the $rti_building_numbers
        return
    }

    $eschool_building_number = $PSItem.School_id
    $rti_building_number = $rti_building_numbers.$($PSItem.School_name)

    $rtifiles | ForEach-Object {
        if ($SharedCognosFolder) {
            ..\CognosDownload.ps1 -report "$PSItem" -cognosfolder "_Shared Data File Reports\RTI Scheduler Files" -TeamContent -reportparams "&p_year=$($schoolyear)&p_building=$eschool_building_number" -savepath "$currentPath\exports\RTI_Scheduler" -TrimCSVWhiteSpace -FileName "$($rti_building_number)-$($validschools.$eschool_building_number)-$($PSItem).csv"
        } else {
            ..\CognosDownload.ps1 -report "$PSItem" -cognosfolder "RTI Scheduler Files" -reportparams "&p_year=$($schoolyear)&p_building=$eschool_building_number" -savepath "$currentPath\exports\RTI_Scheduler" -TrimCSVWhiteSpace -FileName "$($rti_building_number)-$($validschools.$eschool_building_number)-$($PSItem).csv"
        }

        $CurlArgument = '-F',
        "upload=@$($currentPath)\exports\RTI_Scheduler\$($rti_building_number)-$($validschools.$eschool_building_number)-$($PSItem).csv",
        "--header",
        """rti-api-token:$($RTIToken)""",
        "https://www.rtischeduler.com/sync-api/$($rti_building_number)/$($($PSItem).ToLower())",
        '-v'
        
        $CURLEXE = "$currentPath\bin\curl.exe"
        & $CURLEXE @CurlArgument

    }
}


