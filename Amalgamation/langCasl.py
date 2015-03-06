import xml.etree.ElementTree as ET
import subprocess
import os
import copy
import time
from string import *
import re
from settings import *

from auxFunctions import *

# from FOL import *

axMap = {}
axEqClasses = {}

# caslToLpNameMap = {}
# lpToCaslNameMap = {}

### input2Xml translates CASL input spaces to an xml file. The xml simplifies the CASL parsing. 
### Input:  CASL file name and names of input spaces
### Output: The path to an xml file representing the input spaces.     
def input2Xml(fName,inputSpaces):    
    global hetsExe
    # First generate .th files from CASL files. 
    #To be sure that all .th files have been generated repeat this 5 times. This is necessary because file generation via command line turned out to be buggy,
    allGenerated = False
    tries = 0
    while True:
        print "Generating Casl .th files using HETS from " + fName
        subprocess.call([hetsExe, "-o th", fName])
        print "Done generating casl .th files using HETS"        
        # raw_input()
        allGenerated = True
        for spec in inputSpaces:
            specThFName = fName.split(".")[0]+"_"+spec+".th"
            # print "th fle name" + specThFName
            if os.path.isfile(specThFName):
                thFileSize = os.stat(specThFName).st_size
            else:
                thFileSize = 0
            if thFileSize == 0:
                allGenerated = False
                break
        if allGenerated == True:
             break        
        if tries > 5:
            print "ERROR: file " + specThFName + " not yet written in " + str(tries) + " times ! Aborting..."
            exit(1)                
        tries = tries + 1

    # Second read the input spaces to be blended in CASL syntax from .th files and concatenate the strings. 
    newFileContent = ""
    for spec in inputSpaces:
        thFileName = fName.split(".")[0]+"_"+spec+".th"
        tmpFile = open(thFileName, "r")
        tmp = tmpFile.read()
        newFileContent = newFileContent + tmp
    
    newFileName = fName.split(".")[0]+"_raw.casl"
    newFile = open(newFileName, "w")
    newFile.write(newFileContent)
    newFile.close()

    #Clean up and remove temporary theory files...
    os.system("rm " + fName.split(".")[0]+"*.th")

    # Third, generate xml file from concatenated CASL input spaces. As above, this is buggy, so we make sure that the xml file is generated correctly by trying 5 times. 
    xmlFileName = newFileName.split(".")[0]+".xml"
    
    tries = 0
    # print "Generating xml file for parsing."
    if os.path.isfile(xmlFileName):
        os.system("rm " + xmlFileName)
    while True:
        xmlFileSize = 0
        if os.path.isfile(xmlFileName):
            statinfo = os.stat(xmlFileName)
            xmlFileSize = statinfo.st_size
        if xmlFileSize != 0:
            # print "Calling parseXml method"
            try:
                tree = ET.parse(xmlFileName)
                # print "End calling parseXml method"
                break
            except ET.ParseError:
                print "xml parse error, trying again..."
        
        if tries > 5:
            print "ERROR: File " + xmlFileName + " not yet written correctly after " + str(tries) + " tries! Aboting... :::::::"
            exit(1)
        tries = tries + 1
        print "Calling hets to generate xml file for parsing"
        subprocess.call([hetsExe, "-o xml", newFileName])        
        print "Done calling hets to generate xml"

    os.remove(newFileName)
    return xmlFileName

## This class represents a predicate in CASL. 
class CaslPred:
    def __init__(self, name):
        self.name = name
        self.args = []
        # self.removable = 1
        self.priority = 1
    
    @staticmethod
    def byStr(text):
        pName = text[4:].split(":")[0].strip()
        p = CaslPred(pName)
        p.args = text.split(":")[1].strip().split(" * ")  
        return p
        
    def toCaslStr(self):
        outStr = self.name + " : " 
        for s in self.args: outStr = outStr + s +" * " 
        outStr = outStr[:-3]
        outStr = outStr + "   %% prio:"+ str(self.priority)
        return outStr    

    def toLPStr(self, specName) :
        oStr = "hasPred("+toLPName(specName)+","+toLPName(self.name)+",1).\n"
        argCtr = 1
        for arg in self.args:
            oStr = oStr + "predHasSort("+toLPName(specName)+","+toLPName(self.name)+","+toLPName(arg)+",arg"+str(argCtr)+",1).\n"
            argCtr = argCtr + 1        
        # if self. == True:
            # oStr = oStr + "removablePred("+toLPName(specName)+","+toLPName(self.name)+").\n"
        oStr = oStr + "predHasPriority("+toLPName(specName)+","+toLPName(self.name)+","+str(self.priority)+").\n"        
        return oStr 
             
