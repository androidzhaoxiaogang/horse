View = View or {}


function View:addElement(window, elementType, elementName, positionX, positionY, element)
    local elementList = self:getSameTypeElement(window, elementType)
    if not elementList then
        return
    end
    if elementList[elementName] then
        Log:i("[%s][%s]Already Exists", elementType, elementName)
        return
    end
    window.cc_layer_ui:addChild(element)
    if positionX and positionY then
        element:setPosition(positionX, positionY)
    end
    elementList[elementName] = element
end

function View:getElement(window, elementType, elementName)
    local elementList = self:getSameTypeElement(window, elementType)
    if not elementList then
        return
    end
    if not elementList[elementName] then
        return
    end
    return elementList[elementName]
end

function View:getSameTypeElements(window, elementType)
    local elements = window.elementList[elementType]
    if not elements then
        assert(false)
    end
    return elements
end

function View:LoadJson(layer, jsonFilePath)
    local rootWidget = ccs.GUIReader:getInstance():widgetFromJsonFile(jsonFilePath)
    local widgetRect = rootWidget:getSize()
    layer:addChild(rootWidget)
    return rootWidget, widgetRect
end

function View:loadCocosView(scentName, ui_list)
    
end













