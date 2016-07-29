local AnmHead = class("AnmHead",cc.load("mvc").ViewBase)
AnmHead.RESOURCE_FILENAME = "common/animal_head"

function AnmHead:onCreate()
    self:get():move(0,0)
    self:initView()
end

function AnmHead:initView()
    self.anm = display.newSprite("#anm-13.png")
    self.clip = cc.ClippingNode:create()
    self.clip:setInverted(false)
    self.anm:addTo(self.clip)
    local drawNode = cc.DrawNode:create()
    local points = {}
    local rad = 106
    local angle = 2*math.pi/100
    local pcount = 100
    for i = 1,pcount do
        points[i] = cc.p(rad*math.cos(angle*i),rad*math.sin(angle*i))
    end
    drawNode:drawPolygon(points,pcount,cc.c4f(0,1,0,0),0,cc.c4f(0,1,0,0))
    self.clip:setStencil(drawNode)
    self.clip:addTo(self.comanmcsd)
end

function AnmHead:showView()
end

return AnmHead