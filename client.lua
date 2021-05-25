ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

cars = 'kart'
local haveKart = 0
local kart = 0

Citizen.CreateThread(function()
	while true do
		local coords = GetEntityCoords(PlayerPedId())
		Citizen.Wait(10)
		if GetDistanceBetweenCoords(coords, -161.89416503906, -2134.3852539062, 16.705030441284, true) < 17 then 
			DrawMarker(36, -161.89416503906, -2134.3852539062, 16.705030441284, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 68, 255, false, true, 2, false, false, false, false)
			if GetDistanceBetweenCoords(coords, -161.89416503906, -2134.3852539062, 16.705030441284, true) < 1.5 then
				ESX.ShowHelpNotification('Pulsa ~INPUT_CONTEXT~ para alquilar un kart por ~y~150$~s~')
				if IsControlJustReleased(0, 38) then 
					if haveKart == 0 then
						spawnCar(cars)
						TriggerServerEvent('blb_karting:cobro')
						haveKart = 1
					else
						TriggerEvent("pNotify:SendNotification", {text = "¡Ya tienes un kart fuera!", type = "error", timeout = 6000, layout = "centerRight"})
					end
				end 
			end 
		end

		if haveKart == 1 and GetDistanceBetweenCoords(coords, -160.38623046875, -2137.6467285156, 16.705018997192, true) < 10 then
			DrawMarker(27, -160.38623046875, -2137.6467285156, 15.705018997192, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 255, false, true, 2, false, false, false, false)
        	if haveKart == 1 and GetDistanceBetweenCoords(coords, -160.38623046875, -2137.6467285156, 16.705018997192, true) < 1.5 then
				ESX.ShowHelpNotification('Pulsa ~INPUT_CONTEXT~ para aparcar el vehiculo')
		  		if IsControlJustReleased(0, 38) then 
				    DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
          	        haveKart = 0
				end
		  	end
		end

	end
end)

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(1)
    end

    --local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    kart = CreateVehicle(car, -160.79, -2141.76, 16.71, 286.0, true, false)
    SetEntityAsMissionEntity(kart, true, true)
    exports["LegacyFuel"]:SetFuel(kart, 100)

    TaskWarpPedIntoVehicle(PlayerPedId(), kart, -1)
end

Citizen.CreateThread(
	function()
		while true do
			Wait(1000)
            local coords = GetEntityCoords(PlayerPedId())
			if haveKart == 1 and GetDistanceBetweenCoords(coords, -85.162, -2067.108, 21.797, true) > 175 then
				TriggerEvent("pNotify:SendNotification", {text = "Tienes 10 segundos para volver con el vehiculo a la pista", type = "success", timeout = 3000, layout = "centerRight"})
				print(kart)
				Wait(5000)
				if haveKart == 1 and GetDistanceBetweenCoords(coords, -85.162, -2067.108, 21.797, true) > 175 then
					TriggerEvent("pNotify:SendNotification", {text = "Tienes 5 segundos para volver con el vehiculo a la pista", type = "success", timeout = 2500, layout = "centerRight"})
					Wait(5000)
					TriggerEvent("pNotify:SendNotification", {text = "¡Se te ha quitado el vehiculo!", type = "error", timeout = 4000, layout = "centerRight"})
					SetEntityAsNoLongerNeeded(kart)
					DeleteEntity(kart)
                    haveKart = 0
				end
			end
		end
	end
)