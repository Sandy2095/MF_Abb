#! /bin/sh

OPCMON="/opt/OV/bin/OpC/opcmon"
OPCMSG1="/opt/OV/bin/OpC/opcmsg"
CNTL="/var/tmp/HostFSalarms.conf"
APPLICATION="file_th_system"
MSGRP=OS
loop=/tmp/vpo-inode-mon
OSTYPE="$( uname )"
mark=70

hp_ux ()
{
df -v | grep / |awk '{print $1";"$3 $4 $5}' |awk -F';' '{print $1}' > /tmp/temp_FS
arr=$(df -v | grep / |awk '{print $1";"$3 $4 $5}'|awk -F';' '{print $2}' | sed 's/[^0-9]//g' | xargs)
set -A array $(echo $arr)
count=0
while read each
do
echo $each"\t"${array[$count]} >> /tmp/org_FS
count=`expr $count + 1`
done </tmp/temp_FS
}

linux()
{
df -h | sed 1d  | xargs -n 6 | awk '{print $6"\t"$5}' | sed 's/%//g' > /tmp/org_FS
}

message ()
{
        #$OPCMSG1 severity=$SEVERITY application=$APPLICATION msg_grp=$MSGRP object=$OBJECT msg_text="$MSG"  node="USCHSLABVI005"
		#opcmsg sev='critical'  a='appli' msg_grp='OS' object='/opt' msg_text='Test /opt' node='USCHSLABVI005'
		echo $SEVERITY , $APPLICATION , $MSGRP , $OBJECT , $MSG

}

threshold()
{
#while read warn crit inode file_th
while read line 
do
set -A arr_thres $(echo $line)
min=${arr_thres[0]}
maj=${arr_thres[1]}
crit=${arr_thres[2]}
file_th=${arr_thres[4]}
echo $min -- $maj -- $crit -- $p -- $FS
  if echo $min | egrep -q '^[0-9]+$'
	then
    if [ $p -ge $min ] && [ $p -lt $maj ]

        then 
           SEVERITY="minor"
           MSG="Inode utilization of $file_th is currently $p%."
           OBJECT="$FS"		  
           message
	elif [ $p -ge $maj ]  && [ $p -lt $crit ]		
		then
		   SEVERITY="major"
           MSG="Inode utilization of $file_th is currently $p%."
           OBJECT="$FS"
		   message
	elif [ $p -ge $crit ]
	then
		   SEVERITY="critical"
           MSG="Inode utilization of $file_th is currently $p%."
           OBJECT="$FS"		   
		   message
	else
	echo "Normal"
    fi
  fi
done
}

[ "$OSTYPE" = "HP-UX" ] && hp_ux 
[ "$OSTYPE" = "Linux" ] && linux
while read FS p; 
do  
if [ $p -gt $mark ]
	then
		grep  $FS$ $CNTL | threshold
		# Note " $FS " . Those spaces make you quite intelligent and save from picking similar file_thsystems.
	else
			# Everything cool. 
			: # Do nothing
			#echo "normal"
	fi
done </tmp/org_FS

rm -r /tmp/org_FS



#setup_system_info
#df -i | cut -c40-200 | tail -n +2 | doit
#df -i | tail -n +2 | doit
date > $loop # For admin to check whether the monitor runs

$OPCMON fs_dfi_linux=0

exit 0

