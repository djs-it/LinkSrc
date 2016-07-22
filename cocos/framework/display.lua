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

local display = {}

local director = cc.Director:getInstance()
local view = director:getOpenGLView()

if not view then
    local width = 960
    local height = 640
    if CC_DESIGN_RESOLUTION then
        if CC_DESIGN_RESOLUTION.width then
            width = CC_DESIGN_RESOLUTION.width
        end
        if CC_DESIGN_RESOLUTION.height then
            height = CC_DESIGN_RESOLUTION.height
        end
    end
    view = cc.GLViewImpl:createWithRect("Cocos2d-Lua", cc.rect(0, 0, width, height))
    director:setOpenGLView(view)
end

local framesize = view:getFrameSize()
local textureCache = director:getTextureCache()
local spriteFrameCache = cc.SpriteFrameCache:getInstance()
local animationCache = cc.AnimationCache:getInstance()

-- auto scale
local function checkResolution(r)
    r.width = checknumber(r.width)
    r.height = checknumber(r.height)
    r.autoscale = string.upper(r.autoscale)
    assert(r.width > 0 and r.height > 0,
        string.format("display - invalid design resolution size %d, %d", r.width, r.height))
end

local function setDesignResolution(r, framesize)
    if r.autoscale == "FILL_ALL" then
        view:setDesignResolutionSize(framesize.width, framesize.height, cc.ResolutionPolicy.FILL_ALL)
    else
        local scaleX, scaleY = framesize.width / r.width, framesize.height / r.height
        local width, height = framesize.width, framesize.height
        if r.autoscale == "FIXED_WIDTH" then
            width = framesize.width / scaleX
            height = framesize.height / scaleX
            view:setDesignResolutionSize(width, height, cc.ResolutionPolicy.NO_BORDER)
        elseif r.autoscale == "FIXED_HEIGHT" then
            width = framesize.width / scaleY
            height = framesize.height / scaleY
            view:setDesignResolutionSize(width, height, cc.ResolutionPolicy.NO_BORDER)
        elseif r.autoscale == "EXACT_FIT" then
            view:setDesignResolutionSize(r.width, r.height, cc.ResolutionPolicy.EXACT_FIT)
        elseif r.autoscale == "NO_BORDER" then
            view:setDesignResolutionSize(r.width, r.height, cc.ResolutionPolicy.NO_BORDER)
        elseif r.autoscale == "SHOW_ALL" then
            view:setDesignResolutionSize(r.width, r.height, cc.ResolutionPolicy.SHOW_ALL)
        else
            printError(string.format("display - invalid r.autoscale \"%s\"", r.autoscale))
        end
    end
end

local function setConstants()
    local sizeInPixels = view:getFrameSize()
    display.sizeInPixels = {width = sizeInPixels.width, height = sizeInPixels.height}

    local viewsize = director:getWinSize()
    display.contentScaleFactor = director:getContentScaleFactor()
    display.size               = {width = viewsize.width, height = viewsize.height}
    display.width              = display.size.width
    display.height             = display.size.height
    display.cx                 = display.width / 2
    display.cy                 = display.height / 2
    display.c_left             = -display.width / 2
    display.c_right            = display.width / 2
    display.c_top              = display.height / 2
    display.c_bottom           = -display.height / 2
    display.left               = 0
    display.right              = display.width
    display.top                = display.height
    display.bottom             = 0
    display.center             = cc.p(display.cx, display.cy)
    display.left_top           = cc.p(display.left, display.top)
    display.left_bottom        = cc.p(display.left, display.bottom)
    display.left_center        = cc.p(display.left, display.cy)
    display.right_top          = cc.p(display.right, display.top)
    display.right_bottom       = cc.p(display.right, display.bottom)
    display.right_center       = cc.p(display.right, display.cy)
    display.top_center         = cc.p(display.cx, display.top)
    display.top_bottom         = cc.p(display.cx, display.bottom)

    printInfo(string.format("# display.sizeInPixels         = {width = %0.2f, height = %0.2f}", display.sizeInPixels.width, display.sizeInPixels.height))
    printInfo(string.format("# display.size                 = {width = %0.2f, height = %0.2f}", display.size.width, display.size.height))
    printInfo(string.format("# display.contentScaleFactor   = %0.2f", display.contentScaleFactor))
    printInfo(string.format("# display.width                = %0.2f", display.width))
    printInfo(string.format("# display.height               = %0.2f", display.height))
    printInfo(string.format("# display.cx                   = %0.2f", display.cx))
    printInfo(string.format("# display.cy                   = %0.2f", display.cy))
    printInfo(string.format("# display.left                 = %0.2f", display.left))
    printInfo(string.format("# display.right                = %0.2f", display.right))
    printInfo(string.format("# display.top                  = %0.2f", display.top))
    printInfo(string.format("# display.bottom               = %0.2f", display.bottom))
    printInfo(string.format("# display.c_left               = %0.2f", display.c_left))
    printInfo(string.format("# display.c_right              = %0.2f", display.c_right))
    printInfo(string.format("# display.c_top                = %0.2f", display.c_top))
    printInfo(string.format("# display.c_bottom             = %0.2f", display.c_bottom))
    printInfo(string.format("# display.center               = {x = %0.2f, y = %0.2f}", display.center.x, display.center.y))
    printInfo(string.format("# display.left_top             = {x = %0.2f, y = %0.2f}", display.left_top.x, display.left_top.y))
    printInfo(string.format("# display.left_bottom          = {x = %0.2f, y = %0.2f}", display.left_bottom.x, display.left_bottom.y))
    printInfo(string.format("# display.left_center          = {x = %0.2f, y = %0.2f}", display.left_center.x, display.left_center.y))
    printInfo(string.format("# display.right_top            = {x = %0.2f, y = %0.2f}", display.right_top.x, display.right_top.y))
    printInfo(string.format("# display.right_bottom         = {x = %0.2f, y = %0.2f}", display.right_bottom.x, display.right_bottom.y))
    printInfo(string.format("# display.right_center         = {x = %0.2f, y = %0.2f}", display.right_center.x, display.right_center.y))
    printInfo(string.format("# display.top_center           = {x = %0.2f, y = %0.2f}", display.top_center.x, display.top_center.y))
    printInfo(string.format("# display.top_bottom           = {x = %0.2f, y = %0.2f}", display.top_bottom.x, display.top_bottom.y))
    printInfo("#")
