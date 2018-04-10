my ($mode, $server) = @ARGV;
use POSIX qw(strftime);
my $date_en = strftime "%Y_%m_%d", localtime;
system('echo ------------------------- >> /home/abvwintel/SNOW_monitor_log_'.$date_en);
system('date  >> /home/abvwintel/SNOW_monitor_log_'.$date_en);
$command='sudo ovpolicy -d -all -host '.$server;
$disable_cmd='sudo /opt/OV/bin/OpC/utils/opcnode -chg_nodetype node_type=DISABLED net_type=NETWORK_IP node_name='.$server;
$command1='sudo ovpolicy -e -all -host '.$server;
$control_cmd='sudo /opt/OV/bin/OpC/utils/opcnode -chg_nodetype node_type=CONTROLLED net_type=NETWORK_IP node_name='.$server;
if($mode eq '0'){
system('echo '.$server.' disabled >> /home/abvwintel/SNOW_monitor_log_'.$date_en);
system($command);
system($disable_cmd);
}
else
{
system('echo '.$server.' enabled >> /home/abvwintel/SNOW_monitor_log_'.$date_en);
system($command1);
system($control_cmd);
}

