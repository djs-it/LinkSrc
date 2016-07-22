
---------------------------
-- 用来完成所有的网络通讯的模块
--
-- @type Network
Network = class("Network",require("eventable").new())

PACKAGE_HEAD_LEN = 10

NETWORK_STATUS_OFFLINE="NETWORK_STATUS_OFFLINE"
NETWORK_STATUS_ONLINE="NETWORK_STATUS_ONLINE"
NETWORK_STATUS_FAILED="NETWORK_STATUS_FAILED"
NETWORK_STATUS_ONDATA="NETWORK_STATUS_ONDATA"

function Network:ctor()
    self.socket = nil
    self.ip = nil
    self.port = nil
    self.status = NETWORK_STATUS_OFFLINE
    self.sessionId = 0
    self.leftpackage = ''  -- 剩余的黏包
    self.bapool = require("objectpool").new():createMore("ByteArray",20)
end


---------------------------
--连接服务器
--@function [parent=#Network] connect
--@param self
--@param string#string ip IP
--@param integer#integer port PORT
--@return Network#Network 自身句柄
function Network:connect(ip, port)

    self.ip = ip
    self.port = port

    local function onConnected(__event)
        printInfo("Network Online!")
        self.status = NETWORK_STATUS_ONLINE
        Network:dispatchEvent({name = NETWORK_STATUS_ONLINE, val = NETWORK_STATUS_ONLINE})
    end
    local function onConnectFail(__event)
        printInfo("Network Connected Failed!!!!")
        self.status = NETWORK_STATUS_FAILED
        Network:dispatchEvent({name = NETWORK_STATUS_FAILED, val = NETWORK_STATUS_FAILED})
    end
    local function onStatus(__event)
--        printInfo("socket status: %s", __event.name)
    end
    local function onClose(__event)
        printInfo("Network Offline!")
        self.status = NETWORK_STATUS_OFFLINE
        Network:dispatchEvent({name = NETWORK_STATUS_OFFLINE, val = NETWORK_STATUS_OFFLINE})
    end
    local function onData(__event)
        Network:dispatchEvent({name = NETWORK_STATUS_ONDATA, val = NETWORK_STATUS_ONDATA})
        local ba = self.bapool:getObject()
        local ba = require("ByteArray").new()
        
        if #self.leftpackage > 0 then
--            print("上次没有完成的数据包")
            ba:writeBuf(self.leftpackage)
        end
        ba:writeBuf(__event.data)
        ba:setPos(1)
        local lenBuf = ba:getLen()
        while true do
            if lenBuf == 0 then
                break
            end
            while true do
                -- 判断是否为1，则表明出现黏包,并且是极限情况的分隔符，导入leftpackage
                -- 因为外面还要进行一次判断，所有长度减为0
                if lenBuf == 1 then
                    self.leftpackage = 0xfe
                    lenBuf = 0
                    break
                end
            	local flag = ba:readByte()
                lenBuf = lenBuf - 1
--                printLog("DEBUG","flag: %d, num: %d",flag, lenBuf)
                if flag == 0xfe or lenBuf == 0 then
            	   break
            	end
            end
            
            if lenBuf == 0 then
                break
            elseif lenBuf < PACKAGE_HEAD_LEN then
                -- 判断是否小于PACKAGE_HEAD_LEN，保留剩下的字符到leftpackage
                self.leftpackage = ba:readStringBytes(lenBuf)
                break
            end
            local aid = ba:readShort()
            local idx = ba:readInt()
            local msg = ba:readShort()
            local len = ba:readShort()
            lenBuf = lenBuf - PACKAGE_HEAD_LEN
            local body = nil
            if len >= 0 then
                if len > lenBuf then
                    -- 判断是否小于还剩的缓存区，保留剩下的字符到leftpackage
                    self.leftpackage = ba:readStringBytes(lenBuf)
                    break
                end
                body = ba:readStringBytes(len)
                lenBuf = lenBuf - len
                
--                local _ba = require("ByteArray").new()
--                _ba:writeBuf(body)
--                _ba:setPos(1)
--                cclog("####" .. _ba:readInt())
                
                ActionManager:prepareAction(aid,idx,msg,len, body)
            end
--            printLog("DEBUG","aid: %d",aid)
        end
        
        self.bapool:recycle(ba)
    end 

    local SocketTCP = require("SocketTCP")
    self.socket = SocketTCP.new(ip, port , false)

    self.socket:addEventListener(SocketTCP.EVENT_CONNECTED, onConnected)
    self.socket:addEventListener(SocketTCP.EVENT_CLOSE, onClose)
    self.socket:addEventListener(SocketTCP.EVENT_CLOSED, onStatus)
    self.socket:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, onConnectFail)
    self.socket:addEventListener(SocketTCP.EVENT_DATA, onData)
    self.socket:connect()
    
    return self
end



---------------------------
--断开连接
--@function [parent=#Network] disconnect
--@param self
function Network:disconnect()
    if self.status == NETWORK_STATUS_ONLINE then
        self.socket:disconnect()
        self.status = NETWORK_STATUS_OFFLINE
    end
end



---------------------------
--发送消息
--@function [parent=#Network] write
--@param self
--@param Message#Message message 封装发送消息体
--@return Network#Network 自身句柄
function Network:write(message)
    if self.status == NETWORK_STATUS_ONLINE then
        local ba = self.bapool:getObject()
        ba:writeByte(0xfe)
          :writeShort(message.aid)
          :writeInt(message.idx)
          :writeShort(message.msg)
          :writeShort(message.len)
        if message.type == MSG_STRING then
          ba:writeStringBytes(message.body)
        elseif message.type == MSG_INT then
          ba:writeInt(message.body)
        elseif message.type == MSG_SHORT then
          ba:writeShort(message.body)
        elseif message.type == MSG_BYTE then
          ba:writeByte(message.body)
        elseif message.type == MSG_BYTE_ARRAY then
            ba:writeStringBytes(message.body)
        end
        self.socket:send(ba:getPack())
        self.bapool:recycle(ba)
    else
        printInfo("Network offline, can't write package!!!")
    end
end

return Network