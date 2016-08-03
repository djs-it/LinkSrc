local WallHorizontal = class("WallHorizontal",cc.load("mvc").ViewBase)
WallHorizontal.RESOURCE_FILENAME = "gaming/wall_horizontal"

function WallHorizontal:onCreate()
    self:get():move(0,0)
end

return WallHorizontal