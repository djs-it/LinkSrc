local Room = class("Room",cc.load("mvc").ViewBase)

local RoomBm = import(".RoomBm")
local RoomTop = import(".RoomTop")

local BedRoom = import(".BedRoom")
local Room1 = import(".Room1")

function Room:onCreate()
    self:initView()
end

function Room:initView()
    
    self.Room1 = Room1:create(self:getApp(),"Room1")
        :addTo(self)
        :move(display.width/2,display.height/2)
        
    self.RoomBm = RoomBm:create(self:getApp(),"RoomBm")
        :addTo(self)
        :move(display.width/2,0)
        :hide()
        
    self.RoomTop = RoomTop:create(self:getApp(),"RoomTop")
        :addTo(self)
        :move(display.width/2,display.height)
        
end

function Room:showBm()
--    self.RoomBm:show()
end

function Room:setRoom()
    self.Room1:setRoom()
end

function Room:editRoom()
    self.Room1:showView()
end

return Room