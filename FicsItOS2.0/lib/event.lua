local pulling = {}
local listeners = {}

local lib = {}
for k,v in pairs(event) do
	lib[k] = v
end
local oldPull = lib.pull

function lib.handlePull(co)
    if not (pulling[co].signal == nil) then
        return true
    end
	local signal = {oldPull()}
	if #signal < 1 then
		return false
	end
	for t,s in pairs(pulling) do
		if s.signal == nil then
			s.signal = signal
		end
	end    
	return true
end

function lib.pull(timeout)
    local co = coroutine.running()
	pulling[co] = {}
    while not lib.handlePull(co) do end
    local pullData = pulling[co]
	pulling[co] = nil
	if pullData.signal == nil then
		return
	end
    local data = pullData.signal
    pullData.signal = nil
	return table.unpack(data)
end

function lib.sleep(timeout)
	timeout = timeout * 1000
	local start = computer.millis()

	while (computer.millis() - start) < timeout do
		event.pull((timeout - (computer.millis() - start)) / 1000)
	end
end

function lib.mapFunctionToEvent(func, event)
	local list = listeners[event]
	if list == nil then
		list = {}
		listeners[event] = list
	end
	table.insert(list, func)
end

function lib.mapFunctionsToEvents(table)
	if table == nil then
		table = _G
	end
	for name,func in pairs(table) do
		if type(func) == "function" then
			lib.mapFunctionToEvent(func,name)
		end
	end
end

function lib.doListeners(...)
	local arg = {...}
	local event = arg[1]
	table.remove(arg, 1)
	local list = listeners[event]
	if list ~= nil then
		for _,func in pairs(list) do
			pcall(func, table.unpack(arg))
		end
	end
end

return lib
