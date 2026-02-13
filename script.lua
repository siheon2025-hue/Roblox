local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- 캐릭터 루트 파트 가져오기
local function getRootPart()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

-- GUI 생성
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.TextColor3 = Color3.new(1,1,1)
title.Text = "TP Toggle"

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.8,0,0,50)
button.Position = UDim2.new(0.1,0,0.5,-25)
button.Text = "TP OFF"
button.BackgroundColor3 = Color3.fromRGB(100,100,255)
button.TextColor3 = Color3.new(1,1,1)

-- TP 상태
local tpEnabled = false

button.MouseButton1Click:Connect(function()
	tpEnabled = not tpEnabled
	button.Text = tpEnabled and "TP ON" or "TP OFF"
end)

-- TP 함수 (Raycast + 캐릭터 높이 보정)
local function tpToPosition(pos)
	local root = getRootPart()
	local halfHeight = root.Size.Y / 2
	root.CFrame = CFrame.new(pos.X, pos.Y + halfHeight, pos.Z)
end

-- PC: 마우스 클릭
local mouse = player:GetMouse()
mouse.Button1Down:Connect(function()
	if not tpEnabled then return end
	local target = mouse.Hit
	if target then
		tpToPosition(target.Position)
	end
end)

-- 모바일: 터치
UserInputService.TouchStarted:Connect(function(input)
	if not tpEnabled then return end
	if input.UserInputType == Enum.UserInputType.Touch then
		-- 화면 좌표 기준 Raycast
		local ray = camera:ScreenPointToRay(input.Position.X, input.Position.Y)
		local result = workspace:Raycast(ray.Origin, ray.Direction * 1000)
		if result then
			tpToPosition(result.Position)
		end
	end
end)
