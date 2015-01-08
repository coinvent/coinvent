#script (python) 

import socket
import os
import errno
from gringo import Fun, Id, SolveResult

class Receiver:
    def __init__(self, conn):
        self.conn = conn
        self.data = bytearray()
    def readline(self):
        pos = self.data.find("\n")
        while pos < 0:
            while True:
                try: self.data.extend(self.conn.recv(4096))
                except socket.error as (code, msg):
                    if code != errno.EINTR: raise
                else: break
            pos = self. data.find("\n")
        msg = self.data[:pos]
        self.data = self.data[pos+1:]
        return msg

class States:
    SOLVE = 1
    IDLE  = 2

def mainn(prg):
    with open(".controller.PORT", "r") as f:
        p = int(f.read())
    os.remove(".controller.PORT")
    conn = socket.create_connection(("127.0.0.1", p))
    try:
        recv  = Receiver(conn)
        state = States.IDLE
        k     = 0
        prg.ground("pigeon", [])
        prg.ground("sleep",  [k])
        prg.assignExternal(Fun("sleep", [k]), True)
        while True:
            if state == States.SOLVE:
                f = prg.asolve(
                    lambda model:            conn.sendall("Answer: " + str(model) + "\n"),
                    lambda ret, interrupted: conn.sendall("finish:" + str(ret) + (":INTERRUPTED" if interrupted else "") + "\n"))
            msg = recv.readline()
            if state == States.SOLVE:
                f.interrupt()
                ret = f.get()
            else:
                ret = SolveResult.UNKNOWN
            if msg == "interrupt":
                state = States.IDLE
            elif msg == "exit":
                return
            elif msg == "less_pigeon_please":
                prg.assignExternal(Id("p"), False)
                state = States.IDLE
            elif msg == "more_pigeon_please":
                prg.assignExternal(Id("p"), True)
                state = States.IDLE
            elif msg == "solve":
                state = States.SOLVE
            else: raise(RuntimeError("unexpected message: " + msg))
            if ret != SolveResult.UNKNOWN:
                k = k + 1
                prg.ground("sleep", [k])
                prg.forgetExternal(Fun("sleep", [k-1]))
                prg.assignExternal(Fun("sleep", [k]), True)
    finally:
        conn.close()
#end.

#script (lua) 

function run(prg, conn)
    local States = {
        ["SOLVE"] = 1,
        ["IDLE"]  = 2,
    }
    local SolveResults = {
        [gringo.SolveResult.SAT]     = "SAT",
        [gringo.SolveResult.UNSAT]   = "UNSAT",
        [gringo.SolveResult.UNKNOWN] = "UNKNOWN",
    }
    local state = States.IDLE
    local k = 0
    prg:ground("pigeon", {})
    prg:ground("sleep",  {k})
    prg:assignExternal(gringo.Fun("sleep", {k}), true)
    while true do
        local f, ret, msg, err
        if state == States.SOLVE then
            f = prg:asolve(
                function (model) conn:send("Answer: "..str(model).."\n") end, 
                function (ret, int)
                    local msg = "finish:"..SolveResults[ret]
                    if int then msg = msg..":INTERRUPTED" end
                    conn:send(msg.."\n") 
                end)
        end
        msg, err = conn:receive("*l")
        if msg == nil then error(err) end
        if state == States.SOLVE then
            f:interrupt()
            ret = f:get()
        else
            ret = gringo.SolveResult.UNKNOWN
        end
        if msg == "interrupt" then
            state = States.IDLE
        elseif msg == "exit" then
            return
        elseif msg == "less_pigeon_please" then
            prg:assignExternal(gringo.Id("p"), false)
            state = States.IDLE
        elseif msg == "more_pigeon_please" then
            prg:assignExternal(gringo.Id("p"), true)
            state = States.IDLE
        elseif msg == "solve" then
            state = States.SOLVE
        else error("unexpected message: " .. msg) end
        if ret ~= gringo.SolveResult.UNKNOWN then
            k = k + 1
            prg:ground("sleep",  {k})
            prg:forgetExternal(gringo.Fun("sleep", {k-1}))
            prg:assignExternal(gringo.Fun("sleep", {k}), true)
        end
    end
end

function main(prg)
    file = io.open(".controller.PORT", "r")
    if file == nil then error("apparently no server is running") end
    p = tonumber(file:read("*all"))
    file:close()
    os.remove(".controller.PORT")
    socket = require "socket"
    conn = socket.tcp()
    ret, err = conn:connect("127.0.0.1", p)
    if ret == nil then error(err) end
    ret, err = pcall(run, prg, conn)
    conn:close()
    if not ret then error(err) end
end

#end.

#const m = 10.
#const n = 190.

#program pigeon.
#external p.

1 { p(X); q(X) } 1 :- X = 1..n.
:- not n+1 { p(1..n); q(1..n) }, p.

#program sleep(k).
#external sleep(k).

1 { p(k,X); q(k,X) } 1 :- X = 1..m, sleep(k), not p.
:- not m+1 { p(k,1..m); q(k,1..m) }, sleep(k), not p.

