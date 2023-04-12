RegisterServerEvent("extramenu.getIsAllowed")
AddEventHandler("extramenu.getIsAllowed", function()
    if IsPlayerAceAllowed(source, "use.ExtraMenu") then
        TriggerClientEvent("extramenu.returnIsAllowed", source, true)
    else
        TriggerClientEvent("extramenu.returnIsAllowed", source, false)
    end
end)