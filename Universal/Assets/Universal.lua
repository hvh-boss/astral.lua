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
]]
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

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and GetCharacter(player) then
            local targetHRP = GetCharacter(player):FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local screenPos, onScreen = Camera:WorldToScreenPoint(targetHRP.Position)
                if true then
                    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                    local dist = ((Vector2.new(screenPos.X, screenPos.Y)) - mousePos).Magnitude

                    if dist <= radius and dist < shortestDistance and screenPos.Z >= 0 then
                        local isEnemy = not teamcheck or GetTeammate(player) ~= GetTeammate(LocalPlayer)
                        local isVisible = not wallcheck or IsVisible(Camera.CFrame.Position, GetCharacter(player))

                        if isEnemy and isVisible then
                            shortestDistance = dist
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
