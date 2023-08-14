# RTI_Scheduler
These scripts come without warranty of any kind. Use them at your own risk. I assume no liability for the accuracy, correctness, completeness, or usefulness of any information provided by this site nor for any sort of damages using these scripts may cause.

**DO NOT INSTALL THESE SCRIPTS TO A DOMAIN CONTROLLER.**

Create a dedicated VM running Windows Server 2019 or Windows 10 Pro 1809+ for your automation scripts.

## Requirements
Git - ````https://git-scm.com/download/win````

PowerShell 7 - ````https://github.com/PowerShell/PowerShell/releases````

CognosModule - ````https://github.com/AR-k12code/CognosModule````

## Installation instructions:
Open powershell 7 (pwsh.exe)as an administrator.

In the command window paste the following:
````
cd c:\scripts
git clone https://github.com/AR-k12code/RTI_Scheduler
cd c:\scripts\RTI_scheduler
Copy-Item sample_settings.ps1 settings.ps1
````
Open the settings file and put your API token in, School Name and the number from RTI_scheduler. 

You can generate a new RTI Scheduler token by going to "Data Sync API > Authentication > Generate New Token"

## Attendance
````
.\RTIScheduler_Attendance.ps1
````

This script will pull the current days attendance and submit it to the RTI Scheduler.

## Roadmap
- [ ] Upload RTI Scheduler Attendance to eSchool (sample script included)
- [ ] Ignore duplicate/failed schedule stuff