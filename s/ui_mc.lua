--[[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Created by: L Ua all (Real Character 3D Version)
]]

return function(Config)
    Config = Config or {}

    local function ForceString(val, fallback)
        if typeof(val) == "string" then return val end
        return tostring(val or fallback or "")
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
    Lbl.BackgroundTransparency, Lbl.TextColor3, Lbl.Text = 1, Color3.fromRGB(50,50,50), TitleText
    Lbl.Font, Lbl.TextSize = Enum.Font.GothamMedium, 16

    -- [[ VIEWPORT (Real 3D Character) ]]
    local Cont = Instance.new("Frame", Main)
    Cont.Position, Cont.Size, Cont.BackgroundColor3 = UDim2.new(0,0,0,35), UDim2.new(1,0,1,-35), Color3.fromRGB(40,30,55)

    local VP = Instance.new("ViewportFrame", Cont)
    VP.AnchorPoint, VP.Position, VP.Size, VP.BackgroundTransparency = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.45,0), UDim2.new(0,400,0,450), 1
    
    local WM = Instance.new("WorldModel", VP)
    local Cam = Instance.new("Camera", VP)
    VP.CurrentCamera = Cam
    Cam.FieldOfView = 50

    local rotAngle = 0
    local function setupRealChar(character)
        WM:ClearAllChildren()
        
        -- ใช้โหมดดึงรูปลักษณ์จริงของผู้เล่น
        local charModel = game:GetService("Players"):CreateHumanoidModelFromUserId(p.UserId)
        charModel.Parent = WM
        
        local hrp = charModel:WaitForChild("HumanoidRootPart")
        hrp.Anchored = true
        hrp.CFrame = CFrame.new(0, 0, 0)
        
        -- ตั้งค่ามุมกล้องให้เห็นตัวละครชัดๆ
        Cam.CFrame = CFrame.new(Vector3.new(0, 2, -8), hrp.Position + Vector3.new(0, 0.5, 0))

        -- ระบบหมุนตัวละคร 3D
        if _G.UpdateConn then _G.UpdateConn:Disconnect() end
        _G.UpdateConn = RS.RenderStepped:Connect(function(dt)
            rotAngle = rotAngle + (dt * 40) -- ปรับความเร็วการหมุนตรงนี้
            hrp.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(rotAngle), 0)
        end)
    end

    setupRealChar()

    -- [[ SELECTION BUTTONS (ล่างสุด) ]]
    local SlotP = Instance.new("Frame", Cont)
    SlotP.AnchorPoint, SlotP.Position, SlotP.Size = Vector2.new(0.5,1), UDim2.new(0.5,0,1,-20), UDim2.new(0,450,0,70)
    SlotP.BackgroundColor3, SlotP.BackgroundTransparency = Color3.fromRGB(20, 10, 30), 0.5
    Instance.new("UICorner", SlotP).CornerRadius = UDim.new(0,8)
    local LLo = Instance.new("UIListLayout", SlotP)
    LLo.FillDirection, LLo.HorizontalAlignment, LLo.VerticalAlignment, LLo.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0,8)

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