local AnmHead = class("AnmHead",cc.load("mvc").ViewBase)
AnmHead.RESOURCE_FILENAME = "common/animal_head"

function AnmHead:onCreate()
    self:get():move(0,0)
    self:test()
end


--function AnmHead:onClick(path,node,funcName)
--    if funcName == "name" then
--        local function btnCallback(node,eventType)
--            print("name")
--        end
--        return btnCallback
--    else
--        local function btnCallback(node,eventType)
--            print("AnmHead:nnnnnnnnnnn")
--        end
--        return btnCallback
--    end
--end

function AnmHead:test()
    self.anmcomcsd:setSpriteFrame("anm-15.png")
    
    self.anmcomcsd:removeSelf()
    local clip = cc.ClippingNode:create()
    self.anmcomcsd:setPosition(display.width/2,display.height/2)
    clip:setInverted(false)
    self.anmcomcsd:addTo(clip)
    self.anmcomcsd:show()
    local drawNode = cc.DrawNode:create()
    local points = {}
    local rad = 150
    local angle = 2*math.pi/100
    local pcount = 100
    for i = 1,pcount do
        points[i] = cc.p(rad*math.cos(angle*i),rad*math.sin(angle*i))
    end
    drawNode:drawPolygon(points,pcount,cc.c4f(0,1,0,0),0,cc.c4f(0,1,0,0))
    clip:setStencil(drawNode)
    
    clip:setScale(1.6)
end

return AnmHead