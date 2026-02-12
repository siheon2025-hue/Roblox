local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local speed = 50
local bodyVelocity
local bodyGyro

local function startFlying()
	local character = player.Character
	if not character then return end
	
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1,1,1) * 100000
	bodyVelocity.Velocity = Vector3.new(0,0,0)
	bodyVelocity.Parent = humanoidRootPart

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1,1,1) * 100000
	bodyGyro.CFrame = humanoidRootPart.CFrame
	bodyGyro.Parent = humanoidRootPart

	flying = true

	RunService.RenderStepped:Connect(function()
		if flying and humanoidRootPart then
			local moveDirection = character.Humanoid.MoveDirection
			bodyVelocity.Velocity = moveDirection * speed
			bodyGyro.CFrame = workspace.CurrentCamera.CFrame
		end
	end)
end

local function stopFlying()
	flying = false
	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end
end

-- 더블 점프로 날기 (모바일도 가능)
player.CharacterAdded:Connect(function(character)
	local humanoid = character:WaitForChild("Humanoid")
	local jumpCount = 0

	humanoid.StateChanged:Connect(function(old, new)
		if new == Enum.HumanoidStateType.Jumping then
			jumpCount += 1
			if jumpCount == 2 then
				startFlying()
			end
		elseif new == Enum.HumanoidStateType.Landed then
			jumpCount = 0
			stopFlying()
		end
	end)
end)
