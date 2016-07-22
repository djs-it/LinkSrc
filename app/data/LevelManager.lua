---------------------------
-- 关卡数据处理
--
--@type LevelManager
local LevelManager = class("LevelManager")

---------------------
--获取data数据
--pnum = 0  直接获取关卡信息
--pnum = 1,2,3 获取相应的小，中，大 pattern
--@return #type table
function LevelManager:getData(num,pnum)
    local str = "app.data."
    if pnum == 1 then
        str = str.."patterndata.small.P_"..num
    elseif pnum == 2 then
        str = str.."patterndata.mid.M_"..num
    elseif pnum == 3 then
        str = str.."patterndata.big.B_"..num
    else
        str = str.."leveldata.L_"..num
    end
    local data = require(str)
    
    local result = {}
    
    for i = 1,3 do
        if data.layers[i] then
            if data.layers[i].name == "base" then
                result.base = data.layers[i].data
            elseif data.layers[i].name == "magic" then
                result.magic = data.layers[i].data
            elseif data.layers[i].name == "effect" then
                result.effect = data.layers[i].data
            end
        end
    end
    return result
end

---------------------------------
--获取随机游戏数据
--num 1 2 3 4  (难度系数)
--
function LevelManager:getRandGameData(num)
    local resultData = {}
    resultData.base = self:getPatterrnByAfterRandUp(RAND_PATTERN[1],1)
    if num ==1 then
        while self:getAllNumByData(resultData.base) < RAND_GAMEDATA[1] do
            local data = self:getPatterrnByAfterRandUp(RAND_PATTERN[1],1)
            self:mergeData(resultData.base,data)
        end
--        return resultData
    elseif num == 2 then
        while self:getAllNumByData(resultData.base) <30 do
            local data = self:getPatterrnByAfterRandUp(RAND_PATTERN[2],2)
            self:mergeData(resultData.base,data)
        end
        while self:getAllNumByData(resultData.base) <RAND_GAMEDATA[2] do
            local data = self:getPatterrnByAfterRandUp(RAND_PATTERN[1],1)
            self:mergeData(resultData.base,data)
        end
--        return resultData
    elseif num == 3 then
        local data = self:getPatterrnByAfterRandUp(RAND_PATTERN[3],3)
        self:mergeData(resultData.base,data)
        while self:getAllNumByData(resultData.base) < RAND_GAMEDATA[3] do
            local data = self:getPatterrnByAfterRandUp(RAND_PATTERN[1],1)
            self:mergeData(resultData.base,data)
        end
--        return resultData
    elseif num == 4 then
        local rd = math.random(3)
        return self:getRandGameData(rd)
    end
    
    self:checkData(resultData.base)
    local num = self:getAllNumByData(resultData.base)
    print("游戏base层总数量 ＝＝＝＝＝＝"..num)
    
    return resultData
end

---------------------------------
--获取pattern信息
--
 function LevelManager:getPatternLevel(num,pnum)
    local str = "app.data.patterndata."
    if pnum == 1 then
        str = str.."small.P_"..num
    elseif pnum ==2 then
        str = str.."mid.M_"..num
    elseif pnum == 3 then
        str = str.."big.B_"..num
    end
    local data = require(str)
    return data.layers[1].data
 end

-------------------------------
--获取随机pattern
--pnum 1 small 2 mid 3 big
--num最多pattern数量
--
function LevelManager:_getRandPatternNum(num,pnum)
    local rn = math.random(num)
    return self:getPatternLevel(rn,pnum)
end


----------------------------------
--  获得当前pattern能够向上移动的最大长度
-- 
function LevelManager:_getMaxUpLenthByPattern(data)
    for key,value in ipairs(data) do
        if value == 1 then
            local num = math.floor(key/GRID_WIDTH)
            return num
        end
    end
end

----------------------------------
--获得当前data数据中 1 的个数
-- 
function LevelManager:getAllNumByData(data)
    local count = 0
    for _,value in ipairs(data) do
        if value == 1 then
            count = count + 1
        end
    end
    return count
end

----------------------------------
--将data数据向上移动并返回
-- 
function LevelManager:_setUpDataByNum(data,num)
    for key,value in ipairs(data) do
        if value == 1 then
            data[key] = 0
            data[key-GRID_WIDTH*num] = 1
        end
    end
end


----------------------------------
----作出相应随机移动后的
--获取最终需要的pattern数据
-- 
function LevelManager:getPatterrnByAfterRandUp(num,pnum)
    local data = self:_getRandPatternNum(num,pnum)
    local maxUp = self:_getMaxUpLenthByPattern(data)
    local rdNum = math.random(maxUp)
    if rdNum ~= maxUp then
        self:_setUpDataByNum(data,rdNum)
    end
    return data
end

----------------------------------
--合并data表中数据
-- 
function LevelManager:mergeData(needData,data)
    for key,value in ipairs(data) do
        if value == 1 then
            needData[key] = 1
        end
    end
end


----------------------------------
--矫正base层奇数  
-- 
function LevelManager:checkData(data)
    local num = self:getAllNumByData(data)
    if num%2 == 1 then
        local rd = math.random(10)
        while data[rd*GRID_WIDTH+6] == 0 do
            rd = math.random(10)
        end
        data[rd*GRID_WIDTH+6] = 0
    end
end

----------------------------------
--测试代码
--
function LevelManager:test()
    local data = self:getPatternLevel(22,1)
    local up = self:_getMaxUpLenthByPattern(data)
    print("===========================up"..up)
    local ta = {}
    ta.base = data
    return ta
end

return LevelManager