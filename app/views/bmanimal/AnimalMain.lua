local AnimalMain = class("AnimalMain",cc.load("mvc").ViewBase)
AnimalMain.RESOURCE_FILENAME ="bmanimal/animal_main"

local AnimalCell = import(".AnimalCell")

function AnimalMain:onCreate()
    self:get():move(0,0)

    self.cellx = 172
    self.celly = 182

    self.changeCellX = 126
    self.changeCellY = 132

    local anmdata = {}

    for i=2,16 do
        table.insert(anmdata,i)
    end
    helper.saveSloterData(SLOTER.animal_have,anmdata)

    self.have = self:getAnmHave()

    self.stageAnm = {}
    self.stageAnm[1] = 3
    self.stageAnm[2] = 9
    helper.saveSloterData(SLOTER.animal_stage,self.stageAnm)


    self.mainCell = {}
    self.changeCell = {}

    self:initView()

end

function AnimalMain:onClick(path,node,funcName)
    if funcName == "btnClose" then
        local function btnCallback(node,eventType)
            print("btnClose")
            AppViews:getView(LAYERS.main_room):hideAllView()
        end
        return btnCallback
    elseif funcName == "btnTurnRight" then
        local function btnCallback(node,eventType)
            print("btnTurnRight")
            self:turnMainPage(1)
        end
        return btnCallback
    elseif funcName == "btnTurnLeft" then
        local function btnCallback(node,eventType)
            print("btnTurnLeft")
            self:turnMainPage(-1)
        end
        return btnCallback
    elseif funcName == "btnChangeRight" then
        local function btnCallback(node,eventType)
            print("btnChangeRight")
            self:turnChangePage(1)
        end
        return btnCallback
    elseif funcName == "btnChangeLeft" then
        local function btnCallback(node,eventType)
            print("btnChangeLeft")
            self:turnChangePage(-1)
        end
        return btnCallback
    elseif funcName == "btnAnmRight" then
        local function btnCallback(node,eventType)
            print("btnAnmRight")
            self:showChangeCsd(false)
        end
        return btnCallback
    elseif funcName == "btnAnmLeft" then
        local function btnCallback(node,eventType)
            print("btnAnmLeft")
            self:showChangeCsd(true)
        end
        return btnCallback
    elseif funcName == "btnCloseChange" then
        local function btnCallback(node,eventType)
            print("btnCloseChange")
            self:btnCloseChangeClick()
        end
        return btnCallback
    elseif funcName == "btnDown" then
        local function btnCallback(node,eventType)
            print("btnDown")
            self:btnDownClick()
        end
        return btnCallback
    elseif funcName == "btnUp" then
        local function btnCallback(node,eventType)
            print("btnUp")
            self:btnUpClick()
        end
        return btnCallback
    elseif funcName == "btnCloseProperty" then
        local function btnCallback(node,eventType)
            print("btnCloseProperty")
            self.propertycsd:hide()
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("AnimalMain:nnnnnnnnnnnnnn")
        end
        return btnCallback
    end

end

function AnimalMain:initView()
    self:setMainCell()
    self:setChangeCell()

    self.changecsd:hide()
    self.propertycsd:hide()

    self.stageAnm = LinkUtil:getStageAnimal()
    self.stageleft = self.stageAnm[1]
    self.stageright = self.stageAnm[2]

    if self.stageleft and self.stageleft ~= 0 then
        self.stageLeftAnm = display.newSprite(string.format("#anm-%s.png",self.stageleft))
        self.stageLeftAnm:addTo(self.anmleftcsd)
    end

    if self.stageright and self.stageright ~= 0 then
        self.stageRightAnm = display.newSprite(string.format("#anm-%s.png",self.stageright))
        self.stageRightAnm:addTo(self.anmrightcsd)
    end
end

function AnimalMain:setChangeNo()
    self.btnDown:hide()
    self.btnUp:hide()
    self.btnNotCan:show()
end

function AnimalMain:setChangeUp()
    self.btnDown:hide()
    self.btnUp:show()
    self.btnNotCan:hide()
end

