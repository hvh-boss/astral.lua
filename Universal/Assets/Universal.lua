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
