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

## Attendance from Cognos to RTI Scheduler
````
.\RTIScheduler_Attendance.ps1
````

This script will pull the current days attendance and submit it to the RTI Scheduler.

## Attedance from RTI Scheduler to eSchool
*YOU NEED TO UNDERSTAND WHAT YOU'RE DOING BEFORE EVER RUNNING THIS SCRIPT*
Refer back to the disclaimer and liability warning at the top!
````
.\RTIScheduler_Upload_ATT_to_eSchool.ps1 -RunMode [V|R]
````

This script will pull the attendance from RTI Scheduler for the RTI Period and upload the absence to eSchool.  This script by default runs in Verification mode. Meaning it will not actually make the changes on the eSchool Database Tables. You must run it with the parameter ```` -RunMode R ```` after you have sufficiently tested this process.

This process requires the ESMU6 upload defintion from the eSchoolModule. You can run the following command to create it.
````
New-eSPAttUploadDefinitions
````

## Roadmap
- [ ] Ignore duplicate/failed schedule stuff