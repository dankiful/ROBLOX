--// Made By dank on https://forum.robloxscripts.com as a script request.

for _, v in ipairs(game.Workspace.Zones.Summer.Drops:GetDescendants()) do
    if v.ClassName == "MeshPart" then
        local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart

        hrp.Position = v.Position
        wait(1)
    end
end
