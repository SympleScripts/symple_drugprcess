local weedTypes = {
    'ls_plain_jane_bag',
    'ls_banana_kush_bag',
    'ls_blue_dream_bag',
    'ls_purple_haze_bag',
    'ls_orange_crush_bag',
    'ls_cosmic_kush_bag'
}

lib.callback.register('convert_drugs:check', function(source)
    local weedBrick = exports.ox_inventory:Search(source, 'count', 'weed_brick')
    local cokeBrick = exports.ox_inventory:Search(source, 'count', 'coke_brick')
    local heroinBrick = exports.ox_inventory:Search(source, 'count', 'heroin_brick')
    local methBrick = exports.ox_inventory:Search(source, 'count', 'kq_meth_brick')
    
    if weedBrick > 0 or cokeBrick > 0 or heroinBrick > 0 or methBrick > 0 then
        return true
    else
        lib.notify(source, {
            title = 'Error',
            description = 'You do not have any bricks to convert.',
            type = 'error'
        })
        return false
    end
end)

RegisterNetEvent('convert_drugs:process', function(selected)
    local source = source
    local converted = false

    if selected == 'weed' then
        local weedBrick = exports.ox_inventory:Search(source, 'count', 'weed_brick')
        if weedBrick > 0 then
            if exports.ox_inventory:RemoveItem(source, 'weed_brick', 1) then
                local totalBags = 500
                while totalBags > 0 do
                    local randomType = weedTypes[math.random(#weedTypes)]
                    local randomAmount = math.random(1, math.min(totalBags, 250))
                    exports.ox_inventory:AddItem(source, randomType, randomAmount)
                    totalBags = totalBags - randomAmount
                end
                converted = true
            end
        end
    elseif selected == 'coke' then
        local cokeBrick = exports.ox_inventory:Search(source, 'count', 'coke_brick')
        if cokeBrick > 0 then
            if exports.ox_inventory:RemoveItem(source, 'coke_brick', 1) then
                exports.ox_inventory:AddItem(source, 'cocaine_baggy', 250)
                converted = true
            end
        end
    elseif selected == 'heroin' then
        local heroinBrick = exports.ox_inventory:Search(source, 'count', 'heroin_brick')
        if heroinBrick > 0 then
            if exports.ox_inventory:RemoveItem(source, 'heroin_brick', 1) then
                exports.ox_inventory:AddItem(source, 'heroin_7g', 150)
                converted = true
            end
        end
    elseif selected == 'meth' then
        local methBrick = exports.ox_inventory:Search(source, 'count', 'kq_meth_brick')
        if methBrick > 0 then
            if exports.ox_inventory:RemoveItem(source, 'kq_meth_brick', 1) then
                exports.ox_inventory:AddItem(source, 'kq_meth_high', 250)
                converted = true
            end
        end
    end

    if converted then
        lib.notify(source, {
            title = 'Success',
            description = 'Order picked up successfully!',
            type = 'success'
        })
    else
        lib.notify(source, {
            title = 'Error',
            description = 'You no longer have the required items.',
            type = 'error'
        })
    end
end)