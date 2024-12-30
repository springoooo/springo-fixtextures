local isFixingTextures = false 

RegisterNetEvent('springo-fixtextures:client', function()
    if isFixingTextures then return end 

    isFixingTextures = true
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicles = {}
    local peds = {}

    if IsPedInAnyVehicle(playerPed, false) then
        lib.notify({
            title = "Error",
            description = "You must exit your vehicle before using this command.",
            type = "error"
        })
        isFixingTextures = false
        return
    end

    local nearbyPlayers = false 
    local players = GetActivePlayers()
    for _, player in ipairs(players) do 
        if player ~= PlayerId() then 
            local targetPed = GetPlayerPed(player)
            local targetCoords = GetEntityCoords(targetPed)
            if #(targetCoords - coords) <= 25.0 then 
                nearbyPlayers = true 
                break 
            end 
        end 
    end 

    lib.notify({
        title = "Fixing Textures",
        description = "Reloading your game world. Please wait...",
        type = "info"
    })

    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Wait(100)
    end

    local radius = 50.0
    local handle, vehicle = FindFirstVehicle()
    local success
    repeat
        if DoesEntityExist(vehicle) then
            local vehicleCoords = GetEntityCoords(vehicle)
            if #(vehicleCoords - coords) <= radius then
                local vehicleData = {
                    handle = vehicle,
                    coords = vehicleCoords,
                    heading = GetEntityHeading(vehicle)
                }
                table.insert(vehicles, vehicleData)
            end
        end
        success, vehicle = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)

    handle, ped = FindFirstPed()
    success = true
    repeat
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then 
            local pedCoords = GetEntityCoords(ped)
            if #(pedCoords - coords) <= radius then
                local pedData = {
                    handle = ped,
                    coords = pedCoords,
                    heading = GetEntityHeading(ped)
                }
                table.insert(peds, pedData)
            end
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)

    local farAwayCoords = vector3(10000.0, 10000.0, 1000.0) 
    SetEntityCoordsNoOffset(playerPed, farAwayCoords.x, farAwayCoords.y, farAwayCoords.z, false, false, false)

    Wait(5000)

    SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z, false, false, false)

    for _, vehicleData in pairs(vehicles) do
        if DoesEntityExist(vehicleData.handle) then
            SetEntityCoordsNoOffset(vehicleData.handle, vehicleData.coords.x, vehicleData.coords.y, vehicleData.coords.z, false, false, false)
            SetEntityHeading(vehicleData.handle, vehicleData.heading)
            SetVehicleOnGroundProperly(vehicleData.handle)
            FreezeEntityPosition(vehicleData.handle, false) 
            SetEntityAsNoLongerNeeded(vehicleData.handle) 
        end
    end

    for _, pedData in pairs(peds) do
        if DoesEntityExist(pedData.handle) then
            SetEntityCoordsNoOffset(pedData.handle, pedData.coords.x, pedData.coords.y, pedData.coords.z, false, false, false)
            SetEntityHeading(pedData.handle, pedData.heading)
            FreezeEntityPosition(pedData.handle, false) 
            SetEntityAsNoLongerNeeded(pedData.handle) 
        end
    end

    local unfrozenradius = 60.0 
    local unfrozenplayerCoords = GetEntityCoords(PlayerPedId())
    local unfrozenvehicles = GetGamePool('CVehicle')

    DoScreenFadeIn(1000)
    while not IsScreenFadedIn() do
        Wait(100)
    end

    lib.notify({
        title = "Textures Fixed",
        description = "Your game world has been reloaded successfully.",
        type = "success"
    })

    isFixingTextures = false 
end)

RegisterNetEvent('springo-fixtextures:cooldownnotification', function(timeLeft)
    lib.notify({
        title = "Cooldown Active",
        description = "You must wait " .. timeLeft .. " seconds before using this command again.",
        type = "error"
    })
end)

