local oldPull = event.pull
local pulling = {}

function handlePull(co)
    if not (pulling[co].signal == nil) then
        return true
    end
	local signal = {oldPull(0)}
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

function event.pull(timeout)
    local co = coroutine.running()
	pulling[co] = {}
    while not handlePull(co) do end
    local pullData = pulling[co]
	pulling[co] = nil
	if pullData.signal == nil then
		return
	end
    local data = pullData.signal
    pullData.signal = nil
	return table.unpack(data)
end

function sleep(timeout)
	timeout = timeout * 1000
	local start = computer.millis()

	while (computer.millis() - start) < timeout do
		event.pull((timeout - (computer.millis() - start)) / 1000)
	end
end
