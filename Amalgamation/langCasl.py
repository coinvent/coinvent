import xml.etree.ElementTree as ET
import subprocess
import os
import copy
import time
from string import *
import re
from settings import *

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
        self.removable = True
        self.priority = 1
    
    @staticmethod
    def byStr(text):
        pName = text[4:].split(":")[0].strip()
        p = CaslPred(pName)
        p.args = text.split(":")[1].strip().split(" * ")  
        return p
        
    def toStr(self):
        str = "pred " + self.name + " : " 
        for s in self.args: str = str + s +" * " 
        str = str[:-3]
        return str    

    def toPlainStr(self):
        outStr = self.name + " : " 
        for s in self.args: outStr = outStr + s +" * " 
        outStr = outStr[:-3]

        outStr = outStr + "   %% p:"+ str(self.priority)

        return outStr 
             
## This class represents an operator in CASL.       
class CaslOp:
    def __init__(self, name):
        self.name = name
        self.args = []
        self.dom = ''
        self.removable = True
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
    
    def toStr(self):
        outStr = "op " + self.name + " : " 
        for s in self.args: outStr = outStr + s +" * " 
        outStr = outStr[:-3]
        if self.partial == False:
            arrStr = " -> "
        else:
            arrStr = " ->? "
        outStr = outStr + arrStr +self.dom
        outStr = outStr + str(self.priority)
        if self.removable:
            outStr = outStr + " \t (r)"
        return outStr 
    
    def toPlainStr(self):
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

        outStr = outStr + "   %% p:"+ str(self.priority)
        return outStr 
    
## This class represents a sort in CASL.       
class CaslSort:
    def __init__(self, name):
        self.name = name
        self.parent = ""
        self.priority = 1
        self.removable = True
        # self.childs = []

    def toStr(self):
        outStr = "sort " + self.name
        if self.parent != "":
            outStr = outStr + " < " + self.parent
        outStr = outStr + "   %% p:"+ str(self.priority)
        return outStr

# This class represents a CASL specification.        
class CaslSpec:
    def __init__(self, name):
        self.name = name
        self.ops = []
        self.preds = []
        self.sorts = {}
        self.axioms = []
        self.id = 0

    def toCaslStr(self):
        # caslStr = "CaslSpec:\n"
        caslStr = "spec "
        caslStr = caslStr +  self.name +" = \n"
        for s in self.sorts.keys(): 
            caslStr = caslStr + "\t sort " + s  
            if self.sorts[s].parent != "":
                caslStr = caslStr + " < " + self.sorts[s].parent
            caslStr = caslStr + "   %% p:" + str(self.sorts[s].priority)
            caslStr = caslStr + "\n" 

        caslStr = caslStr + "\n"
        if len(self.ops) > 0 :
            caslStr = caslStr + "\t ops \n" 
        for op in self.ops: caslStr = caslStr + "\t\t " + op.toPlainStr() +"\n"
        if len(self.preds) > 0 :
            caslStr = caslStr + "\t preds \n"
        for p in self.preds: 
            caslStr = caslStr + "\t\t " + p.toPlainStr() +"\n"
        caslStr += "\n"
        for ax in self.axioms: 
            caslStr = caslStr + "\t " + ax['ax'].replace("\n", "\n\t\t\t") + "\t" + "%(" + ax["name"]+ ")%" + " %importance(" + str(ax['priority']) +")%"   "  %% AxId:"+str(ax['id']) + "   p:"+str(ax['priority']) + "\n"
        caslStr = caslStr + "end"
        return caslStr
        
    def toLP(self):
        oStr = "spec("+toLPName(self.name)+").\n"
        oStr = oStr + "hasId("+toLPName(self.name)+","+str(self.id)+").\n"      
        for op in self.ops:
            oStr = oStr + "hasOp("+toLPName(self.name)+","+toLPName(op.name)+",1).\n"
            for arg in op.args:
                oStr = oStr + "opHasSort("+toLPName(self.name)+","+toLPName(op.name)+","+toLPName(arg)+").\n"
            oStr = oStr + "opHasSort("+toLPName(self.name)+","+toLPName(op.name)+","+toLPName(op.dom)+").\n"
            if op.removable == True:
                oStr = oStr + "removable("+toLPName(self.name)+","+toLPName(op.name)+").\n"
            oStr = oStr + "priority("+toLPName(self.name)+","+toLPName(op.name)+","+str(op.priority)+").\n"
        for p in self.preds:
            oStr = oStr + "hasPred("+toLPName(self.name)+","+toLPName(p.name)+",1).\n"
            for arg in p.args:
                oStr = oStr + "predHasSort("+toLPName(self.name)+","+toLPName(p.name)+","+toLPName(arg)+").\n"
            if p.removable == True:
                oStr = oStr + "removable("+toLPName(self.name)+","+toLPName(p.name)+").\n"
            oStr = oStr + "priority("+toLPName(self.name)+","+toLPName(p.name)+","+str(p.priority)+").\n"
        for ax in self.axioms:
            oStr = oStr + "hasAxiom("+toLPName(self.name)+","+str(ax['id'])+",1).\n"
            for predOp in ax['predsOps']:
                oStr = oStr + "axInvolvesPredOp("+str(ax['id'])+","+toLPName(predOp)+").\n"
            if ax['removable'] == 1:
                oStr = oStr + "removable("+toLPName(self.name)+","+str(ax['id'])+").\n"
            oStr = oStr + "priority("+toLPName(self.name)+","+toLPName(str(ax['id']))+","+str(ax['priority'])+").\n"
        
        for so in self.sorts.keys():
            oStr = oStr + "hasSort("+toLPName(self.name)+","+toLPName(so)+",1).\n"
            if self.sorts[so].parent != "":
                oStr = oStr + "isParentSort("+toLPName(self.name)+","+toLPName(self.sorts[so].parent)+","+toLPName(so)+").\n"
            if self.sorts[so].removable == True:
                oStr = oStr + "removable("+toLPName(self.name)+","+toLPName(so)+").\n"
            oStr = oStr + "priority("+toLPName(self.name)+","+toLPName(so)+","+str(self.sorts[so].priority)+").\n"
        return oStr

