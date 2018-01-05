#!../../bin/darwin-x86/scan

## You may have to change scan to something else
## everywhere it appears in this file

< envPaths

epicsEnvSet("Sys", "Test:")
epicsEnvSet("Dev", "")
epicsEnvSet("MaxScanPts", "4000")
epicsEnvSet("PREFIX", "Test:")
epicsEnvSet("IOC_PREFIX", "Test:Scan")
epicsEnvSet("AS_PATH", "${TOP}/autosave")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "100000")
#epicsEnvSet("EPICS_CA_ADDR_LIST", "10.3.1.255")
#epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")

cd $(TOP)

## Register all support components
dbLoadDatabase("dbd/scan.dbd",
scan_registerRecordDeviceDriver(pdbbase) 

## Load record instances
dbLoadRecords("db/scan.db","P=$(Sys)$(Dev),MAXPTS1=$(MaxScanPts),MAXPTS2=$(MaxScanPts),MAXPTS3=$(MaxScanPts),MAXPTS4=$(MaxScanPts),MAXPTSH=$(MaxScanPts)")
dbLoadRecords("db/saveData.db","P=$(Sys)$(Dev)")

dbLoadRecords("db/iocAdminSoft.db", "IOC=$(IOC_PREFIX)")
dbLoadRecords("db/save_restoreStatus.db", "P=$(IOC_PREFIX):")

save_restoreSet_Debug(0)
save_restoreSet_IncompleteSetsOk(1)
save_restoreSet_DatedBackupFiles(1)
save_restoreSet_status_prefix("$(IOC_PREFIX):")

set_requestfile_path("${AS_PATH}/","/req")
set_requestfile_path("${SSCAN}/sscanApp/Db","/req")
set_savefile_path("${AS_PATH}","/sav")

set_pass0_restoreFile("auto_settings.sav")
set_pass1_restoreFile("auto_settings.sav")

iocInit()

create_monitor_set("auto_settings.req", 15 , "")

saveData_Init("iocBoot/$(IOC)/saveData.req", "P=$(Sys)$(Dev)")

