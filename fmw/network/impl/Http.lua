
local SOCKET_TICK_TIME = 0.1            -- check socket data interval
local SOCKET_RECONNECT_TIME = 5         -- socket reconnect try interval
local SOCKET_CONNECT_FAIL_TIMEOUT = 3   -- socket failure timeout

local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_ALREADY_CONNECTED = "already connected"
local STATUS_ALREADY_IN_PROGRESS = "Operation already in progress"
local STATUS_TIMEOUT = "timeout"

--local scheduler = require("framework.scheduler")

local Http = class("Http",require("util.eventable").new())
http.method = {
    GET = "GET",
    POST = "POST",
    PUT = "PUT",
    DELETE = "DELETE",
}

Http.EVENT_DATA = "SOCKET_TCP_DATA"
Http.EVENT_CLOSE = "SOCKET_TCP_CLOSE"
Http.EVENT_CLOSED = "SOCKET_TCP_CLOSED"
Http.EVENT_CONNECTED = "SOCKET_TCP_CONNECTED"
Http.EVENT_CONNECT_FAILURE = "SOCKET_TCP_CONNECT_FAILURE"

function Http:ctor(__url, __retryConnectWhenFailure)
    self.url = __url
    self.tickScheduler = nil            -- timer for data
    self.reconnectScheduler = nil       -- timer for reconnect
    self.connectTimeTickScheduler = nil -- timer for connect timeout
    self.name = 'Http'
    self.tcp = nil
    self.isRetryConnect = __retryConnectWhenFailure
    self.isConnected = false
end

function Http:setName( __name )
    self.name = __name
    return self
end

function Http:setTickTime(__time)
    SOCKET_TICK_TIME = __time
    return self
end

function Http:setReconnTime(__time)
    SOCKET_RECONNECT_TIME = __time
    return self
end

function Http:setConnFailTime(__time)
    SOCKET_CONNECT_FAIL_TIMEOUT = __time
    return self
end

-- 发送数据，参数：string，string，table
function httpSend(type, url, data, callback)
    local xhr = cc.XMLHttpRequest:new() --new 一个http request 实例

    -- response回调函数
    local function responseCallback()
        if nil ~= callback then
            callback(xhr)
        else
            printInfo("callback is nil")
        end
    end

    -- 设置返回值类型及回调函数
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_BLOB
    xhr:registerScriptHandler(responseCallback)
--    xhr:setRequestHeader("Content-Type", "text/html")
 
    -- 请求方式判断
    printInfo("send %s %s",type,url)
    xhr:open(type, url)
    xhr:send(data)
  
--        printInfo("ERROR : type only can be \"Post\" or \"GET\"")
end



function Http:connect(__retryConnectWhenFailure)
    if __retryConnectWhenFailure ~= nil then self.isRetryConnect = __retryConnectWhenFailure end
    assert(self.url, "url are necessary!")
    --printInfo("%s.connect(%s, %d)", self.name, self.host, self.port)
    self:_connect()
--    if not self.isConnected then
--        -- check whether connection is success
--        -- the connection is failure if socket isn't connected after SOCKET_CONNECT_FAIL_TIMEOUT seconds
--        local __connectTimeTick = function ()
--         printInfo("reconnect")
--            if self.isConnected then
--            self:_onConnected()
--             return 
--             end
--            self.waitConnect = self.waitConnect or 0
--            self.waitConnect = self.waitConnect + SOCKET_TICK_TIME
--            if self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT then
--                self.waitConnect = nil
--                self:close()
--                self:_connectFailure()
--            end
--            self:_connect()
--        end
--        if self.isRetryConnect then 
--            self.connectTimeTickScheduler = scheduler.scheduleGlobal(__connectTimeTick, SOCKET_RECONNECT_TIME)
--        else
--            self:_connect()
--        end
--    end
end

function Http:callback(xhr) 
end


local key = DNP_APP.netKey
function Http:send(data)
    --    assert(self.isConnected, self.name .. " is not connected.")
    local that = self
    function callback (xhr)
        local data = crypto.decodeBase64(xhr.response)
        data = crypto.decryptXXTEA(data,key)
        that:dispatchEvent({name=Http.EVENT_DATA, data=data, partial=__partial, body=__body})
    end
    data = crypto.encryptXXTEA(data,key)
    httpSend(http.method.POST,self.url,data,callback)
end

function Http:close( ... )
    --printInfo("%s.close", self.name)
    function callback(xhr)
    	if xhr.statusText == "200" then
            self:dispatchEvent({name=Http.EVENT_CLOSE})
    	end
    end
    httpSend(http.method.DELETE,self.url,"",callback)
end

