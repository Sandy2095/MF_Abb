import subprocess as sub
p = sub.call("""opcnode -list_nodes group_name=linux net_type=NETWORK_IP | grep Name |awk '{gsub("Name         = ", "", $0); print}'""",stdout=sub.PIPE,stderr=sub.PIPE)
output, errors = p.communicate()
print output ,errors


opcnode -list_nodes group_name=windows net_type=NETWORK_IP | grep Name |awk '{gsub("Name         = ", "", $0); print}'

import subprocess
output = subprocess.check_output(["""opcnode -list_nodes group_name=linux net_type=NETWORK_IP | grep Name |awk '{gsub("Name         = ", "", $0); print}'"""])
print 'Have %d bytes in output' % len(output)
print output

import subprocess 
p1 = subprocess.Popen(['opcnode','-list_nodes','group_name=linux','net_type=NETWORK_IP' ], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
p2 = subprocess.Popen(['grep','Name'],stdin=p1.stdout, stdout=subprocess.PIPE,stderr=subprocess.PIPE)
out, err = p2.communicate()
print out

p2 = subprocess.Popen('sed ...', stdin=p1.stdout, stdout=subprocess.PIPE)
print p2.communicate()



import subprocess
p1 = subprocess.Popen(['opcnode','-list_nodes','group_name=linux','net_type=NETWORK_IP'], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
p2 = subprocess.Popen(['grep', 'Name'],stdin=p1.stdout, stdout=subprocess.PIPE,stderr=subprocess.PIPE)
out, err = p2.communicate()
for i_u in out.split("Name         = "):
        p_out = subprocess.Popen(['opcragt',i_u.strip("\n")], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        p_rest ,p_err=p_out.communicate()
        if p_rest.find("isn't") >= 0:
                for p_val in p_rest.split("\n"):
                        if p_val.find("isn't") >=0:
                                print i_u.strip("\n"),' '.join(p_val.split()[:-3]),"Not Running"
        elif p_rest.find('certificate') >= 0:
                print i_u.strip("\n"),"NA","Certificate Issue"
        elif p_rest.find('Transport') >= 0:
                print i_u.strip("\n"),"NA","Port Issue"

import subprocess
p1 = subprocess.Popen(['opcnode','-list_nodes','group_name=linux','net_type=NETWORK_IP'], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
p2 = subprocess.Popen(['grep', 'Name'],stdin=p1.stdout, stdout=subprocess.PIPE,stderr=subprocess.PIPE)
out, err = p2.communicate()
rptHTML=""
rptHTML +="<table border=1>"
rptHTML+="<tr><th>Server Name</th><th>Process Name</th><th>Remarks</th></tr>"
for i_u in out.split("Name         = "):
        p_out = subprocess.Popen(['opcragt',i_u.strip("\n")], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        p_rest ,p_err=p_out.communicate()
        if p_rest.find("isn't") >= 0:
                for p_val in p_rest.split("\n"):
                        if p_val.find("isn't") >=0:
                                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>"+str(' '.join(p_val.split()[:-3]))+"</td><td>Not Running</td></tr>"
        elif p_rest.find('certificate') >= 0:
                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>NA</td><td>Certificate Issue</td></tr>"
        elif p_rest.find('Transport') >= 0:
                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>NA</td><td>Port Issue</td></tr>"
rptHTML+="</table>"
fobj= open("/tmp/Failure_Rpt.html",'w')
fobj.write(rptHTML)
fobj.close()

sh file content
cmd ="( cat body.txt; uuencode Failure_Rpt.html Failure_Rpt.html) | mail -s 'Failure Report' santhosh.kumar-e@hpe.com"

import subprocess
p1 = subprocess.Popen(['opcnode','-list_nodes','group_name=linux','net_type=NETWORK_IP'], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
p2 = subprocess.Popen(['grep', 'Name'],stdin=p1.stdout, stdout=subprocess.PIPE,stderr=subprocess.PIPE)
out, err = p2.communicate()
rptHTML=""
rptHTML +="<table border=1>"
rptHTML+="<tr><th>Server Name</th><th>Process Name</th><th>Remarks</th></tr>"
for i_u in out.split("Name         = "):
        p_out = subprocess.Popen(['opcragt',i_u.strip("\n")], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        p_rest ,p_err=p_out.communicate()
        if p_rest.find("isn't") >= 0:
                for p_val in p_rest.split("\n"):
                        if p_val.find("isn't") >=0:
                                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>"+str(' '.join(p_val.split()[:-3]))+"</td><td>Not Running</td></tr>"
        elif p_rest.find('certificate') >= 0:
                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>NA</td><td>Certificate Issue</td></tr>"
        elif p_rest.find('Transport') >= 0:
                rptHTML+="<tr><td>"+str(i_u.strip("\n"))+"</td><td>NA</td><td>Port Issue</td></tr>"
rptHTML+="</table>"
fobj= open("/tmp/Failure_Rpt.html",'w')
fobj.write(rptHTML)
fobj.close()
fail_p = subprocess.Popen(['sh','mail.sh'], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
out, err = fail_p.communicate()
print out