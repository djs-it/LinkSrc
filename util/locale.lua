--[[
Load a mo file, retuan a lua function or table.
A sample and description(in chinese): http://zengrong.net/post/1986.htm 

@see http://lua-users.org/lists/lua-l/2010-04/msg00005.html
Modifier zrong(zengrong.net)
Creation 2013-11-29

usage:

local mo_data=assert(require("util.locale").loadMOFromFile("main.mo"))
print(mo_data["hello"])
-- 你好
print(mo_data["world"])
-- nil

then you'll get a kind of gettext function:

local gettext=assert(require("util.locale").gettextFromFile("main.mo"))
print(gettext("hello"))
-- 你好
print(gettext("world"))
-- world

with a slight modification this will be ready-to-use for the xgettext tool:

_ = assert(require("utils.locale").gettextFromFile("main.mo"))
print(_("hello"))
print(_("world"))
]]

-- Original description
-----------------------------------------------------------
-- load an mo file and return a lua table
-- @param mo_file name of the file to load
-- @return table on success
-- @return nil,string on failure
-- @copyright J.J?rgen von Bargen
-- @licence I provide this as public domain
-- @see http://www.gnu.org/software/hello/manual/gettext/MO-Files.html
-----------------------------------------------------------

local locale = {}

function locale._getFileData(mo_file)
    local mo_data = cc.HelperFunc:getFileData(mo_file)
    return mo_data
end

function locale.saveDefault(language)
    helper.saveSloterData("locale_language", language)
end


function locale.defaultLang()
    return helper.getSloterData("locale_language")
end

function locale.loadDefault()
    local target = device.language
    local language = helper.getSloterData("locale_language")
    if nil == language then
        helper.saveSloterData("locale_language", target)
    else
        target = language
    end
    local file = "locale/" .. target .. ".mo"
    print(file)
    if cc.FileUtils:getInstance():isFileExist(file) then
        return locale.gettext(locale._getFileData(file))
    else
        helper.saveSloterData("locale_language", "en")
        return locale.gettext(locale._getFileData("locale/en.mo"))
    end
end


function locale.loadMOFromFile(mo_file)
    return locale.parseData(locale._getFileData(mo_file))
end

function locale.gettextFromFile(mo_file)
    return locale.gettext(locale._getFileData(mo_file))
end

function locale.gettext(mo_data)
    local __hash = locale.parseData(mo_data)
    return function(text)
        return __hash[text] or text
    end
end

function locale.parseData(mo_data)
    --------------------------------
    -- precache some functions
    --------------------------------
    local byte=string.byte
    local sub=string.sub

    --------------------------------
    -- check format
    --------------------------------
    local peek_long --localize
    local magic=sub(mo_data,1,4)
    -- intel magic 0xde120495
    if magic=="\222\018\004\149" then
        peek_long=function(offs)
            local a,b,c,d=byte(mo_data,offs+1,offs+4)
            return ((d*256+c)*256+b)*256+a
        end
        -- motorola magic = 0x950412de
    elseif magic=="\149\004\018\222" then
        peek_long=function(offs)
            local a,b,c,d=byte(mo_data,offs+1,offs+4)
            return ((a*256+b)*256+c)*256+d
        end
    else
        return nil,"no valid mo-file"
    end

    --------------------------------
    -- version
    --------------------------------
    local V=peek_long(4)
    if V~=0 then
        return nul,"unsupported version"
    end

    ------------------------------
    -- get number of offsets of table
    ------------------------------
    local N,O,T=peek_long(8),peek_long(12),peek_long(16)
    ------------------------------
    -- traverse and get strings
    ------------------------------
    local hash={}
    for nstr=1,N do
        local ol,oo=peek_long(O),peek_long(O+4) O=O+8
        local tl,to=peek_long(T),peek_long(T+4) T=T+8
        hash[sub(mo_data,oo+1,oo+ol)]=sub(mo_data,to+1,to+tl)
    end
    return hash    -- return table
end

return locale
