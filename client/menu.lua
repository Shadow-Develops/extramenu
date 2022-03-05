--[[
───────────────────────────────────────────────────────────────

	Extra Changer Menu (menu.lua) - Created by Shadow Development
	
	Website: https://shadowdevs.com
    Discord: https://discord.shadowdevs.com

    DO NOT TOUCH THE CODE IF YOU DO NOT KNOW WHAT YOU ARE DOING!!
    If you do modify the code, and you want to reupload your version 
        contact Shadow Development first via Discord or our contact form on the website.

───────────────────────────────────────────────────────────────
]] 
_menuPool = NativeUI.CreatePool()

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
                local extraItem = NativeUI.CreateCheckboxItem(CustomExtra.extra[x], veh_extras[k],
                    "Toggle for " .. CustomExtra.extra[x] .. " | Extra #" .. k)
                mainMenu:AddItem(extraItem)
                items[k] = extraItem
                customCar = true
            end
        end
    end

    if customCar == false then
        for _,CustomExtra in pairs(Config.CustomNames) do
            for k,_ in pairs(veh_extras) do
                local extraItem = NativeUI.CreateCheckboxItem('Extra ' .. k, veh_extras[k],
                        "Toggle for Extra " .. k)
                mainMenu:AddItem(extraItem)
                items[k] = extraItem
            end
        end
    end

    mainMenu.OnCheckboxChange = function(sender, item, checked)
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

function CreditsSection(ped, vehicle, menu)
    local submenu = _menuPool:AddSubMenu(menu, "Menu Info / Credits",
        "Information about the ~y~Extra Menu ~w~and the creators.", true, true)
    submenu:AddItem(NativeUI.CreateItem("Menu Information",
        "The ~y~Extra Menu ~w~was created to make changing extras easier, and to allow for custom names to be added for extras for custom vehicles in servers."))
    submenu:AddItem(NativeUI.CreateItem("Creators Information",
        "This menu was created by ~r~Agent Squad Productions~w~."))
    submenu:AddItem(NativeUI.CreateItem("Links", "~o~agentsquad.org ~w~| ~b~discord.agentsquad.org"))
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
            if IsControlJustReleased(1, Config.MenuKey) then
                if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(vehicle, -1) == ped then
                    openMenu(ped, vehicle)
                    mainMenu:Visible(not mainMenu:Visible())
                end
            end

            if IsPedInAnyVehicle(ped, false) == false then
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
                    if IsControlJustReleased(1, Config.MenuKey) then
                        if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(vehicle, -1) == ped then
                            openMenu(ped, vehicle)
                            mainMenu:Visible(not mainMenu:Visible())
                        end
                    end

                    if IsPedInAnyVehicle(ped, false) == false then
                        if mainMenu ~= nil and mainMenu:Visible() then
                            mainMenu:Visible(false)
                        end
                    end
                end
            end
        end
    end
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
