###### In this settings file we define some global variables ######

##### The input file should contain the input spaces, i.e. specifications to be blended. The file can also contain other specifications, so that e.g., in CASL, the input spaces can inherit structure from a same parent space. However, a parent space is not necessarily a generic space. Currently, only two input spaces are supported.

inputFile = "examples/minimal.casl"
inputSpaceNames = ["S1","S2"]

###### The search control file is an auxiliary file which is supposed to include domain specific knowledge for guiding the search. 
searchControlFile = ""

###### The number of models to be generated (0 for all models)
numModels = 30

###### The minimal number of iterations for generalization
minIterationsGeneralize = 1

###### The maximal number of iterations for generalization
maxIterationsGeneralize = 20

###### The minimal number of iterations for blending
minIterationsBlend = 1

###### The maximal number of iterations for blending
maxIterationsBlend = 20

###### Time limit for eprover and darwin consistency check in seconds CPU time
eproverTimeLimit = 10
darwinTimeLimit = 10

############################
###### CASL-specific #######
############################

###### For generalization, determine whether removal of axioms, sorts, predicates and operators are allowed atomic generalization actions. For certain domains it may be useful to use only a subset of generalization operations.
# TODO: THis is currently not working... For now (de)-comment respective LP rules in generalize.lp file to select generalization operations
# rmAxAllowed = True
# rmPredAllowed = True
# rmOpAllowed = True
# rmSortAllowed = True

###################################################################

## Here is space to quickly overwrite the above settings for debugging purposes.
inputFile = "examples/cadenceByAx.casl"
inputSpaceNames = ["Perfect7Cadence","PhrygianCadence"]
# searchControlFile = "examples/cadenceByAxControl.lp"

# inputFile = "examples/chordBlendRelAbsSimple.casl"
# inputSpaceNames = ["Dmin7","Emaj7"]

# inputFile = "examples/subSortTest.casl"
# inputSpaceNames = ["S1","S2"]
