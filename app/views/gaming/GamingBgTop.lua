local GamingBgTop = class("GamingBgTop",cc.load("mvc").ViewBase)
GamingBgTop.RESOURCE_FILENAME = "gaming/gaming_top"

function GamingBgTop:onCreate()
    self:get():move(0,0)
    
end

function GamingBgTop:onClick(path,node,funcName)
    if funcName == "btnPause" then
        local function btnCallback(node,eventType)
            print("btnPause")
            self:showPause()
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("GamingBgTop:nnnnnnnnnn")
        end
        return btnCallback
    end
end

function GamingBgTop:addGamingTimer(levelNum)
    self.star1:show()
    self.star2:show()
    
    local ln = levelNum
    self.timeStr = nil
    self.starNum = 3
    
    self.isCanTimer = true
    self.timeCount = 0
    self.toptime:setString("00:00")
    local function call()
        if self.isCanTimer then
            self.timeCount = self.timeCount + TIME_GAMING_NUM
            self.timeStr = LinkUtil:getStrMinTime(self.timeCount)
            if self.timeCount > LEVEL_MSG[ln].T[2] then
                self.star2:hide()
                self.starNum = 1
            elseif self.timeCount > LEVEL_MSG[ln].T[1] then
                self.star1:hide()
                self.starNum = 2
            end
            self.toptime:setString(self.timeStr)
        end
    end
    self:addTimer(TIME_GAMING_NAME,TIME_GAMING_NUM,20000,call)
end

function GamingBgTop:showPause()
    AppViews:getView(LAYERS.gaming_other):showPause()
    AppViews:getView(LAYERS.gaming_ctl):showPause()
    self.isCanTimer = false
end

function GamingBgTop:starGamingTimer()
    self.isCanTimer = true
end

function GamingBgTop:deleGamingTimer()
    self:removeTimer(TIME_GAMING_NAME)
    
    return self.starNum,self.timeStr
end

return GamingBgTop