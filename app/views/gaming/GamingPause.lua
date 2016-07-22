local GamingPause = class("GamingPause",cc.load("mvc").ViewBase)
GamingPause.RESOURCE_FILENAME = "gaming/gaming_pause"

function GamingPause:onCreate()
    self:get():move(0,0)
    self:initView()
end

function GamingPause:onClick(path,node,funcName)
    if funcName == "btnContinue" then
        local function btnCallback(node,eventType)
            print("btnContinue")
            self:btnContinueClick()
        end
        return btnCallback
    elseif funcName == "btnGiveUp" then
        local function btnCallback(node,eventType)
            print("btnGiveUp")
            self:btnGiveUpClick()
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("GamingPause:nnnnnnnnn")
        end
        return btnCallback
    end
end

function GamingPause:btnContinueClick()
    AppViews:getView(LAYERS.gaming_bg_top):starGamingTimer()
    AppViews:getView(LAYERS.gaming_ctl):hidePause()
    self:hideView()
    
end

function GamingPause:btnGiveUpClick()
    AppViews:getView(LAYERS.gaming_bg_top):deleGamingTimer()
    AppViews:getView(LAYERS.gaming_ctl):closeCtl()
    AppViews:getView("MainScene"):showMainRoom()
    self:hideView()
    
end


function GamingPause:initView()
    local function valueChanged(pSender)
        if nil == pDisplayValueLabel or nil == pSender then
            return
        end
        print(pSender)
    end
    local pSwitchControl = cc.ControlSwitch:create(
        cc.Sprite:create("Resource/other/switch-mask.png"),
        cc.Sprite:create("Resource/other/switch-off.png"),
        cc.Sprite:create("Resource/other/switch-on.png"),
        cc.Sprite:create("Resource/other/switch-thumb.png"),
        cc.Label:createWithSystemFont("On", "Arial-BoldMT", 16),
        cc.Label:createWithSystemFont("Off", "Arial-BoldMT", 16)
    )
    pSwitchControl:addTo(self.slidemusic)
    pSwitchControl:registerControlEventHandler(valueChanged,cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    valueChanged(pSwitchControl)
    
    
    local function effectChanged(pSender)
        if nil == pDsiplayValueLabel or nil == pSender then
            return 
        end
        dump(pSender)
    end
    local effectCtrol = cc.ControlSwitch:create(
        cc.Sprite:create("Resource/other/switch-mask.png"),
        cc.Sprite:create("Resource/other/switch-off.png"),
        cc.Sprite:create("Resource/other/switch-on.png"),
        cc.Sprite:create("Resource/other/switch-thumb.png"),
        cc.Label:createWithSystemFont("On", "Arial-BoldMT", 16),
        cc.Label:createWithSystemFont("Off", "Arial-BoldMT", 16)
    )
    effectCtrol:addTo(self.slideeffect)
    effectCtrol:registerControlEventHandler(effectChanged,cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    effectChanged(effectCtrol)
end

function GamingPause:hideView()
    self:move(display.width/2,3000)
end

function GamingPause:showView()
    self:show()
    self:move(display.width/2,display.height/2)
end

return GamingPause