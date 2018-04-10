$current_user=`whoami`;
$current_user=~s/\n//;
print "Currently '$current_user' is executing this script\n";
$user_id=`id -u $current_user`;
#print $user_id;
#sleep(100);
$current_process=`ps -ef | grep suppress.pl | grep "$user_id" | wc -l`;
print $current_process;
if ($current_process>3)
{
print "if";
print "Someone from your Team tried executing this Script. Please abort and try again..\n";
}
else
{
print "else";
my ($mode) = @ARGV;

$hostname_string=`/opt/OV/bin/OpC/utils/opcnode -list_nodes group_name=windows net_type=NETWORK_IP | grep Name`;
@total_host=split('\n',$hostname_string);

foreach $item (@total_host){
$item=~ s/Name         = //;
$file='/home/abvwintel/Lamborghini/suppress.lst'; #server list path
open(my $data, '<', $file) or die "Could not open '$file' $!\n";
while($item=<$data>){
$command='ovpolicy -d -all -host '.$item;
$command1='ovpolicy -e -all -host '.$item;
if($mode eq '0'){
$push_data = `echo "$item" >>sample.data`;
system($command);
}
else
{
system($command1);
}
}
}
}
