#!/bin/sh
if [ $# -eq 0 ]
  then
    echo "No arguments supplied, Please provide parameter 0(NOTMANAGED) or 1(MANAGED)"
   exit 0
fi
if [ $1 -gt 0 ]
then
ser_staus="MANAGED"
else
ser_staus="NOTMANAGED"
fi
DATE=`date +%Y_%m_%d`
while read each
do
if [ ! -z "$each" ]
then
deviceName=`echo $each | awk '{print tolower($0)}'`
echo $deviceName","$ser_staus >> /home/abbvienoc/Alert_Suppression/servers_modified.csv
fi
done </home/abbvienoc/Alert_Suppression/servers.list

sudo /opt/OV/bin/nnmmanagementmode.ovpl -t node -f /home/abbvienoc/Alert_Suppression/servers_modified.csv >> /home/abbvienoc/Alert_Suppression/log.out
cat /home/abbvienoc/Alert_Suppression/log.out
echo "--------------------------" >> /home/abbvienoc/Monitor_log_$DATE.out
echo `date` >> /home/abbvienoc/Monitor_log_$DATE.out
echo "--------------------------" >> /home/abbvienoc/Monitor_log_$DATE.out
cat /home/abbvienoc/Alert_Suppression/log.out >> /home/abbvienoc/Monitor_log_$DATE.out
rm -rf /home/abbvienoc/Alert_Suppression/servers_modified.csv /home/abbvienoc/Alert_Suppression/log.out