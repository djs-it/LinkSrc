local BedRoom = class("BedRoom",cc.load("mvc").ViewBase)
BedRoom.RESOURCE_FILENAME = "room/bedroom"

function BedRoom:onCreate()
    self:get():move(0,0)
    self:initView()
end

function BedRoom:onClick(path,node,funcName)
    if string.find(funcName,"btnSign") then
        local function btnCallback()
            print(funcName)
        end
        return btnCallback
    elseif string.find(funcName,"btnPos") then
        local function btnCallback()
            print(funcName)
            self:showSign()
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

function BedRoom:btnSign101Click()
    self:showSign()
end

function BedRoom:btnSign102Click()
    self:showSign()
end

function BedRoom:btnSign103Click()
    self:showSign()
end

function BedRoom:btnSign1Click()
    self:showSign()
end

function BedRoom:btnSign2Click()
    self:showSign()
end

function BedRoom:btnSign3Click()
    self:showSign()
end

function BedRoom:btnSign4Click()
    self:showSign()
end

function BedRoom:btnPos1Click()
    self:showSign()
end

function BedRoom:btnPos2Click()
    self:showSign()
end

function BedRoom:btnPos3Click()
    self:showSign()
end

function BedRoom:btnPos4Click()
    self:showSign()
end

return BedRoom