local GamingBg = class("GamingBg",cc.load("mvc").ViewBase)
GamingBg.RESOURCE_FILENAME = "gaming/gaming_bg"

local GamingBgBm = import(".GamingBgBm")
local GamingBgTop = import(".GamingBgTop")

function GamingBg:onCreate()
    self:initView()
end

function GamingBg:onClick(path,node,funcName)
    if funcName == "name" then
        local function btnCallback(node,eventType)
            print("name")
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("GamingBg:nnnnnnnnnn")
        end
        return btnCallback
    end
end

function GamingBg:initView()
    self.GamingBgTop = GamingBgTop:create(self:getApp(),LAYERS.gaming_bg_top)
        :addTo(self)
        :move(display.width/2,display.height)
        
    self.GamingBgBm = GamingBgBm:create(self:getApp(),LAYERS.gaming_bg_bm)
        :addTo(self)
        :move(display.width/2,0)
        
end

return GamingBg