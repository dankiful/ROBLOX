--queue_on_teleport("https://raw.githubusercontent.com/dankiful/ROBLOX/main/Open-Source/plsdonate.lua")
repeat task.wait() until game:IsLoaded()
--//Variables\\--

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local gameid = game.PlaceId
local serverlist = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/".. gameid .."/servers/Public?sortOrder=Desc&limit=100"))
local VU = game:GetService("VirtualUser")
local queue_on_telep = queue_on_teleport or queueonteleport or syn.queue_on_teleport
--game:GetService("TeleportService"):Teleport(gameid, lp)

--local queue = 
--//Settings\\--

local cooldown = 5
local minimumDonated = 5000
local mostDonated = false
local repeatCooldown = 10 -- Loops every _ _ seconds

--//Messages\\--

local msgs = {
    ",",
    "?",
    "!",
    "@",
}

--//Anti-AFK\\--

for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
    v:Disable()
    end

lp.Idled:connect(function()
VU:CaptureController()
VU:ClickButton2(Vector2.new()) --Clicks MB2 each time Idled.
end)




--//Script\\--
while task.wait() do 
if mostDonated == true then
    for _, v in next, Players:GetPlayers() do
        if v.Name ~= lp.Name and v.leaderstats:WaitForChild("Donated").Value > minimumDonated then
            lp.Character.Humanoid:MoveTo(v:WaitForChild("Character").HumanoidRootPart.Position)
            wait(4)
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                msgs[math.random(1, #msgs)],
                "All"
            )
            wait(cooldown)
        end
    end
elseif mostDonated == false then
    for _, v in next, Players:GetPlayers() do
        if v.Name ~= lp.Name then
            lp.Character.Humanoid:MoveTo(v:WaitForChild("Character").HumanoidRootPart.Position)
            wait(4)
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                msgs[math.random(1, #msgs)],
                "All"
            )
            wait(cooldown)
        end
    end
end
end

--//ServerHop\\--
if game:IsLoaded() then
    wait(60)
    queue_on_teleport(loadstring(game:HttpGet("https://raw.githubusercontent.com/dankiful/ROBLOX/main/Open-Source/autobeg.lua",true))())

    for _,v in pairs(serverlist.data) do
        if v.playing > 5 and v.playing ~= v.maxPlayers then
            game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, v.id)
        end
      end
end



