

function DrawText3dNew(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end


-- Guide message on tow truck arm

CreateThread(function()

	local towTruckHash = GetHashKey("towtruck")
	while true do
		local ped = GetPlayerPed(-1)
		
		local pedVehicle = GetVehiclePedIsIn(ped, false)
		
		if(pedVehicle ~= 0 and GetPedInVehicleSeat(pedVehicle, -1) == ped) then
			local vehicle = GetEntityAttachedToTowTruck(pedVehicle)
			
			
					
			if vehicle == 0 then
				local bTowTruck = IsVehicleTowTruck(pedVehicle)
				
				if bTowTruck then
					local pedVehiclePos = GetEntityCoords(pedVehicle, true)
					
					if GetEntityAttachedToTowTruck(pedVehicle) ~= 0 then
						DrawText3dNew(pedVehiclePos.x, pedVehiclePos.y, pedVehiclePos.z+3.08, "~c~Hold ~b~\"H\"~c~ to detach.\n~c~Drive to purple mark to impound.")
					else
						DrawText3dNew(pedVehiclePos.x, pedVehiclePos.y, pedVehiclePos.z+3.08, "~c~Hold ~b~\"Num5\"~c~ to lower the crane.\n~c~Hold ~b~\"Num8\"~c~ to raise the crane.")
					end
				end
			end
		end
		
		Citizen.Wait(0)
	end
end)
-- Force towtruck attachment

Citizen.CreateThread(function()
	while true do
		
		local ped = GetPlayerPed(-1)
		
		local pedVehicle = GetVehiclePedIsIn(ped, false)
		
		if(pedVehicle ~= 0 and IsVehicleTowTruck(pedVehicle) and GetPedInVehicleSeat(pedVehicle, -1) == ped and ) then
			
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

function IsVehicleTowTruck(vehicle)
	local bone = GetEntityBoneIndexByName(vehicle, "tow_arm")
	
	return bone ~= -1
end
