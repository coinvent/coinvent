#script (python)

import gringo, json

def make_onModel():
    class State:
        def __init__(self):
            self.num = 1
    state = State()
    def onModel(model):
        print "Answer {0}:".format(state.num)
        print model
        state.num += 1
    return onModel

def main(prg):
    prg.ground("base", [])
    
    prg.setConf("-n 0")
    print "All models..."
    prg.solve(make_onModel())

    prg.setConf("-n 1")
    print "One model..."
    prg.solve(make_onModel())

    prg.setConf("-e cautious -n 0")
    print "Solving..."
    prg.solve(make_onModel())

    prg.setConf("-e brave -n 0")
    print "Solving..."
    prg.solve(make_onModel())

    print json.dumps(prg.getStats(), sort_keys=True, indent=4, separators=(',', ': '))
#end.

{ a; b; c }.
