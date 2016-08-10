local Room = class("Room",cc.load("mvc").ViewBase)

local BedRoom = import(".BedRoom")
local Room1 = import(".Room1")

function Room:onCreate()
    self:initView()
end

function Room:initView()
    self.Room1 = Room1:create(self:getApp(),"Room1")
        :addTo(self)
--    self.BedRoom = BedRoom:create(self:getApp(),"bedRoom")
--        :addTo(self)
        
end

return Room