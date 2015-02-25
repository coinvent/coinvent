from gringo import *
import os, sys, time, subprocess, threading, shlex
from settings import *
from langCasl import *
from itertools import *


def findLeastGeneralizedBlends(modelAtoms, inputSpaces, maxCost, blends):

    # Parse model and execute actions on internal data structure to obtain the generalized inut spaces. 
    genInputSpaces = getGeneralizedSpaces(modelAtoms, inputSpaces)

    # Get possible combinations of generalization combinations
    blendCombis = getPossBlendCombis(genInputSpaces)    

    # initialize output string for casl file
    cstr = ''

    # First state generic spaces
    cstr = cstr + genInputSpaces["Generic"][0].toCaslStr()+"\n\n"
    # State all generalized input spaces:     
    for specName in genInputSpaces.keys():
        if specName == "Generic":            
            continue
        for spec in genInputSpaces[specName]:
            cstr = cstr + spec.toCaslStr()+"\n\n"
            cstr = cstr + "view GenTo"+spec.name+" : Generic to "+spec.name+" \n"
            
            renamings = {}
            for atom in modelAtoms:
                a = str(atom)
                if a[:4] == "exec":
                    act = getActFromAtom(a)
                    if act["actType"]  != "renameOp":
                        continue
                    if act["iSpace"] != toLPName(specName):
                        continue
                    # Add renaming only if operator is in target spec.
                    rnInOps = False
                    for op in spec.ops:                        
                        if act["argVect"][0] == op.name: 
                            rnInOps = True
                            break
                    if rnInOps: 
                        renamings[act["step"]] = act["argVect"]

            if len(renamings.keys()) > 0:
                cstr = cstr + " =  "
                for step in sorted(renamings.keys()):
                    cstr = cstr + renamings[step][1] + " |-> " + renamings[step][0] + ", "
                cstr = cstr[:-2]

                    # print act
                # if atom.find("exec(renameOp(") != -1:
                    # atomSpec = 
            cstr = cstr + " end\n\n"

    # State blends (colimit operation)
    for cost in sorted(blendCombis.keys()):
        print "Specifying blends with generalization cost of " + str(cost)
        
        for combi in blendCombis[cost]:            
            cstr = cstr + "spec Blend"
            for specName in combi.keys():
                sCost = combi[specName]
                cstr = cstr + "_" + specName + "-" + str(sCost)
            cstr = cstr + " = combine "
            for specName in combi.keys():
                spec = genInputSpaces[specName][combi[specName]]
                cstr = cstr + "GenTo"+spec.name+","
            cstr = cstr[:-1]
            cstr = cstr + " end\n\n"
    
    # First make sure file does not exists, and then write file. Try writing multiple times (this is necessary due to some strange file writing bug...)
    if os.path.isfile("amalgamTmp.casl"):
        os.system("rm amalgamTmp.casl")

    tries = 0
    while not os.path.isfile("amalgamTmp.casl") :        
        outFile = open("amalgamTmp.casl","w")
        outFile.write(cstr)
        outFile.close()
        tries = tries + 1
        if tries > 5:
            print "ERROR! file amalgamTmp.casl not yet written after "+ str(tries) + "tries. Aborting program... "
            exit(1)
    generalizationCost = sys.maxint
    for cost in sorted(blendCombis.keys()):
        consistent = -1
        print "Trying blends with generalization cost of " + str(cost)
        if cost > maxCost:
            print "cost "  +str(cost) + " > " + str(maxCost) + " too high, aborting..."
            os.remove("amalgamTmp.casl")
            os.system("rm *.tptp")
            return [blends,maxCost]

        # TODO: do not blend if generic space is reached. 
        isBestBlendCost = False
        for combi in blendCombis[cost]:   
            thisCombiConsistent = -1
            blendName = "Blend" 
            for specName in combi.keys():
                sCost = combi[specName]
                blendName = blendName + "_" + specName + "-" + str(sCost)

            print "Checking consistency of " + blendName + ""
            #generate tptp format of theory and call eprover to check consistency
            blendTptpName = "amalgamTmp_"+blendName+".tptp"
            tries = 0

            # Try to generate input files several times. This is neccesary due to strange file writing bug. 
            while True:

                if os.path.isfile(blendTptpName):
                     blendFileSize = os.stat(blendTptpName).st_size
                else: 
                    blendFileSize = 0
                
                if blendFileSize != 0:
                    break
                
                print "generating tptp"
                subprocess.call([hetsExe, "-o tptp", "amalgamTmp.casl"])
                print "Done generating tptp"
                # This is a hack because hets sometimes seems to not generate all .tptp files. So we just try again and again until its working. 
                tries = tries + 1
                if tries > 5:
                    print "ERROR: File "+blendTptpName+" not yet written correctly "+ str(tries) + " times! Aborting..."
                    exit(1)

            thisCombiConsistent = checkConsistencyEprover(blendTptpName)
            if thisCombiConsistent == -1:
                print "Consistency could not be determined by eprover, trying darwin"
                thisCombiConsistent = checkConsistencyDarwin(blendTptpName)
                        
            # if thisCombiConsistent == 1: # If we can show that the blend is consistent
            if thisCombiConsistent != 0: # If we can not show that the blend is inconsistent
                prettyBlendStr = prettyPrintBlend(genInputSpaces,combi)
                blendInfo = {"combi" : combi, "prettyHetsStr" : prettyBlendStr, "blendName" : blendName, "generalizationCost" : cost}
                consistent = 1
                # If a better blend was found, delete all previous blends. 
                if cost < maxCost:
                    print "New min. cost: " + str(cost)
                    blends = []
                    maxCost = cost
                blends.append(blendInfo) 

        if consistent != 1:
            generalizationCost == sys.maxint
    raw_input()
    os.system("rm *.tptp")
    os.remove("amalgamTmp.casl")

    return [blends,generalizationCost]
    
