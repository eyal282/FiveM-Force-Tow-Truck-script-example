
-- Force towtruck attachment

Citizen.CreateThread(function()
	while true do
		
		local ped = GetPlayerPed(-1)
		
		local pedVehicle = GetVehiclePedIsIn(ped, false)
		
		if(pedVehicle ~= 0 and GetPedInVehicleSeat(pedVehicle, -1) == ped) then
			
			local vehicle = GetEntityAttachedToTowTruck(pedVehicle)
			
			if vehicle ~= 0 and vehicle ~= nil then
				
				SetNetworkIdCanMigrate(VehToNet(pedVehicle), true)
				SetNetworkIdCanMigrate(VehToNet(vehicle), true)
				
				while not NetworkHasControlOfEntity(vehicle) do
					NetworkRequestControlOfEntity(vehicle)
					
					Citizen.Wait(500)
					
				end
				
				while not NetworkHasControlOfEntity(pedVehicle) do
					NetworkRequestControlOfEntity(pedVehicle)
					
					Citizen.Wait(500)
				end
				
				SetNetworkIdCanMigrate(VehToNet(pedVehicle), false)
				SetNetworkIdCanMigrate(VehToNet(vehicle), false)
				
				AttachVehicleToTowTruck(pedVehicle, vehicle, true, 0.0, 0.0, 0.0)
				
				if IsControlPressed(1, 104) then
					DetachVehicleFromTowTruck(pedVehicle, vehicle)
				end
			end
		end
		Citizen.Wait(100)
	end
end)
