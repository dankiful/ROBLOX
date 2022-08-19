--fixed version , not mine

--Wait until game loads
repeat
    wait()
until game:IsLoaded()

--Stops script if on a different game
if game.PlaceId ~= 8737602449 and game.Players.Localplayer.Name ~= "breakdesync" then
    return
end

--Anti-AFK
local connections = getconnections or get_signal_cons
if connections then
	for i,v in pairs(connections(game.Players.LocalPlayer.Idled)) do
		if v["Disable"] then
			v["Disable"](v)
		elseif v["Disconnect"] then
			v["Disconnect"](v)
		end
	end
else
    game.Players.LocalPlayer.Idled:Connect(function()
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
wait(5)

--Variables
local unclaimed = {}
local counter
local donation
local boothText
local errCount = 0
local booths = {
    ["1"] = "72, 4, 36",
    ["2"] = "83, 4, 161",
    ["3"] = "11, 4, 36",
    ["4"] = "100, 4, 59",
    ["5"] = "72, 4, 166",
    ["6"] = "2, 4, 42",
    ["7"] = "-9, 4, 52",
    ["8"] = "10, 4, 166",
    ["9"] = "-17, 4, 60",
    ["10"] = "35, 4, 173",
    ["11"] = "24, 4, 170",
    ["12"] = "48, 4, 29",
    ["13"] = "24, 4, 33",
    ["14"] = "101, 4, 142",
    ["15"] = "-18, 4, 142",
    ["16"] = "60, 4, 33",
    ["17"] = "35, 4, 29",
    ["18"] = "0, 4, 160",
    ["19"] = "48, 4, 173",
    ["20"] = "61, 3, 170",
    ["21"] = "91, 4, 151",
    ["22"] = "-24, 4, 72",
    ["23"] = "-28, 4, 88",
    ["24"] = "92, 4, 51",
    ["25"] = "-28, 4, 112",
    ["26"] = "-24, 3, 129",
    ["27"] = "83, 4, 42",
    ["28"] = "-8, 4, 151"
}
local queueonteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
local httprequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request
local Players = game:GetService("Players")
queueonteleport("loadstring(game:HttpGet('raw.githubusercontent.com/dankiful/ROBLOX/main/Open-Source/plsdonate.lua'))()")
local library = loadstring(game:HttpGet("https://pastebin.com/raw/QYnVhBVd"))()

--Load Settings
if isfile("plsdonate-settings.txt") then
    getgenv().settings = game:GetService('HttpService'):JSONDecode(readfile('plsdonate-settings.txt'))
else
    getgenv().settings = {
        textUpdateToggle = true,
        textUpdateDelay = 30,
        serverHopToggle = true,
        serverHopDelay = 30,
        hexBox = "#32CD32",
        goalBox = 5,
        webhookToggle = false,
        webhookBox = ""
    }
    writefile('plsdonate-settings.txt', game:GetService('HttpService'):JSONEncode(getgenv().settings))
end

--Save Settings
local settingsLock = true
local function saveSettings()
    if settingsLock == false then
        print('Settings saved.')
        writefile('plsdonate-settings.txt', game:GetService('HttpService'):JSONEncode(getgenv().settings))
    end
end

--Function to fix slider
local sliderInProgress = false;
local function slider(value, whichSlider)
    if sliderInProgress then
        return
    end
    sliderInProgress = true
    wait(5)
    if whichSlider == "serverHopDelay" then
        if getgenv().settings.serverHopDelay == value then
            print(getgenv().settings.serverHopDelay)
            print(value)
            saveSettings()
            sliderInProgress = false;
        else
            sliderInProgress = false;
            return slider(getgenv().settings.serverHopDelay, "serverHopDelay")
        end
    elseif whichSlider == "textUpdateDelay" then
        if getgenv().settings.textUpdateDelay == value then
            saveSettings()
            sliderInProgress = false;
        else
            sliderInProgress = false;
            return slider(getgenv().settings.textUpdateDelay, "textUpdateDelay")
        end
    end
end

--Booth update function
function update()
    local text
    local Raised = Players.LocalPlayer.leaderstats.Raised
    
    --Checks if you have 1000+ robux raised
    --4 digit numbers are censored so they will be shortened
    if Raised.Value > 999 then
        text = tostring(math.ceil(tonumber(Raised.Value + 1) / 100) * 100)
        text = string.format("%.1fk", text / 10 ^ 3)
        --Booth text when 1000+ robux raised
        boothText = tostring('my goal ' .. Raised.value .. "/" .. text .. " afk")
    else
        --Booth text when under 1000 robux raised
        text = tostring(Raised.Value + getgenv().settings.goalBox)
        boothText = tostring('my goal ' .. Raised.value .. "/" .. text .. " afk")
    end
    --Updates the booth text
    require(game.ReplicatedStorage.Remotes).Event("SetBoothText"):FireServer(boothText, "booth")
end


--GUI
local Window = library:AddWindow("PLS DONATE",
{
    main_color = Color3.fromRGB(0, 128, 0),
    min_size = Vector2.new(300, 400),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = true
})
local mainTab = Window:AddTab("Main")
local webhookTab = Window:AddTab("Webhook")
local textUpdateToggle = mainTab:AddSwitch("Text Update", function(bool)
    getgenv().settings.textUpdateToggle = bool
    saveSettings()
    if bool then
        wait(1)
        update()
    end
end)
textUpdateToggle:Set(getgenv().settings.textUpdateToggle)
local textUpdateDelay = mainTab:AddSlider("Text Update Delay (S)", function(x) 
    if settingsLock then
       return 
    end
    getgenv().settings.textUpdateDelay = x
    coroutine.wrap(slider)(getgenv().settings.textUpdateDelay, "textUpdateDelay")
end,
{
    ["min"] = 0,
    ["max"] = 120
})
textUpdateDelay:Set((getgenv().settings.textUpdateDelay / 120) * 100)
local serverHopToggle = mainTab:AddSwitch("Auto Server Hop", function(bool)
    getgenv().settings.serverHopToggle = bool
    saveSettings()
end)
serverHopToggle:Set(getgenv().settings.serverHopToggle)
local serverHopDelay = mainTab:AddSlider("Server Hop Delay (M)", function(x)
    if settingsLock then
       return 
    end
    getgenv().settings.serverHopDelay = x
    coroutine.wrap(slider)(getgenv().settings.serverHopDelay, "serverHopDelay")
end,
{
    ["min"] = 1,
    ["max"] = 120
})
serverHopDelay:Set((getgenv().settings.serverHopDelay / 120) * 100)
local hexBox = mainTab:AddTextBox("Text Color (HEX)", function(text)
    local success = pcall(function()
	    return Color3.fromHex(text)
    end)
    if success and string.find(text, "#") then
        getgenv().settings.hexBox = text
        saveSettings()
        if getgenv().settings.textUpdateToggle then
            wait(1)
            update()
        end
    end
end,
{
    ["clear"] = false
})
hexBox.Text = getgenv().settings.hexBox
local goalBox = mainTab:AddTextBox("Goal Increase", function(text)
    if tonumber(text) then
        getgenv().settings.goalBox = text
        saveSettings()
        if getgenv().settings.textUpdateToggle then
            wait(1)
            update()
        end
    end
end,
{
    ["clear"] = false
})
goalBox.Text = getgenv().settings.goalBox
mainTab:AddButton("Server Hop", function()
    while wait(5) do
		local servers = {}
		local req = httprequest({Url = "https://games.roblox.com/v1/games/8737602449/servers/Public?sortOrder=Desc&limit=100"})
		local body = game:GetService('HttpService'):JSONDecode(req.Body)
		if body and body.data then
			for i, v in next, body.data do
				if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.playing > 19 then
					table.insert(servers, 1, v.id)
				end 
			end
		end
		if #servers > 0 then
			game:GetService("TeleportService"):TeleportToPlaceInstance("8737602449", servers[math.random(1, #servers)], Players.LocalPlayer)
		end
    end
end)
local webhookToggle = webhookTab:AddSwitch("Discord Webhook Notifications", function(bool)
    getgenv().settings.webhookToggle = bool
    saveSettings()
end)
webhookToggle:Set(getgenv().settings.webhookToggle)
local webhookBox = webhookTab:AddTextBox("Webhook URL", function(text)
    if string.find(text, "https://discord.com/api/webhooks/") then
        getgenv().settings.webhookBox = text;
        saveSettings()
    end
end,
{
    ["clear"] = false
})
webhookBox.Text = getgenv().settings.webhookBox
webhookTab:AddButton("Test Message", function()
    if getgenv().settings.webhookToggle and getgenv().settings.webhookBox then
        httprequest({
            Url = getgenv().settings.webhookBox,
            Body = game:GetService("HttpService"):JSONEncode({["content"] = "Test"}),
            Method = "POST",
            Headers = {["content-type"] = "application/json"}
        })
    end
end)
mainTab:Show()
library:FormatWindows()
settingsLock = false

--Finds unclaimed booths
local function findUnclaimed()
    for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MapUIContainer.MapUI.BoothUI:GetChildren()) do
        if (v.Details.Owner.Text == "unclaimed") then
            table.insert(unclaimed, tonumber(string.match(tostring(v), "%d+")))
        end
    end
end
if not pcall(findUnclaimed) then
    while wait(5) do
        local servers = {}
        local req = httprequest({Url = "https://games.roblox.com/v1/games/8737602449/servers/Public?sortOrder=Desc&limit=100"})
        local body = game:GetService('HttpService'):JSONDecode(req.Body)
        if body and body.data then
        	for i, v in next, body.data do
    		    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.playing > 19 then
    			    table.insert(servers, 1, v.id)
    		    end 
    	    end
        end
        if #servers > 0 then
    	    game:GetService("TeleportService"):TeleportToPlaceInstance("8737602449", servers[math.random(1, #servers)], Players.LocalPlayer)
        end
    end
end
local claimCount = #unclaimed
--Claim booth function
local function boothclaim()
    require(game.ReplicatedStorage.Remotes).Event("ClaimBooth"):InvokeServer(unclaimed[1])
    if not string.find(Players.LocalPlayer.PlayerGui.MapUIContainer.MapUI.BoothUI:FindFirstChild(tostring("BoothUI".. unclaimed[1])).Details.Owner.Text, game:GetService("Players").LocalPlayer.DisplayName) then
        wait(5)
        if not string.find(Players.LocalPlayer.PlayerGui.MapUIContainer.MapUI.BoothUI:FindFirstChild(tostring("BoothUI".. unclaimed[1])).Details.Owner.Text, game:GetService("Players").LocalPlayer.DisplayName) then
            error()
        end
    end
end

--Checks if booth claim fails
while not pcall(boothclaim) do
    if errCount >= claimCount then
        while wait(5) do
    		local servers = {}
    		local req = httprequest({Url = "https://games.roblox.com/v1/games/8737602449/servers/Public?sortOrder=Desc&limit=100"})
    		local body = game:GetService('HttpService'):JSONDecode(req.Body)
    		if body and body.data then
    			for i, v in next, body.data do
    				if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.playing > 19 then
    					table.insert(servers, 1, v.id)
    				end 
    			end
    		end
    		if #servers > 0 then
    			game:GetService("TeleportService"):TeleportToPlaceInstance("8737602449", servers[math.random(1, #servers)], Players.LocalPlayer)
    		end
        end
    end
    table.remove(unclaimed, 1)
    errCount = errCount + 1
end

--Walks to booth
game.Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(booths[tostring(unclaimed[1])]:match("(.+), (.+), (.+)")))
local atBooth = false
game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:Connect(function(reached)
    atBooth = true
end)

--Just in case you run into a bench
while not atBooth do
    wait(0.1)
    local function noclip()
        for i,v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
    game:GetService("RunService").Stepped:Connect(noclip)
    if game.Players.LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Seated then
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
    end
end
--Turns charcter to face away from booth
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(40, 14, 101)))

--Waits for donations
while true do
    counter = 0
    if getgenv().settings.textUpdateToggle then
        update()
    end
    local RaisedC = Players.LocalPlayer.leaderstats.Raised.value
    while (Players.LocalPlayer.leaderstats.Raised.value == RaisedC) do
        wait(1)
        counter = counter + 1
        --Server hops after 1800 seconds (30 minutes)
        if getgenv().settings.serverHopToggle then
            if counter >= (getgenv().settings.serverHopDelay * 60) then
                --Random wait time in case of interference from alts
                wait(math.random(1, 60))
		        local servers = {}
		        local req = httprequest({Url = "https://games.roblox.com/v1/games/8737602449/servers/Public?sortOrder=Desc&limit=100"})
        		local body = game:GetService('HttpService'):JSONDecode(req.Body)
		        if body and body.data then
			        for i, v in next, body.data do
				        if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.playing > 19 then
					        table.insert(servers, 1, v.id)
				        end 
			        end
		        end
		        if #servers > 0 then
        			game:GetService("TeleportService"):TeleportToPlaceInstance("8737602449", servers[math.random(1, #servers)], Players.LocalPlayer)
		        end
            end
        end
    end

    --Checks for Discord Webhook
    if getgenv().settings.webhookToggle and getgenv().settings.webhookBox then
        local LogService = Game:GetService("LogService")
        local logs = LogService:GetLogHistory()
        local donation
        --Tries to grabs donation message from logs
        if string.find(logs[#logs].message, game:GetService("Players").LocalPlayer.Name) then
            donation = tostring(logs[#logs].message.. " (Total: ".. Players.LocalPlayer.leaderstats.Raised.value.. ")")
        else
            donation = tostring("💰 Somebody tipped ".. Players.LocalPlayer.leaderstats.Raised.value - RaisedC.. " Robux to ".. game:GetService("Players").LocalPlayer.Name.. " (Total: " .. Players.LocalPlayer.leaderstats.Raised.value.. ")")
        end

        --Sends to webhook
        httprequest({
            Url = getgenv().settings.webhookBox,
            Body = game:GetService("HttpService"):JSONEncode({["content"] = donation}),
            Method = "POST",
            Headers = {["content-type"] = "application/json"}
        })
    end

    --Text update delay
    wait(getgenv().settings.textUpdateDelay)
end
