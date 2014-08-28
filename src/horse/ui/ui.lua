Ui = Ui or {}

function Ui:init()
    self.sceneUiList = {}
end

function Ui:destroy()
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

function Ui:getElement(uiContainer, elementType, elementName)
    local elementList = self:getSameTypeElement(uiContainer, elementType)
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

function Ui:loadJson(layer, jsonFilePath)
    local rootWidget = ccs.GUIReader:getInstance():widgetFromJsonFile(jsonFilePath)
    local widgetRect = rootWidget:getSize()
    layer:addChild(rootWidget)
    return rootWidget, widgetRect
end

function Ui:loadCocosUi(scentName, uiList)
    local uiContainer = self:getSceneUi(scentName)
    if uiList and uiContainer then
        if not uiContainer.cocosWidget then
            uiContainer.cocosWidget = {}
        end
        local layer = self:getLayer(uiContainer)
        for uiFile, data in pairs(uiList) do
            local rootWidget, rootWidget = self:LoadJson(layer, uiFile)
            local widget_rect = rootWidget:getSize()
            rootWidget:setScaleX(gVisibleSize.width / widget_rect.width)
            rootWidget:setScaleY(gVisibleSize.height / widget_rect.height)
            
            if data.hide == 1 then
                rootWidget:setVisible(false)
                self:setCocosLayerEnabled(rootWidget, false)
            end
            
            local uiName = data.name
            uiContainer.cocosWidget[uiName] = {}
            local uiWidget = uiContainer.cocosWidget[uiName]

            uiWidget.rootWidget = rootWidget

            uiWidget.button = {}
            uiWidget.widget2button = {}
            local buttonWidgetList = uiWidget.button
            local widget2button = uiWidget.widget2button

            local function onButtonEvent(node, event)
                local widgetButton = tolua.cast(node, "ccui.Button")
                local scene = SceneManager:getScene(scentName)
                local buttonName = widget2button[widgetButton:getName()]
                if scene.onCocosButtonEvent then
                    scene:onCocosButtonEvent(uiName, buttonName, event, widgetButton)
                end
            end
            
            for buttonName, widgetName in pairs(data.button or {}) do
                local widgetButton = rootWidget:getChildByName(widgetName)
                assert(widget2button)
                widgetButton:addTouchEventListener(onButtonEvent)
                widget2button[widgetName] = buttonName
                buttonWidgetList[buttonName] = tolua.cast(widgetButton, "ccui.Button")
            end

            uiWidget.text = {}
            uiWidget.widget2text = {}
            for textName, widgetName in pairs(data.text or {}) do
                uiWidget.text[textName] = tolua.cast(
                    assert(rootWidget:getChildByName(widgetName)), "ccui.Text")
                uiWidget.widget2text[widgetName] = textName
            end

            uiWidget.imageView = {}
            uiWidget.widget2imageview = {}
            for imageview_name, widgetName in pairs(data.imageView or {}) do
                uiWidget.imageView[imageview_name] = tolua.cast(
                    assert(rootWidget:getChildByName(widgetName), widgetName), "ccui.ImageView")
                uiWidget.widget2imageview[widgetName] = imageview_name
            end
        end
    end
end

function Ui:getCocosLayer(uiContainer, uiName)
    if uiContainer and uiContainer.cocosWidget 
        and uiContainer.cocosWidget[uiName] then
        return uiContainer.cocosWidget[uiName].rootWidget
    end
end

function Ui:getCocosButton(uiContainer, uiName, buttonName)
    if uiContainer and uiContainer.cocosWidget 
        and uiContainer.cocosWidget[uiName] and uiContainer.cocosWidget[uiName].button then
        return uiContainer.cocosWidget[uiName].button[buttonName]
    end
end

function Ui:getCocosText(uiContainer, uiName, textName)
    if uiContainer and uiContainer.cocosWidget 
        and uiContainer.cocosWidget[uiName] and uiContainer.cocosWidget[uiName].text then
        return uiContainer.cocosWidget[uiName].text[textName]
    end
end

function Ui:getCocosImageView(uiContainer, uiName, imageViewName)
    if uiContainer and uiContainer.cocosWidget 
        and uiContainer.cocosWidget[uiName] and uiContainer.cocosWidget[uiName].imageView then
        return uiContainer.cocosWidget[uiName].imageView[imageViewName]
    end
end

function Ui:setCocosLayerEnabled(rootWidget, enable)
    rootWidget:setEnabled(enable)
end


