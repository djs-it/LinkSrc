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

local device = {}

device.platform    = "unknown"
device.model       = "unknown"

device.PLATFORM = {}
device.PLATFORM.IOS = "ios"
device.PLATFORM.ANDROID = "android"
device.PLATFORM.MACOS = "mac"
device.PLATFORM.WINDOWS = "windows"
device.PLATFORM.WINRT = "winrt"
device.PLATFORM.WP8 = "wp8"
device.PLATFORM.UNKNOWN = "unknown"

device.LANGUAGE = {}
device.LANGUAGE.CN = "cn"
device.LANGUAGE.FR = "fr"
device.LANGUAGE.IT = "it"
device.LANGUAGE.GR = "gr"
device.LANGUAGE.SP = "sp"
device.LANGUAGE.RU = "ru"
device.LANGUAGE.KR = "kr"
device.LANGUAGE.JP = "jp"
device.LANGUAGE.HU = "hu"
device.LANGUAGE.PT = "pt"
device.LANGUAGE.AR = "ar"
device.LANGUAGE.EN = "en"

local app = cc.Application:getInstance()
local target = app:getTargetPlatform()
if target == cc.PLATFORM_OS_WINDOWS then
    device.platform = "windows"
elseif target == cc.PLATFORM_OS_MAC then
    device.platform = "mac"
elseif target == cc.PLATFORM_OS_ANDROID then
    device.platform = "android"
elseif target == cc.PLATFORM_OS_IPHONE or target == cc.PLATFORM_OS_IPAD then
    device.platform = "ios"
    local director = cc.Director:getInstance()
    local view = director:getOpenGLView()
    local framesize = view:getFrameSize()
    local w, h = framesize.width, framesize.height
    if w == 640 and h == 960 then
        device.model = "iphone 4"
    elseif w == 640 and h == 1136 then
        device.model = "iphone 5"
    elseif w == 750 and h == 1334 then
        device.model = "iphone 6"
    elseif w == 1242 and h == 2208 then
        device.model = "iphone 6 plus"
    elseif w == 768 and h == 1024 then
        device.model = "ipad"
    elseif w == 1536 and h == 2048 then
        device.model = "ipad retina"
    end
elseif target == cc.PLATFORM_OS_WINRT then
    device.platform = "winrt"
elseif target == cc.PLATFORM_OS_WP8 then
    device.platform = "wp8"
end

local language_ = app:getCurrentLanguage()
if language_ == cc.LANGUAGE_CHINESE then
    language_ = "cn"
elseif language_ == cc.LANGUAGE_FRENCH then
    language_ = "fr"
elseif language_ == cc.LANGUAGE_ITALIAN then
    language_ = "it"
elseif language_ == cc.LANGUAGE_GERMAN then
    language_ = "gr"
elseif language_ == cc.LANGUAGE_SPANISH then
    language_ = "sp"
elseif language_ == cc.LANGUAGE_RUSSIAN then
    language_ = "ru"
elseif language_ == cc.LANGUAGE_KOREAN then
    language_ = "kr"
elseif language_ == cc.LANGUAGE_JAPANESE then
    language_ = "jp"
elseif language_ == cc.LANGUAGE_HUNGARIAN then
    language_ = "hu"
elseif language_ == cc.LANGUAGE_PORTUGUESE then
    language_ = "pt"
elseif language_ == cc.LANGUAGE_ARABIC then
    language_ = "ar"
else
    language_ = "en"
end

device.language = language_
device.writablePath = cc.FileUtils:getInstance():getWritablePath()
device.directorySeparator = "/"
device.pathSeparator = ":"
if device.platform == "windows" then
    device.directorySeparator = "\\"
    device.pathSeparator = ";"
end

printInfo("# device.platform              = " .. device.platform)
printInfo("# device.model                 = " .. device.model)
printInfo("# device.language              = " .. device.language)
printInfo("# device.writablePath          = " .. device.writablePath)
printInfo("# device.directorySeparator    = " .. device.directorySeparator)
printInfo("# device.pathSeparator         = " .. device.pathSeparator)
printInfo("#")


