local Buy = class("Buy",cc.load("mvc").ViewBase)
Buy.RESOURCE_FILENAME = "mainbuy/buy"

function Buy:onCreate()
    self:get():move(0,0)
end

function Buy:onClick(path,node,funcName)
    if funcName == "btnClose" then
        local function btnCallback()
            print("btnClose")
            self:hide()
        end
        return btnCallback
    elseif funcName == "btnMember" then
        local function btnCallback()
            print("btnMember")
            self:btnMemberClick()
        end
        return btnCallback
    elseif funcName == "btnGold" then
        local function btnCallback()
            print("btnGold")
            self:btnGoldClick()
        end
        return btnCallback
    elseif funcName == "btnGem" then
        local function btnCallback()
            print("btnGem")
            self:btnGemClick()
        end
        return btnCallback
    else
        local function btnCallback()
            print("buy:nnnnnnnnnnnnnn")
        end
        return btnCallback
    end
end

function Buy:btnMemberClick()
    self.membercsd:show()
    self.goldcsd:hide()
    self.gemcsd:hide()
end

function Buy:btnGoldClick()
    self.membercsd:hide()
    self.goldcsd:show()
    self.gemcsd:hide()
end

function Buy:btnGemClick()
    self.membercsd:hide()
    self.goldcsd:hide()
    self.gemcsd:show()

end

return Buy