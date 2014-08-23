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

---------------------------
--@return # safe to excute a function.
function Utils:safeExecute(func)
    local function excute()
        return func[1](unpack(func, 2))
    end
    return xpcall(excute, self.printStackTrace)
end















