--[[
--When overwriting a function make sure its like this "getgenv().GetCharacter = function()"
--symbol: 
--function(plr: Player <-- This is what the function should get): Model <-- This is what the function will return
GetCharacter:: function(plr: Player): Model
GetTeammate:: function(plr: Player): BrickColor
IsVisible:: function(startPos: Vector3, toPart: Model): boolean
EspPositionType:: function() <-- Dont really need to overwrite this function
DrawLine:: function(StartPos: Number, EndPos: Number, Thick: Number, Transparency: Number): Line
Convert3DTo2D:: function(pos: Vector3): Vector2
SetCamPos:: function(pos: Vector3, smoothness: Number) <- sets camera position ( this is for aimbot )
ClosestToMouseRadius:: function(teamcheck: Boolean, wallcheck: Boolean, radius: Radius): Model
mouse1click:: function() <- This is for triggerbot basically triggers mouse1click you can change the function for like shoot functions

Global important variables:
getgenv().ClosestToMouse <- This returns a character closest to the legitbot fov radius.. Or you can just usethe closesttomouseradius function
]]
getgenv().METHODS = {
    SilentAim = {
        Packet_Name = "", -- Should be string because its the RemoteEvent name
        Vector = true, -- Value if vector should be hooked
        Vector_ArgumentIndex = 0, -- Vector3 or .Position can be CFrame
        HitPart = false, -- Value if HitPart should be hooked
        HitPart_Index = 0 -- BasePart or a string depends on how the game functions
    }
}

getgenv().GetCharacter = getgenv().GetCharacter or function(plr: Player): Model
    return plr.Character
end
getgenv().GetTeammate = getgenv().GetTeammate or function(plr: Player): BrickColor
    return plr.TeamColor
end
getgenv().IsVisible = getgenv().IsVisible or function(startPos: Vector3, toPart: Model): boolean
    local Character, Lc = toPart, GetCharacter(LocalPlayer)
    if not Character and not Lc then return false end

    local direction = (Character.HumanoidRootPart.Position - startPos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Camera, Lc}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true

    local result = workspace:Raycast(startPos, direction, raycastParams)
    return result == nil or result.Instance:IsDescendantOf(Character)
end
getgenv().EspPositionType = getgenv().EspPositionType or function()
    if SETTINGS.ESP.Type == "Mouse" then
        return Vector2.new(Mouse.X, Mouse.Y + 60)
    elseif SETTINGS.ESP.Type == "Head" and GetCharacter(LocalPlayer) then
        if GetCharacter(LocalPlayer):FindFirstChild('Head') then
            local pos,_ = Convert3DTo2D(GetCharacter(LocalPlayer).Head.Position)
            return pos
        end
    elseif SETTINGS.ESP.Type == "Top" then
        return Vector2.new(Camera.ViewportSize.X/2, 0)
    elseif SETTINGS.ESP.Type == "Bottom" then
        return Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
    end
end
getgenv().DrawLine = getgenv().DrawLine or function(StartPos: Number, EndPos: Number): Line
    local Line = Drawing.new('Line')
    Line.From = StartPos
    Line.To = EndPos
    Line.Visible = true
    return Line
end

--\ GEOMETRY 
getgenv().beam = getgenv().beam or function(p1, p2)
    local beam = Instance.new("Part", workspace)
    beam.Anchored = true
    beam.CanCollide = false
    beam.Material = Enum.Material.ForceField
    beam.Color = SETTINGS.Client.BulletTracer.Color
    beam.Size = Vector3.new(0.1, 0.1, (p1 - p2).magnitude)
    beam.CFrame = CFrame.new(p1, p2) * CFrame.new(0, -0.5, -beam.Size.Z / 2)
    return beam
end
getgenv().Convert3DTo2D = getgenv().Convert3DTo2D or function(pos: Vector3): Vector2
	local screenpos, onscreen = Camera:WorldToViewportPoint(pos)
	return Vector2.new(screenpos.X, screenpos.Y), onscreen
