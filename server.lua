ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local money = 150

RegisterNetEvent('blb_karting:cobro')
AddEventHandler('blb_karting:cobro', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= money then
		xPlayer.removeMoney(money)
	elseif xPlayer.getAccount('bank').money >= money then
		xPlayer.removeAccountMoney('bank', money)
	else
		ESX.ShowNotification("You don't have money to pay")
	end
end)