--[[
    ██╗     ██╗   ██╗ █████╗      █████╗ ██╗     ██╗     
    ██║     ██║   ██║██╔══██╗    ██╔══██╗██║     ██║     
    ██║     ██║   ██║███████║    ███████║██║     ██║     
    ██║     ██║   ██║██╔══██║    ██╔══██║██║     ██║     
    ███████╗╚██████╔╝██║  ██║    ██║  ██║███████╗███████╗
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝
    Created by: L Ua all (3D Model Tabs Version)
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

    -- [[ VIEWPORT (Main 3D Character) ]]
    local VP = Instance.new("ViewportFrame", Cont)
    VP.AnchorPoint, VP.Position, VP.Size, VP.BackgroundTransparency = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.45,0), UDim2.new(0,400,0,450), 1
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
        if _G.VFX_MainRot then _G.VFX_MainRot:Disconnect() end
        _G.VFX_MainRot = RS.RenderStepped:Connect(function(dt)
            rot = rot + (dt * 45)
            hrp.CFrame = CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(rot), 0)
        end)
    end
    setupMainChar()

    -- [[ TAB CONTAINER ]]
    local SlotP = Instance.new("Frame", Cont)
    SlotP.AnchorPoint, SlotP.Position, SlotP.Size = Vector2.new(0.5,1), UDim2.new(0.5,0,1,-20), UDim2.new(0,700,0,85)
    SlotP.BackgroundColor3, SlotP.BackgroundTransparency = Color3.fromRGB(15, 10, 25), 0.6
    Instance.new("UICorner", SlotP).CornerRadius = UDim.new(0,10)
    
    local LLo = Instance.new("UIListLayout", SlotP)
    LLo.FillDirection, LLo.HorizontalAlignment, LLo.VerticalAlignment, LLo.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0,12)

    -- [[ 🔄 DYNAMIC TABS (รองรับ Text, Image, และ 3D Model หมุนได้) ]]
    for i, info in ipairs(CustomTabs) do
        local btn = Instance.new("TextButton", SlotP)
        btn.Size, btn.BackgroundColor3, btn.Text = UDim2.new(0,70,0,70), Color3.fromRGB(60, 40, 100), ""
        btn.AutoButtonColor = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
        
        local strk = Instance.new("UIStroke", btn)
        strk.Color, strk.Thickness, strk.Transparency = MainColor, 2, 0.5

        if info.Model then
            -- [[ ส่วนที่ 1: สร้าง 3D Model ในปุ่ม (ViewportFrame) ]]
            local vpBtn = Instance.new("ViewportFrame", btn)
            vpBtn.Size, vpBtn.Position = UDim2.new(0.8,0,0.8,0), UDim2.new(0.5,0,0.5,0)
            vpBtn.AnchorPoint, vpBtn.BackgroundTransparency = Vector2.new(0.5,0.5), 1
            vpBtn.ZIndex = 2
            
            local wmBtn = Instance.new("WorldModel", vpBtn)
            local camBtn = Instance.new("Camera", vpBtn)
            vpBtn.CurrentCamera = camBtn
            
            -- โคลน Model ของผู้ใช้มาใส่
            info.Model.Archivable = true
            local modelClone = info.Model:Clone()
            modelClone.Parent = wmBtn
            
            -- ปรับมุมกล้องให้เห็น Model ชัดๆ (ถ้ามี HumanoidRootPart หรือ PrimaryPart)
            local center = modelClone:GetPrimaryPartCFrame() or CFrame.new(0,0,0)
            modelClone:SetPrimaryPartCFrame(CFrame.new(0,0,0))
            camBtn.CFrame = CFrame.new(Vector3.new(0, 1.5, -5), Vector3.new(0, 0, 0))

            -- สั่งหมุน Model 3D ภายในปุ่ม
            local btnRot = 0
            if _G["BtnRot_"..i] then _G["BtnRot_"..i]:Disconnect() end
            _G["BtnRot_"..i] = RS.RenderStepped:Connect(function(dt)
                if btn and btn.Parent then
                    btnRot = btnRot + (dt * 60) -- หมุนปุ่มเร็วหน่อย
                    modelClone:SetPrimaryPartCFrame(CFrame.Angles(0, math.rad(btnRot), 0))
                else
                    _G["BtnRot_"..i]:Disconnect()
                end
            end)

        elseif info.Image then
            -- [[ ส่วนที่ 2: สร้างปุ่มรูปภาพนิ่ง ]]
            local img = Instance.new("ImageLabel", btn)
            img.Size, img.Position = UDim2.new(0.7,0,0.7,0), UDim2.new(0.5,0,0.5,0)
            img.AnchorPoint, img.BackgroundTransparency = Vector2.new(0.5,0.5), 1
            img.Image, img.ScaleType = info.Image, Enum.ScaleType.Fit
            img.ZIndex = 2
        else
            -- [[ ส่วนที่ 3: สร้างปุ่มข้อความปกติ ]]
            local l = Instance.new("TextLabel", btn)
            l.Size, l.BackgroundTransparency = UDim2.new(1,-10,1,-10), 1
            l.Position, l.AnchorPoint = UDim2.new(0.5,0,0.5,0), Vector2.new(0.5,0.5)
            l.Text = ForceString(info.Name, "Tab")
            l.TextColor3, l.Font, l.TextSize = Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 11
            l.TextScaled, l.ZIndex = true, 2
        end

        btn.MouseButton1Click:Connect(function()
            if info.Callback then info.Callback() end
            TS:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0,65,0,65)}):Play()
            task.wait(0.1)
            TS:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0,70,0,70)}):Play()
        end)
    end

    return { UI = UI }
end