local MainScene = class("MainScene",cc.load("mvc").ViewBase)

local LevelManager = import("app.data.LevelManager")

local MainRoom = import(".mainroom.MainRoom")
local GamingBg = import(".gaming.GamingBg")
local GamingCtrl = import("app.battle.controllers.LinkController")
local GamingOther = import(".gaming.GamingOther")

function MainScene:onCreate()
    self:initData()
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
    self.GamingBg:show():showView()
    AppViews:getView(LAYERS.gaming_bg_top):addGamingTimer(levelNum)
    self.GamingCtrl:show():initGame(data)
end

function MainScene:addGamingRand(randLevel)
    self.MainRoom:hide()
    local data = LevelManager:getRandGameData(randLevel)
    self.GamingBg:show():showView()
    self.GamingCtrl:show():initGame(data)
end

function MainScene:showNextLevel()
    self:showMainRoom()

    self.GamingOther:showNextLevelBegin()
end

function MainScene:initData()
    local stageAnm = {}
    stageAnm[1] = 0
    stageAnm[2] = 20
    helper.saveSloterData(SLOTER.animal_stage,stageAnm)

    local anmdata = {}
    for i=1,20 do
        table.insert(anmdata,i)
    end
    helper.saveSloterData(SLOTER.animal_have,anmdata)

    if not LinkUtil:getGem() then
        local gem = 100
        helper.saveSloterData(SLOTER.user_gem,gem)
    end

    if not LinkUtil:getGold() then
        local gold = 300
        helper.saveSloterData(SLOTER.user_gold,gold)
    end

    if not LinkUtil:getLevelTime() then
        local data = {}
        for index = 1,50 do
            table.insert(data,3666)
        end
        LinkUtil:setLevelTime(data)
        LinkUtil:setLevelNow(1)
    end

end

return MainScene