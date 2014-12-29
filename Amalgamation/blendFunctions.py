from gringo import *
import os, sys, time, subprocess
from settings import *
from langCasl import *

generalizations = {}
colimitValues = {}

def computeColimit(s1,t1,s2,t2):
    # first determine the model 
    return 1

# Returns the colimit value determined by consistency and maybe other factors. (E.g. a consistent colimit has a high value). 
# The function first checkes whether the colimit has been computed before, and, if not, it computes the colimit by calling computeColimit beleow. 
def getColimitVal(s1,t1,s2,t2):
    if s1 not in colimitValues.keys():
        colimitValues[s1] = {}
    if t1 not in colimitValues[s1].keys():
        colimitValues[s1][t1] = {}
    if s2 not in colimitValues[s1][t1].keys():
        colimitValues[s1][t1][s2] = {}
    if t2 not in colimitValues[s1][t1][s2].keys():
        colimitValues[s1][t1][s2][t2] = computeColimit(s1,t1,s2,t2)
    
    return colimitValues[s1][t1][s2][t2]
   
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
    