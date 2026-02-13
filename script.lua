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

-- TP 상태
local tpEnabled = false
local tpUnlocked = false  -- 암호 맞으면 true
local currentKey = ""

-- GUI 생성
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 220)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.Active = true
frame.Draggable = true

-- 제목
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.TextColor3 = Color3.new(1,1,1)
title.Text = "TP Toggle (Key Required)"

-- 키 라벨
local keyLabel = Instance.new("TextLabel", frame)
keyLabel.Size = UDim2.new(0.8,0,0,25)
keyLabel.Position = UDim2.new(0.1,0,0.1,0)
keyLabel.BackgroundTransparency = 0.5
keyLabel.BackgroundColor3 = Color3.fromRGB(60,60,60)
keyLabel.TextColor3 = Color3.new(1,1,0)
keyLabel.Text = "키 없음"
keyLabel.TextScaled = true

-- 키 얻기 버튼
local getKeyButton = Instance.new("TextButton", frame)
getKeyButton.Size = UDim2.new(0.8,0,0,30)
getKeyButton.Position = UDim2.new(0.1,0,0.3,0)
getKeyButton.Text = "키 얻기"
getKeyButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
getKeyButton.TextColor3 = Color3.new(1,1,1)

-- 입력 박스
local inputBox = Instance.new("TextBox", frame)
inputBox.Size = UDim2.new(0.8,0,0,30)
inputBox.Position = UDim2.new(0.1,0,0.45,0)
inputBox.PlaceholderText = "암호 입력"
inputBox.Text = ""

-- TP 버튼
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.8,0,0,40)
button.Position = UDim2.new(0.1,0,0.65,0)
button.Text = "TP를 사용하려면 암호를 입력하세요"
button.BackgroundColor3 = Color3.fromRGB(100,100,255)
button.TextColor3 = Color3.new(1,1,1)

-- 랜덤 키 생성 함수 (소문자 + 숫자, 5글자 고정)
local function generateKey()
	local length = 5
	local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
	local key = ""
	for i = 1,length do
		local rand = math.random(1,#chars)
		key = key .. string.sub(chars, rand, rand)
	end
	return key
end

-- 키 얻기 버튼 클릭
getKeyButton.MouseButton1Click:Connect(function()
	currentKey = generateKey()
	keyLabel.Text = "생성 키: "..currentKey

	-- Studio에서는 클립보드 복사
	pcall(function()
		UserInputService:SetClipboard(currentKey)
	end)

	print("생성된 키:", currentKey)
end)

-- 암호 입력 확인
inputBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		if inputBox.Text == currentKey and currentKey ~= "" then
			tpUnlocked = true
			button.Text = "TP OFF"
			print("인증 성공! TP 잠금 해제 (게임 종료 전까지 유지)")
		else
			tpUnlocked = false
			button.Text = "TP를 사용하려면 암호를 입력하세요"
			print("암호 틀림! TP 잠금 유지")
		end
	end
end)

-- TP 버튼 클릭
button.MouseButton1Click:Connect(function()
	if not tpUnlocked then
		button.Text = "TP를 사용하려면 암호를 입력하세요"
		return
	end
	
	tpEnabled = not tpEnabled
	button.Text = tpEnabled and "TP ON" or "TP OFF"
end)

-- TP 함수
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
		local ray = camera:ScreenPointToRay(input.Position.X, input.Position.Y)
		local result = workspace:Raycast(ray.Origin, ray.Direction * 1000)
		if result then
			tpToPosition(result.Position)
		end
	end
end)