function AnimalMain:setChangeDown()
    self.btnDown:show()
    self.btnUp:hide()
    self.btnNotCan:hide()
end

function AnimalMain:showPropertyCsd()
    self.propertycsd:show()
end


function AnimalMain:setMainCell()
    self.allAnm = self:getAnmList()
    for page = 1,math.ceil(#self.allAnm/8.0) do
        local layout = ccui.Layout:create()
        layout:setContentSize(cc.size(self.cellx*4,self.celly*2))
        for i = 1,8 do
            if 8*(page-1) +i <= #self.allAnm then
                local index = (page-1)*8 +i
                local cell = AnimalCell:create(self:getApp(),"cell")
                self.mainCell[self.allAnm[index]] = cell
                if (index <= self:getAnmHaveNum()) then
                    cell:initView(self.allAnm[index],true,false,1)
                else
                    cell:initView(self.allAnm[index],false,false,1)
                end
                local id = i % 8
                if id == 0 then
                    id = 8
                end

                cell:setAnchorPoint(0.5,0.5)
                local pt = self:getCellPtById(id,1)
                cell:setPosition(pt)
                cell:addTo(layout)
            end
        end

        self.mainTV:addPage(layout)
    end
    self.mainTV:scrollToPage(0)
end

function AnimalMain:setChangeCell()
    for page = 1,math.ceil(#self.have/8.0) do
        local layout = ccui.Layout:create()
        layout:setContentSize(cc.size(self.changeCellX*4,self.changeCellY*2))
        for i = 1,8 do
            if 8*(page-1) +i <= #self.have then
                local index = (page-1)*8+i
                local cell = AnimalCell:create(self:getApp(),"changecell")
                self.changeCell[self.have[index]] = cell
                cell:initView(self.have[index],true,false,2)

                local ptid = i%8
                if ptid == 0 then
                    ptid = 8
                end

                cell:setScale(self.changeCellX/self.cellx)
                cell:setAnchorPoint(0.5,0.5)
                local pt = self:getCellPtById(ptid,2)
                cell:setPosition(pt)
                cell:addTo(layout)
            end
        end
        self.changeTV:addPage(layout)
    end
    self.changeTV:scrollToPage(0)
end

----------------------------------------
--btn>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function AnimalMain:btnCloseChangeClick()
    self.changeCell[self.changeId]:setNoSelect()
    if self.isChangeLeft then
        self.stageAnm[1] = self.changeId
    else
        self.stageAnm[2] = self.changeId
    end
    helper.saveSloterData(SLOTER.animal_stage,self.stageAnm)
    
    self.changecsd:hide()
    self.changeId = nil
end

function AnimalMain:turnMainPage(sign)
    local pageindex = self.mainTV:getCurrentPageIndex() + sign
    if pageindex < 0 then
        pageindex = 0
    end
    if pageindex > 2 then
        pageindex = 2
    end
    self.mainTV:scrollToPage(pageindex)
end

function AnimalMain:turnChangePage(sign)
    local pageindex = self.changeTV:getCurrentPageIndex() + sign
    if pageindex < 0 then
        pageindex = 0
    end
    if pageindex > (math.ceil(#self.have/8)-1) then
        pageindex = math.ceil(#self.have/8)-1
    end
    print(pageindex)
    self.changeTV:scrollToPage(pageindex)
end

function AnimalMain:showChangeCsd(isLeft)
    self.changeTV:scrollToPage(0)
    self.isChangeLeft = isLeft
    if isLeft then
        if self.stageleft ~= 0 then
            self.changeStageAnm = display.newSprite(string.format("#anm-%s.png",self.stageleft))
            self.changeId = self.stageleft
            self.changeStageAnm:addTo(self.changestagecsd)
        end
    else
        if self.stageright ~= 0 then
            self.changeStageAnm = display.newSprite(string.format("#anm-%s.png",self.stageright))
            self.changeId = self.stageright
            self.changeStageAnm:addTo(self.changestagecsd)
        end
    end

    if self.changeId then
        self.changeCell[self.changeId]:setSelect()
        self:setChangeDown()
    else
        self:setChangeNo()
    end

    self.changecsd:show()
end

function AnimalMain:btnDownClick()
    self:setChangeUp()

    if self.isChangeLeft then
        self.stageleft = 0
        if self.stageLeftAnm then
            self.stageLeftAnm:removeSelf()
        end
        self.stageAnm[1] = 0

    else
        self.stageright = 0
        if self.stageRightAnm then
            self.stageRightAnm:removeSelf()
        end
        self.stageAnm[2] = 0
    end
end

function AnimalMain:btnUpClick()
    self:setChangeDown()

    if self.isChangeLeft then
        self.stageleft = self.changeId
        if self.stageLeftAnm ~= nil then
            self.stageLeftAnm:removeSelf()
        end
        self.stageLeftAnm = display.newSprite(string.format("#anm-%s.png",self.changeId))
        self.stageLeftAnm:addTo(self.anmleftcsd)
        self.stageAnm[1] = self.changeId
    else
        self.stageright = self.changeId
        if self.stageRightAnm ~= nil then
            self.stageRightAnm:removeSelf()
        end
        self.stageRightAnm = display.newSprite(string.format("#anm-%s.png",self.changeId))
        self.stageRightAnm:addTo(self.anmrightcsd)
        self.stageAnm[2] = self.changeId
    end

end

--btn>>>>>>>>>>>>>>>>>>>>>>>>>>>
----------------------------------------------


----------------------------------------
--change界面当前选中id
--
function AnimalMain:getChangeId()
    return self.changeId
end

function AnimalMain:setChangeId(num)
    if self.isChangeLeft then
        if self.stageright == num then
            self:setChangeNo()
        elseif self.stageleft == num then
            self:setChangeDown()
        else
            self:setChangeUp()
        end
    else
        if self.stageleft == num then
            self:setChangeNo()
        elseif self.stageright == num then
            self:setChangeDown()
        else
            self:setChangeUp()
        end
    end

    if self.changeStageAnm then
        self.changeStageAnm:removeSelf()
    end
    self.changeStageAnm = display.newSprite(string.format("#anm-%s.png",num))
    self.changeStageAnm:addTo(self.changestagecsd)

    if self.changeId then
        self.changeCell[self.changeId]:setNoSelect()
    end
    self.changeCell[num]:setSelect()
    self.changeId = num

end

----------------------------------------
--根据坐标id获取cell位置
--
function AnimalMain:getCellPtById(id,num)
    local cellx,celly
    if num == 1 then
        cellx = self.cellx
        celly = self.celly
    elseif num == 2 then
        cellx = self.changeCellX
        celly = self.changeCellY
    end
    local x = id%4
    if x == 0 then
        x = 4
    end
    local y = 3-math.ceil(id/4.0)

    local px = (2*x-1) * cellx/2
    local py = (2*y-1) * celly/2
    return cc.p(px,py)
end


----------------------------------------
--获取宠物列表顺序
--
function AnimalMain:getAnmList()
    local data = {}
    local hdata = self:getAnmHave()
    local ndata = self:getAnmNotHave()
    for _,value in ipairs(hdata) do
        table.insert(data,value)
    end
    for _,value in ipairs(ndata) do
        table.insert(data,value)
    end
    return data
end

----------------------------------------
--获取已经拥有的宠物数量
--
function AnimalMain:getAnmHaveNum()
    return #self.have
end

----------------------------------------
--获取已经拥有的宠物
--
function AnimalMain:getAnmHave()
    return helper.getSloterData(SLOTER.animal_have)
end

----------------------------------------
--获取尚未拥有的宠物
--
function AnimalMain:getAnmNotHave()
    local data = {}
    for i = 1,ANIMAL_ALL_NUM do
        if not self:isHaveById(i) then
            table.insert(data,i)
        end
    end
    return data
end

----------------------------------------
--判断宠物是否拥有
--
function AnimalMain:isHaveById(id)
    for _,value in ipairs(self.have) do
        if id == value then
            return true
        end
    end
    return false
end


return AnimalMain