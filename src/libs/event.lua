--=======================================================================
-- File Name    : event.lua
-- Author       : zhaoxiaogang
-- Date         : 2014/8/17 10:42:50
-- Description  : Event  supports event-drived programming.
--                It use to between the module communication .
-- Modify       :
--=======================================================================
Event = Event or {}

-- init the event funcs table
function Event:init()
  self.EventList = {}
end

function Event:enableDebug(debuggable)
  self.debuggable = debuggable
end

function Event:registerEvent(event, func, ...)
    if not event or not func then
        if self.debuggable then
            print(event, func)
        end

        return
    end
    
    if not self.EventList[event] then
        self.EventList[event] = {}
    end

    local eventList = self.EventList[event]
    local eventId = #eventList + 1
    eventList[eventId] = {func, {...}} -- func and params
    return eventId
end

function Event:unRegisterEvent(event, eventId)
    if not event or not eventId then
        assert(false)
        return
    end
    
    if not self.EventList[event] then
        return false
    end
    
    local eventList = self.EventList[event]
    if not eventList[eventId] then
        return false
    end
    
    eventList[eventId] = nil
    return true
end

function Event:postEvent(event, ...)
  self:execute(self.EventList[event], ...)
end

function Event:execute(eventList, ...)
    if not eventList then
        print("event list is null")
        return
    end

    local tmpEventList = Utils:copy(eventList)

    for eventId, funcs in pairs(tmpEventList) do
        if eventList[eventId] then
            local func = funcs[1]
            local args = funcs[2]

            if #args > 0 then
                Utils:safeExecute{func, unpack(args), ...}
            else
                Utils:safeExecute{func, ...}
            end
        end
    end
end

