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
    local starData = LinkUtil:getLevelStar()
    local levelNow = LinkUtil:getLevelNow()
    
    print("======levelnow"..levelNow)
    
    for i = 1 , 50 do
        self["bn"..i] = LevelBn:create(self:getApp(),"bn")
        local star = starData[i]
        local sign
        local sign = true
--        if i > levelNow then
--            sign = false
--        else
--            sign = true
--        end
        self["bn"..i]:initView(i,star,sign)
        self["bn"..i]:addTo(self["BN"..i])
    end
end

function SingleGameMap:showNextBtn(level,starNum)
    local levelNow = LinkUtil:getLevelNow()
    if levelNow == level then
        LinkUtil:setLevelNow(level+1)
        self["bn"..(level+1)]:setBtnShow(0)
    end
    self["bn"..level]:setStar(starNum)
    
end


return SingleGameMap