-- 获得手机唯一编码
function device:getDeviceUid()
    if device.platform == device.PLATFORM.ANDROID then
        local a, b = LuaJavaBridge.callStaticMethod("org/cocos2dx/util/Gamer","getUUID",{},"()Ljava/lang/String;")
        if a == true and b ~= nil then
            return b
        else
            return "999999999999"
        end
    elseif device.platform == device.PLATFORM.IOS then
        return dnp.DNPDeviceUtils:uuid()
    else
        return "999999999999"
    end
end




--[[--
显示活动指示器
在 iOS 和 Android 设备上显示系统的活动指示器，可以用于阻塞操作时通知用户需要等待。
]]
function device.showActivityIndicator()
    if DEBUG > 1 then
        printInfo("device.showActivityIndicator()")
    end
    if device.platform == "android" then
        luaj.callStaticMethod("org/cocos2dx/util/PSNative", "showActivityIndicator", {}, "()V");
    elseif device.platform == "ios" then
        cc.Native:showActivityIndicator()
    end
end

--[[--
隐藏正在显示的活动指示器
]]
function device.hideActivityIndicator()
    if DEBUG > 1 then
        printInfo("device.hideActivityIndicator()")
    end
    if device.platform == "android" then
        luaj.callStaticMethod("org/cocos2dx/util/PSNative", "hideActivityIndicator", {}, "()V");
    elseif device.platform == "ios" then
        cc.Native:hideActivityIndicator()
    end
end

--[[--
显示一个包含按钮的弹出对话框
~~~ lua
local function onButtonClicked(event)
if event.buttonIndex == 1 then
.... 玩家选择了 YES 按钮
else
.... 玩家选择了 NO 按钮
end
end
device.showAlert("Confirm Exit", "Are you sure exit game ?", {"YES", "NO"}, onButtonClicked)
~~~
当没有指定按钮标题时，对话框会默认显示一个“OK”按钮。
回调函数获得的表格中，buttonIndex 指示玩家选择了哪一个按钮，其值是按钮的显示顺序。
@param string title 对话框标题
@param string message 内容
@param table buttonLabels 包含多个按钮标题的表格对象
@param function listener 回调函数
]]
function device.showAlert(title, message, buttonLabels, listener)
    if type(buttonLabels) ~= "table" then
        buttonLabels = {tostring(buttonLabels)}
    else
        table.map(buttonLabels, function(v) return tostring(v) end)
    end

    for i = 1 ,3 do
        if buttonLabels[i] == nil then
            buttonLabels[i] = ""
        end
    end


    if DEBUG > 1 then
        printInfo("device.showAlert() - title: %s", title)
        printInfo("    message: %s", message)
        printInfo("    buttonLabels: %s", table.concat(buttonLabels, ", "))
    end

    if device.platform == "android" then
        local tempListner = function(event)
            if type(event) == "string" then
                event = require("framework.json").decode(event)
                event.buttonIndex = tonumber(event.buttonIndex)
            end
            if listener then listener(event) end
        end
        require("luaj").callStaticMethod("org/cocos2dx/util/PSNative", "createAlert", {title, message, buttonLabels[1],buttonLabels[2],buttonLabels[3], tempListner},
            "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V");
    else
        local defaultLabel = ""
        if #buttonLabels > 0 then
            defaultLabel = buttonLabels[1]
            table.remove(buttonLabels, 1)
        end

        cc.Native:createAlert(title, message, defaultLabel)
        for i, label in ipairs(buttonLabels) do
            cc.Native:addAlertButton(label)
        end

        if type(listener) ~= "function" then
            listener = function() end
        end

        cc.Native:showAlert(listener)
    end
end

--[[--
取消正在显示的对话框。
提示：取消对话框，不会执行显示对话框时指定的回调函数。
]]
function device.cancelAlert()
    if DEBUG > 1 then
        printInfo("device.cancelAlert()")
    end
    cc.Native:cancelAlert()
