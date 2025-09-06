local pedSpawnPoint = vec3(280.61, -973.19, 29.42)
local processingPoint = vec3(279.78, -974.34, 29.42)
local pedModel = "ig_omega"
local createdPed = nil
local isProcessing = false
local originalPedCoords = nil
local currentDrugType = nil

function addConvertDrugsTarget()
    exports.ox_target:removeModel(pedModel, 'pickup_order')

    exports.ox_target:addModel(pedModel, {
        {
            name = 'convert_drugs',
            icon = 'fas fa-cannabis',
            label = 'You got Bricks or What',
            distance = 2.0,
            onSelect = function()
                local itemCount = exports.ox_inventory:Search('count', 'coffee_club')

                if itemCount < 1 then
                    lib.notify({type = 'error', description = 'You are not authorized to be here.'})
                    return
                end

                if isProcessing then
                    lib.notify({type = 'error', description = 'The dealer is currently busy processing an order'})
                    return
                end
                
                local success = lib.callback.await('convert_drugs:check', false)
                if success then
                    local menu = {
                        id = 'drug_conversion_menu',
                        title = 'Drug Conversion Menu',
                        options = {
                            {
                                title = 'Convert Weed Brick',
                                description = 'Break down a brick into smaller bags',
                                icon = 'cannabis',
                                onSelect = function()
                                    processDrug('weed')
                                end
                            },
                            {
                                title = 'Convert Cocaine Brick',
                                description = 'Break down a brick into smaller bags',
                                icon = 'pills',
                                onSelect = function()
                                    processDrug('coke')
                                end
                            },
                            {
                                title = 'Convert Heroin Brick',
                                description = 'Break down a brick into smaller bags',
                                icon = 'pills',
                                onSelect = function()
                                    processDrug('heroin')
                                end
                            },
                            {
                                title = 'Convert Meth Brick',
                                description = 'Break down a brick into smaller bags',
                                icon = 'pills',
                                onSelect = function()
                                    processDrug('meth')
                                end
                            },
                        }
                    }

                    lib.registerContext(menu)
                    lib.showContext('drug_conversion_menu')
                end
            end,
            anim = {
                dict = "mp_common",
                clip = "givetake1_a",
                flag = 1
            },
        }
    })
end

CreateThread(function()
    print('Client: Resource starting')
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(0)
    end

    local _, groundZ = GetGroundZFor_3dCoord(pedSpawnPoint.x, pedSpawnPoint.y, pedSpawnPoint.z, false)
    pedSpawnPoint = vec3(pedSpawnPoint.x, pedSpawnPoint.y, groundZ)

    local _, processGroundZ = GetGroundZFor_3dCoord(processingPoint.x, processingPoint.y, processingPoint.z, false)
    processingPoint = vec3(processingPoint.x, processingPoint.y, processGroundZ)
   
    createdPed = CreatePed(4, pedModel, pedSpawnPoint.x, pedSpawnPoint.y, pedSpawnPoint.z, 0.0, false, true)
    SetEntityHeading(createdPed, 0.0)
    FreezeEntityPosition(createdPed, true)
    SetEntityInvincible(createdPed, true)
    SetBlockingOfNonTemporaryEvents(createdPed, true)
    
    originalPedCoords = pedSpawnPoint
   
    addConvertDrugsTarget()
end)

function processDrug(drugType)
    isProcessing = true
    currentDrugType = drugType
    exports.ox_target:removeModel(pedModel, 'convert_drugs')
    print("Starting processDrug for: " .. drugType)
    
    CreateThread(function()
        ClearPedTasks(createdPed)
        FreezeEntityPosition(createdPed, false)
        
        TaskGoStraightToCoord(createdPed, processingPoint.x, processingPoint.y, processingPoint.z, 1.0, -1, 180.0, 0.1)
        
        local timeout = 0
        while GetScriptTaskStatus(createdPed, 2106541073) ~= 7 and timeout < 150 do
            Wait(100)
            timeout = timeout + 1
        end
        
        if GetScriptTaskStatus(createdPed, 2106541073) ~= 7 then
             SetEntityCoords(createdPed, processingPoint.x, processingPoint.y, processingPoint.z, false, false, false, true)
             SetEntityHeading(createdPed, 180.0)
        end
        
        RequestAnimDict("anim@amb@business@coc@coc_unpack_cut_left@")
        while not HasAnimDictLoaded("anim@amb@business@coc@coc_unpack_cut_left@") do
            Wait(0)
        end
        
        TaskPlayAnim(createdPed, "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_v1_coccutter", 8.0, -8.0, -1, 1, 0, false, false, false)
        
        if lib.progressBar({
            duration = 15000,
            label = 'Processing order...',
            useWhileDead = false,
            canCancel = true,
        }) then
            ClearPedTasks(createdPed)
            
            TaskGoStraightToCoord(createdPed, originalPedCoords.x, originalPedCoords.y, originalPedCoords.z, 1.0, -1, 0.0, 0.1)
            
            timeout = 0
            while GetScriptTaskStatus(createdPed, 2106541073) ~= 7 and timeout < 150 do
                Wait(100)
                timeout = timeout + 1
            end

            SetEntityCoords(createdPed, originalPedCoords.x, originalPedCoords.y, originalPedCoords.z, false, false, false, true)
            SetEntityHeading(createdPed, 0.0)
            FreezeEntityPosition(createdPed, true)
            
            print("Ped returned to spawn point")
            createPickupTarget()
        else
            ClearPedTasks(createdPed)
            SetEntityCoords(createdPed, originalPedCoords.x, originalPedCoords.y, originalPedCoords.z, false, false, false, true)
            SetEntityHeading(createdPed, 0.0)
            FreezeEntityPosition(createdPed, true)
            isProcessing = false
            addConvertDrugsTarget()
        end
    end)
end

function createPickupTarget()
    exports.ox_target:removeModel(pedModel, 'convert_drugs')

    exports.ox_target:addModel(pedModel, {
        {
            name = 'pickup_order',
            icon = 'fas fa-hand-paper',
            label = 'Pick up your order',
            distance = 2.0,
            onSelect = function()
                TriggerServerEvent('convert_drugs:process', currentDrugType)
                isProcessing = false

                exports['ps-dispatch']:SuspiciousActivity()

                addConvertDrugsTarget()
            end
        }
    })
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() and createdPed then
        DeleteEntity(createdPed)
    end
end)