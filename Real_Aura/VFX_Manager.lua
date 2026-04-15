-- ==========================================
-- ⚙️ VFX MANAGER CORE (Core Engine)
-- หน้าที่: จัดการระบบ Mapping ตำแหน่งร่างกาย, Toggle เปิด-ปิด, และสร้างฐาน
-- ==========================================

local VFXManager = {}
local Players = game:GetService("Players")

-- ==========================================
-- 🔍 1. ระบบ MAPPING (แปลงชื่อชิ้นส่วน R6 / R15)
-- ==========================================
local function GetBodyPart(char, zone)
    -- ตารางจับคู่ชื่อชิ้นส่วน (ถ้าเป็น R15 จะใช้ชื่อแรก ถ้าเป็น R6 จะใช้ชื่อหลัง)
    local mapping = {
        ["Head"] = "Head",
        ["Torso"] = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
        ["Right Arm"] = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm"),
        ["Left Arm"] = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm"),
        ["Right Leg"] = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg"),
        ["Left Leg"] = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg"),
        ["Root"] = "HumanoidRootPart",
        ["All"] = "HumanoidRootPart" -- เผื่อไว้สำหรับทำเอฟเฟกต์คลุมทั้งตัว
    }
    
    local target = mapping[zone]
    
    -- ตรวจสอบและคืนค่า Object ชิ้นส่วนกลับไป
    if typeof(target) == "string" then 
        return char:FindFirstChild(target) 
    end
    
    return target
end

-- ==========================================
-- 🚀 2. ระบบจัดการเอฟเฟกต์ (APPLY & TOGGLE)
-- ==========================================
function VFXManager.Apply(zoneName, effectName, effectModule)
    local player = Players.LocalPlayer
    local char = player.Character
    if not char then return end
    
    -- 🛑 ระบบ Toggle: เช็คว่ามีอยู่แล้วหรือไม่ ถ้ามี = ลบออก (ปิดการทำงาน)
    if char:FindFirstChild(effectName) then
        char[effectName]:Destroy()
        return 
    end

    -- 🎯 ค้นหาชิ้นส่วนร่างกายผ่านระบบ Mapping ด้านบน
    local targetPart = GetBodyPart(char, zoneName)
    if not targetPart then 
        warn("[VFX Manager] เกิดข้อผิดพลาด: หาชิ้นส่วน '" .. tostring(zoneName) .. "' ไม่พบในตัวละครนี้")
        return 
    end 

    -- 📦 สร้าง Part ล่องหน เพื่อเป็นฐานให้เอฟเฟกต์มาเกาะ
    local container = Instance.new("Part")
    container.Name = effectName 
    container.Size = Vector3.new(0.1, 0.1, 0.1)
    container.Transparency = 1
    container.CanCollide = false
    container.Massless = true
    container.CFrame = targetPart.CFrame
    container.Parent = char

    -- 🔗 เชื่อมฐานเข้ากับอวัยวะเป้าหมาย
    local weld = Instance.new("WeldConstraint", container)
    weld.Part0 = targetPart
    weld.Part1 = container
    
    -- 📌 สร้าง Attachment ที่เป็นจุดเกิดของ Particle
    local att = Instance.new("Attachment", container)
    
    -- ✨ นำโค้ดเอฟเฟกต์มารัน โดยจับใส่ Attachment ที่เตรียมไว้
    if type(effectModule) == "function" then
        effectModule(att)
    end
end

return VFXManager