end

--[[--
返回设备的 OpenUDID 值
OpenUDID 是为设备仿造的 UDID（唯一设备识别码），可以用来识别用户的设备。
但 OpenUDID 存在下列问题：
-   如果删除了应用再重新安装，获得的 OpenUDID 会发生变化
-   iOS 7 不支持 OpenUDID
@return string 设备的 OpenUDID 值
]]
function device.getOpenUDID()
    local ret = cc.Native:getOpenUDID()
    if DEBUG > 1 then
        printInfo("device.getOpenUDID() - Open UDID: %s", tostring(ret))
    end
    return ret
end

--[[--
用浏览器打开指定的网址
~~~ lua
-- 打开网页
device.openURL("http://dualface.github.com/quick-cocos2d-x/")
-- 打开设备上的邮件程序，并创建新邮件，填入收件人地址
device.openURL("mailto:nobody@mycompany.com")
-- 增加主题和内容
local subject = string.urlencode("Hello")
local body = string.urlencode("How are you ?")
device.openURL(string.format("mailto:nobody@mycompany.com?subject=%s&body=%s", subject, body))
-- 打开设备上的拨号程序
device.openURL("tel:123-456-7890")
~~~
@param string 网址，邮件，拨号等的字符串
]]
function device.openURL(url)
    if DEBUG > 1 then
        printInfo("device.openURL() - url: %s", tostring(url))
    end
    cc.Native:openURL(url)
end

--[[--
显示一个输入框，并返回用户输入的内容。
当用户点击取消按钮时，showInputBox() 函数返回空字符串。
@param string title 对话框标题
@param string message 提示信息
@param string defaultValue 输入框默认值
@return string 用户输入的字符串
]]
function device.showInputBox(title, message, defaultValue)
    title = tostring(title or "INPUT TEXT")
    message = tostring(message or "INPUT TEXT, CLICK OK BUTTON")
    defaultValue = tostring(defaultValue or "")
    if DEBUG > 1 then
        printInfo("device.showInputBox() - title: %s", tostring(title))
        printInfo("    message: %s", tostring(message))
        printInfo("    defaultValue: %s", tostring(defaultValue))
    end
    return cc.Native:getInputText(title, message, defaultValue)
end


--[[--
震动
@param int millisecond 震动时长(毫秒) (设置震动时长仅对android有效，默认200ms)
android 需要添加震动服务权限
<uses-permission android:name="android.permission.VIBRATE" />
]]

function device.vibrate(millisecond)
    if DEBUG > 1 then
        printInfo("device.vibrate(%s)", millisecond or "")
    end

    if device.platform == "android" then
        if millisecond then
            luaj.callStaticMethod("org/cocos2dx/util/PSNative", "vibrate", {millisecond}, "(I)V");
        else
            cc.Native:vibrate()
        end
    elseif device.platform == "ios" then
        cc.Native:vibrate()
    else
        printInfo("%s platform unsupporte vibrate", device.platform)
    end
end

--[[
获得系统时间，精确到微妙
@return cc_timeval
cc_timeval.tv_sec  seconds
cc_timeval.tv_usec microSeconds
~~~ lua
-- sample
local tm = device.gettime()
printInfo("%d:%d", tm.tv_sec, tm.tv_usec)
~~~
]]
function device.gettime()
    local tm = cc_timeval:new()
    CCTime:gettimeofdayCocos2d(tm, nil)

    if device.platform == "windows" then
        tm.tv_sec = os.time()
    end
    return tm
end

--[[
获得时间差，精确到毫秒
@param cc_timeval tm_start 开始时间
@param cc_timeval tm_end   结束时间
@return double             时间差(毫秒)
~~~ lua
-- sample
local tm_start = device.gettime()
--do something
local tm_end   = device.gettime()
local timesub  = device.timersub(tm_start, tm_end)
printInfo(timesub)
~~~
]]

function device.timersub(tm_start, tm_end)
    return CCTime:timersubCocos2d(tm_start, tm_end)
end

return device
