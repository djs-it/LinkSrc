local MainTop = class("MainTop",cc.load("mvc").ViewBase)
MainTop.RESOURCE_FILENAME = "mainroom/main_top"

function MainTop:onCreate()
    self:get():move(0,0)
    self:initView()
end

function MainTop:onClick(path,node,funcName)
    if funcName == "btnGold" then
        local function btnCallback(node,eventType)
            print("btnGold")
        end
        return btnCallback
    elseif funcName == "btnGem" then
        local function btnCallback(node,eventType)
            print("btnGem")
        end
        return btnCallback
    elseif funcName == "btnFriend" then
        local function btnCallback(node,eventType)
            print("btnFriend")
        end
        return btnCallback
    elseif funcName == "btnActivity" then
        local function btnCallback(node,eventType)
            print("btnActivity")
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("MainTop:nnnnnnnnnnn")
        end
        return btnCallback
    end
end

function MainTop:initView()
    local levelNum = helper.getSloterData(SLOTER.user_level) or 1
    local gemNum = helper.getSloterData(SLOTER.user_gem) or 100
    local goldNum = helper.getSloterData(SLOTER.user_gold) or 1000
    
    self.leaveltxt:setString(levelNum)
    self.goldtxt:setString(goldNum)
    self.gemtxt:setString(gemNum)
end

return MainTop