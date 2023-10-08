--[[
───────────────────────────────────────────────────────────────

	Extra Changer Menu (menu.lua) - Created by Shadow Development
	
	Website: https://shadowdevs.com
    Discord: https://shadowdevs.com/discord

    DO NOT TOUCH THE CODE IF YOU DO NOT KNOW WHAT YOU ARE DOING!!
    If you do modify the code, and you want to reupload your version 
        contact Shadow Development first via Discord or our contact form on the website.

───────────────────────────────────────────────────────────────
]] 
_menuPool = NativeUI.CreatePool()
local menuOpen = false

local MenuOri = 0
if Config.MenuOrientation == 0 then
    MenuOri = 0
elseif Config.MenuOrientation == 1 then
    MenuOri = 1320
else
    MenuOri = 0
end

local MenuTitle = ''
if Config.MenuTitle == 0 then
    MenuTitle = 'Extras Menu'
elseif Config.MenuTitle == 1 then
    local ped = GetPlayerPed(-1)
    MenuTitle = GetPlayerName(ped)
elseif Config.MenuTitle == 2 then
    MenuTitle = Config.MenuTitleCustom
else
    MenuTitle = 'Extras Menu'
end

function AreVehicleDoorsClosed(vehicle)
    local result = true
    local numberOfDoors = GetNumberOfVehicleDoors(vehicle)
    for i = 0, numberOfDoors, 1 do
        if GetVehicleDoorAngleRatio(vehicle, i) > 0.0 then
            result = false
        end
    end
    return result
end

function IsVehicleHealthy(vehicle)
    local vehHealth = GetVehicleBodyHealth(vehicle)

    if vehHealth > Config.DamageLimit then
        return true
    else
        return false
    end
end

function find_index(tbl, target)
    for i, v in ipairs(tbl) do
        if v == target then
            return i
        end
    end
    return nil
end


function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function ExtraChanger(ped, vehicle, menu)
    local veh_extras = {}
    local items = {}

    for extraID = 0, 20 do
        if DoesExtraExist(vehicle, extraID) then
            veh_extras[extraID] = (IsVehicleExtraTurnedOn(vehicle, extraID) == 1)
        end
    end

    local customCar = false

    for _,CustomExtra in pairs(Config.CustomNames) do
        for k,_ in pairs(veh_extras) do
            if GetEntityModel(vehicle) == GetHashKey(CustomExtra.vehicle) then
                x = "" .. k .. ""
                local extraItem
                if CustomExtra.extra[x] == nil then
                    extraItem = NativeUI.CreateCheckboxItem('Extra ' .. k, veh_extras[k],
                            "Toggle for Extra " .. k)
                else
                    extraItem = NativeUI.CreateCheckboxItem(CustomExtra.extra[x], veh_extras[k],
                        "Toggle for " .. CustomExtra.extra[x] .. " | Extra #" .. k)
                end
                mainMenu:AddItem(extraItem)
                items[k] = extraItem
                customCar = true
            end
        end
    end

    if customCar == false then
        for k,_ in pairs(veh_extras) do
            local extraItem = NativeUI.CreateCheckboxItem('Extra ' .. k, veh_extras[k],
                    "Toggle for Extra " .. k)
            mainMenu:AddItem(extraItem)
            items[k] = extraItem
        end
    end

    mainMenu.OnCheckboxChange = function(sender, item, checked)
        if not AreVehicleDoorsClosed(vehicle) then 
            return ShowNotification("Vehicle extras can not be changed while doors are open. (It would force close doors.)") 
        end
        
        if Config.DamageStopper then
            if not IsVehicleHealthy(vehicle) then 
                return ShowNotification("Vehicle extras can not be changed while vehicle is damaged. See a mechanic before changing extras.") 
            end

            for k, v in pairs(items) do
                if item == v then
                    veh_extras[k] = checked
                    if veh_extras[k] then
                        SetVehicleExtra(vehicle, k, 0)
                    else
                        SetVehicleExtra(vehicle, k, 1)
                    end
                end
            end

            SetVehicleDeformationFixed(vehicle)
            SetVehicleAutoRepairDisabled(vehicle, false)
        else
            SetVehicleAutoRepairDisabled(vehicle, false)
            for k, v in pairs(items) do
                if item == v then
                    veh_extras[k] = checked
                    if veh_extras[k] then
                        SetVehicleExtra(vehicle, k, 0)
                    else
                        SetVehicleExtra(vehicle, k, 1)
                    end
                end
            end
        end
    end
