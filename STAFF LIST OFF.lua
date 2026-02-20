-- Remove a Interface STAFF LIST e desconecta os eventos

if _G._StaffListGui then
    pcall(function() _G._StaffListGui:Destroy() end)
    _G._StaffListGui = nil
end

if _G._StaffList_Con then
    pcall(function() _G._StaffList_Con:Disconnect() end)
    _G._StaffList_Con = nil
end

if _G._StaffList_DragCon then
    pcall(function() _G._StaffList_DragCon:Disconnect() end)
    _G._StaffList_DragCon = nil
end

print("STAFF LIST desativada e removida!")
