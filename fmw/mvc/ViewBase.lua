-----------------------------------------
--视图基础类
--
--
local ViewBase = class("ViewBase", cc.Node)

function ViewBase:ctor(app, name)
    self:enableNodeEvents()
    self.resourceExtend_ = nil

    self.app_      = app
    self.name_     = name
    self.visible   = true
    self.tag       = tagen:get()

    self.events    = {}
    self.timers    = {}
    self.tables    = {}
    self.children  = {}

    -- check CSB resource file
    local res = rawget(self.class, "RESOURCE_FILENAME")
    if res then
        self:createResoueceNode(res)
    end

    local binding = rawget(self.class, "RESOURCE_BINDING")
    if res and binding then
        self:createResoueceBinding(binding)
    end

    if self.onCreate then self:onCreate() end

    self:register()
end

function ViewBase:getApp()
    --    return self.app_
    return DNP_APP.appName
end

function ViewBase:getName()
    return self.name_
end

--------------------
--获取最底层节点
--
--@function [parent=#.ViewBase] get
function ViewBase:get()
    return self.resourceNode_
end

--------------------
--获取整个studio文件资源，root，animation
--@param self
--@function [parent=#ViewBase] getExtend
function ViewBase:getExtend()
    return self.resourceExtend_
end


---------------------------
--获取视图资源的方法
--@function [parent=#ViewBase] getChild
--@param self
--@param string#string tableName 数据表命名
function ViewBase:getChild(name)
    --    return self:get():getChildByName(name)
    return self.children[name]
end



function ViewBase:onClick( path,node,funcName)
--    printf("onClick11")
--    if path == "MainScene.lua" and node:getName()=="Button_1" and funcName =="onCloseClick" then
--            local function btnCallback(  node,eventType  )
--            --TODO
--            end
--            return btnCallback
--        end
end


---------------------------
--帧事件回调
--@function [parent=#ViewBase] onFrameEvent
--@param self
--@return ViewBase#ViewBase 自身句柄
function ViewBase:onFrameEvent(frame)
    local eventName = frame:getEvent()
    if self.exitEvent and  eventName == self.exitEvent then
        self:removeSelf()
    end
end


function ViewBase:pairesTarget(target)
    local children = target:getChildren()
    if next(children)  then
        for _, child in pairs(children) do
            local name = child:getName()
            if name then
                self.children[name] = child
                self[name] = child
            end
            if child.UserData and child.UserData[1] == "sb" then
                child:setPressedActionEnabled(true)
            end
            self:pairesTarget(child)
        end
    end
end


function ViewBase:createResoueceNode(resourceFilename)
    if self.resourceNode_ then
        self.resourceNode_:removeSelf()
        self.resourceNode_ = nil
    end

    local  csLuaScene = require(resourceFilename).create(handler(self,self.onClick))
    self.resourceExtend_  = csLuaScene  --所有资源，root，animation
    self.resourceNode_ = csLuaScene["root"]  --底层节点

    self:pairesTarget(csLuaScene["root"])

    if csLuaScene['animation'] then
        self:get():runAction(csLuaScene['animation'])
        csLuaScene['animation']:setFrameEventCallFunc(handler(self,self.onFrameEvent))
    end
    local s =  self.resourceNode_:getContentSize()
    self.resourceNode_:setAnchorPoint(cc.p(0.5,0.5))
    self.resourceNode_:setPosition(display.width/2,display.height/2)
    assert(self.resourceNode_, string.format("ViewBase:createResoueceNode() - load resouce node from file \"%s\" failed", resourceFilename))
    self:addChild(self.resourceNode_)
end

function ViewBase:createResoueceBinding(binding)
    assert(self.resourceNode_, "ViewBase:createResoueceBinding() - not load resource node")
    if binding and binding.touches then
        for nodeName, nodeBinding in pairs(binding.touches) do
            local node = self.resourceNode_:getChildByName(nodeName)
            if nodeBinding.varname then
                self[nodeBinding.varname] = node
            end
            for _, event in ipairs(nodeBinding.events or {}) do
                if event.event == "touch" then
                    node:onTouch(handler(self, self[event.method]))
                end
            end
        end
    end

    if binding and binding.actions then
        for actName, actBinding in pairs(binding.actions) do
            self[actName] = actBinding
        end
    end
end

function ViewBase:showWithScene(transition, time, more)
    self:setVisible(true)
    local scene = display.newScene(self.name_)
    scene:addChild(self)
    --######################QHZF####################
    AppViews:clearAll()
    AppViews:setScene(self):registerView(self)
    --######################QHZF####################
    display.runScene(scene, transition, time, more)
    return self
end


function ViewBase:onEnter()
    if self.enterAni then
        self:runAnimation(self.enterAni)
    end
end

function ViewBase:onExit_()
end

function ViewBase:onCleanup_()
    if next(self.events) ~=nil then
        for eventName,evt in pairs(self.events) do
            event.removeEventListenersByEvent(eventName)
        end
    end

    if next(self.timers) ~=nil then
        for _, time in pairs(self.timers) do
            timer:kill(time)
        end
    end

    if next(self.tables) ~=nil then
        for _,table in pairs(self.tables) do
            table:removeEventListenersByTag(self.tag)
        end
    end

end

---------------------------
--关闭视图的方法
--@function [parent=#ViewBase] closeSelf
--@param self
--@return ViewBase#ViewBase 自身句柄
function ViewBase:closeSelf()
    if self.exitAni then
        self:runAnimation(self.exitAni)
    else
        self:removeSelf()
    end
    AppViews:removeView(self.name_)
end


---------------------------
--视图动画播放方法
--@function [parent=#ViewBase] runAnimation
--@param self
--@return ViewBase#ViewBase 自身句柄
function ViewBase:runAnimation(name,loop)
    self.resourceExtend_['animation']:play(name,loop or false)
end


---------------------------
--视图动画播放速度
--@function [parent=#ViewBase] setSpeed
--@param self
--@return ViewBase#ViewBase 自身句柄
function ViewBase:setSpeed(speed)
    self.resourceExtend_['animation']:setTimeSpeed(speed)
end



---------------------------
--注册自己到视图管理器
--@function [parent=#ViewBase] register
--@param self
--@return ViewBase#ViewBase 自身句柄
function ViewBase:register()
    AppViews:registerView(self)
    return self
end

---------------------------
--添加面板的事件监听
--@function [parent=#ViewBase] addEventListener
--@param self
--@param string#string resourceFilename 资源文件名
--@return ViewBase#ViewBase 自身句柄
function ViewBase:addEventListener(eventName, listener)
    event:addEventListener(eventName, listener)
    return self
end


---------------------------
--添加该面板的事件监听
--@function [parent=#ViewBase] addSelfEventListener
--@param self
--@param string#string eventName 事件命名
--@param function#function func 回调函数
function ViewBase:addSelfEventListener(eventName, func)
    self.events[eventName] = func
    self:addEventListener(eventName,func)
    return self
end



---------------------------
--添加该面板的计数器
--@function [parent=#ViewBase] addTimer
--@param self
--@param string#string eventName 事件命名
--@param number#number runCount 执行次数
--@param number#number interval 间隔
--@param function#function func 回调函数
function ViewBase:addTimer(eventName, interval , runCount , func , data)
    local timerId = timer:start(eventName,func,interval, runCount, data)
    self.timers[eventName] = timerId
    return eventName
end


---------------------------
--停掉面板计数器
--@function [parent=#ViewBase] removeTimer
--@param self
--@param string#string timerName 事件命名
function ViewBase:removeTimer(timerName)
    timer:kill(timerName)
    self.timers[timerName] = nil
end


---------------------------
--添加该面板的数据表更新时间监听
--@function [parent=#ViewBase] addDatatableWatch
--@param self
--@param string#string tableName 数据表命名
function ViewBase:addDatatableWatch(dataTable, listener)
    dataTable:addDataListener(listener, self.tag)
    self.tables[dataTable:getEventName()] = dataTable
end


---------------------------
--开启触摸监听事件，默认方法是onTouch
--@function [parent=#ViewBase] enTouch
--@param self
function ViewBase:enTouch()
    if not self.touchLayer then
        self.touchLayer = display.newLayer()
            :addTo(self)
    end
    self.touchLayer:onTouch(handler(self, self.touch))
end


---------------------------
--关闭触摸监听事件
--@function [parent=#ViewBase] disTouch
--@param self
function ViewBase:disTouch()
    if  self.touchLayer then
        self.touchLayer:setTouchEnabled(false)
    end
end


---------------------------
--默认触摸监听事件，单点触控
--@function [parent=#ViewBase] onTouch
--@param self
function ViewBase:touch(event)
    if event.name == "began" then
    --需要返回true
    --        return true
    elseif event.name == "moved" then
    elseif event.name == "ended" then
    end
end


---------------------------
--开启update事件，默认方法是update
--@function [parent=#ViewBase] enUpdate
--@param self
function ViewBase:enUpdate()
    self:onUpdate(handler(self,self.update))
end


---------------------------
--关闭触摸监听事件
--@function [parent=#ViewBase] disUpdate
--@param self
function ViewBase:disUpdate()
    self:unscheduleUpdate()
end


---------------------------
--默认update
--@function [parent=#ViewBase] update
--@param self
function ViewBase:update(event)

end


function ViewBase:show()
    self:setVisible(true)
    self.visible = true
    return self
end

function ViewBase:hide()
    self:setVisible(false)
    self.visible = false
    return self
end


function ViewBase:updateCell()
end

function ViewBase:clearCell(event)
end

function ViewBase:setCellHighlight(event)
end

function ViewBase:setCellUnHighlight(event)
end

function ViewBase:onCellTouched(event)
end



-----------------------------
--国际化语言
--
function ViewBase:localLanguage()
    local res = rawget(self.class, "LOCALE_LANG_LABEL")
    if res then
        local curLang =  locale.defaultLang()
        local lblType = 1
        if   curLang == device.LANGUAGE.CN or curLang == device.LANGUAGE.JP or curLang == device.LANGUAGE.KR then
            lblType = 1
        else
            lblType = 2
        end
        for name, langs in pairs(res) do
            for t=1, 2 do
                local lblName = "LO_"..name.."_"..t
                print(lblName)
                if lblType == t then
                    self[lblName]:setVisible(true)
                    self[name] = self[lblName]
                    self[name]:setString(langs)
                else
                    self[lblName]:setVisible(false)
                end
            end

        end
    end
end


-----------------------------
----更新界面标签元素
----@function [parent=#ViewBase] updateLable
----@param self
----@param DataTable#DataTable data 提供更新数据的表
--function ViewBase:updateLable(data)
--
--    for key, var in pairs(self.delegate) do
--        if string.find(key,"lbl") == 1 then
--            local dataItem = string.gsub(key,"^lbl",'',1):lower()
--            local temp = data[dataItem]
--            if temp then
--                local lbl = tolua.cast(self.delegate[key],"cc.LabelTTF") or tolua.cast(self.delegate[key],"cc.LabelBMFont")
--                lbl:setString(temp)
--            end
--        end
--    end
--end

return ViewBase
