--[[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Created by: L Ua all (Interactive 3D Focus Version)
]]

return function(Config)
    Config = Config or {}

    local function ForceString(val, fallback)
        if typeof(val) == "string" then return val end
        return tostring(val or fallback or "")
    end

    local TitleText = ForceString(Config.Title, "VFX Hub")
    local MainColor = Config.MainColor or Color3.fromRGB(160, 80, 255)
    local CustomTabs = Config.Tabs or {} 

    local P = game:GetService("Players")
    local TS = game:GetService("TweenService")
    local RS = game:GetService("RunService")
    local p = P.LocalPlayer
    local pg = p:WaitForChild("PlayerGui")

    for _, old in ipairs(pg:GetChildren()) do
        if old.Name == "VFXHub" then old:Destroy() end
    end

    local UI = Instance.new("ScreenGui", pg)
    UI.Name, UI.ResetOnSpawn = "VFXHub", false

    local Main = Instance.new("Frame", UI)
    Main.AnchorPoint, Main.Position, Main.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,1000,0,650)
    Main.BackgroundColor3, Main.ClipsDescendants = Color3.fromRGB(30, 30, 30), true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

    local Cont = Instance.new("Frame", Main)
    Cont.Position, Cont.Size, Cont.BackgroundTransparency = UDim2.new(0,0,0,40), UDim2.new(1,0,1,-40), 1

    -- [[ 🖼️ RIGHT INFO PANEL ]]
    local InfoPanel = Instance.new("Frame", Cont)
    InfoPanel.Position = UDim2.new(0, 1050, 0, 30) -- ซ่อนไว้ทางขวาสุด
    InfoPanel.Size = UDim2.new(0, 450, 0, 450)
    InfoPanel.BackgroundColor3, InfoPanel.BackgroundTransparency = Color3.fromRGB(20, 15, 35), 0.3
    Instance.new("UICorner", InfoPanel).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", InfoPanel)
    stroke.Color, stroke.Thickness, stroke.Transparency = MainColor, 2, 0.5

    local InfoTitle = Instance.new("TextLabel", InfoPanel)
    InfoTitle.Size, InfoTitle.Position, InfoTitle.BackgroundTransparency = UDim2.new(1,-50,0,50), UDim2.new(0,25,0,20), 1
    InfoTitle.TextColor3, InfoTitle.Font, InfoTitle.TextSize = Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 28

    local InfoDesc = Instance.new("TextLabel", InfoPanel)
    InfoDesc.Size, InfoDesc.Position, InfoDesc.BackgroundTransparency = UDim2.new(1,-50,0,80), UDim2.new(0,25,0,75), 1
    InfoDesc.TextColor3, InfoDesc.Font, InfoDesc.TextSize, InfoDesc.TextWrapped = Color3.fromRGB(210,210,210), Enum.Font.Gotham, 16, true

    -- [[ 🎥 VIEWPORT & CAMERA FOCUS SYSTEM ]]
    local VP = Instance.new("ViewportFrame", Cont)
    VP.Position, VP.Size, VP.BackgroundTransparency = UDim2.new(0,30,0,30), UDim2.new(0,450,0,450), 1
    local VPClick = Instance.new("TextButton", VP) -- ใช้สำหรับตรวจจับการคลิกที่ตัวละคร
    VPClick.Size, VPClick.BackgroundTransparency, VPClick.Text = UDim2.new(1,0,1,0), 1, ""

    local WM = Instance.new("WorldModel", VP)
    local Cam = Instance.new("Camera", VP)
    VP.CurrentCamera = Cam

    local charModel, hrp
    local function setupMainChar()
        WM:ClearAllChildren()
        charModel = P:CreateHumanoidModelFromUserId(p.UserId)
        charModel.Parent = WM
        hrp = charModel:WaitForChild("HumanoidRootPart")
        hrp.Anchored = true
        Cam.CFrame = CFrame.new(Vector3.new(0, 2, -9), hrp.Position + Vector3.new(0, 0.5, 0))
        
        local rot = 0
        RS.RenderStepped:Connect(function(dt)
            rot = rot + (dt * 30)
            if hrp then hrp.CFrame = CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(rot), 0) end
        end)
    end
    setupMainChar()

    -- ฟังก์ชันเลื่อนกล้องไปโฟกัสส่วนต่างๆ
    local function FocusPart(partName)
        local target = charModel:FindFirstChild(partName, true)
        if target and target:IsA("BasePart") then
            local offset = Vector3.new(0, 0, -4) -- ระยะห่างการซูม
            if partName == "Head" then offset = Vector3.new(0, 0, -2.5) end
            
            local targetCF = CFrame.new(target.Position + (target.CFrame.LookVector * offset.Z), target.Position)
            TS:Create(Cam, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {CFrame = targetCF}):Play()
        end
    end

    -- ฟังก์ชันสไลด์ Panel กลับ
    local isPanelOpen = false
    local function HidePanel()
        if isPanelOpen then
            isPanelOpen = false
            TS:Create(InfoPanel, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 1050, 0, 30)}):Play()
            -- รีเซ็ตกล้องกลับไปมุมกว้าง
            TS:Create(Cam, TweenInfo.new(0.6), {CFrame = CFrame.new(Vector3.new(0, 2, -9), hrp.Position + Vector3.new(0, 0.5, 0))}):Play()
        end
    end

    local function ShowPanel(data)
        InfoTitle.Text = data.Name or ""
        InfoDesc.Text = data.Description or ""
        if not isPanelOpen then
            isPanelOpen = true
            TS:Create(InfoPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 520, 0, 30)}):Play()
        end
    end

    VPClick.MouseButton1Click:Connect(HidePanel)

    -- [[ TAB CONTAINER ]]
    local SlotP = Instance.new("Frame", Cont)
    SlotP.AnchorPoint, SlotP.Position, SlotP.Size = Vector2.new(0.5, 1), UDim2.new(0.5, 0, 1, -25), UDim2.new(0, 900, 0, 90)
    SlotP.BackgroundColor3, SlotP.BackgroundTransparency = Color3.fromRGB(15, 10, 25), 0.6
    Instance.new("UICorner", SlotP).CornerRadius = UDim.new(0, 12)
    local layout = Instance.new("UIListLayout", SlotP)
    layout.FillDirection, layout.HorizontalAlignment, layout.VerticalAlignment, layout.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0, 10)

    for _, info in ipairs(CustomTabs) do
        local btn = Instance.new("TextButton", SlotP)
        btn.Size, btn.BackgroundColor3, btn.Text = UDim2.new(0, 80, 0, 80), Color3.fromRGB(60, 40, 100), ""
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        
        local l = Instance.new("TextLabel", btn)
        l.Size, l.BackgroundTransparency, l.Text = UDim2.new(1,0,1,0), 1, ForceString(info.Name)
        l.TextColor3, l.Font, l.TextSize, l.TextScaled = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12, true

        btn.MouseButton1Click:Connect(function()
            ShowPanel(info)
            if info.Focus then FocusPart(info.Focus) end
            if info.Callback then info.Callback() end
        end)
    end

    return { UI = UI }
end