local GamingLevelOver = class("GamingLevelOver",cc.load("mvc").ViewBase)
GamingLevelOver.RESOURCE_FILENAME = "gaming/gaming_level_over"

function GamingLevelOver:onCreate()
    self:get():move(0,0)
end

function GamingLevelOver:onClick(path,node,funcName)
    if funcName == "btnBack" then
        local function btnCallback(node,eventType)
            print("btnBack")
            self:btnBackClick()
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("GamingLevelOver:nnnnnnnnnn")
        end
        return btnCallback
    end
end

function GamingLevelOver:btnBackClick()
    AppViews:getView("MainScene"):showMainRoom()
    AppViews:getView(LAYERS.main_room):showSingle()
--    AppViews:getView("MainScene"):showNextLevel()
end


function GamingLevelOver:showView(levelNum,useTime,starNum)
    self.overtile:setString("第"..levelNum.."关")
    self.usetime:setString("本关用时:"..useTime)
    
    self.star2:show()
    self.star1:show()
    if starNum == 1 then
        self.star2:hide()
        self.star1:hide()
    elseif starNum == 2 then
        self.star1:hide()
    end
    
end

return GamingLevelOver