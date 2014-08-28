--=======================================================================
-- File Name    : utils.lua
-- Author       : zhaoxiaogang
-- Date         : 2014/8/17 10:42:50
-- Description  : common tools.
-- Modify       :
--=======================================================================

Lib = Lib or {}

---------------------------
--@return #boolean check if the string is an empty string.
function Lib:isEmptyStr(str)
	if str == nil or str == "" then
	   return true
	end 
	
	return false
end

function Lib:printStackTrace(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
    return msg
end

---------------------------
--@return # excute a function to catch the exception.
function Lib:safeExecute(func)
    local function excute()
        return func[1](unpack(func, 2))
    end
    return xpcall(excute, self.printStackTrace)
end















