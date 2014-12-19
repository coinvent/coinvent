###### In this settings file we define some global variables ######

##### CASL input file should contain the input spaces, i.e. specifications to be blended. The CASL file can also contain other specifications, so that e.g. the input spaces can inherit structure from a same parent spec. However, a parent spec is not necessarily a generic space. Currently, only two input spaces are supported.

caslInputFile = "examples/minimal.casl"
inputSpaces = ["S1","S2"]

###### The search control file is an auxiliary file which is supposed to include domain specific knowledge for guiding the search. 
searchControlFile = ""

###### The number of models to be generated (0 for all models)
numModels = 1

###### The minimal number of iterations for generalization
minIterations = 1

###### The maximal number of iterations for generalization
maxIterations = 100


caslInputFile = "examples/cadenceByAx.casl"
inputSpaces = ["Perfect7Cadence","PhrygianCadence"]
searchControlFile = "examples/cadenceByAxControl.lp"

