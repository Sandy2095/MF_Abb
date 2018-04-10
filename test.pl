import subprocess
rcCnt = 1
p1 = subprocess.Popen(['/opt/OV/bin/OpC/utils/opcnode','-list_nodes','group_name=linux','net_type=NETWORK_IP'], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
p2 = subprocess.Popen(['grep', 'Name'],stdin=p1.stdout, stdout=subprocess.PIPE,stderr=subprocess.PIPE)
out, err = p2.communicate()
rptHTML=""
hostNotRun,certIssue,portIssue,serNotResp,authFail=[],[],[],[],[]
rptHTML +="<table border=1>"
rptHTML+="<tr  bgcolor='orange'><th>Server Name</th><th>Process Name</th><th>Remarks</th></tr>"
for i_u in out.split("Name         = "):
        fobj= open("/opt/Mon_Scripts/Unix_Failure_Rpt.log",'w')
        fobj.write(str(rcCnt))
        fobj.close()
        print rcCnt
        p_out = subprocess.Popen(['/opt/OV/bin/OpC/opcragt',i_u.strip("\n")], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        p_rest ,p_err=p_out.communicate()
        if p_rest.find("isn't") >= 0:
                for p_val in p_rest.split("\n"):
                        if p_val.find("isn't") >=0:
                                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>"+str(' '.join(p_val.split()[:-3]))+"</td><td>Not Running</td></tr>"
                                hostNotRun.append(str(i_u.strip("\n")))
        elif p_rest.find('certificate') >= 0:
                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>NA</td><td>Certificate Issue</td></tr>"
                certIssue.append(str(i_u.strip("\n")))
        elif p_rest.find('Transport') >= 0 or p_rest.find('reset') >= 0:
                portIssue.append(str(i_u.strip("\n")))
                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>NA</td><td>Port Issue</td></tr>"
        elif p_rest.find('RPC') >= 0:
                serNotResp.append(str(i_u.strip("\n")))
                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>NA</td><td>Server Not Responding</td></tr>"
        elif p_rest.find('authentication') >= 0:
                authFail.append(str(i_u.strip("\n")))
                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>NA</td><td>Authentication Failed</td></tr>"
        rcCnt +=1
rptHTML+="</table><br>"
rptHTML+="<table border=1><tr bgcolor='orange'><th>Remarks</th><th>Count</th></tr><tr><td>Process Not Running</td><td>"+str(len(set(hostNotRun)))+"</td></tr> <tr><td>Certificate Issue</td><td>"+str(len(set(certIssue)))+"</td></tr><tr><td>Port Issue</td><td>"+str(len(set(portIssue)))+"</td></tr><tr><td>Server Not Responding</td><td>"+str(len(set(serNotResp)))+"</td></tr><tr><td>Authentication Failed</td><td>"+str(len(set(authFail)))+"</td></tr><tr><td>Agents Up & Running</td><td>"+str(int(rcCnt)-(len(set(hostNotRun))+len(set(certIssue))+len(set(portIssue))+len(set(serNotResp))+len(set(authFail))))+"</td></tr><tr bgcolor='orange'><td>Total Server Count</td><td>"+str(rcCnt)+"</td></tr></table>"
fobj= open("/opt/Mon_Scripts/Unix_Failure_Rpt.html",'w')
fobj.write(rptHTML)
fobj.close()