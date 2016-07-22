local MainBmBtn = class("MainBmBtn",cc.load("mvc").ViewBase)
MainBmBtn.RESOURCE_FILENAME = "mainroom/main_bm_btn"

function MainBmBtn:onCreate()
    self:get():move(0,0)
end

function MainBmBtn:onClick(path,node,funcName)
    if funcName == "btn_1" then
        local function btnCallback(node,eventType)
            print("btnSingle")
        end
        return btnCallback
    elseif funcName == "btn_2" then
        local function btnCallback(node,eventType)
            print("btnPK")
        end
        return btnCallback
    elseif funcName == "btn_3" then
        local function btnCallback(node,eventType)
            print("btnFriend")
        end
        return btnCallback
    elseif funcName == "btn_4" then
        local function btnCallback(node,eventType)
            print("btnRoom")
        end
        return btnCallback
    else
        local function btnCallback(node,eventType)
            print("MainRoom:nnnnnnnnnnnn")
        end
        return btnCallback
    end
end

function MainBmBtn:showBtn(num)
    for i = 1,4 do
        self["btn_"..i]:hide()
    end
    self["btn_"..num]:show()
end

return MainBmBtn