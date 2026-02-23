local lp = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- 전역 변수
_G.FullInvis = false
_G.SilentAim = false
_G.ESP = false
_G.HitboxSize = 10
_G.Speed = 16
_G.InfJump = false

-- [ UI 생성 ]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 420)
Main.Position = UDim2.new(0.5, -120, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "CG_CLAN FIX V6"
Title.TextColor3 = Color3.fromRGB(255, 100, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- 입력창 (히트박스 크기 지정)
local Input = Instance.new("TextBox", Main)
Input.Size = UDim2.new(0.9, 0, 0, 35)
Input.Position = UDim2.new(0.05, 0, 0.12, 0)
Input.PlaceholderText = "히트박스 크기 (입력 후 엔터)"
Input.Text = "10"
Input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Input.TextColor3 = Color3.new(1, 1, 1)
Input.FocusLost:Connect(function() _G.HitboxSize = tonumber(Input.Text) or 10 end)

local function CreateBtn(name, pos, color, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 기능 토글
CreateBtn("SILENT AIM & HITBOX", UDim2.new(0.05, 0, 0.25, 0), Color3.fromRGB(150, 0, 0), function()
    _G.SilentAim = not _G.SilentAim
end)

CreateBtn("ESP (월핵)", UDim2.new(0.05, 0, 0.4, 0), Color3.fromRGB(150, 0, 0), function()
    _G.ESP = not _G.ESP
end)

-- 투명화 토글 (꺼질 때 즉시 복구 로직 포함)
CreateBtn("FULL INVISIBILITY", UDim2.new(0.05, 0, 0.55, 0), Color3.fromRGB(50, 50, 50), function()
    _G.FullInvis = not _G.FullInvis
    if not _G.FullInvis and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 0
                v.LocalTransparencyModifier = 0
            end
        end
    end
end)

CreateBtn("SPEED 100 / JUMP", UDim2.new(0.05, 0, 0.7, 0), Color3.fromRGB(50, 50, 50), function()
    _G.Speed = (_G.Speed == 16) and 100 or 16
    _G.InfJump = not _G.InfJump
end)

-- [ 무한 루프: 실시간 감지 ]
RunService.Stepped:Connect(function()
    -- 1. 히트박스 & ESP (상대방 부활 시 즉시 재적용)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            
            if _G.SilentAim then
                hrp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                hrp.Transparency = 0.7 -- 확인용 (투명하게 하려면 1)
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1) -- 원래 크기로 복구
                hrp.Transparency = 0
            end

            -- ESP 하이라이트
            if _G.ESP then
                if not v.Character:FindFirstChild("Highlight") then
                    Instance.new("Highlight", v.Character).FillColor = Color3.new(1, 0, 0)
                end
            else
                if v.Character:FindFirstChild("Highlight") then v.Character.Highlight:Destroy() end
            end
        end
    end

    -- 2. 내 캐릭터 상태 (투명화 & 스피드)
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = _G.Speed
        
        if _G.FullInvis then
            for _, p in pairs(lp.Character:GetDescendants()) do
                if p:IsA("BasePart") or p:IsA("Decal") then
                    p.Transparency = 1
                    p.LocalTransparencyModifier = 1
                end
            end
        end
    end
end)

-- 무한 점프
UIS.JumpRequest:Connect(function()
    if _G.InfJump and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid:ChangeState(3) end
end)