end

getgenv().SetCamPos = getgenv().SetCamPos or function(pos: Vector3, smoothness: Number)
    local t = 1 - 1 / smoothness
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(Camera.CFrame.Position, pos)
    if smoothness == 100 then
        Camera.CFrame = targetCFrame
    else
        Camera.CFrame = currentCFrame:Lerp(targetCFrame, t)
    end
end
getgenv().ClosestToMouseRadius = getgenv().ClosestToMouseRadius or function(teamcheck: Boolean, wallcheck: Boolean, radius: Radius): Model
    local closestCharacter = nil
    local shortestDistance = math.huge
    local shortestPhysicalDistance = SETTINGS.LegitBot.MaxDistance
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and GetCharacter(player) then
            local targetHRP = GetCharacter(player):FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local screenPos, onScreen = Camera:WorldToScreenPoint(targetHRP.Position)
                if true then
                    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                    local dist = ((Vector2.new(screenPos.X, screenPos.Y)) - mousePos).Magnitude
                    local physicalDist = (targetHRP.Position - GetCharacter(LocalPlayer):FindFirstChild('HumanoidRootPart').Position).Magnitude
                    if dist <= radius and dist < shortestDistance and screenPos.Z >= 0 then
                        local isEnemy = not teamcheck or GetTeammate(player) ~= GetTeammate(LocalPlayer)
                        local isVisible = not wallcheck or IsVisible(Camera.CFrame.Position, GetCharacter(player))

                        if isEnemy and isVisible and physicalDist < shortestPhysicalDistance then
                            shortestDistance = dist
                            shortestPhysicalDistance = physicalDist
                            closestCharacter = GetCharacter(player)
                        end
                    end
                end
            end
        end
    end

    return closestCharacter
end
getgenv().mouse1click = getgenv().mouse1click

--[[{
    SilentAim = {
        Packet_Name = "", -- Should be string because its the RemoteEvent name
        Vector = true, -- Value if vector should be hooked
        Position_Type = "Position",
        Vector_ArgumentIndex = 0, -- Vector3 or .Position can be CFrame
        HitPart = false, -- Value if HitPart should be hooked
        HitPart_Index = 0 -- BasePart or a string depends on how the game functions
    }
}]]
function serialize(tbl, indent)
    indent = indent or 0
    local toString = string.rep("  ", indent) .. "{\n"

    for k, v in pairs(tbl) do
        local key = type(k) == "string" and string.format("%q", k) or "[" .. tostring(k) .. "]"
        local value

        if type(v) == "table" then
            value = serialize(v, indent + 1)
        elseif type(v) == "string" then
            value = string.format("%q", v)
        else
            value = tostring(v)
        end

        toString = toString .. string.rep("  ", indent + 1) .. key .. " = " .. value .. ",\n"
    end

    toString = toString .. string.rep("  ", indent) .. "}"
    return toString
end
function FadeChar(char)
    char.Archivable = true
    local Character = char:Clone()
    Character.Parent = workspace
    for i,v in pairs(Character:GetDescendants()) do
        if v:IsA('BasePart') then
        task.spawn(function()
            for i = 1,60 do
                v.Anchored = true
                v.CanCollide = false
                v.Color = SETTINGS.Client.DeathAnim.Color
                v.Transparency = 0.9 + (i / 100)
                v.CanQuery = false
                wait(.1)
            end
        end)
        elseif v:IsA('Decal') then
            v:Destroy()
        elseif v:IsA('Humanoid') then
            v:Destroy()
        end
    end
    wait(.1 * 60)
    Character:Destroy()
end
for i,v in pairs(game.Players:GetPlayers()) do
    local char = v.Character
    if char then
        task.spawn(function() -- Multi thread so :WaitForChild doesnt suspend the current loop cuz im too lazy to optimize ts
            local hum = char:WaitForChild('Humanoid', 9e9)
            hum.Died:Connect(function()
                if SETTINGS.Client.DeathAnim.Enabled then
                    FadeChar(char)
                end
            end)
        end)
    end