end

function LiveryChanger(ped, vehicle, menu)
    local veh_liveries = {}
    local custveh_liveries = {}
    local customveh = false

    for _,CustomLivery in pairs(Config.CustomLiveryNames) do
        for i = 0, GetVehicleLiveryCount(vehicle)-1 do
            if GetEntityModel(vehicle) == GetHashKey(CustomLivery.vehicle) then
                if CustomLivery.livery[i] == nil then
                    table.insert(veh_liveries, "Livery #" .. i)
                    custveh_liveries[i] = "Livery #" .. i
                else
                    table.insert(veh_liveries, CustomLivery.livery[i])
                    custveh_liveries[i] = CustomLivery.livery[i]
                end
                customveh = true
            else
                table.insert(veh_liveries, "Livery #" .. i)
            end
        end
    end

    local liveryList
    if customveh then
        liveryList = NativeUI.CreateListItem('Livery Charger', veh_liveries, find_index(veh_liveries, custveh_liveries[GetVehicleLivery(vehicle)]), "Change the Vehicle's Livery")
    else
        liveryList = NativeUI.CreateListItem('Livery Charger', veh_liveries, find_index(veh_liveries, "Livery #"..GetVehicleLivery(vehicle)), "Change the Vehicle's Livery")
    end
    menu:AddItem(liveryList)

    menu.OnListChange = function(sender, item, index)
        if item == liveryList then
            SetVehicleLivery(vehicle, index-1)
        end
    end
end

function CreditsSection(ped, vehicle, menu)
    local submenu = _menuPool:AddSubMenu(menu, "Menu Info / Credits",
        "Information about the ~y~Extra Menu ~w~and the creators.", true, true)
    submenu:AddItem(NativeUI.CreateItem("Menu Information",
        "The ~y~Extra Menu ~w~was created to make changing extras easier, and to allow custom names for extras."))
    submenu:AddItem(NativeUI.CreateItem("Creators Information",
        "This menu was created by ~c~Shadow Development~w~."))
    submenu:AddItem(NativeUI.CreateItem("Links", "~o~shadowdevs.com ~w~| ~b~https://discord.gg/shadowdevs"))
    submenu:SetMenuWidthOffset(Config.MenuWidth)
end

function openMenu(ped, vehicle)
    if mainMenu ~= nil and mainMenu:Visible() then
        mainMenu:Visible(false)
        return
    end
    mainMenu = NativeUI.CreateMenu(MenuTitle, "~b~The easy way to change extras!", MenuOri)
    _menuPool:Add(mainMenu)
    ExtraChanger(ped, vehicle, mainMenu)
    if Config.enableLivery then
        LiveryChanger(ped, vehicle, mainMenu)
    end
    if Config.EnableCredits then
        CreditsSection(ped, vehicle, mainMenu)
    end

    mainMenu:SetMenuWidthOffset(Config.MenuWidth)

    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled(false);
    _menuPool:MouseEdgeEnabled(false);
    _menuPool:ControlDisablingEnabled(false);
end