# This is just a dirty quickfix to use (infix) plus and minus operators. 
def toLPName(predOp):
    s = predOp.lower()
    if s == "__+__" or s == "+":
        s =  "plus"
    if s == "__-__" or s == "-":
        s = "minus"
    return s

# This is the main method to turn the xml representation of input spaces into the internal data structure
# Input: The path to an XML file name
# Output: a list of CASL specs represented in the internal data structure
def parseXml(xmlFile):
    specs = []
    # print "Calling parseXml method"
    tree = ET.parse(xmlFile)
    # print "End calling parseXml method"
    dGraph = tree.getroot()
    ctr = 0   
    for dgNode in dGraph:
        if 'refname' not in dgNode.attrib.keys():
            continue
        specName = dgNode.attrib['refname']
        thisSpec = CaslSpec(specName)
        thisSpec.id = len(specs)
        print "found spec " + specName
        for decAx in dgNode:
            # determine non-removable ops, i.e. those in free type definitions. 
            nonRemovableOps = []
            for entry in decAx:
                if entry.tag == "Axiom":
                    for subEntry in entry:
                        if subEntry.tag == "Text":
                            axText = subEntry.text
                            if axText.find("generated type") == 0:
                                nonRemStr = axText.split("::=")[1]
                                nonRems = nonRemStr.split("|")
                                for nr in nonRems : nonRemovableOps.append(nr.strip())
        for decAx in dgNode:
            for entry in decAx:
                if entry.tag == "Symbol":
                    if entry.attrib['kind'] == 'sort':
                        sName = entry.attrib['name']
                        thisSpec.sorts[entry.attrib['name']] = CaslSort(sName)
                        sSortArr = entry.text.split("<")
                        if len(sSortArr) == 2:
                            pSort = sSortArr[1].strip()
                            thisSpec.sorts[sName].parent = pSort
                            # thisSpec.sorts[pSort].childs.append(sName)
                        
                    if entry.attrib['kind'] == 'op':
                        op = CaslOp.byStr(entry.text)
                        # print "op"
                        # print op.name 
                        if op.name in nonRemovableOps:
                            op.removable = False
                            # print op.name + " is not removable"
                        thisSpec.ops.append(op)
                        
                    if entry.attrib['kind'] == 'pred':
                        pred = CaslPred.byStr(entry.text)
                        thisSpec.preds.append(pred)   
                        
                if entry.tag == "Axiom":
                    name = ''
                    if 'name' in entry.attrib.keys():
                        name = entry.attrib['name']
                    
                    priority = 1
                    # # This is a quick hack to encode axiom prioritites in axiom names using :p:. 
                    if name.find(":p:") != -1:
                        priority = int(name.split(":p:")[1])   
                    if 'importance' in entry.attrib.keys():
                        priority = int(entry.attrib['importance'])
                    for subEntry in entry:
                        if subEntry.tag == "Text":
                            axText = subEntry.text
                            # print axText
                            axRemovable = checkAxRemovable(nonRemovableOps,axText)
                            thisSpec.axioms.append({'ax' : axText, 'id' : -1, 'removable' : axRemovable, 'priority' : priority, 'name' : name})
        # print thisSpec.toStr()
        specs.append(thisSpec)

    # enumerate axioms
    axCtr = 1
    for spec in specs:
        for ax in spec.axioms:
            idAssigned = False
            for spec2 in specs:
                if idAssigned:
                    break
                if spec2.name == spec.name:
                    continue
                for ax2 in spec2.axioms:
                    if idAssigned:
                        break
                    if ax2['ax'] == ax['ax'] and ax2['id'] != -1:
                        ax['id'] = ax2['id']
                        idAssigned = True
            if idAssigned == False:
                ax['id'] = axCtr
                axCtr = axCtr + 1

    # print "# check occurrence of predicates and operators in axioms"
    for spec in specs:
        # print spec.toStr()
        for ax in spec.axioms:
            if ax['ax'].find("generated type") == 0:
                ax['predsOps'] = [] 
                continue
            axStrArr = re.split("[ .=(),:><;\n]|not|forall|exists|exists!",ax['ax'])
            # print axStrArr
            predOpNames = []
            for item in axStrArr:
                if item == "":
                    continue
                predOpNames.append(item)
            ax['predsOps'] = copy.deepcopy(predOpNames)

    return specs

