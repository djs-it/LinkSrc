---------------------------
--网络通讯基本包
--
--@module Message
local Message = class("Message")

MSG_NONE = 0
MSG_INT = 2
MSG_SHORT = 3
MSG_BYTE = 4
MSG_STRING = 5
MSG_BYTE_ARRAY = 6

function Message:ctor()
    self.aid = 0
    self.idx = 0
    self.msg = 0
    self.len = 0
    self.body = ''
    self.type = MSG_NONE
end


---------------------------
--写入整形
--@function [parent=#Message] writeInt
--@param self
--@param number#number val Value
function Message:writeInt(val)
    self.len = 4
    self.type = MSG_INT
    self.body = val
end


---------------------------
--写入短型
--@function [parent=#Message] writeShort
--@param self
--@param number#number val Value
function Message:writeShort(val)
    self.len = 2
    self.type = MSG_SHORT
    self.body = val
end

---------------------------
--写入字节型
--@function [parent=#Message] writeByte
--@param self
--@param number#number val Value
function Message:writeByte(val)
    self.len = 1
    self.type = MSG_BYTE
    self.body = val
end


---------------------------
--写入 Table
--@function [parent=#Message] writeByte
--@param self
--@param table#table val Value
function Message:writeTable(table)
    local cmsgpack = require 'cmsgpack'
    self.type = MSG_BYTE_ARRAY
    self.body = cmsgpack.pack(table);
    self.len = string.len(self.body)
end

---------------------------
--写入字符串
--@function [parent=#Message] writeString
--@param writeString
--@param string#string val Value
function Message:writeString(val)
    self.type = MSG_STRING
    self.body = val
    self.len = string.len(val)
end


function Message:reset()
    self.aid = 0
    self.idx = 0
    self.msg = 0
    self.len = 0
    self.body = ''
    self.type = MSG_NONE
end

---------------------------
--读取body里面的短整形值
--@function [parent=#Message] readShort
--@param self
--@return number#number 短整形
function Message:readShort()
    local ba = require("fmw.network.ByteArray").new()
    ba:writeBuf(self.body)
    ba:setPos(1)
    return ba:readShort()
end



---------------------------
--读取body里面的整形值
--@function [parent=#Action] readInt
--@param self
--@return number#number 短整形
function Message:readInt()
    local ba = require("fmw.network.ByteArray").new()
    ba:writeBuf(self.body)
    ba:setPos(1)
    return ba:readInt()
end



---------------------------
--获取body的ByteArray句柄,可以流式读取多个数据项
--@function [parent=#Message] getByteArray
--@param self
--@return ByteArray#ByteArray body的ByteArray句柄
function Message:getByteArray()
    local ba = require("fmw.network.ByteArray").new()
    ba:writeBuf(self.body)
    ba:setPos(1)
    return ba
end

---------------------------
--写入 Table
--@function [parent=#Message] writeByte
--@param self
--@param table#table val Value
function Message:readTable()
    local cmsgpack = require 'cmsgpack'
    return cmsgpack.unpack(self.body)
end

return Message