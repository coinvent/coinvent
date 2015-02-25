# This file contains classes that represent FOL expressions
import copy
from auxFunctions import *
import re
# An atom is a predicate with arguments, e.g. livesIn(person,house). We don't use reification. 
class Atom:
    def __init(self) :
        self.name = ''
        self.args = []
    
    def toStr(self):
        oStr = self.name
        if len(args) > 0:
            oStr.append("(")
            for arg in args:
                oStr.append(arg+",")
            oStr = oStr[:-1]+")"
        return oStr
    
    def toCaslStr(self):
        return self.toStr()

    def toLPStr(self):            
        return self.toStr()

# A disjunct has a left hand side (lhs) if its a function statement and only a right hand side (rhs) if its a predicate statement. A left-hand-side or right-hand-side is an atom, i.e. a predicate or function name with arguments.
class Disjunct:
    def __init(self,id) :
        self.id = id
        self.lhs = None 
        self.rhs = None
    
    def toCaslStr(self):
        oStr = self.lhs.toCaslStr()
        if self.rhs != None:
            oStr = oStr + "= " + self.rhs.toCaslStr()
        return oStr
    
    def toLPStr(self):            
        oStr = "disjunct("+str(self.id)+").\n"
        oStr = oStr + "disjunctLhs("+str(self.id)+","+self.lhs.toLPStr()+").\n"
        if self.rhs != None:
            oStr += "disjunctRhs("+str(self.id)+","+self.rhs.toLPStr()+").\n"
        return oStr

class Conjunct:
    def __init(self,id) :
        self.disjuncts = set()
        self.id = id
    
    def toCaslStr(self):
        oStr = ""
        for d in disjuncts:
            oStr += d.toStr()
            oStr += " \/ "
        oStr = oStr[0:-4]
        return oStr
    
    def toLPStr(self):            
        oStr = "conjunct("+str(self.id)+").\n"
        for d in self.disjuncts:
            oStr = oStr + "conjunctHasDisjunct("+str(self.id)+","+str(d.id)+").\n"
        return oStr

# This represents a quantification of a type (exists or forall) over several variables of different sorts.
class Quantification:
    def __init__(self,type,id) :
        self.vars = {} # vars are dictionaries where the keys are the original var strings and the values are generic var strings of the form <var>:<Sort>. 
        self.type = type
        self.id = id
    
    def toCaslStr(self):
        oStr = self.type + " "
        for var in self.vars.keys():
            oStr =  oStr + var + " : " + self.vars[var] + " ; "
        oStr = oStr[:-2]
        return oStr
    
    def toLPStr(self):            
        oStr = "quantification("+str(id)+","+type+").\n"
        # oStr = "quantificationHasType("+type+").\n"
        for var in self.vars:
            oStr = "quantificationHasVar("+str(id)+","+var.split(":")[0]+","+var.split(":")[1]+").\n"
        return oStr


# This class represents a CASL Axiom.        
class CaslAx:    

    def __init__(self, id, name, axStr):
        self.id = id
        self.name = name
        self.axStr = axStr
        self.removable = 1
        self.priority = 0
        self.quantifications = {} # the key of this dict is an integer that represents the order of the quantification. The value of the dict is the quantification id.
        self.conjunctions = set() # This is a set of conjuncts. A conjunct is a set of disjuncts. A disjunct is a set of strings that represent atoms.
        self.fromAxStr(axStr)

    def toCaslStr(self):
        if self.axStr.find("generated type") != -1:
            return self.axStr + "\n"
        oStr = ''
        for q in sorted(self.quantifications.keys()):
            oStr += self.quantifications[q].toCaslStr()
            oStr += " . "
        oStr = oStr[:-3]
        oStr += "\n\t "
        for c in self.conjunctions:
            oStr += c.toCaslStr() +"\n"
        
        return oStr
        # return self.axStr + " " + "%("+self.name+")% \t " + "%priority(" + str(self.priority) + ")% \t %%rem:" + str(self.removable)+" %%id:"+str(self.id)+" \n"
        
    def toLPStr(self, specName):
        if self.axStr.find("generated type") != -1:
            return ""
        oStr = "hasAxiom("+toLPName(specName)+","+str(self.id)+",1).\n"
        if self.removable == 1:
            oStr = oStr + "removableAx("+toLPName(specName) +","+str(self.id)+").\n"
        oStr = oStr + "priorityAx("+toLPName(specName) +","+str(self.id)+","+str(self.priority)+",1).\n"

        return oStr

    # This generates the internal axiom representation from an axiom string in CASL
    def fromAxStr(self, text):
        # first extract quantifications
        axStr = copy.deepcopy(text)
        qId = 0
        while True:
            forallPos = axStr.find("forall")
            existsPos = axStr.find("exists")
            thisQType = ''
            if forallPos != -1:
                if existsPos == -1:
                    thisQType = 'fa'
                if forallPos < existsPos:
                    thisQType = 'fa'
            if existsPos != -1:
                if forallPos == -1:
                    thisQType = 'ex'
                if existsPos < forallPos:
                    thisQType = 'ex'
            
            # no quantification exists anymore
            if thisQType == '':
                break

            thisQId = "q"+str(qId) + "_" + str(self.id)

            if thisQType == 'fa':
                axStr = axStr[forallPos+len('forall'):]
                thisQ  =  Quantification('forall',thisQId)
            if thisQType == 'ex':
                axStr = axStr[forallPos+len('exists'):]
                thisQ  =  Quantification('exists',thisQId)

            qVars = []

            nextQPos = axStr.find(".")

            varsStr = axStr[:nextQPos-1]
            varsStr = re.sub(" ", "", varsStr)
            axStr = axStr[nextQPos+1:]

            origQVars = varsStr.split(';')
            qVars = {}
            varNum = 0
            for var in origQVars:
                vName = "v"+str(varNum)+"_"+str(qId)#+"_"+var.split(":")[1].lower()
                qVars[vName] = var.split(":")[1]
                varNum = varNum + 1
            # print "---"
            # print origQVars
            # print qVars
            # print "---"
            thisQ.vars = qVars
            self.quantifications[qId] = copy.deepcopy(thisQ)
            qId = qId + 1

        # print self.quantifications
        
        # # Having all the quantifications, we can look at the conjuncts. First remove white spaces from string and then split by \wedge symbol /\

        # axStr = axStr.replace(" ", "")
        # conjuncts = axStr.split("/\\")

        # # Remove brackets from conjuncts. We don't need them becasue we assume conjunctive normal form. 
        # conId = 0
        # for con in conjuncts:
        #     thisCName = "q"+str(conId) + "_" + str(self.id)
        #     thisC = Conjunct(thisCName)

        #     con.replace("(", "")
        #     con.replace(")", "")
            
            


        #     conId = conId + 1


