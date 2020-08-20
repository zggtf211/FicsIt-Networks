local processedLibs = {}
local libFolders = {"/lib/"}

function require(libName)
	local lib = processedLibs[libName]
	if lib ~= nil then
		return lib
	end
	for _,libFolder in pairs(libFolders) do
		for _,file in pairs(filesystem.childs(libFolder)) do
			local m = string.match(file, "^" .. libName .. ".lua$")
			if m ~= nil then
				local path = libFolder .. file
				local lib = filesystem.doFile(path)
				processedLibs[libName] = lib
				return lib
			end
		end
	end
	return nil
end
