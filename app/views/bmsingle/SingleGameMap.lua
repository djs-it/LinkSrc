local SingleGameMap = class("SingleGameMap",cc.load("mvc").ViewBase)
SingleGameMap.RESOURCE_FILENAME = "bmsingle.map_game"

local LevelBn = import("..common.LevelBn")

function SingleGameMap:onCreate()
    self:get():move(0,0)
    self:initView()
end

function SingleGameMap:onClick(path,node,funcName)
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