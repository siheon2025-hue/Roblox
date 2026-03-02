local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

-- 설정 데이터 (여기에 해당 그룹 ID를 입력하세요)
local ROBLOX_ADMIN_GROUP = 1200769 -- 공식 로블록스 관리자 그룹
local RIVAL_GROUP_ID = 0           -- 라이벌 그룹 ID
local RIVAL_MIN_RANK = 200         -- 라이벌 그룹 내 개발자/관리자 최소 등급

local function displaySystemNotice(text, color)
    local textChannel = TextChatService:WaitForChild("TextChannels"):FindFirstChild("RBXSystem")
    if textChannel then
        textChannel:DisplaySystemMessage("<font color='" .. color .. "'>[" .. text .. "]</font>")
    end
end

local function checkPlayerIdentity(player)
    if player == Players.LocalPlayer then return end

    local name = player.Name
    local isSpecial = false

    -- 1. 로블록스 모더레이터 체크
    if player:IsInGroup(ROBLOX_ADMIN_GROUP) then
        displaySystemNotice("모더레이터 감지: " .. name, "#FF0000") -- 빨간색
        isSpecial = true
    end

    -- 2. 라이벌 개발자 체크 (일반 멤버 제외)
    local rank = player:GetRankInGroup(RIVAL_GROUP_ID)
    if rank >= RIVAL_MIN_RANK then
        displaySystemNotice("라이벌 개발자 감지: " .. name, "#FFA500") -- 주황색
        isSpecial = true
    end

    -- 3. 특수 신분이 아닌 경우 일반 플레이어로 표시
    if not isSpecial then
        displaySystemNotice("평범한 플레이어 입장: " .. name, "#FFFFFF") -- 흰색
    end
end

-- 실행 및 이벤트 연결
for _, plr in ipairs(Players:GetPlayers()) do
    checkPlayerIdentity(plr)
end
Players.PlayerAdded:Connect(checkPlayerIdentity)
