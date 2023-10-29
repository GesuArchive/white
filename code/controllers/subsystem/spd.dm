SUBSYSTEM_DEF(spd)
	name = "SPD"
	init_order = INIT_ORDER_SPD
	flags = SS_NO_INIT | SS_NO_FIRE
	priority = FIRE_PRIORITY_SPD
	var/list/checked_flags = list()

/datum/controller/subsystem/spd/proc/check_action(client/target_client, action_type)
	if(!target_client || target_client.player_age > 14 || !action_type)
		return

	if(!(action_type in checked_flags))
		checked_flags[action_type] = list()

	if(target_client in checked_flags[action_type])
		return

	checked_flags[action_type] += target_client
	message_admins("[ADMIN_LOOKUPFLW(target_client.mob)] ([target_client.player_age] дней) [action_type]")
