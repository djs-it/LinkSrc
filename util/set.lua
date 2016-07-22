Set = {}
Set.mt = {}    -- metatable for sets


function Set.new (t)
    local set = {}
    setmetatable(set, Set.mt)
    for _, l in ipairs(t) do
        set[l] = true 
    end
    return set
end
function Set.newFromString (str)
    local set = Set.new({})
    for k in string.gmatch(str, "(%w+)") do
        Set.add(set,k)
    end
    return set
end

function Set.add (set,val)
    set[val] = true
end

function Set.remove(set, key)
    set[key] = nil
end

function Set.contains(set, key)
    return set[key] ~= nil
end

function Set.union (a,b)
    if getmetatable(a) ~= Set.mt or
        getmetatable(b) ~= Set.mt then
        error("attempt to `add' a set with a non-set value", 2)
    end
    local res = Set.new{}
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = true end
    return res
end

function Set.intersection (a,b)
    local res = Set.new{}
    for k in pairs(a) do
        res[k] = b[k]
    end
    return res
end
function Set.tostring (set)
    local s = "{"
    local sep = ""
    for e in pairs(set) do
        s = s .. sep .. e
        sep = ", "
    end
    return s .. "}"
end

function Set.print (s)
    print(Set.tostring(s))
end
Set.mt.__mul = Set.intersection
Set.mt.__add = Set.union


--local s = Set.new({1,"apple",3,4})
--Set.print(s)
--Set.print(Set.newFromString(Set.tostring(s)))
