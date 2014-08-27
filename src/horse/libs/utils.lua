--=======================================================================
-- File Name    : utils.lua
-- Author       : zhaoxiaogang
-- Date         : 2014/8/17 10:42:50
-- Description  : common tools.
-- Modify       :
--=======================================================================

Utils = Utils or {}

---------------------------
--@return #boolean check if the string is an empty string.
function Utils:isEmptyStr(str)
	if str == nil or str == "" then
	   return true
	end 
	
	return false
end

function Utils:printStackTrace(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
    return msg
end

---------------------------
--@return # excute a function to catch the exception.
function Utils:safeExecute(func)
    local function excute()
        return func[1](unpack(func, 2))
    end
    return xpcall(excute, self.printStackTrace)
end















