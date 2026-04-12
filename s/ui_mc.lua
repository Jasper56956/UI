--[[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Created by: L Ua all (Library Version)
]]

return function(Config)
    -- [[ CONFIGURATION DEFAULTS ]]
    Config = Config or {}
    local TitleText = Config.Title or "Hub"
    local MainColor = Config.MainColor or Color3.fromRGB(160, 80, 255)
    local HighlightColor = Config.HighlightColor or Color3.fromRGB(100, 255, 255)
    local ToggleKey = Config.ToggleKey or Enum.KeyCode.RightControl
    local VFXName = Config.VFXName or "Shadow Weaver"
    
    -- [[ SERVICES ]]
    local P = game:GetService("Players")
    local TS = game:GetService("TweenService")
    local RS = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")

    local p = P.LocalPlayer
    local pg = p:WaitForChild("PlayerGui")

    if pg:FindFirstChild("VFXHub") then pg.VFXHub:Destroy() end

    local ti = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

    -- Colors from Config/Original
    local C_BASE = MainColor
    local C_HL = HighlightColor
    local C_ON = Config.ButtonColor or Color3.fromRGB(100, 70, 150)
    local C_HOV = Config.HoverColor or Color3.fromRGB(150, 120, 200)

    -- [[ UI SETUP ]]
    local UI = Instance.new("ScreenGui", pg)
    UI.Name, UI.ResetOnSpawn = "VFXHub", false

    local Main = Instance.new("Frame", UI)
    Main.AnchorPoint, Main.Position, Main.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,800,0,500)
    Main.BackgroundColor3, Main.ClipsDescendants = Color3.fromRGB(30, 30, 30), true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    local MainScale = Instance.new("UIScale", Main)
    MainScale.Scale = 1

    local Top = Instance.new("Frame", Main)
    Top.Size, Top.BackgroundColor3 = UDim2.new(1,0,0,35), Color3.fromRGB(220, 220, 220)
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

    local TClip = Instance.new("Frame", Top)
    TClip.AnchorPoint, TClip.Position, TClip.Size = Vector2.new(0,1), UDim2.new(0,0,1,0), UDim2.new(1,0,0,10)
    TClip.BackgroundColor3, TClip.BorderSizePixel = Top.BackgroundColor3, 0

    local Lbl = Instance.new("TextLabel", Top)
    Lbl.AnchorPoint, Lbl.Position, Lbl.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,100,1,-10)
    Lbl.BackgroundTransparency, Lbl.Text, Lbl.TextColor3 = 1, TitleText, Color3.fromRGB(50,50,50)
    Lbl.Font, Lbl.TextSize = Enum.Font.GothamMedium, 16

    -- [[ MAC BUTTONS ]]
    local uiOpen = true
    local MacP = Instance.new("Frame", Top)
    MacP.BackgroundTransparency, MacP.Position, MacP.AnchorPoint, MacP.Size = 1, UDim2.new(0,15,0.5,0), Vector2.new(0,0.5), UDim2.new(0,60,1,0)
    local MLo = Instance.new("UIListLayout", MacP)
    MLo.FillDirection, MLo.VerticalAlignment, MLo.Padding = Enum.FillDirection.Horizontal, Enum.VerticalAlignment.Center, UDim.new(0,8)

    local function mkMac(c)
        local b = Instance.new("TextButton", MacP)
        b.Size, b.BackgroundColor3, b.Text, b.AutoButtonColor = UDim2.new(0,14,0,14), c, "", false
        Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
        return b
    end
    local mClose = mkMac(Color3.fromRGB(255, 95, 86))
    local mMin = mkMac(Color3.fromRGB(255, 189, 46)) 
    local mMax = mkMac(Color3.fromRGB(39, 201, 63))  

    local function toggleUI()
        uiOpen = not uiOpen
        if uiOpen then
            Main.Visible = true
            TS:Create(MainScale, ti, {Scale = 1}):Play()
        else
            local tw = TS:Create(MainScale, ti, {Scale = 0})
            tw:Play()
            tw.Completed:Connect(function() if not uiOpen then Main.Visible = false end end)
        end
    end
    mClose.MouseButton1Click:Connect(toggleUI)
    UIS.InputBegan:Connect(function(inp, gpe) if not gpe and inp.KeyCode == ToggleKey then toggleUI() end end)

    -- [[ DRAG LOGIC ]]
    local dragToggle, dragInput, dragStart, startPos
    Top.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragToggle, dragStart, startPos = true, inp.Position, Main.Position
            inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
        end
    end)
    Top.InputChanged:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end end)
    UIS.InputChanged:Connect(function(inp)
        if inp == dragInput and dragToggle then
            local delta = inp.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- [[ CONTENT ]]
    local Cont = Instance.new("Frame", Main)
    Cont.Position, Cont.Size, Cont.BackgroundColor3, Cont.ClipsDescendants = UDim2.new(0,0,0,35), UDim2.new(1,0,1,-35), Color3.fromRGB(45,30,60), true
    local Grid = Instance.new("ImageLabel", Cont)
    Grid.Size, Grid.BackgroundTransparency, Grid.Image, Grid.ImageColor3, Grid.ImageTransparency = UDim2.new(1,0,1,0), 1, "rbxassetid://277037193", MainColor, 0.8
    Grid.ScaleType, Grid.TileSize = Enum.ScaleType.Tile, UDim2.new(0,50,0,50)

    -- [[ VIEWPORT ]]
    local VP = Instance.new("ViewportFrame", Cont)
    VP.AnchorPoint, VP.Position, VP.Size, VP.BackgroundTransparency = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.45,0), UDim2.new(0,300,0,400), 1
    VP.Ambient, VP.LightColor = MainColor, MainColor
    local HBox = Instance.new("TextButton", Cont)
    HBox.AnchorPoint, HBox.Position, HBox.Size, HBox.BackgroundTransparency, HBox.Text, HBox.ZIndex = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.45,0), UDim2.new(0,200,0,320), 1, "", 5
    local WM = Instance.new("WorldModel", VP)
    local Cam = Instance.new("Camera", VP)
    VP.CurrentCamera = Cam

    -- [[ RIGHT PANEL ]]
    local RPane = Instance.new("Frame", Cont)
    RPane.AnchorPoint, RPane.Position, RPane.Size = Vector2.new(1,0.5), UDim2.new(1.5, 0, 0.45, 0), UDim2.new(0, 420, 0, 320)
    RPane.BackgroundColor3, RPane.BackgroundTransparency = Color3.fromRGB(25, 15, 40), 0.2
    Instance.new("UICorner", RPane).CornerRadius = UDim.new(0, 8)
    local RStrk = Instance.new("UIStroke", RPane)
    RStrk.Color, RStrk.Transparency, RStrk.Thickness = MainColor, 0.5, 1.5

    local RTit = Instance.new("TextLabel", RPane)
    RTit.Size, RTit.Position, RTit.BackgroundTransparency = UDim2.new(1,-40,0,40), UDim2.new(0,20,0,15), 1
    RTit.Text, RTit.TextColor3, RTit.Font, RTit.TextSize = "SYSTEM INFO", Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 22
    RTit.TextXAlignment = Enum.TextXAlignment.Left

    local BoxContainer = Instance.new("Frame", RPane)
    BoxContainer.Size, BoxContainer.Position, BoxContainer.BackgroundTransparency = UDim2.new(1, -40, 0, 100), UDim2.new(0, 20, 0, 80), 1
    Instance.new("UIListLayout", BoxContainer).FillDirection, BoxContainer.UIListLayout.Padding, BoxContainer.UIListLayout.HorizontalAlignment = Enum.FillDirection.Horizontal, UDim.new(0, 20), Enum.HorizontalAlignment.Center

    for i = 1, 4 do
        local slot = Instance.new("Frame", BoxContainer)
        slot.Size = UDim2.new(0, 80, 0, 90)
        slot.BackgroundColor3, slot.BackgroundTransparency = Color3.fromRGB(35, 20, 50), 0.5
        Instance.new("UICorner", slot).CornerRadius = UDim.new(0, 6)
        local slotStrk = Instance.new("UIStroke", slot)
        slotStrk.Color, slotStrk.Transparency, slotStrk.Thickness = MainColor, 0.3, 2 
    end

    -- [[ LOGIC: CHAR & HIGHLIGHT ]]
    local ptsCfg = {
        {n="หัว", t={"Head"}}, {n="ตัว", t={"Torso","UpperTorso","LowerTorso"}},
        {n="แขนซ้าย", t={"Left Arm","LeftUpperArm","LeftLowerArm","LeftHand"}},
        {n="แขนขวา", t={"Right Arm","RightUpperArm","RightLowerArm","RightHand"}},
        {n="ขาซ้าย", t={"Left Leg","LeftUpperLeg","LeftLowerLeg","LeftFoot"}},
        {n="ขาขวา", t={"Right Leg","RightUpperLeg","RightLowerLeg","RightFoot"}},
        {n="หลัง", t={"Torso","UpperTorso","LowerTorso"}}
    }

    local BASE_CF = CFrame.new(Vector3.new(0, 0.5, -6.5), Vector3.new(0, 0.5, 0))
    local isIdle, rotAngle, Y_OFF, isPanelOpen = true, 0, 0.5, false

    local function getPts(idx)
        local lst, char = {}, WM:FindFirstChild(p.Name)
        if not char then return lst end
        for _, pn in ipairs(ptsCfg[idx].t) do
            local pt = char:FindFirstChild(pn)
            if pt and pt:IsA("BasePart") then table.insert(lst, pt) end
        end
        return lst
    end

    local function setupChar()
        local function cloneC(c)
            c.Archivable = true
            local cl = c:Clone()
            cl.Parent = WM
            local hrp = cl:WaitForChild("HumanoidRootPart")
            hrp.Anchored, hrp.CFrame, Cam.CFrame = true, CFrame.new(0, Y_OFF, 0), BASE_CF
            for _, pt in ipairs(cl:GetDescendants()) do
                if pt:IsA("BasePart") and pt.Name ~= "HumanoidRootPart" then
                    pt.Color, pt.Material, pt.Transparency = C_BASE, Enum.Material.ForceField, 0
                elseif pt:IsA("Shirt") or pt:IsA("Pants") or pt:IsA("Decal") then pt:Destroy() end
            end
        end
        p.CharacterAdded:Connect(cloneC)
        if p.Character then cloneC(p.Character) end
    end
    setupChar()

    RS.RenderStepped:Connect(function(dt)
        if isIdle then
            local char = WM:FindFirstChild(p.Name)
            if char and char:FindFirstChild("HumanoidRootPart") then
                rotAngle = rotAngle + math.rad(30 * dt) 
                char.HumanoidRootPart.CFrame = CFrame.new(0, Y_OFF, 0) * CFrame.Angles(0, rotAngle, 0)
            end
        end
    end)

    -- [[ HOVER INFO ]]
    local Info = Instance.new("Frame", Cont)
    Info.AnchorPoint, Info.Position, Info.Size, Info.BackgroundColor3, Info.BackgroundTransparency, Info.Visible = Vector2.new(1,0.5), UDim2.new(1,-20,0.45,0), UDim2.new(0,300,0,150), Color3.fromRGB(20,10,30), 1, false
    Instance.new("UICorner", Info).CornerRadius = UDim.new(0,4)
    local IStrk = Instance.new("UIStroke", Info)
    IStrk.Color, IStrk.Transparency = MainColor, 1
    local ITit = Instance.new("TextLabel", Info)
    ITit.Size, ITit.Position, ITit.BackgroundTransparency, ITit.Text, ITit.TextColor3, ITit.Font, ITit.TextSize, ITit.TextTransparency, ITit.TextXAlignment = UDim2.new(1,0,0,30), UDim2.new(0,10,0,5), 1, "CHAR: "..p.Name:upper(), Color3.fromRGB(230,230,255), Enum.Font.GothamBold, 14, 1, Enum.TextXAlignment.Left
    local IVFX = Instance.new("TextLabel", Info)
    IVFX.Size, IVFX.Position, IVFX.BackgroundTransparency, IVFX.Text, IVFX.TextColor3, IVFX.Font, IVFX.TextSize, IVFX.TextTransparency, IVFX.TextXAlignment, IVFX.TextYAlignment = UDim2.new(1,-20,0,60), UDim2.new(0,10,0,35), 1, "VFX: "..VFXName.."\n* Click character to Zoom Out *", Color3.fromRGB(180,150,255), Enum.Font.Gotham, 12, 1, Enum.TextXAlignment.Left, Enum.TextYAlignment.Top

    -- [[ BUTTONS PANEL ]]
    local SlotP = Instance.new("Frame", Cont)
    SlotP.AnchorPoint, SlotP.Position, SlotP.Size, SlotP.BackgroundColor3, SlotP.BackgroundTransparency = Vector2.new(0.5,1), UDim2.new(0.5,0,1,-20), UDim2.new(0,450,0,70), Color3.fromRGB(25,15,40), 0.4
    Instance.new("UICorner", SlotP).CornerRadius = UDim.new(0,6)
    local SStrk = Instance.new("UIStroke", SlotP)
    SStrk.Color, SStrk.Transparency = MainColor, 0.6
    local LLo = Instance.new("UIListLayout", SlotP)
    LLo.FillDirection, LLo.Padding, LLo.HorizontalAlignment, LLo.VerticalAlignment = Enum.FillDirection.Horizontal, UDim.new(0,8), Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center

    for i = 1, 7 do
        local btn = Instance.new("TextButton", SlotP)
        btn.Size, btn.BackgroundColor3, btn.Text, btn.AutoButtonColor = UDim2.new(0,50,0,50), C_ON, "", false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
        local lbl = Instance.new("TextLabel", btn)
        lbl.Size, lbl.BackgroundTransparency, lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize = UDim2.new(1,0,1,0), 1, ptsCfg[i].n, Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 10
        
        btn.MouseEnter:Connect(function()
            TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C_HOV}):Play()
            for _, pt in ipairs(getPts(i)) do TS:Create(pt, TweenInfo.new(0.2), {Color = C_HL}):Play() end
        end)
        btn.MouseLeave:Connect(function()
            TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C_ON}):Play()
            for _, pt in ipairs(getPts(i)) do TS:Create(pt, TweenInfo.new(0.2), {Color = C_BASE}):Play() end
        end)
        btn.MouseButton1Click:Connect(function()
            isIdle, isPanelOpen = false, true
            RTit.Text = "ข้อมูลส่วน: " .. ptsCfg[i].n
            TS:Create(VP, ti, {Position = UDim2.new(0.25, 0, 0.45, 0)}):Play()
            TS:Create(HBox, ti, {Position = UDim2.new(0.25, 0, 0.45, 0)}):Play()
            TS:Create(RPane, ti, {Position = UDim2.new(0.97, 0, 0.45, 0)}):Play()
            Info.Visible = false
            local char = WM:FindFirstChild(p.Name)
            if not char then return end
            local hrp = char.HumanoidRootPart
            local tAng = (i == 7) and math.rad(180) or 0
            rotAngle = tAng
            TS:Create(hrp, ti, {CFrame = CFrame.new(0, Y_OFF, 0) * CFrame.Angles(0, tAng, 0)}):Play()
            local fp
            if i==1 then fp=char:FindFirstChild("Head") elseif i==2 or i==7 then fp=char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") elseif i==3 then fp=char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") elseif i==4 then fp=char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") elseif i==5 then fp=char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") elseif i==6 then fp=char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") end
            if fp then
                local off = hrp.CFrame:ToObjectSpace(fp.CFrame).Position
                local tFoc = (CFrame.new(0, Y_OFF, 0) * CFrame.Angles(0, tAng, 0)) * off
                local zD = (i==1) and 2 or (i==2 or i==7) and 3.5 or 3
                TS:Create(Cam, ti, {CFrame = CFrame.new(tFoc + Vector3.new(0,0,-zD), tFoc)}):Play()
            end
        end)
    end

    HBox.MouseEnter:Connect(function()
        if not isPanelOpen then
            Info.Visible = true 
            TS:Create(Info, ti, {BackgroundTransparency=0.3}):Play()
            TS:Create(IStrk, ti, {Transparency=0.5}):Play()
            TS:Create(ITit, ti, {TextTransparency=0}):Play()
            TS:Create(IVFX, ti, {TextTransparency=0}):Play()
        end
        for _, pt in ipairs(WM:GetDescendants()) do if pt:IsA("BasePart") then TS:Create(pt, TweenInfo.new(0.2), {Color = C_HL}):Play() end end
    end)
    HBox.MouseLeave:Connect(function()
        if not isPanelOpen then
            TS:Create(Info, ti, {BackgroundTransparency=1}):Play()
            TS:Create(IStrk, ti, {Transparency=1}):Play()
            TS:Create(ITit, ti, {TextTransparency=1}):Play()
            TS:Create(IVFX, ti, {TextTransparency=1}):Play()
            task.delay(0.5, function() if Info.BackgroundTransparency==1 then Info.Visible=false end end)
        end
        for _, pt in ipairs(WM:GetDescendants()) do if pt:IsA("BasePart") then TS:Create(pt, TweenInfo.new(0.2), {Color = C_BASE}):Play() end end
    end)
    HBox.MouseButton1Click:Connect(function()
        isPanelOpen = false
        TS:Create(VP, ti, {Position = UDim2.new(0.5, 0, 0.45, 0)}):Play()
        TS:Create(HBox, ti, {Position = UDim2.new(0.5, 0, 0.45, 0)}):Play()
        TS:Create(RPane, ti, {Position = UDim2.new(1.5, 0, 0.45, 0)}):Play()
        TS:Create(Cam, ti, {CFrame = BASE_CF}):Play()
        local char = WM:FindFirstChild(p.Name)
        if char then TS:Create(char.HumanoidRootPart, ti, {CFrame = CFrame.new(0, Y_OFF, 0)}):Play() end
        task.delay(0.4, function() rotAngle, isIdle = 0, true end)
    end)
    
    return UI
end