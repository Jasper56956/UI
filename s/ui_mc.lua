--[[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Created by: L Ua all (Image & Text Tabs Version)
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
    Main.AnchorPoint, Main.Position, Main.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,800,0,500)
    Main.BackgroundColor3, Main.ClipsDescendants = Color3.fromRGB(30, 30, 30), true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    -- [[ TOP BAR ]]
    local Top = Instance.new("Frame", Main)
    Top.Size, Top.BackgroundColor3 = UDim2.new(1,0,0,35), Color3.fromRGB(220, 220, 220)
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

    local Lbl = Instance.new("TextLabel", Top)
    Lbl.AnchorPoint, Lbl.Position, Lbl.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,200,1,0)
    Lbl.BackgroundTransparency, Lbl.TextColor3, Lbl.Text = 1, Color3.fromRGB(50,50,50), TitleText
    Lbl.Font, Lbl.TextSize = Enum.Font.GothamMedium, 16

    -- [[ CONTENT AREA ]]
    local Cont = Instance.new("Frame", Main)
    Cont.Position, Cont.Size, Cont.BackgroundColor3 = UDim2.new(0,0,0,35), UDim2.new(1,0,1,-35), Color3.fromRGB(40,30,55)

    -- [[ VIEWPORT (3D Character) ]]
    local VP = Instance.new("ViewportFrame", Cont)
    VP.AnchorPoint, VP.Position, VP.Size, VP.BackgroundTransparency = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.45,0), UDim2.new(0,400,0,450), 1
    local WM = Instance.new("WorldModel", VP)
    local Cam = Instance.new("Camera", VP)
    VP.CurrentCamera = Cam

    local function setupChar()
        WM:ClearAllChildren()
        local charModel = P:CreateHumanoidModelFromUserId(p.UserId)
        charModel.Parent = WM
        local hrp = charModel:WaitForChild("HumanoidRootPart")
        hrp.Anchored = true
        Cam.CFrame = CFrame.new(Vector3.new(0, 2, -8), hrp.Position + Vector3.new(0, 0.5, 0))

        local rot = 0
        if _G.VFX_Rot then _G.VFX_Rot:Disconnect() end
        _G.VFX_Rot = RS.RenderStepped:Connect(function(dt)
            rot = rot + (dt * 45)
            hrp.CFrame = CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(rot), 0)
        end)
    end
    setupChar()

    -- [[ TAB CONTAINER ]]
    local SlotP = Instance.new("Frame", Cont)
    SlotP.AnchorPoint, SlotP.Position, SlotP.Size = Vector2.new(0.5,1), UDim2.new(0.5,0,1,-20), UDim2.new(0,650,0,75)
    SlotP.BackgroundColor3, SlotP.BackgroundTransparency = Color3.fromRGB(15, 10, 25), 0.6
    Instance.new("UICorner", SlotP).CornerRadius = UDim.new(0,10)
    
    local LLo = Instance.new("UIListLayout", SlotP)
    LLo.FillDirection, LLo.HorizontalAlignment, LLo.VerticalAlignment, LLo.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0,12)

    -- [[ สร้างปุ่มแบบ Dynamic (รองรับ Name และ Image) ]]
    for _, info in ipairs(CustomTabs) do
        local btn = Instance.new("TextButton", SlotP)
        btn.Size, btn.BackgroundColor3, btn.Text = UDim2.new(0,60,0,60), Color3.fromRGB(60, 40, 100), ""
        btn.AutoButtonColor = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
        
        -- ใส่ Stroke ให้ปุ่มดูคมขึ้น
        local strk = Instance.new("UIStroke", btn)
        strk.Color, strk.Thickness, strk.Transparency = MainColor, 1.5, 0.5

        if info.Image then
            -- ถ้ามี ID รูปภาพ ให้สร้างปุ่มรูป
            local img = Instance.new("ImageLabel", btn)
            img.Size = UDim2.new(0.7,0,0.7,0)
            img.Position = UDim2.new(0.5,0,0.5,0)
            img.AnchorPoint = Vector2.new(0.5,0.5)
            img.BackgroundTransparency = 1
            img.Image = info.Image
            img.ScaleType = Enum.ScaleType.Fit
        else
            -- ถ้าไม่มีรูป ให้แสดงข้อความแทน
            local l = Instance.new("TextLabel", btn)
            l.Size = UDim2.new(1,-10,1,-10)
            l.Position = UDim2.new(0.5,0,0.5,0)
            l.AnchorPoint = Vector2.new(0.5,0.5)
            l.BackgroundTransparency = 1
            l.Text = ForceString(info.Name, "Tab")
            l.TextColor3, l.Font, l.TextSize = Color3.