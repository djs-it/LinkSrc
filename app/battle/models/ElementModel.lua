local ElementModel = class("ElementModel")

--$$$$$$$$$$$$  CONFIG   $$$$$$$$$$$$$

--$$$$$$$$$$$$  CTOR   $$$$$$$$$$$$$

function ElementModel:ctor(base,magic,effect)
    self.base = base
    self.magic = magic
    self.effect = effect
end

--$$$$$$$$$$$$  LOGIC&OTHRE   $$$$$$$$$$$$$

function ElementModel:setBase(base)
    self.base = base
end

function ElementModel:getBase()
    return self.base
end

function ElementModel:setMagic(magic)
    self.magic = magic
end

function ElementModel:getMagic()
    return self.magic
end

function ElementModel:setEffect(effect)
    self.effect = effect
end

function ElementModel:getEffect()
    return self.effect
end

return ElementModel