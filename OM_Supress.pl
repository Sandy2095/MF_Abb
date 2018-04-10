my ($mode) = @ARGV;
use POSIX qw(strftime);
my $date_en = strftime "%Y_%m_%d", localtime;
$file='/home/abvwintel/Lamborghini/suppress.lst'; #server list path
system('echo ------------------------- >> /home/abvwintel/monitor_log_'.$date_en                                                                                                                      );
system('date  >> /home/abvwintel/monitor_log_'.$date_en);
open(my $fh, $file)
  or die "Could not open file '$file' $!";
while (my $item = <$fh>) {
  chomp $item;
$item =~ /^$/ and die "Blank line detected at $.\n";
$item =~ /^#/ and next;
$command='sudo ovpolicy -d -all -host '.$item;
$disable_cmd='sudo /opt/OV/bin/OpC/utils/opcnode -chg_nodetype node_type=DISABLE                                                                                                                      D net_type=NETWORK_IP node_name='.$item;
$command1='sudo ovpolicy -e -all -host '.$item;
$control_cmd='sudo /opt/OV/bin/OpC/utils/opcnode -chg_nodetype node_type=CONTROL                                                                                                                      LED net_type=NETWORK_IP node_name='.$item;
if($mode eq '0'){
system('echo '.$item.' disabled >> /home/abvwintel/monitor_log_'.$date_en);
system($command);
system($disable_cmd);
}
else
{
system('echo '.$item.' enabled >> /home/abvwintel/monitor_log_'.$date_en);
system($command1);
system($control_cmd);
}
}
