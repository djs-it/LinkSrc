local SingleMain = class("SingleMain",cc.load("mvc").ViewBase)
SingleMain.RESOURCE_FILENAME = "bmsingle/single_map"

local SingleGameMap = import(".SingleGameMap")

function SingleMain:onCreate()
    self:get():move(0,0)
    self:initView()
    self.randLevel = 1
end

function SingleMain:onClick(path,node,funcName)
    if funcName == "btnCloseBg" then
        local function btnCallback(node,eventType)
            print("btnCloseBg")
            self:btnCloseBgClick()
        end
        return btnCallback
    elseif funcName == "btnBeginRand" then
        local function btnCallback(node,eventType)
            print("btnBeginRand")
            self:btnBeginRandClick()
        end
        return btnCallback
    elseif funcName == "btnTurnRight" then
        local function btnCallback(node,eventType)
            print("btnTurnRight")
            self:btnTurn(1)
        end
        return btnCallback
    elseif funcName == "btnTurnLeft" then
        local function btnCallback(node,eventType)
            print("btnTurnLeft")
            self:btnTurn(-1)
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("SingleMain:nnnnnnnnnnn")
        end
        return btnCallback
    end
end

function SingleMain:initView()
    self.singleGameMap = SingleGameMap:create(self:getApp(),LAYERS.single_map)
        :addTo(self.singlemap)
        :setRotation(180)
     
     
    self.sliderbar = cc.ProgressTimer:create(cc.Sprite:create("Resource/other/progress-1.png"))
    self.sliderbar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.sliderbar:setMidpoint(cc.p(0, 0))
    self.sliderbar:setBarChangeRate(cc.p(1, 0))
    self.sliderbar:addTo(self.slider)
    self.sliderbar:setPosition(cc.p(235,31.5))
    
    self.sliderbar:setPercentage(60)
end

-------------------------------------------------------------------
--BTN
--<<<<<<<<<<<<<<<<<<<<<<<<<<

function SingleMain:btnCloseBgClick()
    AppViews:getView(LAYERS.main_room):hideAllView()
end

function SingleMain:btnTurn(sign)
    self.randLevel = self.randLevel + sign
    if self.randLevel > 4 then
        self.randLevel = 1
    elseif self.randLevel < 1 then
        self.randLevel = 4
    end
    self.randTile:setString(RAND_NAME[self.randLevel])
end

function SingleMain:btnBeginRandClick()
    AppViews:getView(LAYERS.gaming_other):showRandBegin()
end
-->>>>>>>>>>>>>>>>>>>>>>>>
--------------------------------------------------------------------

function SingleMain:getRandLevel()
    return self.randLevel
end

return SingleMain