my ($mode) = @ARGV;
use POSIX qw(strftime);
my $day_time = strftime "%a_%H", localtime;
if($mode eq '1'){
$set_mode="_start";
}else
{
$set_mode="_end";
}
system('cat /opt/Mon_Scripts/Cpu_Suppression/serverFile.db | grep '.$day_time.$set_mode.'| awk -F , \'{print $1}\'>/opt/Mon_Scripts/Cpu_Suppression/temp_'.$day_time);
$file='/opt/Mon_Scripts/Cpu_Suppression/temp_'.$day_time; #server list path
system('echo ------------------------- >> /opt/Mon_Scripts/Cpu_Suppression/monitor_log_'.$date_en);
system('date  >> /opt/Mon_Scripts/Cpu_Suppression/monitor_log_'.$date_en);
open(my $fh, $file)
  or die "Could not open file '$file' $!";
open(my $fout, '>', '/opt/Mon_Scripts/Cpu_Suppression/Cpu_Suppression.html');
print $fout "<table border=1><tr bgcolor=CE97D8><th>Server Name</th><th>Status</th></tr>";
while (my $item = <$fh>)
{
  chomp $item;
$item =~ /^$/ and die "Blank line detected at $.\n";
$item =~ /^#/ and next;
$command='sudo /opt/OV/bin/ovpolicy -d -polname "windows_SI-CPUBottleneckDiagnosis"  -host '.$item;
$command1='sudo /opt/OV/bin/ovpolicy -e -polname "windows_SI-CPUBottleneckDiagnosis"  -host '.$item;
if($mode eq '0'){
system('echo '.$item.' disabled >> /opt/Mon_Scripts/Cpu_Suppression/monitor_log_'.$date_en);
if (system($command)==0)
{
print $fout  "<tr><td>".$item."</td><td>Disabled</td></tr>";
}
else
{
print $fout "<tr><td>".$item."</td><td bgcolor=red>Disable Failed Please contact Tools Team</td></tr>";
}
}
else
{
system('echo '.$item.' enabled >> /opt/Mon_Scripts/Cpu_Suppression/monitor_log_'.$date_en);
if (system($command1)==0)
{
print $fout "<tr><td>".$item."</td><td>Enabled</td></tr>";
}
else
{
print $fout "<tr><td>".$item."</td><td bgcolor=red>Enable Failed Please contact Tools Team</td></tr>";
}
}
}
print $fout "</table>";
close $fout;
#system('sh /opt/Mon_Scripts/Cpu_Suppression/Mail.sh')