## This class represents an operator in CASL.       
class CaslOp:
    def __init__(self, name):
        self.name = name
        self.args = []
        self.dom = ''
        # self.removable = 1
        self.isDataOp = False
        self.priority = 1
    
    @staticmethod
    def byStr(text):
        opName = text[2:].split(":")[0].strip()
        op = CaslOp(opName)
        if text.find("->") == -1:
            op.dom = text.split(":")[1].strip()
            op.partial = False
        else: 
            # if the operator is not a partial function (i.e. a total function)
            if text.find("->?") == -1:
                op.args = text.split(":")[1].split("->")[0].strip().split(" * ")  
                op.dom = text.split("->")[1].strip()
                op.partial = False
            # if the operator is a partial function
            else:
                op.args = text.split(":")[1].split("->?")[0].strip().split(" * ")  
                op.dom = text.split("->?")[1].strip()
                op.partial = True
        return op
    
    def toCaslStr(self):
        outStr = self.name + " : " 
        for s in self.args: outStr = outStr + s +" * " 
        outStr = outStr[:-3]
        if self.partial == False:
            arrStr = " -> "
        else:
            arrStr = " ->? "
        if len(self.args) > 0:
            outStr = outStr + arrStr +self.dom    
        else:
            outStr = outStr + " : " +self.dom

        outStr = outStr + "\t%%prio:"+ str(self.priority)
        if self.isDataOp:
            outStr +=  "\t(data operator)"
        return outStr 

    def toLPStr(self,specName):
        oStr = "hasOp("+toLPName(specName)+","+toLPName(self.name)+",1).\n"
        argCtr = 1
        for arg in self.args:
            oStr = oStr + "opHasSort("+toLPName(specName)+","+toLPName(self.name)+","+toLPName(arg)+",arg"+str(argCtr)+",1).\n"
            argCtr = argCtr + 1
        oStr = oStr + "opHasSort("+toLPName(specName)+","+toLPName(self.name)+","+toLPName(self.dom)+",domain,1).\n"
        if self.isDataOp == False:
            oStr = oStr + "isNonDataOp("+toLPName(specName)+","+toLPName(self.name)+").\n"
        else:
            oStr = oStr + "isDataOp("+toLPName(specName)+","+toLPName(self.name)+").\n"
        oStr = oStr + "opHasPriority("+toLPName(specName)+","+toLPName(self.name)+","+str(self.priority)+").\n"        
        return oStr 

    
## This class represents a sort in CASL.       
class CaslSort:
    def __init__(self, name):
        self.name = name
        self.parent = ""
        self.priority = 1
        # self.removable = 1
        self.isDataSort = False

    def toCaslStr(self):
        outStr = "sort " + self.name
        if self.parent != "":
            outStr = outStr + " < " + self.parent
        outStr = outStr + "\t%%prio:"+ str(self.priority)
        if self.isDataSort:
            outStr +=  "\t(data sort)"
        return outStr

    def toLPStr(self,specName):
        oStr = "hasSort("+toLPName(specName)+","+toLPName(self.name)+",1).\n"
        if self.parent != "":
            oStr = oStr + "hasParentSort("+toLPName(specName)+","+toLPName(self.name)+","+toLPName(self.parent)+",1).\n"
        if self.isDataSort == False:
            oStr = oStr + "isNonDataSort("+toLPName(specName)+","+toLPName(self.name)+").\n"
        else:
            oStr = oStr + "isDataSort("+toLPName(specName)+","+toLPName(self.name)+").\n"
        oStr = oStr + "sortHasPriority("+toLPName(specName)+","+toLPName(self.name)+","+str(self.priority)+").\n"
        return oStr

