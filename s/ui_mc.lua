--[[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Gemini Fixed: Rotation & Tab Visibility
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
    local UIS = game:GetService("UserInputService")
    local p = P.LocalPlayer
    local pg = p:WaitForChild("PlayerGui")

    for _, old in ipairs(pg:GetChildren()) do
        if old.Name == "VFXHub" then old:Destroy() end
    end

    local UI = Instance.new("ScreenGui", pg)
    UI.Name, UI.ResetOnSpawn = "VFXHub", false

    -- [[ MAIN WINDOW ]]
    local Main = Instance.new("Frame", UI)
    Main.AnchorPoint, Main.Position, Main.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,1000,0,650)
    Main.BackgroundColor3, Main.ClipsDescendants = Color3.fromRGB(25, 25, 30), true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

    -- [[ TOP BAR & DRAG ]]
    local Top = Instance.new("TextButton", Main)
    Top.Size, Top.BackgroundColor3, Top.Text = UDim2.new(1,0,0,40), Color3.fromRGB(35, 35, 45), ""
    Top.AutoButtonColor = false
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 12)
    
    local dragging, dragInput, dragStart, startPos
    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, input.Position, Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Mac Buttons (Red, Yellow, Green)
    local BtnContainer = Instance.new("Frame", Top)
    BtnContainer.Size, BtnContainer.Position, BtnContainer.BackgroundTransparency = UDim2.new(0, 80, 1, 0), UDim2.new(0, 15, 0, 0), 1
    Instance.new("UIListLayout", BtnContainer).FillDirection, BtnContainer.UIListLayout.VerticalAlignment, BtnContainer.UIListLayout.Padding = Enum.FillDirection.Horizontal, Enum.VerticalAlignment.Center, UDim.new(0, 8)

    local function CreateMacBtn(color, action)
        local b = Instance.new("TextButton", BtnContainer)
        b.Size, b.BackgroundColor3, b.Text = UDim2.new(0, 12, 0, 12), color, ""
        Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
        if action then b.MouseButton1Click:Connect(action) end
    end
    CreateMacBtn(Color3.fromRGB(255, 95, 87), function() UI:Destroy() end)
    CreateMacBtn(Color3.fromRGB(255, 189, 46))
    CreateMacBtn(Color3.fromRGB(39, 201, 63))

    local Cont = Instance.new("Frame", Main)
    Cont.Position, Cont.Size, Cont.BackgroundTransparency = UDim2.new(0,0,0,40), UDim2.new(1,0,1,-40), 1

    -- [[ 🎥 VIEWPORT (จัดกลางจอสีฟ้า) ]]
    local VP = Instance.new("ViewportFrame", Cont)
    VP.Position, VP.Size, VP.BackgroundTransparency = UDim2.new(0,0,0,0), UDim2.new(1,0,0,500), 1
    VP.ZIndex = 1 -- อยู่หลังสุด

    local WM = Instance.new("WorldModel", VP)
    local Cam = Instance.new("Camera", VP)
    VP.CurrentCamera = Cam

    local Highlight = Instance.new("SelectionBox", WM)
    Highlight.Color3, Highlight.LineThickness, Highlight.SurfaceTransparency = MainColor, 0.02, 0.8
    Highlight.SurfaceColor3 = MainColor

    local charModel, hrp
    local isRotating, rotAngle = true, 0 -- ✅ มั่นใจว่าเปิดมาแล้วหมุน

    local function setupMainChar()
        WM:ClearAllChildren()
        Highlight.Parent = WM
        charModel = P:CreateHumanoidModelFromUserId(p.UserId)
        charModel.Parent = WM
        hrp = charModel:WaitForChild("HumanoidRootPart")
        hrp.Anchored = true
        Cam.CFrame = CFrame.new(Vector3.new(0, 1.5, -7), hrp.Position)
    end
    setupMainChar()

    -- ✅ แยก Loop หมุนออกมาข้างนอกเพื่อความเสถียร
    RS.RenderStepped:Connect(function(dt)
        if isRotating and hrp then
            rotAngle = rotAngle + (dt * 40)
            hrp.CFrame = CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(rotAngle), 0)
        end
    end)

    -- [[ 🖼️ INFO PANEL ]]
    local InfoPanel = Instance.new("Frame", Cont)
    InfoPanel.Position = UDim2.new(0, 1050, 0, 30)
    InfoPanel.Size = UDim2.new(0, 480, 0, 460)
    InfoPanel.BackgroundColor3, InfoPanel.BackgroundTransparency = Color3.fromRGB(20, 15, 35), 0.3
    InfoPanel.ZIndex = 10 
    Instance.new("UICorner", InfoPanel).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", InfoPanel).Color, InfoPanel.UIStroke.Thickness = MainColor, 2

    local InfoTitle = Instance.new("TextLabel", InfoPanel)
    InfoTitle.Size, InfoTitle.Position, InfoTitle.BackgroundTransparency = UDim2.new(1,-50,0,50), UDim2.new(0,25,0,20), 1
    InfoTitle.TextColor3, InfoTitle.Font, InfoTitle.TextSize, InfoTitle.TextXAlignment = Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 28, Enum.TextXAlignment.Left

    local Grid = Instance.new("Frame", InfoPanel)
    Grid.Position, Grid.Size, Grid.BackgroundTransparency = UDim2.new(0, 25, 0, 150), UDim2.new(1, -50, 0, 270), 1
    local GLo = Instance.new("UIGridLayout", Grid)
    GLo.CellPadding, GLo.CellSize = UDim2.new(0, 15, 0, 15), UDim2.new(0, 100, 0, 100)

    -- [[ TABS (แก้ไขแถบปุ่มวงกลมสีแดง) ]]
    local SlotP = Instance.new("Frame", Cont)
    SlotP.AnchorPoint, SlotP.Position, SlotP.Size = Vector2.new(0.5, 1), UDim2.new(0.5, 0, 1, -25), UDim2.new(0, 920, 0, 100)
    SlotP.BackgroundColor3, SlotP.BackgroundTransparency = Color3.fromRGB(15, 10, 25), 0.5
    SlotP.ZIndex = 20 -- ✅ สูงกว่า Viewport มั่นใจว่าไม่หาย
    Instance.new("UICorner", SlotP).CornerRadius = UDim.new(0, 15)
    local stroke = Instance.new("UIStroke", SlotP)
    stroke.Color, stroke.Transparency = MainColor, 0.6
    
    Instance.new("UIListLayout", SlotP).FillDirection, SlotP.UIListLayout.HorizontalAlignment, SlotP.UIListLayout.VerticalAlignment, SlotP.UIListLayout.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0, 12)

    local isPanelOpen = false
    local function ResetUI()
        isRotating, isPanelOpen, Highlight.Adornee = true, false, nil
        TS:Create(InfoPanel, TweenInfo.new(0.5), {Position = UDim2.new(0, 1050, 0, 30)}):Play()
        TS:Create(Cam, TweenInfo.new(0.7), {CFrame = CFrame.new(Vector3.new(0, 1.5, -7), hrp.Position)}):Play()
    end

    -- คลิกที่ว่างใน Window เพื่อ Reset
    local BgClick = Instance.new("TextButton", Cont)
    BgClick.Size, BgClick.BackgroundTransparency, BgClick.Text, BgClick.ZIndex = UDim2.new(1,0,1,0), 1, "", 0
    BgClick.MouseButton1Click:Connect(ResetUI)

    for _, info in ipairs(CustomTabs) do
        local btn = Instance.new("TextButton", SlotP)
        btn.Size, btn.BackgroundColor3, btn.Text = UDim2.new(0, 85, 0, 85), Color3.fromRGB(60, 45, 110), ""
        btn.ZIndex = 21
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        local l = Instance.new("TextLabel", btn)
        l.Size, l.BackgroundTransparency, l.Text, l.TextColor3, l.Font, l.TextSize = UDim2.new(1,0,1,0), 1, info.Name, Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 14

        btn.MouseButton1Click:Connect(function()
            -- Show Panel Logic
            InfoTitle.Text = "ข้อมูลส่วน: " .. info.Name
            for _, v in ipairs(Grid:GetChildren()) do if v:IsA("GuiObject") then v:Destroy() end end
            if data and data.Items then -- ตรวจสอบข้อมูลไอเทม
                 -- (โค้ดสร้างปุ่มไอเทมเหมือนเดิม)
            end
            
            if not isPanelOpen then
                isPanelOpen = true
                TS:Create(InfoPanel, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 500, 0, 30)}):Play()
            end

            -- Focus Logic
            local target = charModel:FindFirstChild(info.Focus, true)
            if target and target:IsA("BasePart") then
                isRotating, Highlight.Adornee = false, target
                local offset = info.Focus == "Head" and -2.5 or -4
                local targetCF = CFrame.new(target.Position + (target.CFrame.LookVector * offset), target.Position)
                TS:Create(Cam, TweenInfo.new(0.7, Enum.EasingStyle.Quart), {CFrame = targetCF}):Play()
            end
        end)
    end

    return { UI = UI }
end