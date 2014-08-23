--=======================================================================
-- File Name    : SceneManager.lua
-- Author       : zhaoxiaogang
-- Date         : 2014/7/31 09:42:50
-- Description  : class
-- Modify       :
--=======================================================================

SceneManager  = SceneManager or {}

function SceneManager:init()
    self.sceneTemplateList = {}
    self.sceneNameList = {}
    self.sceneList = {}
end

function SceneManager:destroy()
    for sceneName, scene in pairs(self.sceneList) do
        scene:destroy()
    end
    self.sceneNameList = nil
    self.sceneList = {}
end

function SceneManager:createScene(sceneName, sceneTemplateName)
    if self.sceneList[sceneName] then
        cclog("Create scene [%s] failed, already exists", sceneName)
        return
    end
    if not sceneTemplateName then
        sceneTemplateName = sceneName
    end
    local sceneTemplateName = self:getSceneTemplate(sceneTemplateName)
    if not sceneTemplateName then
        return print("No scene class [%s] exits!", sceneTemplateName)
    end
    local scene = EventClass:new(sceneTemplateName, sceneName)
    scene.sceneTemplateName = sceneTemplateName
    self.sceneList[sceneName] = scene
    if scene:__init(sceneName) ~= 1 then
        self:destroyScene(sceneName)
        return nil
    end
    Event:postEvent("SCENE.CREATE", sceneTemplateName, sceneName)
    return scene
end

function SceneManager:destroyScene(sceneName)
    if not self.sceneList[sceneName] then
        cclog("Create scene [%s] failed, not exists", sceneName)
        return
    end
    local index = nil
    for index, name in ipairs(self.sceneNameList) do
        if name == sceneName then
            index = index
            break
        end
    end
    if index then
        table.remove(self.sceneNameList, index)
    end
    
    local className = self.sceneList[sceneName]:__getClassName()
    Event:postEvent("SCENE.DESTORY", className, sceneName)
    
    local scene = self.sceneList[sceneName]
    if scene then
        scene:destroy()
        self.sceneList[sceneName] = nil
    end
    return 1
end

function SceneManager:getSceneTemplate(className)
    if not self.sceneTemplateList[className] then
        local newScene = EventClass:new(RootScene, className)
        newScene.eventListener = {}
        self.sceneTemplateList[className] = newScene
    end
    return self.sceneTemplateList[className]    
end

function SceneManager:getCurrentScene()
    local currentSceneName = self:getCurrentSceneName()
    if currentSceneName then
        return self.sceneList[currentSceneName]
    end
end

function SceneManager:getCurrentSceneName()
    local count = #self.sceneNameList
    if count > 0 then
        return self.sceneNameList[count]
    end
end

function SceneManager:getSceneObj(sceneName)
    local scene = self.sceneList[sceneName]
    
    if scene then
        return scene:getScene()
    end
end

function SceneManager:unLoadCurrentScene()
    local currentSceneName = self:getCurrentSceneName()
    self:DestroyScene(currentSceneName)
    CCDirector:getInstance():popScene()
    local scene = self:getCurrentScene()
end

function SceneManager:reloadCurrentScene()
    local currentSceneName = self:getCurrentSceneName()
    local scene = self.sceneList[currentSceneName]
    local sceneTemplateName = scene:getClassName()
    self:unLoadCurrentScene()
    return self:loadSceneByName(sceneTemplateName, currentSceneName)
end

function SceneManager:firstLoadScene(sceneTemplateName, sceneName)
    if not sceneName then
        sceneName = sceneTemplateName
    end
    table.insert(self.sceneNameList, sceneName)
    local scene = self.sceneList[sceneName]
    if not scene then
        scene = self:createScene(sceneName, sceneTemplateName)
    end
    if not scene then 
        return
    end
    local loadScene = scene:getScene()
    
    if not loadScene then 
        return 
    end 
    
    cc.Director:getInstance():runWithScene(loadScene)
end

function SceneManager:loadSceneByName(sceneTemplateName, sceneName)
    if not sceneName then
        sceneName = sceneTemplateName
    end
    table.insert(self.sceneNameList, sceneName)
    local scene = self.sceneList[sceneName]
    if not scene then
        scene = self:createScene(sceneName, sceneTemplateName)
    end
    if not scene then
        return
    end
    local loadScene = scene:getScene()
    cc.Director:getInstance():pushScene(loadScene)
    return scene
end

function SceneManager:getRootSceneName()
    return self.sceneNameList[1]
end

function SceneManager:isRootScene()
    local count = #self.sceneNameList
    if count == 1 then
        return true
    end
    return false
end
