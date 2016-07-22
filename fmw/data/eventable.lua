---------------------------
-- 事件协议封装的基类
--
-- @type eventable
local eventable = class("eventable")

function eventable:ctor()
    self.listeners_ = {}
    self.nextListenerHandleIndex_ = 0
    return self
end


---------------------------
--添加一个事件监听函数
--@function [parent=#eventable] addEventListener
--@param string#string eventName 事件命名
--@param function#function listener 监听函数钩子
--@param tag#tag tag 标记名
--@return number#number 监听句柄
function eventable:addEventListener(eventName, listener, tag)

    assert(type(eventName) == "string" and eventName ~= "",
        "eventable:addEventListener() - invalid eventName")
    eventName = string.upper(eventName)
    if self.listeners_[eventName] == nil then
        self.listeners_[eventName] = {}
    end

    local ttag = type(tag)
    if ttag == "table" or ttag == "userdata" then
        PRINT_DEPRECATED("eventable:addEventListener(eventName, listener, target) is deprecated, please use eventable:addEventListener(eventName, handler(target, listener), tag)")
        listener = handler(tag, listener)
        tag = ""
    end

    self.nextListenerHandleIndex_ = self.nextListenerHandleIndex_ + 1
    local handle = tostring(self.nextListenerHandleIndex_)
    tag = tag or ""
    self.listeners_[eventName][handle] = {listener, tag}

    if DEBUG > 1 then
        printInfo("%s [eventable] addEventListener() - event: %s, handle: %s, tag: %s", tostring(self.target_), eventName, handle, tostring(tag))
    end

    return handle
end



---------------------------
--分发事件消息
--@function [parent=#eventable] dispatchEvent
--@param event#event event 事件对象
--@return handle#handle 目标句柄
function eventable:dispatchEvent(event)
    event.name = string.upper(tostring(event.name))
    local eventName = event.name
    if DEBUG > 1 then
        printInfo("%s [eventable] dispatchEvent() - event %s", tostring(self.target_), eventName)
    end

    if self.listeners_[eventName] == nil then return end
    event.target = self.target_
    event.stop_ = false
    event.stop = function(self)
        self.stop_ = true
    end

    for handle, listener in pairs(self.listeners_[eventName]) do
        if DEBUG > 1 then
            printInfo("%s [eventable] dispatchEvent() - dispatching event %s to listener %s", tostring(self.target_), eventName, handle)
        end
        -- listener[1] = listener
        -- listener[2] = tag
        listener[1](event)
        if event.stop_ then
            if DEBUG > 1 then
                printInfo("%s [eventable] dispatchEvent() - break dispatching for event %s", tostring(self.target_), eventName)
            end
            break
        end
    end

    return self.target_
end



---------------------------
--通过Tag编号移除监听
--@function [parent=#eventable] removeEventListenersByTag
--@param number#number tagToRemove 要移除的监听编号
--@return handle#handle 目标句柄
function eventable:removeEventListenersByTag(tagToRemove)
    for eventName, listenersForEvent in pairs(self.listeners_) do
        for handle, listener in pairs(listenersForEvent) do
            -- listener[1] = listener
            -- listener[2] = tag
            if listener[2] == tagToRemove then
                listenersForEvent[handle] = nil
                if DEBUG > 1 then
                    printInfo("%s [eventable] removeEventListener() - remove listener [%s] for event %s", tostring(self.target_), handle, eventName)
                end
            end
        end
    end

    return self.target_
end



---------------------------
--通过事件命名移除所有监听
--@function [parent=#eventable] removeEventListenersByEvent
--@param number#number eventName 要移除的监听命名
--@return handle#handle 目标句柄
function eventable:removeEventListenersByEvent(eventName)
    self.listeners_[string.upper(eventName)] = nil
    if DEBUG > 1 then
        printInfo("%s [eventable] removeAllEventListenersForEvent() - remove all listeners for event %s", tostring(self.target_), eventName)
    end
    return self.target_
end



---------------------------
--移除所有的监听器
--@function [parent=#eventable] removeAllEventListeners
--@param string#string eventName 要移除的监听命名
--@return handle#handle 目标句柄
function eventable:removeAllEventListeners()
    self.listeners_ = {}
    if DEBUG > 1 then
        printInfo("%s [eventable] removeAllEventListeners() - remove all listeners", tostring(self.target_))
    end
    return self.target_
end



---------------------------
--查询目标监听器是否存在
--@function [parent=#eventable] hasEventListener
--@param string#string eventName 要查询的监听命名
--@return boolean#boolean 是否存在
function eventable:hasEventListener(eventName)
    event.name = string.upper(tostring(eventName))
    local t = self.listeners_[eventName]
    for _, __ in pairs(t) do
        return true
    end
    return false
end

function eventable:dumpAllEventListeners()
    print("---- eventable:dumpAllEventListeners() ----")
    for name, listeners in pairs(self.listeners_) do
        printf("-- event: %s", name)
        for handle, listener in pairs(listeners) do
            printf("--     listener: %s, handle: %s", tostring(listener[1]), tostring(handle))
        end
    end
    return self.target_
end


return eventable
