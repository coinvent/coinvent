#script (lua)

json = require("json")

function main(prg)

    print(gringo.Fun("f", {1, 2, 3}))

    prg:ground("base", {})
    prg:solve()
    stats = prg:getStats()
    print(json.encode(stats)) -- no pretty printing support

    print("lp.bodies", stats["lp"]["bodies"])
    -- alternativly supports dot access
    print("lp.bodies", stats.lp.bodies)

end

#end.