end

function display.setAutoScale(configs)
    if type(configs) ~= "table" then return end

    checkResolution(configs)
    if type(configs.callback) == "function" then
        local c = configs.callback(framesize)
        for k, v in pairs(c or {}) do
            configs[k] = v
        end
        checkResolution(configs)
    end

    setDesignResolution(configs, framesize)

    printInfo(string.format("# design resolution size       = {width = %0.2f, height = %0.2f}", configs.width, configs.height))
    printInfo(string.format("# design resolution autoscale  = %s", configs.autoscale))
    setConstants()
end

if type(CC_DESIGN_RESOLUTION) == "table" then
    display.setAutoScale(CC_DESIGN_RESOLUTION)
end

display.COLOR_WHITE = cc.c3b(255, 255, 255)
display.COLOR_BLACK = cc.c3b(0, 0, 0)
display.COLOR_RED   = cc.c3b(255, 0, 0)
display.COLOR_GREEN = cc.c3b(0, 255, 0)
display.COLOR_BLUE  = cc.c3b(0, 0, 255)

display.AUTO_SIZE      = 0
display.FIXED_SIZE     = 1
display.LEFT_TO_RIGHT  = 0
display.RIGHT_TO_LEFT  = 1
display.TOP_TO_BOTTOM  = 2
display.BOTTOM_TO_TOP  = 3

display.CENTER        = cc.p(0.5, 0.5)
display.LEFT_TOP      = cc.p(0, 1)
display.LEFT_BOTTOM   = cc.p(0, 0)
display.LEFT_CENTER   = cc.p(0, 0.5)
display.RIGHT_TOP     = cc.p(1, 1)
display.RIGHT_BOTTOM  = cc.p(1, 0)
display.RIGHT_CENTER  = cc.p(1, 0.5)
display.CENTER_TOP    = cc.p(0.5, 1)
display.CENTER_BOTTOM = cc.p(0.5, 0)

display.SCENE_TRANSITIONS = {
    CROSSFADE       = cc.TransitionCrossFade,
    FADE            = {cc.TransitionFade, cc.c3b(0, 0, 0)},
    FADEBL          = cc.TransitionFadeBL,
    FADEDOWN        = cc.TransitionFadeDown,
    FADETR          = cc.TransitionFadeTR,
    FADEUP          = cc.TransitionFadeUp,
    FLIPANGULAR     = {cc.TransitionFlipAngular, cc.TRANSITION_ORIENTATION_LEFT_OVER},
    FLIPX           = {cc.TransitionFlipX, cc.TRANSITION_ORIENTATION_LEFT_OVER},
    FLIPY           = {cc.TransitionFlipY, cc.TRANSITION_ORIENTATION_UP_OVER},
    JUMPZOOM        = cc.TransitionJumpZoom,
    MOVEINB         = cc.TransitionMoveInB,
    MOVEINL         = cc.TransitionMoveInL,
    MOVEINR         = cc.TransitionMoveInR,
    MOVEINT         = cc.TransitionMoveInT,
    PAGETURN        = {cc.TransitionPageTurn, false},
    ROTOZOOM        = cc.TransitionRotoZoom,
    SHRINKGROW      = cc.TransitionShrinkGrow,
    SLIDEINB        = cc.TransitionSlideInB,
    SLIDEINL        = cc.TransitionSlideInL,
    SLIDEINR        = cc.TransitionSlideInR,
    SLIDEINT        = cc.TransitionSlideInT,
    SPLITCOLS       = cc.TransitionSplitCols,
    SPLITROWS       = cc.TransitionSplitRows,
    TURNOFFTILES    = cc.TransitionTurnOffTiles,
    ZOOMFLIPANGULAR = cc.TransitionZoomFlipAngular,
    ZOOMFLIPX       = {cc.TransitionZoomFlipX, cc.TRANSITION_ORIENTATION_LEFT_OVER},
    ZOOMFLIPY       = {cc.TransitionZoomFlipY, cc.TRANSITION_ORIENTATION_UP_OVER},
}

display.TEXTURES_PIXEL_FORMAT = {}

display.DEFAULT_TTF_FONT        = "Arial"
display.DEFAULT_TTF_FONT_SIZE   = 32


local PARAMS_EMPTY = {}
local RECT_ZERO = cc.rect(0, 0, 0, 0)

local sceneIndex = 0
function display.newScene(name, params)
    params = params or PARAMS_EMPTY
    sceneIndex = sceneIndex + 1
    local scene
    if not params.physics then
        scene = cc.Scene:create()
    else
        scene = cc.Scene:createWithPhysics()
    end
    scene.name_ = string.format("%s:%d", name or "<unknown-scene>", sceneIndex)

    if params.transition then
        scene = display.wrapSceneWithTransition(scene, params.transition, params.time, params.more)
    end

    return scene
end

