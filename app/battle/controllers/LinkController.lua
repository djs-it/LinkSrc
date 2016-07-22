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
function LinkController:initGame(data)
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
                local lastPoint,newPoint,clearPoint,linePoint,clearGem,clearKey= self.model:dealTouchPoint(beganPosition)
                self:dealGame(lastPoint,newPoint,clearPoint,linePoint,clearGem,clearKey)
            end
        else
            self:setBmBtnClear(false)
        end
        return true
    elseif event.name == "moved" then
    elseif event.name == "ended" then
    end

end


-----------------------------------------
--处理游戏逻辑
--
function LinkController:dealGame(lastPoint,newPoint,clearPoint,linePoint,clearGem,clearKey)

    if LinkUtil:isTrue(linePoint) then
        local pt = self.model:getAllPointByTips(linePoint)
    end

    self.view:hideTipsDemo()
    self:hideAllViewDemo()

    self.view:setSelectByPoint(lastPoint,newPoint)

    local mark,pointLast,pointNew = self.model:dealTurning(lastPoint,newPoint)
    self.view:dealTurning(mark,pointLast,pointNew)

    local isRunWay,wayTable = self.model:clearBaseByPoint(clearPoint)
    self.view:clearBaseByTable(clearPoint,isRunWay,wayTable)

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

    local tipsTable = self.model:getLineTwoPoint()
    if not LinkUtil:isTrue(tipsTable) then
        local dataing,resultdata = self.model:dealGameDataIng()
        self.view:realignGameIng(dataing,resultdata)
    end

end


function LinkController:dealBmBtnClear(clearPoint)
    if LinkUtil:isTrue(clearPoint) then

        local isRunWay,wayTable = self.model:clearBaseByPoint(clearPoint)
        self.view:clearBaseByTable(clearPoint,isRunWay,wayTable)

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
            else
                self:removeTimer(TIME_CLOUD_NAME)
            end
        end
        self.cloudTimer =  self:addTimer(TIME_CLOUD_NAME,TIME_CLOUD_NUM,190000,call)
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
    local basePoint = self.model:getGamingBaseData()
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
    self.view:clearView()
    if self.cloudTimer then
        self:removeTimer(TIME_CLOUD_NAME)
    end

    local starNum,timeStr = AppViews:getView(LAYERS.gaming_bg_top):deleGamingTimer()
    AppViews:getView(LAYERS.gaming_other):showLevelOver(timeStr,starNum)
end

function LinkController:closeCtl()
    local dataing,resultdata = self.model:dealGameDataIng()
    if self.cloudTimer then
        self:removeTimer(TIME_CLOUD_NAME)
    end
    self.view:clearView()
    self.view = nil
    self.model:clearModel()
    self.model = nil
end

return LinkController