
---------------------------
--动作管理器，属于全局对象句柄
--
--@type ActionManager
local actmanager = class("actmanager")

function actmanager:ctor()
    self.actions   = {}
    self.callbacks = {}
end


---------------------------
--从网络过来的动作包，执行动作的初始化
--@function [parent=#ActionManager] prepareAction
--@param self
--@param number#number aid ActionId
--@param number#number idx Index
--@param number#number msg MessageId
--@param string#string aid Body
function actmanager:prepareAction(aid, idx, msg, len, body)
    local action = self:getAction(aid)
    action:setMessage(aid, idx, msg, len, body)
    local message = action:action()
    if nil ~= message then
        Network:write(message)
    end
end



---------------------------
--通过动作Id直接执行动作脚本
--@function [parent=#ActionManager] excuteAction
--@param self
--@param integer#integer aid 动作编码
function actmanager:excuteAction(aid,content,callback,nomask)
    self.callbacks[aid] = nil

    local message = self:getAction(aid)
    message.aid = aid
    if type(content) == "table" then
        message:writeTable(content)
    elseif type(content) == "string" then
        message:writeString(content)
    elseif type(content) == "number" then
        message:writeInt(content)
    end
    
    if message then
        if callback then
            self.callbacks[aid] = callback
        end
        Network:write(message)
    end
end


---------------------------
--直接执行回调函数
--@function [parent=#ActionManager] excuteCallBack
--@param self
function actmanager:excuteCallBack(action,result)
    if self.callbacks[action.aid] then
        self.callbacks[action.aid](result)
    end
end




return actmanager