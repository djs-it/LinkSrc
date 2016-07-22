local ElementSprite = class("ElementSprite",function(imageFilename)
    return display.newNode()
end)


--$$$$$$$$$$$$  CTOR   $$$$$$$$$$$$$

function ElementSprite:ctor(type)
    --    self.isHaveChild = nil
    self.isSelect = false
    self.sp = display.newSprite(string.format("#sp-%s.png",type or 0))
        :addTo(self)
    self.back = display.newSprite(string.format("#sp-118.png"))
        :addTo(self)
        :setLocalZOrder(ELEMENT_ZORDER)
        :hide()
    self.select = display.newSprite("#sp-select.png")
        :addTo(self)
        :hide()
end


function ElementSprite:addEffect(type)
    self.effect = display.newSprite(string.format("#sp-%s.png",type or 0))
        :addTo(self)

end


function ElementSprite:removeEffect()
    if self.effect then
        self.effect:removeSelf()
        self.effect = nil
    end
end

function ElementSprite:hideEffect()
    if self.effect then
        self.effect:setVisible(false)
    end
end

function ElementSprite:showEffect()
    if self.effect then
        self.effect:setVisible(true)
    end
end

function ElementSprite:showBack()
    if self.back then
        self.back:show()
    end
end

function ElementSprite:hideBack()
    if self.back then
        self.back:hide()
    end
end

function ElementSprite:selected()
    if not self.isSelect then
        self.isSelect = true
--        local x,y = self:getPosition()
--        self.select:show()
--        ac.execute(self,ac.ccSeq(ac.ccScaleTo(0.05,1.25),ac.ccEasing(ac.ccScaleTo(0.1,1.0),10)))
--        ac.execute(self,ac.ccMoveTo(0.05,cc.p(x,y+16)))
        ac.execute(self.sp,ac.ccSeq(ac.ccScaleTo(0.05,1.25),ac.ccEasing(ac.ccScaleTo(0.1,1.0),10)))
        ac.execute(self.sp,ac.ccMoveTo(0.05,cc.p(0,16)))
        
        ac.execute(self.back,ac.ccSeq(ac.ccScaleTo(0.05,1.25),ac.ccEasing(ac.ccScaleTo(0.1,1.0),10)))
        ac.execute(self.back,ac.ccMoveTo(0.05,cc.p(0,16)))
        
        self.select:show()
        ac.execute(self.select,ac.ccSeq(ac.ccScaleTo(0.05,1.25),ac.ccEasing(ac.ccScaleTo(0.1,1.0),10)))
        ac.execute(self.select,ac.ccMoveTo(0.05,cc.p(0,26)))
        
        if self.effect then
            ac.execute(self.effect,ac.ccSeq(ac.ccScaleTo(0.05,1.25),ac.ccEasing(ac.ccScaleTo(0.1,1.0),10)))
            ac.execute(self.effect,ac.ccMoveTo(0.05,cc.p(0,16)))
        end
    end
end


function ElementSprite:unselected()
    if self.isSelect then
        ac.stopTarget(self.sp)
        ac.stopTarget(self.back)
        ac.stopTarget(self.select)
        
        self.isSelect = false
        
        self.sp:move(0,0)
        self.sp:setScale(1)
        
        self.back:move(0,0)
        self.back:setScale(1)
        
        self.select:hide()
        self.select:move(0,0)
        self.select:setScale(1)
        
        if self.effect then
            self.effect:move(0,0)
            self.effect:setScale(1)
        end
    end
end



return ElementSprite