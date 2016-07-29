local GamingWall = class("GamingWall",cc.load("mvc").ViewBase)
GamingWall.RESOURCE_FILENAME = "gaming/gaming_wall"

function GamingWall:onCreate()
    self:get():move(0,0)
end

function GamingWall:onClick(path,node,funcName)
    if funcName == "name" then
        local function btnCallback(node,eventType)
            print("name")
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("GamingWall:nnnnnnnnn")
        end
        return btnCallback
    end
end

function GamingWall:hideWall()
    self:hide()
    self.walltop:hide()
    self.wallbottom:hide()
    self.wallright:hide()
    self.wallleft:hide()
    return self
end

function GamingWall:setWallLeft(pos)
    self:show()
    self.wallleft:show()
    local np = cc.p(pos.x,pos.y)
    self.wallleft:setPosition(np)
end

function GamingWall:setWallRight(pos)
    self:show()
    self.wallright:show()
    local np = cc.p(pos.x,pos.y)
    self.wallright:setPosition(np)
end

function GamingWall:setWallTop(pos)
    self:show()
    self.walltop:show()
    local np = cc.p(pos.x,pos.y)
    self.walltop:setPosition(np)
end

function GamingWall:setWallBm(pos)
    self:show()
    self.wallbottom:show()
    local np = cc.p(pos.x,pos.y)
    self.wallbottom:setPosition(np)
end

return GamingWall