end
game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild('Humanoid', 9e9)
        hum.Died:Connect(function()
            if SETTINGS.Client.DeathAnim.Enabled then
                FadeChar(char)
            end
        end)
    end)
end)
-- HOOKS (__namecall)
local pattern = getgenv().pattern or {
    ['2502424930'] = { -- Trench war
        RemoteEvent = {
            ['Humanoid'] = {
                1,
            },
            ['CFrame'] = {
                5,
            }
        },
    },
    ['770538576'] = { -- Naval warfare
        Event = {
            ['Hit'] = {
                2,
            },
            ['Humanoid'] = {
                4,
            },
        }
    },
}
local oldNamecall; 
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()
	local args = {...}
	if method == "FireServer" then
        if pattern[tostring(game.GameId)] and pattern[tostring(game.GameId)][self.Name] then -- EXAMPLE PSEUDOCODE SILENT AIM CODE
    elseif method == "Kick" then
		return
	end
	return oldNamecall(self, ...)
end)


-- HOOKS (__index)

-- HOOKS (__newindex)

--[[ SETTINGS ( this is automatically set in the global env )

getgenv().GC = {
    Drawing = {Line = setmetatable(table.create(100, nil), { __mode = "v" })}, -- preallocates
    Characters = setmetatable(table.create(100, nil), { __mode = "v" }), -- preallocates
    Players = {
        Connections = setmetatable(table.create(100, nil), { __mode = "v" }), -- preallocates
    },
    Raycast = {
        Enabled = true,
        WithRadius = {Enabled = true, Value = 50, Character = nil},
        WithRaycast = {Enabled = true, Character = nil},
        WithTeammate = {Enabled = true, Character = nil}
    },
}

getgenv().SETTINGS = {
    Movement = {
        Legit = {
            WalkSpeed = {
                Enabled = false,
                Value = 20,
            },
            JumpPower = {
                Enabled = false,
                Value = 50,
            },
            Bunnyhop = {
                Enabled = false,
                Strafe = false,
                StrafeValue = 100,
                Delay = 0,
            },
        },
        Rage = {
            AntiAim = {
                Enabled = false,
                Type = "Jitter",
                YawOffset = 1,
            },
        },
    },
    Client = {
        ForceFov = {
            Enabled = false,
            Value = 90,
        },
        Ambient = {
            Enabled = false,
            Ambient = Color3.new(0,0,0),
            OutdoorAmbient = Color3.new(128,128,128),
            TimeOfDay = 12,
        },
        ThirdPerson = {
            Enabled = false,
            Value = 20,
        }
    },
    ESP = {
        Type = "Bottom",
        Line = {
            Enabled = false,
            Transparency = 0.3,
            Thickness = 2,
            Color = Color3.new(1,1,1),
        },
        Highlight = {
            Enabled = false,
            Teamcheck = false,
            FillTransparency = 0.8,
            OutlineTransparency = 0.8,
            Color = Color3.new(1,1,1),

        }
    },
    LegitBot = {
        Target = nil,
        Enabled = false,
        Teamcheck = false,
        Radius = 60,
        Smoothness = 100,
        Wallcheck = true,
        Hitbox = "Head",
        Fov = true,
        Line = true,
        Keybind = Enum.UserInputType.MouseButton1,
        Drawing = {},
        Type = "Aimlock",
    },
    Triggerbot = {
        Enabled = false,
        Teamcheck = false,
        Hitbox = "Any",
        ReactionTime = 0.01,


    },
    RageBot = {
        Enabled = false,
        Teamcheck = true,
        Radius = 30,
        Smoothness = 10,
        Wallcheck = true
    },
}

]]
--251, 15, 276
