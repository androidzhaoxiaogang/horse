
--=======================================================================
-- File Name    : logger.lua
-- Author       : zhaoxiaogang
-- Date         : 2014/7/25 15:42:53
-- Description  : logger system
-- Modify       : 
--=======================================================================

Log = Log or {}

local debuggable = true

function Log:enableDebug(debug)
    debuggable = debug
end

__print = print

print = function(...)
    local trace = debug.traceback()
    index = 0
    local msg = os.date("%Y-%m-%d %H:%M:%S", os.time()) .. ' '
    for w in string.gmatch(trace, ".") do
        if(w=="\n") then
            index = index + 1
        end
        if(index == 2 and w~="\n" and w~="\t") then
            msg = msg .. w
        end
    end
    msg = msg .. ":"
    __print(msg, ...)
end

function Log:formatText(fmt, ...)
    local result, text = pcall(string.format, fmt, ...)
    if not result then
        text = fmt
        
        for index=1,select("#", ...) do
        	local temp = select(index, ...)
            text = text .. "\t" .. tostring(temp)
        end
    end
    
    return text
end

---------------------------
--@return #type description
function Log:i(fmt, ...)
    if debuggable then 
        local text = "[LOG INFO:]" .. self:formatText(fmt, ...)
        print(text)
        return text
    end 
end

---------------------------
--@return #type description
function Log:d(fmt, ...)
    if debuggable then 
        local text = "[LOG DEBUG:]" .. self:formatText(fmt, ...)
        print(text)
    end
end

---------------------------
--@return #type description
function Log:w(fmt, ...)
    if debuggable then 
        local text = "[LOG WARNING:]" .. self:formatText(fmt, ...)
        print(text)
    end
end

---------------------------
--@return #type description
function Log:e(fmt, ...)
    if debuggable then 
        local text = "[LOG ERROR:]" .. self:formatText(fmt, ...)
        print(text)
    end
end

function Log:destroy()

end

