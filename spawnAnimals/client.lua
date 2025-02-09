local activeZones = {}

-- Создание зон
Citizen.CreateThread(function()
    for i, zone in ipairs(Config.Zones) do
        local poly = CircleZone:Create(zone.center, zone.radius, {
            name = zone.name,
            debugPoly = true
        })

        poly:onPlayerInOut(function(isPointInside)
            if isPointInside then
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local playerHeading = GetEntityHeading(playerPed)
                TriggerServerEvent('spawnAnimals:requestSpawn', zone.name, playerCoords, playerHeading)
            end
        end)

        activeZones[zone.name] = poly
    end
end)

-- Отслеживание смерти кабанов
RegisterNetEvent('spawnAnimals:trackBoar', function(netId)
    Citizen.CreateThread(function()
        local boar = NetworkGetEntityFromNetworkId(netId)
        local attempts = 0

        -- Ожидание синхронизации сущности
        while not DoesEntityExist(boar) and attempts < 10 do
            Citizen.Wait(500) -- Ожидание 0.5 секунды
            boar = NetworkGetEntityFromNetworkId(netId)
            attempts = attempts + 1
        end

        if DoesEntityExist(boar) then
            while DoesEntityExist(boar) do
                Citizen.Wait(1000) -- Проверка каждую секунду

                if IsEntityDead(boar) then
                    -- Отправляем событие на сервер о смерти кабана
                    TriggerServerEvent('spawnAnimals:boarDied', netId)
                    break
                end
            end
        else
            print("Кабан с NetID " .. netId .. " не найден или не синхронизирован.")
        end
    end)
end)