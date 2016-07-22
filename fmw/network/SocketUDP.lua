local SocketUDP = class("SocketUDP",require("util.eventable").new())
local SOCKET_TICK_TIME = 0.1            -- check socket data interval
local socket = require "socket"

function SocketUDP:ctor(port,getData)
    self.tickScheduler = nil            -- timer for data
    self.reconnectScheduler = nil       -- timer for reconnect
    self.connectTimeTickScheduler = nil -- timer for connect timeout
    self.name = 'SocketTCP'
    self.tcp = nil
    self.isConnected = false
    self.running = true
    self.getData = getData
    self.udp = socket.udp()
    self.udp:settimeout(0)
    self.udp:setsockname('*', port)    --server
end


-- the beginning of the loop proper...
print "Beginning server loop."
function SocketUDP:startServer()

    local __tick = function()
        local data, msg_or_ip, port_or_nil
        data, msg_or_ip, port_or_nil = self.udp:receivefrom()
        if data then
            print("receive " .. data)
            if msg_or_ip then print("receive ip " .. msg_or_ip) end
            if port_or_nil then print("receive port ".. port_or_nil) end
            local result = self.getData(data)

            if result then
                self.udp:sendto(result, msg_or_ip, port_or_nil)
            end
        elseif msg_or_ip ~= 'timeout' then
            error("Unknown network error: "..tostring(msg))
        end


    end

    -- start to read TCP data
    self.tickScheduler = scheduler.scheduleGlobal(__tick, SOCKET_TICK_TIME)
end

function SocketUDP.broadcast(msg,port,callback)
    local udp = socket.udp()

    udp:setoption('broadcast', true)
    udp:settimeout(0)
    --udp:setpeername(address, port)
    udp:sendto(msg, '255.255.255.255', port)
    --udp:send("udp-test0n")
    --udp:send("udp-test1n")
    --udp:send("udp-test2n")

    local data = {}
    local rescheduler
    local count = 0
    local function call()
        count = count +1
        local r = udp:receive()
        if r and #r > 0 then
            table.insert(data,r)
            print(r)
            print('-----')
        end
        
        if count == 10 then
            scheduler.unscheduleGlobal(rescheduler) 
            callback(data)
            udp:close()
        end
    end
    
    rescheduler = scheduler.scheduleGlobal(call, SOCKET_TICK_TIME)


end

function SocketUDP:close( ... )
    --printInfo("%s.close", self.name)
    self.tcp:close();
    if self.tickScheduler then scheduler.unscheduleGlobal(self.tickScheduler) end
end

return SocketUDP