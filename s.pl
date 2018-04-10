use POSIX qw(strftime);
my $date_en = strftime "%Y_%m_%d_%a_%H", localtime;
print $date_en;


my $day_time = strftime "%a_%H", localtime;
print $day_time;
#system('cat serverFile.db | grep Fri_17| awk -F , \'{print $1}\'>temp_Fri_17')