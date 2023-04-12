local label =
  [[
  //
  ||       ______      _               __  __
  ||      |  ____|    | |             |  \/  |
  ||      | |__  __  _| |_ _ __ __ _  | \  / | ___ _ __  _   _ 
  ||      |  __| \ \/ / __| '__/ _` | | |\/| |/ _ \ '_ \| | | |
  ||      | |____ >  <| |_| | | (_| | | |  | |  __/ | | | |_| |
  ||      |______/_/\_\\__|_|  \__,_| |_|  |_|\___|_| |_|\__,_|
  ||
  ||             Shadow Development (^5shadowdevs.com^7)
  ||]]

Citizen.CreateThread(function()
	local CurrentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
	if not CurrentVersion then
		print('^1Extra Menu Version Check Failed!^7')
	end

	function VersionCheckHTTPRequest()
		PerformHttpRequest('https://raw.githubusercontent.com/Shadow-Develops/version-api/main/extramenu.json', VersionCheck, 'GET')
	end

	function VersionCheck(err, response, _)
		Citizen.Wait(3000)
		if err == 200 then
			local Data = json.decode(response)
			if CurrentVersion ~= Data.version then
				print( label )
				print('  ||    \n  ||    Extra Menu is outdated!')
				print('  ||    Current version: ^2' .. Data.version .. '^7')
				print('  ||    Your version: ^1' .. CurrentVersion .. '^7')
				print('  ||    Please download the lastest version from ^5https://github.com/Shadow-Develops/extramenu/releases ^7')
				if Data.Changes ~= '' then
					print('  ||    \n  ||    ^5Changes: ^7' .. Data.changes .. "\n^0  \\\\\n")
				end
			else
				print( label )
				print('  ||    ^2Extra Menu is up to date! Good job!\n^0  ||\n  \\\\\n')
			end
		else
			print( label )
			print('  ||    ^1There was an error getting the latest version information!    ||\n  \\\\\n')
		end

		SetTimeout(60000000, VersionCheckHTTPRequest)
	end

	VersionCheckHTTPRequest()
end)
