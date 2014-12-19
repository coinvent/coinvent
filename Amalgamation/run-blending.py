from langCasl import *
import os
import subprocess

from settings import *

fName = caslInputFile

xmlFileName = casl2Xml(fName,inputSpaces) 
caslSpecs = parseXmlCasl(xmlFileName)
print "blending the following CASL specs:"
for spec in caslSpecs:
    print spec.toStr()
# raw_input()
print "\n\n\n"

lpRep = toLP(caslSpecs)
lpRep = "#program base1.\n\n" + lpRep

lpFileName = fName.split(".")[0]+".lp"
lpFile = open(lpFileName,'w')
lpFile.write(lpRep)
lpFile.close()
print "Generated Logic Programming facts from CASL Spec."
# raw_input()

lpName = fName.split(".casl")[0] + ".lp"

if searchControlFile != "":
	subprocess.call(["clingo4", "--number="+str(numModels), "iclingo-py.lp", "generalize.lp", lpName, searchControlFile])
else:
	subprocess.call(["clingo4", "--number="+str(numModels), "iclingo-py.lp", "generalize.lp", lpName])
# subprocess.call(["hets", "-g", "amalgamBlend_0.casl"])
