import xml.etree.ElementTree as ET
import subprocess
import os
import copy
import time
from string import *
import re

### input2Xml translates CASL input spaces to an xml file. The xml simplifies the CASL parsing. 
### Input:  CASL file name and names of input spaces
### Output: The path to an xml file representing the input spaces.     
def input2Xml(fName,inputSpaces):    
    newFileName = fName.split(".")[0]+"_raw.casl"
    # os.system("echo \"\" > "+ newFileName)
    xmlFileName = newFileName.split(".")[0]+".xml"

    # First generate .th files from CASL files. 
    print "generating Casl .th files using HETS from " + fName
    # os.system("hets -o th "+fName)
    subprocess.call(["hets", "-o th", fName])
    print "DONE generating casl .th files using HETS"
    
    #To be sure that all .th files have been generated repeat this 5 times. This is necessary because file generation via command line turned out to be buggy,
    allGenerated = False
    tries = 0
    while allGenerated == False and tries < 5:
        allGenerated = True
        for spec in inputSpaces:
            specThFName = fName.split(".")[0]+"_"+spec+".th"
            # print "th fle name" + specThFName
            thFileSize = os.stat(specThFName).st_size
            if (not os.path.isfile(specThFName)) or (thFileSize == 0):
                allGenerated = False
                print ":::::::::::::::: file " + specThFName + " not yet written in " + str(tries) + " times !!!!!!:::::::::::::::"
                subprocess.call(["hets", "-o th", fName])
                thFileSize = os.stat(specThFName).st_size
                break
        tries = tries + 1

    # Second read the input spaces to be blended in CASL syntax from .th files and concatenate the strings. 
    newFileContent = ""
    for spec in inputSpaces:
        tmpFile = open(fName.split(".")[0]+"_"+spec+".th", "r")
        tmp = tmpFile.read()
        newFileContent = newFileContent + tmp
    
    newFile = open(newFileName, "w")
    newFile.write(newFileContent)
    newFile.close()
    os.system("rm *.th")   

    # Third, generate xml file from concatenated CASL input spaces. As above, this is buggy, so we make sure that the xml file is generated correctly by trying 5 times. 
    xmlFileSize = 0
    tries = 0
    print "Generating xml file for parsing."
    while True:
        if os.path.isfile(xmlFileName) and (xmlFileSize != 0):
            # print "Calling parseXml method"
            try:
                tree = ET.parse(xmlFileName)
                # print "End calling parseXml method"
                break
            except ET.ParseError:
                print "xml parse error, trying again..."
        
        if tries > 5:
            print "ERROR: :::::::::::::::: file " + xmlFileName + " not yet written correctly after " + str(tries) + " tries! Aboting... :::::::"
            exit(1)
        tries = tries + 1

        print "calling hets to compute xml"
        subprocess.call(["hets", "-o xml", newFileName])
        if os.path.isfile(xmlFileName):
            statinfo = os.stat(xmlFileName)
            xmlFileSize = statinfo.st_size
        print "done calling hets to compute xml"

    os.remove(newFileName)
    return xmlFileName

## This class represents a predicate in CASL. 
class CaslPred:
    def __init__(self, name):
        self.name = name
        self.args = []
        self.removable = True
    
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
        str = self.name + " : " 
        for s in self.args: str = str + s +" * " 
        str = str[:-3]
        return str         
             
## This class represents an operator in CASL.       
class CaslOp:
    def __init__(self, name):
        self.name = name
        self.args = []
        self.dom = ''
        self.removable = True
    
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
        str = "op " + self.name + " : " 
        for s in self.args: str = str + s +" * " 
        str = str[:-3]
        if self.partial == False:
            arrStr = "->"
        else:
            arrStr = "-> ?"
        str = str + arrStr +self.dom
        if self.removable:
            str = str + " \t (r)"
        return str 
    def toPlainStr(self):
        str = self.name + " : " 
        for s in self.args: str = str + s +" * " 
        str = str[:-3]
        if self.partial == False:
            arrStr = "->"
        else:
            arrStr = "-> ?"
        if len(self.args) > 0:
            str = str + arrStr +self.dom    
        else:
            str = str + " : " +self.dom
        return str 
    
