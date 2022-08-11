-- This is a Client-Sided Roblox UserID/UserName Spoofer. You should always use this when using a obfuscated script incase the developers of that script sell data such as usernames to admins of a game to get you banned.
local LP = game.Players.LocalPlayer
function spoof()
game.Players.LocalPlayer.UserId = 1337
game.Players.LocalPlayer.Name = "0sid0"
game.Players.LocalPlayer.DisplayName = "0sid0"
end
wait(1)

spoof()


Player.CharacterAdded:Connect(function()
    spoof()
end)
