my ($mode) = @ARGV;
=pod
$hostname_string=`opcnode -list_nodes group_name=windows net_type=NETWORK_IP | grep Name`;
@total_host=split('\n',$hostname_string);
foreach $item (@total_host){
$item=~ s/Name         = //;
=cut
$file='/tmp/pooja/Lambo/suppress.lst'; #server list path
open(my $data, '<', $file) or die "Could not open '$file' $!\n";
while($item=<$data>){
$command='ovpolicy -d -all -host '.$item;
$command1='ovpolicy -e -all -host '.$item;
if($mode eq '0'){
system($command);
}
else
{
system($command1);
}


}



print " This is perl program";
$current_user=`whoami`;
print "$current_user\n";
$current_process=`ps -ef | grep loop.pl | grep "$current_user" | wc -l`;
print "$current_process\n";
#@total_process=split('\n',$current_process);
#print @total_process;
#$cnt_process =@total_process;
#print $cnt_process;






my ($mode) = @ARGV;
use POSIX qw(strftime);
my $date_en = strftime "%Y_%m_%d", localtime;
$file='/home/abvwintel/Lamborghini/suppress.lst'; #server list path
system('echo ------------------------- >> /home/abvwintel/monitor_log_'.$date_en);
system('date  >> /home/abvwintel/monitor_log_'.$date_en);
open(my $fh, $file)
  or die "Could not open file '$file' $!";
while (my $item = <$fh>) {
  chomp $item;
$item =~ /^$/ and die "Blank line detected at $.\n";
$item =~ /^#/ and next;
$command='sudo ovpolicy -d -all -host '.$item;
$disable_cmd='sudo /opt/OV/bin/OpC/utils/opcnode -chg_nodetype node_type=DISABLED net_type=NETWORK_IP node_name='.$item;
$command1='sudo ovpolicy -e -all -host '.$item;
$control_cmd='sudo /opt/OV/bin/OpC/utils/opcnode -chg_nodetype node_type=CONTROLLED net_type=NETWORK_IP node_name='.$item;
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
