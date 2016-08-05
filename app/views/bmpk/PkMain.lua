local PkMain = class("PkMain",cc.load("mvc").ViewBase)
PkMain.RESOURCE_FILENAME = "bmpk/pk_main"

function PkMain:onCreate()
    self:get():move(0,0)
    LinkUtil:initStageAnm(self)
end

function PkMain:onClick(path,node,funcName)
    if funcName == "btnClosePk" then
        local function btnCallback()
            print("btnClosePk")
            AppViews:getView(LAYERS.main_room):hideAllView()
        end
        return btnCallback
    else
        local function btnCallback()
            print("pkmain:nnnnnnnnnnnnnn")
        end
        return btnCallback
    end
end

function PkMain:showView()
    LinkUtil:setStageAnm(self,0.6)
end

return PkMain