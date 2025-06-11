local b = game.Workspace:WaitForChild("ServerStuff", math.huge):WaitForChild("Statistics", math.huge):WaitForChild("CLASS_STATISTICS", math.huge):Clone()
local BYPASSMEXD = require(b)
b.Parent = workspace
b.Name = "astral.bypass"

local oldhook;
oldhook = hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()
	if tostring(method) == "FireServer" and tostring(self) == "devicePerformanceStatistics" then
		return oldhook(self, BYPASSMEXD)
	end
	return oldhook(self, ...)
end)
