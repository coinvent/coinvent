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
    print s.toStr()
# raw_input()
print "\n\n\n"

# Generate the Logic Programming representation of the CASL input spaces. 
lpRep = toLP(inputSpaces)
lpRep = "#program base1.\n\n" + lpRep
lpFileName = fName.split(".")[0]+".lp"
lpFile = open(lpFileName,'w')
lpFile.write(lpRep)
lpFile.close()
print "Generated Logic Programming facts from CASL Spec."
# raw_input()

# Invoke clingo4 and run 
if searchControlFile != "":
	subprocess.call(["clingo4", "--number="+str(numModels), "iterationCore-py.lp", "generalize.lp", lpFileName, searchControlFile])
else:
	subprocess.call(["clingo4", "--number="+str(numModels), "iterationCore-py.lp", "generalize.lp", lpFileName])

# subprocess.call(["hets", "-g", "amalgamBlend_0.casl"])
