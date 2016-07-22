local SingleLevelBegin = class("SingleLevelBegin",cc.load("mvc").ViewBase)
SingleLevelBegin.RESOURCE_FILENAME = "gaming/begin_single_level"

function SingleLevelBegin:onCreate()
    self:get():move(0,0)
end

function SingleLevelBegin:onClick(path,node,funcName)
    if funcName == "btnCloseBegin" or funcName == "btnCloseBg" then
        local function btnCallback(node,eventType)
            print("btnCloseBegin")
            self:hide()
        end
        return btnCallback
    elseif funcName == "btnBeginGame" then
        local function btnCallback(node,eventType)
            print("btnBeginGame")
            self:btnBeginGame()
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("SingleLevelBegin:nnnnnnnnnnn")
        end
        return btnCallback
    end
end

------------------------------------------------------------
--BTN<<<<<<<<<<<<<<<<<<<<<<<<<<<

function SingleLevelBegin:btnBeginGame()
    self:hide()
    AppViews:getView("MainScene"):addGamingLevel(AppViews:getView(LAYERS.gaming_other):getLevelNum())
end

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-------------------------------------------------------------


function SingleLevelBegin:showView(levelNum)
    self.levelnum:setString("第"..levelNum.."关")
end


return SingleLevelBegin