def prettyPrintBlend(genInputSpaces,combi):

    lastSpecs = {}

    # state generic space
    cstr = genInputSpaces["Generic"][0].toCaslStr()+"\n\n"
    
    # initiate blend spec string
    blendStr =  "spec Blend = combine "
    for iSpaceName in genInputSpaces.keys():
        if iSpaceName == "Generic":
            continue
        lastSpecName = ''
        numGeneralizations = 0
        for spec in genInputSpaces[iSpaceName]:
            cstr = cstr + spec.toCaslStr()+"\n\n"
            # define view to previous spec. 
            if lastSpecName != '':
                cstr = cstr + "view "+spec.name+"To"+lastSpecName+" : " + spec.name + " to " +lastSpecName + " end \n\n"
            lastSpecName = spec.name
            # The most general input space has been found
            if numGeneralizations == combi[iSpaceName]:
                # view from generic space to generalized input space:
                cstr = cstr + "view GenTo"+lastSpecName+" : Generic to " + lastSpecName + " end \n\n"
                # Specify blend
                blendStr = blendStr + "GenTo"+spec.name+","
                break
            numGeneralizations = numGeneralizations + 1
        
    blendStr = blendStr[:-1] + " end\n\n"

    cstr = cstr + blendStr

    return cstr

# This function takes a list of blend speciications and writes them to disk.
def writeBlends(blends):
    raw_input
    os.system("rm Blend_*.casl")
    bNum = 0
    for blend in blends:
        blendStr = blend["prettyHetsStr"]
        fName = blend["blendName"] + "_c_"+str(blend["generalizationCost"])+"_b_"+str(bNum)+".casl"
        outFile = open(fName,"w")
        outFile.write(blendStr)
        outFile.close()
        bNum = bNum + 1
    raw_input

# Returns an array of possible Blend combinations and provides a generalization cost value for the combination
def getPossBlendCombis(genInputSpaces):
    maxGeneralizationsPerSpace = 0
    for gisName in genInputSpaces:
        if gisName == "Generic":
            continue
        maxGeneralizationsPerSpace = max(maxGeneralizationsPerSpace,len(genInputSpaces[gisName])-1)

    numSpaces = len(genInputSpaces) -1 # The -1 is there because Generic Space does not count...
    
    # generate the list of all possible combinaions of generalization steps by using the cartesian product function.     
    combiList = [list(combi) for combi in product(range(maxGeneralizationsPerSpace+1),repeat = numSpaces)]
    # Now make these lists readable for the later processing by generating the "combis" dictionary which is organized by generalization cost. Also check if combi is valid. , i.e. if the number of generalizations in the possCombiList variable applied is valid. If valid add them to list of possible combis. 
    possCombis = []
    for combi in combiList:
        thisCombi = {}
        gisNum = 0
        combiValid = True
        for gisName in sorted(genInputSpaces.keys()):
            if gisName == "Generic":
                continue            
            thisCombi[gisName] = combi[gisNum]
            # Also check if this combination is valid. It may be, that for a particular input space there is no generalization at all, or less generalizations than for other input spaces.
            if len(genInputSpaces[gisName]) <= combi[gisNum]:
                combiValid = False
                break
            gisNum = gisNum + 1
        
        # Append this combi if it is valid. 
        if combiValid:
            possCombis.append(thisCombi)

    combis = {}
    for combi in possCombis:
        # thisCombiCost = 0
        minSpaceGenCost = sys.maxint
        maxSpaceGenCost = 0
        for iSpaceName in combi.keys():
            cost = combi[iSpaceName]
            minSpaceGenCost = min(cost,minSpaceGenCost)
            maxSpaceGenCost = max(cost,maxSpaceGenCost)

        finalCombiCost = maxSpaceGenCost * 10 + minSpaceGenCost

        if finalCombiCost not in combis.keys():
            combis[finalCombiCost] = []
        combis[finalCombiCost].append(combi)

    return combis

   
