local LinkModel = class("LinkModel")

local ElementModel = import(".ElementModel")

--$$$$$$$$$$$$  CONFIG   $$$$$$$$$$$$$
local function elementData()
    return { dataPoint = {} , dataBase = {}, dataMagic = {} , dataEffect = {}}
end

--$$$$$$$$$$$$  CTOR   $$$$$$$$$$$$$

function LinkModel:ctor()
    self.elements = {}
    self.ways = {}
    self.waypoint = {}
end

function LinkModel:onCreate()
    for y = 0 ,GRID_HEIGHT - 1 do
        self.elements[y] = {}
        self.ways[y] = {}
        self.waypoint[y] = {}
        for x = 0, GRID_WIDTH - 1 do
            self.elements[y][x] = ElementModel:create(DATA_TYPE._0,DATA_TYPE._0,DATA_TYPE._0)
            self.ways[y][x] = 0
            self.waypoint[y][x] = nil
        end
    end
    return self
end

--$$$$$$$$$$$$  LOGIC&OTHRE   $$$$$$$$$$$$$

------------------------------
--初始化
--@function [parent=#LinkModel] initModel
function LinkModel:initModel(dataTable)
    local data = self:getInitData(dataTable)

    self.selectPoint = nil
    self.showCloudNum = nil
    self.isShowCloud = true
    self.canSelectNum = TYPE_OTHER + DATA_TYPE._29

    self:getRandBaseTable(data.base)
    print("11111111111111随机后＝＝＝＝"..self.baseCur)

    local result = elementData()

    for y = 0, GRID_HEIGHT - 1 do
        for x = 0, GRID_WIDTH - 1 do
            local element = self.elements[y][x]
            local index = self:_getIndexByPoint(cc.p(x,y))

            self.ways[y][x] = data.way[index]
            self:initWaypointByPoint(cc.p(x,y),self.ways[y][x])

            table.insert(result.dataPoint,cc.p(x,y))

            local baseType = self:getRandBaseType(data.base[index])
            table.insert(result.dataBase,baseType)
            element:setBase(baseType)

            if LinkUtil:isTrue(data.magic) then
                local magicType = self:getOtherTypeByTable(data.magic[index])
                if magicType ~= DATA_TYPE._0 then
                    result.dataBase[LinkUtil:getBaseIdByPoint(cc.p(x,y))] = magicType
                    element:setBase(magicType)
                end
            end

            if LinkUtil:isTrue(data.effect) then
                local effectType = self:getOtherTypeByTable(data.effect[index])
                table.insert(result.dataEffect,effectType)
                element:setEffect(effectType)
            end
        end
    end
    print("2222222222222222初始化后＝＝＝＝"..self.baseCur)
    return result
end


----------------------------
--获取当前游戏进度table表信息
--并随机打乱
--
function LinkModel:dealGameDataIng()
    self.selectPoint = nil
    local resultData = elementData()
    for y = 0 ,GRID_HEIGHT-1 do
        for x = 0 , GRID_WIDTH-1 do
            table.insert(resultData.dataPoint,cc.p(x,y))

            local baseType = self.elements[y][x]:getBase()
            table.insert(resultData.dataBase,baseType)

            local effectType = self.elements[y][x]:getEffect()
            table.insert(resultData.dataEffect,effectType)
        end
    end
    local dataIng = resultData


    self:dealGameBaseIng(resultData.dataBase)
    self:initGameDataIng(resultData)
    
    local tipsTable = self:getLineTwoPoint()
    while not tipsTable do
        self:dealGameBaseIng(resultData.dataBase)
        self:initGameDataIng(resultData)
        tipsTable = self:getLineTwoPoint()
    end
    
    return dataIng,resultData
end

----------------------------
-- 获取游戏base层点数据
--
function LinkModel:getGamingBaseData()
    local basePoint = {}
    for y = 0 ,GRID_HEIGHT-1 do
        for x = 0 , GRID_WIDTH-1 do
            if self:getBaseTypeByPoint(cc.p(x,y)) ~= 0 then
                table.insert(basePoint,cc.p(x,y))
            end
        end
    end
    return basePoint
end

----------------------------
-- 初始化重排后的数据
--
function LinkModel:initGameDataIng(resultData)
    for index = 1 ,#resultData.dataPoint do
        self.elements[resultData.dataPoint[index].y][resultData.dataPoint[index].x]:setBase(resultData.dataBase[index])
    end
end


----------------------------
-- 处理base层随机元素
--
function LinkModel:dealGameBaseIng(dataBase)
    local baseIndex = {}
    local baseType = {}
    for index = 1 ,#dataBase do
        if dataBase[index] > 0 and dataBase[index] < 100 then
            table.insert(baseIndex,index)
            table.insert(baseType,dataBase[index])
        end
    end
    for index = #baseType, 1,-1 do
        self:_randBaseIng(baseType,index)
    end

    for index = 1,#baseIndex do
        dataBase[baseIndex[index]] = baseType[index]
    end
end

----------------------------
-- 游戏中BASE数据 重排 随机
--
function LinkModel:_randBaseIng(baseType,index)
    local rd = math.random(index)
    baseType[index],baseType[rd] = baseType[rd],baseType[index]
end


----------------------------
--处理初始化数据结构表
--
function LinkModel:getInitData(data)
    local initData  = { base = {} , magic = {},effect = {},way = {}}

    for index =1,GRID_WIDTH*GRID_HEIGHT do
        if LinkUtil:isTrue(data.magic) then
            initData.magic[index] = data.magic[index]
            initData.way[index],initData.base[index] = self:_getWayAndBaseByBase(data.base[index],data.magic[index])
        else
            initData.way[index],initData.base[index] = self:_getWayAndBaseByBase(data.base[index],DATA_TYPE._0)
        end

        if LinkUtil:isTrue(data.effect) then
            initData.effect[index] = data.effect[index]
        end
    end
    return initData
end


----------------------------
--判断游戏是否还具有能够消除的点
--返回能够消除的两个点
--否则返回nil
--
function LinkModel:getLineTwoPoint()
    local tipsTable = {}
    for y = 0,GRID_HEIGHT-1 do
        for x = 0 ,GRID_WIDTH-1 do
            local onePoint = cc.p(x,y)
            if self:isCanSelect(onePoint) then
                local twoPoint = self:getLineOnePoint(onePoint)
                if twoPoint then
                    table.insert(tipsTable,onePoint)
                    table.insert(tipsTable,twoPoint)
                    return tipsTable
                end
            end
        end
    end
end

----------------------------------
--根据点 获取能够与之相消除的另一个点
--
function LinkModel:getLineOnePoint(point)
    for y = 0 ,GRID_HEIGHT-1 do
        for x = 0 ,GRID_WIDTH-1 do
            if self.elements[y][x]:getBase() ~= DATA_TYPE._0 then
                if not LinkUtil:isEqualByPoint(point,cc.p(x,y)) and self:isCanSelect(cc.p(x,y)) then
                    if self:getBaseTypeByPoint(point) == self:getBaseTypeByPoint(cc.p(x,y)) then
                        local linePoint = self:getLineByPoint(cc.p(x,y),point)
                        if linePoint then
                            return cc.p(x,y)
                        end
                    end
                end
            end
        end
    end
end


----------------------------
--获取路径way信息通过初始信息
--
function LinkModel:_getWayAndBaseByBase(baseType,magicType)
    local way,base
    if magicType == DATA_TYPE._0 then
        if baseType == DATA_TYPE._0 then
            way,base = WAY_TYPE[0],DATA_TYPE._0
        elseif baseType == DATA_TYPE._4 then
            way,base = WAY_TYPE[1],DATA_TYPE._1
        elseif baseType == DATA_TYPE._5 then
            way,base = WAY_TYPE[2],DATA_TYPE._1
        elseif baseType == DATA_TYPE._6 then
            way,base = WAY_TYPE[3],DATA_TYPE._1
        elseif baseType == DATA_TYPE._7 then
            way,base = WAY_TYPE[4],DATA_TYPE._1
        else
            way,base = WAY_TYPE[0],baseType
        end
    else
        if baseType == DATA_TYPE._4 then
            way,base = WAY_TYPE[1],DATA_TYPE._0
        elseif baseType == DATA_TYPE._5 then
            way,base = WAY_TYPE[2],DATA_TYPE._0
        elseif baseType == DATA_TYPE._6 then
            way,base = WAY_TYPE[3],DATA_TYPE._0
        elseif baseType == DATA_TYPE._7 then
            way,base = WAY_TYPE[4],DATA_TYPE._0
        else
            way,base = WAY_TYPE[0],DATA_TYPE._0
        end
    end
    return way,base
end

----------------------------
--根据way初始化waypoint
--路径信息
--
function LinkModel:initWaypointByPoint(point,way)
    if way ~= WAY_TYPE[0] then
        local px = point.x + SEARCH_GROUND[way].x
        local py = point.y + SEARCH_GROUND[way].y
        self.waypoint[point.y][point.x] = cc.p(px,py)
    end
end


----------------------------
--是否含有路径信息
--
function LinkModel:isHaveWay()
    for y = 0 ,GRID_HEIGHT-1 do
        for x = 0 ,GRID_WIDTH-1 do
            if self.ways[y][x] ~= 0 then
                return true
            end
        end
    end
    return false
end


----------------------------
--消除数字处理相应逻辑
--
function LinkModel:dealNumByCleanTable(pointTable)
    if pointTable and #pointTable ~= 0 then
        for _,value in ipairs(pointTable) do
            if self.elements[value.y][value.x]:getBase() == self.canSelectNum then
                self.canSelectNum = self.canSelectNum + 1
                return
            end
        end
    end
end


-------------------------------
--magic and effect 数据表
--根据data表中数据  获取相应的 type 类型
--
function LinkModel:getOtherTypeByTable(dataType)
    if dataType == DATA_TYPE._0 then
        return DATA_TYPE._0
    else
        return TYPE_OTHER+dataType
    end
end

-------------------------------
--随机出base数据
--
function LinkModel:getRandBaseTable(baseData)
    self.baseRand = {}
    self.baseCur = 0
    local isCan = true
    for _,value in ipairs(baseData) do
        if value == DATA_TYPE._1 then
            if isCan then
                local baseType = math.random(ELEMENT_TYPE._NUM)
                table.insert(self.baseRand,baseType)
                isCan = false
            else
                table.insert(self.baseRand,self.baseRand[self.baseCur])
                isCan = true
            end
            self.baseCur = self.baseCur + 1
        end
    end
    return self.baseRand
end

-----------------------
--根据table.base数据随机出相应的类型
--
function LinkModel:getRandBaseType(type)
    if type == DATA_TYPE._0 then
        return DATA_TYPE._0
    elseif type == DATA_TYPE._1 then
        return self:_getNextBaseType()
    else
        return TYPE_OTHER+type
    end
end

---------------------------------
--随机打乱已生成的base数据
--
function LinkModel:_getNextBaseType()
    local rand = math.random(self.baseCur)
    local result = self.baseRand[rand]
    self.baseRand[rand],self.baseRand[self.baseCur] = self.baseRand[self.baseCur],self.baseRand[rand]
    self.baseCur = self.baseCur - 1
    return result
end

-------------------------------
--根据坐标获取data表中对应的index
--
function LinkModel:_getIndexByPoint(point)
    return (GRID_HEIGHT - 1 - point.y) * GRID_WIDTH + point.x + 1
end

---------------------------------
--根据点坐标获取base类型
--
function LinkModel:getBaseTypeByPoint(point)
    return self.elements[point.y][point.x]:getBase()
end

---------------------------------
--根据点坐标获取effect类型
--
function LinkModel:getEffectTypeByPoint(point)
    return self.elements[point.y][point.x]:getEffect()
end


---------------------------------
--判断是否能响应点击事件
--
function LinkModel:isCanClearByBmBtn(point)
    local baseType = self.elements[point.y][point.x]:getBase()
    if baseType > 0 and baseType < 100 then
        return true
    else
        return false
    end
end

---------------------------------
--根据点获取另一个对应base的点
--bmbtnclear
--
function LinkModel:getAnotherPointByPointBase(point)
    local baseType = self:getBaseTypeByPoint(point)
    for y = 0,GRID_HEIGHT-1 do
        for x = 0,GRID_WIDTH-1 do
            if y ~= point.y or x ~= point.x then
                if baseType == self:getBaseTypeByPoint(cc.p(x,y)) then
                    return cc.p(x,y)
                end
            end
        end
    end
end

---------------------------------
--处理bmbtnclear按钮数据
--
function LinkModel:dealBmBtnClear(point)
    local clearPoint = {}
    if self:isCanClearByBmBtn(point) then
        local otherP = self:getAnotherPointByPointBase(point)
        table.insert(clearPoint,point)
        table.insert(clearPoint,otherP)
        return clearPoint
    end
end

---------------------------------------
--处理触控点
--@return #type 上一次的点，当前点
--
function LinkModel:dealTouchPoint(point)

    local lastPoint = nil
    local linePoint = {}
    local clearPoint = {}
    local clearGem = {}
    local clearKey = {}

    if self.selectPoint then
        if not LinkUtil:isEqualByPoint(self.selectPoint,point) then
            if self:isCanSelect(point) then
                if self:getBaseTypeByPoint(point) == self:getBaseTypeByPoint(self.selectPoint) then
                    linePoint = self:getLineByPoint(self.selectPoint,point)
                    if linePoint then
                        table.insert(clearPoint,self.selectPoint)
                        table.insert(clearPoint,point)
                        self.selectPoint = nil
                    else
                        lastPoint = self.selectPoint
                        self.selectPoint = point
                    end
                else
                    lastPoint = self.selectPoint
                    self.selectPoint = point
                end
            end
        end
    else
        if self:isCanSelect(point) then
            self.selectPoint = point
        end
    end

    if LinkUtil:isTrue(clearPoint) then
        clearGem = self:checkGem(clearPoint)
        clearKey = self:checkKey(clearPoint)
    end
    local sortLinePoint = self:getSortLine(linePoint)
    return lastPoint,self.selectPoint,clearPoint,sortLinePoint,clearGem,clearKey
end

-------------------------------------
--获取提示点
--
function LinkModel:getTipByLine(lineTable)

end

-------------------------------------
--获取消除特效点
--
function LinkModel:getTipsByLine(lineTable)

end

-------------------------------------
--根据转折点获取连线位置上的所有点
--
function LinkModel:getAllPointByTips(lineTable)
    local tipsTable = {}
    if #lineTable == 2 then
        tipsTable = self:getPointsByTwoP(lineTable[1],lineTable[2])
    elseif #lineTable == 3 then
        local pt1 = self:getPointsByTwoP(lineTable[1],lineTable[2])
        local pt2 = self:getPointsByTwoP(lineTable[2],lineTable[3])
        for key = 1,#pt1-1 do
            table.insert(tipsTable,pt1[key])
        end
        for key = 1,#pt2 do
            table.insert(tipsTable,pt2[key])
        end
    elseif #lineTable == 4 then
        local pt1 = self:getPointsByTwoP(lineTable[1],lineTable[2])
        local pt2 = self:getPointsByTwoP(lineTable[2],lineTable[3])
        local pt3 = self:getPointsByTwoP(lineTable[3],lineTable[4])
        for key = 1,#pt1-1 do
            table.insert(tipsTable,pt1[key])
        end
        for key = 1,#pt2-1 do
            table.insert(tipsTable,pt2[key])
        end
        for key = 1,#pt3 do
            table.insert(tipsTable,pt3[key])
        end
    end
    return tipsTable
end

-------------------------------------
--获取两点间所有的点
--
function LinkModel:getPointsByTwoP(pointF,pointT)
    local pointTable = {}
    if pointF.x == pointT.x then
        local sign = (pointT.y-pointF.y)/math.abs(pointT.y-pointF.y)
        for y = pointF.y ,pointT.y ,sign do
            table.insert(pointTable,cc.p(pointF.x,y))
        end
    elseif pointF.y == pointT.y then
        local sign = (pointT.x-pointF.x)/math.abs(pointT.x-pointF.x)
        for x = pointF.x,pointT.x, sign do
            table.insert(pointTable,cc.p(x,pointF.y))
        end
    end
    return pointTable
end


-------------------------------------
--处理消除连线点table
--
function LinkModel:getSortLine(lineTable)
    if LinkUtil:isTrue(lineTable) then
        local sortLine = {}
        if #lineTable == 2 then
            table.insert(sortLine,lineTable[1])
            table.insert(sortLine,lineTable[2])
            return sortLine
        end

        if #lineTable == 3 then
            table.insert(sortLine,lineTable[1])
            table.insert(sortLine,lineTable[3])
            table.insert(sortLine,lineTable[2])
            return sortLine
        end

        if #lineTable == 4 then
            table.insert(sortLine,lineTable[1])

            if (LinkUtil:isEqualByPoint(lineTable[3],lineTable[4]) and LinkUtil:isEqualByPoint(lineTable[3],lineTable[1]))
                or (LinkUtil:isEqualByPoint(lineTable[3],lineTable[4]) and LinkUtil:isEqualByPoint(lineTable[3],lineTable[2]))
                or (LinkUtil:isEqualByPoint(lineTable[3],lineTable[1]) and LinkUtil:isEqualByPoint(lineTable[4],lineTable[2]))
                or (LinkUtil:isEqualByPoint(lineTable[3],lineTable[2]) and LinkUtil:isEqualByPoint(lineTable[4],lineTable[1]))
            then
                table.insert(sortLine,lineTable[2])
                return sortLine
            elseif (LinkUtil:isEqualByPoint(lineTable[3],lineTable[4]))
                or (LinkUtil:isEqualByPoint(lineTable[3],lineTable[1]))
                or (LinkUtil:isEqualByPoint(lineTable[3],lineTable[2]))
            then
                table.insert(sortLine,lineTable[4])
                table.insert(sortLine,lineTable[2])
                return sortLine
            elseif (LinkUtil:isEqualByPoint(lineTable[4],lineTable[1]))
                or (LinkUtil:isEqualByPoint(lineTable[4],lineTable[2]))
            then
                table.insert(sortLine,lineTable[3])
                table.insert(sortLine,lineTable[2])
                return sortLine
            end

            if lineTable[1].x == lineTable[3].x or lineTable[1].y == lineTable[3].y then
                table.insert(sortLine,lineTable[3])
                table.insert(sortLine,lineTable[4])
                table.insert(sortLine,lineTable[2])
                return sortLine
            else
                table.insert(sortLine,lineTable[4])
                table.insert(sortLine,lineTable[3])
                table.insert(sortLine,lineTable[2])
                return sortLine
            end
        end
    end
end


-------------------------------------
--处理路径
--
function LinkModel:getRunWayByClean(clearTable)
    local runTable = {}
    if LinkUtil:isTrue(clearTable) then
        local pt1 = self:getWayTableByPoint(clearTable[1])
        local pt2 = self:getWayTableByPoint(clearTable[2])
        if #pt1 > #pt2 then
            runTable[1] = pt2
            runTable[2] = pt1
        else
            runTable[1] = pt1
            runTable[2] = pt2
        end
    end
    return runTable
end


-------------------------------------
--处理路径
--通过point
--
function LinkModel:getWayTableByPoint(point)
    local pointTable = {}
    table.insert(pointTable,point)
    local pt = self:getToPointByPoint(point)
    while pt do
        table.insert(pointTable,pt)
        pt =self:getToPointByPoint(pt)
    end
    return pointTable
end

-------------------------------------
--处理路径
--
function LinkModel:getToPointByPoint(point)
    for y = 0,GRID_HEIGHT-1 do
        for x = 0,GRID_WIDTH-1 do
            if self.waypoint[y][x] then
                if LinkUtil:isEqualByPoint(point,self.waypoint[y][x]) then
                    return cc.p(x,y)
                end
            end
        end
    end
end


-------------------------------------
--处理不可点击冰块
--
function LinkModel:dealIceByTable(clearTable)
    local iceTable = {}
    for _,value in ipairs(clearTable) do
        local itl = self:dealIceByPoint(value)
        if LinkUtil:isTrue(itl) then
            for _,value in ipairs(itl) do
                table.insert(iceTable,value)
            end
        end
    end
    return iceTable
end

-------------------------------------
--相应点周围冰块初始化
--
function LinkModel:dealIceByPoint(point)
    local iceTable = {}
    for i = 1,4 do
        local ptx = point.x + SEARCH_GROUND[i].x
        local pty = point.y + SEARCH_GROUND[i].y
        if self.elements[pty][ptx]:getEffect() == TYPE_OTHER + DATA_TYPE._8 then
            self.elements[pty][ptx]:setEffect(DATA_TYPE._0)
            table.insert(iceTable,cc.p(ptx,pty))
        end
    end
    return iceTable
end


-------------------------------------
--获取乌云table
--
function LinkModel:getCloudsTable()
    local clouds = {}
    for y = 0 ,GRID_HEIGHT-1 do
        for x = 0, GRID_WIDTH-1 do
            if self.elements[y][x]:getEffect() == TYPE_OTHER + DATA_TYPE._13 then
                table.insert(clouds,cc.p(x,y))
            end
        end
    end
    return clouds
end

-------------------------------------
--乌云游戏逻辑
--
function LinkModel:getShowCloud()
    local isDoCloud = false
    local cloudTable = self:getCloudsTable()
    if cloudTable and #cloudTable ~= 0 then
        isDoCloud = true
        if self.isShowCloud then
            if self.showCloudNum then
                if self.showCloudNum >= #cloudTable then
                    self.showCloudNum = 1
                else
                    self.showCloudNum = self.showCloudNum + 1
                end
                self.isShowCloud = true
            else
                self.showCloudNum = 1
            end
            self.isShowCloud = false
        else
            self.isShowCloud = true
        end
    end
    return isDoCloud,self.isShowCloud,cloudTable[self.showCloudNum]
end


-------------------------------------
--判断点位置的乌云是否存在
--
function LinkModel:isCloudTypeByPoint(point)
    return self.elements[point.y][point.x]:getEffect() == TYPE_OTHER + DATA_TYPE._13
end


-------------------------------------
--处理翻片问号
--
function LinkModel:dealTurning(last,new)
    local mark = 0
    local cType = TYPE_OTHER + DATA_TYPE._9
    if last then
        local lastType = self:getEffectTypeByPoint(last)
        local newType = self:getEffectTypeByPoint(new)
        if lastType == cType and newType == cType then
            mark = 1
        elseif lastType == cType then
            mark = 2
        elseif newType == cType then
            mark = 3
        end
    elseif new then
        local newT = self:getEffectTypeByPoint(new)
        if newT == cType then
            mark = 4
        end
    end
    return mark,last,new
end

-------------------------------------
--获取连线点
--
function LinkModel:getLineByPoint(old,new)
    local linePoint = {}
    self:_dealSpecialGetLine(old,new,linePoint)
    if #linePoint ~= 0 then
        return linePoint
    else
        local oldX = self:getHorizontalEmpty(old)
        local newX = self:getHorizontalEmpty(new)
        for _,x1 in ipairs(oldX) do
            for _,x2 in ipairs(newX) do
                if x1 == x2 then
                    if old.y == new.y then
                        table.insert(linePoint,old)
                        table.insert(linePoint,new)
                        return linePoint
                    elseif self:isCanLine(old.y,new.y,x1,false) then
                        table.insert(linePoint,old)
                        table.insert(linePoint,new)
                        table.insert(linePoint,cc.p(x1,old.y))
                        table.insert(linePoint,cc.p(x1,new.y))
                        return linePoint
                    end
                end
            end
        end

        local oldY = self:getVerticalEmpty(old)
        local newY = self:getVerticalEmpty(new)
        for _,y1 in ipairs(oldY) do
            for _,y2 in ipairs(newY) do
                if y1 == y2 then
                    if old.x == new.x then
                        table.insert(linePoint,old)
                        table.insert(linePoint,new)
                        return linePoint
                    elseif self:isCanLine(old.x,new.x,y1,true) then
                        table.insert(linePoint,old)
                        table.insert(linePoint,new)
                        table.insert(linePoint,cc.p(old.x,y1))
                        table.insert(linePoint,cc.p(new.x,y1))
                        return linePoint
                    end
                end
            end
        end

    end
end


--------------------------------
--处理特殊情况
--
function LinkModel:_dealSpecialGetLine(old,new,linePoint)
    local signX = math.abs(old.x - new.x)
    local signY = math.abs(old.y - new.y)
    local num = signX + signY

    if num == 1 then
        table.insert(linePoint,old)
        table.insert(linePoint,new)
        return
    end

    if signX == 1 and signY == 1 then
        if self.elements[old.y][new.x].base == ELEMENT_TYPE._0 then
            table.insert(linePoint,old)
            table.insert(linePoint,new)
            table.insert(linePoint,cc.p(new.x,old.y))
            return
        end
        if self.elements[new.y][old.x].base == ELEMENT_TYPE._0 then
            table.insert(linePoint,old)
            table.insert(linePoint,new)
            table.insert(linePoint,cc.p(old.x,new.y))
            return
        end
    end
end

-------------------------------------------
--获取横向联通点的x坐标值
--
function LinkModel:getHorizontalEmpty(point)
    local pointTable = {}
    table.insert(pointTable,point.x)
    for x = point.x - 1, 0 , -1 do
        if self.elements[point.y][x].base == ELEMENT_TYPE._0 then
            table.insert(pointTable,x)
        else
            break
        end
    end

    for x = point.x + 1, GRID_WIDTH - 1 do
        if self.elements[point.y][x].base == ELEMENT_TYPE._0 then
            table.insert(pointTable,x)
        else
            break
        end
    end
    return pointTable
end

----------------------------------------
--获取纵向联通点的y坐标值
--
function LinkModel:getVerticalEmpty(point)
    local pointTable = {}
    table.insert(pointTable,point.y)
    for y = point.y - 1, 0, -1 do
        if self.elements[y][point.x].base == ELEMENT_TYPE._0 then
            table.insert(pointTable,y)
        else
            break
        end
    end

    for y = point.y + 1, GRID_HEIGHT - 1 do
        if self.elements[y][point.x].base == ELEMENT_TYPE._0 then
            table.insert(pointTable,y)
        else
            break
        end
    end
    return pointTable
end

-------------------------------------------
--根据两点判断是否能够联通
--isx 是否横向
--num3 共同值
--
function LinkModel:isCanLine(num1,num2,com,isX)
    local sign = (num1 - num2)/math.abs(num1 - num2)
    if isX then
        for x = num2+sign ,num1-sign,sign do
            if self.elements[com][x].base ~= ELEMENT_TYPE._0 then
                return false
            end
        end
        return true
    else
        for y = num2+sign ,num1-sign,sign do
            if self.elements[y][com].base ~= ELEMENT_TYPE._0 then
                return false
            end
        end
        return true
    end
end

------------------------------------------
--根据点 判断是否响应点击事件
--
--TYPE_OTHER + DATA_TYPE._29 and baseType <= TYPE_OTHER + DATA_TYPE._37 then
function LinkModel:isCanSelect(point)
    local baseType = self:getBaseTypeByPoint(point)
    local effectType = self:getEffectTypeByPoint(point)
    if effectType == DATA_TYPE._0 then
        if baseType > 0 and baseType < 100 then
            return true
        elseif baseType == self.canSelectNum then
            return true
        elseif self:_isGemBaseType(baseType) then
            return true
        elseif self:_isKeyBaseType(baseType) then
            return true
        else
            return false
        end
        --问号
    elseif effectType == TYPE_OTHER + DATA_TYPE._9 then
        return true
            --乌云
    elseif effectType == TYPE_OTHER + DATA_TYPE._13 then
        return true
            --冰块
    elseif effectType == TYPE_OTHER + DATA_TYPE._8 then
        return false
    end
end

------------------------------------------
--判断是否是宝石
--传入参数是相应的type类型
--
function LinkModel:_isGemBaseType(num)
    return num == TYPE_OTHER + DATA_TYPE._22 or num == TYPE_OTHER + DATA_TYPE._23 or num == TYPE_OTHER + DATA_TYPE._24
end

------------------------------------------
--判断是否是钥匙
--传入参数是相应的type类型
--
function LinkModel:_isKeyBaseType(num)
    return num == TYPE_OTHER + DATA_TYPE._25 or num == TYPE_OTHER + DATA_TYPE._26
end


--------------------------------
--消除相应元素后init base相应位置
--
function LinkModel:clearBaseByPoint(pointTable)
    if pointTable and #pointTable ~= 0  then
        local isRunWay = false
        self.selectPoint = nil
        self:dealNumByCleanTable(pointTable)
        for _,value in ipairs(pointTable) do
            self.elements[value.y][value.x]:setEffect(ELEMENT_TYPE._0)
            self.elements[value.y][value.x]:setBase(ELEMENT_TYPE._0)
        end

        local wayTable = self:getRunWayByClean(pointTable)
        local resultTable = {}
        if #wayTable[2] ~= 1 then
            resultTable = self:getWayResult(wayTable)

            if #wayTable[1] ~= 1 then
                self:_doRunWayByTable(wayTable[1])
            end
            if #wayTable[2] ~= 1 then
                self:_doRunWayByTable(wayTable[2])
            end
            isRunWay = true
        end
        return isRunWay,resultTable
    end
end

--------------------------------
--处理way table
--返回正确位置的table
--
function LinkModel:getWayResult(wayTable)
    local resultTable = {}
    resultTable[1] = self:getWayResultByClean(wayTable[1][1])
    resultTable[2] = self:getWayResultByClean(wayTable[2][1])
    if self:isInTheSameList(wayTable) then
        if #wayTable ~= 1 then
            for key = 1,#resultTable[1]-1 do
                table.insert(resultTable[2],resultTable[1][key])
            end
        end
    end
    return resultTable
end

-------------------------------------
--获取正确路径result way
--通过clean point
--
function LinkModel:getWayResultByClean(point)
    local pointTable = {}
    table.insert(pointTable,point)
    local pt = self:getWayPointList(point)
    while pt do
        table.insert(pointTable,pt)
        pt =self:getWayPointList(pt)
    end
    return pointTable
end

-------------------------------------
--根据点获取上一个能够移动的点
--
function LinkModel:getWayPointList(point)
    for y = 0,GRID_HEIGHT-1 do
        for x = 0,GRID_WIDTH-1 do
            if self.waypoint[y][x] then
                if LinkUtil:isEqualByPoint(point,self.waypoint[y][x]) and self.elements[y][x]:getBase() ~= DATA_TYPE._0 then
                    return cc.p(x,y)
                end
            end
        end
    end
end

--------------------------------
--是否在同一个链表里面
--
function LinkModel:isInTheSameList(wayTable)
    for _,value in ipairs(wayTable[2]) do
        if LinkUtil:isEqualByPoint(value,wayTable[1][1]) then
            return true
        end
    end
end


--------------------------------
--消除相应元素后init base相应位置
--
function LinkModel:_doRunWayByTable(wayTable)
    if #wayTable ~= 1 then
        for key=2,#wayTable do
            local now = wayTable[key]
            local last = wayTable[key-1]
            self.elements[now.y][now.x],self.elements[last.y][last.x] = self.elements[last.y][last.x],self.elements[now.y][now.x]
        end
    end
end

--------------------------------
--消除相应元素后init effect相应位置
--
function LinkModel:clearEffectByPoint(pointTable)
    if pointTable and #pointTable ~= 0 then
        for _,value in ipairs(pointTable) do
            self.elements[value.y][value.x]:setEffect(ELEMENT_TYPE._0)
        end
    end
end

----------------------------------
--判断钥匙
--
function LinkModel:checkKey(pointTable)
    for _,value in ipairs(pointTable) do
        if self.elements[value.y][value.x]:getBase() == TYPE_OTHER + DATA_TYPE._25 then
            return self:getClearKey(DATA_TYPE._10)
        elseif self.elements[value.y][value.x]:getBase() == TYPE_OTHER + DATA_TYPE._26 then
            return self:getClearKey(DATA_TYPE._11)
        end
    end
end


----------------------------------
--获取钥匙消除的相应元素
--
function LinkModel:getClearKey(type)
    local pointTable = {}
    for y = 0,GRID_HEIGHT-1 do
        for x = 0,GRID_WIDTH-1 do
            if self.elements[y][x]:getEffect() == type + TYPE_OTHER then
                table.insert(pointTable,cc.p(x,y))
            end
        end
    end
    return pointTable
end

----------------------------------
--判断宝石
--
function LinkModel:checkGem(pointTable)
    for _,value in ipairs(pointTable) do
        if self.elements[value.y][value.x]:getBase() == TYPE_OTHER + DATA_TYPE._22 then
            return self:getClearGem(TYPE_OTHER + DATA_TYPE._15)
        elseif self.elements[value.y][value.x]:getBase() == TYPE_OTHER + DATA_TYPE._23 then
            return self:getClearGem(TYPE_OTHER + DATA_TYPE._16)
        elseif self.elements[value.y][value.x]:getBase() == TYPE_OTHER + DATA_TYPE._24 then
            return self:getClearGem(TYPE_OTHER + DATA_TYPE._17)
        end
    end
end

----------------------------------
--获取宝石消除的相应元素
--
function LinkModel:getClearGem(type)
    local pointTable = {}
    for y = 0 ,GRID_HEIGHT-1 do
        for x = 0, GRID_WIDTH-1 do
            if self.elements[y][x]:getBase() == type then
                table.insert(pointTable,cc.p(x,y))
            end
        end
    end
    return pointTable
end


--------------------------------
-- 获取暂停数据
--
function LinkModel:getPauseData()
    local resultData = {}
    for y = 0 ,GRID_HEIGHT-1 do
        for x = 0 , GRID_WIDTH-1 do
            if self.elements[y][x]:getBase() ~= DATA_TYPE._0 then
                table.insert(resultData,cc.p(x,y))
            end
        end
    end
    return resultData
end


--------------------------------
-- 判断游戏是否完成
--
function LinkModel:isFinishGame()
    for y = 0,GRID_HEIGHT-1 do
        for x= 0,GRID_WIDTH-1 do
            local base = self.elements[y][x]:getBase()
            if base ~= TYPE_OTHER + DATA_TYPE._18 or base ~= TYPE_OTHER+DATA_TYPE._2 then
                if base >0 and base < 100 then
                    return false
                end
                if base >= 129 then
                    return false
                end
            end
        end
    end
    return true
end

--------------------------------
-- 测试代码
--
function LinkModel:test()
    for y = 0 ,GRID_HEIGHT-1 do
        for x = 0, GRID_WIDTH-1 do
            print("xxx:"..x.."yyy:"..y)
            print(self.elements[y][x].base)
        end
    end
end


--------------------------------
--清场
--
function LinkModel:clearModel()
    for y = 0,GRID_HEIGHT-1 do
        for x= 0,GRID_WIDTH-1 do
            self.elements[y][x] = nil
        end
    end
end

return LinkModel