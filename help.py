long_str="""Hostname: WR00063Q\n
       * List installed policies for host 'WR00063Q'.
         
  Type              Name                        Status     Version
 --------------------------------------------------------------------
  configsettings    "OVO settings"              enabled    1        
  le                "Abbvie_SI-MSWindowsServer_Reboot"   disabled   0001.0001
  mgrconf           "OVO authorization"         enabled    1        
  monitor           "AbbVie_Win_SI-MSWindowsPerfMonCollector"   disabled   0001.0000
  monitor           "Abbvie_SI-MSWindowsVMWareMonitor"   disabled   0001.0001
  monitor           "Abbvie_SI-MSWindows_CitrixCseEngine"   disabled   0001.0005
  monitor           "Abbvie_SI-MSWindows_IMAService"   disabled   0001.0004
  monitor           "Abbvie_SI-MSWindows_MFCom"   disabled   0001.0004
  monitor           "Abbvie_SI-MSWindows_cpsvc"   disabled   0001.0008
  monitor           "DSIService_service_monitoring"   disabled   0001.0000
  monitor           "Dnscache_service_monitoring"   disabled   0001.0000
  monitor           "EventLog_service_monitoring"   disabled   0001.0000
  monitor           "LanmanServer_service_monitoring"   disabled   0001.0000
  monitor           "LanmanWorkstation_service_monitoring"   disabled   0001.0000
  monitor           "MIService_service_monitoring"   disabled   0001.0000
  monitor           "MWECService_service_monitoring"   disabled   0001.0000
  monitor           "McShield_service_monitoring"   disabled   0001.0000
  monitor           "Netlogon_service_monitoring"   disabled   0001.0000
  monitor           "OpswareAgent_service_monitoring"   disabled   0001.0000
  monitor           "OvCtrl_service_monitoring"   disabled   0001.0000
  monitor           "ProfSvc_service_monitoring"   disabled   0001.0000
  monitor           "RpcSs_service_monitoring"   disabled   0001.0000
  monitor           "Schedule_service_monitoring"   disabled   0001.0000
  monitor           "TTService_service_monitoring"   disabled   0001.0000
  monitor           "TermService_service_monitoring"   disabled   0001.0000
  monitor           "W32Time_service_monitoring"   disabled   0001.0000
  monitor           "W3SVC_service_monitoring"   disabled   0001.0000
  monitor           "Windows_SI-MemoryBottleneckDiagnosis"   disabled   0001.0000
  monitor           "Winmgmt_service_monitoring"   disabled   0001.0000
  monitor           "avbackup_service_monitoring"   disabled   0001.0000
  monitor           "gpsvc_service_monitoring"   disabled   0001.0000
  monitor           "lmhosts_service_monitoring"   disabled   0001.0000
  monitor           "windows_SI-CPUBottleneckDiagnosis"   disabled   0001.0000
  monitor           "windows_SI-DiskCapacityMonitor"   disabled   0001.0000
  monitor           "windows_SI-SwapCapacityMonitor"   enabled    0001.0001
  msgi              "Abbvie_opcmsg(1|3)"        disabled   0001.0003
"""

for i in long_str.split("Hostname:")[1:]:
    if i.find('disabled') >= 0:
        print 'disabled' , i.split("\n\n")[0]
        f = open('C:\Working_Project\Python_Proj\PyFiles\Build_Final\disabled.txt', 'a')
        f.write("Hostname: "+i) 
        f.close()
    else:
        if len(i) >= 100:
            print "enabled", i.split("\n\n")[0]
            f = open('enabled.txt', 'a')
            f.write("Hostname: "+i)
            f.close()
        else:
            print "Policies not listed on text file" ,i.split("\n\n")[0]
