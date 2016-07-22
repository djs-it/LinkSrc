local SingleGameMap = class("SingleGameMap",cc.load("mvc").ViewBase)
SingleGameMap.RESOURCE_FILENAME = "bmsingle/map_game"

local LevelBn = import("..common/LevelBn")

function SingleGameMap:onCreate()
    self:get():move(0,0)
    self:initView()
end

function SingleGameMap:onClick(path,node,funcName)
    --    if string.sub(node:getName(),1,5) == "LEVEL" then
    --        local levelNum = string.sub(node:getName(),6)
    --        local function btnCallback(node,eventType)
    --            print("LEVEL"..levelNum)
    --            AppViews:getView(LAYERS.gaming_other):showLevelBegin(levelNum)
    --        end
    --        return btnCallback
    --    elseif string.sub(node:getName(),1,6) == "NOHAVE" then
    --        local str = string.sub(node:getName(),7)
    --        local function btnCallback(node,eventType)
    --            print("NOHAVE:"..str)
    --        end
    --        return btnCallback
    if  funcName == "name" then
        local function btnCallback(node,eventType)
            print("name")
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("SingleGameMap:nnnnnnnnnnnnnnnnnnn")
        end
        return btnCallback
    end
end


function SingleGameMap:initView()
    for i = 1 , 50 do
        self["bn"..i] = LevelBn:create(self:getApp(),"bn")
        self["bn"..i]:initView(i,2,true)
        self["bn"..i]:addTo(self["BN"..i])
    end
end


return SingleGameMap