--[=[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Created by: L Ua all
    Modified to Library: Gemini
]=]

local P = game:GetService("Players")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

return function(Config)
    Config = Config or {}

    -- [[ ⚙️ CONFIGURATION VARIABLES ]]
    local UI_TITLE = Config.Title or "Hub"
    local C_BASE = Config.BaseColor or Color3.fromRGB(160, 80, 255)     
    local C_HL = Config.HighlightColor or Color3.fromRGB(100, 255, 255) 
    local C_ON = Config.ButtonColor or Color3.fromRGB(100, 70, 150)
    local C_HOV = Config.HoverColor or Color3.fromRGB(150, 120, 200)
    local BG_IMAGE = Config.BackgroundImage or "rbxassetid://277037193"
    
    local TOGGLE_KEY = Config.ToggleKey or Enum.KeyCode.RightControl
    local INFO_TITLE = Config.InfoTitle or "SYSTEM INFO"
    local VFX_TEXT = Config.HoverText or "VFX: Shadow Weaver\n* Click character to Zoom Out *"
    
    local CUSTOM_BOXES = Config.Boxes or { {}, {}, {}, {} } -- ค่าเริ่มต้นสร้าง 4 กล่อง
    
    -- ตั้งค่าแท็บเริ่มต้นถ้าไม่ได้ระบุมา (รองรับการตั้งค่ามุมกล้องและระยะซูมในแต่ละส่วน)
    local TABS = Config.Tabs or {
        {n="หัว", t={"Head"}, angle=0, zoom=2}, 
        {n="ตัว", t={"Torso","UpperTorso","LowerTorso"}, angle=0, zoom=3.5},
        {n="แขนซ้าย", t={"Left Arm","LeftUpperArm","LeftLowerArm","LeftHand"}, angle=0, zoom=3},
        {n="แขนขวา", t={"Right Arm","RightUpperArm","RightLowerArm","RightHand"}, angle=0, zoom=3},
        {n="ขาซ้าย", t={"Left Leg","LeftUpperLeg","LeftLowerLeg","LeftFoot"}, angle=0, zoom=3},
        {n="ขาขวา", t={"Right Leg","RightUpperLeg","RightLowerLeg","RightFoot"}, angle=0, zoom=3},
        {n="หลัง", t={"Torso","UpperTorso","LowerTorso"}, angle=180, zoom=3.5}
    }

    local p = P.LocalPlayer
    local pg = p:WaitForChild("PlayerGui")

    if pg:FindFirstChild("VFXHub") then pg.VFXHub:Destroy() end

    local ti = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

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
    Lbl.BackgroundTransparency, Lbl.Text, Lbl.TextColor3, Lbl.Font, Lbl.TextSize = 1, UI_TITLE, Color3.fromRGB(50,50,50), Enum.Font.GothamMedium, 16

    -- [[ MAC BUTTONS & TOGGLE LOGIC ]]
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
    UIS.InputBegan:Connect(function(inp, gpe)
        if not gpe and inp.KeyCode == TOGGLE_KEY then toggleUI() end
    end)

    -- [[ DRAG GUI LOGIC ]]
    local dragToggle, dragInput, dragStart, startPos
    Top.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = inp.Position
            startPos = Main.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragToggle = false end
            end)
        end
    end)
    Top.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end
    end)
    UIS.InputChanged:Connect(function(inp)
        if inp == dragInput and dragToggle then
            local delta = inp.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Cont = Instance.new("Frame", Main)
    Cont.Position, Cont.Size, Cont.BackgroundColor3, Cont.ClipsDescendants = UDim2.new(0,0,0,35), UDim2.new(1,0,1,-35), Color3.fromRGB(45,30,60), true

    local Grid = Instance.new("ImageLabel", Cont)
    Grid.Size, Grid.BackgroundTransparency, Grid.Image, Grid.ImageColor3, Grid.ImageTransparency = UDim2.new(1,0,1,0), 1, BG_IMAGE, Color3.fromRGB(200,100,255), 0.8
    Grid.ScaleType, Grid.TileSize = Enum.ScaleType.Tile, UDim2.new(0,50,0,50)

    -- Viewport & Hitbox
    local VP = Instance.new("ViewportFrame", Cont)
    VP.AnchorPoint, VP.Position, VP.Size, VP.BackgroundTransparency = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.45,0), UDim2.new(0,300,0,400), 1
    VP.Ambient, VP.LightColor = Color3.fromRGB(150,100,255), Color3.fromRGB(200,150,255)

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
    RStrk.Color, RStrk.Transparency, RStrk.Thickness = C_BASE, 0.5, 1.5

    local RTit = Instance.new("TextLabel", RPane)
    RTit.Size, RTit.Position, RTit.BackgroundTransparency = UDim2.new(1,-40,0,40), UDim2.new(0,20,0,15), 1
    RTit.Text, RTit.TextColor3, RTit.Font, RTit.TextSize = INFO_TITLE, Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 22
    RTit.TextXAlignment = Enum.TextXAlignment.Left

    -- Dynamic Custom Boxes
    local BoxContainer = Instance.new("Frame", RPane)
    BoxContainer.Size, BoxContainer.Position, BoxContainer.BackgroundTransparency = UDim2.new(1, -40, 0, 100), UDim2.new(0, 20, 0, 80), 1

    local BoxListLayout = Instance.new("UIListLayout", BoxContainer)
    BoxListLayout.FillDirection = Enum.FillDirection.Horizontal
    BoxListLayout.Padding = UDim.new(0, 20)
    BoxListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    BoxListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    for _, boxData in ipairs(CUSTOM_BOXES) do
        local slot = Instance.new("Frame", BoxContainer)
        slot.Size = UDim2.new(0, 80, 0, 90)
        slot.BackgroundColor3 = Color3.fromRGB(35, 20, 50) 
        slot.BackgroundTransparency = 0.5
        Instance.new("UICorner", slot).CornerRadius = UDim.new(0, 6)

        local slotStrk = Instance.new("UIStroke", slot)
        slotStrk.Color, slotStrk.Transparency, slotStrk.Thickness = C_HL, 0.3, 2 
        
        -- รองรับการสร้างเนื้อหาในกล่อง (Image หรือปุ่ม)
        if boxData.Image then
            local img = Instance.new("ImageButton", slot)
            img.Size, img.BackgroundTransparency = UDim2.new(1, -10, 1, -10), 1
            img.Position, img.AnchorPoint = UDim2.new(0.5, 0, 0.5, 0), Vector2.new(0.5, 0.5)
            img.Image = boxData.Image
            if boxData.Callback then
                img.MouseButton1Click:Connect(boxData.Callback)
            end
        end
    end

    -- [[ Character Logic & Highlight Config ]]
    local BASE_CF = CFrame.new(Vector3.new(0, 0.5, -6.5), Vector3.new(0, 0.5, 0))
    local isIdle, rotAngle, Y_OFF, isPanelOpen = true, 0, 0.5, false

    local function getPts(tabData)
        local lst, char = {}, WM:FindFirstChild(p.Name)
        if not char then return lst end
        if tabData.isAcc then
            for _, a in ipairs(char:GetChildren()) do
                if a:IsA("Accessory") and a:FindFirstChild("Handle") then table.insert(lst, a.Handle) end
            end
        else
            for _, pn in ipairs(tabData.t) do
                local pt = char:FindFirstChild(pn)
                if pt and pt:IsA("BasePart") then table.insert(lst, pt) end
            end
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
                elseif pt:IsA("Shirt") or pt:IsA("Pants") or pt:IsA("Decal") then
                    pt:Destroy()
                end
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

    -- Hover Info Panel 
    local Info = Instance.new("Frame", Cont)
    Info.AnchorPoint, Info.Position, Info.Size, Info.BackgroundColor3, Info.BackgroundTransparency, Info.Visible = Vector2.new(1,0.5), UDim2.new(1,-20,0.45,0), UDim2.new(0,300,0,150), Color3.fromRGB(20,10,30), 1, false
    Instance.new("UICorner", Info).CornerRadius = UDim.new(0,4)
    local IStrk = Instance.new("UIStroke", Info)
    IStrk.Color, IStrk.Transparency = C_BASE, 1

    local ITit = Instance.new("TextLabel", Info)
    ITit.Size, ITit.Position, ITit.BackgroundTransparency, ITit.Text, ITit.TextColor3, ITit.Font, ITit.TextSize, ITit.TextTransparency, ITit.TextXAlignment = UDim2.new(1,0,0,30), UDim2.new(0,10,0,5), 1, "CHAR: "..p.Name:upper(), Color3.fromRGB(230,230,255), Enum.Font.GothamBold, 14, 1, Enum.TextXAlignment.Left

    local IVFX = Instance.new("TextLabel", Info)
    IVFX.Size, IVFX.Position, IVFX.BackgroundTransparency, IVFX.Text, IVFX.TextColor3, IVFX.Font, IVFX.TextSize, IVFX.TextTransparency, IVFX.TextXAlignment, IVFX.TextYAlignment = UDim2.new(1,-20,0,60), UDim2.new(0,10,0,35), 1, VFX_TEXT, C_BASE, Enum.Font.Gotham, 12, 1, Enum.TextXAlignment.Left, Enum.TextYAlignment.Top

    -- Buttons Panel (Dynamic generation based on Config.Tabs)
    local SlotP = Instance.new("Frame", Cont)
    SlotP.AnchorPoint, SlotP.Position, SlotP.Size, SlotP.BackgroundColor3, SlotP.BackgroundTransparency = Vector2.new(0.5,1), UDim2.new(0.5,0,1,-20), UDim2.new(0,450,0,70), Color3.fromRGB(25,15,40), 0.4
    Instance.new("UICorner", SlotP).CornerRadius = UDim.new(0,6)
    local SStrk = Instance.new("UIStroke", SlotP)
    SStrk.Color, SStrk.Transparency = C_BASE, 0.6
    local LLo = Instance.new("UIListLayout", SlotP)
    LLo.FillDirection, LLo.Padding, LLo.HorizontalAlignment, LLo.VerticalAlignment = Enum.FillDirection.Horizontal, UDim.new(0,8), Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center

    for _, tabData in ipairs(TABS) do
        local btn = Instance.new("TextButton", SlotP)
        btn.Size, btn.BackgroundColor3, btn.Text, btn.AutoButtonColor = UDim2.new(0,50,0,50), C_ON, "", false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
        local lbl = Instance.new("TextLabel", btn)
        lbl.Size, lbl.BackgroundTransparency, lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize = UDim2.new(1,0,1,0), 1, tabData.n, Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 10

        btn.MouseEnter:Connect(function()
            TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C_HOV}):Play()
            for _, pt in ipairs(getPts(tabData)) do TS:Create(pt, TweenInfo.new(0.2), {Color = C_HL}):Play() end
        end)
        btn.MouseLeave:Connect(function()
            TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C_ON}):Play()
            for _, pt in ipairs(getPts(tabData)) do TS:Create(pt, TweenInfo.new(0.2), {Color = C_BASE}):Play() end
        end)
        
        btn.MouseButton1Click:Connect(function()
            isIdle = false 
            isPanelOpen = true

            RTit.Text = "ข้อมูลส่วน: " .. tabData.n

            TS:Create(VP, ti, {Position = UDim2.new(0.25, 0, 0.45, 0)}):Play()
            TS:Create(HBox, ti, {Position = UDim2.new(0.25, 0, 0.45, 0)}):Play()
            TS:Create(RPane, ti, {Position = UDim2.new(0.97, 0, 0.45, 0)}):Play()

            Info.Visible = false

            local char = WM:FindFirstChild(p.Name)
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local hrp = char.HumanoidRootPart

            -- ใช้ angle และ zoom จากตาราง Config
            local tAng = tabData.angle and math.rad(tabData.angle) or 0
            local zD = tabData.zoom or 3
            
            rotAngle = tAng
            TS:Create(hrp, ti, {CFrame = CFrame.new(0, Y_OFF, 0) * CFrame.Angles(0, tAng, 0)}):Play()

            -- หาพาร์ทที่จะโฟกัส
            local fp
            for _, pName in ipairs(tabData.t) do
                local found = char:FindFirstChild(pName)
                if found then
                    fp = found
                    break
                end
            end

            if fp then
                local off = hrp.CFrame:ToObjectSpace(fp.CFrame).Position
                local futHRP = CFrame.new(0, Y_OFF, 0) * CFrame.Angles(0, tAng, 0)
                local tFoc = futHRP * off
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
        if char and char:FindFirstChild("HumanoidRootPart") then
            TS:Create(char.HumanoidRootPart, ti, {CFrame = CFrame.new(0, Y_OFF, 0)}):Play()
        end
        task.delay(0.4, function() 
            rotAngle = 0 
            isIdle = true 
        end)
    end)

    -- Return API object (ถ้าต้องการสั่งปิดเปิดจากนอกสคริปต์)
    return {
        UI = UI,
        Toggle = toggleUI,
        Destroy = function() if UI then UI:Destroy() end end
    }
end