
---------------------------
--App应用级别的全局工具类
--
--@type LinkUtil
local LinkUtil = class("LinkUtil")


---------------------------
--获取data数据中的不为0的个数
--@return #type ~=0
--
function LinkUtil:getDataNum(data)
    local count = 0
    for _,value in ipars(data) do
        if value ~= 0 then
            count = count + 1
        end
    end
    return count
end


-------------------------------
--合并两个table表
--@return #type data3
--
function LinkUtil:getMerge(data1,data2)
    local data3 = {}
    for key,value in ipairs(data1) do
        if value == 0 and data2[key] == 0 then
            data3[key] = 0
        else
            if value == 0 then
                data3[key] = data2[key]
            else
                data3[key] = value
            end
        end
    end
    return data3
end

--------------------------------
-- 判断是否为真
--
function LinkUtil:isTrue(data)
    return data and #data ~= 0
end

--------------------------------
--根据点获取相应base的tag id
--
function LinkUtil:getBaseIdByPoint(point)
    return point.y * GRID_WIDTH + point.x + 1
end
--------------------------------
--根据点获取相应effect的tag id
--
function LinkUtil:getEffectTagByPoint(point)
    return point.y * GRID_WIDTH + point.x + 1 + TAG_EFFECT
end

----------------------------------
-- 判断两个点是否相等
--
function LinkUtil:isEqualByPoint(point1,point2)
    return point1.x == point2.x and point1.y == point2.y
end

----------------------------------------
--计时数据优化
--
function LinkUtil:getStrMinTime(count)
    local m = math.floor(count/60)
    local s = count - (60*m)
    local timeStr
    if m <10 then
        if s<10 then
            timeStr = "0"..m..":".."0"..s
        else
            timeStr = "0"..m..":"..s
        end
    else
        if s<10 then
            timeStr = m..":".."0"..s
        else
            timeStr = m..":"..s
        end
    end
    return timeStr
end

----------------------------------------
--获取上场的宠物
--
function LinkUtil:getStageAnimal()
    return helper.getSloterData(SLOTER.animal_stage)
end

----------------------------------------
--初始化带宠物的界面
--
function LinkUtil:setStageAnm(node,scalenum)
    local stageAnm = LinkUtil:getStageAnimal()
    if stageAnm[1] ~= 0 then
        local sp = display.newSprite(string.format("#anm-%s.png",stageAnm[1]))
        sp:setScale(scalenum)
        sp:addTo(node.stageleftcsd)
    end

    if stageAnm[2] ~= 0 then
        local sp = display.newSprite(string.format("#anm-%s.png",stageAnm[2]))
        sp:setScale(scalenum)
        sp:addTo(node.stagerightcsd)
    end
end

----------------------------------------
--宠物概率
--
function LinkUtil:isDoAnmByNum(num)
    local rd = math.random(100)
    if rd < num then
        return true
    else
        return false
    end
end

----------------------------------------
--增加金币
--
function LinkUtil:addGold(num)
    local gold = helper.getSloterData(SLOTER.user_gold)
    gold = gold + num
    helper.saveSloterData(SLOTER.user_gold,gold)
end

function LinkUtil:getGold()
    return helper.getSloterData(SLOTER.user_gold)
end
----------------------------------------
--增加钻石
--
function LinkUtil:addGem(num)
    local gem = helper.getSloterData(SLOTER.user_gem)
    gem = gem + num
    helper.saveSloterData(SLOTER.user_gem,gem)
end

function LinkUtil:getGem()
    return helper.getSloterData(SLOTER.user_gem)
end

----------------------------------------
--关卡信息处理
--<<<<<<<<<<<<<<<<<<<<<<<<<
--
--function LinkUtil:setLevelStar(starData)
--    helper.saveSloterData(SLOTER.single_level_star,starData)
--end
--
--function LinkUtil:setLevelStarByLevel(level,starNum)
--    local data = self:getLevelStar()
--    if data[level] < starNum then
--        data[level] = starNum
--        self:setLevelStar(data)
--    end
--end
--
--function LinkUtil:getLevelStar()
--    return helper.getSloterData(SLOTER.single_level_star)
--end
--
--function LinkUtil:getLevelStarByLevel(level)
--    local data = self:getLevelStar()
--    return data[level]
--end


function LinkUtil:setLevelTime(timeData)
    helper.saveSloterData(SLOTER.single_level_time,timeData)
end

function LinkUtil:setLevelTimeByLevel(level,time)
    local data = self:getLevelTime()
    if data[level] > time then
        data[level] = time
        self:setLevelTime(data)
    end
end

function LinkUtil:getLevelTime()
    return helper.getSloterData(SLOTER.single_level_time)
end

function LinkUtil:getLevelTimeByLevel(level)
    local data = self:getLevelTime()
    return data[level]
end

function LinkUtil:getLevelStar()
    local timeData = self:getLevelTime()
    local starData = {}
    for index = 1 ,50 do
        local star = self:_getStarByTime(timeData[index],index)
        starData[index] = star
    end
    return starData
end

function LinkUtil:_getStarByTime(time,level)
    if time > 3660 then
        return 0
    elseif time > LEVEL_MSG[level].T[2] then
        return 1
    elseif time > LEVEL_MSG[level].T[1] then
        return 2
    elseif time > 0 then
        return 3
    end
end

function LinkUtil:setLevelNow(level)
    helper.saveSloterData(SLOTER.single_level_now,level)
end

function LinkUtil:getLevelNow()
    return helper.getSloterData(SLOTER.single_level_now)
end

--
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
------------------------------------------
return LinkUtil