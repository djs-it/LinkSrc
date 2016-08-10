local Room1 = class("Room1",cc.load("mvc").ViewBase)
Room1.RESOURCE_FILENAME = "room/room_1"

function Room1:onCreate()
    self:get():move(0,0)
    self:initView()
    self:editRoom()
end

function Room1:onClick(path,node,funcName)
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
    elseif funcName == "btnRoomMask" then
        local function btnCallback()
            print("btnRoomMask11111")
            self:hideSign()
        end
        return btnCallback
    else
        local function btnCallback()
            print("Room1:nnnnnnnnnnnnnn")
        end
        return btnCallback
    end
end

function Room1:initView()
    self:hideSign()
end

function Room1:showView()
end

function Room1:editRoom()
    self.untouchcsd:hide()
end

function Room1:setRoom()
    self.untouchcsd:show()
end

function Room1:hideSign()
    self.firstsigncsd:hide()
end

function Room1:showSign()
    self.firstsigncsd:show()
end


return Room1