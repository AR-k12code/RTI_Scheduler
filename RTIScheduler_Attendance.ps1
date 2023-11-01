<#

.SYNOPSIS
RTI Scheduler Attendance for Arkansas Public Schools
Author: Craig Millsap, CAMTech Computer Service, LLC.

.DESCRIPTION
This will pull attendance from Cognos and upload to RTI Scheduler.

#>

if (!(Test-Path $PSScriptRoot\settings.ps1)) {
    Write-Host "Error: settings.ps1 file not found. Please use the settings-sample.ps1 as an example."
    exit(1)
} else {
    . $PSScriptRoot\settings.ps1
}

if (!(Test-Path "$PSScriptRoot\exports\RTI_Scheduler\")) {
    New-Item -Path "$PSScriptRoot\exports\RTI_Scheduler\" -ItemType Directory -Force
}

$schoolyear = (Get-Date).Month -ge 7 ? (Get-Date).Year + 1 : (Get-Date).Year

try {

    Connect-ToCognos

    if (Test-Path "$PSScriptRoot\schools.csv") {
        #if you need to override anything out of Cognos you can use the same format as Clever schools.csv
        $eschool_buildings = Import-CSV -Path "$PSScriptRoot\schools.csv" | Select-Object School_id,School_name
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
        } | Export-CSV "$PSScriptRoot\exports\RTI_Scheduler\$($rti_building_number)-attendance.csv" -UseQuotes AsNeeded -Force -NoTypeInformation

        Invoke-RestMethod -Uri ("https://rtischeduler.com/sync-api/$($rti_building_number)/attendance") `
            -Method Post `
            -Headers @{ "rti-api-token" = "$($RTIToken)" } `
            -Form @{
                'upload' = Get-Item -Path "$PSScriptRoot\exports\RTI_Scheduler\$($rti_building_number)-attendance.csv"
            }

    } else {
        Write-Warning "No attendance data for $($PSItem.School_name)"
    }

}
