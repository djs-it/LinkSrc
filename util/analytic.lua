
local analytic = {}


---------------------------
-- 初始化
-- 注意该方法只在游戏开始时调用一次，之后就不用再调用了
--
--@function [parent=#analytic] init
--@param string#string uid 玩家 id
--@param string#string appVersion 程序版本
function analytic:init(uid,appVersion,logids)
    if uid == nil then
        uid = "none"
    end
    if appVersion == nil then
        appVersion = "none"
    end
    local isDebug;
    if DEBUG > 1 then
        isDebug = true
    end

    if device.platform == device.PLATFORM.ANDROID then

        local luaj = require("luaj");
        luaj.callStaticMethod("org/cocos2dx/util/Flurry","init", {logids["android"],true}, "(Ljava/lang/String;Z)V")

        luaj.callStaticMethod("org/cocos2dx/util/Flurry","setAppVersion", {appVersion}, "(Ljava/lang/String;)V")
        luaj.callStaticMethod("org/cocos2dx/util/Flurry","setSessionContinueSecond", {143}, "(I)V")
        luaj.callStaticMethod("org/cocos2dx/util/Flurry","setUserID", {uid}, "(Ljava/lang/String;)V")
        luaj.callStaticMethod("org/cocos2dx/util/Flurry","setReportLocation", {true}, "(Z)V")
      elseif device.platform == device.PLATFORM.IOS then
        local DNPAnalyticX = dnp.DNPAnalyticX
        DNPAnalyticX:flurrySetAppVersion(appVersion)
        DNPAnalyticX:flurrySetDebugLogEnabled(DNP_USE_FLURRY);
        DNPAnalyticX:flurrySetSessionContinueSeconds(143);
        DNPAnalyticX:flurrySetCrashReportingEnabled(true);
        DNPAnalyticX:flurrySetEventLoggingEnabled(true)
        DNPAnalyticX:flurrySetUserID(uid); -- DNPAnalyticX:flurrySetAge(34); / DNPAnalyticX:flurrySetGender("f");
        DNPAnalyticX:flurrySetReportLocation(true);
        DNPAnalyticX:flurryStartSession(logids["ios"])
        if DEBUG > 1 then
            printInfo("Flurry version : " .. DNPAnalyticX:flurryGetFlurryAgentVersion())
        end
    end

   
    

    return self

end
---------------------------
-- 记录事件
--
--@function [parent=#analytic] logEvent
--@param string#string event 事件名
function analytic:logEvent(event)
    if event then
        if DEBUG > 1 then
            printInfo("Log event : " .. event)
        end
        if device.platform == device.PLATFORM.ANDROID then

            local luaj = require("luaj");
            luaj.callStaticMethod("org/cocos2dx/util/Flurry","logEvent", {event}, "(Ljava/lang/String;)V")
        elseif device.platform == device.PLATFORM.IOS then
            dnp.DNPAnalyticX:flurryLogEventWrap(event)
        end
    end
    return self
end

---------------------------
-- 记录事件
--
--@function [parent=#analytic] logEventWithParameters
--@param string#string event 事件名
--@param table#table data 数据
function analytic:logEventWithParameters(event,data)
    if event and data then
        if DEBUG > 1 then
            printInfo("log event with paras : " .. event)
            dump(data)
        end
        if device.platform == device.PLATFORM.ANDROID then
            local str = json:encode(data);
            local luaj = require("luaj");
            luaj.callStaticMethod("org/cocos2dx/util/Flurry","logEventWithParameters", {event,str}, "(Ljava/lang/String;Ljava/lang/String;)V")
        elseif device.platform == device.PLATFORM.IOS then
            dnp.DNPAnalyticX:flurryLogEventWithParameters(event,data)
        end

    end
    return self
end

return analytic