#!/opt/opsware/bin/python2
import sys
import types

sys.path.append("/opt/opsware/pylibs2")
from pytwist import *
from pytwist.com.opsware.search import Filter
from pytwist.com.opsware.server import ServerRef
from pytwist.com.opsware.swmgmt import WindowsPatchPolicyRef
from pytwist.com.opsware.compliance import ObjectReference
from pytwist.com.opsware.compliance import *

TWISTHOST = "localhost"
patchPolicyName = '2018 Approved Windows 2008 Security Patches'

ts = twistserver.TwistServer(TWISTHOST)
SearchService = ts.search.SearchService
ComplianceScanService = ts.compliance.ComplianceScanService
ServerService = ts.server.ServerService

listPatchAttrs = [
    "name", "platform", "softwareRelease", "version", "updateId",
    "location", "downloadUrl", "fileName", "metadataSource",
    "createdBy", "checksum", "patchStatus"]

def getpatcheslist(patchpolID,serverid):
    patches = ComplianceScanService.getComplianceScanDetails(WindowsPatchPolicyRef(patchpolID),ServerRef(serverid))
    print summaries
##    try:
##        patches = ComplianceScanService.getComplianceScanDetails(WindowsPatchPolicyRef(patchpolID),ServerRef(serverid))
##        #summaries = ServerService.getComplianceScanSummaries(patchpolID,serverid)
##        print summaries
##    except Exception as err:
##        print 'unable list policies-',str(err)   
chec =[]
def getPatchLSerList(serverid):
    try:
         list_policy = ts.server.ServerService.getComplianceScans(ServerRef(serverid))
         for each in list_policy:
             if str(each).find('WindowsPatchPolicyRef') >= 0:
                 #getpatcheslist(scanlist,serverid)
                 chec.append(str(each).split(':')[-1].strip(')'))
                 print str(each).split(':')[-1].strip(')')
                 getpatcheslist(chec,serverid)
    except Exception as err:
        print 'unable list patch policy-',str(err)

def getServerID(hostname):
    id_filter = Filter()
    id_filter.objectType = 'device'
    id_filter.expression = 'ServerVO.hostname contains '+hostname
    try:
        if hostname:
            refs = SearchService.findObjRefs(id_filter)
            if refs:                
                print (str(refs[0]).split(':')[-1].strip(')'))
                getPatchLSerList(str(refs[0]).split(':')[-1].strip(')'))
    except Exception as err:
        print 'unable to find server ref using hostname-', str(err)
getServerID('WA00637Q')


def fetchAttr(objectZed, strAttr):
    listFilterStrings = ["|", "\r", "\n"]
    if "." in strAttr:
            (parentAttr, childAttr) = strAttr.split(".", 1)
            parentReturn = getattr(objectZed, parentAttr)
            attrReturn = fetchAttr(parentReturn, childAttr)
    else:
            if objectZed:
                    attrReturn = getattr(objectZed, strAttr)
            else:
                    attrReturn = objectZed
    if attrReturn is None:
        attrReturn = ''
    if attrReturn is True:
        attrReturn = 'True'
    if attrReturn is False:
        attrReturn = 'False'
    if type(attrReturn) == types.InstanceType and dir(attrReturn) != []:
            if "id" and "idAsLong" and "name" in dir(attrReturn):
                    attrReturn = attrReturn.name
    if type(attrReturn) == types.StringType:
            for filterStr in listFilterStrings:
                    attrReturn = attrReturn.replace(filterStr, "")
    return str(attrReturn)

       
def walkAttrs(objectZed, listAttrs):
    """
    used to return a list with the results for a list of given attributes
    """
    return [fetchAttr(objectZed, strAttr) for strAttr in listAttrs]


def getPatchesFromPatchPolicy(policyName=None):
    """
    used to fetch list of VO's for every patch attached to a given patch policy
    """
    myFilter = com.opsware.search.Filter()
    if policyName:
        myFilter.expression = '{PatchPolicyVO.name = "%s"}' % (policyName)
    ppservice = ts.swmgmt.PatchPolicyService
    listPatchPolicyRefs = ppservice.findPatchPolicyRefs(myFilter)

    if len(listPatchPolicyRefs) == 0:
            print "Policy '%s' not found in HP SA!" % (policyName)
            sys.exit(4)

    if len(listPatchPolicyRefs) > 1:
            print "Duplicate patch policy '%s' in HP SA!" % (policyName)
            sys.exit(4)
    patchPolicyVO = ppservice.getPatchPolicyVO(listPatchPolicyRefs[0])
    listPatchRefs = ppservice.getPatches(listPatchPolicyRefs)
    listPatchVOs = ts.pkg.UnitService.getUnitVOs(listPatchRefs)

    return (patchPolicyVO, listPatchVOs)


def getHotfixInfo(listHotfixVOs):
    listHotfixes = []
    for hotfixVO in listHotfixVOs:
        dictHotfixInfo = walkAttrs(hotfixVO, listPatchAttrs)
        if (dictHotfixInfo in listHotfixes) and warnDupes:
            print "!!!DUPLICATE FOUND: %s" % (dictHotfixInfo)
        listHotfixes.append(dictHotfixInfo)

    return listHotfixes


##try:
##    (patchPolicyVO, listHotfixVOs) = getPatchesFromPatchPolicy(patchPolicyName)
##    listHotfixes = getHotfixInfo(listHotfixVOs)
##    for entry in listHotfixes:
##        print entry
##except:
##    print "Something Didn't Work"
