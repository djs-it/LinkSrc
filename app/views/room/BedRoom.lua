local BedRoom = class("BedRoom",cc.load("mvc").ViewBase)
BedRoom.RESOURCE_FILENAME = "room/bedroom"

function BedRoom:onCreate()
    self:get():move(0,0)
    self:initView()
end

function BedRoom:onClick(patn,node,funcName)
    if funcName == "btnCarpet" then
        local function btnCallback()
            print("btnCarpet")
            self:btnCarpetClick()
        end
        return btnCallback
    elseif funcName == "btnBed" then
        local function btnCallback()
            print("btnBed")
            self:btnBedClick()
        end
        return btnCallback
    elseif funcName == "btnWindow" then
        local function btnCallback()
            print("btnWindow")
            self:btnWindowClick()
        end
        return btnCallback
    elseif funcName == "btnDesk" then
        local function btnCallback()
            print("btnDesk")
            self:btnDeskClick()
        end
        return btnCallback
    elseif funcName == "btnBedMask" then
        local function btnCallback()
            print("btnBedMask")
            self:hideSign()
        end
        return btnCallback
    else
        local function btnCallback()
            print("BedRoom:nnnnnnnnn")
        end
        return btnCallback
    end
end

function BedRoom:initView()
    self.firstsigncsd:hide()
end

function BedRoom:hideSign()
    self.firstsigncsd:hide()
end

function BedRoom:showSign()
    self.firstsigncsd:show()
end

function BedRoom:btnCarpetClick()
    self:showSign()
end

function BedRoom:btnBedClick()
    self:showSign()
end

function BedRoom:btnWindowClick()
    self:showSign()
end

function BedRoom:btnDeskClick()
    self:showSign()
end

return BedRoom