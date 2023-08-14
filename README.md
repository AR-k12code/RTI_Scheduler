# RTI_Scheduler
These scripts come without warranty of any kind. Use them at your own risk. I assume no liability for the accuracy, correctness, completeness, or usefulness of any information provided by this site nor for any sort of damages using these scripts may cause.

## Requirements
PowerShell 7 - https://github.com/PowerShell/PowerShell/releases

CognosModule - https://github.com/AR-k12code/CognosModule

## Settings
Copy the settings-sample.ps1 file and rename to settings.ps1.

You can generate a new RTI Scheduler token by going to "Data Sync API > Authentication > Generate New Token"

Your School Names and RTI School IDs are also listed in this box.

````
.\RTIScheduler.ps1
````

## Attendance
````
.\RTIScheduler_Attendance.ps1
````

This script will pull the current days attendance and submit it to the RTI Scheduler.

## Roadmap
- [ ] Upload RTI Scheduler Attendance to eSchool (sample script included)