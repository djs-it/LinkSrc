
---------------------------
--动作执行类
--
--@type Action
local Action = class("Action",require("fmw.network.Message").new())

function Action:ctor()
    self.super:ctor()
end

---------------------------
--动作执行接口
--@function [parent=#Action] action
--@param self
--@return Message#Message 返回消息
function Action:action()
	
end


---------------------------
--设置动作消息接口，由动作管理器植入
--@function [parent=#Action] setMessage
--@param self
--@param number#number index 绑定消息
--@param number#number msg 绑定消息
--@param mixed#mixed body 绑定消息
function Action:setMessage(aid, idx, msg, len, body)
    self.aid = aid
    self.idx = idx	
    self.msg = msg	
    self.len = len
    self.body = body	
end


return Action