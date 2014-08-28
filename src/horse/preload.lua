local gScriptFileList = {}


function addPreloadFile(scriptFile)
    gScriptFileList[#gScriptFileList + 1] = scriptFile
end

function preloadScriptFile()
    for _, scriptFile in ipairs(gScriptFileList) do
        print("loading \""..scriptFile.."\"")
        require(scriptFile)
    end
    
    return true
end


addPreloadFile("horse/event/event_node.lua")
addPreloadFile("horse/event/event.lua")






