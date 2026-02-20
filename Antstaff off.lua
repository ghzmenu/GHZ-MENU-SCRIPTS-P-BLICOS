if _G._ANTSTAFFLoop then
    pcall(function() _G._ANTSTAFFLoop:Disconnect() end)
    _G._ANTSTAFFLoop = nil
end
print("ANTSTAFF desativado.")
