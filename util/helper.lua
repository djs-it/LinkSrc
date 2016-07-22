---------------------------
-- 所有的label相关的更加高层的封装全局模块
--
-- @module helper
local helper = class("helper")

local cache = cc.SpriteFrameCache:getInstance()


---------------------------
-- 函数功能为 提供可滑动层
-- @function [parent=#helper] scrollable
-- @param Layer#Layer layer
-- @param int#int width description
function helper.scrollable(layer, width)

    local touchBeginPoint = nil
    local touchLastPoint = nil

    local beginTime = 0
    local oneTouch = false

    local function onTouchBegan(touch, event)
        if oneTouch == true then
            return
        else
            oneTouch = true
        end
        local socket = require "socket"
        beginTime = socket.gettime()
        local location = touch:getLocation()
        touchBeginPoint = {x = location.x, y = location.y}
        touchLastPoint = touchBeginPoint
        ac.stopTarget(layer)
        return true
    end

    local function onTouchMoved(touch, event)
        local location = touch:getLocation()
        if touchBeginPoint then
            local cx, cy = layer:getPosition()
            layer:setPosition(cx + location.x - touchBeginPoint.x,
                cy)
            if math.abs(cx + location.x - touchBeginPoint.x) > (width - display.width) / 2   then
                layer:setPosition(cx, cy)
            end
            touchBeginPoint = {x = location.x, y = location.y}
        end
    end

    local function onTouchEnded(touch, event)
        local location = touch:getLocation()
        local socket = require "socket"
        local time = socket.gettime() - beginTime
        local distance = (math.abs(location.x - touchLastPoint.x) )
        local position

        if distance > 60 and time < 0.5 then
            local cx, cy = layer:getPosition()

            if (math.abs(cx) + distance) >= (width - display.width) / 2 then
                if touchLastPoint.x > location.x then
                    position = (width - display.width) / 2 * -1
                else
                    position = (width - display.width) / 2
                end
            else
                if touchLastPoint.x > location.x then
                    position = cx + distance  * -1
                else
                    position = cx + distance
                end
            end
            local period = distance / 256
            local actionMove = cc.MoveTo:create(period,{x=position,y=cy})
            layer:runAction(actionMove)
        end
        touchBeginPoint = nil
        oneTouch = false
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
end


---------------------------
-- 函数功能为 阻止下层点击
-- @function [parent=#helper] addNotouch
-- @param Layer#Layer layer
function helper.addNotouch(layer)
    local mask = cc.LayerColor:create(cc.c4b(255,255,255,0))
    helper.notouched(mask)
    mask:setContentSize(display.size);
    layer:addChild(mask)
end

---------------------------
-- 函数功能为 阻止下层点击
-- @function [parent=#helper] notouched
-- @param Layer#Layer layer
function helper.notouched(layer)

    local function onTouchBegan(touch, event)
        return true
    end

    local function onTouchMoved(touch, event)
        return true
    end

    local function onTouchEnded(touch, event)
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

end


local function _creteAnimation(fileName,times,re)
    local animFrames = {}
    for i = 1,times do
        local name = string.format(fileName, i)
        local frame = cache:getSpriteFrame(name)
        animFrames[i] = frame
    end
    local animation
    if re then
        animation = cc.Animation:createWithSpriteFrames(animFrames,ANI_UNITE_TIME,re)
    else
        animation = cc.Animation:createWithSpriteFrames(animFrames,ANI_UNITE_TIME)
    end
    local action = cc.Animate:create(animation)

    return action
end

---------------------------
--执行帧动画，单次
--@function [parent=#helper] runFrameAninate
--@param node#node node 执行动画的节点
function helper.runFrameAninate(node,fileName,times,re)
    node:runAction(_creteAnimation(fileName,times,re))
end

---------------------------
--执行帧动画，循环
--@function [parent=#helper] runFrameAninateForever
--@param node#node node 执行动画的节点
function helper.runFrameAninateForever(node,fileName,times,re)
    node:runAction(cc.RepeatForever:create(_creteAnimation(fileName,times,re)))
end

---------------------------
--执行粒子动画
--@function [parent=#helper] createParticles
function helper.createParticles(filenames,pos,delay)
    local partic= cc.Node:create()

    for key, filename in pairs(filenames) do
        local emitter = cc.ParticleSystemQuad:create(filename)
        emitter:setAutoRemoveOnFinish(true)
        emitter:setBlendAdditive(false)
        if pos then
            emitter:setPosition(pos)
        else
            emitter:setPosition(cc.p(0,0))
        end
        partic:addChild(emitter,1)
    end

    partic:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.RemoveSelf:create()))

    return partic
end

---------------------------
--执行粒子动画
--@function [parent=#helper] createParticles
function helper.createDNPParticle(filenames,pos,fps)
    local partic = dnp.DNPParticleSystemFrameQuad:create("ccbResources/particles/" .. filenames .. "p.plist")
    partic:spriteFrameWithFile("ccbResources/particles/" .. filenames .. ".plist", "ccbResources/particles/" .. filenames .. ".png", fps)
    partic:setPosition(pos)
    partic:setAutoRemoveOnFinish(true)
    partic:setBlendAdditive(false)
    return partic
end

---------------------------
--获得ccLableTTF句柄
--@function [parent=#helper] setUserData
--@param string#string name 名字
--@param mix#mix value值
function helper.setUserData(name,value)
    local type = type(value)
    if type == "string" then
        cc.UserDefault:getInstance():setStringForKey(name,value)
    elseif type == "number" then
        cc.UserDefault:getInstance():setIntegerForKey(name,value)
    elseif type == "boolean" then
        cc.UserDefault:getInstance():setBoolForKey(name,value)
    end
end


---------------------------
--获得用户存储数据整形
--@function [parent=#helper] getUserDataInt
--@param string#string name 名字
--@return number#number 值
function helper.getUserDataInt(name)
    return cc.UserDefault:getInstance():getIntegerForKey(name)
end


---------------------------
--获得用户存储数据字符串
--@function [parent=#helper] getUserDataString
--@param string#string name 名字
--@return number#number 值
function helper.getUserDataString(name)
    return cc.UserDefault:getInstance():getStringForKey(name)
end


---------------------------
--获得用户存储数据布尔
--@function [parent=#helper] getUserDataBoolean
--@param string#string name 名字
--@return number#number 值
function helper.getUserDataBoolean(name)
    return cc.UserDefault:getInstance():getBoolForKey(name)
end

---------------------------
--是否是手机设备
--@function [parent=#helper] isPhone
--@return boolean#boolean 值
function helper.isPhone()
    if device.platform == device.PLATFORM.ANDROID or device.platform == device.PLATFORM.IOS then
        return true
    end
end


---------------------------
--向存储卡上储存用户数据
--@function [parent=#helper] setSloterData
function helper.setSloterData(key,value)
    sloter:setValueItem(key,value)
end


---------------------------
--向存储卡上储存用户数据，并保存
--@function [parent=#helper] saveSloterData
function helper.saveSloterData(key,value)
    sloter:setValueItem(key,value)
    sloter:save()
end


---------------------------
--获取存储卡上的用户数据
--@function [parent=#helper] getSloterData
function helper.getSloterData(key)
    return sloter:getValueItem(key)
end

--------------------
--用指定字符或字符串分割输入字符串，返回包含分割结果的数组
--
----@function [parent=#helper] getUserIdMd5
function helper.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

--------------------
--判断两个点相等
--
----@function [parent=#helper] pEqual
function helper.pEqual(p1,p2)
    return (p1.x == p2.x and p1.y == p2.y)
end

--------------------
--打开一个外部链接,"http://www.baidu.com"
--
----@function [parent=#helper] openUrl
function helper.openUrl(url)
    cc.Application:getInstance():openURL(url)
end


function helper.typewriterLabel(label,text,dt)

    local totalLen = string.utf8len(text)
    local i = 0    
    local function showFont()
        i = i+1
        local str = string.utf8str(text, 1, i)
        label:setString(str)
    end
    timer:start("DEFALUT_TIMER"..tagen:get(),showFont,dt,totalLen)
end

function helper.fromatLO(lostr)
    local temstr = string.split(lostr, "()")
    local forstr = ""
    for v=1, #temstr do
        if #temstr == v then
            forstr = forstr .. temstr[v]
        else
            forstr =forstr .. temstr[v] .. "%d"
        end
        
    end
    return forstr
end

-----
--持续增加数字动画效果
--
--@function [parent=#app.QueenUtil] updateMainColt
function helper.seqAniGet(label,toNum,added)
    local t = 10
    if added<10 then
        t = added
    end
    local coin = toNum - added
    if coin<0 then
        coin = 0
    end

    local function addcoin()
        coin = coin + math.ceil(added/t)
        label:setString(coin)
    end
    local function compolet()
        label:setString(toNum)
    end
    label:runAction(cc.Sequence:create(cc.Repeat:create(cc.Sequence:create(cc.ScaleBy:create(0.05,1.2),cc.CallFunc:create(addcoin),cc.ScaleBy:create(0.05,1/1.2)),t),cc.CallFunc:create(compolet)))
end

return helper