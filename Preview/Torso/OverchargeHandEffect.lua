return function(holoChar, previewFolder)
    local rootPart = holoChar:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- [1] สร้างออร่าจำลอง (ปรับแต่งขนาดและสีตามต้องการ)
    local previewAura = Instance.new("Part")
    
    -- เปลี่ยนขนาด (Size) ให้กว้าง/สูง พอดีกับเอฟเฟคจริง
    previewAura.Size = Vector3.new(5, 7, 5) 
    
    -- เปลี่ยนรูปทรง: Enum.PartType.Cylinder (ทรงกระบอก)
    previewAura.Shape = Enum.PartType.Cylinder 
    
    -- สีของ Part อิงตามสีหลักของ Particle
    previewAura.Color = Color3.fromRGB(143, 250, 0) 
    
    previewAura.Material = Enum.Material.Neon
    -- 💡 ซ่อน Part หลักเป็นล่องหน เพื่อโชว์เฉพาะ Particle Effects ที่จัดเตรียมไว้
    previewAura.Transparency = 1 
    previewAura.CanCollide = false
    
    -- จัดแกนให้ตรงกับตัวละคร (ทรงกระบอกต้องหมุน 90 องศา)
    previewAura.CFrame = rootPart.CFrame * CFrame.Angles(0, 0, math.rad(90))
    
    -- [2] เชื่อมเอฟเฟคติดกับโฮโลแกรม
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = rootPart
    weld.Part1 = previewAura
    weld.Parent = previewAura

    -- สร้าง Attachment ไว้สำหรับรองรับ Particle ทั้งหมด
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = previewAura

    -- =======================================================
    -- ใส่ Particle Emitter: ชุด Old Effects 
    -- =======================================================
    local fx1 = Instance.new("ParticleEmitter")
    fx1.Name = "Old_1"
    fx1.Lifetime = NumberRange.new(0.50, 0.50)
    fx1.Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, Color3.new(0.56, 0.98, 0.00)), ColorSequenceKeypoint.new(1.00, Color3.new(0.56, 0.98, 0.00))})
    fx1.ZOffset = -1.5
    fx1.TimeScale = 0.75
    fx1.LightEmission = 1
    fx1.SpreadAngle = Vector2.new(360.00, -360.00)
    fx1.Speed = NumberRange.new(-0.24, 0.24)
    fx1.Brightness = 10
    fx1.Texture = "rbxassetid://1084970835"
    fx1.Rotation = NumberRange.new(-360.00, 360.00)
    fx1.Rate = 5
    fx1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 0.00, 0.00), NumberSequenceKeypoint.new(0.03, 0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx1.Size = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 0.00, 0.00), NumberSequenceKeypoint.new(0.05, 4.70, 0.00), NumberSequenceKeypoint.new(0.08, 6.86, 0.00), NumberSequenceKeypoint.new(0.12, 15.00, 0.00), NumberSequenceKeypoint.new(0.17, 7.20, 0.00), NumberSequenceKeypoint.new(0.22, 5.71, 0.00), NumberSequenceKeypoint.new(0.27, 3.55, 0.00), NumberSequenceKeypoint.new(0.35, 1.44, 0.00), NumberSequenceKeypoint.new(0.41, 0.53, 0.00), NumberSequenceKeypoint.new(0.47, 0.05, 0.00), NumberSequenceKeypoint.new(0.58, 0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx1.Parent = Attachment

    local fx2 = Instance.new("ParticleEmitter")
    fx2.Name = "Old_2"
    fx2.Lifetime = NumberRange.new(0.55, 0.55)
    fx2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, Color3.new(0.83, 0.99, 0.47)), ColorSequenceKeypoint.new(1.00, Color3.new(0.83, 0.99, 0.47))})
    fx2.ZOffset = 0.07223039865493774
    fx2.TimeScale = 0.85
    fx2.LightEmission = 1
    fx2.SpreadAngle = Vector2.new(360.00, -360.00)
    fx2.Speed = NumberRange.new(-0.17, 0.17)
    fx2.Brightness = 6
    fx2.Texture = "rbxassetid://8625703339"
    fx2.Rotation = NumberRange.new(-360.00, 360.00)
    fx2.Rate = 5
    fx2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 0.00, 0.00), NumberSequenceKeypoint.new(0.24, 0.00, 0.00), NumberSequenceKeypoint.new(0.40, 0.15, 0.00), NumberSequenceKeypoint.new(0.62, 0.75, 0.00), NumberSequenceKeypoint.new(1.00, 1.00, 0.00)})
    fx2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 0.00, 0.00), NumberSequenceKeypoint.new(0.19, 2.43, 0.00), NumberSequenceKeypoint.new(1.00, 6.21, 0.00)})
    fx2.Parent = Attachment

    local fx3 = Instance.new("ParticleEmitter")
    fx3.Name = "Old_3"
    fx3.Lifetime = NumberRange.new(0.70, 0.70)
    fx3.Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, Color3.new(0.56, 0.98, 0.00)), ColorSequenceKeypoint.new(1.00, Color3.new(0.56, 0.98, 0.00))})
    fx3.ZOffset = 1.5136833190917969
    fx3.TimeScale = 0.90
    fx3.LightEmission = 1
    fx3.SpreadAngle = Vector2.new(360.00, -360.00)
    fx3.Speed = NumberRange.new(-0.51, 0.51)
    fx3.Brightness = 5
    fx3.Texture = "rbxassetid://8130415181"
    fx3.Rotation = NumberRange.new(-360.00, 360.00)
    fx3.Rate = 5
    fx3.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 0.00, 0.00), NumberSequenceKeypoint.new(0.03, 0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx3.Size = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 0.00, 0.00), NumberSequenceKeypoint.new(0.05, 9.88, 3.23), NumberSequenceKeypoint.new(0.08, 14.41, 4.59), NumberSequenceKeypoint.new(0.12, 20.00, 5.44), NumberSequenceKeypoint.new(0.17, 15.12, 4.93), NumberSequenceKeypoint.new(0.22, 12.00, 3.57), NumberSequenceKeypoint.new(0.27, 7.46, 1.53), NumberSequenceKeypoint.new(0.35, 3.02, 0.00), NumberSequenceKeypoint.new(0.41, 1.11, 0.00), NumberSequenceKeypoint.new(0.47, 0.10, 0.00), NumberSequenceKeypoint.new(0.58, 0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx3.Parent = Attachment

    local fx4 = Instance.new("ParticleEmitter")
    fx4.Name = "Old_6"
    fx4.Lifetime = NumberRange.new(0.30, 0.45)
    fx4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, Color3.new(0.83, 0.99, 0.47)), ColorSequenceKeypoint.new(1.00, Color3.new(0.83, 0.99, 0.47))})
    fx4.ZOffset = 0.07742195576429367
    fx4.TimeScale = 0.85
    fx4.LightEmission = 1
    fx4.SpreadAngle = Vector2.new(360.00, -360.00)
    fx4.Speed = NumberRange.new(-0.18, 0.18)
    fx4.Brightness = 6
    fx4.Texture = "rbxassetid://8625703339"
    fx4.Rotation = NumberRange.new(-360.00, 360.00)
    fx4.Rate = 25
    fx4.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 1.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx4.Size = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 12.68, 0.00), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx4.Parent = Attachment

    -- =======================================================
    -- ใส่ Particle Emitter: ชุด New Effects 
    -- =======================================================
    local fx5 = Instance.new("ParticleEmitter")
    fx5.Name = "New_1"
    fx5.Lifetime = NumberRange.new(1.00, 1.00)
    fx5.Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, Color3.new(0.31, 0.56, 0.00)), ColorSequenceKeypoint.new(1.00, Color3.new(0.31, 0.56, 0.00))})
    fx5.ZOffset = 1.6571919918060303
    fx5.Speed = NumberRange.new(-0.17, 0.17)
    fx5.Brightness = 10
    fx5.Texture = "rbxassetid://14834478801"
    fx5.RotSpeed = NumberRange.new(111.00, 111.00)
    fx5.Rotation = NumberRange.new(-360.00, 360.00)
    fx5.LockedToPart = true
    fx5.Rate = 10
    fx5.EmissionDirection = Enum.NormalId.Front
    fx5.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.49, 0.00)})
    fx5.Size = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 0.00, 0.00), NumberSequenceKeypoint.new(0.06, 0.59, 0.00), NumberSequenceKeypoint.new(0.11, 1.11, 0.00), NumberSequenceKeypoint.new(0.15, 2.16, 0.00), NumberSequenceKeypoint.new(0.18, 2.55, 0.00), NumberSequenceKeypoint.new(0.20, 10.00, 0.00), NumberSequenceKeypoint.new(0.22, 2.33, 0.00), NumberSequenceKeypoint.new(0.24, 1.76, 0.00), NumberSequenceKeypoint.new(0.27, 1.13, 0.00), NumberSequenceKeypoint.new(0.33, 0.88, 0.00), NumberSequenceKeypoint.new(0.46, 0.47, 0.00), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx5.Parent = Attachment

    local fx6 = Instance.new("ParticleEmitter")
    fx6.Name = "New_10"
    fx6.Lifetime = NumberRange.new(0.40, 0.60)
    fx6.Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, Color3.new(0.56, 0.98, 0.00)), ColorSequenceKeypoint.new(1.00, Color3.new(0.56, 0.98, 0.00))})
    fx6.ZOffset = 0.60
    fx6.SpreadAngle = Vector2.new(360.00, -360.00)
    fx6.Speed = NumberRange.new(-0.06, 0.06)
    fx6.Brightness = 5
    fx6.Texture = "rbxassetid://6770889554"
    fx6.RotSpeed = NumberRange.new(-1100.00, -850.00)
    fx6.Rotation = NumberRange.new(-360.00, 360.00)
    fx6.LockedToPart = true
    fx6.Rate = 58
    fx6.EmissionDirection = Enum.NormalId.Front
    fx6.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 1.00, 0.00), NumberSequenceKeypoint.new(0.35, 0.88, 0.05), NumberSequenceKeypoint.new(0.51, 0.66, 0.14), NumberSequenceKeypoint.new(0.65, 0.30, 0.21), NumberSequenceKeypoint.new(0.79, 0.07, 0.07), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx6.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
    fx6.Size = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 17.00, 0.00), NumberSequenceKeypoint.new(0.64, 3.06, 3.06), NumberSequenceKeypoint.new(0.77, 1.52, 1.52), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx6.Parent = Attachment

    local fx7 = Instance.new("ParticleEmitter")
    fx7.Name = "New_11"
    fx7.Lifetime = NumberRange.new(0.40, 0.60)
    fx7.Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, Color3.new(0.83, 0.99, 0.47)), ColorSequenceKeypoint.new(1.00, Color3.new(0.83, 0.99, 0.47))})
    fx7.ZOffset = 0.60
    fx7.LightEmission = 1
    fx7.SpreadAngle = Vector2.new(360.00, -360.00)
    fx7.Speed = NumberRange.new(-0.06, 0.06)
    fx7.Brightness = 15
    fx7.Texture = "rbxassetid://6770889554"
    fx7.RotSpeed = NumberRange.new(-1100.00, -850.00)
    fx7.Rotation = NumberRange.new(-360.00, 360.00)
    fx7.LockedToPart = true
    fx7.Rate = 58
    fx7.EmissionDirection = Enum.NormalId.Front
    fx7.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 1.00, 0.00), NumberSequenceKeypoint.new(0.35, 0.88, 0.05), NumberSequenceKeypoint.new(0.51, 0.66, 0.14), NumberSequenceKeypoint.new(0.65, 0.30, 0.21), NumberSequenceKeypoint.new(0.79, 0.07, 0.07), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx7.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
    fx7.Size = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 15.00, 0.00), NumberSequenceKeypoint.new(0.64, 3.06, 3.06), NumberSequenceKeypoint.new(0.77, 1.52, 1.52), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx7.Parent = Attachment

    local fx8 = Instance.new("ParticleEmitter")
    fx8.Name = "New_15"
    fx8.Lifetime = NumberRange.new(0.10, 0.30)
    fx8.Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, Color3.new(0.83, 0.99, 0.47)), ColorSequenceKeypoint.new(1.00, Color3.new(0.83, 0.99, 0.47))})
    fx8.Drag = 30
    fx8.TimeScale = 0.50
    fx8.LightEmission = 0.55
    fx8.SpreadAngle = Vector2.new(360.00, 360.00)
    fx8.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0.00, -0.74, 0.00), NumberSequenceKeypoint.new(1.00, 2.13, 0.00)})
    fx8.Speed = NumberRange.new(0.00, 100.00)
    fx8.Brightness = 9
    fx8.Texture = "http://www.roblox.com/asset/?id=243098098"
    fx8.Rotation = NumberRange.new(-90.00, -90.00)
    fx8.Rate = 75
    fx8.EmissionDirection = Enum.NormalId.Bottom
    fx8.Orientation = Enum.ParticleOrientation.VelocityParallel
    fx8.Size = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 10.00, 8.71), NumberSequenceKeypoint.new(0.03, 1.43, 0.00), NumberSequenceKeypoint.new(0.10, 8.34, 2.85), NumberSequenceKeypoint.new(0.15, 1.11, 0.00), NumberSequenceKeypoint.new(0.20, 0.95, 0.00), NumberSequenceKeypoint.new(0.26, 3.48, 1.74), NumberSequenceKeypoint.new(0.29, 1.27, 0.00), NumberSequenceKeypoint.new(0.35, 0.16, 0.00), NumberSequenceKeypoint.new(0.40, 1.90, 0.95), NumberSequenceKeypoint.new(0.46, 8.16, 2.06), NumberSequenceKeypoint.new(0.52, 1.27, 0.00), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx8.Parent = Attachment

    local fx9 = Instance.new("ParticleEmitter")
    fx9.Name = "New_18"
    fx9.Lifetime = NumberRange.new(0.10, 0.30)
    fx9.Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, Color3.new(0.00, 0.98, 0.00)), ColorSequenceKeypoint.new(1.00, Color3.new(0.00, 0.98, 0.00))})
    fx9.Drag = 30
    fx9.TimeScale = 0.50
    fx9.SpreadAngle = Vector2.new(360.00, 360.00)
    fx9.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0.00, -0.74, 0.00), NumberSequenceKeypoint.new(1.00, 2.13, 0.00)})
    fx9.Speed = NumberRange.new(0.00, 100.00)
    fx9.Brightness = 9
    fx9.Texture = "http://www.roblox.com/asset/?id=243098098"
    fx9.Rotation = NumberRange.new(90.00, 90.00)
    fx9.Rate = 75
    fx9.EmissionDirection = Enum.NormalId.Bottom
    fx9.Orientation = Enum.ParticleOrientation.VelocityParallel
    fx9.Size = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 10.00, 8.71), NumberSequenceKeypoint.new(0.03, 1.43, 0.00), NumberSequenceKeypoint.new(0.10, 8.34, 2.85), NumberSequenceKeypoint.new(0.15, 1.11, 0.00), NumberSequenceKeypoint.new(0.20, 0.95, 0.00), NumberSequenceKeypoint.new(0.26, 3.48, 1.74), NumberSequenceKeypoint.new(0.29, 1.27, 0.00), NumberSequenceKeypoint.new(0.35, 0.16, 0.00), NumberSequenceKeypoint.new(0.40, 1.90, 0.95), NumberSequenceKeypoint.new(0.46, 8.16, 2.06), NumberSequenceKeypoint.new(0.52, 1.27, 0.00), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx9.Parent = Attachment

    local fx10 = Instance.new("ParticleEmitter")
    fx10.Name = "Lines"
    fx10.Lifetime = NumberRange.new(1.00, 1.50)
    fx10.Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, Color3.new(1.00, 0.99, 0.47)), ColorSequenceKeypoint.new(1.00, Color3.new(1.00, 0.99, 0.47))})
    fx10.Drag = 2
    fx10.ZOffset = 2
    fx10.LightEmission = 1
    fx10.SpreadAngle = Vector2.new(-360.00, 360.00)
    fx10.Speed = NumberRange.new(0.00, 20.00)
    fx10.Brightness = 5
    fx10.Texture = "rbxassetid://10439119562"
    fx10.Acceleration = Vector3.new(0.00, -10.00, 0.00)
    fx10.Rotation = NumberRange.new(-360.00, 360.00)
    fx10.Rate = 100
    fx10.Size = NumberSequence.new({NumberSequenceKeypoint.new(0.00, 0.00, 0.00), NumberSequenceKeypoint.new(0.25, 1.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00, 0.00)})
    fx10.Parent = Attachment

    -- =======================================================
    -- 👇 [3] นำไปใส่ใน Folder ที่ระบบเตรียมไว้ให้ (ห้ามลบเด็ดขาด) 👇
    -- =======================================================
    previewAura.Parent = previewFolder
end