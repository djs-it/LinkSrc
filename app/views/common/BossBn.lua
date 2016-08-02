local BossBn = class("BossBn",cc.load("mvc").ViewBase)
BossBn.RESOURCE_FILENAME = "common/boss_bn"

function BossBn:onCreate()
    self:get():move(0,0)
end

function BossBn:onClick(path,node,funcName)
    if funcName == "btnLevelNo" then
        local function btnCallback(node,eventType)
            print("btnLevelNo")
        end
        return btnCallback
    elseif funcName == "btnLevel" then
        local function btnCallback(node,eventType)
            print("btnLevel"..self.level)
            AppViews:getView(LAYERS.gaming_other):showLevelBegin(self.level)
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("BossBn:nnnnnnnnnn")
        end
        return btnCallback
    end
end

function BossBn:initView(levelNum,starNum,isCan)

    self.level = levelNum
    self.star = starNum

    self:setStar(starNum)

    self.levelNUM:setString(levelNum)

    if isCan then
        self.btnLevel:show()
        self.btnLevelNo:hide()
    else
        self.btnLevel:hide()
        self.btnLevelNo:show()
    end
end

function BossBn:setStar(starNum)
    for i = 1,3 do
        if i <= starNum then
            self["star_"..i]:show()
        else
            self["star_"..i]:hide()
        end
    end
end

function BossBn:setBtnShow(starNum)
    self.btnLevel:show()
    self.btnLevelNo:hide()
    self:setStar(starNum)
end

return BossBn