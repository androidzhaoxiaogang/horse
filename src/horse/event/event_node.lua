--=======================================================================
-- File Name    : EventNode.lua
-- Author       : zhaoxiaogang
-- Date         : 2014/7/28 10:42:50
-- Description  : The base internal module message object, all the event 
--                drived class should derived from it.
-- Modify       :
--=======================================================================

EventNode = EventNode or class("EventNode")

function EventNode:ctor(...)
    self:registerEvent()
end

function EventNode:enableDebug(debuggable)
    self.debuggable = debuggable
end

function EventNode:initListenEvent(event, func)
    if not self.eventListener then
        self.eventListener = {}
    end
    self.eventListener[event] = func
end

function EventNode:registerEvent()
    if not self.eventListener then
        return
    end
    if not self.regEventList then
        self.regEventList = {}
    end

    for event, func in pairs(self.eventListener) do
        if not self.regEventList[event] then
            local eventId = Event:registerEvent(event, func, self)
            self.regEventList[event] = eventId
        else
            assert(false, event)
        end
    end
end

function EventNode:unregisterEvent()
    if not self.regEventList then
        return
    end

    for event, eventId in pairs(self.regEventList) do
        Event:unRegisterEvent(event, eventId)
    end
    self.regEventList = {}
end

function EventNode:unregisterSpecificEvent(event)
    local eventId = self.regEventList[event]
    if eventId then
        Event:unRegisterEvent(event, eventId)
    end
end

function EventNode:getParent()
    return self.parent
end

function EventNode:addChild(childName, child, order)
    assert(childName)
    
    if not child then
        return 
    end 
    
    if not self.childOrder then
        self.childOrder = 0
    end

    if not self.childList then
        self.childList = {}
    end

    if not self.childOrderList then
        self.childOrderList = {}
    end

    if not order then
        order = self.childOrder + 1
    end

    self.childList[childName] = child
    self.childOrderList[order] = child
    child.parent = self
    self.childOrder = order
end

function EventNode:removeChild(childName)
    assert(childName)
    
    if not self.childOrder then
        self.childOrder = 0
    end

    if not self.childList then
        return
    end

    if not self.childOrderList then
        return
    end

    assert(self.childList[childName])

    for i = 1, self.childOrder do
        if self.childOrderList[i] == 
            self.childList[childName] then
            self.childOrderList[i] = nil
            break
        end
    end

    self.childList[childName] = nil
end

function EventNode:getChild(childName)
    assert(childName)

    if not self.childList then
        return
    end
    return self.childList[childName]
end

function EventNode:destroyChild()
    if not self.childList then
        return
    end
    
    for name, child in pairs(self.childList) do
        child:postTreeEvent("destroy")
    end
    self.childList = nil
end

function EventNode:getFunc(func)
    local item = self[func]
    if item and type(item) == "function" then
        return item
    end
end

function EventNode:queryFromChild(func)
    local result = {}
    local func = nil
    func = self:getFunc(func)

    if func then
        table.insert(result, {func, self})
    end

    if not self.childList then
        return result
    end

    for i = 1, self.childOrder do
        local child = self.childOrderList[i]
        if child and child.postNodeEvent then

            func = child:getFunc(func)
            if func then
                table.insert(result, {func, child})
            end
        end
    end

    return result
end

---------------------------
--@return #void The messages be transferred 
--         from parent to grandson in the internal
--         module
function EventNode:postNodeEvent(eventName, ...)
    local func = eventName
    local funcs = self:queryFromChild(func)

    for _, value in ipairs(funcs) do
        local func, owner = unpack(value)
        func(owner, ...)
        if self.__destroy then
            return
        end
    end
end

---------------------------
--@return #func The messages only be transferred 
--        for one layer from parent to children
--        in the internal module
function EventNode:postLayerEvent(eventName, ...)
    local func = nil
    func = self:getFunc(eventName)

    if func then
        return func(self, ...)
    end

    if not self.childList then
        return
    end

    for i = 1, self.childOrder do
        local child = self.childOrderList[i]
        if child and child.getFunc then
            func = child:getFunc(eventName)
            if func then
                return func(child, ...)
            end
        end
    end
end

function EventNode:destroy()
    self:destroyChild()
    self:unregisterEvent()
    self.childOrder     = nil
    self.childList      = nil
    self.childOrderList = nil
    self.regEventList   = nil
    self.debuggable     = nil
end
