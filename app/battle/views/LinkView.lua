--------------------------------
-- @module LinkView
-- @extend ViewBase
-- @parent_module cc
-- LinkView is a combination of view and controller

local LinkView = class("LinkView",cc.load("mvc").ViewBase)

local ElementSprite = import(".Element.ElementSprite")

function LinkView:ctor()
    self:setOffset()
    self.tips = {}
end

--$$$$$$$$$$$$$$$$$$$$$ LOGIC $$$$$$$$$$$$$$$$$$$$$$$$$
----------------------------
--游戏初始化
--
--@function [parent=#LinkView] initView
function LinkView:initView(data)
    self.viewLayer = display.newLayer()
        :addTo(self)
    for index = 1, #data.dataPoint  do
        local pos = self:getPositionByPoint(data.dataPoint[index])

        local baseType = data.dataBase[index]
        if baseType ~= 0 then
            local zo = self:getZOrderByY(pos.y)
            local block = ElementSprite:create(baseType)
                :setPosition(pos)
                :addTo(self.viewLayer)
                :setTag(index)
                :setLocalZOrder(zo)
        end
        if LinkUtil:isTrue(data.dataEffect) then
            local effectType = data.dataEffect[index]
            if effectType ~= 0 then
                local sp = self.viewLayer:getChildByTag(index)
                sp:addEffect(effectType)
            end
        end
    end
    return self
end


-----------------------------
--根据Y获取zorder
--相应y值
--
function LinkView:getZOrderByY(y)
    return GRID_HEIGHT - y +1
end

-----------------------------
--处理重排
--
function LinkView:realignGameIng(dataIng,resultData)
    self:dealBaseIng(dataIng.dataBase)
    self:createBaseIng(resultData)
end

-----------------------------
-- 删除base层当前数据
--
function LinkView:dealBaseIng(baseData)
    if LinkUtil:isTrue(baseData) then
        for index = 1,#baseData do
            if baseData[index] ~= 0 then
                local sp = self.viewLayer:getChildByTag(index)
                sp:removeSelf()
            end
        end
    end
end


-----------------------------
-- 重排后 重新生成精灵
--
function LinkView:createBaseIng(gameData)
    for index = 1,#gameData.dataPoint do
        local pos = self:getPositionByPoint(gameData.dataPoint[index])
        local baseType = gameData.dataBase[index]

        if baseType ~= 0 then
            local zo = self:getZOrderByY(pos.y)
            local block = ElementSprite:create(baseType)
                :setPosition(pos)
                :addTo(self.viewLayer)
                :setTag(index)
                :setLocalZOrder(zo)
        end

        if LinkUtil:isTrue(gameData.dataEffect) then
            local effectType = gameData.dataEffect[index]
            if effectType ~= 0 then
                local sp = self.viewLayer:getChildByTag(index)
                sp:addEffect(effectType)
            end
        end
    end
end


-----------------------------
--获取坐标偏移
--
function LinkView:setOffset()
    self.offsetX = (display.width - GRID_BORDER_WIDTH * GRID_WIDTH) / 2 + GRID_BORDER_WIDTH /2
    self.offsetY = GAME_BORDER_OFFSETY + GRID_BORDER_HEIGHT / 2
end

-------------------------------
--根据坐标点获取坐标位置
--
function LinkView:getPositionByPoint(x,y)
    local ix,iy = x , y
    if not y then
        ix , iy = x.x, x.y
    end
    return cc.p(ix * GRID_BORDER_WIDTH + self.offsetX, iy * GRID_BORDER_HEIGHT + self.offsetY)
end

---------------------------------
--当前选中的元素的效果
--
function LinkView:setSelectByPoint(lastPoint,newPoint)
    if lastPoint then
        local lastTag = LinkUtil:getBaseIdByPoint(lastPoint)
        local newTag = LinkUtil:getBaseIdByPoint(newPoint)
        local lastSp = self.viewLayer:getChildByTag(lastTag)
        local newSp = self.viewLayer:getChildByTag(newTag)
        lastSp:unselected()
        newSp:selected()
        print("-----------------===")
    elseif newPoint then
        print("+++++++++++++===")
        local tag = LinkUtil:getBaseIdByPoint(newPoint)
        local sp = self.viewLayer:getChildByTag(tag)
        sp:selected()
    end
end

-------------------------------
--根据table消除相应元素
--
function LinkView:clearBaseByTable(pointTable,isRun,wayTable)
    if pointTable and #pointTable ~= 0 then
        for _,value in ipairs(pointTable) do
            if LinkUtil:isTrue(self.tips) then
                local tp = {}
                for key,tvalue in ipairs(self.tips) do
                    if not LinkUtil:isEqualByPoint(value,tvalue) then
                        table.insert(tp,tvalue)
                    end
                end
                self.tips = tp
            end

            local tag = LinkUtil:getBaseIdByPoint(value)
            local clearsp = self.viewLayer:getChildByTag(tag)
            clearsp:removeSelf()
        end

        if isRun then
            if #wayTable[1] ~= 1 then
                self:_doRunWay(wayTable[1])
            end
            self:_doRunWay(wayTable[2])
        else
        end
    end
end


-------------------------------
--路径移动
--
function LinkView:_doRunWay(wayT)
    if #wayT ~= 1 then
        for key = 2,#wayT do
            local new = wayT[key]
            local old = wayT[key-1]
            local newtag = LinkUtil:getBaseIdByPoint(new)
            local oldtag = LinkUtil:getBaseIdByPoint(old)
            local spm = self.viewLayer:getChildByTag(newtag)
            local pos = self:getPositionByPoint(old)
            local zo = self:getZOrderByY(pos.y)
            spm:setPosition(pos)
            spm:setTag(oldtag)
            spm:setLocalZOrder(zo)
        end
    end
end


-------------------------------
--根据table消除相应元素
--
function LinkView:clearEffectByTable(pointTable)
    if pointTable and #pointTable ~= 0 then
        for _,value in ipairs(pointTable) do
            local tag = LinkUtil:getBaseIdByPoint(value)
            local sp = self.viewLayer:getChildByTag(tag)
            sp:removeEffect()
        end
    end
end

-------------------------------
--提示做  相应动画
--
function LinkView:showTipsByTable(pointTable)
    if LinkUtil:isTrue(pointTable) then
        self.tips = pointTable
        for key,value in ipairs(pointTable) do
            local tag = LinkUtil:getBaseIdByPoint(value)
            local sp = self.viewLayer:getChildByTag(tag)
            sp:selected()
        end
    end
end

-------------------------------
--消除相应动画效果
--
function LinkView:hideTipsDemo()
    if LinkUtil:isTrue(self.tips) then
        for key,value in ipairs(self.tips) do
            local tag = LinkUtil:getBaseIdByPoint(value)
            local sp = self.viewLayer:getChildByTag(tag)
            sp:unselected()
        end
        self.tips = nil
    end
end

-------------------------------
--消除所有动画效果
--
function LinkView:hideAllDemo(baseTable)
    for _,value in ipairs(baseTable) do
        local tag = LinkUtil:getBaseIdByPoint(value)
        local sp = self.viewLayer:getChildByTag(tag)
        sp:unselected()
    end
end

-------------------------------
--处理问号类型
--
function LinkView:dealTurning(mark,pointLast,pointNew)

    if mark == 0 then
        return
    else
        if mark == 1 then
            local tagLast = LinkUtil:getBaseIdByPoint(pointLast)
            local tagNew = LinkUtil:getBaseIdByPoint(pointNew)
            local spLast = self.viewLayer:getChildByTag(tagLast)
            local spNew = self.viewLayer:getChildByTag(tagNew)
            spLast:showEffect()
            spNew:hideEffect()
        elseif mark ==2 then
            local tagLast = LinkUtil:getBaseIdByPoint(pointLast)
            local spLast = self.viewLayer:getChildByTag(tagLast)
            spLast:showEffect()
        elseif mark ==3 or mark == 4 then
            local tagNew = LinkUtil:getBaseIdByPoint(pointNew)
            local spNew = self.viewLayer:getChildByTag(tagNew)
            spNew:hideEffect()
        end
    end
end

-------------------------------
--隐藏乌云下面元素
--显示乌云
--
function LinkView:showCloudByPoint(point)
    if point then
        local tag = LinkUtil:getBaseIdByPoint(point)
        local sp = self.viewLayer:getChildByTag(tag)
        sp:showEffect()
    end
end


-------------------------------
--显示乌云下面元素
--隐藏乌云
--
function LinkView:hideCloudByPoint(point)
    if point then
        local tag = LinkUtil:getBaseIdByPoint(point)
        local sp = self.viewLayer:getChildByTag(tag)
        sp:hideEffect()
    end
end

-------------------------------
--冰块消除
--
function LinkView:cleanIceByTable(iceTable)
    if iceTable and #iceTable ~= 0 then
        for _,value in ipairs(iceTable) do
            local tag = LinkUtil:getBaseIdByPoint(value)
            local sp = self.viewLayer:getChildByTag(tag)
            sp:removeEffect()
        end
    end
end


-------------------------------
--乌云动画
--
function LinkView:runCloud(isShowCloud,cloudPoint)
    if isShowCloud then
        self:showCloudByPoint(cloudPoint)
    else
        self:hideCloudByPoint(cloudPoint)
    end
end

-------------------------------
--展示暂停
--
function LinkView:showPauseByPoint(dataPoint)
    --    if LinkUtil.isTrue(dataPoint) then
    for _,value in ipairs(dataPoint) do
        local tag = LinkUtil:getBaseIdByPoint(value)
        local sp = self.viewLayer:getChildByTag(tag)
        sp:showBack()
    end
    --    end
end

-------------------------------
--结束暂停展示
--
function LinkView:hidePauseByPoint(dataPoint)
    --    if LinkUtil.isTrue(baseData) then
    for _,value in ipairs(dataPoint) do
        local tag = LinkUtil:getBaseIdByPoint(value)
        local sp = self.viewLayer:getChildByTag(tag)
        sp:hideBack()
    end
    --    end
end

-------------------------------
--消除选中状态
--
function LinkView:setUnSelectByPoint(point)
    local tag = LinkUtil:getBaseIdByPoint(point)
    local sp = self.viewLayer:getChildByTag(tag)
    sp:unselected()
end


-------------------------------
--清空游戏层
--
function LinkView:clearView()
    self.viewLayer:removeSelf()
    self.viewLayer = nil
end

return LinkView