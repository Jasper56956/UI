--[[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Created by: L Ua all (Clean Viewport Version)
]]

return function(Config)
    Config = Config or {}

    local function ForceString(val, fallback)
        if typeof(val) == "string" then return val end
        if typeof(val) == "boolean" then return tostring(val) end
        if val == nil then return tostring(fallback or "") end
        return tostring(val)
    end

    local TitleText = ForceString(Config.Title, "VFX Hub")
    local MainColor = Config.MainColor or Color3.fromRGB(160, 80, 255)
    local ToggleKey = Config.ToggleKey or Enum.KeyCode.RightControl

    local P = game:GetService("Players")
    local TS = game:GetService("TweenService")
    local RS = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local p = P.LocalPlayer
    local pg = p:WaitForChild("PlayerGui")

    -- ลบ UI เก่าออกให้หมดก่อนเริ่ม
    for _, old in ipairs(pg:GetChildren()) do
        if old.Name == "VFXHub" then old:Destroy() end
    end

    local UI = Instance.new("ScreenGui", pg)
    UI.Name, UI.ResetOnSpawn = "VFXHub", false

    local Main = Instance.new("Frame", UI)
    Main.AnchorPoint, Main.Position, Main.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,800,0,500)
    Main.BackgroundColor3, Main.ClipsDescendants = Color3.fromRGB(30, 30, 30), true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    local MainScale = Instance.new("UIScale", Main)

    -- [[ TOP BAR ]]
    local Top = Instance.new("Frame", Main)
    Top.Size, Top.BackgroundColor3 = UDim2.new(1,0,0,35), Color3.fromRGB(220, 220, 220)
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

    local Lbl = Instance.new("TextLabel", Top)
    Lbl.AnchorPoint, Lbl.Position, Lbl.Size = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0,200,1,0)
    Lbl.BackgroundTransparency, Lbl.TextColor3 = 1, Color3.fromRGB(50,50,50)
    Lbl.Font, Lbl.TextSize = Enum.Font.GothamMedium, 16
    Lbl.Text = TitleText

    -- [[ MAC BUTTONS ]]
    local uiOpen = true
    local MacP = Instance.new("Frame", Top)
    MacP.BackgroundTransparency, MacP.Position, MacP.AnchorPoint, MacP.Size = 1, UDim2.new(0,15,0.5,0), Vector2.new(0,0.5), UDim2.new(0,60,1,0)
    Instance.new("UIListLayout", MacP).FillDirection, MacP.UIListLayout.Padding, MacP.UIListLayout.VerticalAlignment = Enum.FillDirection.Horizontal, UDim.new(0,8), Enum.VerticalAlignment.Center

    local function mkMac(c)
        local b = Instance.new("TextButton", MacP)
        b.Size, b.BackgroundColor3, b.Text, b.AutoButtonColor = UDim2.new(0,12,0,12), c, "", false
        Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
        return b
    end
    mkMac(Color3.fromRGB(255, 95, 86)).MouseButton1Click:Connect(function()
        uiOpen = not uiOpen
        TS:Create(MainScale, TweenInfo.new(0.4), {Scale = uiOpen and 1 or 0}):Play()
    end)
    mkMac(Color3.fromRGB(255, 189, 46))
    mkMac(Color3.fromRGB(39, 201, 63))

    -- [[ CONTENT AREA ]]
    local Cont = Instance.new("Frame", Main)
    Cont.Position, Cont.Size, Cont.BackgroundColor3 = UDim2.new(0,0,0,35), UDim2.new(1,0,1,-35), Color3.fromRGB(40,30,55)

    -- [[ VIEWPORT (CLEAN) ]]
    local VP = Instance.new("ViewportFrame", Cont)
    VP.AnchorPoint, VP.Position, VP.Size, VP.BackgroundTransparency = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.45,0), UDim2.new(0,300,0,400), 1
    local WM = Instance.new("WorldModel", VP)
    local Cam = Instance.new("Camera", VP)
    VP.CurrentCamera = Cam
    Cam.CFrame = CFrame.new(Vector3.new(0, 1, -7), Vector3.new(0, 0.5, 0))

    -- ฟังก์ชันเคลียร์ตัวละครให้เหลือแค่ร่างกายเปล่าๆ
    local function setupChar(c)
        WM:ClearAllChildren() -- ล้างขยะใน WorldModel ก่อน
        c.Archivable = true
        local cl = c:Clone()
        cl.Parent = WM
        
        local hrp = cl:WaitForChild("HumanoidRootPart")
        hrp.Anchored = true
        hrp.CFrame = CFrame.new(0, 0.5, 0)

        for _, obj in ipairs(cl:GetDescendants()) do
            if obj:IsA("BasePart") then
                if obj.Name ~= "HumanoidRootPart" then
                    obj.Color = MainColor
                    obj.Material = Enum.Material.ForceField
                    obj.Transparency = 0
                    obj.CanCollide = false
                end
            elseif obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("Decal") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj:Destroy() -- ลบพวก Effect พ่วง และเสื้อผ้าทิ้งให้หมด
            end
        end
    end
    
    if p.Character then setupChar(p.Character) end
    p.CharacterAdded:Connect(setupChar)

    -- [[ SELECTION BUTTONS ]]
    local SlotP = Instance.new("Frame", Cont)
    SlotP.AnchorPoint, SlotP.Position, SlotP.Size = Vector2.new(0.5,1), UDim2.new(0.5,0,1,-20), UDim2.new(0,450,0,70)
    SlotP.BackgroundColor3, SlotP.BackgroundTransparency = Color3.fromRGB(20, 10, 30), 0.5
    Instance.new("UICorner", SlotP).CornerRadius = UDim.new(0,8)
    Instance.new("UIListLayout", SlotP).FillDirection, SlotP.UIListLayout.HorizontalAlignment, SlotP.UIListLayout.VerticalAlignment, SlotP.UIListLayout.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0,8)

    local partNames = {"หัว", "ตัว", "แขนซ้าย", "แขนขวา", "ขาซ้าย", "ขาขวา", "หลัง"}
    for _, n in ipairs(partNames) do
        local btn = Instance.new("TextButton", SlotP)
        btn.Size, btn.BackgroundColor3, btn.Text = UDim2.new(0,50,0,50), MainColor, ""
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
        local l = Instance.new("TextLabel", btn)
        l.Size, l.BackgroundTransparency, l.Text = UDim2.new(1,0,1,0), 1, n
        l.TextColor3, l.Font, l.TextSize = Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 10
    end

    return { Instance = UI }
end