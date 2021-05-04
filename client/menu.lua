--[[
───────────────────────────────────────────────────────────────

	Extra Changer Menu (menu.lua) - Created by Agent Squad Prodcutions
	
	Website: https://agentsquad.org
    Discord: https://discord.agentsquad.org

    DO NOT TOUCH THE CODE IF YOU DO NOT KNOW WHAT YOU ARE DOING!!
    If you do modify the code, and you want to reupload your version 
        contact ASP first via Discord or our contact form on the website.

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
	local veh_extras = {['vehicleExtras'] = {}}
    local items = {['vehicle'] = {}}
    
	for extraID = 0, 20 do
        if DoesExtraExist(vehicle, extraID) then
            veh_extras.vehicleExtras[extraID] = (IsVehicleExtraTurnedOn(vehicle, extraID) == 1)
        end
    end

    for _, CustomExtra in pairs(Config.CustomNames) do
        for k, v in pairs(veh_extras.vehicleExtras) do
            if GetEntityModel(vehicle) == GetHashKey(CustomExtra.vehicle) then
                x = ""..k..""
                local extraItem = NativeUI.CreateCheckboxItem(CustomExtra.extra[x], veh_extras.vehicleExtras[k],"Toggle for "..CustomExtra.extra[x].." | Extra #"..k)
                mainMenu:AddItem(extraItem)
                items.vehicle[k] = extraItem 
            else
                local extraItem = NativeUI.CreateCheckboxItem('Extra ' .. k, veh_extras.vehicleExtras[k],"Toggle for Extra "..k)
                mainMenu:AddItem(extraItem)
                items.vehicle[k] = extraItem
            end
        end 
    end
    
    mainMenu.OnCheckboxChange = function(sender, item, checked)
        for k, v in pairs(items.vehicle) do
            if item == v then
                veh_extras.vehicleExtras[k] = checked
                if veh_extras.vehicleExtras[k] then
                    SetVehicleExtra(vehicle, k, 0)
                else
                    SetVehicleExtra(vehicle, k, 1)
                end
            end
        end
    end
end

function CreditsSection(ped, vehicle, menu)
    local submenu = _menuPool:AddSubMenu(menu, "Menu Info / Credits", "Information about the ~y~Extra Menu ~w~and the creators.", true, true)
    submenu:AddItem(NativeUI.CreateItem(
        "Menu Information", "The ~y~Extra Menu ~w~was created to make changing extras easier, and to allow for custom names to be added for extras for custom vehicles in servers."
    ))
    submenu:AddItem(NativeUI.CreateItem(
        "Creators Information", "This menu was created by ~r~Agent Squad Productions~w~."
    ))
    submenu:AddItem(NativeUI.CreateItem(
        "Links", "~o~agentsquad.org ~w~| ~b~discord.agentsquad.org"
    ))
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
    _menuPool:MouseControlsEnabled (false);
	_menuPool:MouseEdgeEnabled (false);
	_menuPool:ControlDisablingEnabled(false);
end

Citizen.CreateThread(function()
    while true do
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
end)