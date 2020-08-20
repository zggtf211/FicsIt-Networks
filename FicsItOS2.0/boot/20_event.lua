local thread = require("thread")
local event = require("event")

--[[thread.create(function()
	while true do
		event.doListeners(event.pull())
	end
end)]]--
