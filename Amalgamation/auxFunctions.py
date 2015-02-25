# This is just a dirty quickfix to use (infix) plus and minus operators. 
def toLPName(caslName):
    s = caslName[0:1].lower() + caslName[1:]
    if s == "__+__" or s == "+":
        s =  "plus"
    if s == "__-__" or s == "-":
        s = "minus"
    return s

# TODO: This causes errors when upper-case letters are used in operators, predicates or sorts. I should create a dictionary with a mapping from Casl to LP names and vice versa. 
def toCaslName(lpName):
    # s = predOp.lower()
    s = lpName
    # if s == "__+__" or s == "+":
    #     s =  "plus"
    # if s == "__-__" or s == "-":
    #     s = "minus"
    return s
