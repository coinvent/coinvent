%%% The main iteration loop or the iterative ASP solving %%%
%%% This is a Logic Programming file called with clingo. The keyword # script (python) is used to tell clingo to call python.

#script (python) 

# The gringo library contains all important python methods used by clingo.
from gringo import *

# Some auxiliary libraries that we need:
import os, sys, time, subprocess
## This variable has to be modified in order to get the system running in your specific system path. TODO: Automate this somehow...
lp_path = os.path.abspath('/home/manni/mac-home/svn/coinvent/Amalgamation/')
sys.path.append(lp_path)

# We also want to be able to call the other amalgamation module python scripts.
from settings import *
from langCasl import *
from auxFunctions import *

## The function main is called by clingo. It implements the main iteration loop.
def main(prg):
    ## The following are constants 
    global minIterations, maxIterations, rmOpAllowed,rmAxAllowed,rmPredAllowed
    
    ## Some abbreviations to make the code more compact:
    imin   = minIterations
    imax   = maxIterations
    
    ## We start at step 1.
    step = 1
    
    ## The parts of the logic program to be grounded are declared with an empty sequence. 
    parts = []

    ## We append the base1 part of the Logic Program. (See e.g. generalize.lp to see which part this is.)
    parts.append(("base1", []))
    
    # These external options are currentl not working. They are intended to disallow generalization operations for particuar domains to improve searhc performance. For now, to realise this, (de)comment respective rules in generalize.lp file manually.
    
    # if rmOpAllowed : prg.assign_external(Fun("rmOpAllowed", [] ), True)
    # if rmPredAllowed : prg.assign_external(Fun("rmPredAllowed", []), True)
    # if rmAxAllowed : prg.assign_external(Fun("rmAxAllowed", []), True)
    
    
    #### First, find a path to the generic space

    # The main generalization loop starts here!
    while True:
        # Abort after the max. number of iterations 
        if step > imax: break
        # Append the cumulative part for the particular step (slice) of the program.
        parts.append(("cumulative1", [step]))
        # Ground the new slice
        prg.ground(parts)
        parts = []
        # Release the query1(t) atom from the last slice (step-1) from the program. 
        prg.release_external(Fun("query1", [step-1]))
        # Add the atom query1(t) of this slice to the program. 
        prg.assign_external(Fun("query1", [step]), True)
        
        # Find Stable Models for this iteration
        ret = prg.solve()
        # ret = prg.solve(None, on_model)
        
        # If Stable Models are found and we are beyond the minimal number of slices, break loop.
        if step >= imin and (ret == SolveResult.SAT): break
        step = step+1

    #### Second, find a blend to the generic space    (TODO)
    # 
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
