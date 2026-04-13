--[=[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Library V20: Added Background Color Setting back to Settings Tab
]=]

local P = game:GetService("Players")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local WS = game:GetService("Workspace")

return function(Config)
    Config = Config or {}

    -- [[ ⚙️ CONFIGURATION VARIABLES ]]
    local UI_TITLE = Config.Title or "Hub"
    local C_BASE = Config.BaseColor or Color3.fromRGB(160, 80, 255)     
    local C_HL = Config.HighlightColor or Color3.fromRGB(100, 255, 255) 
    local C_ON = Config.ButtonColor or Color3.fromRGB(100, 70, 150)
    
    local C_BG = Config.BackgroundColor or Color3.fromRGB(30, 15, 45)
    local BG_TRANS = Config.BackgroundTransparency or 0.2
    
    local TOGGLE_KEY = Config.ToggleKey or Enum.KeyCode.RightControl
    local C_FONT = Config.Font or Enum.Font.GothamMedium
    local INFO_TITLE = Config.InfoTitle or "SYSTEM INFO"
    
    -- 🌟 Center Text Typewriter Config
    local CENTER_TEXT_DATA = Config.CenterText or {"ยินดีต้อนรับสู่ระบบ!", "เลือกส่วนที่ต้องการเพื่อเริ่มต้น"}
    if type(CENTER_TEXT_DATA) == "string" then CENTER_TEXT_DATA = {CENTER_TEXT_DATA} end
    local CENTER_TEXT_SIZE = Config.CenterTextSize or 32
    local CENTER_TEXT_FONT = Config.CenterTextFont or Enum.Font.FredokaOne
    local TYPE_SPEED = Config.TypingSpeed or 0.05
    local PAUSE_TIME = Config.PauseTime or 2.5
    local SHOW_CENTER_TEXT = Config.ShowCenterText
    if SHOW_CENTER_TEXT == nil then SHOW_CENTER_TEXT = true end
    
    local TAB_BOXES = Config.TabBoxes or {}
    
    local FIXED_TABS = {
        {id="Head", n="Head", t={"Head"}, angle=0, zoom=3}, 
        {id="Torso", n="Torso", t={"Torso","UpperTorso","LowerTorso"}, angle=0, zoom=6},
        {id="Left Arm", n="Left Arm", t={"Left Arm","LeftUpperArm","LeftLowerArm","LeftHand"}, angle=0, zoom=5},
        {id="Right Arm", n="Right Arm", t={"Right Arm","RightUpperArm","RightLowerArm","RightHand"}, angle=0, zoom=5},
        {id="Left Leg", n="Left Leg", t={"Left Leg","LeftUpperLeg","LeftLowerLeg","LeftFoot"}, angle=0, zoom=5},
        {id="Right Leg", n="Right Leg", t={"Right Leg","RightUpperLeg","RightLowerLeg","RightFoot"}, angle=0, zoom=5},
        {id="Back", n="Back", t={"Torso","UpperTorso","LowerTorso"}, angle=180, zoom=6}
    }

    local p = P.LocalPlayer
    local pg = p:WaitForChild("PlayerGui")
    local camera = WS.CurrentCamera
    
    if pg:FindFirstChild("VFXHub") then pg.VFXHub:Destroy() end

    local ti = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

    -- [[ UI SETUP ]]
    local UI = Instance.new("ScreenGui", pg)
    UI.Name, UI.ResetOnSpawn = "VFXHub", false
    UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- ======================================================
    -- 🖥️ MAIN UI WINDOW
    -- ======================================================
    local uiOpen = true 

    local Main = Instance.new("Frame", UI)
    Main.AnchorPoint, Main.Position, Main.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,800,0,500)
    Main.BackgroundColor3, Main.ClipsDescendants = Color3.fromRGB(20, 20, 20), true
    Main.BackgroundTransparency = 0.2
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    local MainScale = Instance.new("UIScale", Main)
    MainScale.Scale = 1

    -- Top Bar
    local Top = Instance.new("Frame", Main)
    Top.Size, Top.BackgroundColor3, Top.ZIndex = UDim2.new(1,0,0,35), Color3.fromRGB(220, 220, 220), 10
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

    local TClip = Instance.new("Frame", Top)
    TClip.AnchorPoint, TClip.Position, TClip.Size = Vector2.new(0,1), UDim2.new(0,0,1,0), UDim2.new(1,0,0,10)
    TClip.BackgroundColor3, TClip.BorderSizePixel = Top.BackgroundColor3, 0

    local Lbl = Instance.new("TextLabel", Top)
    Lbl.AnchorPoint, Lbl.Position, Lbl.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,100,1,-10)
    Lbl.BackgroundTransparency, Lbl.Text, Lbl.TextColor3, Lbl.Font, Lbl.TextSize = 1, UI_TITLE, Color3.fromRGB(50,50,50), C_FONT, 16

    local SettingsBtn = Instance.new("TextButton", Top)
    SettingsBtn.AnchorPoint, SettingsBtn.Position, SettingsBtn.Size = Vector2.new(1,0.5), UDim2.new(1,-15,0.5,0), UDim2.new(0,25,0,25)
    SettingsBtn.BackgroundTransparency, SettingsBtn.Text, SettingsBtn.TextColor3, SettingsBtn.TextSize = 1, "⚙", Color3.fromRGB(100,100,100), 20

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

    -- ======================================================
    -- 📦 CONTENT AREA (Solid Background)
    -- ======================================================
    local Cont = Instance.new("Frame", Main)
    Cont.Position, Cont.Size = UDim2.new(0,0,0,35), UDim2.new(1,0,1,-35)
    Cont.BackgroundColor3 = C_BG
    Cont.BackgroundTransparency = BG_TRANS
    Cont.ClipsDescendants = true
    Cont.Visible = true

    -- 🌟 Typewriter Center Text
    local CenterTextLbl = Instance.new("TextLabel", Cont)
    CenterTextLbl.AnchorPoint, CenterTextLbl.Position = Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.45, 0)
    CenterTextLbl.Size = UDim2.new(0.8, 0, 0.2, 0)
    CenterTextLbl.BackgroundTransparency = 1
    CenterTextLbl.Text = ""
    CenterTextLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    CenterTextLbl.Font = CENTER_TEXT_FONT
    CenterTextLbl.TextSize = CENTER_TEXT_SIZE
    CenterTextLbl.Visible = SHOW_CENTER_TEXT
    CenterTextLbl.ZIndex = 2
    local CenterTextStrk = Instance.new("UIStroke", CenterTextLbl)
    CenterTextStrk.Color = Color3.fromRGB(0, 0, 0)
    CenterTextStrk.Thickness = 2
    CenterTextStrk.Transparency = 0.5

    local function getGraphemes(str)
        local graphemes = {}
        for first, last in utf8.graphemes(str) do
            table.insert(graphemes, string.sub(str, first, last))
        end
        return graphemes
    end

    if SHOW_CENTER_TEXT and #CENTER_TEXT_DATA > 0 then
        task.spawn(function()
            while true do
                for _, str in ipairs(CENTER_TEXT_DATA) do
                    local graphemes = getGraphemes(str)
                    local currentText = ""
                    -- พิมพ์เข้า
                    for i = 1, #graphemes do
                        currentText = currentText .. graphemes[i]
                        CenterTextLbl.Text = currentText
                        task.wait(TYPE_SPEED)
                    end
                    task.wait(PAUSE_TIME)
                    
                    -- ลบออก
                    if #CENTER_TEXT_DATA > 1 then
                        for i = #graphemes, 1, -1 do
                            currentText = ""
                            for j = 1, i - 1 do
                                currentText = currentText .. graphemes[j]
                            end
                            CenterTextLbl.Text = currentText
                            task.wait(TYPE_SPEED / 2)
                        end
                        task.wait(0.5)
                    end
                end
                if #CENTER_TEXT_DATA == 1 then break end
            end
        end)
    end

    -- ======================================================
    -- ⚙️ CORE SYSTEMS
    -- ======================================================
    local function clearHighlights()
        if p.Character then
            for _, v in ipairs(p.Character:GetDescendants()) do
                if v.Name == "VFXHub_Highlight" then v:Destroy() end
            end
        end
    end

    local function clearPreview()
        if p.Character and p.Character:FindFirstChild("PreviewEffects") then
            p.Character.PreviewEffects:ClearAllChildren()
        end
    end

    local function toggleUI()
        uiOpen = not uiOpen
        if uiOpen then
            Main.Visible = true
            TS:Create(MainScale, ti, {Scale = 1}):Play()
        else
            local tw = TS:Create(MainScale, ti, {Scale = 0})
            tw:Play()
            tw.Completed:Connect(function() if not uiOpen then Main.Visible = false end end)
            camera.CameraType = Enum.CameraType.Custom
            clearPreview()
            clearHighlights()
        end
    end

    mClose.MouseButton1Click:Connect(toggleUI)

    local dragToggle, dragInput, dragStart, startPos
    Top.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragToggle, dragStart, startPos = true, inp.Position, Main.Position
            inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
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

    -- ======================================================
    -- 📁 CONTENT DETAILS & HOVER PREVIEW
    -- ======================================================
    local HBox = Instance.new("TextButton", Cont)
    HBox.AnchorPoint, HBox.Position, HBox.Size, HBox.BackgroundTransparency, HBox.Text, HBox.ZIndex = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.45,0), UDim2.new(0,350,0,350), 1, "", 5
    HBox.Visible = false 

    local RPane = Instance.new("Frame", Cont)
    RPane.AnchorPoint, RPane.Position, RPane.Size, RPane.ZIndex = Vector2.new(1,0.5), UDim2.new(1.5, 0, 0.45, 0), UDim2.new(0, 420, 0, 320), 5
    RPane.BackgroundColor3, RPane.BackgroundTransparency = Color3.fromRGB(25, 15, 40), 0.2
    RPane.Visible = false 
    Instance.new("UICorner", RPane).CornerRadius = UDim.new(0, 8)
    local RStrk = Instance.new("UIStroke", RPane)
    RStrk.Color, RStrk.Transparency, RStrk.Thickness = C_BASE, 0.5, 1.5

    local BigPreview = Instance.new("ImageLabel", Cont)
    BigPreview.Size = UDim2.new(0, 260, 0, 260)
    BigPreview.AnchorPoint = Vector2.new(0.5, 0.5)
    BigPreview.Position = UDim2.new(0.25, 0, 0.45, 0)
    BigPreview.BackgroundTransparency = 1
    BigPreview.ImageTransparency = 1 
    BigPreview.ScaleType = Enum.ScaleType.Fit
    BigPreview.ZIndex = 4

    local RTit = Instance.new("TextLabel", RPane)
    RTit.Size, RTit.Position, RTit.BackgroundTransparency = UDim2.new(1,-40,0,40), UDim2.new(0,20,0,15), 1
    RTit.Text, RTit.TextColor3, RTit.Font, RTit.TextSize = INFO_TITLE, Color3.fromRGB(255,255,255), C_FONT, 22
    RTit.TextXAlignment = Enum.TextXAlignment.Left

    local BoxContainer = Instance.new("ScrollingFrame", RPane)
    BoxContainer.Size, BoxContainer.Position, BoxContainer.BackgroundTransparency = UDim2.new(1, -20, 1, -70), UDim2.new(0, 10, 0, 60), 1
    BoxContainer.ScrollBarThickness = 4
    BoxContainer.ScrollBarImageColor3 = C_HL
    BoxContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y 
    BoxContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    BoxContainer.BorderSizePixel = 0
    
    local Padding = Instance.new("UIPadding", BoxContainer)
    Padding.PaddingTop, Padding.PaddingBottom, Padding.PaddingLeft, Padding.PaddingRight = UDim.new(0, 8), UDim.new(0, 8), UDim.new(0, 5), UDim.new(0, 5)

    local BoxGridLayout = Instance.new("UIGridLayout", BoxContainer)
    BoxGridLayout.CellSize = UDim2.new(0, 80, 0, 90)
    BoxGridLayout.CellPadding = UDim2.new(0, 15, 0, 15)
    BoxGridLayout.FillDirectionMaxCells = 4 
    BoxGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    BoxGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function RenderBoxes(boxDataList)
        for _, v in ipairs(BoxContainer:GetChildren()) do
            if v:IsA("Frame") then v:Destroy() end
        end
        boxDataList = boxDataList or {}
        for _, data in ipairs(boxDataList) do
            local slot = Instance.new("Frame", BoxContainer)
            slot.BackgroundColor3, slot.BackgroundTransparency = Color3.fromRGB(35, 20, 50), 0.5
            Instance.new("UICorner", slot).CornerRadius = UDim.new(0, 6)
            local slotStrk = Instance.new("UIStroke", slot)
            slotStrk.Color, slotStrk.Transparency, slotStrk.Thickness = C_HL, 0.3, 2 
            
            if data.Image then
                local img = Instance.new("ImageButton", slot)
                img.Size, img.BackgroundTransparency, img.Position, img.AnchorPoint = UDim2.new(1, -10, 1, -10), 1, UDim2.new(0.5, 0, 0.5, 0), Vector2.new(0.5, 0.5)
                img.Image = data.Image
                
                img.MouseEnter:Connect(function()
                    BigPreview.Image = data.Image
                    TS:Create(BigPreview, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
                end)
                
                img.MouseLeave:Connect(function()
                    TS:Create(BigPreview, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                end)

                img.MouseButton1Click:Connect(function()
                    clearPreview()
                    if data.Callback then 
                        if type(data.Callback) == "string" and data.Callback:match("^http") then
                            loadstring(game:HttpGet(data.Callback))()
                        elseif type(data.Callback) == "function" then
                            data.Callback() 
                        end
                    end
                    local char = p.Character
                    if char then
                        local prevFolder = char:FindFirstChild("PreviewEffects") or Instance.new("Folder", char)
                        prevFolder.Name = "PreviewEffects"
                        if data.Preview then
                            if type(data.Preview) == "string" and data.Preview:match("^http") then
                                local success, result = pcall(function() return loadstring(game:HttpGet(data.Preview))() end)
                                if success and type(result) == "function" then result(char, prevFolder) end
                            elseif type(data.Preview) == "function" then
                                data.Preview(char, prevFolder)
                            end
                        end
                    end
                end)
            end
        end
    end

    -- ======================================================
    -- ⚙️ SETTINGS PANEL (REBUILT FOR CLEAN UI)
    -- ======================================================
    local SetPnl = Instance.new("Frame", Main)
    SetPnl.Size, SetPnl.Position, SetPnl.BackgroundColor3 = UDim2.new(1,0,1,-35), UDim2.new(0,0,0,35), Color3.fromRGB(15,10,25)
    SetPnl.BackgroundTransparency, SetPnl.ZIndex, SetPnl.Visible, SetPnl.Active = 0.2, 100, false, true 
    
    local SetBox = Instance.new("Frame", SetPnl)
    -- ปรับขนาดกล่อง SetBox ให้สูงขึ้นเล็กน้อยเพื่อรองรับแถวเพิ่ม
    SetBox.Size, SetBox.AnchorPoint, SetBox.Position = UDim2.new(0, 320, 0, 260), Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0)
    SetBox.BackgroundColor3, SetBox.ZIndex, SetBox.Active = Color3.fromRGB(35, 20, 50), 101, true
    Instance.new("UICorner", SetBox).CornerRadius = UDim.new(0, 8)
    local SetStrk = Instance.new("UIStroke", SetBox)
    SetStrk.Color, SetStrk.Thickness = C_BASE, 2
    
    local SetTitle = Instance.new("TextLabel", SetBox)
    SetTitle.Size, SetTitle.Position, SetTitle.BackgroundTransparency = UDim2.new(1, 0, 0, 45), UDim2.new(0, 0, 0, 0), 1
    SetTitle.Text, SetTitle.TextColor3, SetTitle.Font, SetTitle.TextSize, SetTitle.ZIndex = "SETTINGS", Color3.fromRGB(255, 255, 255), C_FONT, 20, 102
    
    local SetClose = Instance.new("TextButton", SetBox)
    SetClose.Size, SetClose.AnchorPoint, SetClose.Position, SetClose.BackgroundColor3 = UDim2.new(0, 120, 0, 35), Vector2.new(0.5, 1), UDim2.new(0.5, 0, 1, -15), C_ON
    SetClose.Text, SetClose.TextColor3, SetClose.Font, SetClose.ZIndex = "Close", Color3.fromRGB(255, 255, 255), C_FONT, 102
    Instance.new("UICorner", SetClose).CornerRadius = UDim.new(0, 6)

    -- Container for Setting Items
    local SetItems = Instance.new("Frame", SetBox)
    SetItems.Size, SetItems.Position, SetItems.BackgroundTransparency = UDim2.new(1, -40, 1, -110), UDim2.new(0, 20, 0, 45), 1
    SetItems.ZIndex = 102
    
    local SetLayout = Instance.new("UIListLayout", SetItems)
    SetLayout.SortOrder, SetLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 12)
    SetLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- ฟังก์ชันสร้าง Row การตั้งค่า
    local function createSettingRow(titleText, inputElement)
        local Row = Instance.new("Frame", SetItems)
        Row.Size, Row.BackgroundTransparency = UDim2.new(1, 0, 0, 32), 1
        
        local Lbl = Instance.new("TextLabel", Row)
        Lbl.Size, Lbl.Position, Lbl.BackgroundTransparency = UDim2.new(0.5, -5, 1, 0), UDim2.new(0, 0, 0, 0), 1
        Lbl.Text, Lbl.TextColor3, Lbl.Font, Lbl.TextSize = titleText, Color3.fromRGB(220, 220, 220), C_FONT, 16
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        
        inputElement.Parent = Row
        inputElement.Size = UDim2.new(0.5, -5, 1, 0)
        inputElement.Position = UDim2.new(0.5, 5, 0, 0)
        inputElement.ZIndex = 103
    end

    -- 1. Font Setting
    local FontBtn = Instance.new("TextButton")
    FontBtn.BackgroundColor3 = Color3.fromRGB(50, 35, 75)
    FontBtn.Text, FontBtn.TextColor3, FontBtn.Font, FontBtn.TextSize = C_FONT.Name, C_HL, C_FONT, 14
    Instance.new("UICorner", FontBtn).CornerRadius = UDim.new(0, 4)
    createSettingRow("Font Style", FontBtn)
    
    local FontList = {Enum.Font.GothamMedium, Enum.Font.Roboto, Enum.Font.Ubuntu, Enum.Font.SciFi, Enum.Font.Arcade, Enum.Font.Code}
    local fIdx = 1
    FontBtn.MouseButton1Click:Connect(function()
        fIdx = (fIdx % #FontList) + 1
        local newFont = FontList[fIdx]
        FontBtn.Text = newFont.Name
        for _, obj in ipairs(Main:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then obj.Font = newFont end
        end
    end)

    -- 2. Keybind Setting
    local KeyBtn = Instance.new("TextButton")
    KeyBtn.BackgroundColor3 = Color3.fromRGB(50, 35, 75)
    KeyBtn.Text, KeyBtn.TextColor3, KeyBtn.Font, KeyBtn.TextSize = TOGGLE_KEY.Name, C_HL, C_FONT, 14
    Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 4)
    createSettingRow("Toggle Key", KeyBtn)

    local isBinding = false
    KeyBtn.MouseButton1Click:Connect(function() isBinding = true KeyBtn.Text = "... Press Key ..." end)
    UIS.InputBegan:Connect(function(inp, gpe)
        if isBinding and inp.UserInputType == Enum.UserInputType.Keyboard then
            TOGGLE_KEY, KeyBtn.Text, isBinding = inp.KeyCode, inp.KeyCode.Name, false
        elseif not gpe and inp.KeyCode == TOGGLE_KEY and not isBinding then
            toggleUI()
        end
    end)

    -- 🌟 3. [NEW] BG Color Setting
    local BgBox = Instance.new("TextBox")
    BgBox.BackgroundColor3 = Color3.fromRGB(50, 35, 75)
    BgBox.Text = ""
    BgBox.PlaceholderText = "e.g. 30, 15, 45"
    BgBox.TextColor3 = C_HL
    BgBox.Font = C_FONT
    BgBox.TextSize = 14
    Instance.new("UICorner", BgBox).CornerRadius = UDim.new(0, 4)
    createSettingRow("UI Color (RGB)", BgBox)

    BgBox.FocusLost:Connect(function()
        local text = BgBox.Text
        if text ~= "" then
            -- เช็คแพทเทิร์น "ตัวเลข, ตัวเลข, ตัวเลข"
            local r, g, b = text:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
            if r and g and b then
                Cont.BackgroundColor3 = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
            else
                BgBox.Text = ""
                BgBox.PlaceholderText = "Invalid Format!"
            end
        end
    end)

    SettingsBtn.MouseButton1Click:Connect(function() SetPnl.Visible = true end)
    SetClose.MouseButton1Click:Connect(function() SetPnl.Visible = false end)

    -- ======================================================
    -- 🌟 BOTTOM TABS UX
    -- ======================================================
    local SlotP = Instance.new("Frame", Cont)
    SlotP.AnchorPoint, SlotP.Position = Vector2.new(0.5, 1), UDim2.new(0.5, 0, 1, -15)
    SlotP.Size, SlotP.BackgroundColor3 = UDim2.new(0, 680, 0, 55), Color3.fromRGB(15, 5, 20)
    SlotP.BackgroundTransparency, SlotP.ZIndex = 0.4, 6
    Instance.new("UICorner", SlotP).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", SlotP).Color = Color3.fromRGB(180, 80, 255)
    
    local LLo = Instance.new("UIListLayout", SlotP)
    LLo.FillDirection, LLo.Padding, LLo.HorizontalAlignment, LLo.VerticalAlignment = Enum.FillDirection.Horizontal, UDim.new(0, 10), Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center

    for _, tabData in ipairs(FIXED_TABS) do
        local btn = Instance.new("TextButton", SlotP)
        btn.Size, btn.BackgroundColor3 = UDim2.new(0, (tabData.id=="Back" and 90 or 75), 0, 32), Color3.fromRGB(80, 15, 25) 
        btn.Text, btn.AutoButtonColor, btn.ZIndex = "", false, 7
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local BStrk = Instance.new("UIStroke", btn)
        BStrk.Color, BStrk.Thickness = Color3.fromRGB(200, 40, 40), 1.2

        local lbl = Instance.new("TextLabel", btn)
        lbl.Size, lbl.BackgroundTransparency, lbl.Text = UDim2.new(1,0,1,0), 1, tabData.n
        lbl.TextColor3, lbl.Font, lbl.TextSize, lbl.ZIndex = Color3.fromRGB(255,255,255), C_FONT, 11, 8

        btn.MouseButton1Click:Connect(function()
            -- ซ่อน Center Text
            TS:Create(CenterTextLbl, ti, {TextTransparency = 1}):Play()
            TS:Create(CenterTextStrk, ti, {Transparency = 1}):Play()
            
            HBox.Visible = true
            RPane.Visible = true

            RTit.Text = "Zone: " .. tabData.n
            RenderBoxes(TAB_BOXES[tabData.id] or {})
            TS:Create(HBox, ti, {Position = UDim2.new(0.25, 0, 0.45, 0)}):Play()
            TS:Create(RPane, ti, {Position = UDim2.new(0.97, 0, 0.45, 0)}):Play()

            local char = p.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            camera.CameraType = Enum.CameraType.Scriptable
            clearHighlights()
            local fp = char.HumanoidRootPart
            for _, pName in ipairs(tabData.t) do
                local part = char:FindFirstChild(pName)
                if part and part:IsA("BasePart") then
                    fp = part
                    local hb = Instance.new("SelectionBox", part)
                    hb.Name = "VFXHub_Highlight"
                    hb.Adornee = part
                    hb.Color3 = C_HL
                    hb.SurfaceColor3 = C_HL
                    hb.LineThickness = 0.05
                    hb.Transparency = 0
                    hb.SurfaceTransparency = 0.7
                end
            end
            local zD = tabData.zoom or 4
            local camPos = (tabData.id == "Back") and (fp.CFrame * CFrame.new(-3, 1, zD + 2)) or (fp.CFrame * CFrame.new(-3, 1, -zD - 2))
            TS:Create(camera, ti, {CFrame = CFrame.lookAt(camPos.Position, fp.Position)}):Play()
        end)
    end

    -- ======================================================
    -- 🔙 ZOOM OUT LOGIC 
    -- ======================================================
    local function performZoomOut()
        local tw = TS:Create(RPane, ti, {Position = UDim2.new(1.5, 0, 0.45, 0)})
        tw:Play()
        TS:Create(HBox, ti, {Position = UDim2.new(0.5, 0, 0.45, 0)}):Play()
        
        -- เฟดให้ Center Text กลับมา
        TS:Create(CenterTextLbl, ti, {TextTransparency = 0}):Play()
        TS:Create(CenterTextStrk, ti, {Transparency = 0.5}):Play()
        
        TS:Create(BigPreview, ti, {ImageTransparency = 1}):Play()
        
        tw.Completed:Connect(function()
            HBox.Visible = false
            RPane.Visible = false
        end)

        camera.CameraType = Enum.CameraType.Custom
        clearHighlights()
    end

    HBox.MouseButton1Click:Connect(performZoomOut)

    return { UI = UI, Toggle = toggleUI, Destroy = function() if UI then UI:Destroy() end end }
end