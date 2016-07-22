local GamingOther = class("GamingOther",cc.load("mvc").ViewBase)


local SingleLevelBegin = import(".SingleLevelBegin")
local SingleRandBegin = import(".SingleRandBegin")
local GamingPause = import(".GamingPause")
local GamingLevelOver = import(".GamingLevelOver")

function GamingOther:onCreate()
    self:initView()
    self.levelNum = nil
end

function GamingOther:initView()
        
    self.SingleLevelBegin = SingleLevelBegin:create(self:getApp(),LAYERS.single_level_begin)
        :addTo(self)
        :move(display.width/2,display.height/2)
        :hide()
        
    self.SingleRandBegin = SingleRandBegin:create(self:getApp(),LAYERS.single_rand_begin)
        :addTo(self)
        :move(display.width/2,display.height/2)
        :hide()
        
    self.GamingPause = GamingPause:create(self:getApp(),LAYERS.gaming_pause)
        :addTo(self)
        :move(display.width/2,display.height/2)
        :hide()
        
    self.GamingLevelOver = GamingLevelOver:create(self:getApp(),LAYERS.gaming_level_over)
        :addTo(self)
        :move(display.width/2,display.height/2)
        :hide()
end

function GamingOther:hideAllView()
    self.GamingPause:hideView()
    self.SingleRandBegin:hide()
    self.SingleLevelBegin:hide()
    self.GamingLevelOver:hide()
    AppViews:getView(LAYERS.main_room):hideAllView()
end

function GamingOther:showPause()
    self:hideAllView()
    
    self.GamingPause:showView()
end

function GamingOther:showLevelBegin(levelNum)
    self:hideAllView()
    
    self.levelNum = levelNum
    self.SingleLevelBegin:show():showView(self.levelNum)
end

function GamingOther:showRandBegin()
    self:hideAllView()
    
    self.SingleRandBegin:show()
end

function GamingOther:showLevelOver(useTime,starNum)
    self:hideAllView()
    
    self.GamingLevelOver:show():showView(self.levelNum,useTime,starNum)
end

function GamingOther:getLevelNum()
    return self.levelNum
end

function GamingOther:showNextLevelBegin()
    self.levelNum = self.levelNum + 1
    self.SingleLevelBegin:show():showView(self.levelNum)
end


return GamingOther