local GamingOther = class("GamingOther",cc.load("mvc").ViewBase)


local SingleLevelBegin = import(".SingleLevelBegin")
local SingleRandBegin = import(".SingleRandBegin")
local GamingPause = import(".GamingPause")
local GamingLevelOver = import(".GamingLevelOver")
local GamingWall = import(".GamingWall")
local GamingBgBm = import(".GamingBgBm")
local GamingBgTop = import(".GamingBgTop")


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
        
    self.GamingWall = GamingWall:create(self:getApp(),LAYERS.gaming_wall)
        :addTo(self)
        :hideWall()
        
    self.GamingBgTop = GamingBgTop:create(self:getApp(),LAYERS.gaming_bg_top)
        :addTo(self)
        :move(display.width/2,display.height)
        :hide()

    self.GamingBgBm = GamingBgBm:create(self:getApp(),LAYERS.gaming_bg_bm)
        :addTo(self)
        :move(display.width/2,0)
        :hide()
        
    self.GamingPause = GamingPause:create(self:getApp(),LAYERS.gaming_pause)
        :addTo(self)
        :move(display.width/2,display.height/2)
        :hide()
        :hideView()
        
    self.GamingLevelOver = GamingLevelOver:create(self:getApp(),LAYERS.gaming_level_over)
        :addTo(self)
        :move(display.width/2,display.height/2)
        :hide()
    
end

function GamingOther:hideAllView()
    self.GamingBgBm:hide()
    self.GamingBgTop:hide()
    self.GamingPause:hideView()
    self.SingleRandBegin:hide()
    self.SingleLevelBegin:hide()
    self.GamingLevelOver:hide()
    AppViews:getView(LAYERS.main_room):hideAllView()
end

function GamingOther:showPause()
    self:hideAllView()
    self.GamingBgBm:show()
    self.GamingBgTop:show()
    
    self.GamingPause:showView()
end

function GamingOther:showLevelBegin(levelNum)
    self:hideAllView()
    
    self.levelNum = levelNum
    self.SingleLevelBegin:show():showView(self.levelNum)
    self.GamingBgTop:showView(self.levelNum)
end

function GamingOther:showRandBegin()
    self:hideAllView()
    
    self.SingleRandBegin:show():showView()
end

function GamingOther:showLevelOver(timeCount,starNum)
    self:hideAllView()
    
    self.GamingLevelOver:show():showView(self.levelNum,timeCount,starNum)
    
    LinkUtil:setLevelTimeByLevel(self.levelNum,timeCount)
    
    AppViews:getView(LAYERS.single_map):showNextBtn(self.levelNum,starNum)
end

function GamingOther:getLevelNum()
    return self.levelNum
end

function GamingOther:showNextLevelBegin()
    self.levelNum = self.levelNum + 1
    self.SingleLevelBegin:show():showView(self.levelNum)
end

function GamingOther:initGamingBg()
    self:hideAllView()
    self.GamingBgBm:show():showView()
    self.GamingBgTop:show()
end

function GamingOther:addSwim(timeNum)
    local pos = cc.p(display.width/2,display.height/2)

    self.swimLayer = display.newLayer(cc.c3b(0,0,0))
        :addTo(self)
        :setOpacity(50)
    self.bossSwim = display.newSprite("#stars.png")
        :addTo(self.swimLayer)
        :move(pos)
    self.bossSwim:move(pos)
    self.bossSwim:setScale(0.1)
    
    local function call()
        self.bossSwim:hide()
        self.bossSwim:removeSelf()
        self.swimLayer:hide()
        self.swimLayer:removeSelf()
        self.swimLayer = nil
        self.bossSwim = nil
    end
    ac.execute(self.bossSwim,ac.ccSeq(ac.ccScaleTo(0.1,1),ac.ccRotateTo(timeNum,180*timeNum,180*timeNum),ac.ccScaleTo(0.1,0.1),cc.CallFunc:create(call)))
end

return GamingOther