-- disconnect on user's own initiative.
function Http:disconnect()
    self:_disconnect()
    self.isRetryConnect = false -- initiative to disconnect, no reconnect.
end

--------------------
-- private
--------------------

--- When connect a connected socket server, it will return "already connected"
-- @see: http://lua-users.org/lists/lua-l/2009-10/msg00584.html
function Http:_connect()
    httpSend(http.method.GET,self.url,nil,function (xhr)
        if string.trim(xhr.statusText) == "200 OK" then
            self:_onConnected()
        else
            self:_onDisconnect()
        end
     end)
end

function Http:_disconnect()
    self.isConnected = false
    self.tcp:shutdown()
    self:close()
    self:dispatchEvent({name=Http.EVENT_CLOSED})
end

function Http:_onDisconnect()
    --printInfo("%s._onDisConnect", self.name);
    self.isConnected = false
    self:dispatchEvent({name=Http.EVENT_CLOSED})
    self:_reconnect();
end

-- connecte success, cancel the connection timerout timer
function Http:_onConnected()
printInfo("%s._onConnectd", self.name)
    self.isConnected = true
    self:dispatchEvent({name=Http.EVENT_CONNECTED})
    if self.connectTimeTickScheduler then scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end
    if self.reconnectScheduler then scheduler.unscheduleGlobal(self.reconnectScheduler) end
end

function Http:_connectFailure(status)
    --printInfo("%s._connectFailure", self.name);
    self:dispatchEvent({name=Http.EVENT_CONNECT_FAILURE})
    self:_reconnect();
end

-- if connection is initiative, do not reconnect
function Http:_reconnect(__immediately)
    if not self.isRetryConnect then return end
    printInfo("%s._reconnect", self.name)
    if __immediately then self:connect() return end
    if self.reconnectScheduler then scheduler.unscheduleGlobal(self.reconnectScheduler) end
    local __doReConnect = function ()
        self:connect(false)
    end
    self.reconnectScheduler = scheduler.performWithDelayGlobal(__doReConnect, SOCKET_RECONNECT_TIME)
end

return Http