# This class represents a CASL specification.        
class CaslSpec:
    def __init__(self, name):
        self.name = name
        self.ops = []
        self.preds = []
        self.sorts = []
        self.axioms = []
        self.id = 0

    def toCaslStr(self):
        # caslStr = "CaslSpec:\n"
        caslStr = "spec "
        caslStr = caslStr +  self.name +" = \n"
        for s in self.sorts: 
            caslStr = caslStr + "\t " + s.toCaslStr() + "\n"
        if len(self.ops) > 0 :
            caslStr = caslStr + "\t ops \n" 
        for op in self.ops: 
            caslStr = caslStr + "\t\t " + op.toCaslStr() +"\n"
        if len(self.preds) > 0 :
            caslStr = caslStr + "\t preds \n"
        for p in self.preds: 
            caslStr = caslStr + "\t\t " + p.toCaslStr() +"\n"
        caslStr += "\n"
        for ax in self.axioms: 
            caslStr = caslStr + ax.toCaslStr()
        caslStr = caslStr + "end"
        
        return caslStr
        
    def toLP(self):
        oStr  = "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"
        oStr += "%% spec " + self.name+" %%\n"
        oStr += "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n"
        oStr = oStr + "spec("+toLPName(self.name)+").\n"
        oStr = oStr + "hasId("+toLPName(self.name)+","+str(self.id)+").\n\n"      
        oStr += "%% sorts %%\n"
        for so in self.sorts:
            oStr = oStr + so.toLPStr(self.name) + "\n"
        oStr += "%% operators %%\n"
        for op in self.ops:
            oStr = oStr + op.toLPStr(self.name) + "\n"
        oStr += "%% predicates %%\n"
        for p in self.preds:
            oStr = oStr + p.toLPStr(self.name) + "\n"
        oStr += "%% axioms %%\n"
        for ax in self.axioms:
            oStr = oStr + ax.toLPStr(self.name) + "\n"        

        return oStr

