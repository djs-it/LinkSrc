---------------------------
--扩展TebleViewCell，可容纳多列
--
--@type TebleViewCell


local TebleViewCell = cc.TableViewCell

TebleViewCell.touchCell = nil

--------------------
--添加modelView
--@function [parent=#TableModelViewCell] addView
function TebleViewCell:addView(content)
    self.cells_ = self.cells_ or 0
    self.cells_ = self.cells_ + 1
    self:addChild(content)
    if not self.table then
        self.table = {}
    end
    table.insert(self.table,content)
end

function TebleViewCell:clear()
    for _, content in ipairs(self.table) do
        content:removeSelf()
    end
    self.table = {}
    self.cells_ = 0
end


-------------
--获取model，默认第一个
--@function [parent=#TableModelViewCell] getView
--@param number col 列
function TebleViewCell:getView(view)
    if view then
        return self.table[view]
    else
        return self.table[1]
    end
end


return TebleViewCell