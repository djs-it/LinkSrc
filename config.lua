
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

--######## 应用区域 #######--
DNP_APP = {
    appName = "OverLap", 
    version = 1.1,
    
    id = {
        dnp = 10000004,                 -- DONOPO应用内部编号
        ios = "1087226557",              -- AppStore编码
        android = "com.donopo.helloKitty",   -- GooglePlay编码
    },

    storeUrl = {
        ios     = "itms-apps://itunes.apple.com/app/id%s",                -- iOS 商店地址
        android = "https://play.google.com/store/apps/details?id=%s",     -- Android商店地址
    },
    
    slotKey = "D*N@P#L0NGL1FE",         -- 存档加密
    confuseKey = 10240806,              -- 内存混淆
    gcInterval = 10,                    -- 垃圾回收频度(秒)
    gcBlock = 5000,                     -- 垃圾回收颗粒度(单元)
}

DNP_GAME = {
--    default_scene = "PlaneScene",
    ios = {
        leaderboards="Classic;Challenge",
        achievements= "White Queen;Mary X;Merida;Merida;Sophie;Elsa;Athena;Black Queen;Kamilah;Amphitrite;Nefertiti;Cinderella;Aphrodite;Rapunzel;Kareena;Pocahontas;Belle;Snow;Anna;Grimhilde;Ygritte;Cersei;Bulma;Sansa;Audrey;Marilyn;Scarlett;Wu Zetian;Liv;Halle;Nicole;Zooey;elizabeth I;Mary I;Sonja (Norway);Anne-Marie (Greece);Mary (Denmark);Rania (Jordan);Galadriel;Cleopatra VII;Sirikit (Thailand);Silvia (Sweden);Marie (France);Caroline (Naples);Amalia  (Greece);Isabella I;Catherine (Russia);Louise (Belgium);Eugenie  (French);Joséphine (French);Anna (Russia);Augusta (German);Esther (Persia);Farah (Iran);Louise (Prussia);Frederica (Greece);Paola (Belgium);Victoria;Elizabeth II;Maxima (Netherland);Cixi",
        separate = ";",
    },
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


--######## 日志区域 #######--
DNP_EVENT = {
    flurry = {
        ios     = "967FPWMY789FXZMDKBXV",
        android = "TB4STFPW85STXPH2Y8YB"
    }
}
DNP_DEBUG = {
    count = 0
}


--######## 调试区域 #######--
DNP_USE_FLURRY = true

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
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio >= 768/1024 then
            return {autoscale = "FIXED_HEIGHT"}
        end
    end
}
