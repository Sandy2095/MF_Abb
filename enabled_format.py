import subprocess
load_policy="""------------------------------
uf00004d.abbvienet.dmz
------------------------------
  configsettings    "OVO settings"              enabled    1        
  le                "LinuxBootLog"              enabled    0001.0001
  le                "Linux_Log_Custom_Msg"      enabled    0001.0001
  le                "SI-LinuxKernelLog"         enabled    1111.0005
  mgrconf           "OVO authorization"         enabled    1        
  monitor           "AbbVie_Linux_SI-DiskCapacityMonitor"   enabled    0001.0009
  monitor           "AbbVie_SI-CPUBottleneckDiagnosis"   enabled    0001.0004
  monitor           "AbbVie_SI-MemoryBottleneckDiagnosis"   enabled    0001.0004
  monitor           "AbbVie_SI-SwapCapacityMonitor"   enabled    0001.0005
  msgi              "Abbvie_opcmsg(1|3)"        enabled    0001.0003
------------------------------
uq00207d.abbvienet.com
------------------------------
  configsettings    "OVERRIDE_ORACLE_FS"        enabled    0001.0012
  configsettings    "OVO settings"              enabled    1        
  le                "LinuxBootLog"              enabled    0001.0001
  le                "Linux_Log_Custom_Msg"      enabled    0001.0001
  le                "SI-LinuxKernelLog"         enabled    1111.0005
  mgrconf           "OVO authorization"         enabled    1        
  monitor           "AbbVie_Linux_SI-DiskCapacityMonitor"   enabled    0001.0009
  monitor           "AbbVie_SI-CPUBottleneckDiagnosis"   enabled    0001.0004
  monitor           "AbbVie_SI-MemoryBottleneckDiagnosis"   enabled    0001.0004
  monitor           "AbbVie_SI-SwapCapacityMonitor"   enabled    0001.0005
  msgi              "Abbvie_opcmsg(1|3)"        enabled    0001.0003
------------------------------
ua00384d.abbvienet.com
------------------------------
  configsettings    "OVO settings"              enabled    1        
  le                "LinuxBootLog"              enabled    0001.0001
  le                "Linux_Log_Custom_Msg"      enabled    0001.0001
  le                "SI-LinuxKernelLog"         enabled    1111.0005
  mgrconf           "OVO authorization"         enabled    1        
  monitor           "AbbVie_Linux_SI-DiskCapacityMonitor"   enabled    0001.0009
  monitor           "AbbVie_SI-CPUBottleneckDiagnosis"   enabled    0001.0004
  monitor           "AbbVie_SI-MemoryBottleneckDiagnosis"   enabled    0001.0004
  monitor           "AbbVie_SI-SwapCapacityMonitor"   enabled    0001.0005
  msgi              "Abbvie_opcmsg(1|3)"        enabled    0001.000"""

spl_list=load_policy.split("------------------------------")
def new_dict_exec(spl_list):
    dict_policy = {}
    garbage_list=[]
    for waste in range(1,len(spl_list)):
        if waste % 2 !=0:
            key_dic_policy = spl_list[waste].strip("\n").strip()
        else:
            for useme in spl_list[waste].split("\n"):
                if len(useme) > 2:
                    garbage_list.append(' '.join(useme.split()[1:-2]))
            dict_policy[key_dic_policy]=garbage_list
            garbage_list=[]
    return dict_policy
#print new_dict_exec(spl_list)
for host , policies in new_dict_exec (spl_list).items():
    fobj= open("enable_policy.log",'a')    
    if host:
        fobj.write(host+"\n"+"------------------------------")
        for each_policy in policies:
            proces = subprocess.Popen(['/opt/OV/bin/ovpolicy','-e','-polname','-host',host], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
            out, err = proces.comunicate()
            f.write(out+"\n")
    fobj.close()

            
            
##tst_lst=[]
##dist={}
##for i in str1.split("\n"):
##	if i.find(".abbvienet.com") >=0:
##		key_host=i.strip("\n").strip()
##	elif len(i.split()) >= 2:
##		tst_lst.append(' '.join(i.split()[1:-2]).strip('"'))
##dist[key_host] = tst_lst
##print dist
