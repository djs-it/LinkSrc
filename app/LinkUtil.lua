
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


return LinkUtil