class CaslAx:    

    def __init__(self, id, name, axStr):
        self.id = id
        self.name = name
        self.axStr = axStr
        self.isDataAxiom = False # THis determines whether only data operators (generated type constants) are part of this axiom. Typicallay, such axioms denote, e.g., that natural numbers are not equal, that the boolean true is not equal to false, or that the tones of a chord (which are data operators) are not equal. 
        self.priority = 0
        self.eqClass = id
        self.involvedPredsOps = {}
        self.involvedSorts = {}
        self.fromAxStr(axStr)

    def getCaslAnnotationStr(self):
        aStr = ''
        aStr += "\t%("+self.name+")%\t%priority(" + str(self.priority) + ")%\t%%id:"+str(self.id)
        if self.isDataAxiom:
            aStr += "\t(data axiom)"
        return  aStr

    def toCaslStr(self):
        # if self.axStr.find("generated type") != -1:
        return "\t" + self.axStr + self.getCaslAnnotationStr() + "\n"
        
    def toLPStr(self, specName):
        if self.axStr.find("generated type") != -1:
            return ""
        oStr = "\n%% Axiom " + self.name + " %%\n"
        oStr += "hasAxiom("+toLPName(specName)+","+str(self.id)+",1).\n"
        if self.isDataAxiom == False:
            oStr = oStr + "isNonDataAx("+toLPName(specName) +","+str(self.id)+").\n"
        else:
            oStr = oStr + "isDataAx("+toLPName(specName) +","+str(self.id)+").\n"
        oStr = oStr + "axHasPriority("+toLPName(specName) +","+str(self.id)+","+str(self.priority)+").\n"
        
        for po in self.involvedPredsOps.keys():
            oStr += "axInvolvesPredOp("+toLPName(specName) +","+str(self.id)+","+po+",1)."
        for s in self.involvedSorts.keys():
            oStr += "axInvolvesSort("+toLPName(specName) +","+str(self.id)+","+s+",1)."

        return oStr

    # This generates the internal axiom representation from an axiom string in CASL
    def fromAxStr(self, text):
        if text.find("generated type") != -1:
            return True
      
        # first extract quantifications
        axStr = copy.deepcopy(text)
        
        print "parsing axiom"
        print axStr    

        qId = 0
        axStr = axStr.replace("\n", "")

        tmpAxStr = copy.deepcopy(axStr)
        pattern = "\s:\s\w+"
        while True:
            match = re.search(pattern,tmpAxStr)
            if match == None:
                break
            print match.group(0)
            tmpAxStr = re.sub(pattern,"",tmpAxStr,count=1)
            self.involvedSorts[match.group(0)[3:]] = True

        print self.involvedSorts


        tmpAxStr = copy.deepcopy(axStr)
        pattern = "\s:\s\w+"
        while True:
            match = re.search(pattern,tmpAxStr)
            if match == None:
                break
            print match.group(0)
            tmpAxStr = re.sub(pattern,"",tmpAxStr,count=1)
            self.involvedSorts[match.group(0)[3:]] = True
        
        

            # for match in sortsMatches:
                # print match


        #     <qName> v : Sort (.|;)  

        #     forallPos = axStr.find("forall")
        #     existsPos = axStr.find("exists")
        #     thisQType = ''
        #     if forallPos != -1:
        #         if existsPos == -1:
        #             thisQType = 'fa'
        #         if forallPos < existsPos:
        #             thisQType = 'fa'
        #     if existsPos != -1:
        #         if forallPos == -1:
        #             thisQType = 'ex'
        #         if existsPos < forallPos:
        #             thisQType = 'ex'
            
        #     # no quantification exists anymore
        #     if thisQType == '':
        #         break

        #     thisQId = "q"+str(qId) + "_" + str(self.id)

        #     if thisQType == 'fa':
        #         axStr = axStr[forallPos+len('forall'):]
        #         thisQ  =  Quantification('forall',thisQId,qId)
        #     if thisQType == 'ex':
        #         axStr = axStr[existsPos+len('exists'):]
        #         thisQ  =  Quantification('exists',thisQId,qId)

        #     qVars = []

        #     nextQPos = axStr.find(".")

        #     varsStr = axStr[:nextQPos]
        #     varsStr = re.sub(" ", "", varsStr)
        #     axStr = axStr[nextQPos+1:]

        #     origQVars = varsStr.split(';')
        #     qVars = {}
        #     varNum = 0
        #     for varSort in origQVars:
        #         sort = varSort.split(":")[1]
        #         var = varSort.split(":")[0]
        #         vName = "v"+str(varNum)+"_"+str(qId)#+"_"+var.split(":")[1].lower()
        #         qVars[var] = vName+":"+sort
        #         varNum = varNum + 1

        #         # Now replace original varname in axiom string with replacement. This helps to determine equivalence with a simple syntactic check. TODO: THis is still not really logical equivalence, because the order of variables within the same quantification matters. E.g. forall v1,v2. p(v1,v2) is not equivalent to forall v2,v1. p(v1,v2) in our framework, but it should be equivalent. 
        #         axStr = re.sub("(?<!\w)"+var.split(":")[0]+"(?!\w)",vName,axStr)

        #     thisQ.vars = qVars
        #     self.quantifications.append(copy.deepcopy(thisQ))
        #     qId = qId + 1
        
        # # # Having all the quantifications, we can look at the conjuncts. First remove white spaces from string and then split by \wedge symbol /\
        # axStr = axStr.replace("not ", "not#")
        # axStr = axStr.replace(" ", "")
        # axStr = axStr.replace(".", "")
        # axStr = axStr.replace("not#", "not ")

        # #remove opening and closing bracket for axiom string
        # # if axStr[:1] == "(" and axStr[-1:] == ")":
        # #     axStr = axStr[1:]
        # #     axStr = axStr[:-1]
    

        # conjuncts = axStr.split("/\\")

        # conId = 0
        # for con in conjuncts:
        #     thisCName = "c"+str(conId) + "_" + str(self.id)
        #     thisC = Conjunct(thisCName)

        #     # remove possible brackets at end and beginning of conjunct
        #     # if con[:1] == "(" and con[-1:] == ")":
        #     #     con = con[1:]
        #     #     con = con[:-1]
            
        #     # print "conjunct"
        #     # print con

        #     disjuncts = con.split("\\/")
        #     disId = 0
        #     for dis in disjuncts:
        #         thisDName = "d"+str(disId) + "_" + thisCName
        #         thisD = Disjunct(thisDName)
                
        #         # remove possible brackets at end and beginning of disjunct
        #         if dis[:1] == "(" and dis.count("(") == dis.count(")") + 1:
        #             dis = dis[1:]
        #         if dis[-1:] == ")" and dis.count(")") == dis.count("(") + 1:
        #             dis = dis[:-1]

        #         # print "disjunct"
        #         # print dis

        #         if dis.find("not ") == 0:
        #             thisD.negated = True
        #             dis = dis[4:]

        #         disLhsRhs = dis.split("=")
        #         # print "dislhsrhs"
        #         # print disLhsRhs
        #         name = disLhsRhs[0].split("(")[0]
        #         args = re.search("\(.*\)",disLhsRhs[0])
        #         argVect = []
        #         if args:
        #             # print "args lhs"
        #             # print args.group(0)
        #             argVect = args.group(0)[1:-1].split(",")
        #         lhsId = "lhs_"+thisDName
        #         lhs = Atom(lhsId, name, argVect)
        #         thisD.lhs = lhs
        #         if len(disLhsRhs) == 2:
        #             name = disLhsRhs[1].split("(")[0]
        #             args = re.search("\(.*\)",disLhsRhs[1])
        #             argVect = []
        #             if args:
        #                 # print "args rhs"
        #                 # print args.group(0)
        #                 argVect = args.group(0)[1:-1].split(",")
        #             rhsId = "lhs_"+thisDName
        #             rhs = Atom(rhsId,name, argVect)
        #             thisD.rhs = rhs

        #         # print "caslStr:"
        #         # print thisD.toCaslStr()

        #         thisC.disjuncts.add(copy.deepcopy(thisD))

        #         disId = disId + 1

        #     self.conjuncts.add(copy.deepcopy(thisC))
        #     # print "conjunct LP"
        #     # print thisC.toLPStr()
        #     conId = conId + 1

        # print "ax in LP"
        # print self.toLPStr("thisSpec")

        # print "ax in Casl"
        # print self.toCaslStr()

