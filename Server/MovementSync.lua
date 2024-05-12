
-----------------------------------------------------------------------------------------------------
-- Emote Movement Syncing  ---------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

RegisterServerEvent("gtahistory-emotes:server:syncPosition")
AddEventHandler("gtahistory-emotes:server:syncPosition", function(pos, rot)
	TriggerClientEvent("gtahistory-emotes:client:syncPosition", -1, source, pos, rot)
end)
