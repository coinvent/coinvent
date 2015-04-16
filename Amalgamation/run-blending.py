from langCasl import *
import os
import subprocess

from settings import *

fName = inputFile

# Generate an xml file from a CASL input file. 
inputSpacesXmlFileName = input2Xml(fName,inputSpaceNames) 
inputSpaces = parseXml(inputSpacesXmlFileName)
print "blending the following CASL specs:"
for s in inputSpaces:
    print s.toCaslStr()
print "\n\n\n"
# raw_input()
# Generate the Logic Programming representation of the CASL input spaces. 
lpRep = toLP(inputSpaces)
lpRep = "#program base.\n\n" + lpRep
lpFileName = fName.split(".")[0]+".lp"
lpFile = open(lpFileName,'w')
lpFile.write(lpRep)
lpFile.close()
print "Generated Logic Programming facts from CASL Spec."

# Invoke clingo4 and run 
subprocess.call(["./clingo4", "--number="+str(numModels), "--quiet", "iterationGeneralize-py.lp", "caslInterface.lp", "generalize.lp", lpFileName])

