local GamingBgBm = class("GamingBgBm",cc.load("mvc").ViewBase)
GamingBgBm.RESOURCE_FILENAME = "gaming/gaming_bm"

function GamingBgBm:onCreate()
    self:get():move(0,0)
end

function GamingBgBm:onClick(path,node,funcName)
    if funcName == "btnFind" then
        local function btnCallback(node,eventType)
            print("btnFind")
            AppViews:getView(LAYERS.gaming_ctl):showTips()
        end
        return btnCallback
    elseif funcName == "btnRand" then
        local function btnCallback(node,eventType)
            print("btnRand")
            AppViews:getView(LAYERS.gaming_ctl):showRand()
        end
        return btnCallback
    elseif funcName == "btnClear" then
        local function btnCallback(node,eventType)
            print("btnClear")
            AppViews:getView(LAYERS.gaming_ctl):setBmBtnClear(true)
            self:setBmBtnClear(true)
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("GamingBgBm:nnnnnnnnn")
        end
        return btnCallback
    end
end

function GamingBgBm:setBmBtnClear(sign)
    if sign then
        self.btnClear:setScale(1.3)
    else
        self.btnClear:setScale(1)
    end
end

return GamingBgBm