local LevelBn = class("LevelBn",cc.load("mvc").ViewBase)
LevelBn.RESOURCE_FILENAME = "common/level_bn"

function LevelBn:onCreate()
    self:get():move(0,0)
end

function LevelBn:onClick(path,node,funcName)
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
            print("LevelBn:nnnnnnnnnn")
        end
        return btnCallback
    end
end

function LevelBn:initView(levelNum,starNum,isCan)
    
    self.level = levelNum
    self.star = starNum
    
    self:setStar(starNum)
    
    self.levelNUM:setString(levelNum)
    
    if isCan then
        self.btnLevel:show()
        self.btnLevelNo:hide()
        self.levelNUM:setTextColor({r = 255, g = 255, b = 255})
    else
        self.btnLevel:hide()
        self.btnLevelNo:show()
        self.levelNUM:setTextColor({r = 103, g = 65, b = 78})
    end
end

function LevelBn:setStar(starNum)
    for i = 1,3 do
        if i <= starNum then
            self["star_"..i]:show()
        else
            self["star_"..i]:hide()
        end
    end
end

function LevelBn:setBtnShow(starNum)
    self.btnLevel:show()
    self.btnLevelNo:hide()
    self:setStar(starNum)
end

return LevelBn