#script (python) 

from gringo import *
import os, sys, time, subprocess
lp_path = os.path.abspath('/home/manni/mac-home/svn/coinvent/Amalgamation/')
sys.path.append(lp_path)
from settings import *
from langCasl import *
generalizations = {}

blends = []
minSteps = sys.maxint

def on_model(model):

    global minSteps, blends
    print "Model found. \n"

    # store model in tmp file
    tmpFile = open("tmpModel",'w')
    for a in model.atoms() :
        tmpFile.write(str(a)+"\n")
        print a
    raw_input()
    tmpFile.close()
    while not os.path.isfile("tmpModel") :
        print ":::::::::::::::: file tmpModel not yet written!!!!!!:::::::::::::::"
        exit(0)
        # continue

    generalizationPairs = computeGeneralizedCaslSpecs()
    os.system("rm tmpModel")
    
    # # state generic space
    cstr = generalizationPairs[len(generalizationPairs)-1][0].toCaslStr()+"\n\n"
    print "generic:"
    print cstr

    # go through steps and compute blend
    laststep = 0
    lastSpecs = []
    for step in sorted(generalizationPairs.keys()):
        if step == len(generalizationPairs)-1: break
        #compute blend for this generalization step
        specid = 0
        
        for spec in generalizationPairs[step]:
            if spec.name not in lastSpecs:
                cstr = cstr + spec.toCaslStr()+"\n\n"
                cstr = cstr + "view GenTo"+spec.name+": Generic to "+spec.name+" end\n\n"
                lastSpecs.append(spec.name)

        cstr = cstr + "spec Blend_" + str(step)
        cstr = cstr + " = combine "
        for spec in generalizationPairs[step]:
            cstr = cstr + "GenTo"+spec.name+","
        cstr = cstr[:-1]
        cstr = cstr + " end\n\n"
        
    os.system("rm amalgamTmp.casl")
    outFile = open("amalgamTmp.casl","w")
    outFile.write(cstr)
    outFile.close()


    while not os.path.isfile("amalgamTmp.casl") :
        print ":::::::::::::::: file amalgamTmp.casl not yet written!!!!!!:::::::::::::::"
        exit(1)

    print "generating tptp"
    subprocess.call(["hets", "-o tptp", "amalgamTmp.casl"])
    print "Done generating tptp"
    # raw_input()

    for step in sorted(generalizationPairs.keys()):
        print "step " + str(step)
        if step > minSteps:
            print "step "  +str(step) + " > " + str(minSteps) + " too high, aborting..."
            os.system("rm *.tptp")


            return 
        if step == len(generalizationPairs.keys())-1:
            print "step "  +str(step) + " is maxstep, aborting..."
            os.system("rm *.tptp")
            return

        blendName = "Blend_" + str(step)
        print "Checking consistency of " + blendName + ""
        #generate tptp format of theory and call eprover to check consistency
        blendTptpName = "amalgamTmp_"+blendName+".tptp"
        tries = 0

        while True:
            if os.path.isfile(blendTptpName) and os.stat(blendTptpName).st_size != 0:
                break
            print ":::::::::::::::: file "+blendTptpName+" not yet written correctly "+ str(tries) + " times!!!!!!:::::::::::::::"
            print "generating tptp again"
            subprocess.call(["hets", "-o tptp", "amalgamTmp.casl"])
            print "Done generating tptp again"
            # This is a hack because, hets sometimes seems to not generate all .tptp files. So we just try again and again until its working. 
            time.sleep(0.5)
            tries = tries + 1
            if tries > 5:
                exit(0)

        # print "tptpSize : " + str(os.stat(blendTptpName).st_size)

        if os.stat(blendTptpName).st_size == 0:
            exit(1)

        consistent = checkConsistencyEprover(blendTptpName)
        if consistent == -1:
            print "Consistency could not be determined by eprover, trying darwin"
            consistent = checkConsistencyDarwin(blendTptpName)
        
        if consistent == 1:
            cstr = prettyPrintBlend(generalizationPairs,step)
            os.system("rm *.tptp")
            if step < minSteps:
                print "New min. number of steps: " + str(step)
                blends = []
            minSteps = step
            blends.append(cstr)
            break
    
    os.remove("amalgamTmp.casl")

def prettyPrintBlend(generalizationPairs,stepConsistent):
    lastSpecs = {}
    # step = 0
    cstr = ""
    # # state generic space
    cstr = generalizationPairs[len(generalizationPairs)-1][0].toCaslStr()+"\n\n"
    for step in generalizationPairs.keys():
        specId = 0
        if step > stepConsistent:
            continue
        for spec in generalizationPairs[step]:            
            if specId not in lastSpecs.keys() or spec.name != lastSpecs[specId]:

                cstr = cstr + spec.toCaslStr()+"\n\n"
                # define view to previous spec. 
                if specId in lastSpecs.keys():
                    cstr = cstr + "view "+spec.name+"To"+lastSpecs[specId]+" : " + spec.name + " to " +lastSpecs[specId] + " end \n\n"
            lastSpecs[specId] = spec.name
            specId = specId + 1

    # view from generic space to most general specs
    for spec in lastSpecs.keys():
        specName = lastSpecs[spec]
        cstr = cstr + "view GenTo"+specName+" : Generic to " +specName + " end \n "

    # blend
    cstr = cstr + "spec Blend" 
    cstr = cstr + " = combine "
    for spec in lastSpecs.keys():
        specName = lastSpecs[spec]
        cstr = cstr + "GenTo"+specName+","
    cstr = cstr[:-1]
    cstr = cstr + " end\n\n"

    return cstr

