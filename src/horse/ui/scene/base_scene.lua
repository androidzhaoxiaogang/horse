--=======================================================================
-- File Name    : base_scene.lua
-- Author       : 赵小刚
-- Date         : 2014/08/01 09:42:50
-- Description  : 场景基类
--=======================================================================

BaseScene = BaseScene or class("BaseScene")

local defaultsize = cc.Director:getInstance():getVisibleSize()

function BaseScene:ctor(sceneName)
    Log:i("====BaseScene:init====")
    
    self.sceneName = sceneName
    self.sceneObj = cc.Scene:create()
    
    self.layerList = {}

    self.minWidthScale = 0
    self.minHeightScale = 0
    
    self:setWidth(defaultsize.width)
    self:setHeight(defaultsize.height)
    
    
    
    UI:initScene(self.sceneName, self.sceneObj)
    
    --Ui:addLayer(name, self.scene)
end

function BaseScene:destroy()
    self.layerList = nil
    self.name = nil
    self.scene = nil
end

function BaseScene:setWidth(width)
    self.width = width
    self.minWidthScale = defaultsize.width / width

    self.minScale = self.minWidthScale > self.minHeightScale
        and self.minWidthScale or self.minHeightScale
end

function BaseScene:setHeight(height)
    self.height = height
    self.minHeightScale = defaultsize.height / height

    self.minScale = self.minWidthScale > self.minHeightScale
        and self.minWidthScale or self.minHeightScale
end

function BaseScene:getSceneObj()
	return self.sceneObj
end

function BaseScene:createLayer(layerName)
    if self.layerList[layerName] then
        cclog("Layer [%s] create Failed! Already Exists", layerName)
        return nil
    end
    local layer = cc.Layer:create()
    assert(self:addLayer(layerName, layer) == 1)
    return layer
end

function BaseScene:addLayer(layerName, layer)
    self.scene:addChild(layer)
    self.layerList[layerName] = layer
end

function BaseScene:getLayer(layerName)
    return self.layerList[layerName]
end

