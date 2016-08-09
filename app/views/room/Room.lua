local Room = class("Room",cc.load("mvc").ViewBase)

local BedRoom = import(".BedRoom")

function Room:onCreate()
    self:initView()
end

function Room:initView()
    self.BedRoom = BedRoom:create(self:getApp(),"bedRoom")
        :addTo(self)
        
end

return Room