def get(val, default):
    return val if val != None else default

def main(prg):
    global generalizations,blends, minIterations, maxIterations
    imin   = minIterations
    imax   = maxIterations
    
    step = 1
    
    parts = []
    parts.append(("base1", []))
    while True:
        if imax != None and step > imax: break
        parts.append(("cumulative1", [step]))
        parts.append(("volatile1", [step]))
        prg.ground(parts)
        parts = []
        prg.release_external(Fun("query1", [step-1]))
        prg.assign_external(Fun("query1", [step]), True)
        ret = prg.solve(None, on_model)
        if step >= imin and (ret == SolveResult.SAT): break
        step = step+1

    blendId = 0
    for blend in blends:
        fName = "amalgamBlend_"+str(blendId)+".casl"
        outFile = open(fName,"w")
        outFile.write(blend)
        outFile.close()
        blendId = blendId + 1

    print "Iteration for generalizations done. Starting blend iteration."

    step = 1
    parts.append(("base2", []))
    while True:
        if imax != None and step > imax: break
        parts.append(("cumulative2", [step]))
        parts.append(("volatile2", [step]))
        prg.ground(parts)
        parts = []
        prg.release_external(Fun("query2", [step-1]))
        prg.assign_external(Fun("query2", [step]), True)
        # ret = prg.solve(None, on_model)
        ret = prg.solve(None, on_model)
        if step >= imin and (ret == SolveResult.SAT) : break
        step = step + 1

    # last cleanup...
    os.system('rm *.th')

def computeGeneralizedCaslSpecs():
    print "computing CASL specs"
    global caslInputFile, inputSpaces

    caslFName = caslInputFile
    # get information about generic space and inputs for the particular t from Answer Set. TODO: File has to be read only once of course.
    tmpFile = open("tmpModel",'r')
    atoms = tmpFile.read().split("\n")

    # parse CASL file again to get data structure. TODO: File has to be parsed only once of course.
    print "generating xml file"
    xmlFileName = casl2Xml(caslFName,inputSpaces) 
    print "parsing xml tree"
    caslSpecs = parseXmlCasl(xmlFileName)
    print "done parsing xml"
    os.remove(xmlFileName)
    originalCaslSpecs = copy.deepcopy(caslSpecs)
    generalizations = {}
    generalizationPairs = {0 : []}
    for spec in originalCaslSpecs:
        generalizations[spec.name] = [spec]
        generalizationPairs[0].append(spec)
    # modify CASL data according to Answer Set. TODO: respect order of actions. For now this does not matter...
    acts = {}
    for a in atoms:
        if a[:4] == "exec":
            # print a
            act = a[5:]
            act = act.split(")")[0]+")"
            actType = act.split("(")[0]
            actArgs = act.split("(")[1].split(")")[0].split(",")
            actStep = int(a.split(",")[len(a.split(","))-1][:-1])
            if actStep in acts.keys():
                acts[actStep].append([actType,actArgs])
            else :
                acts[actStep] = [[actType,actArgs]]
    # print acts
    for step in sorted(acts.keys()):
        cSpecToAlter = None
        generalizationPairs[step] = []
        simActs = acts[step]
        for act in simActs:
            actArgs = act[1]
            actType = act[0]
            # print "step: " + str(step)
            # print "act: " + actType 
            # print actArgs
            for cSpec in caslSpecs:
                # print cSpec.name.lower()
                if cSpec.name.lower() == actArgs[0]:  
                    cSpecToAlter = cSpec
                    if actType == "rmOp" :
                        for op in cSpec.ops:
                            if op.name.lower() == actArgs[1]:
                                cSpec.ops.remove(op)
                        
                    if actType == "rmPred" :
                        for p in cSpec.preds:
                            if p.name.lower() == actArgs[1]:
                                cSpec.preds.remove(p)

                    if actType == "rmAx" :
                        for a in cSpec.axioms:
                            if str(a['id']) == actArgs[1]:
                                cSpec.axioms.remove(a)
                        
                    
                    # remove unnecessary sorts
                    sorts = []
                    for op in cSpec.ops:
                        for arg in op.args:
                            sorts.append(arg)
                        sorts.append(op.dom)
                    for p in cSpec.preds:
                        for arg in p.args:
                            sorts.append(arg)
                    uniqueSorts = []
                    [uniqueSorts.append(item) for item in sorts if item not in uniqueSorts]
                    sorts = uniqueSorts
                    cSpec.sorts = sorts
                    # print cSpec.toStr()

        thisCSpec = copy.deepcopy(cSpecToAlter)
        thisCSpec.name = thisCSpec.name + "_gen_" + str(len(generalizations[thisCSpec.name]))
        
        generalizations[cSpecToAlter.name].append(thisCSpec)
        for cSpec in caslSpecs:
            if cSpec.name == cSpecToAlter.name:
                generalizationPairs[step].append(thisCSpec)
            else:
                generalizationPairs[step].append(generalizations[cSpec.name][len(generalizations[cSpec.name])-1])

    
    # exit(1)
    # add one last generic cSpec
    genSpec = copy.deepcopy(generalizationPairs[len(generalizationPairs)-1][0])
    genSpec.name = "Generic"
    generalizations["Generic"] = [genSpec]    
    generalizationPairs[len(generalizationPairs)] = [genSpec]
    # print genSpec.toStr()
    # time.sleep(1)

    return generalizationPairs
    # return generalizations
    
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
    

        

    #end.
