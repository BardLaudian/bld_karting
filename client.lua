ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local haveKart = 0
local kart = 0

local cars = 'kart'

local rentpoint = vector3(-161.89416503906, -2134.3852539062, 16.705030441284)
local returnpoint = vector3(-160.38623046875, -2137.6467285156, 16.705018997192)
local spawnpoint = vector3(-160.79, -2141.76, 16.71)
local areapoint = vector3(-85.162, -2067.108, 21.797)
local areazone = 175

-- 
Citizen.CreateThread(function()
	local w = 150
	while true do
		Wait(w)
		local coords = GetEntityCoords(PlayerPedId())
		if haveKart == 0 and #(coords - rentpoint) < 15 then
			DrawMarker(36, rentpoint.x, rentpoint.y, rentpoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 68, 255, false, true, 2, false, false, false, false)
			if #(coords - rentpoint) < 1.5 then
				ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to rent a kart for ~y~150$~s~')
				if IsControlJustReleased(0, 38) then
					spawnCar(cars)
					TriggerServerEvent('blb_karting:cobro')
					haveKart = 1
				else
					ESX.ShowNotification("You already have a kart out!")
				end 
			end 
		else
			if w ~= 150 then w = 150 end
		end
		if haveKart == 1 and #(coords - returnpoint) < 10 then
			DrawMarker(27, returnpoint.x, returnpoint.y, returnpoint.z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 255, false, true, 2, false, false, false, false)
			if #(coords - returnpoint) < 1.5 then
				ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to park the vehicle')
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
        Wait(1)
    end

    kart = CreateVehicle(car, spawnpoint.x, spawnpoint.y, spawnpoint.z, 286.0, true, false)
    SetEntityAsMissionEntity(kart, true, true)
    --exports["LegacyFuel"]:SetFuel(kart, 100)

    TaskWarpPedIntoVehicle(PlayerPedId(), kart, -1)
end

Citizen.CreateThread(
	function()
		while true do
			Wait(3000)
            local coords = GetEntityCoords(PlayerPedId())
			if haveKart == 1 and (#(coords - areapoint) > areazone) then
				ESX.ShowNotification("You have 10 seconds to return the vehicle to the track")
				Wait(5000)	
				if #(coords - areapoint) > areazone then
					ESX.ShowNotification("You have 5 seconds to return the vehicle to the track")
					Wait(5000)
					if #(coords - areapoint) > areazone then
						ESX.ShowNotification("Your vehicle has been taken away for not following the directions!")
						SetEntityAsNoLongerNeeded(kart)
						DeleteEntity(kart)
                    	haveKart = 0
					end
				end
			end
		end
	end
)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(rentpoint.x, rentpoint.y, rentpoint.z)
	SetBlipSprite(blip , 531)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 28)
	SetBlipScale(blip, 0.7)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Karting")
	EndTextCommandSetBlipName(blip)
end)
