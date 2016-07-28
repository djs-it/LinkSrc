if not DNP_DEBUG then
    sopackeage = {}
    for k, v in pairs(package.loaded) do
        sopackeage[k] = v
    end
end

local function cleanPackage()
    for k, v in pairs(package.loaded) do
        if not  sopackeage[k] then
            package.loaded[k] = nil
        end
    end
end


if DNP_DEBUG  then
    DNP_DEBUG.count = DNP_DEBUG.count + 1
    timer:killAll()
    cleanPackage()
end

cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("src/app/")
cc.FileUtils:getInstance():addSearchPath("res/")
cc.FileUtils:getInstance():addSearchPath("res/studio/")
cc.FileUtils:getInstance():addSearchPath("res/studio/views/")

require "config"
require "cocos.init"
require "util.init"
require "fmw.init"
require "app.init"


local function main()
    require("app.MyApp"):create():run()

--    local scene = display.newScene()
--    
--    display.newSprite("f1.png")
--    :move(400,400)
--    :addTo(scene)
--    
--    display.runScene(scene)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
