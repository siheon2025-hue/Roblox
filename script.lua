local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
	return getCharacter():WaitForChild("Humanoid")
end

local function getRoot()
	return getCharacter():WaitForChild("HumanoidRootPart")
end

-- 상태값
local tpEnabled = false
local speedOn = false
local jumpOn = false
local nightOn = false
local pendingPosition = nil
local marker = nil

-- ===== GUI =====
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 300)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(25,25,25)
title.TextColor3 = Color3.new(1,1,1)
title.Text = "All In One Panel"

local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1,0,0,20)
credit.Position = UDim2.new(0,0,0,30)
credit.BackgroundTransparency = 1
credit.TextColor3 = Color3.fromRGB(170,170,170)
credit.TextScaled = true
credit.Text = "Developed by siheon_01"

local function makeButton(text, y, color)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.8,0,0,35)
	b.Position = UDim2.new(0.1,0,y,0)
	b.Text = text
	b.BackgroundColor3 = color
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local tpBtn = makeButton("TP OFF",0.20,Color3.fromRGB(100,100,255))
local speedBtn = makeButton("Speed OFF",0.35,Color3.fromRGB(80,160,255))
local jumpBtn = makeButton("Jump OFF",0.50,Color3.fromRGB(80,255,120))
local nightBtn = makeButton("Night OFF",0.65,Color3.fromRGB(150,150,255))

-- ===== 버튼 기능 =====
tpBtn.MouseButton1Click:Connect(function()
	tpEnabled = not tpEnabled
	tpBtn.Text = tpEnabled and "TP ON" or "TP OFF"
end)

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	getHumanoid().WalkSpeed = speedOn and 32 or 16
	speedBtn.Text = speedOn and "Speed ON" or "Speed OFF"
end)

jumpBtn.MouseButton1Click:Connect(function()
	jumpOn = not jumpOn
	getHumanoid().JumpPower = jumpOn and 100 or 50
	jumpBtn.Text = jumpOn and "Jump ON" or "Jump OFF"
end)

nightBtn.MouseButton1Click:Connect(function()
	nightOn = not nightOn
	Lighting.ClockTime = nightOn and 0 or 14
	nightBtn.Text = nightOn and "Night ON" or "Night OFF"
end)

-- ===== 확인창 =====
local confirmFrame = Instance.new("Frame", gui)
confirmFrame.Size = UDim2.new(0, 300, 0, 160)
confirmFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
confirmFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
confirmFrame.Visible = false

local confirmText = Instance.new("TextLabel", confirmFrame)
confirmText.Size = UDim2.new(1,0,0.4,0)
confirmText.BackgroundTransparency = 1
confirmText.TextColor3 = Color3.new(1,1,1)
confirmText.TextScaled = true
confirmText.Text = "정말로 이동하시겠습니까?"

local coordLabel = Instance.new("TextLabel", confirmFrame)
coordLabel.Size = UDim2.new(1,0,0.2,0)
coordLabel.Position = UDim2.new(0,0,0.4,0)
coordLabel.BackgroundTransparency = 1
coordLabel.TextColor3 = Color3.fromRGB(200,200,200)
coordLabel.TextScaled = true

local yesBtn = Instance.new("TextButton", confirmFrame)
yesBtn.Size = UDim2.new(0.4,0,0.25,0)
yesBtn.Position = UDim2.new(0.1,0,0.7,0)
yesBtn.Text = "네"
yesBtn.BackgroundColor3 = Color3.fromRGB(80,200,120)

local noBtn = Instance.new("TextButton", confirmFrame)
noBtn.Size = UDim2.new(0.4,0,0.25,0)
noBtn.Position = UDim2.new(0.5,0,0.7,0)
noBtn.Text = "아니요"
noBtn.BackgroundColor3 = Color3.fromRGB(200,80,80)

-- ===== TP 관련 =====
local function teleport(pos)
	getRoot().CFrame = CFrame.new(pos + Vector3.new(0,3,0))
end

local function removeMarker()
	if marker then
		marker:Destroy()
		marker = nil
	end
end

local function createMarker(pos)
	removeMarker()
	marker = Instance.new("Part")
	marker.Size = Vector3.new(2,0.2,2)
	marker.Anchored = true
	marker.CanCollide = false
	marker.Material = Enum.Material.Neon
	marker.Color = Color3.fromRGB(255,0,0)
	marker.Position = pos + Vector3.new(0,0.1,0)
	marker.Parent = Workspace
end

UserInputService.TouchTap:Connect(function(touchPositions, gameProcessed)
	if gameProcessed then return end
	if not tpEnabled then return end
	
	local pos = touchPositions[1]
	if not pos then return end
	
	local ray = camera:ScreenPointToRay(pos.X, pos.Y)
	local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000)
	
	if result and result.Position then
		pendingPosition = result.Position
		createMarker(pendingPosition)
		
		coordLabel.Text = string.format(
			"X: %.1f  Y: %.1f  Z: %.1f",
			pendingPosition.X,
			pendingPosition.Y,
			pendingPosition.Z
		)
		
		confirmFrame.Visible = true
	end
end)

yesBtn.MouseButton1Click:Connect(function()
	if pendingPosition then
		teleport(pendingPosition)
	end
	removeMarker()
	confirmFrame.Visible = false
	pendingPosition = nil
end)

noBtn.MouseButton1Click:Connect(function()
	removeMarker()
	confirmFrame.Visible = false
	pendingPosition = nil
end)