def checkConsistencyEprover(blendTptpName) :
        global eproverTimeLimit
        # os.system("eprover --auto --tptp3-format "+blendTptpName+" > consistencyRes.log")
        resFile = open("consistencyRes.log", "w")
        subprocess.call(["eprover","--auto" ,"--tptp3-format", "--cpu-limit="+str(eproverTimeLimit), blendTptpName], stdout=resFile)
        resFile.close()
        # exit(0)
        while not os.path.isfile("consistencyRes.log") :
            print ":::::::::::::::: file consistencyRes.log not yet written!!!!!!:::::::::::::::"
            exit(0)
        #     continue

        resFile = open("consistencyRes.log",'r')
        res = resFile.read()
        resFile.close()

        os.system("rm consistencyRes.log")

        if res.find("# No proof found!") != -1 or res.find("# Failure: Resource limit exceeded") != -1:
            print "Eprover: No consistency proof found with eprover"
            return -1

        if res.find("SZS status Unsatisfiable") != -1:
            print "Eprover: Blend inconsistent"
            return 0
        
        print "Eprover: Blend consistent"
        return 1

def checkConsistencyDarwin(blendTptpName) :
        global darwinTimeLimit
        
        darwinCmd = Command("darwin " + blendTptpName)

        status,output,error = darwinCmd.run(timeout=darwinTimeLimit)
        # res = darwinCmd.run(timeout=darwinTimeLimit, shell=True)

        # print output
        cVal = -1
        if output.find("ABORTED termination") != -1:
            print "Consistency check w. darwin failed: TIMEOUT" 
            cVal = -1
        if output.find("SZS status Satisfiable") != -1:
            print "Consistency check w. darwin succeeds: CONSISTENT"
            cVal = 1
        if output.find("SZS status Unsatisfiable") != -1:
            print "Consistency check w. darwin succeeds: INCONSISTENT"
            cVal = 0
        
        # raw_input()

        return cVal

        # exit(0)

        # # os.system("darwin "+blendTptpName+" > consistencyRes.log")
        # resFile = open("consistencyRes.log", "w")
        # # subprocess.call(["darwin", "--timeout-cpu " + str(darwinTimeLimit), blendTptpName], stdout=resFile)
        # # subprocess.call(["darwin", blendTptpName, " -to " + str(darwinTimeLimit)], stdout=resFile)
        # subprocess.call(["darwin", " -to " + str(darwinTimeLimit), blendTptpName], stdout=resFile)
        # # subprocess.call(["darwin", blendTptpName], stdout=resFile)
        # resFile.close()
        # while not os.path.isfile("consistencyRes.log") :
        #     print ":::::::::::::::: file consistencyRes.log not yet written!!!!!!:::::::::::::::"
        #     exit(1)

        # resFile = open("consistencyRes.log",'r')
        # res = resFile.read()
        # resFile.close()
        # print res
        # raw_input()
        # os.system("rm consistencyRes.log")
        # if res.find("SZS status Satisfiable") != -1:
        #     print "Darwin: Consistency proof found."
        #     return 1

        # else : #if res.find("SZS status Unsatisfiable") != -1:
        #     print "Darwin: Blend inconsistent or consistency not determined."
        #     return 0


class Command(object):
    """
    Enables to run subprocess commands in a different thread with TIMEOUT option.

    Based on jcollado's solution:
    http://stackoverflow.com/questions/1191374/subprocess-with-timeout/4825933#4825933
    """
    command = None
    process = None
    status = None
    output, error = '', ''

    def __init__(self, command):
        if isinstance(command, basestring):
            command = shlex.split(command)
        self.command = command

    def run(self, timeout=None, **kwargs):
        """ Run a command then return: (status, output, error). """
        def target(**kwargs):
            try:
                self.process = subprocess.Popen(self.command, **kwargs)
                # print self.command
                self.output, self.error = self.process.communicate()
                self.status = self.process.returncode
            except:
                self.error = traceback.format_exc()
                self.status = -1
        # default stdout and stderr
        if 'stdout' not in kwargs:
            kwargs['stdout'] = subprocess.PIPE
        if 'stderr' not in kwargs:
            kwargs['stderr'] = subprocess.PIPE
        # thread
        thread = threading.Thread(target=target, kwargs=kwargs)
        thread.start()
        thread.join(timeout)
        if thread.is_alive():
            self.process.terminate()
            thread.join()
        return self.status, self.output, self.error

