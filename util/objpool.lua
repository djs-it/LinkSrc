
---------------------------
--对象管理池类
--
--@module objpool
local objpool = class("objpool")


function objpool:ctor()
    self.className = ''
    self.freeObjects = {}
    self.allObjects = {}
    self.numFreeObjects = 0
end


---------------------------
--创建一个给定规格的对象池
--@function [parent=#objectpool] createMore
--@param self
--@param string#string className 类名称
--@param number#number more 初始对象数量
--@return objectpool#objectpool 对象池句柄
function objpool:createMore(className, more)
    self.className = className
    for var=self.numFreeObjects+1, more  do
        local object = require(className):create()
--        local object = require(className):new()
        table.insert(self.freeObjects,object)
        table.insert(self.allObjects,object)
    end
    self.numFreeObjects = self.numFreeObjects + more
    return self
end


---------------------------
--获取池对象
--@function [parent=#objectpool] getObject
--@param self
--@return table#table 池对象
function objpool:getObject()
	if self.numFreeObjects == 0 then
        return require(self.className):new()
	else
	   self.numFreeObjects = self.numFreeObjects - 1
--        return table.remove(self.freeObjects)
        return table.remove(self.freeObjects,1)
	end
end

----------------------------
--获取池中所有对象
--
--@function [parent=#objectpool] getAllObjects
--@param self
--@return #table#table  整个池
function objpool:getAllObjects()
    return self.allObjects
end


---------------------------
--归还池对象
--@function [parent=#objectpool] recycle
--@param self
--@param object#object obj 归还对象
function objpool:recycle(obj)
    self.numFreeObjects = self.numFreeObjects + 1
    obj:reset()
    table.insert(self.freeObjects,obj)
end



return objpool