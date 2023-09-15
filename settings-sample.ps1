#Use the RTI Scheduler Files from the Team content\_Shared Data File Reports\RTI Scheduler Files? If $False then you need them in your My Content folder in "RTI Scheduler Files"
$SharedCognosFolder = $True

#Token provided by RTI
$RTIToken = 'OQPQnKZI1hpLonU6xMxSAL5mxEaxO2yjCheDtidg'

#Building Names and Numbers. The building number must match the exact name in eSchool. Check your schools.csv from Clever. (Will also be downloaded on first run.)
$rti_building_numbers = @{
    'My Primary School' = 34399971
    'My Elementary School'= 34399972
    'My Middle School' = 34399973
    'My High School' = 34399974
}

#Uploading Attendance back into eSchool. You really need to know what you're doing here. This is not for the faint of heart.
$uploadAttendance = $false

<#
This date can not be more than the current school year.
If the current date is 8/15/2024, then you can set the date to 6/1/2025.
If you set it to 7/1/2025 then it will error.
The script will stop working after this date until you verify the correct period is selected in RTI Scheduler and updated the date here.
#>
$attendanceUntilDate = "6/1/2024"

#Default for attendance minutes missed for a student to be considered absent when uploading attendance to eSchool.
$uploadAttendanceMinutes = 11 #customize this for your district.

#Absence code you want entered into eSchool when a student is marked absent in RTI Scheduler.
$absenceCode = 'U'