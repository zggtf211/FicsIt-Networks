local thread = require("thread")
local event = require("event")

local gpu = computer.getGPUs()[1]
local screen = computer.getScreens()[1]

gpu:bindScreen(screen)

local width, height = gpu:getSize()

gpu:setText(0,0,"nice")
gpu:flush()

event.listen(gpu)

local cX, cY = 0, 0

function OnKeyUp(sender, key)
	print("dafq", sender, string.char(key))
end

--event.mapFunctionsToEvents()

thread.create(function()
	print(event.pull())
end)