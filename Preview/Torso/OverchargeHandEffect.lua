return function(holoChar, previewFolder)
    local rootPart = holoChar:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- [ ฟังก์ชันช่วยสร้าง Neon Part สำหรับซ้อนเลเยอร์ ]
    local function createNeonLayer(name, size, transparency, offsetAngle)
        local part = Instance.new("Part")
        part.Name = name
        part.Size = size
        part.Shape = Enum.PartType.Cylinder
        part.Color = Color3.fromRGB(143, 250, 0) -- โทนเขียวอมเหลืองหลัก
        part.Material = Enum.Material.Neon
        part.Transparency = transparency
        part.CanCollide = false
        part.CastShadow = false
        
        -- จัดตำแหน่งและหมุนให้ตรงแกนตัวละคร
        part.CFrame = rootPart.CFrame * offsetAngle
        
        -- เชื่อมติดกับ HumanoidRootPart
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = rootPart
        weld.Part1 = part
        weld.Parent = part
        
        part.Parent = previewFolder
        return part
    end

    -- [1] เลเยอร์หลัก (แกนกลาง)
    -- เน้นความชัดเจนของรูปทรงออร่า
    createNeonLayer(
        "MainAuraCore", 
        Vector3.new(6, 4.5, 4.5), 
        0.5, 
        CFrame.Angles(0, 0, math.rad(90))
    )

    -- [2] เลเยอร์นอก (รัศมีฟุ้ง)
    -- ปรับให้ใหญ่ขึ้นและจางลงเพื่อให้ดูเหมือนแสงฟุ้งกระจาย (Glow effect)
    createNeonLayer(
        "OuterGlow", 
        Vector3.new(6.5, 5.5, 5.5), 
        0.8, 
        CFrame.Angles(0, 0, math.rad(90))
    )

    -- [3] เลเยอร์ตัดขวาง (เพิ่มมิติ)
    -- สร้าง Part อีกชิ้นวางเอียงเล็กน้อยเพื่อให้ดูมี Dynamic ใน UI
    createNeonLayer(
        "CrossDetail", 
        Vector3.new(5.8, 4.8, 4.8), 
        0.7, 
        CFrame.Angles(math.rad(15), 0, math.rad(90))
    )

end