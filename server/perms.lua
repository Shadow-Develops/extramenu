RegisterServerEvent("extramenu.getIsAllowed")
AddEventHandler("extramenu.getIsAllowed", function()
    return IsPlayerAceAllowed(source, "use.ExtraMenu")
end)