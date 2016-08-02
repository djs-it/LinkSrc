local AnimalCell = class("AnimalCell",cc.load("mvc").ViewBase)
AnimalCell.RESOURCE_FILENAME = "bmanimal/animal_cell"

local AnmHead = import("..common.AnmHead")

function AnimalCell:onCreate()
    self:get():move(0,0)
end

function AnimalCell:onClick(path,node,funcName)
    if funcName == "btnAnmCell" then
        local function btnCallback(node,eventType)
            print("btnAnmCell")
            self:btnAnmCellClick()
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("btnAnmCell:nnnnnnnn")
        end
        return btnCallback
    end
end


---------------------------
--num 1 main 2 change
function AnimalCell:initView(anmId,isHave,isSelect,num)
    self.anmId = anmId
    local anmSp = display.newSprite(string.format("#anm-%s.png",anmId))
    anmSp:setScale(0.8)
    anmSp:move(0,-15)
    self.clip = cc.ClippingNode:create()
    self.clip:setInverted(false)
    anmSp:addTo(self.clip)
    local drawNode = cc.DrawNode:create()
    local points = {}
    local rad = 75
    local angle = 2*math.pi/100
    local pcount = 100
    for i=1,pcount do
        points[i] = cc.p(rad*math.cos(angle*i),rad*math.sin(angle*i))
    end
    drawNode:drawPolygon(points,pcount,cc.c4f(0,1,0,0),0,cc.c4f(0,1,0,0))
    self.clip:setStencil(drawNode)
    
    self.clip:addTo(self.animalcsd)

    self.isHave =isHave
    if isHave then
        self.nohavecsd:hide()
    else
        self.nohavecsd:show()
    end

    if isSelect then
        self.selectcsd:show()
    else
        self.selectcsd:hide()
    end

    self.belong = num
end

function AnimalCell:btnAnmCellClick()
    if self.belong == 1 then
        AppViews:getView(LAYERS.animal_main):showPropertyCsd(self.anmId)
    elseif self.belong == 2 then
        self:btnChangeCell()
    end
end

function AnimalCell:btnChangeCell()
    local select = AppViews:getView(LAYERS.animal_main):getChangeId()
    
    if select and select == self.anmId then
        return
    else
        AppViews:getView(LAYERS.animal_main):setChangeId(self.anmId)
    end
end

function AnimalCell:setSelect()
    self.selectcsd:show()
end

function AnimalCell:setNoSelect()
    self.selectcsd:hide()
end

return AnimalCell