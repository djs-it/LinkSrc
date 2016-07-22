local MainRoom = class("MainRoom",cc.load("mvc").ViewBase)
MainRoom.RESOURCE_FILENAME = "mainroom/main_room"

local MainTop = import(".MainTop")
local MainBottom = import(".MainBottom")
local MainBmBtn = import(".MainBmBtn")

local SingleMap = import("..bmsingle.SingleMain")
local RoomMain = import("..bmroom.RoomMain")
local AnimalMain = import("..bmanimal.AnimalMain")

function MainRoom:onCreate()
    self:initView()
end

function MainRoom:onClick(path,node,funcName)
    if funcName == "btnWindow" then
        local function btnCallback(node,eventType)
            print("btnWindow")
        end
        return btnCallback
    elseif funcName == "btnHang" then
        local function btnCallback(node,eventType)
            print("btnHang")
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("nnnnnnnnnnnnn")
        end
        return btnCallback
    end
end


function MainRoom:initView()
    self.MainTop = MainTop:create(self:getApp(),LAYERS.main_top)
        :addTo(self)
        :move(display.width/2,display.height)
        
    self.MainBottom = MainBottom:create(self:getApp(),LAYERS.main_bottom)
        :addTo(self)
        :move(display.width/2,0)
        
    self.SingleView = SingleMap:create(self:getApp(),LAYERS.single_main)
        :addTo(self)
        :move(display.width/2,0)
        :hide()
        
    self.RoomMain = RoomMain:create(self:getApp(),LAYERS.room_main)
        :addTo(self)
        :move(display.width/2,0)
        :hide()

    self.AnimalMain = AnimalMain:create(self:getApp(),LAYERS.animal_main)
        :addTo(self)
        :move(display.width/2,0)
        :hide()

    self.MainBmBtn = MainBmBtn:create(self:getApp(),LAYERS.main_bm_btn)
        :addTo(self)
        :move(display.width/2,0)
        :hide()
   
end

function MainRoom:hideAllView()
    self.AnimalMain:hide()
    self.SingleView:hide()
    self.RoomMain:hide()
    self.MainBmBtn:hide()
end

--------------------------------------------------------
--<<<<<<<<<<<<底部按钮
--
function MainRoom:showSingle()
    self:hideAllView()
    
    self.MainBmBtn:show():showBtn(1)
    self.SingleView:show()
    
end

function MainRoom:showPK()
    self:hideAllView()
    
    self.MainBmBtn:show():showBtn(2)
end

function MainRoom:showAnimal()
    self:hideAllView()
    
    self.MainBmBtn:show():showBtn(3)
    self.AnimalMain:show()
end

function MainRoom:showRoom()
    self:hideAllView()
    
    self.RoomMain:show()
    self.MainBmBtn:show():showBtn(4)
end
-->>>>>>>>>>>>>>
------------------------------------------------------

return MainRoom