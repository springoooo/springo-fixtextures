local cooldowns = {}

lib.addCommand('fixtextures', {
    help = 'Fix texture issues by reloading the world around you.',
    restricted = false 
}, function(source, args, raw)
    local playerId = source

    if cooldowns[playerId] and cooldowns[playerId] > os.time() then
        local timeLeft = cooldowns[playerId] - os.time()
        TriggerClientEvent('springo-fixtextures:cooldownnotification', playerId, timeLeft)
        return
    end

    cooldowns[playerId] = os.time() + 30

    TriggerClientEvent('springo-fixtextures:client', playerId)
end)
