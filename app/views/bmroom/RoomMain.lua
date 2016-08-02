local RoomMain = class("RoomMain",cc.load("mvc").ViewBase)
RoomMain.RESOURCE_FILENAME = "bmroom/room_main"

function RoomMain:onCreate()
    self:get():move(0,0)
    self:initView()
end

function RoomMain:onClick(path,node,funcName)
    if funcName == "btnFloorOne" then
        local function btnCallback(node,eventType)
            print("btnFloorOne")
            self:btnFloorClick(1)
        end
        return btnCallback
    elseif funcName == "btnFloorTwo" then
        local function btnCallback(node,eventType)
            print("btnFloorTwo")
            self:btnFloorClick(2)
        end
        return btnCallback
    elseif funcName == "btnClose" then
        local function btnCallback(node,eventType)
            print("btnClose")
            self:hideView()
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("RoomMain:nnnnnnnnnnnnn")
        end
        return btnCallback
    end
end

function RoomMain:hideView()
    AppViews:getView(LAYERS.main_room):hideAllView()
    
end

function RoomMain:initView()
    self.roomtile:setString("别墅一层")
    self.btnFloorOne:show()
    self.btnFloorTwo:hide()

    self.floorone:show()
    self.floortwo:hide()
end

function RoomMain:btnFloorClick(num)
    if num == 1 then
        self.roomtile:setString("别墅二层")
        self.btnFloorOne:hide()
        self.btnFloorTwo:show()

        self.floorone:hide()
        self.floortwo:show()
    elseif num == 2 then
        self.roomtile:setString("别墅一层")
        self.btnFloorOne:show()
        self.btnFloorTwo:hide()

        self.floorone:show()
        self.floortwo:hide()
    end
end

return RoomMain