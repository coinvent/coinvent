#script(lua)

-- VARIABLES --

-- indicate solving approaches or grounding instructions, respectively
debugs = true -- false
debugg = false -- true

-- maximum time stamp for solving approaches
limit = math.huge

-- smallest and current time stamp
iinit = 0
time = 0

-- sequence number for blocks
block = 0

-- FUNCTIONS --

-- integrate a block appearing at time stamp "init"

function addblock(init)
  if limit < init then time = init end
  if limit < time then return end
  if init < iinit then
    for t = init+1, iinit do
      if debugg then print("Ground: table("..t..")") end
      prg:ground("table", {t})
      for k = 1, block do
        if debugg then print("Ground: move("..k..","..t..")") end
        prg:ground("move", {k, t})
      end
    end
    iinit = init
  end
  rollout(init)
  block = block+1
  if debugg then print("Ground: base_"..block) end
  prg:ground("base_"..block, {})
  if debugg then print("Ground: init("..block..","..init..")") end
  prg:ground("init", {block, init})
  if debugg then print("Ground: state("..block..","..init..")") end
  prg:ground("state", {block, init})
  for t = iinit+1, time do
    if debugg then print("Ground: move("..block..","..t..")") end
    prg:ground("move", {block, t})
    -- for k = 1, block do
    --   prg:assignExternal(gringo.Fun("change", { 1, block, k, t}), false)
    --   prg:assignExternal(gringo.Fun("change", {-1, block, k, t}), false)
    -- end
    -- prg:assignExternal(gringo.Fun("change", { 1, block, t}), false)
    -- prg:assignExternal(gringo.Fun("change", {-1, block, t}), false)
    if init < t then
      if debugg then print("Ground: state("..block..","..t..")") end
      prg:ground("state", {block, t})
    end
  end
  -- prg:assignExternal(gringo.Fun("scope", {block, 0, time+1}), false)
  -- prg:assignExternal(gringo.Fun("scope", {block, 0, time+1}), false)
end

-- ground encoding parts beyond current time stamp up to "next"

function rollout(next)
  if limit < next then
    time = next
    return
  end
  if time < next then
    time = time+1
    if debugg then print("Ground: table("..time..")") end
    prg:ground("table", {time})
    for k = 1, block do
      if debugg then print("Ground: state("..k..","..time..")") end
      prg:ground("state", {k, time})
      if debugg then print("Ground: move("..k..","..time..")") end
      prg:ground("move", {k, time})
      -- prg:assignExternal(gringo.Fun("change", { 1, block, k, time}), false)
      -- prg:assignExternal(gringo.Fun("change", {-1, block, k, time}), false)
    end
    -- prg:assignExternal(gringo.Fun("change", { 1, block, time}), false)
    -- prg:assignExternal(gringo.Fun("change", {-1, block, time}), false)
    rollout(next)
  -- else
    -- for k = 1, block do
      -- prg:assignExternal(gringo.Fun("scope", {k, 0, time+1}), false)
      -- prg:assignExternal(gringo.Fun("scope", {k, 0, time+1}), false)
    -- end
  end
end

-- incrementally solve and ground for increasing time stamps until a plan exists

function incsolve()
  if limit < time then return end
  if debugs then
    print("=============")
    print("TIME "..time)
  end
  ret = prg:solve()
  if debugs then
    if     ret == gringo.SolveResult.SAT     then print "SATISFIABLE"
    elseif ret == gringo.SolveResult.UNSAT   then print "UNSATISFIABLE"
    elseif ret == gringo.SolveResult.UNKNOWN then print "UNKNOWN"
    end
    print("=============")
  end
  if ret == gringo.SolveResult.UNSAT then
    rollout(time+1)
    incsolve()
  end
end

-- AUXILIARY FUNCTIONS --

function setdebugg(debug)
  debugg = debug
end

function setdebugs(debug)
  debugs = debug
end

function setdebug(debug)
  debugg = debug
  debugs = debug
end

function setlimit(custom)
  limit = custom
end

function setiinit(custom)
  iinit = custom
  time = iinit
end

#end.