Citizen.CreateThread(function()
    while true do
        if Config.locationOpen == false then
            Citizen.Wait(0)
            _menuPool:ProcessMenus()
            local ped = GetPlayerPed(-1)
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if IsControlJustPressed(1, Config.MenuKey) and not menuOpen and not Config.commandOnly then
                if TriggerServerEvent("extramenu.getIsAllowed") ~= 1 and Config.requirePerms then
                    return ShowNotification('~r~You do not have the correct permissions to open this menu.')
                end

                menuOpen = true
                if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(vehicle, -1) == ped then
                    openMenu(ped, vehicle)
                    mainMenu:Visible(not mainMenu:Visible())
                end
            elseif IsControlJustPressed(1, Config.MenuKey) and menuOpen and not Config.commandOnly then
                menuOpen = false
                if mainMenu ~= nil and mainMenu:Visible() then
                    mainMenu:Visible(false)
                end
            end
        end

        if Config.locationOpen == true then
            Citizen.Wait(5)
            local player = GetPlayerPed(-1)
            local playerLoc = GetEntityCoords(player)

            for _, location in ipairs(Config.positions) do
                teleport_text = location[3]
                loc = {
                    x = location[1][1],
                    y = location[1][2],
                    z = location[1][3],
                    heading = location[1][4]
                }
                Red = location[2][1]
                Green = location[2][2]
                Blue = location[2][3]

                DrawMarker(1, loc.x, loc.y, loc.z, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, Red, Green, Blue, 200, 0, 0,
                    0, 0)

                if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc.x, loc.y, loc.z, 2) then
                    alert(teleport_text)
                    _menuPool:ProcessMenus()
                    local ped = GetPlayerPed(-1)
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    if IsControlJustPressed(1, Config.MenuKey) then
                        if TriggerServerEvent("extramenu.getIsAllowed") ~= 1 and Config.requirePerms then
                            return ShowNotification('~r~You do not have the correct permissions to open this menu.')
                        end

                        if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(vehicle, -1) == ped then
                            openMenu(ped, vehicle)
                            mainMenu:Visible(not mainMenu:Visible())
                        end
                    end
                end
            end
        end

        if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
            if mainMenu ~= nil and mainMenu:Visible() then
                mainMenu:Visible(false)
                menuOpen = false
            end
        end
    end
end)

if Config.commandOpen then
    RegisterCommand(Config.command, function(source, args)
        _menuPool:ProcessMenus()
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if not menuOpen then
            if TriggerServerEvent("extramenu.getIsAllowed") ~= 1 and Config.requirePerms then
                return ShowNotification('~r~You do not have the correct permissions to open this menu.')
            end
            
            menuOpen = true
            if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(vehicle, -1) == ped then
                openMenu(ped, vehicle)
                mainMenu:Visible(not mainMenu:Visible())
            end
        elseif menuOpen then
            menuOpen = false
            if mainMenu ~= nil and mainMenu:Visible() then
                mainMenu:Visible(false)
            end
        end
    end, false)
end

RegisterNetEvent("extramenu.returnIsAllowed")
AddEventHandler("extramenu.returnIsAllowed", function(isAllowed)
    allowedToUse = isAllowed
end)

if Config.locationOpen == true then
    function CheckPos(x, y, z, cx, cy, cz, radius)
        local t1 = x - cx
        local t12 = t1 ^ 2

        local t2 = y - cy
        local t21 = t2 ^ 2

        local t3 = z - cz
        local t31 = t3 ^ 2

        return (t12 + t21 + t31) <= radius ^ 2
    end

    function alert(msg)
        SetTextComponentFormat("STRING")
        AddTextComponentString("~"..keys[Config.MenuKey].."~ | ~w~"..msg)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end
end

CreateThread(function()
    while true do Wait(1000)
        local vehicles = GetGamePool("CVehicle")
        for _, v in pairs(vehicles) do
            if v ~= GetVehiclePedIsIn(PlayerPedId(), false) then
                SetVehicleAutoRepairDisabled(v, true)
            else
                SetVehicleAutoRepairDisabled(v, false)
            end
        end
    end
end)