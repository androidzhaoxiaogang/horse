
require "Cocos2d"

-- cclog
local cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end


gVisibleSize = cc.Director:getInstance():getVisibleSize()

local function mainLoop(dt)
    local module = nil
    function modulLoop()
        module:OnLoop(delta)
    end

    module = GameManager
    xpcall(modulLoop, __G__TRACKBACK__)

    module = SceneManager
    xpcall(modulLoop, __G__TRACKBACK__)
end 

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")

    CCDirector:getInstance():setDisplayStats(true)
    CCDirector:getInstance():getScheduler():scheduleScriptFunc(MainLoop, 0, false)
end

local status, msg = xpcall(main, __G__TRACKBACK__)

if not status then
    error(msg)
end