# 


# This is the main method to turn the xml representation of input spaces into the internal data structure
# Input: The path to an XML file name
# Output: a list of CASL specs represented in the internal data structure
def parseXml(xmlFile):
    global axMap
    specs = []
    # print "Calling parseXml method"
    tree = ET.parse(xmlFile)
    # print "End calling parseXml method"
    dGraph = tree.getroot()
    ctr = 0  
    axCtr = 0 
    dataOps = {}
    dataSorts = {}
    for dgNode in dGraph:
        if 'refname' not in dgNode.attrib.keys():
            continue
        specName = dgNode.attrib['refname']
        thisSpec = CaslSpec(specName)
        thisSpec.id = len(specs)
        print "found spec " + specName
        # determine non-removable ops, i.e. those in free type definitions. 
        for decAx in dgNode:
            # determine data ops, and sorts, i.e. those in generated type definitions. 
            dataOps[specName] = []
            dataSorts[specName] = []
            for entry in decAx:
                if entry.tag == "Axiom":
                    for subEntry in entry:
                        if subEntry.tag == "Text":
                            axText = subEntry.text
                            if axText.find("generated type") == 0:

                                dataOpsStr = axText.split("::=")[1]
                                dataOpStrs = dataOpsStr.split("|")
                                for op in dataOpStrs : dataOps[specName].append(op.strip())

                                dataSortStr = axText.split("::=")[0][len("generated type"):].strip()
                                dataSorts[specName].append(dataSortStr)

        for decAx in dgNode:
            for entry in decAx:
                if entry.tag == "Symbol":
                    if entry.attrib['kind'] == 'sort':
                        sName = entry.attrib['name']
                        sort = CaslSort(sName)
                        sSortArr = entry.text.split("<")
                        if len(sSortArr) == 2:
                            pSort = sSortArr[1].strip()
                            sort.parent = pSort
                        
                        if sName in dataSorts[specName]:
                            sort.isDataSort = True
                        else:
                            sort.isDataSort = False
                        
                        thisSpec.sorts.append(sort)
                        
                            # thisSpec.sorts[pSort].childs.append(sName)
                        
                    if entry.attrib['kind'] == 'op':
                        op = CaslOp.byStr(entry.text)
                        # print "op"
                        # print op.name 
                        if op.name in dataOps[specName]:
                            op.isDataOp = True
                        else:
                            op.isDataOp = False
                            # print op.name + " is not removable"
                        thisSpec.ops.append(op)
                        
                    if entry.attrib['kind'] == 'pred':
                        pred = CaslPred.byStr(entry.text)
                        thisSpec.preds.append(pred)   
        # Add axioms
        for decAx in dgNode:
            for entry in decAx:                
                if entry.tag == "Axiom":
                    
                    name = ''
                    if 'name' in entry.attrib.keys():
                        name = entry.attrib['name']
                                        
                    for subEntry in entry:
                        if subEntry.tag == "Text":
                            axStr = subEntry.text
                            if axStr == '':
                                continue
                            ax = CaslAx(axCtr,name,axStr)
                            
                            # Check priority:
                            priority = 0
                            if name.find(":p:") != -1:
                                priority = int(name.split(":p:")[1].split(":")[0])                        
                            if 'priority' in entry.attrib.keys():
                                priority = int(entry.attrib['priority'])
                            ax.priority = priority

                            # If this is an axiom stating that a data op is not equal to a data op, it is a data axiom.
                            axStrArr = axStr.split(" ")
                            predOpNames = []
                            if len(axStrArr) == 5:
                                if axStrArr[4] in dataOps[specName] and axStrArr[2] in dataOps[specName]:
                                    ax.isDataAxiom = True

                            thisSpec.axioms.append(copy.deepcopy(ax))
                    axCtr = axCtr + 1

        specs.append(copy.deepcopy(thisSpec))
    return specs
    
