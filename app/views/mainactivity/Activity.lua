local Activity = class("Activity",cc.load("mvc").ViewBase)
Activity.RESOURCE_FILENAME = "mainactivity/activity"

function Activity:onCreate()
    self:get():move(0,0)
end

function Activity:onClick(path,node,funcName)
    if funcName == "btnSign" then
        local function btnCallback()
            print("btnSign")
            self:btnSignClick()
        end
        return btnCallback
    elseif funcName == "btnPresent" then
        local function btnCallback()
            print("btnPresent")
            self:btnPresentClick()
        end
        return btnCallback
    elseif funcName == "btnActivity" then
        local function btnCallback()
            print("btnActivity")
            self:btnActivityClick()
        end
        return btnCallback
    elseif funcName == "btnMask" then
        local function btnCallback()
            print("btnMask")
            self:hide()
        end
        return btnCallback
    else
        local function btnCallback()
            print("Activity:nnnnnnnn")
        end
        return btnCallback
    end
end

function Activity:btnSignClick()
    self:show()
    self.signcsd:show()
    self.presentcsd:hide()
    self.activitycsd:hide()
end

function Activity:btnPresentClick()
    self:show()
    self.signcsd:hide()
    self.presentcsd:show()
    self.activitycsd:hide()
end

function Activity:btnActivityClick()
    self:show()
    self.signcsd:hide()
    self.presentcsd:hide()
    self.activitycsd:show()
end

return Activity