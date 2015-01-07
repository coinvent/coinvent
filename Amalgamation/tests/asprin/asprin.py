#script (python)

from gringo import *

holds, tproject, fproject = [], [], []
noshowproject = 0

def getHolds():
    global holds
    return holds

def getTProject():
    global tproject
    return tproject

def getFProject():
    global fproject
    return fproject

def onModel(model):
    global holds, tproject,fproject, noshowproject
    holds, tproject, fproject = [], [], []
    for a in model.atoms():
    	if ((a.name() == "_holds") and (a.args()[1] == 0)): holds.append(a.args()[0])
        elif (a.name() == "tproject"):
          tproject.append(a.args()[0])
          if (noshowproject == 0): print a,
        elif (a.name() == "fproject"):
          fproject.append(a.args()[0]);
          if (noshowproject == 0): print a,
        elif ((a.name()[0] != "_") and (a.name()[0] != "#")): print a,
    print

def main(prg):

    global holds, tproject, noshowproject
    unsat = 0
    step = 1
    startone = 1
    opt = []
    nmodels = 0
    enum=0
    maxmodels = prg.getConst("_n") if prg.getConst("_n") != None else 1
    forgetopt  = prg.getConst("_forgetopt")  if prg.getConst("_forgetopt")  != None else 0
    forgetlast = prg.getConst("_forgetlast") if prg.getConst("_forgetlast") != None else 0
    noshowproject = prg.getConst("_noshowproject") if prg.getConst("_noshowproject") != None else 0

    prg.ground("base", [])
    while True:
        print "Answer: "+ str(step)
        if step > startone:
            if ((maxmodels != 1) and (forgetlast != 0) and (step - startone > 1)): prg.releaseExternal(Fun("_volatile",[0,step-2]))
            prg.ground("doholds",[step-1])
            prg.ground("preference",[0,step-1])
            prg.ground("constraints",[0,step-1])
	    if (maxmodels != 1):
                prg.ground("volatile_external",[0,step-1])
		prg.assignExternal(Fun("_volatile",[0,step-1]),True)
            else: prg.ground("volatile_fact",[0,step-1])
        ret = prg.solve(onModel)
        if ret == SolveResult.UNSAT:
            if (step==1 or unsat==1):  print "UNSATISFIABLE"; break
            print "OPTIMUM FOUND"
            nmodels += 1
            if (maxmodels == nmodels): break
            for i in range(startone,step): prg.releaseExternal(Fun("_volatile",[0,i]))
            startone = step + 1
            prg.ground("deletemodel",[])
            prg.ground("preference", [step-1,0])
            prg.ground("unsat_constraints", [step-1,0])
            prg.ground("volatile_external",[step-1,0])
            prg.assignExternal(Fun("_volatile",[step-1,0]),True)
            if forgetopt != 0:
                for i in opt: prg.assignExternal(Fun("_volatile",[i,0]),True)
                opt.append(step-1)
            unsat = 1
        else:
	    enum = enum + 1
            if (unsat==1 and forgetopt != 0):
                for i in opt: prg.assignExternal(Fun("_volatile",[i,0]),False)
            unsat = 0
        step = step+1
    print
    print "Models       : " + str(nmodels)
    print "  Enumerated : " + str(enum)
#end.

#program base.
#show _holds(X,0) : _holds(X,0).

#program deletemodel.
:- tproject(X)  : X = @getTProject();
   fproject(X)  : X = @getFProject().

#program doholds(m).
_holds(X,m) :- X = @getHolds().

#program volatile_fact(m1,m2).
_volatile(m1,m2).

#program volatile_external(m1,m2).
#external _volatile(m1,m2).