# Turn CASL specs in their internal data structure into a Logic Programming specification that is compatible with the ASP files. 
def toLP(caslSpecs):
    lpStr = ""
    for s in caslSpecs:
        lpStr = lpStr + s.toLP()
        lpStr += "\n\n\n"
    
    return lpStr
    
def getActFromAtom(a):    
    # print a
    if a[:4] != "exec":
        print "Error, this is not an action atom."
        exit(0)
    actStr = a[5:-1]
    act = {}
    actStrArr = actStr.split(",")
    act["step"] = int(actStrArr[len(actStrArr)-1])
    act["iSpace"] = actStrArr[len(actStrArr)-2]
    atomicActStr = ""
    # re-assemble first parts of this string to obtain the atomic generalization action string.
    for item in actStrArr:
        if item == actStrArr[len(actStrArr)-2]:
            break
        atomicActStr = atomicActStr + item + ","
    atomicActStr = atomicActStr[:-1]
    # print atomicActStr
    act["actType"] = atomicActStr.split("(")[0]
    act["argVect"] = atomicActStr.split("(")[1][:-1].split(",")
    return act

def getGeneralizedSpaces(atoms, originalInputSpaces):

    inputSpaces = copy.deepcopy(originalInputSpaces)
    generalizations = {}
    lastSpecName = ''
    for spec in originalInputSpaces:
        generalizations[spec.name] = [spec]
        lastSpecName = spec.name
    # modify CASL data according to Answer Set atoms.
    acts = {}
    for atom in atoms:
        a = str(atom)
        if a[:4] == "exec":
            act = getActFromAtom(a)
            # print "new action: "
            # print act
            if act["step"] not in acts.keys():
                acts[act["step"]] = {}
            if act["iSpace"] not in acts[act["step"]].keys():
                acts[act["step"]][act["iSpace"]] = []
            
            acts[act["step"]][act["iSpace"]].append(act)

    # print " All actions:"
    # print acts
    for step in sorted(acts.keys()):
        for iSpace in sorted(acts[step]):
            for cSpec in inputSpaces:
                # print cSpec.name.lower()
                # remove operators, predicates and axioms
                if cSpec.name.lower() == iSpace:  
                    for act in acts[step][iSpace]:
                        if act["actType"] == "rmOp" :
                            for op in cSpec.ops:
                                if toLPName(op.name) == act["argVect"][0]:
                                    cSpec.ops.remove(op)

                        if act["actType"] == "renameOp" :
                            opFrom = act["argVect"][0]
                            opTo = act["argVect"][1]
                            for op in cSpec.ops:
                                if toLPName(op.name) == opFrom:
                                    cSpec.ops.remove(op)
                            newOp = copy.deepcopy(op)
                            newOp.name = toCaslName(opTo)
                            cSpec.ops.append(newOp)

                            # Get axioms that involve the operator and remove them. 
                            for ax in cSpec.axioms:
                                # predsOpsSorts = ax.determinePredsOpsSorts()
                                # print ax.axStr
                                # print predsOpsSorts
                                if op.name in ax.determinePredsOpsSorts():
                                    # Add new updated axioms with changed operator names
                                    newAxStr = re.sub("(?<!\w)"+opFrom+"(?!\w)", opTo, ax.axStr)
                                    # newAx = copy.deepcopy(ax)
                                    # newAx.axStr = newAxStr
                                    # newAx.id = axMap[newAxStr]
                                    # cSpec.axioms.remove(ax)
                                    # cSpec.axioms.append(newAx)
                                    ax.axStr = newAxStr
                                    ax.id = axMap[newAxStr]
                            
                        if act["actType"] == "rmPred" :
                            for p in cSpec.preds:
                                if toLPName(p.name) == act["argVect"][0]:
                                    cSpec.preds.remove(p)

                        if act["actType"] == "rmSort" :
                            for srt in cSpec.sorts.keys():
                                if toLPName(srt) == act["argVect"][0]:
                                    del cSpec.sorts[srt]

                        if act["actType"] == "rmAx" :
                            for a in cSpec.axioms:
                                if str(a.id) == act["argVect"][0]:
                                    cSpec.axioms.remove(a)

                    thisCSpec = copy.deepcopy(cSpec)
                    thisCSpec.name = thisCSpec.name + "_gen_" + str(len(generalizations[thisCSpec.name]))
                    generalizations[cSpec.name].append(thisCSpec)
                    # print "generalization"
                    # print thisCSpec.toStr()
                    # raw_input()

    # add one last generic cSpec
    genSpec = copy.deepcopy(generalizations[lastSpecName][len(generalizations[lastSpecName])-1])
    genSpec.name = "Generic"
    generalizations["Generic"] = [genSpec]    

    # print generalizations
    for origS in generalizations.values():
        for s in origS:
            print s.toCaslStr()

    return generalizations

