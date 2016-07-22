--[[

Copyright (c) 2011-2014 chukong-inc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

local ac = {}

local ACTION_EASING = {}
ACTION_EASING["BACKIN"]           = {cc.EaseBackIn, 1}
ACTION_EASING["BACKINOUT"]        = {cc.EaseBackInOut, 1}
ACTION_EASING["BACKOUT"]          = {cc.EaseBackOut, 1}
ACTION_EASING["BOUNCE"]           = {cc.EaseBounce, 1}
ACTION_EASING["BOUNCEIN"]         = {cc.EaseBounceIn, 1}
ACTION_EASING["BOUNCEINOUT"]      = {cc.EaseBounceInOut, 1}
ACTION_EASING["BOUNCEOUT"]        = {cc.EaseBounceOut, 1}
ACTION_EASING["ELASTIC"]          = {cc.EaseElastic, 2, 0.3}
ACTION_EASING["ELASTICIN"]        = {cc.EaseElasticIn, 2, 0.3}
ACTION_EASING["ELASTICINOUT"]     = {cc.EaseElasticInOut, 2, 0.3}
ACTION_EASING["ELASTICOUT"]       = {cc.EaseElasticOut, 2, 0.3}
ACTION_EASING["EXPONENTIALIN"]    = {cc.EaseExponentialIn, 1}
ACTION_EASING["EXPONENTIALINOUT"] = {cc.EaseExponentialInOut, 1}
ACTION_EASING["EXPONENTIALOUT"]   = {cc.EaseExponentialOut, 1}
ACTION_EASING["IN"]               = {cc.EaseIn, 2, 1}
ACTION_EASING["INOUT"]            = {cc.EaseInOut, 2, 1}
ACTION_EASING["OUT"]              = {cc.EaseOut, 2, 1}
ACTION_EASING["RATEACTION"]       = {cc.EaseRateAction, 2, 1}
ACTION_EASING["SINEIN"]           = {cc.EaseSineIn, 1}
ACTION_EASING["SINEINOUT"]        = {cc.EaseSineInOut, 1}
ACTION_EASING["SINEOUT"]          = {cc.EaseSineOut, 1}

local ACTION_EASING_INDEX = {}
ACTION_EASING_INDEX[1] = "BACKIN"
ACTION_EASING_INDEX[2] = "BACKINOUT"
ACTION_EASING_INDEX[3] = "BACKOUT"
ACTION_EASING_INDEX[4] = "BOUNCE"
ACTION_EASING_INDEX[5] = "BOUNCEIN"
ACTION_EASING_INDEX[6] = "BOUNCEINOUT"
ACTION_EASING_INDEX[7] = "BOUNCEOUT"
ACTION_EASING_INDEX[8] = "ELASTIC"
ACTION_EASING_INDEX[9] = "ELASTICIN"
ACTION_EASING_INDEX[10] = "ELASTICINOUT"
ACTION_EASING_INDEX[11] = "ELASTICOUT"
ACTION_EASING_INDEX[12] = "EXPONENTIALIN"
ACTION_EASING_INDEX[13] = "EXPONENTIALINOUT"
ACTION_EASING_INDEX[14] = "EXPONENTIALOUT"
ACTION_EASING_INDEX[15] = "IN"
ACTION_EASING_INDEX[16] = "INOUT"
ACTION_EASING_INDEX[17] = "OUT"
ACTION_EASING_INDEX[18] = "RATEACTION"
ACTION_EASING_INDEX[19] = "SINEIN"
ACTION_EASING_INDEX[20] = "SINEINOUT"
ACTION_EASING_INDEX[21] = "SINEOUT"


local actionManager = cc.Director:getInstance():getActionManager()

function ac.ccEasing(action, easingName, more)
    local key
    if type(easingName) == "string" then
        key = string.upper(tostring(easingName))
    else
        key =   ACTION_EASING_INDEX[tonumber(easingName)]
    end
    local easing
    if ACTION_EASING[key] then
        local cls, count, default = unpack(ACTION_EASING[key])
        if count == 2 then
            easing = cls:create(action, more or default)
        else
            easing = cls:create(action)
        end
    end
    return easing or action
end

function ac.create(action, args)
    args = checktable(args)
    if args.easing then
        if type(args.easing) == "table" then
            action = ac.ccEasing(action, unpack(args.easing))
        else
            action = ac.ccEasing(action, args.easing)
        end
    end

    local actions = {}
    local delay = checknumber(args.delay)
    if delay > 0 then
        actions[#actions + 1] = cc.DelayTime:create(delay)
    end
    actions[#actions + 1] = action

    local onComplete = args.onComplete
    if type(onComplete) ~= "function" then onComplete = nil end
    if onComplete then
        actions[#actions + 1] = cc.CallFunc:create(onComplete)
    end

    if args.removeSelf then
        actions[#actions + 1] = cc.RemoveSelf:create()
    end

    if #actions > 1 then
        return ac.sequence(actions)
    else
        return actions[1]
    end
end

function ac.execute(target, action, args)
    assert(not tolua.isnull(target), "ac.execute() - target is not cc.Node")
    local action = ac.create(action, args)
    target:runAction(action)
    return action
end

function ac.moveTo(target, args)
    assert(not tolua.isnull(target), "ac.moveTo() - target is not cc.Node")
    local x = args.x or target:getPositionX()
    local y = args.y or target:getPositionY()
    local action = cc.MoveTo:create(args.time, cc.p(x, y))
    return ac.execute(target, action, args)
end

function ac.moveBy(target, args)
    assert(not tolua.isnull(target), "ac.moveBy() - target is not cc.Node")
    local x = args.x or 0
    local y = args.y or 0
    local action = cc.MoveBy:create(args.time, cc.p(x, y))
    return ac.execute(target, action, args)
end

function ac.fadeIn(target, args)
    assert(not tolua.isnull(target), "ac.fadeIn() - target is not cc.Node")
    local action = cc.FadeIn:create(args.time)
    return ac.execute(target, action, args)
end

function ac.fadeOut(target, args)
    assert(not tolua.isnull(target), "ac.fadeOut() - target is not cc.Node")
    local action = cc.FadeOut:create(args.time)
    return ac.execute(target, action, args)
end

function ac.fadeTo(target, args)
    assert(not tolua.isnull(target), "ac.fadeTo() - target is not cc.Node")
    local opacity = checkint(args.opacity)
    if opacity < 0 then
        opacity = 0
    elseif opacity > 255 then
        opacity = 255
    end
    local action = cc.FadeTo:create(args.time, opacity)
    return ac.execute(target, action, args)
end

function ac.scaleTo(target, args)
    assert(not tolua.isnull(target), "ac.scaleTo() - target is not cc.Node")
    local action
    if args.scale then
        action = cc.ScaleTo:create(checknumber(args.time), checknumber(args.scale))
    elseif args.scaleX or args.scaleY then
        local scaleX, scaleY
        if args.scaleX then
            scaleX = checknumber(args.scaleX)
        else
            scaleX = target:getScaleX()
        end
        if args.scaleY then
            scaleY = checknumber(args.scaleY)
        else
            scaleY = target:getScaleY()
        end
        action = cc.ScaleTo:create(checknumber(args.time), scaleX, scaleY)
    end
    return ac.execute(target, action, args)
end

function ac.rotateTo(target, args)
    assert(not tolua.isnull(target), "ac.rotateTo() - target is not cc.Node")
    local rotation = args.rotation or target:getRotation()
    local action = cc.RotateTo:create(args.time, rotation)
    return ac.execute(target, action, args)
end

function ac.rotateBy(target, args)
    assert(not tolua.isnull(target), "ac.rotateTo() - target is not cc.Node")
    local rotation = args.rotation or 0
    local action = cc.RotateBy:create(args.time, rotation)
    return ac.execute(target, action, args)
end

function ac.sequence(actions)
    if #actions < 1 then return end
    if #actions < 2 then return actions[1] end
    return cc.Sequence:create(actions)
end

function ac.removeAction(action)
    if not tolua.isnull(action) then
        actionManager:removeAction(action)
    end
end

function ac.stopTarget(target)
    if not tolua.isnull(target) then
        actionManager:removeAllActionsFromTarget(target)
    end
end

function ac.pauseTarget(target)
    if not tolua.isnull(target) then
        actionManager:pauseTarget(target)
    end
end

function ac.resumeTarget(target)
    if not tolua.isnull(target) then
        actionManager:resumeTarget(target)
    end
end

function ac.ccMoveTo(duration,position)
    return cc.MoveTo:create(duration,position)
end

function ac.ccMoveBy(duration,position)
    return cc.MoveBy:create(duration,position)
end

function ac.ccScaleTo(duration,sx,sy,sz)
    if not sy then
        return   cc.ScaleTo:create(duration,sx)
    elseif not sz then
        return   cc.ScaleTo:create(duration,sx,sy)
    else
        return   cc.ScaleTo:create(duration,sx,sy,sz)
    end

end

function ac.ccScaleBy(duration,sx,sy,sz)
    if not sy then
        return   cc.ScaleBy:create(duration,sx)
    elseif not sz then
        return   cc.ScaleBy:create(duration,sx,sy)
    else
        return   cc.ScaleBy:create(duration,sx,sy,sz)
    end
end

function ac.ccRotateTo(duration,deltaAngleX,deltaAngleY)
    return cc.RotateTo:create(duration,deltaAngleX,deltaAngleY)
end

function ac.ccRotateBy(duration,deltaAngleX,deltaAngleY)
    return cc.RotateBy:create(duration,deltaAngleX,deltaAngleY)
end

function ac.ccRotateBy(t,sx,sy)
    return cc.SkewTo:create(t,sx,sy)
end

function ac.ccSkewBy(t,sx,sy)
    return cc.SkewBy:create(t,sx,sy)
end

function ac.ccJumpTo(duration,position,height,jumps)
    return cc.JumpTo:create(duration,position,height,jumps)
end

function ac.ccJumpBy(duration,position,height,jumps)
    return cc.JumpBy:create(duration,position,height,jumps)
end

function ac.ccBlink(duration,blinks)
    return cc.Blink:create(duration,blinks)
end

function ac.ccDelay(duration)
    return cc.DelayTime:create(duration)
end

function ac.ccRemoveSelf()
    return cc.RemoveSelf:create()
end

function ac.ccSeq(...)
    return cc.Sequence:create(...)
end

function ac.ccCall(onComplete)
    return cc.CallFunc:create(onComplete)
end

function ac.ccDellayToCall(partent,dt,call)
    partent:runAction(cc.Sequence:create(cc.DelayTime:create(dt),cc.CallFunc:create(call)))
end


function ac.ccFadeIn(time)
    return cc.FadeIn:create(time)
end

function ac.ccFadeOut(time)
  return cc.FadeOut:create(time)
end

function ac.ccFadeTo(time , opacity)
    return cc.FadeTo:create(time, opacity)
end

function ac.ccForever(action)
    return cc.RepeatForever:create(action)
end



return ac
