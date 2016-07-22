local MainBottom = class("MainBototm",cc.load("mvc").ViewBase)
MainBottom.RESOURCE_FILENAME = "mainroom/main_bottom"

function MainBottom:onCreate()
    self:get():move(0,0)

end

function MainBottom:onClick(path,node,funcName)
    if funcName == "btnSingle" then
        local function btnCallback(node,eventType)
            print("btnSingle")
            AppViews:getView(LAYERS.main_room):showSingle()
        end
        return btnCallback
    elseif funcName == "btnPK" then
        local function btnCallback(node,eventType)
            print("btnPK")
            AppViews:getView(LAYERS.main_room):showPK()
        end
        return btnCallback
    elseif funcName == "btnAnimal" then
        local function btnCallback(node,eventType)
            print("btnAnimal")
            AppViews:getView(LAYERS.main_room):showAnimal()
        end
        return btnCallback
    elseif funcName == "btnRoom" then
        local function btnCallback(node,eventType)
            print("btnRoom")
            AppViews:getView(LAYERS.main_room):showRoom()
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("MainRoom:nnnnnnnnnnnn")
        end
        return btnCallback
    end
end

return MainBottom