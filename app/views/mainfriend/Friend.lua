local Friend = class("Friend",cc.load("mvc").ViewBase)
Friend.RESOURCE_FILENAME = "mainfriend/friend"

function Friend:onCreate()
    self:get():move(0,0)
    self:initView()
end

function Friend:onClick(path,node,funcName)
    if funcName == "btnCloseFriend" then
        local function btnCallback()
            print("btnCloseFriend")
            self:hide()
        end
        return btnCallback
    else
        local function btnCallback()
            print("Friend:nnnnnnnnnnn")
        end
        return btnCallback
    end
end

function Friend:initView()

end


return Friend