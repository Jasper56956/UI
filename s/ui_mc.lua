--[=[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Library V8: Home Page Menu & Left Image Preview
]=]

local P = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

return function(Config)
    Config = Config or {}

    -- [[ ⚙️ CONFIGURATION VARIABLES ]]
    local UI_TITLE = Config.Title or "VFX Hub"
    local C_BASE = Config.BaseColor or Color3.fromRGB(160, 80, 255)     
    local C_HL = Config.HighlightColor or Color3.fromRGB(100, 255, 255) 
    local C_ON = Config.ButtonColor or Color3.fromRGB(45, 25, 65)
    local C_HOV = Config.HoverColor or Color3.fromRGB(80, 50, 120)
    local BG_IMAGE = Config.BackgroundImage or "rbxassetid://277037193"
    
    local TOGGLE_KEY = Config.ToggleKey or Enum.KeyCode.RightControl
    local C_FONT = Config.Font or Enum.Font.GothamMedium
    
    local TAB_BOXES = Config.TabBoxes or {}
    
    -- หมวดหมู่ที่จะโชว์ในหน้าแรก (Home Page)
    local ZONES = {
        {id="Head", name="Head / Face"},
        {id="Torso", name="Body / Torso"},
        {id="Arms", name="Arms / Hands"},
        {id="Legs", name="Legs / Feet"},
        {id="Back", name="Back / Wings"}
    }

    local p = P.LocalPlayer
    local pg = p:WaitForChild("PlayerGui")
    
    if pg:FindFirstChild("VFXHub") then pg.VFXHub:Destroy() end

    local ti = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    -- [[ UI SETUP ]]
    local UI = Instance.new("ScreenGui", pg)
    UI.Name, UI.ResetOnSpawn = "VFXHub", false

    local Main = Instance.new("Frame", UI)
    Main.AnchorPoint, Main.Position, Main.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,750,0,450)
    Main.BackgroundColor3, Main.ClipsDescendants = Color3.fromRGB(20, 15, 30), true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color, MainStroke.Thickness, MainStroke.Transparency = C_BASE, 2, 0.3

    local MainScale = Instance.new("UIScale", Main)
    MainScale.Scale = 1

    -- [[ TOP BAR (DRAGGABLE) ]]
    local Top = Instance.new("Frame", Main)
    Top.Size, Top.BackgroundColor3, Top.ZIndex = UDim2.new(1,0,0,40), Color3.fromRGB(30, 20, 45), 10
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 10)
    
    local TClip = Instance.new("Frame", Top)
    TClip.AnchorPoint, TClip.Position, TClip.Size = Vector2.new(0,1), UDim2.new(0,0,1,0), UDim2.new(1,0,0,10)
    TClip.BackgroundColor3, TClip.BorderSizePixel = Top.BackgroundColor3, 0

    local Lbl = Instance.new("TextLabel", Top)
    Lbl.Size, Lbl.Position, Lbl.BackgroundTransparency = UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), 1
    Lbl.Text, Lbl.TextColor3, Lbl.Font, Lbl.TextSize = UI_TITLE, Color3.fromRGB(255,255,255), C_FONT, 18

    -- ปิด UI
    local uiOpen = true
    local CloseBtn = Instance.new("TextButton", Top)
    CloseBtn.AnchorPoint, CloseBtn.Position, CloseBtn.Size = Vector2.new(1,0.5), UDim2.new(1,-10,0.5,0), UDim2.new(0,24,0,24)
    CloseBtn.BackgroundColor3, CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.Font = Color3.fromRGB(255, 80, 80), "X", Color3.fromRGB(255,255,255), Enum.Font.GothamBold
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)

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
    CloseBtn.MouseButton1Click:Connect(toggleUI)

    -- [[ DRAG SYSTEM ]]
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

    UIS.InputBegan:Connect(function(inp, gpe)
        if not gpe and inp.KeyCode == TOGGLE_KEY then toggleUI() end
    end)

    -- พื้นหลังลายตาราง
    local Cont = Instance.new("Frame", Main)
    Cont.Position, Cont.Size, Cont.BackgroundTransparency = UDim2.new(0,0,0,40), UDim2.new(1,0,1,-40), 1
    local Grid = Instance.new("ImageLabel", Cont)
    Grid.Size, Grid.BackgroundTransparency, Grid.Image, Grid.ImageColor3, Grid.ImageTransparency = UDim2.new(1,0,1,0), 1, BG_IMAGE, C_BASE, 0.9
    Grid.ScaleType, Grid.TileSize = Enum.ScaleType.Tile, UDim2.new(0,100,0,100)

    -- ==========================================
    -- 🏠 PAGE 1: HOME PAGE (เลือกส่วนร่างกาย)
    -- ==========================================
    local HomePage = Instance.new("Frame", Cont)
    HomePage.Size, HomePage.Position, HomePage.BackgroundTransparency = UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), 1
    
    local HomeTitle = Instance.new("TextLabel", HomePage)
    HomeTitle.Size, HomeTitle.Position, HomeTitle.BackgroundTransparency = UDim2.new(1,0,0,50), UDim2.new(0,0,0,20), 1
    HomeTitle.Text, HomeTitle.TextColor3, HomeTitle.Font, HomeTitle.TextSize = "SELECT BODY PART", C_HL, C_FONT, 24
    
    local ZoneContainer = Instance.new("ScrollingFrame", HomePage)
    ZoneContainer.Size, ZoneContainer.AnchorPoint, ZoneContainer.Position = UDim2.new(0,600,0,300), Vector2.new(0.5, 0), UDim2.new(0.5,0,0,80)
    ZoneContainer.BackgroundTransparency, ZoneContainer.ScrollBarThickness = 1, 0
    ZoneContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local ZoneLayout = Instance.new("UIGridLayout", ZoneContainer)
    ZoneLayout.CellSize, ZoneLayout.CellPadding = UDim2.new(0, 180, 0, 80), UDim2.new(0, 20, 0, 20)
    ZoneLayout.HorizontalAlignment, ZoneLayout.SortOrder = Enum.HorizontalAlignment.Center, Enum.SortOrder.LayoutOrder

    -- ==========================================
    -- 📦 PAGE 2: SELECTION PAGE (เลือกเอฟเฟค + พรีวิวรูปภาพ)
    -- ==========================================
    local SelectionPage = Instance.new("Frame", Cont)
    SelectionPage.Size, SelectionPage.Position, SelectionPage.BackgroundTransparency = UDim2.new(1,0,1,0), UDim2.new(1,0,0,0), 1 -- ซ่อนไว้ทางขวา
    SelectionPage.Visible = false

    -- 🔙 ปุ่มย้อนกลับ
    local BackBtn = Instance.new("TextButton", SelectionPage)
    BackBtn.Size, BackBtn.Position, BackBtn.BackgroundColor3 = UDim2.new(0,100,0,30), UDim2.new(0,15,0,15), Color3.fromRGB(50, 30, 70)
    BackBtn.Text, BackBtn.TextColor3, BackBtn.Font, BackBtn.TextSize = "← BACK", Color3.fromRGB(255,255,255), C_FONT, 14
    Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0,6)
    local BackStrk = Instance.new("UIStroke", BackBtn)
    BackStrk.Color, BackStrk.Thickness, BackStrk.Transparency = C_HL, 1, 0.5
    
    local CurrentZoneTitle = Instance.new("TextLabel", SelectionPage)
    CurrentZoneTitle.Size, CurrentZoneTitle.Position, CurrentZoneTitle.BackgroundTransparency = UDim2.new(0,200,0,30), UDim2.new(0,130,0,15), 1
    CurrentZoneTitle.Text, CurrentZoneTitle.TextColor3, CurrentZoneTitle.Font, CurrentZoneTitle.TextSize, CurrentZoneTitle.TextXAlignment = "Zone", C_HL, C_FONT, 20, Enum.TextXAlignment.Left

    -- 🖼️ ฝั่งซ้าย: รูปภาพ Preview ขนาดใหญ่
    local LeftPreview = Instance.new("Frame", SelectionPage)
    LeftPreview.Size, LeftPreview.Position, LeftPreview.BackgroundColor3 = UDim2.new(0,300,0,300), UDim2.new(0,20,0,60), Color3.fromRGB(15,10,25)
    Instance.new("UICorner", LeftPreview).CornerRadius = UDim.new(0,10)
    Instance.new("UIStroke", LeftPreview).Color = C_BASE
    
    local PreviewImg = Instance.new("ImageLabel", LeftPreview)
    PreviewImg.Size, PreviewImg.Position, PreviewImg.BackgroundTransparency = UDim2.new(1,-20,1,-20), UDim2.new(0,10,0,10), 1
    PreviewImg.ScaleType = Enum.ScaleType.Fit
    -- รูปเริ่มต้นเมื่อยังไม่ได้เลือกอะไร
    PreviewImg.Image = "rbxassetid://15053423719" 
    PreviewImg.ImageTransparency = 0.5

    local PreviewText = Instance.new("TextLabel", LeftPreview)
    PreviewText.Size, PreviewText.Position, PreviewText.BackgroundTransparency = UDim2.new(1,0,0,30), UDim2.new(0,0,1,-40), 1
    PreviewText.Text, PreviewText.TextColor3, PreviewText.Font, PreviewText.TextSize = "Select VFX on the right", Color3.fromRGB(150,150,150), C_FONT, 14

    -- 🗂️ ฝั่งขวา: รายการไอเทม
    local RightPanel = Instance.new("ScrollingFrame", SelectionPage)
    RightPanel.Size, RightPanel.Position, RightPanel.BackgroundTransparency = UDim2.new(0,380,0,300), UDim2.new(0,340,0,60), 1
    RightPanel.ScrollBarThickness, RightPanel.ScrollBarImageColor3 = 4, C_HL
    RightPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local RightLayout = Instance.new("UIGridLayout", RightPanel)
    RightLayout.CellSize, RightLayout.CellPadding = UDim2.new(0, 80, 0, 80), UDim2.new(0, 10, 0, 10)
    RightLayout.HorizontalAlignment, RightLayout.SortOrder = Enum.HorizontalAlignment.Center, Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", RightPanel).PaddingTop = UDim.new(0,5)

    -- [[ LOGIC: สร้างกล่องไอเทมฝั่งขวา ]]
    local function RenderRightItems(zoneId)
        -- ล้างของเก่าทิ้ง
        for _, v in ipairs(RightPanel:GetChildren()) do
            if v:IsA("Frame") then v:Destroy() end
        end
        
        -- คืนค่ารูปพรีวิวฝั่งซ้ายเป็นค่าเริ่มต้น
        PreviewImg.Image = "rbxassetid://15053423719"
        PreviewImg.ImageTransparency = 0.5
        PreviewText.Text = "Select VFX on the right"

        local boxDataList = TAB_BOXES[zoneId] or {}
        
        for _, data in ipairs(boxDataList) do
            local slot = Instance.new("Frame", RightPanel)
            slot.BackgroundColor3, slot.BackgroundTransparency = Color3.fromRGB(35, 20, 50), 0.5
            Instance.new("UICorner", slot).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", slot).Color = C_BASE
            
            if data.Image then
                local imgBtn = Instance.new("ImageButton", slot)
                imgBtn.Size, imgBtn.BackgroundTransparency = UDim2.new(1,-10,1,-10), 1
                imgBtn.Position, imgBtn.AnchorPoint = UDim2.new(0.5,0,0.5,0), Vector2.new(0.5,0.5)
                imgBtn.Image = data.Image
                
                imgBtn.MouseButton1Click:Connect(function()
                    -- 1. เปลี่ยนรูปภาพฝั่งซ้ายมือให้เป็นรูปที่กด
                    PreviewImg.Image = data.Image
                    PreviewImg.ImageTransparency = 0
                    PreviewText.Text = "Preview"

                    -- 2. รันสคริปต์/เอฟเฟค ลงตัวละคร
                    if data.Callback then 
                        if type(data.Callback) == "string" and data.Callback:match("^http") then
                            loadstring(game:HttpGet(data.Callback))()
                        elseif type(data.Callback) == "function" then
                            data.Callback() 
                        end
                    end
                end)
            end
        end
    end

    -- [[ LOGIC: เปลี่ยนหน้าไปมา ]]
    local function GoToSelectionPage(zoneData)
        CurrentZoneTitle.Text = zoneData.name
        RenderRightItems(zoneData.id)
        
        SelectionPage.Visible = true
        TS:Create(HomePage, ti, {Position = UDim2.new(-1,0,0,0)}):Play()
        TS:Create(SelectionPage, ti, {Position = UDim2.new(0,0,0,0)}):Play()
    end

    BackBtn.MouseButton1Click:Connect(function()
        TS:Create(HomePage, ti, {Position = UDim2.new(0,0,0,0)}):Play()
        local tw = TS:Create(SelectionPage, ti, {Position = UDim2.new(1,0,0,0)})
        tw:Play()
        tw.Completed:Connect(function() SelectionPage.Visible = false end)
    end)

    -- สร้างปุ่มเลือกหมวดหมู่ในหน้าแรก (Home Page)
    for _, z in ipairs(ZONES) do
        local zBtn = Instance.new("TextButton", ZoneContainer)
        zBtn.BackgroundColor3 = C_ON
        zBtn.Text, zBtn.TextColor3, zBtn.Font, zBtn.TextSize = z.name, Color3.fromRGB(255,255,255), C_FONT, 18
        Instance.new("UICorner", zBtn).CornerRadius = UDim.new(0,8)
        local zStrk = Instance.new("UIStroke", zBtn)
        zStrk.Color, zStrk.Thickness = C_BASE, 2
        
        zBtn.MouseEnter:Connect(function() TS:Create(zBtn, ti, {BackgroundColor3 = C_HOV}):Play() end)
        zBtn.MouseLeave:Connect(function() TS:Create(zBtn, ti, {BackgroundColor3 = C_ON}):Play() end)
        
        zBtn.MouseButton1Click:Connect(function()
            GoToSelectionPage(z)
        end)
    end

    return { UI = UI, Toggle = toggleUI, Destroy = function() if UI then UI:Destroy() end end }
end