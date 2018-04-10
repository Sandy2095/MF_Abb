#############################################################################################
# Perl options
#############################################################################################
#use strict ;
use warnings;
use OvTrace;
use OvPrum;
use OvCommon;

my $traceObj = OvTrace->new($Policy, $ConsoleMessage, $Rule, $Session);      

my $AlertString="";
my $ProcString="";

sub DisplayTopHoggingProcess
{              
                # Get top 10 memory hogging process
                my $prumObj = OvPrum->new($OVOSystem);
                my $numprocs=10;
                my $ProcessList = $prumObj->getTopMemoryHoggingProcess($numprocs);       
                if ( $ProcessList and scalar(@$ProcessList) )
                {
                                $ProcString .= "Top ".$numprocs." memory hogging processes are listed below :\n";
                                $ProcString .= "\nKBused             PID         Process\n\n";
                                foreach ( @$ProcessList)
                                {
                                  $ProcString .= $$_{kbused}."    ".$$_{pid}."        ".$$_{args}."\n";
                                }
                }
                $Session->Value("ProcString",$ProcString);
}

sub ReadInputFromCoda
{
                # Get OS name
                # $_=shift;
                my $OS =shift;
                
                my $source = "CODA";
                if (OvCommon::PaCheck()) {
                                $source = "SCOPE";
                }
                $Session->Value('source', $source);        
                
                # Get Memory utilization, PageOut rate from CODA
                my $MemUtilSrc = $Policy->Source("MemUtil");
                $Session->Value("MemUtil", $MemUtilSrc->Value() );
                
                my $MemPageOutRateSrc = $Policy->Source("MemPageOutRate");
                $Session->Value("MemPageOutRate",$MemPageOutRateSrc->Value() );
                
                my $MemAvailSrc = $Policy->Source("MemAvail");
                $Session->Value("MemAvail", $MemAvailSrc->Value() );
                                
                # Trace enabled
                my $DbgStr;
                if ($Debug)
                {
                                $DbgStr .= "\n Memory utilization (%) = ".$Session->Value("MemUtil");
                                $DbgStr .= "\n Page out rate (Pages/sec) = ".$Session->Value("MemPageOutRate");
                                $DbgStr .= "\n Available memory (MB) = ".$Session->Value("MemAvail");
                                $traceObj->WriteTraceLog($Debug, "Current Values (Trace): \n".$DbgStr); # sends console message
                }
                
                # Define Alertstring
                $AlertString .= "\n  Memory utilization = ".(sprintf "%.2f", $Session->Value("MemUtil"))." %";
                $AlertString .= "\n  Page out rate (pages/sec) = ".(sprintf "%.2f", $Session->Value("MemPageOutRate"));
                
                # Get OS-specific metrics from CODA
                $_=$OS;
                SWITCH: 
                {
                                /WIN/i      && do {                                            
                                                # Get MEM_PAGE_REQUEST_RATE, MEM_CACHE_FLUSH_RATE values for Windows
                                                if ($Session->Value("Source") eq "SCOPE") 
                                                {
                                                                my $MemPageReqRateSrc = $Policy->SourceEx("CODA\\\\$source\\\\GLOBAL\\\\GBL_MEM_PAGE_REQUEST_RATE");
                                                                $Session->Value("MemPageReqRate", $MemPageReqRateSrc->Value() );
                                                                my $MemCacheFlushRateSrc = $Policy->SourceEx("CODA\\\\$source\\\\GLOBAL\\\\GBL_MEM_CACHE_FLUSH_RATE");
                                                                $Session->Value("MemCacheFlushRate", $MemCacheFlushRateSrc->Value() );                                
                                                                
                                                                # Trace enabled
                                                                if ($Debug)
                                                                {
                                                                                $DbgStr .= "\n Page req rate (Pages/sec) = ".$Session->Value("MemPageReqRate");
                                                                                $DbgStr .= "\n Cache flush rate (MB) = ".$Session->Value("MemCacheFlushRate");
                                                                                $traceObj->WriteTraceLog($Debug, "Current Values (Trace): \n".$DbgStr); # sends console message
                                                                }
                                                                
                                                                # Define Alertstring
                                                                $AlertString .= "\n  Page request rate (pages/sec)= ".(sprintf "%.2f", $Session->Value("MemPageReqRate"));
                                                                $AlertString .= "\n  Cache flush rate (MB) = ".(sprintf "%.2f", $Session->Value("MemCacheFlushRate"))."\n";
                                                }
                                                else
                                                {
                                                                # Trace enabled
                                                                if ($Debug)
                                                                {
                                                                                $DbgStr .= "\n Available memory (MB) = ".$Session->Value("MemAvail");
                                                                                $traceObj->WriteTraceLog($Debug, "Current Values (Trace): \n".$DbgStr); # sends console message
                                                                }                                                              
                                                                # Define Alertstring
                                                                $AlertString .= "\n  Available memory (MB)= ".(sprintf "%.2f", $Session->Value("MemAvail"))."\n";
                                                }
                                                
                                                # Get Free Page Table Entries from PERFMON
                                                my $FreePageTable = $Policy->SourceEx("NTPERFMON\\\\Memory\\\\Free System Page Table Entries");
                                                $Session->Value("FreePageTable", $FreePageTable->Value() );
                                                
                                                # Trace enabled
                                                if ($Debug)
                                                {
                                                                $DbgStr .= "\n Free Page Table = ".$Session->Value("FreePageTable");
                                                                $traceObj->WriteTraceLog($Debug, "Free Page Table Values: \n".$DbgStr); # sends console message
                                                }
                                
                                                last SWITCH;
                                };
                                
                                /LINUX/i    && do {
                                                # Get MEM_SWAPOUT_BYTE_RATE value for Linux
                                                my $MemSwapoutByteRateSrc = $Policy->SourceEx("CODA\\\\$source\\\\GLOBAL\\\\GBL_MEM_SWAPOUT_BYTE_RATE");
                                                $Session->Value("MemSwapoutByteRate", $MemSwapoutByteRateSrc->Value() );
                                                
                                                # Trace enabled
                                                if ($Debug)
                                                {
                                                                $DbgStr .= "\n Swapout Byte rate (MB) = ".$Session->Value("MemSwapoutByteRate");
                                                                $traceObj->WriteTraceLog($Debug, "Current Values (Trace): \n".$DbgStr); # sends console message
                                                }
                                                
                                                # Define Alertstring
                                                $AlertString .= "\n  Swapout byte rate (MB)= ".(sprintf "%.2f", $Session->Value("MemSwapoutByteRate"))."\n";
                                                last SWITCH;
                                };
                                                
                                /AIX/i       && do {
                                                # Get MEM_PAGE_SCAN_RATE value for Aix
                                                my $MemPageScanRateSrc = $Policy->SourceEx("CODA\\\\$source\\\\GLOBAL\\\\GBL_MEM_PG_SCAN_RATE");
                                                $Session->Value("MemPageScanRate", $MemPageScanRateSrc->Value() );                                                                                       
                                                
                                                # Trace enabled
                                                if ($Debug)
                                                {
                                                                $DbgStr .= "\n Page Scan rate (Pages/sec) = ".$Session->Value("MemPageScanRate");
                                                                $traceObj->WriteTraceLog($Debug, "Current Values (Trace): \n".$DbgStr); # sends console message
                                                }
                                                
                                                # Define Alertstring
                                                $AlertString .= "\n  Page scan rate (pages/sec)= ".(sprintf "%.2f", $Session->Value("MemPageScanRate"))."\n";
                                                last SWITCH;
                                };
                                
                                (/HPUX/i or /SOLARIS/i)       && do {
                                                # Get MEM_PAGE_SCAN_RATE, MEM_SWAPOUT_BYTE_RATE value for HP-UX, Solaris
                                                my $MemPageScanRateSrc = $Policy->SourceEx("CODA\\\\$source\\\\GLOBAL\\\\GBL_MEM_PG_SCAN_RATE");
                                                $Session->Value("MemPageScanRate", $MemPageScanRateSrc->Value() );
                                                my $MemSwapoutByteRateSrc = $Policy->SourceEx("CODA\\\\$source\\\\GLOBAL\\\\GBL_MEM_SWAPOUT_BYTE_RATE");
                                                $Session->Value("MemSwapoutByteRate", $MemSwapoutByteRateSrc->Value() );
                                                
                                                # Trace enabled
                                                if ($Debug)
                                                {
                                                                $DbgStr .= "\n Swapout Byte rate (MB) = ".$Session->Value("MemSwapoutByteRate");
                                                                $DbgStr .= "\n Page Scan rate (Pages/sec) = ".$Session->Value("MemPageScanRate");
                                                                $traceObj->WriteTraceLog($Debug, "Current Values (Trace): \n".$DbgStr); # sends console message
                                                }
                                                
                                                # Define Alertstring
                                                $AlertString .= "\n  Swapout byte rate (MB)= ".(sprintf "%.2f", $Session->Value("MemSwapoutByteRate"));
                                                $AlertString .= "\n  Page scan rate (pages/sec)= ".(sprintf "%.2f", $Session->Value("MemPageScanRate"))."\n";
                                                last SWITCH;
                                };             
                } # end of SWITCH
                $Session->Value('AlertString',$AlertString);
} #End of ReadInputFromCoda


