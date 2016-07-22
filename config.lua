
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

--######## 应用区域 #######--
DNP_APP = {
    appName = "OverLap", 
    
    slotKey = "D*N@P#L0NGL1FE",         -- 存档加密
    confuseKey = 10240806,              -- 内存混淆
    gcInterval = 10,                    -- 垃圾回收频度(秒)
    gcBlock = 5000,                     -- 垃圾回收颗粒度(单元)
}

DNP_GAME = {
--    default_scene = "PlaneScene"
}

--######## 广告区域 #######--
DNP_AD = {
    platform = {unity="unity",vungle = "vungle", unity = "unity"},
    target = {
        vungle = "vungle",
        gdt = "gdt",
        unity = "unity",
    },

    vungle = {
        android = "com.donopo.helloKitty", --kt
        ios = "56e633b62e4d11793d00000a", --kt
    },

    unity = {
        android = "com.donopo.helloKitty", --kt
        ios = "1070802", --kt
    },

}


--######## 分享区域 #######--
DNP_SHARE = {
    wxScene = {
        chat = 0,
        friends = 1,
    },
    usingWeixin = false,                -- 是否采用微信分享
    wxAppId = "wx0ca6563dedb4f77d",      --kt
    wxSecret = "bee696f2b18c4572837cafc2db4ff217",   --kt
}


-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = false

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 960,
    height = 1440,
    autoscale = "FIXED_WIDTH",
--    autoscale = "FIXED_WIDTH",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio >= 768/1024 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "FIXED_HEIGHT"}
--            return {autoscale = "FIXED_HEIGHT"}
        end
    end
}
