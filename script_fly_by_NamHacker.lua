
--[[
✅ Script Full GUI Hack by NamHacker
Tính năng:
- Fly theo hướng cam
- NoClip
- Teleport sau người
- Auto TP 0.1 studs
- ESP tên người chơi
- Auto Clicker
- Menu ẩn/hiện
]]--

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local cam = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local hrp = player.Character:WaitForChild("HumanoidRootPart")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NamHackerGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 260, 0, 350)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", Frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "👑 by NamHacker"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local function createBtn(txt, posY)
    local b = Instance.new("TextButton", Frame)
    b.Size = UDim2.new(1, -20, 0, 30)
    b.Position = UDim2.new(0, 10, 0, posY)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    return b
end

-- Fly
local flying = false
local flySpeed = 50
local function fly()
    local bv = Instance.new("BodyVelocity", hrp)
    bv.Name = "FlyForce"
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(1,1,1) * 1e5
    bv.P = 1e4

    RS:BindToRenderStep("Fly", Enum.RenderPriority.Input.Value, function()
        bv.Velocity = cam.CFrame.LookVector * flySpeed
    end)
end

local function stopFly()
    RS:UnbindFromRenderStep("Fly")
    local f = hrp:FindFirstChild("FlyForce")
    if f then f:Destroy() end
end

local btnFly = createBtn("🕊️ Toggle Fly", 50)
btnFly.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then fly() else stopFly() end
end)

-- NoClip
local noclip = false
local btnNoclip = createBtn("🚪 Toggle NoClip", 90)
btnNoclip.MouseButton1Click:Connect(function()
    noclip = not noclip
end)

RS.Stepped:Connect(function()
    if noclip and player.Character then
        for _, p in pairs(player.Character:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
        end
    end
end)

-- TP sau người
local btnTP = createBtn("🎯 TP Sau Người Gần Nhất", 130)
btnTP.MouseButton1Click:Connect(function()
    local closest, dist = nil, math.huge
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < dist then dist = d closest = p end
        end
    end
    if closest and closest.Character then
        hrp.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0.1)
    end
end)

-- Auto TP
local autoTP = false
local autoTPConnection

local function startAutoTP()
    autoTPConnection = RS.Heartbeat:Connect(function()
        local closest, dist = nil, math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < dist then dist = d closest = p end
            end
        end
        if closest and closest.Character then
            hrp.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0.1)
        end
    end)
end

local function stopAutoTP()
    if autoTPConnection then
        autoTPConnection:Disconnect()
        autoTPConnection = nil
    end
end

local btnAutoTP = createBtn("🚀 Toggle Auto TP 0.1 Stud", 170)
btnAutoTP.MouseButton1Click:Connect(function()
    autoTP = not autoTP
    if autoTP then startAutoTP() btnAutoTP.Text = "⛔ Dừng Auto TP"
    else stopAutoTP() btnAutoTP.Text = "🚀 Toggle Auto TP 0.1 Stud"
    end
end)

-- ESP
local btnESP = createBtn("🔍 Toggle ESP Tên", 210)
local showingESP = false
local espConnections = {}

local function showESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head and not head:FindFirstChild("NamESP") then
                local billboard = Instance.new("BillboardGui", head)
                billboard.Name = "NamESP"
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.AlwaysOnTop = true

                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = p.Name
                label.TextColor3 = Color3.new(1, 1, 1)
                label.BackgroundTransparency = 1
                label.TextScaled = true
            end
        end
    end
end

local function clearESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local gui = p.Character.Head:FindFirstChild("NamESP")
            if gui then gui:Destroy() end
        end
    end
end

btnESP.MouseButton1Click:Connect(function()
    showingESP = not showingESP
    if showingESP then showESP() btnESP.Text = "⛔ Ẩn ESP"
    else clearESP() btnESP.Text = "🔍 Toggle ESP Tên"
    end
end)

-- Auto Clicker
local clicking = false
local btnClick = createBtn("🖱️ Toggle Auto Click", 250)
btnClick.MouseButton1Click:Connect(function()
    clicking = not clicking
    btnClick.Text = clicking and "⛔ Dừng Auto Click" or "🖱️ Toggle Auto Click"
end)

RS.Heartbeat:Connect(function()
    if clicking then
        mouse1click()
    end
end)

-- Toggle Menu
local toggleBtn = Instance.new("TextButton", ScreenGui)
toggleBtn.Size = UDim2.new(0, 120, 0, 30)
toggleBtn.Position = UDim2.new(0, 20, 0, 60)
toggleBtn.Text = "🧰 Mở/Ẩn Menu"
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 14
toggleBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)
