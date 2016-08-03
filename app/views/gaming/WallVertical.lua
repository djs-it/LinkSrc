local WallVertical = class("WallVertical",cc.load("mvc").ViewBase)
WallVertical.RESOURCE_FILENAME = "gaming/wall_vertical"

function WallVertical:onCreate()
    self:get():move(0,0)
end

return WallVertical