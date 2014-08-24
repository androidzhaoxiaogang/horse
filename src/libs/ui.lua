Ui = Ui or {}

function Ui:Init()
    self.sceneUiList = {}
end

function Ui:Uninit()
    self.sceneUiList = {}
end

function Ui:initScene(sceneName, sceneObj)
    if self.sceneUiList[sceneName] then
        Log.w("Scene [%s] already existed!!!", sceneName)
        return
    end

    local uiContainer = {}
    uiContainer.elementList = {
        ["MENU"] = {},
        ["LABELTTF"] = {},
        ["LABELBMFONT"] = {},
        ["LABEL"] = {},
    }

    local rootLayer = CCLayer:create()        

    sceneObj:addChild(rootLayer)

    uiContainer.sceneObj = sceneObj
    uiContainer.rootLayer = rootLayer

    self.sceneUiList[sceneName] = uiContainer
end

function Ui:destroyScene(sceneName)
    local uiContainer = self.sceneUiList[sceneName]
    if not uiContainer then
        Log.w("[%s] not exitst", sceneName)
        return
    end
    
    for _, elements in pairs(uiContainer.elementList) do
        for _, element in pairs(elements) do
            uiContainer.rootLayer:removeChild(element, true)
        end
    end
    
    uiContainer.sceneObj:removeChild(uiContainer.rootLayer)

    uiContainer.elementList = nil
    uiContainer.sceneObj = nil
    uiContainer.rootLayer = nil
    self.sceneUiList[sceneName] = nil
end

function Ui:addElement(uiContainer, elementType, elementName, positionX, 
    positionY, element)
    local elementList = self:getSameTypeElement(uiContainer, elementType)
    if not elementList then
        return
    end
    if elementList[elementName] then
        Log:i("[%s][%s]Already Exists", elementType, elementName)
        return
    end
    uiContainer.rootLayer:addChild(element)
    if positionX and positionY then
        element:setPosition(positionX, positionY)
    end
    elementList[elementName] = element
end

function Ui:getElement(window, elementType, elementName)
    local elementList = self:getSameTypeElement(window, elementType)
    if not elementList then
        return
    end
    if not elementList[elementName] then
        return
    end
    return elementList[elementName]
end

function Ui:getSameTypeElements(uiContainer, elementType)
    local elements = uiContainer.elementList[elementType]
    if not elements then
        assert(false)
    end
    return elements
end

function Ui:LoadJson(layer, jsonFilePath)
    local rootWidget = ccs.GUIReader:getInstance():widgetFromJsonFile(jsonFilePath)
    local widgetRect = rootWidget:getSize()
    layer:addChild(rootWidget)
    return rootWidget, widgetRect
end

function Ui:loadCocosUi(scentName, ui_list)
    
end













