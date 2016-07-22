local UITebleView = class("UITebleView",function ()
    return display.newLayer()
end)


function UITebleView:ctor(_datas,size,viewCell)
    self.datas = _datas
    --tableview大小
    self.tableView = cc.TableView:create(size)
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setDelegate()
    self.tableView:setPosition(0,0)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self:addChild(self.tableView)

    local cw =  viewCell.width
    local cp =  viewCell.space or 0
    if cw then
        self.cols = math.floor(size.width/(cw+cp))
        self.cellwidth = cw
        self.cellspace = cp
        local touchLayer = display.newLayer()
            :addTo(self)
        touchLayer:onTouch(handler(self, self.touch))
    else
        self.cols = 1
    end

    local  function tableCellTouched(table,cell)
        local view = cell:getView(self.cellIdx)
        if view then
            view:onCellTouched()
        end
    end

    local  function tableCellUnHighLight(table,cell)
        local view = cell:getView(self.cellIdx)
        if view then
            view:setCellUnHighlight()
        end
    end

    local  function tableCellHighLight(table,cell)
        local view = cell:getView(self.cellIdx)
        if view then
            view:setCellHighlight()
        end
    end

    local  function cellSizeForTable(table,idx)
        return size.width,viewCell.height
    end

    local  function tableCellAtIndex(table, idx)
        --单元格内容
        local cell = table:dequeueCell()
        local cols = 1
        if viewCell.width then
            cols = math.floor(size.width/viewCell.width)
        end

        if nil == cell then
            cell = cc.TableViewCell:create()
            for v=1,cols do
                if idx*cols+v<=#self.datas then
                    local card = self.datas[idx*cols+v]
                    local cellview = viewCell.cellView:create()
                    if self.cols>1 then
                        cellview:move((v-1)*(self.cellwidth+self.cellspace),0)
                    end
                    cell:addView(cellview)
                    cellview:updateCell(card)
                end
            end
        else
            for v=1,cols do
                local card = self.datas[idx*cols+v]
                local cellview = cell:getView(v)
                if idx*cols+v<=#self.datas then
                    cellview:updateCell(card)
                else
                    cellview:clearCell()
                end
            end
        end

        return cell
    end

    local  function numberOfCellsInTableView(table)
        if viewCell.width then
            local cols = math.floor(size.width/viewCell.width)
            return math.ceil(#self.datas/cols)
        end
        return #self.datas
    end

    --注册事件
    self.tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(tableCellHighLight,cc.TABLECELL_HIGH_LIGHT)
    self.tableView:registerScriptHandler(tableCellUnHighLight,cc.TABLECELL_UNHIGH_LIGHT)
    self.tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:reloadData()

end



function UITebleView:getTableViw()
    return self.tableView
end

function UITebleView:updateTable(datas_)
    if datas_ then
        self.datas = datas_
    end
    self.tableView:reloadData()
end

function UITebleView:touch(event)
    if event.name == "began" then
        self.cellIdx = nil
        local  touch = self.tableView:convertToNodeSpace(cc.p(event.x,event.y))
        if self.cellwidth then
            local toucX  = math.ceil(touch.x/(self.cellwidth+self.cellspace))
            if touch.x > 0 and touch.x <= (toucX*(self.cellwidth+self.cellspace) - self.cellspace) then
                self.cellIdx = toucX
                return true
            else
                return false
            end
        else
            self.cellIdx = 1
        end
        return true
    elseif event.name == "moved" then
    elseif event.name == "ended" then
    end
end




return UITebleView