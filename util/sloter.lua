
---------------------------
--游戏存储工具
--
--@module sloter
local sloter = class("sloter")

function sloter:ctor()
    self.slots_ = {}
    self.current = 1
    self:setCurrent(self.current)
end


---------------------------
--设置当前操作slot
--@function [parent=#sloter] setCurrent
--@param self
--@param node#node node 执行动画的节点
--@return #sloter 自身句柄
function sloter:setCurrent(current)
    self.current = current
    self.slots_ = self:load()
    return self
end


---------------------------
--获取当前的Slot值
--@function [parent=#sloter] value
--@param self
--@return #table 存档内容
function sloter:value()
    return self.slots_
end


---------------------------
--替换当前的Slot值
--@function [parent=#sloter] setValue
--@param self
--@param table#table values 保存的表
function sloter:setValue(values)
    self.slots_ = values
end


---------------------------
--设置当前的Slot的存储项
--@function [parent=#sloter] setValueItem
--@param self
--@return #string 存档内容
function sloter:setValueItem(key,value)
    self.slots_[key] = value
end


---------------------------
--获取当前的Slot的存储项目的值
--@function [parent=#sloter] getValueItem
--@param self
--@param string#string value 条目的值
function sloter:getValueItem(key)
    return  self.slots_[key]
end


---------------------------
--检查是否存在存盘文件，检查结果是否有文件，MacOS会自动创建目录结构
--@function [parent=#sloter] existSlot
--@param self
--@return #boolean 存在为真
function sloter:existSlot()
    local path = string.gsub(device.writablePath, "[\\\\/]+$", "") .. device.directorySeparator
    local slotFile = "gameslot" .. self.current .. ".dat"
    if device.platform == device.PLATFORM.MACOS then
        slotFile = "RuntimeSlots/" .. DNP_APP.appName .. "/" .. slotFile
    end
    if not io.open(path .. slotFile,"r") then
        if device.platform == device.PLATFORM.MACOS then
            if not io.open(path .. "RuntimeSlots/" .. DNP_APP.appName,"r") then
                os.execute("mkdir " .. path .. "RuntimeSlots/")
                os.execute("mkdir " .. path .. "RuntimeSlots/" .. DNP_APP.appName)
            end
        end
        return false
    else
        return true
    end
end


---------------------------
--获取当前存盘文件名
--@function [parent=#sloter] getSlotFile
--@param self
--@param table#table table 保存的表
--@return #string 存盘文件名
function sloter:getSlotFile()
    local slotFile = "gameslot" .. self.current .. ".dat"
    if device.platform == device.PLATFORM.MACOS then
        slotFile = "RuntimeSlots/" .. DNP_APP.appName .. "/" .. slotFile
    end
    return string.gsub(device.writablePath, "[\\\\/]+$", "") .. device.directorySeparator .. slotFile 
end


---------------------------
--加密文件获取
--@function [parent=#sloter] getEncryptContent
--@param self
--@param table#table values 保存的表
--@return #string 内容
function sloter:encryptContent(values)
    local s = json.encode(values)
    local hash = crypto.md5(s)
    local contents = json.encode({h = hash, s = s})
    return crypto.encryptXXTEA(contents, DNP_APP.slotKey .. device:getDeviceUid())
end


---------------------------
--加密文件获取
--@function [parent=#sloter] getEncryptContent
--@param self
--@param string#string content 保存的表
--@return #string 内容
function sloter:decryptContent(content)
    local t = crypto.decryptXXTEA(content, DNP_APP.slotKey .. device:getDeviceUid())
    if (t == nil) then
        return {}
    end
    local c = json.decode(t)
    local hash = crypto.md5(c.s)
    if (c.h ~= hash) then
        return {}
    end
    return json.decode(c.s)
end



---------------------------
--保存游戏结构到存盘文件
--@function [parent=#sloter] save
--@param self
--@return #booleam 保存成功
function sloter:save()
    self:existSlot()
    local result = io.writefile(self:getSlotFile(), self:encryptContent(self.slots_))
    return result
end


---------------------------
--读取游戏结构到数据表 
--@function [parent=#sloter] load
--@param self
--@return #table 存档table 
function sloter:load()
    return self:decryptContent(io.readfile(self:getSlotFile()))
end


return sloter
