local MainScene = class("MainScene",cc.load("mvc").ViewBase)

local LevelManager = import("app.data.LevelManager")

local MainRoom = import(".mainroom.MainRoom")
local GamingBg = import(".gaming.GamingBg")
local GamingCtrl = import("app.battle.controllers.LinkController")
local GamingOther = import(".gaming.GamingOther")

function MainScene:onCreate()
    self:initMainScene()
end

function MainScene:initMainScene()
    self.GamingBg = GamingBg:create(self:getApp(),LAYERS.gaming_bg)
        :addTo(self)
        :hide()
        
    self.GamingCtrl = GamingCtrl:create(self:getApp(),LAYERS.gaming_ctl)
        :addTo(self)
        :hide()
    
    self.MainRoom = MainRoom:create(self:getApp(),LAYERS.main_room)
        :addTo(self)
    
    self.GamingOther = GamingOther:create(self:getApp(),LAYERS.gaming_other)
        :addTo(self)
end

function MainScene:hideAllView()
    self.GamingBg:hide()
    self.GamingCtrl:hide()
    self.MainRoom:hide()
    self.GamingOther:hideAllView()
    
end
function MainScene:showMainRoom()
    self:hideAllView()
    self.MainRoom:show()
end

function MainScene:addGamingLevel(levelNum)
    self.MainRoom:hide()
    local data = LevelManager:getData(levelNum)
    self.GamingBg:show()
    AppViews:getView(LAYERS.gaming_bg_top):addGamingTimer(levelNum)
    self.GamingCtrl:show():initGame(data)
end

function MainScene:addGamingRand(randLevel)
    self.MainRoom:hide()
    local data = LevelManager:getRandGameData(randLevel)
    self.GamingBg:show()
    self.GamingCtrl:show():initGame(data)
end

function MainScene:showNextLevel()
    self:showMainRoom()
    
    self.GamingOther:showNextLevelBegin()
end

return MainScene