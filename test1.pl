my ($mode) = @ARGV;

$hostname_string=`sudo /opt/OV/bin/OpC/utils/opcnode -list_nodes group_name=windows net_type=NETWORK_IP | grep Name`;
@total_host=split('\n',$hostname_string);

$file='/home/abvwintel/Lamborghini/suppress.lst'; #server list path
open(my $fh, $file)
  or die "Could not open file '$file' $!";
 
while (my $item = <$fh>) {
  chomp $item;
$command='sudo ovpolicy -d -all -host '.$item;
$disable_cmd='sudo /opt/OV/bin/OpC/utils/opcnode -chg_nodetype node_type=DISABLED net_type=NETWORK_IP node_name='.$item;
$control_cmd='sudo /opt/OV/bin/OpC/utils/opcnode -chg_nodetype de_type=CONTROLLED net_type=NETWORK_IP node_name='.$item;
$command1='sudo ovpolicy -e -all -host '.$item;
if($mode eq '0'){
$push_data = `echo "$item" >>sample.data`;
system($command);
system($disable_cmd);
}
else
{
system($command1);
system($control_cmd);
}
}





$item =~ /^$/ and die "Blank line detected at $.\n";
$item =~ /^#/ and next;