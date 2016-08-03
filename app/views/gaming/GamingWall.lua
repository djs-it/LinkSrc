local GamingWall = class("GamingWall",cc.load("mvc").ViewBase)

local WallVertical = import(".WallVertical")
local WallHorizontal = import(".WallHorizontal")


function GamingWall:onCreate()
    self:initView()
end

function GamingWall:initView()
    self.topWall = WallHorizontal:create(self:getApp(),"topWall")
        :addTo(self)
    self.bmWall = WallHorizontal:create(self:getApp(),"bmWall")
        :addTo(self)
    self.leftWall = WallVertical:create(self:getApp(),"leftWall")
        :addTo(self)
    self.rightWall = WallVertical:create(self:getApp(),"rightWall")
        :addTo(self)
end

function GamingWall:hideWall()
    self:hide()
    self.topWall:hide()
    self.bmWall:hide()
    self.leftWall:hide()
    self.rightWall:hide()
    return self
end

function GamingWall:setWallLeft(pos)
    self:show()
    self.leftWall:show()
    local np = cc.p(pos.x,pos.y+GRID_BORDER_HEIGHT)
    self.leftWall:move(np)
end

function GamingWall:setWallRight(pos)
    self:show()
    self.rightWall:show()
    local np = cc.p(pos.x,pos.y+GRID_BORDER_HEIGHT)
    self.rightWall:move(np)
end

function GamingWall:setWallTop(pos)
    self:show()
    self.topWall:show()
    local np = cc.p(pos.x-GRID_BORDER_WIDTH/2,pos.y)
    self.topWall:move(np)
end

function GamingWall:setWallBm(pos)
    self:show()
    self.bmWall:show()
    local np = cc.p(pos.x-GRID_BORDER_WIDTH/2,pos.y)
    self.bmWall:move(np)
end

return GamingWall