function display.wrapScene(scene, transition, time, more)
    local key = string.upper(tostring(transition))

    if key == "RANDOM" then
        local keys = table.keys(display.SCENE_TRANSITIONS)
        key = keys[math.random(1, #keys)]
    end

    if display.SCENE_TRANSITIONS[key] then
        local t = display.SCENE_TRANSITIONS[key]
        time = time or 0.2
        more = more or t[2]
        if type(t) == "table" then
            scene = t[1]:create(time, scene, more)
        else
            scene = t:create(time, scene)
        end
    else
        error(string.format("display.wrapScene() - invalid transition %s", tostring(transition)))
    end
    return scene
end

function display.runScene(newScene, transition, time, more)
    if director:getRunningScene() then
        if transition then
            newScene = display.wrapScene(newScene, transition, time, more)
        end
        director:replaceScene(newScene)
    else
        director:runWithScene(newScene)
    end
end

function display.getRunningScene()
    return director:getRunningScene()
end

function display.newNode()
    return cc.Node:create()
end

function display.newLayer(...)
    local params = {...}
    local c = #params
    local layer
    if c == 0 then
        -- /** creates a fullscreen black layer */
        -- static Layer *create();
        layer = cc.Layer:create()
    elseif c == 1 then
        -- /** creates a Layer with color. Width and height are the window size. */
        -- static LayerColor * create(const Color4B& color);
        layer = cc.LayerColor:create(cc.convertColor(params[1], "4b"))
    elseif c == 2 then
        -- /** creates a Layer with color, width and height in Points */
        -- static LayerColor * create(const Color4B& color, const Size& size);
        --
        -- /** Creates a full-screen Layer with a gradient between start and end. */
        -- static LayerGradient* create(const Color4B& start, const Color4B& end);
        local color1 = cc.convertColor(params[1], "4b")
        local p2 = params[2]
        assert(type(p2) == "table" and (p2.width or p2.r), "display.newLayer() - invalid paramerter 2")
        if p2.r then
            layer = cc.LayerGradient:create(color1, cc.convertColor(p2, "4b"))
        else
            layer = cc.LayerColor:create(color1, p2.width, p2.height)
        end
    elseif c == 3 then
        -- /** creates a Layer with color, width and height in Points */
        -- static LayerColor * create(const Color4B& color, GLfloat width, GLfloat height);
        --
        -- /** Creates a full-screen Layer with a gradient between start and end in the direction of v. */
        -- static LayerGradient* create(const Color4B& start, const Color4B& end, const Vec2& v);
        local color1 = cc.convertColor(params[1], "4b")
        local p2 = params[2]
        local p2type = type(p2)
        if p2type == "table" then
            layer = cc.LayerGradient:create(color1, cc.convertColor(p2, "4b"), params[3])
        else
            layer = cc.LayerColor:create(color1, p2, params[3])
        end
    end
    return layer
end

--function display.newSprite(source, x, y, params)
--    local spriteClass = cc.Sprite
--    local scale9 = false
--
--    if type(x) == "table" and not x.x then
--        -- x is params
--        params = x
--        x = nil
--        y = nil
--    end
--
--    local params = params or PARAMS_EMPTY
--    if params.scale9 or params.capInsets then
--        spriteClass = ccui.Scale9Sprite
--        scale9 = true
--        params.capInsets = params.capInsets or RECT_ZERO
--        params.rect = params.rect or RECT_ZERO
--    end
--
--    local sprite
--    while true do
--        -- create sprite
--        if not source then
--            sprite = spriteClass:create()
--            break
--        end
--
--        local sourceType = type(source)
--        if sourceType == "string" then
--            if string.byte(source) == 35 then -- first char is #
--                -- create sprite from spriteFrame
--                if not scale9 then
--                    sprite = spriteClass:createWithSpriteFrameName(string.sub(source, 2))
--                else
--                    sprite = spriteClass:createWithSpriteFrameName(string.sub(source, 2), params.capInsets)
--                end
--                break
--            end
--
--            -- create sprite from image file
--            if display.TEXTURES_PIXEL_FORMAT[source] then
--                cc.Texture2D:setDefaultAlphaPixelFormat(display.TEXTURES_PIXEL_FORMAT[source])
--            end
--            if not scale9 then
--                sprite = spriteClass:create(source)
--            else
--                sprite = spriteClass:create(source, params.rect, params.capInsets)
--            end
--            if display.TEXTURES_PIXEL_FORMAT[source] then
--                cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)
--            end
--            break
--        elseif sourceType ~= "userdata" then
--            error(string.format("display.newSprite() - invalid source type \"%s\"", sourceType), 0)
--        else
--            sourceType = tolua.type(source)
--            if sourceType == "cc.SpriteFrame" then
--                if not scale9 then
--                    sprite = spriteClass:createWithSpriteFrame(source)
--                else
--                    sprite = spriteClass:createWithSpriteFrame(source, params.capInsets)
--                end
--            elseif sourceType == "cc.Texture2D" then
--                sprite = spriteClass:createWithTexture(source)
--            else
--                error(string.format("display.newSprite() - invalid source type \"%s\"", sourceType), 0)
--            end
--        end
--        break
--    end
--
--    if sprite then
--        if x and y then sprite:setPosition(x, y) end
--        if params.size then sprite:setContentSize(params.size) end
--    else
--        error(string.format("display.newSprite() - create sprite failure, source \"%s\"", tostring(source)), 0)
--    end
--
--    return sprite
--end


-- start --

--------------------------------
-- 创建并返回一个 Sprite 显示对象。
-- @function [parent=#display] newSprite
-- @param mixed 图像名或SpriteFrame对象
-- @param number x
-- @param number y
-- @param table params
-- @return Sprite#Sprite ret (return value: cc.Sprite)
-- @see Sprite


--[[--

创建并返回一个 Sprite 显示对象。

display.newSprite() 有三种方式创建显示对象：

-   从图片文件创建
-   从缓存的图像帧创建
-   从 SpriteFrame 对象创建

~~~ lua

-- 从图片文件创建显示对象
local sprite1 = display.newSprite("hello1.png")

-- 从缓存的图像帧创建显示对象
-- 图像帧的名字就是图片文件名，但为了和图片文件名区分，所以此处需要在文件名前添加 “#” 字符
-- 添加 “#” 的规则适用于所有需要区分图像和图像帧的地方
local sprite2 = display.newSprite("#frame0001.png")

-- 从 SpriteFrame 对象创建
local frame = display.newFrame("frame0002.png")
local sprite3 = display.newSprite(frame)

~~~

如果指定了 x,y 参数，那么创建显示对象后会调用对象的 setPosition() 方法设置对象位置。

]]
-- end --

function display.newSprite(filename, x, y, params)
    local spriteClass = nil
    local size = nil

    if params then
        spriteClass = params.class
        size = params.size
    end
    if not spriteClass then spriteClass = cc.Sprite end

    local t = type(filename)
    if t == "userdata" then t = tolua.type(filename) end
    local sprite

    if not filename then
        sprite = spriteClass:create()
    elseif t == "string" then
        if string.byte(filename) == 35 then -- first char is #
            local frame = display.newSpriteFrame(string.sub(filename, 2))
            if frame then
                if params and params.capInsets then
                    sprite = spriteClass:createWithSpriteFrame(frame, params.capInsets)
                else
                    sprite = spriteClass:createWithSpriteFrame(frame)
                end
            end
        else
            if display.TEXTURES_PIXEL_FORMAT[filename] then
                cc.Texture2D:setDefaultAlphaPixelFormat(display.TEXTURES_PIXEL_FORMAT[filename])
                sprite = spriteClass:create(filename)
                cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2D_PIXEL_FORMAT_RGBA8888)
            else
                if params and params.capInsets then
                    sprite = spriteClass:create(params.capInsets, filename)
                else
                    sprite = spriteClass:create(filename)
                end
            end
        end
    elseif t == "cc.SpriteFrame" then
        sprite = spriteClass:createWithSpriteFrame(filename)
    elseif t == "cc.Texture2D" then
        sprite = spriteClass:createWithTexture(filename)
    else
        printError("display.newSprite() - invalid filename value type")
        sprite = spriteClass:create()
    end

    if sprite then
        if x and y then sprite:setPosition(x, y) end
        if size then sprite:setContentSize(size) end
    else
        printError("display.newSprite() - create sprite failure, filename %s", tostring(filename))
        sprite = spriteClass:create()
    end

    return sprite
end

function display.newSpriteFrame(source, ...)
    local frame
    if type(source) == "string" then
        if string.byte(source) == 35 then -- first char is #
            source = string.sub(source, 2)
        end
        frame = spriteFrameCache:getSpriteFrame(source)
        if not frame then
            error(string.format("display.newSpriteFrame() - invalid frame name \"%s\"", tostring(source)), 0)
        end
    elseif tolua.type(source) == "cc.Texture2D" then
        frame = cc.SpriteFrame:createWithTexture(source, ...)
    else
        error("display.newSpriteFrame() - invalid parameters", 0)
    end
    return frame
end

function display.newFrames(pattern, begin, length, isReversed)
    local frames = {}
    local step = 1
    local last = begin + length - 1
    if isReversed then
        last, begin = begin, last
        step = -1
    end

    for index = begin, last, step do
        local frameName = string.format(pattern, index)
        local frame = spriteFrameCache:getSpriteFrame(frameName)
        if not frame then
            error(string.format("display.newFrames() - invalid frame name %s", tostring(frameName)), 0)
        end
        frames[#frames + 1] = frame
    end
    return frames
end

local function newAnimation(frames, time)
    local count = #frames
    assert(count > 0, "display.newAnimation() - invalid frames")
    time = time or 1.0 / count
    return cc.Animation:createWithSpriteFrames(frames, time),
        cc.Sprite:createWithSpriteFrame(frames[1])
end

function display.newAnimation(...)
    local params = {...}
    local c = #params
    if c == 2 then
        -- frames, time
        return newAnimation(params[1], params[2])
    elseif c == 4 then
        -- pattern, begin, length, time
        local frames = display.newFrames(params[1], params[2], params[3])
        return newAnimation(frames, params[4])
    elseif c == 5 then
        -- pattern, begin, length, isReversed, time
        local frames = display.newFrames(params[1], params[2], params[3], params[4])
        return newAnimation(frames, params[5])
    else
        error("display.newAnimation() - invalid parameters")
    end
end

function display.loadImage(imageFilename, callback)
    if not callback then
        return textureCache:addImage(imageFilename)
    else
        textureCache:addImageAsync(imageFilename, callback)
    end
end

local fileUtils = cc.FileUtils:getInstance()
function display.getImage(imageFilename)
    local fullpath = fileUtils:fullPathForFilename(imageFilename)
    return textureCache:getTextureForKey(fullpath)
end

function display.removeImage(imageFilename)
    textureCache:removeTextureForKey(imageFilename)
end

function display.loadSpriteFrames(dataFilename, imageFilename, callback)
    if display.TEXTURES_PIXEL_FORMAT[imageFilename] then
        cc.Texture2D:setDefaultAlphaPixelFormat(display.TEXTURES_PIXEL_FORMAT[imageFilename])
    end
    if not callback then
        spriteFrameCache:addSpriteFrames(dataFilename, imageFilename)
    else
        spriteFrameCache:addSpriteFramesAsync(dataFilename, imageFilename, callback)
    end
    if display.TEXTURES_PIXEL_FORMAT[imageFilename] then
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)
    end
end

function display.removeSpriteFrames(dataFilename, imageFilename)
    spriteFrameCache:removeSpriteFramesFromFile(dataFilename)
    if imageFilename then
        display.removeImage(imageFilename)
    end
end

function display.removeSpriteFrame(imageFilename)
    spriteFrameCache:removeSpriteFrameByName(imageFilename)
end

function display.setTexturePixelFormat(imageFilename, format)
    display.TEXTURES_PIXEL_FORMAT[imageFilename] = format
end

function display.setAnimationCache(name, animation)
    animationCache:addAnimation(animation, name)
end

function display.getAnimationCache(name)
    return animationCache:getAnimation(name)
end

function display.removeAnimationCache(name)
    animationCache:removeAnimation(name)
end

function display.removeUnusedSpriteFrames()
    spriteFrameCache:removeUnusedSpriteFrames()
    textureCache:removeUnusedTextures()
end


-- start --

--------------------------------
-- 暂停当前场景
-- @function [parent=#display] pause

-- end --

function display.pause()
    director:pause()
end

-- start --

--------------------------------
-- 恢复当前暂停的场景
-- @function [parent=#display] resume

-- end --

function display.resume()
    director:resume()
end


-- start --

--------------------------------
-- 创建并返回一个平铺的 Sprite 显示对象
-- @function [parent=#display] newTilesSprite
-- @param string filename 图像名
-- @param cc.rect rect    平铺范围
-- @return Sprite#Sprite ret (return value: cc.Sprite)

-- end --

function display.newTilesSprite(filename, rect)
    if not rect then
        rect = cc.rect(0, 0, display.width, display.height)
    end
    local sprite = cc.Sprite:create(filename, rect)
    if not sprite then
        printError("display.newTilesSprite() - create sprite failure, filename %s", tostring(filename))
        return
    end

    sprite:getTexture():setTexParameters(gl.LINEAR, gl.LINEAR, gl.REPEAT, gl.REPEAT)

    display.align(sprite, display.LEFT_BOTTOM, 0, 0)

    return sprite
end

-- start --

--------------------------------
-- create a tiled SpriteBatchNode, the image can not a POT file.
-- @function [parent=#display] newTiledBatchNode
-- @param mixed filename As same a the first parameter for display.newSprite
-- @param string plistFile Texture(plist) image filename, filename must be a part of the texture.
-- @param size size The tiled node size, use cc.size create it please.
-- @param integer hPadding Horizontal padding, it will display 1 px gap on moving the node, set padding for fix it.
-- @param integer vPadding Vertical padding.
-- @return SpriteBatchNode#SpriteBatchNode ret (return value: cc.SpriteBatchNode)

-- end --

function display.newTiledBatchNode(filename, plistFile, size, hPadding, vPadding)
    size = size or cc.size(display.width, display.height)
    hPadding = hPadding or 0
    vPadding = vPadding or 0
    local __sprite = display.newSprite(filename)
    local __sliceSize = __sprite:getContentSize()
    __sliceSize.width = __sliceSize.width - hPadding
    __sliceSize.height = __sliceSize.height - vPadding
    local __xRepeat = math.ceil(size.width/__sliceSize.width)
    local __yRepeat = math.ceil(size.height/__sliceSize.height)
    -- How maney sprites we need to fill in tiled node?
    local __capacity = __xRepeat * __yRepeat
    local __batch = display.newBatchNode(plistFile, __capacity)
    local __newSize = cc.size(0,0)

    for y=0,__yRepeat-1 do
        for x=0,__xRepeat-1 do
            __newSize.width = __newSize.width + __sliceSize.width
            __sprite = display.newSprite(filename)
                :align(display.LEFT_BOTTOM,x*__sliceSize.width, y*__sliceSize.height)
                :addTo(__batch)
        end
        __newSize.height = __newSize.height + __sliceSize.height
    end
    __batch:setContentSize(__newSize)

    return __batch, __newSize.width, __newSize.height
end

-- start --

--------------------------------
-- Create a Filtered Sprite
-- @function [parent=#display] newFilteredSprite
-- @param mixed filename As same a the first parameter for display.newSprite
-- @param mixed filters One of the following:
-- @param table params A or some parameters for Filter.
-- @return FilteredSprite#FilteredSprite ret (return value: cc.FilteredSprite)

-- end --

function display.newFilteredSprite(filename, filters, params)
    local __one = {class=cc.FilteredSpriteWithOne}
    local __multi = {class=cc.FilteredSpriteWithMulti}
    if not filters then return display.newSprite(filename, nil,nil , __one) end
    local __sp = nil
    local __type = type(filters)
    if __type == "userdata" then __type = tolua.type(filters) end
    --print("display.newFSprite type:", __type)
    if __type == "string" then
        __sp = display.newSprite(filename, nil, nil, __one)
        filters = filter.newFilter(filters, params)
        __sp:setFilter(filters)
    elseif __type == "table" then
        assert(#filters > 1, "display.newFilteredSprite() - Please give me 2 or more filters!")
        __sp = display.newSprite(filename, nil, nil, __multi)
        -- treat filters as {"FILTER_NAME", "FILTER_NAME"}
        if type(filters[1]) == "string" then
            __sp:setFilters(filter.newFilters(filters, params))
        else
            -- treat filters as {Filter, Filter , ...}
            local __filters = cc.Array:create()
            for i in ipairs(filters) do
                __filters:addObject(filters[i])
            end
            __sp:setFilters(__filters)
        end
    elseif __type == "Array" then
        -- treat filters as Array(Filter, Filter, ...)
        __sp = display.newSprite(filename, nil, nil, __multi)
        __sp:setFilters(filters)
    else
        -- treat filters as Filter
        __sp = display.newSprite(filename, nil, nil, __one)
        __sp:setFilter(filters)
    end
    return __sp
end


-- start --

--------------------------------
-- Create a Filtered Sprite
-- @function [parent=#display] newFilteredSprite
-- @param mixed filename As same a the first parameter for display.newSprite
-- @param mixed filters One of the following:
-- @param table params A or some parameters for Filter.
-- @return ShaderSprite#ShaderSprite ret (return value: dnp.ShaderSprite)

-- end --

function display.newShaderSprite(filename, shaders,param)
    if not shaders then return display.newSprite(filename) end
    local __sp = nil
    if shaders then
        __sp =  shader.newShader(shaders, filename)
        if shaders == shader.ghost then
            if string.byte(filename) == 35 then -- first char is #
                __sp:init(display.newSpriteFrame(filename))
             else
                __sp:init(display.newSprite(filename))
            end
        end
    end
    if param then
        if shaders == shader.laser then
            if #param == 4 then
                __sp:setLight(param[1],param[2],param[3],param[4])
            else
                assert( #param == 4, "d shader.laser - invalid paramerters number 4")
            end
        elseif shaders == shader.ripple then
        elseif shaders == shader.ghost then
            __sp:init(display.newSprite(filename))
        end
    end
    if __sp  then
        __sp:setShader()
    end
    return __sp
end





-- start --

--------------------------------
-- Create a Gray Sprite by FilteredSprite
-- @function [parent=#display] newGraySprite
-- @param mixed filename As same a the first parameter for display.newSprite
-- @param table params As same as the third parameter for display.newFilteredSprite
-- @return FilteredSprite#FilteredSprite ret (return value: cc.FilteredSprite)

-- end --

function display.newGraySprite(filename, params)
    return display.newFilteredSprite(filename, "GRAY", params)
end

-- start --

--------------------------------
-- 创建并返回一个空的 DrawNode 对象
-- @function [parent=#display] newDrawNode
-- @return DrawNode#DrawNode ret (return value: cc.DrawNode)
-- @see DrawNode

-- end --

function display.newDrawNode()
    return cc.DrawNode:create()
end

-- start --

--------------------------------
-- 创建并返回一个 DrawNode（实心圆）对象。
-- @function [parent=#display] newSolidCircle
-- @param number radius 实心圆的半径
-- @param table params 创建圆的参数 x,y为圆点位置 color中圆的颜色
-- @return DrawNode#DrawNode ret (return value: cc.DrawNode)
-- @see DrawNode


--[[--

创建并返回一个 DrawNode（实心圆）对象。

~~~ lua

local circle = display.newSolidCircle(10, {x = 150, y = 150, color = cc.c4f(1, 1, 1, 1)})
circle:addTo(scene)

~~~

]]
-- end --

function display.newSolidCircle(radius, params)
    local circle = display.newDrawNode()
    circle:drawDot(cc.p(params.x or 0, params.y or 0),
        radius or 0, params.color or cc.c4f(0, 0, 0, 1))
    return circle
end

-- start --

--------------------------------
-- 创建并返回一个 DrawNode （圆）对象。
-- @function [parent=#display] newCircle
-- @param number radius
-- @param table params 有参数，x,y 圆的位置 填充色 fillColor, 边线色 borderColor 及边线宽度 borderWidth
-- @return DrawNode#DrawNode ret (return value: cc.DrawNode)
-- @see DrawNode


--[[--

创建并返回一个 DrawNode （圆）对象。

~~~ lua

--创建一个半径为50, 圆心在(100,100),中间填充为红色,边线为绿色,边线的宽度为2 的圆
local circle = display.newCircle(50,
{x = 100, y = 100,
fillColor = cc.c4f(1, 0, 0, 1),
borderColor = cc.c4f(0, 1, 0, 1),
borderWidth = 2})

~~~

]]
-- end --

function display.newCircle(radius, params)
    params = checktable(params)

    local function makeVertexs(radius)
        local segments = params.segments or 32
        local startRadian = 0
        local endRadian = math.pi * 2
        local posX = params.x or 0
        local posY = params.y or 0
        if params.startAngle then
            startRadian = math.angle2radian(params.startAngle)
        end
        if params.endAngle then
            endRadian = startRadian + math.angle2radian(params.endAngle)
        end
        local radianPerSegm = 2 * math.pi / segments
        local points = {}
        for i = 1, segments do
            local radii = startRadian + i * radianPerSegm
            if radii > endRadian then break end
            points[#points + 1] = {posX + radius * math.cos(radii), posY + radius * math.sin(radii)}
        end
        return points
    end

    local points = makeVertexs(radius)
    local circle = display.newPolygon(points, params)
    if circle then
        circle.radius = radius
        circle.params = params

        function circle:setRadius(radius)
            self:clear()
            local points = makeVertexs(radius)
            display.newPolygon(points, params, self)
        end

        function circle:setLineColor(color)
            self:clear()
            local points = makeVertexs(radius)
            params.borderColor = color
            display.newPolygon(points, params, self)
        end
    end
    return circle
end

-- start --

--------------------------------
-- 创建并返回一个 DrawNode （矩形）对象。
-- @function [parent=#display] newRect
-- @param table rect table
-- @param table params 有参数，填充色 fillColor, 边线色 borderColor 及边线宽度 borderWidth
-- @return DrawNode#DrawNode ret (return value: cc.DrawNode)
-- @see ShapeNode


--[[--

创建并返回一个 DrawNode （矩形）对象。

格式：

shape = display.newRect(rect表, [参数])

~~~ lua

-- 创建一个宽度 200，高度 100 的矩形，并且定位于 50, 80
local shape3 = display.newRect(cc.rect(50, 80, 200, 100))

-- 创建一个宽度 100, 高度 100 的矩形，并定位于 40,40
-- 并设置它的中间填充色 fillColor, 边线色 borderColor 及边线宽度 borderWidth
local shape4 = display.newRect(cc.rect(100, 100, 40, 40),
{fillColor = cc.c4f(1,0,0,1), borderColor = cc.c4f(0,1,0,1), borderWidth = 5})

~~~

]]
-- end --

function display.newRect(rect, params)
    local x, y, width, height = 0, 0
    x = rect.x or 0
    y = rect.y or 0
    height = rect.height
    width = rect.width

    local points = {
        {x,y},
        {x + width, y},
        {x + width, y + height},
        {x, y + height}
    }
    return display.newPolygon(points, params)
end

-- start --

--------------------------------
-- 创建并返回一个 DrawNode （线性）对象。
-- @function [parent=#display] newLine
-- @param table point table
-- @param table params 有参数，边线色 borderColor 及边线宽度 borderWidth
-- @return DrawNode#DrawNode ret (return value: cc.DrawNode)
-- @see ShapeNode


--[[--

创建并返回一个 DrawNode （线性）对象。

格式：

shape = display.newLine(point表, [参数])

~~~ lua

-- 创建一个线宽为2，颜色为红色，从(10,10)到(100,100)的线段
local shape3 = display.newLine({(10, 10), (100,100)},
{borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0),
borderWidth = 1})

~~~

]]
-- end --

function display.newLine(points, params)
    local radius
    local borderColor
    local scale

    if not params then
        borderColor = cc.c4f(0,0,0,1)
        radius = 0.5
        scale = 1.0
    else
        borderColor = params.borderColor or cc.c4f(0,0,0,1)
        radius = (params.borderWidth and params.borderWidth/2) or 0.5
        scale = checknumber(params.scale or 1.0)
    end

    for i, p in ipairs(points) do
        p = cc.p(p[1] * scale, p[2] * scale)
        points[i] = p
    end

    local drawNode = cc.DrawNode:create()
    drawNode:drawSegment(points[1], points[2], radius, borderColor)

    return drawNode
end

-- start --

--------------------------------
-- 创建并返回一个 PolygonShape （多边形）对象。
-- @function [parent=#display] newPolygon
-- @param table points 包含多边形每一个点坐标的表格对象
-- @param number scale 缩放比例
-- @return DrawNode#DrawNode ret (return value: cc.DrawNode)  DrawNode
-- @see DrawNode


--[[--

创建并返回一个 PolygonShape （多边形）对象。

~~~ lua

local points = {
{10, 10},  -- point 1
{50, 50},  -- point 2
{100, 10}, -- point 3
}
local polygon = display.newPolygon(points)

~~~

]]
-- end --

function display.newPolygon(points, params, drawNode)
    params = checktable(params)
    local scale = checknumber(params.scale or 1.0)
    local borderWidth = checknumber(params.borderWidth or 0.5)
    local fillColor = params.fillColor or cc.c4f(1, 1, 1, 0)
    local borderColor = params.borderColor or cc.c4f(0, 0, 0, 1)

    local pts = {}
    for i, p in ipairs(points) do
        pts[i] = {x = p[1] * scale, y = p[2] * scale}
    end

    drawNode = drawNode or cc.DrawNode:create()
    drawNode:drawPolygon(pts, {
        fillColor = fillColor,
        borderWidth = borderWidth,
        borderColor = borderColor
    })

    if drawNode then
        function drawNode:setLineStipple()
        end

        function drawNode:setLineStippleEnabled()
        end

        function drawNode:setLineColor(color)
        end
    end
    return drawNode
end

-- start --

--------------------------------
-- 用位图字体创建文本显示对象，并返回 Label 对象。
-- @function [parent=#display] newBMFontLabel
-- @param table params 参数表格对象
-- @return Label#Label ret (return value: cc.Label)  Label对象

--[[--

用位图字体创建文本显示对象，并返回 Label 对象。

BMFont 通常用于显示英文内容，因为英文字母加数字和常用符号也不多，生成的 BMFont 文件较小。如果是中文，应该用 TTFLabel。

可用参数：

-    text: 要显示的文本
-    font: 字体文件名
-    align: 文字的水平对齐方式（可选）
-    maxLineWidth: 最大行宽（可选）
-    offsetX: 图像的X偏移量（可选）
-    offsetY: 图像的Y偏移量（可选）
-    x, y: 坐标（可选）

~~~ lua

local label = display.newBMFontLabel({
text = "Hello",
font = "UIFont.fnt",
})

~~~

]]
-- end --

function display.newBMFontLabel(params)
    assert(type(params) == "table",
        "[framework.display] newBMFontLabel() invalid params")

    local text      = tostring(params.text)
    local font      = params.font
    local textAlign = params.align or cc.TEXT_ALIGNMENT_LEFT
    local maxLineW  = params.maxLineWidth or 0
    local offsetX   = params.offsetX or 0
    local offsetY   = params.offsetY or 0
    local x, y      = params.x, params.y
    assert(font ~= nil, "framework.display.newBMFontLabel() - not set font")

    local label = cc.Label:createWithBMFont(font, text, textAlign, maxLineW, cc.p(offsetX, offsetY));
    if not label then return end

    if type(x) == "number" and type(y) == "number" then
        label:setPosition(x, y)
    end

    return label
end

-- start --

--------------------------------
-- 使用 TTF 字体创建文字显示对象，并返回 Label 对象。
-- @function [parent=#display] newTTFLabel
-- @param table params 参数表格对象
-- @return Label#Label ret (return value: cc.Label)  Label对象

--[[--

使用 TTF 字体创建文字显示对象，并返回 Label 对象。

可用参数：

-    text: 要显示的文本
-    font: 字体名，如果是非系统自带的 TTF 字体，那么指定为字体文件名
-    size: 文字尺寸，因为是 TTF 字体，所以可以任意指定尺寸
-    color: 文字颜色（可选），用 cc.c3b() 指定，默认为白色
-    align: 文字的水平对齐方式（可选）
-    valign: 文字的垂直对齐方式（可选），仅在指定了 dimensions 参数时有效
-    dimensions: 文字显示对象的尺寸（可选），使用 cc.size() 指定
-    x, y: 坐标（可选）

align 和 valign 参数可用的值：

-    cc.TEXT_ALIGNMENT_LEFT 左对齐
-    cc.TEXT_ALIGNMENT_CENTER 水平居中对齐
-    cc.TEXT_ALIGNMENT_RIGHT 右对齐
-    cc.VERTICAL_TEXT_ALIGNMENT_TOP 垂直顶部对齐
-    cc.VERTICAL_TEXT_ALIGNMENT_CENTER 垂直居中对齐
-    cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM 垂直底部对齐

~~~ lua

-- 创建一个居中对齐的文字显示对象
local label = display.newTTFLabel({
text = "Hello, World",
font = "Marker Felt",
size = 64,
align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
})

-- 左对齐，并且多行文字顶部对齐
local label = display.newTTFLabel({
text = "Hello, World\n您好，世界",
font = "Arial",
size = 64,
color = cc.c3b(255, 0, 0), -- 使用纯红色
align = cc.TEXT_ALIGNMENT_LEFT,
valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
dimensions = cc.size(400, 200)
})

~~~

]]
-- end --

function display.newTTFLabel(params)
    assert(type(params) == "table",
        "[framework.display] newTTFLabel() invalid params")

    local text       = tostring(params.text)
    local font       = params.font or display.DEFAULT_TTF_FONT
    local size       = params.size or display.DEFAULT_TTF_FONT_SIZE
    local color      = params.color or display.COLOR_WHITE
    local textAlign  = params.align or cc.TEXT_ALIGNMENT_LEFT
    local textValign = params.valign or cc.VERTICAL_TEXT_ALIGNMENT_TOP
    local x, y       = params.x, params.y
    local dimensions = params.dimensions or cc.size(0, 0)

    assert(type(size) == "number",
        "[framework.display] newTTFLabel() invalid params.size")

    local label
    if cc.FileUtils:getInstance():isFileExist(font) then
        label = cc.Label:createWithTTF(text, font, size, dimensions, textAlign, textValign)
        if label then
            label:setColor(color)
        end
    else
        label = cc.Label:createWithSystemFont(text, font, size, dimensions, textAlign, textValign)
        if label then
            label:setTextColor(color)
        end
    end

    if label then
        if x and y then label:setPosition(x, y) end
    end

    return label
end

-- start --

--------------------------------
-- 将指定的显示对象按照特定锚点对齐。
-- @function [parent=#display] align
-- @param Sprite target 显示对象
-- @param integer anchorPoint 锚点位置
-- @param integer x
-- @param integer y


--[[--

将指定的显示对象按照特定锚点对齐。

格式：

display.align(显示对象, 锚点位置, [x, y])

显示对象锚点位置：

-   display.CENTER 图像中央
-   display.LEFT_TOP,
-   display.TOP_LEFT 图像左上角
-   display.CENTER_TOP,
-   display.TOP_CENTER 图像顶部的中间
-   display.RIGHT_TOP,
-   display.TOP_RIGHT 图像顶部的中间
-   display.CENTER_LEFT,
-   display.LEFT_CENTER 图像左边的中间
-   display.CENTER_RIGHT,
-   display.RIGHT_CENTER 图像右边的中间
-   display.BOTTOM_LEFT,
-   display.LEFT_BOTTOM 图像左边的底部
-   display.BOTTOM_RIGHT,
-   display.RIGHT_BOTTOM 图像右边的底部
-   display.BOTTOM_CENTER,
-   display.CENTER_BOTTOM 图像中间的底部

~~~ lua

-- 将图像按左上角对齐，并放置在屏幕左上角
display.align(sprite, display.LEFT_TOP, 0, 0)

~~~

]]
-- end --

function display.align(target, anchorPoint, x, y)
    target:setAnchorPoint(display.ANCHOR_POINTS[anchorPoint])
    if x and y then target:setPosition(x, y) end
end


-- start --

--------------------------------
-- 从指定的图像文件创建并返回一个批量渲染对象。
-- @function [parent=#display] newBatchNode
-- @param string image 图像文件名
-- @param integer capacity
-- @return SpriteBatchNode#SpriteBatchNode ret (return value: cc.SpriteBatchNode)
-- @see Batch Node

--[[--

从指定的图像文件创建并返回一个批量渲染对象。

~~~ lua

local imageName = "Sprites.png"
display.addSpriteFrames("Sprites.plist", imageName) -- 载入图像到帧缓存

-- 下面的代码绘制 100 个图像只用了 1 次 OpenGL draw call
local batch = display.newBatchNode(imageName)
for i = 1, 100 do
local sprite = display.newSprite("#Sprite0001.png")
batch:addChild(sprite)
end

-- 下面的代码绘制 100 个图像则要使用 100 次 OpenGL draw call
local group = display.newNode()
for i = 1, 100 do
local sprite = display.newSprite("#Sprite0001.png")
group:addChild(sprite)
end

~~~

]]
-- end --

function display.newBatchNode(image, capacity)
    return cc.SpriteBatchNode:create(image, capacity or 100)
end


-- start --

--------------------------------
-- 创建一个进度条的节点
-- @function [parent=#display] newProgressTimer
-- @param mixed image
-- @param number progressType

--[[--

创建一个进度条的节点

进度条类型有:

- display.PROGRESS_TIMER_BAR
- display.PROGRESS_TIMER_RADIAL 环形

]]

-- end --

display.PROGRESS_TIMER_BAR = 1
display.PROGRESS_TIMER_RADIAL = 0

function display.newProgressTimer(image, progresssType)
    if type(image) == "string" then
        image = display.newSprite(image)
    end

    local progress = cc.ProgressTimer:create(image)
    progress:setType(progresssType)
    return progress
end

-- start --

--------------------------------
-- 截屏并保存为一个文件
-- @function [parent=#display] captureScreen
-- @param function callback 截屏的回调函数
-- @param string fileName 保存的文件, 绝对路径就直接保存, 只有文件名会保存在writePath下

--[[--

~~~ lua

display.captureScreen(
function (bSuc, filePath)
--bSuc 截屏是否成功
--filePath 文件保存所在的绝对路径
end, "screen.png")

~~~

]]

-- end --

function display.captureScreen(callback, fileName)
    cc.utils:captureScreen(callback, fileName)
end



return display
