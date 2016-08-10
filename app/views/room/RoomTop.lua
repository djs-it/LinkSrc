local RoomTop = class("RoomTop",cc.load("mvc").ViewBase)
RoomTop.RESOURCE_FILENAME = "room/room_top"

function RoomTop:onCreate()
    self:get():move(0,0)
end

function RoomTop:onClick(path,node,funcName)
    if funcName == "btnBack" then
        local function btnCallback()
            print("btnBack")
            AppViews:getView(LAYERS.main_room):setRoom()
        end
        return btnCallback
    elseif funcName == "btnCapture" then
        local function btnCallback()
            print("btnCapture")
        end
        return btnCallback
    elseif funcName == "btnSee" then
        local function btnCallback()
            print("btnSee")
        end
        return btnCallback
    else
        local function btnCallback()
            print("roomTop:nnnnnnnnnnnn")
        end
        return btnCallback
    end
end

return RoomTop