from parseCasl import *
import os
import subprocess

from settings import *

fName = caslInputFile

xmlFileName = casl2Xml(fName,specsToConsider) 
caslSpecs = parseXmlCasl(xmlFileName)
print "blending the following CASL specs:"
for spec in caslSpecs:
    print spec.toStr()
# exit(1)
print "\n\n\n"

lpRep = toLP(caslSpecs)
lpRep = "#program base1.\n\n" + lpRep

lpFileName = fName.split(".")[0]+".lp"
lpFile = open(lpFileName,'w')
lpFile.write(lpRep)
lpFile.close()

lpName = fName.split(".casl")[0] + ".lp"

if searchControlFile != "":
	subprocess.call(["clingo4", "--number="+str(numModels), "iclingo-py.lp", "blend.lp", lpName, searchControlFile])# | sed s/\") \"/\")\\n\"/g"])\\
else:
	subprocess.call(["clingo4", "--number="+str(numModels), "iclingo-py.lp", "blend.lp", lpName])# | sed s/\") \"/\")\\n\"/g"])\\	

subprocess.call(["hets", "-g", "amalgamBlend_0.casl"])
