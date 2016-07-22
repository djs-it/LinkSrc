local AnimalCell = class("AnimalCell",cc.load("mvc").ViewBase)
AnimalCell.RESOURCE_FILENAME = "bmanimal/animal_cell"

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
    anmSp:addTo(self.animalcsd)

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
        AppViews:getView(LAYERS.animal_main):showPropertyCsd()
    elseif self.belong == 2 then
        self:btnChangeCell()
    end
end

function AnimalCell:btnChangeCell()
    local select = AppViews:getView(LAYERS.animal_main):getChangeId()
    
    if select == self.anmId then
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