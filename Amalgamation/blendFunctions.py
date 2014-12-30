from gringo import *
import os, sys, time, subprocess
from settings import *
from langCasl import *
from itertools import *

def findLeasetGeneralizedBlends(modelAtoms, inputSpaces):
    # Parse model and execute actions on internal data structure to obtain the generalized inut spaces. 
    genInputSpaces = getGeneralizedSpaces(modelAtoms, inputSpaces)

    # get possible combinations of generalization combinations
    blendCombis = getPossBlendCombis(genInputSpaces)    

    # initialize output string for casl file
    cstr = ''

    # State all generalized input spaces:     
    for specName in genInputSpaces.keys():
        for spec in genInputSpaces[specName]:
            cstr = cstr + spec.toCaslStr()+"\n\n"
            cstr = cstr + "view GenTo"+spec.name+": Generic to "+spec.name+" end\n\n"

    # State blends (colimit operation)
    for cost in sorted(blendCombis.keys()):
        print "Trying blends with generalization cost of " + str(cost)
        
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
    
    # Write file, try multiple times due to bug        
    os.system("rm amalgamTmp.casl")
    tries = 0
    while not os.path.isfile("amalgamTmp.casl") :        
        outFile = open("amalgamTmp.casl","w")
        outFile.write(cstr)
        outFile.close()
        tries = tries + 1
        if tries > 5:
            print ":::::::::::::::: ERROR! file amalgamTmp.casl not yet written after "+ str(tries) + "tries. !!!!!!:::::::::::::::"
            exit(1)

    # print "generating tptp"
    # subprocess.call(["hets", "-o tptp", "amalgamTmp.casl"])
    # print "Done generating tptp"
    # # raw_input()

    # for step in sorted(generalizationPairs.keys()):
    #     print "step " + str(step)
    #     if step > minSteps:
    #         print "step "  +str(step) + " > " + str(minSteps) + " too high, aborting..."
    #         os.system("rm *.tptp")


    #         return 
    #     if step == len(generalizationPairs.keys())-1:
    #         print "step "  +str(step) + " is maxstep, aborting..."
    #         os.system("rm *.tptp")
    #         return

    #     blendName = "Blend_" + str(step)
    #     print "Checking consistency of " + blendName + ""
    #     #generate tptp format of theory and call eprover to check consistency
    #     blendTptpName = "amalgamTmp_"+blendName+".tptp"
    #     tries = 0

    #     while True:
    #         if os.path.isfile(blendTptpName) and os.stat(blendTptpName).st_size != 0:
    #             break
    #         print ":::::::::::::::: file "+blendTptpName+" not yet written correctly "+ str(tries) + " times!!!!!!:::::::::::::::"
    #         print "generating tptp again"
    #         subprocess.call(["hets", "-o tptp", "amalgamTmp.casl"])
    #         print "Done generating tptp again"
    #         # This is a hack because, hets sometimes seems to not generate all .tptp files. So we just try again and again until its working. 
    #         time.sleep(0.5)
    #         tries = tries + 1
    #         if tries > 5:
    #             exit(0)

    #     # print "tptpSize : " + str(os.stat(blendTptpName).st_size)

    #     if os.stat(blendTptpName).st_size == 0:
    #         exit(1)

    #     consistent = checkConsistencyEprover(blendTptpName)
    #     if consistent == -1:
    #         print "Consistency could not be determined by eprover, trying darwin"
    #         consistent = checkConsistencyDarwin(blendTptpName)
        
    #     if consistent == 1:
    #         cstr = prettyPrintBlend(generalizationPairs,step)
    #         os.system("rm *.tptp")
    #         if step < minSteps:
    #             print "New min. number of steps: " + str(step)
    #             blends = []
    #         minSteps = step
    #         blends.append(cstr)
    #         break
    
    # os.remove("amalgamTmp.casl")
    
    totalGeneralizationCost = 1
    return totalGeneralizationCost

def getPossBlendCombis(genInputSpaces):
    maxGeneralizationsPerSpace = 0
    for gisName in genInputSpaces:
        if gisName == "Generic":
            continue
        maxGeneralizationsPerSpace = max(maxGeneralizationsPerSpace,len(genInputSpaces[gisName])-1)

    numSpaces = len(genInputSpaces) -1 # The -1 is there because Generic Space does not count...
    
    # generate the list of all possible combinaions of generalization steps by using the cartesian product function.     
    possCombiList = [list(combi) for combi in product(range(maxGeneralizationsPerSpace+1),repeat = numSpaces)]
    # now make these lists readable for the later processing by generating the "combis" dictionary which is organized by generalization cost. 
    combis = {}
    for combi in possCombiList:
        thisCombiCost = 0
        for cost in combi:
            thisCombiCost = thisCombiCost + cost
        if thisCombiCost not in combis.keys():
            combis[thisCombiCost] = []
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


        if combiValid:
            combis[thisCombiCost].append(thisCombi)

    print combis

    return combis

   
def checkConsistencyEprover(blendTptpName) :

        # os.system("eprover --auto --tptp3-format "+blendTptpName+" > consistencyRes.log")
        resFile = open("consistencyRes.log", "w")
        subprocess.call(["eprover","--auto" ,"--tptp3-format", blendTptpName], stdout=resFile)
        resFile.close()
        # exit(0)
        while not os.path.isfile("consistencyRes.log") :
            print ":::::::::::::::: file consistencyRes.log not yet written!!!!!!:::::::::::::::"
            exit(0)
        #     continue

        resFile = open("consistencyRes.log",'r')
        res = resFile.read()
        resFile.close()

        subprocess.call(["rm", "consistencyRes.log"])
        # os.system("rm consistencyRes.log")

        if res.find("# No proof found!") != -1:
            print "Eprover: No consistency proof found with eprover"
            return -1

        if res.find("SZS status Unsatisfiable") != -1:
            print "Eprover: Blend inconsistent"
            return 0
        
        print "Eprover: Blend consistent"
        return 1

def checkConsistencyDarwin(blendTptpName) :

        # os.system("darwin "+blendTptpName+" > consistencyRes.log")
        resFile = open("consistencyRes.log", "w")
        subprocess.call(["darwin", blendTptpName], stdout=resFile)
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
            print "Darwin: Blend consistent."
            return 1

        else : #if res.find("SZS status Unsatisfiable") != -1:
            print "Darwin: Blend inconsistent "
            return 0
    