# This class represents a CASL specification.        
class CaslSpec:
    def __init__(self, name):
        self.name = name
        self.ops = []
        self.preds = []
        self.sorts = []
        self.axioms = []
        self.id = 0
    
    def toStr(self):
        s = "CaslSpec:\n"
        s = s + "\t name: " + self.name +"\n"
        s = s + "\t sorts: " 
        for srt in self.sorts: s = s + srt +" " 
        s = s + "\n"
        for op in self.ops: s = s + "\t " + op.toStr() +"\n"
        for p in self.preds: s = s + "\t " + p.toStr() +"\n"
        s += "\n \t axioms: \n"
        for ax in self.axioms: 
            s = s + "\t\t " + ax['ax'] + " \t\t ("+ str(ax['id']) 
            if (ax['removable']) == 1:
                s = s + "-r"
            s = s +") \n"
            # s = s +  "("+ str(ax['id']) +") "
        return s

    def toCaslStr(self):
        # str = "CaslSpec:\n"
        str = "spec "
        str = str +  self.name +" = \n"
        if len(self.sorts) > 0 :
            str = str + "\t sorts " 
        for s in self.sorts: str = str + s +" " 
        str = str + "\n"
        if len(self.ops) > 0 :
            str = str + "\t ops \n" 
        for op in self.ops: str = str + "\t\t " + op.toPlainStr() +"\n"
        if len(self.preds) > 0 :
            str = str + "\t preds \n"
        for p in self.preds: str = str + "\t\t " + p.toPlainStr() +"\n"
        str += "\n"
        for ax in self.axioms: str = str + "\t " + ax['ax'].replace("\n", "\n\t\t\t") + "\n"
        str = str + "end"
        return str
        
    def toLP(self):
        oStr = "spec("+self.name.lower()+").\n"
        oStr = oStr + "hasId("+toLPName(self.name)+","+str(self.id)+").\n"      
        for op in self.ops:
            oStr = oStr + "hasOp("+toLPName(self.name)+","+toLPName(op.name)+",1).\n"
            for arg in op.args:
                oStr = oStr + "opHasSort("+toLPName(op.name)+","+toLPName(arg)+").\n"
            oStr = oStr + "opHasSort("+toLPName(op.name)+","+toLPName(op.dom)+").\n"
            if op.removable == True:
                oStr = oStr + "removable("+toLPName(self.name)+","+toLPName(op.name)+").\n"
        for p in self.preds:
            oStr = oStr + "hasPred("+toLPName(self.name)+","+toLPName(p.name)+",1).\n"
            for arg in p.args:
                oStr = oStr + "predHasSort("+toLPName(p.name)+","+toLPName(arg)+").\n"
            if p.removable == True:
                oStr = oStr + "removable("+toLPName(self.name)+","+toLPName(p.name)+").\n"
        for ax in self.axioms:
            oStr = oStr + "hasAxiom("+toLPName(self.name)+","+str(ax['id'])+",1).\n"
            for predOp in ax['predsOps']:
                oStr = oStr + "axInvolvesPredOp("+str(ax['id'])+","+toLPName(predOp)+").\n"
            if ax['removable'] == 1:
                oStr = oStr + "removable("+toLPName(self.name)+","+str(ax['id'])+").\n"
        #for so in self.sorts:
        #    oStr = oStr + "hasSort("+toLPName(self.name)+","+so+",0).\n"
        return oStr

def toLPName(predOp):
    s = predOp.lower()
    if s == "__+__" or s == "+":
        s =  "plus"
    if s == "__-__" or s == "-":
        s = "minus"
    return s
# This is used to get a predicate object by parsing a string in a predicate node of the xml format that HETS produces. Its probably deprecated, but I don't dare to delete yet (20.12.14)
# def getPredByText(text):
#     pName = text[4:].split(":")[0].strip()
#     thisPred = CaslPred(pName)
#     thisPred.args = text.split(":")[1].strip().split(" * ")
#     return thisPred

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
            # print "nonRemovable ops in " + specName+ ":"
            # print nonRemovableOps
            # generate spec from xmlTree, under consideration of the nonremovable ops
            for entry in decAx:
                if entry.tag == "Symbol":
                    if entry.attrib['kind'] == 'sort':
                        thisSpec.sorts.append(entry.attrib['name'])
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
                    for subEntry in entry:
                        if subEntry.tag == "Text":
                            axText = subEntry.text
                            # print axText
                            axRemovable = checkAxRemovable(nonRemovableOps,axText)
                            thisSpec.axioms.append({'ax' : axText, 'id' : -1, 'removable' : axRemovable})
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
                # if item == ".":
                #     continue
                # if item == "not":
                #     continue
                predOpNames.append(item)
            ax['predsOps'] = copy.deepcopy(predOpNames)
            # print "axiom " + ax['ax'] 
            # print "has id " + str(ax['id'])
            # print " contains the following preds and ops:"
            # print  ax['predsOps']

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
    

def getGeneralizedSpaces(atoms, inputSpaces):
    originalCaslSpecs = copy.deepcopy(inputSpaces)

    generalizations = {}
    lastSpecName = ''
    for spec in originalCaslSpecs:
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
                        # print "action:"
                        # print act
                        if act["actType"] == "rmOp" :
                            for op in cSpec.ops:
                                if op.name.lower() == act["argVect"][0]:
                                    cSpec.ops.remove(op)
                            
                        if act["actType"] == "rmPred" :
                            for p in cSpec.preds:
                                if p.name.lower() == act["argVect"][0]:
                                    cSpec.preds.remove(p)

                        if act["actType"] == "rmAx" :
                            for a in cSpec.axioms:
                                if str(a['id']) == act["argVect"][0]:
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


