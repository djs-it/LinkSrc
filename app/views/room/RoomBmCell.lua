local RoomBmCell = class("RoomBmCell",cc.load("mvc").ViewBase)
RoomBmCell.RESOURCE_FILENAME = "room/roombm_cell"

function RoomBmCell:onCreate()
    self:get():move(0,0)
end

function RoomBmCell:onClick(path,node,funcName)
    if funcName == "name" then
        local function btnCallback()
            print("name")
        end
        return btnCallback
    else
        local function btnCallback()
            print("RoomBmCell")
        end
        return btnCallbakc
    end
end

return RoomBmCell