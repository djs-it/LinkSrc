
---------------------------
--Tag编号生成器,用来给所有用户显示面板来自动生成Tag
--
--@module tagen
local tagen = class("tagen")

function tagen:ctor()
    self.counter = 100000
end



---------------------------
--获取一个最新的Tag
--@function [parent=#tagen] get
--@param self
--@return number#number Tag新值
function tagen:get()
    self.counter = self.counter + 1
    return self.counter
end
	
return tagen