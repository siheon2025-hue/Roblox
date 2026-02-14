-- ScreenGui 만들기
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- 버튼 만들기
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "에임 모드 OFF"
button.Parent = screenGui

local aimMode = false

button.MouseButton1Click:Connect(function()
    aimMode = not aimMode
    button.Text = aimMode and "에임 모드 ON" or "에임 모드 OFF"
end)

-- 가장 가까운 적 찾기
local function getClosestEnemy()
    local closest = nil
    local shortest = math.huge

    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = plr
            end
        end
    end

    return closest
end

-- 마우스 클릭 시 총알 발사
mouse.Button1Down:Connect(function()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local origin = player.Character.HumanoidRootPart.Position
    local direction

    if aimMode then
        local target = getClosestEnemy()
        if target then
            direction = (target.Character.HumanoidRootPart.Position - origin).Unit * 500
        else
            direction = (mouse.Hit.Position - origin).Unit * 500
        end
    else
        direction = (mouse.Hit.Position - origin).Unit * 500
    end

    -- Raycast
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {player.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(origin, direction, rayParams)
    if result then
        print("타격 대상:", result.Instance.Name)
    end
end)
