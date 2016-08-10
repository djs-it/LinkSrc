local RoomBm = class("RoomBm",cc.load("mvc").ViewBase)
RoomBm.RESOURCE_FILENAME = "room/room_bm"

local RoomBmCell = import(".RoomBmCell")

function RoomBm:onCreate()
    self:get():move(0,0)
end

function RoomBm:onClick(patn,node,funcName)
    if funcName == "name" then
        local function btnCallback()
            print("name")
        end
        return btnCallback
    else
        local function btnCallback()
            print("RoomBm:nnnnnnnnnn")
        end
        return btnCallback
    end
end

function RoomBm:initView()

end

function RoomBm:showView()

end

return RoomBm