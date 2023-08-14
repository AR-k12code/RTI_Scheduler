<#

    .SYNOPSIS
    RTI Scheduler Attendance for Arkansas Public Schools
    Author: Craig Millsap, CAMTech Computer Service, LLC.

    .DESCRIPTION
    This will pull attendance from Cognos and upload to RTI Scheduler.

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

    $rti_building_number = $rti_building_numbers.$($PSItem.School_name)
    $eschool_building_number = $PSItem.School_id

    $cognosAttendanceData = Get-CogStuAttendance -Building $eschool_building_number -IncludeComments
    
    if ($cognosAttendanceData) {
        $cognosAttendanceData | ForEach-Object {
            [PSCustomObject]@{
                'Student ID' = $PSItem.Student_id
                'Attendance Code' = $PSItem.Attendance_code
                'Period' = $PSItem.Attendance_periodName
                'Date' = $PSItem.Attendance_date
                'Description' = $PSItem.Attendance_comment
            }
        } | Export-CSV "exports\RTI_Scheduler\$($rti_building_number)-attendance.csv" -UseQuotes AsNeeded -Force -NoTypeInformation

        Invoke-RestMethod -Uri ("https://rtischeduler.com/sync-api/$($rti_building_number)/attendance") `
            -Method Post `
            -Headers @{ "rti-api-token" = "$($RTIToken)" } `
            -Form @{
                'upload' = Get-Item -Path "exports\RTI_Scheduler\$($rti_building_number)-attendance.csv"
            }

    } else {
        Write-Warning "No attendance data for $($PSItem.School_name)"
    }

}
