local protocal = class("protocol",require("eventable").new())


local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_ALREADY_CONNECTED = "already connected"
local STATUS_ALREADY_IN_PROGRESS = "Operation already in progress"
local STATUS_TIMEOUT = "timeout"

--local scheduler = require("framework.scheduler")


protocal.EVENT_DATA = "TCP_DATA"
protocal.EVENT_CLOSE = "TCP_CLOSE"
protocal.EVENT_CLOSED = "TCP_CLOSED"
protocol.EVENT_CONNECTED = "TCP_CONNECTED"
protocol.EVENT_CONNECT_FAILURE = "TCP_CONNECT_FAILURE"

protocol._VERSION = socket._VERSION
protocol._DEBUG = socket._DEBUG

function protocol.getTime()
    return socket.gettime()
end

function protocol:ctor(__host, __port, __retryConnectWhenFailure)
    self.host = __host
    self.port = __port
    self.tickScheduler = nil            -- timer for data
    self.reconnectScheduler = nil       -- timer for reconnect
    self.connectTimeTickScheduler = nil -- timer for connect timeout
    self.name = 'protocol'
    self.tcp = nil
    self.isRetryConnect = __retryConnectWhenFailure
    self.isConnected = false
end

function protocol:setName( __name )
    self.name = __name
    return self
end

function protocol:setTickTime(__time)
    SOCKET_TICK_TIME = __time
    return self
end

function protocol:setReconnTime(__time)
    SOCKET_RECONNECT_TIME = __time
    return self
end

function protocol:setConnFailTime(__time)
    SOCKET_CONNECT_FAIL_TIMEOUT = __time
    return self
end

function protocol:connect(__host, __port, __retryConnectWhenFailure)
    if __host then self.host = __host end
    if __port then self.port = __port end
    if __retryConnectWhenFailure ~= nil then self.isRetryConnect = __retryConnectWhenFailure end
    assert(self.host or self.port, "Host and port are necessary!")
    --printInfo("%s.connect(%s, %d)", self.name, self.host, self.port)
    self.tcp = socket.tcp()
    self.tcp:settimeout(0)

    local function __checkConnect()
        local __succ = self:_connect()
        if __succ then
            self:_onConnected()
        end
        return __succ
    end

    if not __checkConnect() then
        -- check whether connection is success
        -- the connection is failure if socket isn't connected after SOCKET_CONNECT_FAIL_TIMEOUT seconds
        local __connectTimeTick = function ()
            --printInfo("%s.connectTimeTick", self.name)
            if self.isConnected then return end
            self.waitConnect = self.waitConnect or 0
            self.waitConnect = self.waitConnect + SOCKET_TICK_TIME
            if self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT then
                self.waitConnect = nil
                self:close()
                self:_connectFailure()
            end
            __checkConnect()
        end
        self.connectTimeTickScheduler = scheduler.scheduleGlobal(__connectTimeTick, SOCKET_TICK_TIME)
    end
end

function protocol:send(__data)
    assert(self.isConnected, self.name .. " is not connected.")
    self.tcp:send(__data)
end

function protocol:close( ... )
    --printInfo("%s.close", self.name)
    self.tcp:close();
    if self.connectTimeTickScheduler then scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end
    if self.tickScheduler then scheduler.unscheduleGlobal(self.tickScheduler) end
    self:dispatchEvent({name=protocol.EVENT_CLOSE})
end

-- disconnect on user's own initiative.
function protocol:disconnect()
    self:_disconnect()
    self.isRetryConnect = false -- initiative to disconnect, no reconnect.
end

--------------------
-- private
--------------------

--- When connect a connected socket server, it will return "already connected"
-- @see: http://lua-users.org/lists/lua-l/2009-10/msg00584.html
function protocol:_connect()
    local __succ, __status = self.tcp:connect(self.host, self.port)
    -- print("protocol._connect:", __succ, __status)
    return __succ == 1 or __status == STATUS_ALREADY_CONNECTED
end

function protocol:_disconnect()
    self.isConnected = false
    self.tcp:shutdown()
    self:dispatchEvent({name=protocol.EVENT_CLOSED})
end

function protocol:_onDisconnect()
    --printInfo("%s._onDisConnect", self.name);
    self.isConnected = false
    self:dispatchEvent({name=protocol.EVENT_CLOSED})
    self:_reconnect();
end

-- connecte success, cancel the connection timerout timer
function protocol:_onConnected()
    --printInfo("%s._onConnectd", self.name)
    self.isConnected = true
    self:dispatchEvent({name=protocol.EVENT_CONNECTED})
    if self.connectTimeTickScheduler then scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end

    local __tick = function()
        while true do
            -- if use "*l" pattern, some buffer will be discarded, why?
            local __body, __status, __partial = self.tcp:receive("*a")  -- read the package body
            --print("body:", __body, "__status:", __status, "__partial:", __partial)
            if __status == STATUS_CLOSED or __status == STATUS_NOT_CONNECTED then
                self:close()
                if self.isConnected then
                    self:_onDisconnect()
                else
                    self:_connectFailure()
                end
                return
            end
            if  (__body and string.len(__body) == 0) or
                (__partial and string.len(__partial) == 0)
            then return end
            if __body and __partial then __body = __body .. __partial end
            self:dispatchEvent({name=protocol.EVENT_DATA, data=(__partial or __body), partial=__partial, body=__body})
        end
    end

    -- start to read TCP data
    self.tickScheduler = scheduler.scheduleGlobal(__tick, SOCKET_TICK_TIME)
end

function protocol:_connectFailure(status)
    --printInfo("%s._connectFailure", self.name);
    self:dispatchEvent({name=protocol.EVENT_CONNECT_FAILURE})
    self:_reconnect();
end

-- if connection is initiative, do not reconnect
function protocol:_reconnect(__immediately)
    if not self.isRetryConnect then return end
    printInfo("%s._reconnect", self.name)
    if __immediately then self:connect() return end
    if self.reconnectScheduler then scheduler.unscheduleGlobal(self.reconnectScheduler) end
    local __doReConnect = function ()
        self:connect()
    end
    self.reconnectScheduler = scheduler.performWithDelayGlobal(__doReConnect, SOCKET_RECONNECT_TIME)
end


return protocal