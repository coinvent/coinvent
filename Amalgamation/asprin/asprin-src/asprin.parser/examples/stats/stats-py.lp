#script (python)

import json

def main(prg):
    prg.ground("base", [])
    prg.solve()
    stats = prg.getStats()
    print json.dumps(stats, sort_keys=True, indent=4, separators=(',', ': '))
    print "lp.bodies", stats["lp"]["bodies"]

#end.