--local SOCKET_TICK_TIME = 0.1            -- check socket data interval
--local SOCKET_RECONNECT_TIME = 5         -- socket reconnect try interval
--local SOCKET_CONNECT_FAIL_TIMEOUT = 3   -- socket failure timeout
--
--local STATUS_CLOSED = "closed"
--local STATUS_NOT_CONNECTED = "Socket is not connected"
--local STATUS_ALREADY_CONNECTED = "already connected"
--local STATUS_ALREADY_IN_PROGRESS = "Operation already in progress"
--local STATUS_TIMEOUT = "timeout"
--
----local scheduler = require("framework.scheduler")
--
--local Http = class("Http",require("util.eventable").new())
--http.method = {
--    GET = "GET",
--    POST = "POST",
--    PUT = "PUT",
--    DELETE = "DELETE",
--}
--
--Http.EVENT_DATA = "SOCKET_TCP_DATA"
--Http.EVENT_CLOSE = "SOCKET_TCP_CLOSE"
--Http.EVENT_CLOSED = "SOCKET_TCP_CLOSED"
--Http.EVENT_CONNECTED = "SOCKET_TCP_CONNECTED"
--Http.EVENT_CONNECT_FAILURE = "SOCKET_TCP_CONNECT_FAILURE"
--
--function Http:ctor(__url, __retryConnectWhenFailure)
--    self.url = __url
--    self.tickScheduler = nil            -- timer for data
--    self.reconnectScheduler = nil       -- timer for reconnect
--    self.connectTimeTickScheduler = nil -- timer for connect timeout
--    self.name = 'Http'
--    self.tcp = nil
--    self.isRetryConnect = __retryConnectWhenFailure
--    self.isConnected = false
--end
--
--function Http:setName( __name )
--    self.name = __name
--    return self
--end
--
--function Http:setTickTime(__time)
--    SOCKET_TICK_TIME = __time
--    return self
--end
--
--function Http:setReconnTime(__time)
--    SOCKET_RECONNECT_TIME = __time
--    return self
--end
--
--function Http:setConnFailTime(__time)
--    SOCKET_CONNECT_FAIL_TIMEOUT = __time
--    return self
--end
--
---- 发送数据，参数：string，string，table
--function httpSend(type, url, data, callback)
--    local xhr = cc.XMLHttpRequest:new() --new 一个http request 实例
--
--    -- response回调函数
--    local function responseCallback()
--        if nil ~= callback then
--            callback(xhr)
--        else
--            printInfo("callback is nil")
--        end
--    end
--
--    -- 设置返回值类型及回调函数
--    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_BLOB
--    xhr:registerScriptHandler(responseCallback)
--    --    xhr:setRequestHeader("Content-Type", "text/html")
--
--    -- 请求方式判断
--    printInfo("send %s %s",type,url)
--    xhr:open(type, url)
--    xhr:send(data)
--
--    --        printInfo("ERROR : type only can be \"Post\" or \"GET\"")
--end
--
--
--
--function Http:connect(__retryConnectWhenFailure)
--    if __retryConnectWhenFailure ~= nil then self.isRetryConnect = __retryConnectWhenFailure end
--    assert(self.url, "url are necessary!")
--    --printInfo("%s.connect(%s, %d)", self.name, self.host, self.port)
--    self:_connect()
--    --    if not self.isConnected then
--    --        -- check whether connection is success
--    --        -- the connection is failure if socket isn't connected after SOCKET_CONNECT_FAIL_TIMEOUT seconds
--    --        local __connectTimeTick = function ()
--    --         printInfo("reconnect")
--    --            if self.isConnected then
--    --            self:_onConnected()
--    --             return 
--    --             end
--    --            self.waitConnect = self.waitConnect or 0
--    --            self.waitConnect = self.waitConnect + SOCKET_TICK_TIME
--    --            if self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT then
--    --                self.waitConnect = nil
--    --                self:close()
--    --                self:_connectFailure()
--    --            end
--    --            self:_connect()
--    --        end
--    --        if self.isRetryConnect then 
--    --            self.connectTimeTickScheduler = scheduler.scheduleGlobal(__connectTimeTick, SOCKET_RECONNECT_TIME)
--    --        else
--    --            self:_connect()
--    --        end
--    --    end
--end
--
--function Http:callback(xhr) 
--end
--
--function Http:send(data)
--    --    assert(self.isConnected, self.name .. " is not connected.")
--    local that = self
--    function callback (xhr)
--        that:dispatchEvent({name=Http.EVENT_DATA, data=crypto.decodeBase64(xhr.response), partial=__partial, body=__body})
--    end
--    httpSend(http.method.POST,self.url,data,callback)
--end
--
--function Http:close( ... )
--    --printInfo("%s.close", self.name)
--    function callback(xhr)
--        if xhr.statusText == "200" then
--            self:dispatchEvent({name=Http.EVENT_CLOSE})
--        end
--    end
--    httpSend(http.method.DELETE,self.url,"",callback)
--end
--
---- disconnect on user's own initiative.
--function Http:disconnect()
--    self:_disconnect()
--    self.isRetryConnect = false -- initiative to disconnect, no reconnect.
--end
--
----------------------
---- private
----------------------
--
----- When connect a connected socket server, it will return "already connected"
---- @see: http://lua-users.org/lists/lua-l/2009-10/msg00584.html
--function Http:_connect()
--    httpSend(http.method.GET,self.url,nil,function (xhr)
--        if string.trim(xhr.statusText) == "200 OK" then
--            self:_onConnected()
--        else
--            self:_onDisconnect()
--        end
--    end)
--end
--
--function Http:_disconnect()
--    self.isConnected = false
--    self.tcp:shutdown()
--    self:close()
--    self:dispatchEvent({name=Http.EVENT_CLOSED})
--end
--
--function Http:_onDisconnect()
--    --printInfo("%s._onDisConnect", self.name);
--    self.isConnected = false
--    self:dispatchEvent({name=Http.EVENT_CLOSED})
--    self:_reconnect();
--end
--
---- connecte success, cancel the connection timerout timer
--function Http:_onConnected()
--    printInfo("%s._onConnectd", self.name)
--    self.isConnected = true
--    self:dispatchEvent({name=Http.EVENT_CONNECTED})
--    if self.connectTimeTickScheduler then scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end
--    if self.reconnectScheduler then scheduler.unscheduleGlobal(self.reconnectScheduler) end
--end
--
--function Http:_connectFailure(status)
--    --printInfo("%s._connectFailure", self.name);
--    self:dispatchEvent({name=Http.EVENT_CONNECT_FAILURE})
--    self:_reconnect();
--end
--
---- if connection is initiative, do not reconnect
--function Http:_reconnect(__immediately)
--    if not self.isRetryConnect then return end
--    printInfo("%s._reconnect", self.name)
--    if __immediately then self:connect() return end
--    if self.reconnectScheduler then scheduler.unscheduleGlobal(self.reconnectScheduler) end
--    local __doReConnect = function ()
--        self:connect(false)
--    end
--    self.reconnectScheduler = scheduler.performWithDelayGlobal(__doReConnect, SOCKET_RECONNECT_TIME)
--end
--
--return Http
