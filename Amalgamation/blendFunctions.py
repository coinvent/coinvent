from gringo import *
import os, sys, time, subprocess
from settings import *
from langCasl import *
from itertools import *


def findLeastGeneralizedBlends(modelAtoms, inputSpaces, maxCost, blends):

    # Parse model and execute actions on internal data structure to obtain the generalized inut spaces. 
    genInputSpaces = getGeneralizedSpaces(modelAtoms, inputSpaces)

    # get possible combinations of generalization combinations
    blendCombis = getPossBlendCombis(genInputSpaces)    

    # initialize output string for casl file
    cstr = ''

    # State all generalized input spaces:     
    for specName in genInputSpaces.keys():
        if specName == "Generic":
            cstr = cstr + genInputSpaces[specName][0].toCaslStr()+"\n\n"
            continue
        for spec in genInputSpaces[specName]:
            cstr = cstr + spec.toCaslStr()+"\n\n"
            cstr = cstr + "view GenTo"+spec.name+": Generic to "+spec.name+" end\n\n"

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
    
    # First make sure file does noe exists, and then write file. Try writing multiple times (this is necessary due to some strange file writing bug...)
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
                subprocess.call(["hets", "-o tptp", "amalgamTmp.casl"])
                print "Done generating tptp"
                # This is a hack because hets sometimes seems to not generate all .tptp files. So we just try again and again until its working. 
                tries = tries + 1
                if tries > 5:
                    print "ERROR: File "+blendTptpName+" not yet written correctly "+ str(tries) + " times! Aborting..."
                    exit(0)

            thisCombiConsistent = checkConsistencyEprover(blendTptpName)
            if thisCombiConsistent == -1:
                print "Consistency could not be determined by eprover, trying darwin"
                thisCombiConsistent = checkConsistencyDarwin(blendTptpName)
                        
            if thisCombiConsistent == 1:
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
            # thisCombiCost = thisCombiCost + cost            

        # avgCost = thisCombiCost / len(combi.keys())

        # totalDiffFromAvg = 0
        # for iSpaceName in combi.keys():
        #     cost = combi[iSpaceName]
        #     totalDiffFromAvg = totalDiffFromAvg + abs(avgCost - cost)

        # avgDiffFromAvg = float(totalDiffFromAvg) / float(len(combi.keys()))
        # symFactor = avgDiffFromAvg + 1
        
        # print "combi cost for "
        # print combi
        # print "avg diff from average:"
        # print avgDiffFromAvg
        # print "symmetry factor:"
        # print symFactor
        # print "apriori cost:"
        # print thisCombiCost
        # print "final cost is"
        # print int(thisCombiCost * symFactor)

        # raw_input()

        # finalCombiCost = int(100*(thisCombiCost + avgDiffFromAvg))
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
        # os.system("darwin "+blendTptpName+" > consistencyRes.log")
        resFile = open("consistencyRes.log", "w")
        subprocess.call(["darwin", "-to " + str(darwinTimeLimit), blendTptpName], stdout=resFile)
        resFile.close()
        # exit(0)
        while not os.path.isfile("consistencyRes.log") :
            print ":::::::::::::::: file consistencyRes.log not yet written!!!!!!:::::::::::::::"
            exit(0)
        #     continue

        resFile = open("consistencyRes.log",'r')
        res = resFile.read()
        resFile.close()

        # subprocess.call(["rm", "consistencyRes.log"])

        while not os.path.isfile("consistencyRes.log") :
            print ":::::::::::::::: file consistencyRes.log not yet written!!!!!!:::::::::::::::"
            exit(0)
        #     continue

        os.system("rm consistencyRes.log")

        if res.find("SZS status Satisfiable") != -1:
            print "Darwin: Consistency proof found."
            return 1

        else : #if res.find("SZS status Unsatisfiable") != -1:
            print "Darwin: Blend inconsistent or consistency not determined."
            return 0
    