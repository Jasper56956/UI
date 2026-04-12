--[[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Created by: L Ua all (Panel Animation Version)
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
    Main.AnchorPoint, Main.Position, Main.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,850,0,500)
    Main.BackgroundColor3, Main.ClipsDescendants = Color3.fromRGB(30, 30, 30), true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    -- [[ TOP BAR ]]
    local Top = Instance.new("Frame", Main)
    Top.Size, Top.BackgroundColor3 = UDim2.new(1,0,0,35), Color3.fromRGB(220, 220, 220)
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 10)

    local Lbl = Instance.new("TextLabel", Top)
    Lbl.AnchorPoint, Lbl.Position, Lbl.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,200,1,0)
    Lbl.BackgroundTransparency, Lbl.TextColor3, Lbl.Text = 1, Color3.fromRGB(50,50,50), TitleText
    Lbl.Font, Lbl.TextSize = Enum.Font.GothamMedium, 16

    local Cont = Instance.new("Frame", Main)
    Cont.Position, Cont.Size, Cont.BackgroundColor3 = UDim2.new(0,0,0,35), UDim2.new(1,0,1,-35), Color3.fromRGB(40,30,55)

    -- [[ VIEWPORT (3D Character) ]]
    local VP = Instance.new("ViewportFrame", Cont)
    VP.Position, VP.Size, VP.BackgroundTransparency = UDim2.new(0,20,0,20), UDim2.new(0,350,0,350), 1
    local WM = Instance.new("WorldModel", VP)
    local Cam = Instance.new("Camera", VP)
    VP.CurrentCamera = Cam

    local function setupMainChar()
        WM:ClearAllChildren()
        local charModel = P:CreateHumanoidModelFromUserId(p.UserId)
        charModel.Parent = WM
        local hrp = charModel:WaitForChild("HumanoidRootPart")
        hrp.Anchored = true
        Cam.CFrame = CFrame.new(Vector3.new(0, 2, -8), hrp.Position + Vector3.new(0, 0.5, 0))
        local rot = 0
        RS.RenderStepped:Connect(function(dt)
            rot = rot + (dt * 45)
            if hrp then hrp.CFrame = CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(rot), 0) end
        end)
    end
    setupMainChar()

    -- [[ 🖼️ RIGHT INFO PANEL (เริ่มต้นจะซ่อนอยู่) ]]
    local InfoPanel = Instance.new("Frame", Cont)
    InfoPanel.Position = UDim2.new(0, 450, 0, 20) -- ตำแหน่งเริ่มต้น
    InfoPanel.Size = UDim2.new(0, 380, 0, 350)
    InfoPanel.BackgroundColor3, InfoPanel.BackgroundTransparency = Color3.fromRGB(20, 15, 35), 1 -- เริ่มที่โปร่งใส
    InfoPanel.ClipsDescendants = true
    Instance.new("UICorner", InfoPanel).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", InfoPanel)
    stroke.Color, stroke.Thickness, stroke.Transparency = MainColor, 1.5, 1 -- เริ่มที่โปร่งใส

    local InfoTitle = Instance.new("TextLabel", InfoPanel)
    InfoTitle.Size, InfoTitle.Position = UDim2.new(1, -40, 0, 40), UDim2.new(0, 20, 0, 15)
    InfoTitle.BackgroundTransparency, InfoTitle.TextColor3, InfoTitle.TextTransparency = 1, Color3.fromRGB(255, 255, 255), 1
    InfoTitle.Font, InfoTitle.TextSize, InfoTitle.TextXAlignment = Enum.Font.GothamBold, 24, Enum.TextXAlignment.Left

    local InfoDesc = Instance.new("TextLabel", InfoPanel)
    InfoDesc.Size, InfoDesc.Position = UDim2.new(1, -40, 0, 60), UDim2.new(0, 20, 0, 60)
    InfoDesc.BackgroundTransparency, InfoDesc.TextColor3, InfoDesc.TextTransparency = 1, Color3.fromRGB(200, 200, 200), 1
    InfoDesc.Font, InfoDesc.TextSize, InfoDesc.TextXAlignment, InfoDesc.TextWrapped = Enum.Font.Gotham, 14, Enum.TextXAlignment.Left, true

    local Grid = Instance.new("Frame", InfoPanel)
    Grid.Position, Grid.Size, Grid.BackgroundTransparency = UDim2.new(0, 20, 0, 130), UDim2.new(1, -40, 0, 150), 1
    local GLo = Instance.new("UIGridLayout", Grid)
    GLo.CellPadding, GLo.CellSize = UDim2.new(0, 10, 0, 10), UDim2.new(0, 80, 0, 80)

    -- [[ ฟังก์ชันอนิเมชั่นแสดง Panel ]]
    local isPanelOpen = false
    local function ShowPanel(data)
        InfoTitle.Text = data.Name or ""
        InfoDesc.Text = data.Description or ""
        
        for _, v in ipairs(Grid:GetChildren()) do if v:IsA("GuiObject") then v:Destroy() end end
        if data.Items then
            for _, item in ipairs(data.Items) do
                local iBtn = Instance.new("ImageButton", Grid)
                iBtn.BackgroundColor3, iBtn.BorderSizePixel = Color3.fromRGB(45, 35, 70), 0
                iBtn.Image = item.Image or ""
                Instance.new("UICorner", iBtn).CornerRadius = UDim.new(0, 8)
                iBtn.MouseButton1Click:Connect(function() if item.Callback then item.Callback() end end)
            end
        end

        if not isPanelOpen then
            isPanelOpen = true
            -- Tween การปรากฏตัว
            TS:Create(InfoPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back), {BackgroundTransparency = 0.3, Position = UDim2.new(0, 420, 0, 20)}):Play()
            TS:Create(stroke, TweenInfo.new(0.5), {Transparency = 0.5}):Play()
            TS:Create(InfoTitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            TS:Create(InfoDesc, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
        end
    end

    -- [[ TAB CONTAINER ]]
    local SlotP = Instance.new("Frame", Cont)
    SlotP.AnchorPoint, SlotP.Position, SlotP.Size = Vector2.new(0.5, 1), UDim2.new(0.5, 0, 1, -20), UDim2.new(0, 700, 0, 80)
    SlotP.BackgroundColor3, SlotP.BackgroundTransparency = Color3.fromRGB(15, 10, 25), 0.6
    Instance.new("UICorner", SlotP).CornerRadius = UDim.new(0, 10)
    local layout = Instance.new("UIListLayout", SlotP)
    layout.FillDirection, layout.HorizontalAlignment, layout.VerticalAlignment, layout.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0, 12)

    for _, info in ipairs(CustomTabs) do
        local btn = Instance.new("TextButton", SlotP)
        btn.Size, btn.BackgroundColor3, btn.Text = UDim2.new(0, 65, 0, 65), Color3.fromRGB(60, 40, 100), ""
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        
        local l = Instance.new("TextLabel", btn)
        l.Size, l.BackgroundTransparency, l.Text = UDim2.new(1, 0, 1, 0), 1, ForceString(info.Name)
        l.TextColor3, l.Font, l.TextSize, l.TextScaled = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 11, true

        btn.MouseButton1Click:Connect(function()
            ShowPanel(info) -- เมื่อกดปุ่ม ให้เรียกฟังก์ชันแสดงผล Panel
            if info.Callback then info.Callback() end
        end)
    end

    return { UI = UI }
end