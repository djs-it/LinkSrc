local LinkController = class("LinkController",cc.load("mvc").ViewBase)


local LinkModel = import("..models.LinkModel")
local LinkView = import("..views.LinkView")


function LinkController:onCreate()
    self.isCanBmClear = false
end


----------------------
--根据数据初始化游戏界面
--
--data is table
--data.base  data.magic data.effect
--@function [parent=#src.app.battle.controllers.LinkController] initGame
function LinkController:initGame(data,isLevel)
    self.anmStage = LinkUtil:getStageAnimal()

    if isLevel then
        self.level = AppViews:getView(LAYERS.gaming_other):getLevelNum()
    end
    self.delNum = 0

    self.isCanBmClear = false

    self.model = LinkModel:create():onCreate()
    local gameData = self.model:initModel(data)
    self.view = LinkView:create(self:getApp(),LAYERS.game_view)
        :addTo(self)
        :initView(gameData)

    self:enTouch()

    self:addCloudListen()
end


-----------------------
--
--游戏控制逻辑
--
--@function [parent=#src.app.battle.controllers.LinkController] touch
function LinkController:touch(event)
    if event.name == "began" then
        print("----began")
        local beganPosition = self:getPointByPosition(event.x,event.y)
        if beganPosition then
            --            dump(beganPosition)
            if self.isCanBmClear then
                self:setBmBtnClear(false)
                local clearPoint = self.model:dealBmBtnClear(beganPosition)
                self:dealBmBtnClear(clearPoint)
            else
                local lastPoint,newPoint,clearPoint,linePoint,clearGem,clearKey,iceMsg= self.model:dealTouchPoint(beganPosition)
                self:dealGame(lastPoint,newPoint,clearPoint,linePoint,clearGem,clearKey,iceMsg)
            end
        else
            self:setBmBtnClear(false)
        end
        return true
    elseif event.name == "moved" then
    elseif event.name == "ended" then
    end

end

function LinkController:doClearByPoint(clearPoint)
    if LinkUtil:isTrue(clearPoint) then
        local isRunWay,wayTable = self.model:clearBaseByPoint(clearPoint)
        self.view:clearBaseByTable(clearPoint,isRunWay,wayTable)
        self.delNum = self.delNum +2
        print("self.delNum === doClearByPoint==="..self.delNum)
        self:checkBoss()
    end
end


-----------------------------------------
--处理游戏逻辑
--
function LinkController:dealGame(lastPoint,newPoint,clearPoint,linePoint,clearGem,clearKey,iceMsg)
    if LinkUtil:isTrue(iceMsg) then
        self.model:doIceMsg(iceMsg)
        self.view:doIceMsg(iceMsg)
        return
    end
    
    self.view:checkTurn(newPoint)

    if LinkUtil:isTrue(linePoint) then
        local pt = self.model:getAllPointByTips(linePoint)
    end

    self.view:hideTipsDemo()
    self:hideAllViewDemo()

    self.view:setSelectByPoint(lastPoint,newPoint)

    local mark,pointLast,pointNew = self.model:dealTurning(lastPoint,newPoint)
    self.view:dealTurning(mark,pointLast,pointNew)

    self:doClearByPoint(clearPoint)

    local iceTable = self.model:dealIceByTable(clearPoint)
    if iceTable and #iceTable~= 0 then
        self.view:cleanIceByTable(iceTable)
    end

    if clearGem and #clearGem ~= 0 then
        self.model:clearBaseByPoint(clearGem)
        self.view:clearBaseByTable(clearGem)
    end

    if clearKey and #clearKey ~= 0 then
        self.model:clearEffectByPoint(clearKey)
        self.view:clearEffectByTable(clearKey)
    end


    if self.model:isFinishGame() then
        self:showLevelOver()
        return
    end

    self:checkAnmByClear(clearPoint)

    local tipsTable = self.model:getLineTwoPoint()
    if not LinkUtil:isTrue(tipsTable) then
        local dataing,resultdata = self.model:dealGameDataIng()
        self.view:realignGameIng(dataing,resultdata)
    end

end


function LinkController:dealBmBtnClear(clearPoint)
    if LinkUtil:isTrue(clearPoint) then

        self:doClearByPoint(clearPoint)

        local iceTable = self.model:dealIceByTable(clearPoint)
        if iceTable and #iceTable~= 0 then
            self.view:cleanIceByTable(iceTable)
        end

        if self.model:isFinishGame() then
            self:showLevelOver()
            return
        end

        local tipsTable = self.model:getLineTwoPoint()
        if not LinkUtil:isTrue(tipsTable) then
            local dataing,resultdata = self.model:dealGameDataIng()
            self.view:realignGameIng(dataing,resultdata)
        end
    end
end

------------------------------------
-- 添加乌云监听
--
function LinkController:addCloudListen()
    local isDoCloud = self.model:getShowCloud()
    if isDoCloud then
        local function call()
            local isDoCloud, isShowCloud,cloudPoint= self.model:getShowCloud()
            if isDoCloud then
                self.view:runCloud(isShowCloud,cloudPoint)
                local data = self.model:getCloudsTable()
--            else
--                self:removeTimer(TIME_CLOUD_NAME)
            end
        end
        self:addTimer(TIME_CLOUD_NAME,TIME_CLOUD_NUM,190000,call)
        self.cloudTimer =  self.timers[TIME_CLOUD_NAME]
    end
end


---------------------------------
--根据坐标位置获取点
--
function LinkController:getPointByPosition(x,y)
    local ix,iy = x,y
    if not y then
        ix,iy = x.x,x.y
    end

    local nx = math.floor((ix - self.view.offsetX + GRID_BORDER_WIDTH / 2)/GRID_BORDER_WIDTH)
    local ny = math.floor((iy - self.view.offsetY + GRID_BORDER_HEIGHT / 2)/GRID_BORDER_HEIGHT)

    if nx >= 0 and ny >= 0 and nx < GRID_WIDTH and ny < GRID_HEIGHT then
        return cc.p(nx,ny)
    end
end

function LinkController:setBmBtnClear(sign)
    if sign then
        self:hideAllViewDemo()
    end
    self.isCanBmClear = sign
    AppViews:getView(LAYERS.gaming_bg_bm):setBmBtnClear(sign)
end

function LinkController:hideAllViewDemo()
    local basePoint = self.model:getGamingBaseData(true)
    self.view:hideAllDemo(basePoint)
end

function LinkController:showTips()
    if self.model.selectPoint then
        self.view:setUnSelectByPoint(self.model.selectPoint)
        self.model.selectPoint = nil
    end
    local tipsTable = self.model:getLineTwoPoint()
    self.view:showTipsByTable(tipsTable)
end

function LinkController:showRand()
    local dataing,resultdata = self.model:dealGameDataIng()
    self.view:realignGameIng(dataing,resultdata)
end

function LinkController:showPause()
    local pauseData = self.model:getPauseData()
    self.view:showPauseByPoint(pauseData)
end

function LinkController:hidePause()
    local pauseData = self.model:getPauseData()
    self.view:hidePauseByPoint(pauseData)
end

function LinkController:showLevelOver()

    self:closeCtl()
    local starNum,timeCount = AppViews:getView(LAYERS.gaming_bg_top):deleGamingTimer()
    AppViews:getView(LAYERS.gaming_other):showLevelOver(timeCount,starNum)
end

function LinkController:closeCtl()
    AppViews:getView(LAYERS.gaming_wall):hideWall()
    if self.cloudTimer then
        self:removeTimer(TIME_CLOUD_NAME)
    end
    self.level = nil
    self.view:clearView()
    self.view = nil
    self.model:clearModel()
    self.model = nil
end

---------------------------------
--处理animal根据消除点
--1  7  8  13  18  20  21
--
function LinkController:checkAnmByClear(clearPoint)
    if not LinkUtil:isTrue(clearPoint) then
        return
    end

    local baseData = self.model:getGamingBaseData(false)
    if #baseData <5 then
        return
    end


    if self:_isOnStageById(0) then
        return
    end
    --每次消除有几率把一对变金币
    if self:_isOnStageById(1) then
        if LinkUtil:isDoAnmByNum(50) then
            local result = self.model:getAnm1()
            self.view:doAnm1(result)
        end
    end
    --每次消除有几率提示
    if self:_isOnStageById(7) then
        if LinkUtil:isDoAnmByNum(50) then
            self:showTips()
        end
    end
    --每次消除有几率显示可消块所在区
    if self:_isOnStageById(8) then
        if LinkUtil:isDoAnmByNum(50) then

        end
    end
    --每次消除有几率自动消除一对
    if self:_isOnStageById(13) then
        if LinkUtil:isDoAnmByNum(50) then
            local result = self.model:getAnm13()
            if result then
                self:doClearByPoint(result)
            end
        end
    end
    --每次消除有几率消除一个障碍类技能(石块,冰冻，冰块)
    if self:_isOnStageById(18) then
        if LinkUtil:isDoAnmByNum(50) then
            local pt,sign = self.model:getAnm18()
            if sign then
                self.view:doAnm18(pt,sign)
            end
        end
    end
    --每次消除有几率消除一个记忆类技能(问号,乌云)
    if self:_isOnStageById(20) then
        if LinkUtil:isDoAnmByNum(50) then
            local pt = self.model:getAnm20()
            if pt then
                self.view:doAnm20(pt)
            end
        end
    end
    --有一定几率抵抗黑白，云，眩晕和西红柿
    if self:_isOnStageById(21) then
        if LinkUtil:isDoAnmByNum(50) then

        end
    end
end

function LinkController:_isOnStageById(id)
    if self.anmStage[1] == id or self.anmStage[2] == id then
        return true
    else
        return false
    end
end

-------------------------------------------------
--检测boss关卡
--
function LinkController:checkBoss()
    if self.level then
        if self.level%5 == 0 then
            local bossId = self.level/5
            if bossId == 1 then
                if self.delNum == LEVEL_BOSS[1].T[1] then
                    local point,base = self.model:getBoss1(LEVEL_BOSS[1].N[1])
                    self.view:doBoss1(point,base)
                elseif self.delNum == LEVEL_BOSS[1].T[2] then
                    local point,base = self.model:getBoss1(LEVEL_BOSS[1].N[2])
                    self.view:doBoss1(point,base)
                end
            elseif bossId == 2 then
                if self.delNum == LEVEL_BOSS[2].T[1] then
                    local result = self.model:getBoss2(LEVEL_BOSS[2].N[1])
                    self.view:doBoss2(result)
                elseif self.delNum == LEVEL_BOSS[2].T[2] then
                    local result = self.model:getBoss2(LEVEL_BOSS[2].N[2])
                    self.view:doBoss2(result)
                end
            elseif bossId == 3 then
            elseif bossId == 4 then
                if self.delNum == LEVEL_BOSS[4].T[1] then
                    local result = self.model:getBoss4(LEVEL_BOSS[4].N[1])
                    self.view:doBoss4(result)
                elseif self.delNum == LEVEL_BOSS[4].T[2] then
                    local result = self.model:getBoss4(LEVEL_BOSS[4].N[2])
                    self.view:doBoss4(result)
                end 
            elseif bossId == 5 then
                if self.delNum == LEVEL_BOSS[5].T[1] then
                    local result = self.model:getBoss5(LEVEL_BOSS[5].N[1])
                    self.view:doBoss5(result)
                elseif self.delNum == LEVEL_BOSS[5].T[2] then
                    local result = self.model:getBoss5(LEVEL_BOSS[5].N[2])
                    self.view:doBoss5(result)
                end
            elseif bossId == 6 then
            elseif bossId == 7 then
            elseif bossId == 8 then
                if self.delNum == LEVEL_BOSS[8].T[1] then
                    local result = self.model:getBoss8(LEVEL_BOSS[8].N[1])
                    self.view:doBoss8(result)
                elseif self.delNum == LEVEL_BOSS[8].T[2] then
                    local result = self.model:getBoss8(LEVEL_BOSS[8].N[2])
                    self.view:doBoss8(result)
                end
            elseif bossId == 9 then
            elseif bossId == 10 then
            
            end
        end
    end
end

return LinkController