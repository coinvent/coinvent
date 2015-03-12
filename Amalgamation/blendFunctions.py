from gringo import *
import os, sys, time, subprocess, threading, shlex
from settings import *
from langCasl import *
from itertools import *


def findLeastGeneralizedBlends(modelAtoms, inputSpaces, maxCost, blends):

    # blends = []
    generalizationCost = sys.maxint

    # Parse model and execute actions on internal data structure to obtain the generalized inut spaces. 
    genInputSpaces = getGeneralizedSpaces(modelAtoms, inputSpaces)

    # print "specs:"
    # print genInputSpaces.keys()
    # for specTypeList in genInputSpaces.values():
    #     for spec in specTypeList:
    #         print spec.toCaslStr()

    # # Get possible combinations of generalization combinations
    blendCombis = getPossBlendCombis(modelAtoms)    

    # # initialize output string for casl file
    cstr = ''

    # # First state generic spaces
    cstr = cstr + genInputSpaces["Generic"][0].toCaslStr()+"\n\n"
    # State the mappings with inheritance
    
    for specName in genInputSpaces.keys():
        if specName == "Generic":            
            continue

        for spec in genInputSpaces[specName]:
            
            specStr = spec.toCaslStr()+"\n\n"

            mappingStr = ""
            mappingStr = mappingStr + "view GenTo"+spec.name+" : Generic to "+spec.name+" \n"
            renamings = getRenamingsFromModelAtoms(modelAtoms,spec,specName)
            # print mappingStr
            # print renamings
            

            if len(renamings.keys()) > 0:
                mappingStr += " =  "
                for step in sorted(renamings.keys()):
                    mappingStr = mappingStr + lpToCaslStr(renamings[step][1]) + " |-> " + lpToCaslStr(renamings[step][0]) + ", "
                mappingStr = mappingStr[:-2]

                    # print act
                # if atom.find("exec(renameOp(") != -1:
                    # atomSpec = 
            mappingStr = mappingStr + " end\n\n"
            cstr += specStr + mappingStr
    
    # raw_input()
    # State blends (colimit operation)
    for cost in sorted(blendCombis.keys()):
        print "Specifying blends with generalization cost of " + str(cost) 
        for combi in blendCombis[cost]:            
            cstr = cstr + "spec Blend"
            for specName in combi.keys():
                steps = combi[specName]
                cstr = cstr + "_" + lpToCaslStr(specName) + "_" + str(steps)
            cstr = cstr + "-c"+str(cost)+" = combine "

            for specName in combi.keys():
                caslSpecName = lpToCaslStr(specName)
                specList = genInputSpaces[caslSpecName]
                specStep = int(combi[specName])
                spec = specList[specStep]
                cstr = cstr + "GenTo"+spec.name+","
            cstr = cstr[:-1]
            cstr = cstr + " end\n\n"
    
    # print cstr
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
    # raw_input()
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
                step = combi[specName]
                blendName = blendName + "_" + lpToCaslStr(specName) + "_" + str(step)
            blendName += "-c"+str(cost)

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
                
                print "generating tptp because " + blendTptpName + " file was not found"
                subprocess.call([hetsExe, "-o tptp", "amalgamTmp.casl"])
                print "Done generating tptp"
                # This is a hack because hets sometimes seems to not generate all .tptp files. So we just try again and again until its working. 
                tries = tries + 1
                if tries > 5:
                    print "ERROR: File "+blendTptpName+" not yet written correctly "+ str(tries) + " times! Aborting..."
                    exit(1)

            thisCombiConsistent = checkConsistencyEprover(blendTptpName)

            # if thisCombiConsistent == -1:
            #     print "Consistency could not be determined by eprover, trying darwin"
            #     thisCombiConsistent = checkConsistencyDarwin(blendTptpName)
                        
            # if thisCombiConsistent == 1: # If we can show that the blend is consistent
            if thisCombiConsistent != 0: # If we can not show that the blend is inconsistent
                prettyBlendStr = prettyPrintBlend(genInputSpaces,combi,modelAtoms)
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
    # raw_input()
    # os.system("rm *.tptp")
    # os.remove("amalgamTmp.casl")

    return [blends,generalizationCost]
    
def prettyPrintBlend(genInputSpaces,combi,modelAtoms):

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
            if numGeneralizations == combi[toLPName(iSpaceName,"spec")]:
                # view from generic space to generalized input space:
                cstr = cstr + "view GenTo"+lastSpecName+" : Generic to " + lastSpecName
                renamings = getRenamingsFromModelAtoms(modelAtoms,spec,iSpaceName)

                if len(renamings.keys()) > 0:
                    cstr = cstr + " =  "
                    for step in sorted(renamings.keys()):
                        cstr = cstr + lpToCaslStr(renamings[step][1]) + " |-> " + lpToCaslStr(renamings[step][0]) + ", "
                    cstr = cstr[:-2]

                cstr += " end \n\n"
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
        fName = blend["blendName"] + "-"+str(blend["generalizationCost"])+"_b_"+str(bNum)+".casl"
        outFile = open(fName,"w")
        outFile.write(blendStr)
        outFile.close()
        bNum = bNum + 1
    raw_input

# Returns an array of possible Blend combinations and provides a generalization cost value for the combination
def getPossBlendCombis(modelAtoms):
    # maxGeneralizationsPerSpace = 0
    combis = {}
    for atom in modelAtoms:
        if str(atom).find("combinedGenCost") != 0:
            continue
        # combi is a pair of generalised specification names
        combi = {}
        # combinedGenCost(spec_Boat,6,spec_House,2,38,7).
        argItems = str(atom).split("(")[1].split(")")[0].split(",")
        # print argItems
        combi[argItems[0]] = int(argItems[1])-1
        combi[argItems[2]] = int(argItems[3])-1
        # cost is the cost of the combination
        cost = int(argItems[4])
        if cost not in combis.keys():
            combis[cost] = []
        if combi not in combis[cost]:
            combis[cost].append(combi)
    # print "combis"
    # print combis
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

def getRenamingsFromModelAtoms(modelAtoms,spec,origCaslSpecName):
    # global inputSpaces
    # spec = inputSpaces[caslSpecName]
    renamings = {}
    for atom in modelAtoms:
        a = str(atom)
        if a[:4] == "exec":
            act = getActFromAtom(a)
            if act["iSpace"] != toLPName(origCaslSpecName,"spec"):
                continue
            if act["actType"] == "renameOp":
                
                # Add renaming only if operator is in target spec.
                rnInOps = False
                for op in spec.ops:                        
                    if act["argVect"][0] == toLPName(op.name,"po"): 
                        rnInOps = True
                        break
                if rnInOps: 
                    renamings[act["step"]] = act["argVect"]
            if act["actType"] == "renamePred":
               
                # Add renaming only if operator is in target spec.
                rnInPreds = False
                for p in spec.preds:                        
                    if act["argVect"][0] == toLPName(p.name,"po"): 
                        rnInOps = True
                        break
                if rnInPreds: 
                    renamings[act["step"]] = act["argVect"]
            if act["actType"] == "renameSort":
                
                # Add renaming only if operator is in target spec.
                rnInSorts = False
                for s in spec.sorts:                        
                    if act["argVect"][0] == toLPName(s.name,"sort"): 
                        rnInSorts = True
                        break
                if rnInSorts: 
                    renamings[act["step"]] = act["argVect"]
    return renamings
