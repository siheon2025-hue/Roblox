-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHum()
	return getChar():WaitForChild("Humanoid")
end

local function getRoot()
	return getChar():WaitForChild("HumanoidRootPart")
end

-- 상태값
local tpOn = false
local espOn = false

local defaultSpeed = 16
local defaultJump = 50

local marker
local pendingPos
local espTable = {}

-- ===== GUI =====

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(340, 550)
frame.Position = UDim2.fromOffset(80, 60)
frame.BackgroundColor3 = Color3.fromRGB(255,0,0)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

-- 🌈 무지개 배경
RunService.RenderStepped:Connect(function()
	local hue = tick() % 5 / 5
	frame.BackgroundColor3 = Color3.fromHSV(hue,1,1)
end)

local function makeBtn(text,y,color)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.8,0,0,40)
	b.Position = UDim2.new(0.1,0,y,0)
	b.Text = text
	b.BackgroundColor3 = color
	b.TextColor3 = Color3.new(1,1,1)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b)
	return b
end

-- TP
local tpBtn = makeBtn("TP OFF",0.05,Color3.fromRGB(100,100,255))

-- Speed
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0.8,0,0,35)
speedBox.Position = UDim2.new(0.1,0,0.15,0)
speedBox.PlaceholderText = "Speed 입력"
speedBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.BorderSizePixel = 0
Instance.new("UICorner", speedBox)

local speedBtn = makeBtn("Speed 적용",0.22,Color3.fromRGB(80,160,255))

-- Jump
local jumpBox = Instance.new("TextBox", frame)
jumpBox.Size = UDim2.new(0.8,0,0,35)
jumpBox.Position = UDim2.new(0.1,0,0.32,0)
jumpBox.PlaceholderText = "Jump 입력"
jumpBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
jumpBox.TextColor3 = Color3.new(1,1,1)
jumpBox.BorderSizePixel = 0
Instance.new("UICorner", jumpBox)

local jumpBtn = makeBtn("Jump 적용",0.39,Color3.fromRGB(80,255,120))

-- 낮 / 밤
local dayBtn = makeBtn("낮",0.49,Color3.fromRGB(255,200,100))
local nightBtn = makeBtn("밤",0.56,Color3.fromRGB(100,100,255))

-- ESP
local espBtn = makeBtn("ESP OFF",0.65,Color3.fromRGB(255,80,80))

-- ===== 기능 =====

tpBtn.MouseButton1Click:Connect(function()
	tpOn = not tpOn
	tpBtn.Text = tpOn and "TP ON" or "TP OFF"
end)

speedBtn.MouseButton1Click:Connect(function()
	local v = tonumber(speedBox.Text)
	getHum().WalkSpeed = v or defaultSpeed
end)

jumpBtn.MouseButton1Click:Connect(function()
	local v = tonumber(jumpBox.Text)
	getHum().JumpPower = v or defaultJump
end)

dayBtn.MouseButton1Click:Connect(function()
	Lighting.ClockTime = 14
end)

nightBtn.MouseButton1Click:Connect(function()
	Lighting.ClockTime = 0
end)

-- ===== ESP =====

local function addESP(plr)
	if plr == player then return end
	if not plr.Character then return end
	if espTable[plr] then return end

	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(255,0,0)
	highlight.FillTransparency = 0.4
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Adornee = plr.Character
	highlight.Parent = plr.Character

	espTable[plr] = highlight
end

local function removeESP()
	for _,v in pairs(espTable) do
		if v then v:Destroy() end
	end
	table.clear(espTable)
end

espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = espOn and "ESP ON" or "ESP OFF"

	if espOn then
		for _,plr in pairs(Players:GetPlayers()) do
			addESP(plr)
		end
	else
		removeESP()
	end
end)

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(0.5)
		if espOn then addESP(plr) end
	end)
end)

-- ===== TP 네온 발판 + 작은 확인창 =====

mouse.Button1Down:Connect(function()
	if not tpOn then return end
	if not mouse.Hit then return end

	local pos = mouse.Hit.Position
	pendingPos = pos

	if marker then marker:Destroy() end

	marker = Instance.new("Part")
	marker.Size = Vector3.new(6,0.5,6)
	marker.Position = pos + Vector3.new(0,0.25,0)
	marker.Anchored = true
	marker.CanCollide = false
	marker.Material = Enum.Material.Neon
	marker.Color = Color3.fromRGB(255,0,0)
	marker.Parent = workspace

	-- 작은 확인창
	local confirmGui = Instance.new("ScreenGui", player.PlayerGui)

	local box = Instance.new("Frame", confirmGui)
	box.Size = UDim2.fromOffset(220,100)
	box.Position = UDim2.fromScale(0.5,0.5)
	box.AnchorPoint = Vector2.new(0.5,0.5)
	box.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Instance.new("UICorner", box)

	local label = Instance.new("TextLabel", box)
	label.Size = UDim2.new(1,0,0.5,0)
	label.BackgroundTransparency = 1
	label.Text = "정말 이동?"
	label.TextColor3 = Color3.new(1,1,1)
	label.TextScaled = true

	local yes = Instance.new("TextButton", box)
	yes.Size = UDim2.new(0.5,0,0.5,0)
	yes.Position = UDim2.new(0,0,0.5,0)
	yes.Text = "YES"
	yes.BackgroundColor3 = Color3.fromRGB(0,200,0)

	local no = Instance.new("TextButton", box)
	no.Size = UDim2.new(0.5,0,0.5,0)
	no.Position = UDim2.new(0.5,0,0.5,0)
	no.Text = "NO"
	no.BackgroundColor3 = Color3.fromRGB(200,0,0)

	yes.MouseButton1Click:Connect(function()
		getRoot().CFrame = CFrame.new(pendingPos + Vector3.new(0,3,0))
		confirmGui:Destroy()
	end)

	no.MouseButton1Click:Connect(function()
		if marker then marker:Destroy() end
		confirmGui:Destroy()
	end)
end)
