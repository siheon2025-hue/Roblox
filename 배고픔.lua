-- 사이트 열기 + 클립보드 복사 버튼
local siteBtn = Instance.new("TextButton", keyFrame)
siteBtn.Size = UDim2.new(0.6,0,0.2,0)
siteBtn.Position = UDim2.new(0.2,0,0.9,0)
siteBtn.Text = "키 받으러 가기"
siteBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
siteBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", siteBtn)

siteBtn.MouseButton1Click:Connect(function()
	setclipboard("갸꿀 딱딱이쥬 속았쥬?")
	warn("클립보드를 봐주세요!")
end)
