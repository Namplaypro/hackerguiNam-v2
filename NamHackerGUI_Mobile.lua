
-- Nam Hacker GUI Tổng Hợp (Mobile friendly + God Mode)
local P = game.Players.LocalPlayer
local C = P.Character or P.CharacterAdded:Wait()
local H = C:WaitForChild("Humanoid")
local R = C:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local G = Instance.new("ScreenGui", P:WaitForChild("PlayerGui"))
G.Name = "NamHackerMenu"
G.ResetOnSpawn = false

-- Frame chính thu nhỏ, giữa màn hình
local F = Instance.new("Frame", G)
F.Size = UDim2.new(0, 280, 0, 480)
F.Position = UDim2.new(0.5, -140, 0.5, -240)
F.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
F.BorderSizePixel = 0
Instance.new("UICorner", F).CornerRadius = UDim.new(0, 12)
F.ZIndex = 2

-- Gradient nền
local gradFrame = Instance.new("UIGradient", F)
gradFrame.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 10, 80)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 130, 210))
}

-- Tiêu đề
local T = Instance.new("TextLabel", F)
T.Size = UDim2.new(1, 0, 0, 40)
T.Position = UDim2.new(0, 0, 0, 10)
T.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
T.TextColor3 = Color3.new(1, 1, 1)
T.Text = "Nam Hacker Menu"
T.Font = Enum.Font.GothamBold
T.TextSize = 20
T.BorderSizePixel = 0
Instance.new("UICorner", T).CornerRadius = UDim.new(0, 12)
T.ZIndex = 3

-- ScrollFrame chứa nút bấm
local scrollFrame = Instance.new("ScrollingFrame", F)
scrollFrame.Size = UDim2.new(1, -20, 1, -70)
scrollFrame.Position = UDim2.new(0, 10, 0, 60)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.CanvasSize = UDim2.new(0, 0, 3, 0)
scrollFrame.ZIndex = 3

local UIListLayout = Instance.new("UIListLayout", scrollFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Hàm tạo nút
local function createBtn(txt, callback)
	local B = Instance.new("TextButton", scrollFrame)
	B.Size = UDim2.new(1, 0, 0, 35)
	B.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	B.TextColor3 = Color3.new(1, 1, 1)
	B.Text = txt
	B.Font = Enum.Font.Gotham
	B.TextSize = 18
	Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
	B.ZIndex = 4
	B.MouseButton1Click:Connect(callback)
	return B
end

-- Fly
local flying = false
local bv
createBtn("Toggle Fly", function()
	flying = not flying
	if flying then
		bv = Instance.new("BodyVelocity")
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.MaxForce = Vector3.new(1, 1, 1) * 1e9
		bv.Parent = R
		RS:BindToRenderStep("Fly", Enum.RenderPriority.Character.Value, function()
			if flying then
				local dir = Vector3.zero
				if UIS:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
				if UIS:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
				if dir.Magnitude > 0 then
					bv.Velocity = dir.Unit * 80
				else
					bv.Velocity = Vector3.zero
				end
			else
				RS:UnbindFromRenderStep("Fly")
				if bv then bv:Destroy() end
			end
		end)
	else
		RS:UnbindFromRenderStep("Fly")
		if bv then bv:Destroy() end
	end
end)

-- Noclip
local noclip = false
local noclipConnection
createBtn("Toggle Noclip", function()
	noclip = not noclip
	if noclip and not noclipConnection then
		noclipConnection = RS.Stepped:Connect(function()
			if noclip then
				for _, v in pairs(C:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			end
		end)
	elseif not noclip and noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end
end)

-- ESP
createBtn("Enable ESP", function()
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= P and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			if not plr.Character:FindFirstChild("NamHackerESP") then
				local esp = Instance.new("BillboardGui", plr.Character)
				esp.Name = "NamHackerESP"
				esp.Size = UDim2.new(0, 100, 0, 40)
				esp.Adornee = plr.Character.HumanoidRootPart
				esp.AlwaysOnTop = true
				local name = Instance.new("TextLabel", esp)
				name.Size = UDim2.new(1, 0, 1, 0)
				name.BackgroundTransparency = 1
				name.Text = plr.Name
				name.TextColor3 = Color3.fromRGB(255, 50, 50)
				name.Font = Enum.Font.GothamBold
				name.TextScaled = true
			end
		end
	end
end)

-- Speed/Jump điều chỉnh
local speed = 16
local jump = 50
H.WalkSpeed = speed
H.JumpPower = jump
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Equals then speed += 4 H.WalkSpeed = speed end
	if input.KeyCode == Enum.KeyCode.Minus then speed = math.max(4, speed - 4) H.WalkSpeed = speed end
	if input.KeyCode == Enum.KeyCode.RightBracket then jump += 10 H.JumpPower = jump end
	if input.KeyCode == Enum.KeyCode.LeftBracket then jump = math.max(10, jump - 10) H.JumpPower = jump end
end)
createBtn("Speed/Jump: =/-/[/]", function() end)

-- Teleport đến chuột
createBtn("Teleport to Mouse", function()
	local mousePos = P:GetMouse().Hit.Position
	R.CFrame = CFrame.new(mousePos + Vector3.new(0, 5, 0))
end)

-- Auto Heal
local healing = false
createBtn("Toggle Auto Heal", function()
	healing = not healing
	if healing then
		spawn(function()
			while healing do
				wait(1)
				if H.Health < 100 then
					H.Health = H.MaxHealth
				end
			end
		end)
	end
end)

-- TextBox Teleport Player
local tpBox = Instance.new("TextBox", scrollFrame)
tpBox.Size = UDim2.new(1, 0, 0, 35)
tpBox.PlaceholderText = "Tên người chơi để Teleport"
tpBox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
tpBox.TextColor3 = Color3.new(1, 1, 1)
tpBox.Font = Enum.Font.Gotham
tpBox.TextSize = 18
Instance.new("UICorner", tpBox).CornerRadius = UDim.new(0, 6)

createBtn("TP đến Player", function()
	local target = game.Players:FindFirstChild(tpBox.Text)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		R.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
	end
end)

-- TextBox Kick Player
local kickBox = Instance.new("TextBox", scrollFrame)
kickBox.Size = UDim2.new(1, 0, 0, 35)
kickBox.PlaceholderText = "Tên người chơi để Kick"
kickBox.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
kickBox.TextColor3 = Color3.new(1, 1, 1)
kickBox.Font = Enum.Font.Gotham
kickBox.TextSize = 18
Instance.new("UICorner", kickBox).CornerRadius = UDim.new(0, 6)

createBtn("Kick Player", function()
	local target = game.Players:FindFirstChild(kickBox.Text)
	if target then
		target:Kick("Kicked by Nam Hacker GUI")
	end
end)

-- God Mode (bất tử)
local godmode = false
createBtn("Toggle God Mode", function()
	godmode = not godmode
	if godmode then
		spawn(function()
			while godmode do
				wait(0.1)
				if H and H.Health < H.MaxHealth then
					H.Health = H.MaxHealth
				end
			end
		end)
	end
end)

-- Anti Kick
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
	local args = {...}
	if getnamecallmethod() == "Kick" then
		return
	end
	return old(...)
end)
setreadonly(mt, true)

-- Toggle GUI bằng phím X
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.X then
		F.Visible = not F.Visible
	end
end)

-- Hiển thị GUI lúc đầu
F.Visible = true
