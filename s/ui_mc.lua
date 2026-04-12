--[[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Created by: L Ua all (Highlight & Stop-Rotation Version)
]]

return function(Config)
    Config = Config or {}

    local function ForceString(val, fallback)
        if typeof(val) == "string" then return val end
        return tostring(val or fallback or "")
    end

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

    -- [[ 🎥 VIEWPORT SYSTEM ]]
    local VP = Instance.new("ViewportFrame", Cont)
    VP.Position, VP.Size, VP.BackgroundTransparency = UDim2.new(0,30,0,30), UDim2.new(0,450,0,450), 1
    local VPClick = Instance.new("TextButton", VP)
    VPClick.Size, VPClick.BackgroundTransparency, VPClick.Text = UDim2.new(1,0,1,0), 1, ""

    local WM = Instance.new("WorldModel", VP)
    local Cam = Instance.new("Camera", VP)
    VP.CurrentCamera = Cam

    -- [[ HIGHLIGHT SYSTEM ]]
    local Highlight = Instance.new("SelectionBox", WM)
    Highlight.Color3 = MainColor
    Highlight.LineThickness = 0.02 -- ไฮไลท์บางๆ
    Highlight.SurfaceTransparency = 0.8 -- ให้สีที่ผิวจางๆ
    Highlight.SurfaceColor3 = MainColor

    local charModel, hrp
    local isRotating = true -- ตัวแปรควบคุมการหมุน
    local rotAngle = 0

    local function setupMainChar()
        WM:ClearAllChildren()
        charModel = P:CreateHumanoidModelFromUserId(p.UserId)
        charModel.Parent = WM
        Highlight.Parent = WM -- ย้าย Highlight กลับมา
        hrp = charModel:WaitForChild("HumanoidRootPart")
        hrp.Anchored = true
        Cam.CFrame = CFrame.new(Vector3.new(0, 2, -9), hrp.Position + Vector3.new(0, 0.5, 0))
        
        RS.RenderStepped:Connect(function(dt)
            if isRotating and hrp then
                rotAngle = rotAngle + (dt * 35)
                hrp.CFrame = CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(rotAngle), 0)
            end
        end)
    end
    setupMainChar()

    -- [[ 🖼️ RIGHT INFO PANEL ]]
    local InfoPanel = Instance.new("Frame", Cont)
    InfoPanel.Position = UDim2.new(0, 1050, 0, 30)
    InfoPanel.Size = UDim2.new(0, 450, 0, 450)
    InfoPanel.BackgroundColor3, InfoPanel.BackgroundTransparency = Color3.fromRGB(20, 15, 35), 0.3
    Instance.new("UICorner", InfoPanel).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", InfoPanel).Color = MainColor

    local InfoTitle = Instance.new("TextLabel", InfoPanel)
    InfoTitle.Size, InfoTitle.Position, InfoTitle.BackgroundTransparency = UDim2.new(1,-50,0,50), UDim2.new(0,25,0,20), 1
    InfoTitle.TextColor3, InfoTitle.Font, InfoTitle.TextSize = Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 28

    local isPanelOpen = false

    -- ฟังก์ชันโฟกัสและหยุดหมุน
    local function FocusPart(partName)
        local target = charModel:FindFirstChild(partName, true)
        if target and target:IsA("BasePart") then
            isRotating = false -- หยุดหมุน
            Highlight.Adornee = target -- ไฮไลท์ส่วนนั้น
            
            local offsetZ = -4
            if partName == "Head" then offsetZ = -2.5 end
            
            local targetCF = CFrame.new(target.Position + (target.CFrame.LookVector * offsetZ), target.Position)
            TS:Create(Cam, TweenInfo.new(0.7, Enum.EasingStyle.Quart), {CFrame = targetCF}):Play()
        end
    end

    -- ฟังก์ชันรีเซ็ต (เมื่อคลิกที่ตัวละคร)
    local function ResetUI()
        isRotating = true -- กลับมาหมุน
        Highlight.Adornee = nil -- เอาไฮไลท์ออก
        isPanelOpen = false
        TS:Create(InfoPanel, TweenInfo.new(0.5), {Position = UDim2.new(0, 1050, 0, 30)}):Play()
        TS:Create(Cam, TweenInfo.new(0.7), {CFrame = CFrame.new(Vector3.new(0, 2, -9), hrp.Position + Vector3.new(0, 0.5, 0))}):Play()
    end

    VPClick.MouseButton1Click:Connect(ResetUI)

    local function ShowPanel(data)
        InfoTitle.Text = data.Name or ""
        if not isPanelOpen then
            isPanelOpen = true
            TS:Create(InfoPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 520, 0, 30)}):Play()
        end
    end

    -- [[ TAB CONTAINER ]]
    local SlotP = Instance.new("Frame", Cont)
    SlotP.AnchorPoint, SlotP.Position, SlotP.Size = Vector2.new(0.5, 1), UDim2.new(0.5, 0, 1, -25), UDim2.new(0, 900, 0, 90)
    SlotP.BackgroundColor3, SlotP.BackgroundTransparency = Color3.fromRGB(15, 10, 25), 0.6
    Instance.new("UICorner", SlotP).CornerRadius = UDim.new(0, 12)
    Instance.new("UIListLayout", SlotP).FillDirection, SlotP.UIListLayout.HorizontalAlignment, SlotP.UIListLayout.VerticalAlignment, SlotP.UIListLayout.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0, 10)

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