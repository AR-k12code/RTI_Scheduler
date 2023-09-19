<#
    If you need to make modifications to the attendance being pushed to eSchool, copy this file to ./attendance_overrides.ps1
    Be extremely careful!
    There is a sample function to exclude a period from being pushed to eSchool.  The example also includes the function calls for this to work.

    1: Create modification functions at the bottom of the document.  Your function needs to take a parameter named $attendanceToUpdate and process the CSV information

    2: Create a new declaration in the Modify-Attendance function that sets $attendanceToUpdate equal to the output of your custom function

#>

#Primary modification function:  List all of the function calls and variable reassignments here.
Function Modify-Attendance {
    Param($rawAttendance)
    Write-Host "Running Attendance Modifications..."
    $attendanceToUpdate = $rawAttendance
#    $attendanceToUpdate = Exclude-Period -periodName "RTIC" -toUpdate $attendanceToUpdate  #Uncomment this line  AND CHANGE THE -periodName PARAM to use the provided Exclude-Period functi>
    # Add $attendanceToUpdate declarations above this line.
    # Do not edit the remainder of this function.
    $updatedAttendance = $attendanceToUpdate
    Write-Host "Finished running Attendance Modifications."
    $updatedAttendance
}

#Create modification functions below.

#Example: Remove attendance values for any record matching a provided period name (passed into the function as a parameter).

Function Exclude-Period {
    Param($periodName, $toUpdate)
    Write-Host "Excluding Period " $periodName "from attendance..."
    $modifiedAttendance = $toUpdate | where{$_ -notmatch "$periodName"}
    $modifiedAttendance
}
