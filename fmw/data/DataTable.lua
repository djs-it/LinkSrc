
---------------------------
--数据基类
--
--@type DataTable
local DataTable = class("DataTable",require("eventable").new())

function DataTable:ctor()
    self.tableName = nil
    self.data = {}
end


---------------------------
--触发更新机制
--@function [parent=#DataTable] fireUpdate
--@param self
function DataTable:fireUpdate()
    self:dispatchEvent({name = string.upper(self.tableName), val = self.tableName})	
end



---------------------------
--获取数据表的table格式数据
--@function [parent=#DataTable] getData
--@param self
--@return table#table 数据表
function DataTable:getData()
	return self.data
end


---------------------------
--添加一个事件监听函数
--@function [parent=#DataTable] addDataListener
--@param self
--@param function#function listener 监听函数钩子
--@param tag#tag tag 标记名
--@return number#number 监听句柄
function DataTable:addDataListener(listener, tag)
    local eventName =  string.upper(self:getEventName())
    self:addEventListener(eventName, listener, tag)
end


---------------------------
--获取该表项的事件命名
--@function [parent=#DataTable] getEventName
--@return string#string 该数据表的事件命名
function DataTable:getEventName()
    return self.tableName
end

	
	
return DataTable