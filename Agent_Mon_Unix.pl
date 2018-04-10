import subprocess
rcCnt=1
p1 = subprocess.Popen(['/opt/OV/bin/OpC/utils/opcnode','-list_nodes','group_name=linux','net_type=NETWORK_IP'], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
p2 = subprocess.Popen(['grep', 'Name'],stdin=p1.stdout, stdout=subprocess.PIPE,stderr=subprocess.PIPE)
out, err = p2.communicate()
rptHTML=""
rptHTML +="<table border=1>"
rptHTML+="<tr><th>Server Name</th><th>Process Name</th><th>Remarks</th></tr>"
for i_u in out.split("Name         = "):
        fobj= open("/opt/Mon_Scripts/Unix_Failure_Rpt.log",'w')
        fobj.write(str(rcCnt))
        fobj.close()
        p_out = subprocess.Popen(['/opt/OV/bin/OpC/opcragt',i_u.strip("\n")], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        p_rest ,p_err=p_out.communicate()
        if p_rest.find("isn't") >= 0:
                for p_val in p_rest.split("\n"):
                        if p_val.find("isn't") >=0:
                                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>"+str(' '.join(p_val.split()[:-3]))+"</td><td>Not Running</td></tr>"
        elif p_rest.find('certificate') >= 0:
                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>NA</td><td>Certificate Issue</td></tr>"
        elif p_rest.find('Transport') >= 0 or p_rest.find('reset') >= 0:
                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>NA</td><td>Port Issue</td></tr>"
        elif p_rest.find('RPC') >= 0:
                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>NA</td><td>Server Not Responding</td></tr>"
        elif p_rest.find('authentication') >= 0:
                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>NA</td><td>Authentication Failed</td></tr>"
        rcCnt += 1
rptHTML+="</table>"
fobj= open("/opt/Mon_Scripts/Unix_Failure_Rpt.html",'w')
fobj.write(rptHTML)
fobj.close()
fail_p = subprocess.Popen(['sh','/opt/Mon_Scripts/Unix_Mail.sh'], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
out, err = fail_p.communicate()
print out