for __,v in pairs(game.workspace.Vehicles:GetDescendants()) do
if v.ClassName == "Part" then -- the item
  local a = Instance.new("BillboardGui",v)
  a.Name = "TankEsp"
  a.Size = UDim2.new(10,0, 10,0)
  a.AlwaysOnTop = true
  local b = Instance.new("Frame",a)
  b.Size = UDim2.new(1,0, 1,0)
  b.BackgroundTransparency = 0.80
  b.BorderSizePixel = 0
  b.BackgroundColor3 = Color3.new(0, 255, 0)
  b.BackgroundTransparency = 0.8 -- customize transparency
  local c = Instance.new('TextLabel',b)
  c.Size = UDim2.new(2,0,2,0)
  c.BorderSizePixel = 0
  c.TextSize = 20
  c.Text = "Tank"
  c.BackgroundTransparency = 1
end
end
