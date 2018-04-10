my ($mode) = @ARGV;
use POSIX qw(strftime);
my $date_en = strftime "%Y_%m_%d", localtime;
$file='/opt/Mon_Scripts/Blackout_Cognos/suppress.lst'; #server list path
system('echo ------------------------- >> /opt/Mon_Scripts/Blackout_Cognos/monitor_log_'.$date_en);
system('date  >> /opt/Mon_Scripts/Blackout_Cognos/monitor_log_'.$date_en);
open(my $fh, $file)
  or die "Could not open file '$file' $!";
rptHTML=>"<table border=1><tr><th>Server Name</th><th>Status</th></tr>";
while (my $item = <$fh>) 
{
  chomp $item;
$item =~ /^$/ and die "Blank line detected at $.\n";
$item =~ /^#/ and next;
$command='sudo ovpolicy -d -all -host '.$item;
$disable_cmd='sudo /opt/OV/bin/OpC/utils/opcnode -chg_nodetype node_type=DISABLED net_type=NETWORK_IP node_name='.$item;
$command1='sudo ovpolicy -e -all -host '.$item;
$control_cmd='sudo /opt/OV/bin/OpC/utils/opcnode -chg_nodetype node_type=CONTROLLED net_type=NETWORK_IP node_name='.$item;
if($mode eq '0'){
system('echo '.$item.' disabled >> /opt/Mon_Scripts/Blackout_Cognos/monitor_log_'.$date_en);
if (system($command)==0)
{
rptHTML+='<tr><td>'.$item.'</td><td>Disabled</td></tr>';
}
else
{
rptHTML+='<tr><td>'.$item.'</td><td bgcolor=red>Disable Failed</td></tr>';
}
system($disable_cmd);
}
else
{
system('echo '.$item.' enabled >> /opt/Mon_Scripts/Blackout_Cognos/monitor_log_'.$date_en);
if (system($command1)==0)
{
rptHTML+='<tr><td>'.$item.'</td><td>Enabled</td></tr>';
}
else
{
rptHTML+='<tr><td>'.$item.'</td><td bgcolor=red>Enable Failed</td></tr>';
}
system($control_cmd);
}
}
print $rptHTML;





my ($mode) = @ARGV;
use POSIX qw(strftime);
my $date_en = strftime "%Y_%m_%d", localtime;
$file='/opt/Mon_Scripts/Blackout_Cognos/suppress.lst'; #server list path
system('echo ------------------------- >> /opt/Mon_Scripts/Blackout_Cognos/monitor_log_'.$date_en);
system('date  >> /opt/Mon_Scripts/Blackout_Cognos/monitor_log_'.$date_en);
open(my $fh, $file)
  or die "Could not open file '$file' $!";
while (my $item = <$fh>) 
{
  chomp $item;
$item =~ /^$/ and die "Blank line detected at $.\n";
$item =~ /^#/ and next;
$command='sudo ovpolicy -d -all -host '.$item;
$disable_cmd='sudo /opt/OV/bin/OpC/utils/opcnode -chg_nodetype node_type=DISABLED net_type=NETWORK_IP node_name='.$item;
$command1='sudo ovpolicy -e -all -host '.$item;
$control_cmd='sudo /opt/OV/bin/OpC/utils/opcnode -chg_nodetype node_type=CONTROLLED net_type=NETWORK_IP node_name='.$item;
if($mode eq '0'){
system('echo '.$item.' disabled >> /opt/Mon_Scripts/Blackout_Cognos/monitor_log_'.$date_en);
system($command);
system($disable_cmd);
}
else
{
system('echo '.$item.' enabled >> /opt/Mon_Scripts/Blackout_Cognos/monitor_log_'.$date_en);
system($command1);
system($control_cmd);
}
}
