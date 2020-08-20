-- OS Configuration

--[[
	The bootPath describes where all scripts for the boot process are located.
	The names need to have the boot priority (order) as number as prefix in the
	filename (lower means first loaded).
	The path should point to a directory (ends with a '/')
]]--
local bootPath = "/boot/"


-- load boot sequence

local sequence = {}
local sequenceKeys = {}

for _,step in pairs(filesystem.childs(bootPath)) do
	local num = step.match(step, '^[0-9]*')
	if num ~= nil then
		num = tonumber(num)
		local l = sequence[num]
		if l == nil then
			l = {}
			sequence[num] = l
		end
		local func = filesystem.loadFile(bootPath .. step)
		if type(func) ~= "function" then
			error(func)
		end
		table.insert(l, func)
	end
end
for k in pairs(sequence) do table.insert(sequenceKeys, k) end
table.sort(sequenceKeys)

-- run boot sequence

for _,k in pairs(sequenceKeys) do
	local seqStep = sequence[k]
	for _,step in pairs(seqStep) do
		step()
	end
end