#script (python) 

from gringo import *
import os, sys, time, subprocess
lp_path = os.path.abspath('/home/manni/mac-home/svn/coinvent/Amalgamation/')
sys.path.append(lp_path)
from settings import *
from langCasl import *
from auxFunctions import *

def main(prg):
    global minIterations, maxIterations, rmOpAllowed,rmAxAllowed,rmPredAllowed
    
    imin   = minIterations
    imax   = maxIterations
    
    step = 1
    
    parts = []
    parts.append(("base1", []))
    # External options currentl not working. To select generalization operations, (de)comment respective rules in generalize.lp file.
    # if rmOpAllowed : prg.assign_external(Fun("rmOpAllowed", [] ), True)
    # if rmPredAllowed : prg.assign_external(Fun("rmPredAllowed", []), True)
    # if rmAxAllowed : prg.assign_external(Fun("rmAxAllowed", []), True)
    while True:
        if imax != None and step > imax: break
        parts.append(("cumulative1", [step]))
        prg.ground(parts)
        parts = []
        prg.release_external(Fun("query1", [step-1]))
        prg.assign_external(Fun("query1", [step]), True)
        # ret = prg.solve(None, on_model)
        ret = prg.solve()
        if step >= imin and (ret == SolveResult.SAT): break
        step = step+1

    # blendId = 0
    # for blend in blends:
    #     fName = "amalgamBlend_"+str(blendId)+".casl"
    #     outFile = open(fName,"w")
    #     outFile.write(blend)
    #     outFile.close()
    #     blendId = blendId + 1

    # print "Iteration for generalizations done. Starting blend iteration."

    # step = 1
    # parts.append(("base2", []))
    # while True:
    #     if imax != None and step > imax: break
    #     parts.append(("cumulative2", [step]))
    #     parts.append(("volatile2", [step]))
    #     prg.ground(parts)
    #     parts = []
    #     prg.release_external(Fun("query2", [step-1]))
    #     prg.assign_external(Fun("query2", [step]), True)
    #     # ret = prg.solve(None, on_model)
    #     ret = prg.solve(None, on_model)
    #     if step >= imin and (ret == SolveResult.SAT) : break
    #     step = step + 1

    # last cleanup...
    # os.system('rm *.th')

#end.
