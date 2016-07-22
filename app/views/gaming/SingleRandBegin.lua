local SingleRandBegin = class("SingleRandBegin",cc.load("mvc").ViewBase)
SingleRandBegin.RESOURCE_FILENAME = "gaming/begin_single_rand"

function SingleRandBegin:onCreate()
    self:get():move(0,0)
end

function SingleRandBegin:onClick(path,node,funcName)
    if funcName == "btnBeginGame" then
        local function btnCallback(node,eventType)
            print("btnBeginGame")
            self:btnBeginGameClick()
        end
        return btnCallback
    elseif funcName == "btnClose" then
        local function btnCallback(node,eventType)
            print("btnClose")
            self:hide()
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("SingleRandBegin:nnnnnnnnnnnnnnn")
        end
        return btnCallback
    end
end

function SingleRandBegin:btnBeginGameClick()
    AppViews:getView(LAYERS.gaming_other):hideAllView()
    AppViews:getView("MainScene"):addGamingRand(AppViews:getView(LAYERS.single_main):getRandLevel())
    
end

return SingleRandBegin