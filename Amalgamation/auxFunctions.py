
def toLPName(caslName,elemType):

    # This is just a dirty quickfix to use (infix) plus and minus operators. 
    s = caslName
    if s == "__+__" or s == "+":
       s =  "plus"
    if s == "__-__" or s == "-":
        s = "minus"

    s = elemType + "_"+caslName
    return s

def lpToCaslStr(lpName):
    uScorePos = lpName.find("_")
    if uScorePos == -1:
        print "Error, lpname invalid"
        exit(1)
    return lpName[uScorePos+1:]
