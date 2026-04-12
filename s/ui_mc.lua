--[[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Created by: L Ua all (Classic Noob 3D Version)
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

    -- [[ VIEWPORT (Classic Noob 3D) ]]
    local Cont = Instance.new("Frame", Main)
    Cont.Position, Cont.Size, Cont.BackgroundColor3 = UDim2.new(0,0,0,35), UDim2.new(1,0,1,-35), Color3.fromRGB(40,30,55)

    local VP = Instance.new("ViewportFrame", Cont)
    VP.AnchorPoint, VP.Position, VP.Size, VP.BackgroundTransparency = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.45,0), UDim2.new(0,400,0,450), 1
    
    local WM = Instance.new("WorldModel", VP)
    local Cam = Instance.new("Camera", VP)
    VP.CurrentCamera = Cam
    Cam.FieldOfView = 50

    local rotAngle = 0
    local function setupNoobChar()
        WM:ClearAllChildren()
        
        -- สร้างโมเดลตัวละคร Noob พื้นฐาน
        local noobModel = Instance.new("Model", WM)
        noobModel.Name = "ClassicNoob"
        
        local partsData = {
            Head = {Size = Vector3.new(1, 1, 1), Color = BrickColor.new("Bright yellow"), Position = Vector3.new(0, 1.5, 0)},
            Torso = {Size = Vector3.new(2, 2, 1), Color = BrickColor.new("Bright blue"), Position = Vector3.new(0, 0, 0)},
            RightArm = {Size = Vector3.new(1, 2, 1), Color = BrickColor.new("Bright yellow"), Position = Vector3.new(1.5, 0, 0)},
            LeftArm = {Size = Vector3.new(1, 2, 1), Color = BrickColor.new("Bright yellow"), Position = Vector3.new(-1.5, 0, 0)},
            RightLeg = {Size = Vector3.new(1, 2, 1), Color = BrickColor.new("Br. yellowish green"), Position = Vector3.new(0.5, -2, 0)},
            LeftLeg = {Size = Vector3.new(1, 2, 1), Color = BrickColor.new("Br. yellowish green"), Position = Vector3.new(-0.5, -2, 0)},
            HumanoidRootPart = {Size = Vector3.new(2, 2, 1), Transparency = 1, Position = Vector3.new(0, 0, 0)} -- สำหรับหมุน
        }

        for name, data in pairs(partsData) do
            local p = Instance.new("Part", noobModel)
            p.Name = name
            p.Size = data.Size
            p.BrickColor = data.Color or BrickColor.new("Medium stone grey")
            p.Transparency = data.Transparency or 0
            p.CFrame = CFrame.new(data.Position)
            p.Anchored = true
            p.CanCollide = false
            
            -- สร้างหัวแบบคลาสสิก
            if name == "Head" then
                local mesh = Instance.new("SpecialMesh", p)
                mesh.MeshType = Enum.MeshType.Head
                mesh.Scale = Vector3.new(1.25, 1.25, 1.25)
                
                -- ใส่หน้ายิ้ม
                local face = Instance.new("Decal", p)
                face.Texture = "rbxasset://textures/face.png"
                face.Face = Enum.Face.Front
            end
        end
        
        local hrp = noobModel:WaitForChild("HumanoidRootPart")
        
        -- ตั้งค่ามุมกล้องให้เห็นตัวละครชัดๆ
        Cam.CFrame = CFrame.new(Vector3.new(0, 1, -7), hrp.Position)

        -- ระบบหมุนตัวละคร Noob 3D
        if _G.UpdateConn then _G.UpdateConn:Disconnect() end
        _G.UpdateConn = RS.RenderStepped:Connect(function(dt)
            rotAngle = rotAngle + (dt * 40) -- ปรับความเร็วการหมุนตรงนี้
            hrp.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(rotAngle), 0)
        end)
    end

    setupNoobChar()

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