# This function works, but it should be more sophisticated and use logical equivalence instead of syntactic equality to check if axioms are equal. 
def getNewAxIdOpRename(axId,op1,op2):
    axInt = int(str(axId))
    op1Str = str(op1)
    op2Str = str(op2)
    global axMap
    # print "Assigning new axiom Id after renaming " + str(op1Str) + " to " + str(op2Str)
    # TODO: This is probably very slow. I have to find another data type that allows of 1-1 mappings with hashing. 
    reverseAxMap = {value:key for key, value in axMap.iteritems()}
    # get original axiom string
    axStr = reverseAxMap[axInt]
    # Now apply renaming operations. Replace ech occurrence of op1, that is not surrounded by alphanumerical symbols a-zA-Z0-9 (encoded as \w in regex), with op2
    newAxStr = re.sub("(?<!\w)"+op1Str+"(?!\w)", op2Str, axStr)
    # print "Replaced " + axStr + " with " + newAxStr
    # exit(0)
    # now add new string to global axiom dictionary if it does not exist already.
    if newAxStr in axMap.keys():
        axId = axMap[newAxStr]
        # print "New ax exists. ID: " + str(axId)
    else:
        if len(axMap.keys()) == 0:
            # this should not happen because there should be at least one axiom when renaming an axiom.
            print "WARNING!! This should not happen. In function: getAxIdOpRename, in langCasl.py"
            exit(0)
        else:
            axId = max(axMap.values())+1
        # print "New ax does not exist. ID: " + str(axId)
        axMap[newAxStr] = axId
    return axId


def newEquivalenceClass(specName,axId, op1,op2):
    global axMap
    global axEqClasses

    newId = 0

    axStr = axMap[axId]

    newAxStr = re.sub(op1,op2,axStr)

    axMap[axId] = newAxStr

    for eqClassId in axEqClasses.keys():
        if isEquivalent(newAxStr,axEqClasses[eqClassId]):
            return eqClassId

    newEqClassId = len(axEqClasses)
    axEqClasses[newEqClassId] = newAxStr

    return newEqClassId



