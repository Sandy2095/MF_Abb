#! /bin/sh

###############################################################################
#							
# File:         fs_dfi_linux.sh					
#                                                                         
# Description:  Monitor inode utilization of a File System on Linux
#                                                                	
###############################################################################

################################################################################
# Functions
################################################################################

OPCMON="/opt/OV/bin/OpC/opcmon"
OPCMSG1="/opt/OV/bin/OpC/opcmsg"
CNTL="/tmp/file"
APPLICATION="file_system"
MSGRP=OS
loop=/tmp/vpo-inode-mon

mark=50


# Get listing. Accomodate long device names.
df -i | egrep -v "Filesystem            Inodes   IUsed   IFree IUse% Mounted on" | awk '{ if (NF==5) print $4 "\t" $5 } { if (NF==6) print $5 "\t" $6}'|sed 's/%//g' | while read p FS 
	do
	if [ $p -gt $mark ]
	then
			# We got problem here. 
			egrep " $FS " $CNTL | threshold 
			# Note " $FS " . Those spaces make you quite intelligent and save from picking similar Filesystems.
	else
			# Everything cool. 
			: # Do nothing
	fi
	
	done # Close the loop.

							
message ()
{
        $OPCMSG1 severity=$SEVERITY \
        application=$APPLICATION msg_grp=$MSGRP object=$OBJECT \
        msg_text="$MESSAGE"  node="`hostname`"

}

opcmsg sev='critical'  a='appli' msg_grp='OS' object='/opt' msg_text='Test /opt' node='USCHSLABVI005'

threshold()
{
#while read warn crit inode file
while read crit maj warn

  do
  echo $crit---$maj---$warn---
      if [ $p -ge $crit ]
        then 
           SEVERITY=critical
           MESSAGE="Inode utilization of $file is currently $p%."
           OBJECT=$FS
           message
	elif [ $p -ge $maj ]
		then
			SEVERITY=major
           MESSAGE="Inode utilization of $file is currently $p%."
           OBJECT=$FS
		   message
	else
		   SEVERITY=warning
           MESSAGE="Inode utilization of $file is currently $p%."
           OBJECT=$FS
		   message
      fi

   done

}

#setup_system_info
#df -i | cut -c40-200 | tail -n +2 | doit
#df -i | tail -n +2 | doit
date > $loop # For admin to check whether the monitor runs

$OPCMON fs_dfi_linux=0

exit 0