# Check whether an axiom may be removed with an atomic generalization operation.
# Input: list of non-removable operators and predicates, and a string representation of an axiom
# Output: 1 or 0 to determine whether the axiom is removable. The axiom is not removable if it involves a non-removable operator or predicate.
def checkAxRemovable(nonRemovableOps,axText):
    if axText.find("generated type") == 0:
        return 0
    axStrArr = axText.split(" ")
    predOpNames = []
    allGenerated = True
    # If this is an axiom stating that a generated type is not equal to a generated type, 
    if len(axStrArr) == 5:
        if axStrArr[4] in nonRemovableOps and axStrArr[2] in nonRemovableOps:
            # print "axiom "+ axText + " not removable because it consists only of generated type specs."
            return 0
    return 1
    
# Turn CASL specs in their internal data structure into a Logic Programming specification that is compatible with the ASP files. 
def toLP(caslSpecs):
    lpStr = ""
    for s in caslSpecs:
        lpStr = lpStr + s.toLP()
        lpStr += "\n\n\n"
    
    return lpStr
    

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
            # print a
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
                atomicActStr = atomicActStr + item
            act["actType"] = atomicActStr.split("(")[0]
            act["argVect"] = atomicActStr.split("(")[1][:-1].split(",")
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
                                if op.name.lower() == act["argVect"][0]:
                                    cSpec.ops.remove(op)
                            
                        if act["actType"] == "rmPred" :
                            for p in cSpec.preds:
                                if p.name.lower() == act["argVect"][0]:
                                    cSpec.preds.remove(p)

                        if act["actType"] == "rmSort" :
                            for srt in cSpec.sorts.keys():
                                if toLPName(srt) == act["argVect"][0]:
                                    del cSpec.sorts[srt]

                        if act["actType"] == "rmAx" :
                            for a in cSpec.axioms:
                                if str(a['id']) == act["argVect"][0]:
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

    return generalizations