#MAIN PROGRAM LOGIC STARTS
my $OS = $^O;
$Session->Value('OS',$OS);

#Read the inputs from coda.
ReadInputFromCoda($OS);

# Get OS-specific memory counters to detect bottleneck condition
if( ($Session->Value("MemPageOutRate") > $Session->Value("MemPageOutRateCriticalThreshold")) and
    ($Session->Value("MemUtil") > $Session->Value("MemUtilCriticalThreshold")) )
{
                $_= $Session->Value('OS');
                SWITCH: 
                {
        /WIN/i      && do {
                # check if the source is CODA/PA
                                                if ( $Session->Value("Source") eq "SCOPE" )
                                                {
                                                               if ( ($Session->Value("MemPageReqRate") > $Session->Value("MemPageReqRateHighThreshold")) and 
                                                         ($Session->Value("MemCacheFlushRate") > $Session->Value("MemCacheFlushRateHighThreshold")) )
                                                    {
                                                                DisplayTopHoggingProcess();
                                                                $Rule->Status(1);                                                                            
                                                                }
                                                }
                                elsif ( ($Session->Value("MemAvail") < $Session->Value("FreeMemAvailCriticalThreshold")) ) 
                                                {
                                                                DisplayTopHoggingProcess();
                                                               $Rule->Status(1);
                                                }
                                                last SWITCH;
                    };
                    /LINUX/i      && do {
                                                if( ($Session->Value("MemSwapoutByteRate") > $Session->Value("MemSwapoutByteRateCriticalThreshold")) )
                                                {              
                                                                DisplayTopHoggingProcess();
                                                               $Rule->Status(1);
                                                                last SWITCH;
                                                }
        };             
        /AIX/i      && do {
                                                if( ($Session->Value("MemPageScanRate") > $Session->Value("MemPageScanRateCriticalThreshold")) )
                                                {
                                                                DisplayTopHoggingProcess();
                                                               $Rule->Status(1);
                                                                last SWITCH;
                                                }
        };             
       (/HPUX/i or /SOLARIS/i)       && do {
                                                if( ($Session->Value("MemPageScanRate") > $Session->Value("MemPageScanRateCriticalThreshold")) and
                                                                ($Session->Value("MemSwapoutByteRate") > $Session->Value("MemSwapoutByteRateCriticalThreshold")) )
                                                {
                                                                DisplayTopHoggingProcess();
                                                               $Rule->Status(1);
                                                                last SWITCH;
                                                }
        };             
                }# end of SWITCH
}
