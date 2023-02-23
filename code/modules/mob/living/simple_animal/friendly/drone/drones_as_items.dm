///////////////////
//DRONES AS ITEMS//
///////////////////
//Drone shells

/** Drone Shell: Ghost role item for drones
 *
 * A simple mob spawner item that transforms into a maintenance drone
 * Resepcts drone minimum age
 */

/obj/effect/mob_spawn/drone
	name = "оболочка дрона"
	desc = "Оболочка дрона, многофункциональный робот созданный для ремонта станции"
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_maint_hat" //yes reuse the _hat state.
	layer = BELOW_MOB_LAYER
	density = FALSE
	death = FALSE
	roundstart = FALSE
	///Type of drone that will be spawned
	banType = ROLE_DRONE
	mob_type = /mob/living/simple_animal/drone

/obj/effect/mob_spawn/drone/Initialize(mapload)
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("Оболочка дрона была создана в локации [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_DRONE, notify_suiciders = FALSE)
	AddElement(/datum/element/point_of_interest)

#define DRONE_MINIMUM_AGE 14

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/effect/mob_spawn/drone/attack_ghost(mob/user)
	if(!check_whitelist(user?.ckey))
		to_chat(user, span_danger("Тебя нет в вайтлисте."))
		return

	if(CONFIG_GET(flag/use_age_restriction_for_jobs))
		if(!isnum(user.client.player_age)) //apparently what happens when there's no DB connected. just don't let anybody be a drone without admin intervention
			return
		if(user.client.player_age < DRONE_MINIMUM_AGE)
			to_chat(user, span_danger("Пока рано! Попробуй через [DRONE_MINIMUM_AGE - user.client.player_age] дней."))
			return
	. = ..()

#undef DRONE_MINIMUM_AGE
/*
		notify_ghosts("A drone shell has been created in <b>[A.name]</b>.", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_DRONE, notify_suiciders = FALSE)

/obj/effect/mob_spawn/drone/allow_spawn(mob/user)
	var/client/user_client = user.client
	var/mob/living/simple_animal/drone/drone_type = mob_type
	if(!initial(drone_type.shy) || isnull(user_client) || !CONFIG_GET(flag/use_exp_restrictions_other))
		return ..()
	var/required_role = CONFIG_GET(string/drone_required_role)
	var/required_playtime = CONFIG_GET(number/drone_role_playtime) * 60
	if(CONFIG_GET(flag/use_exp_restrictions_admin_bypass) && check_rights_for(user.client, R_ADMIN))
		return ..()
	if(user?.client?.prefs.db_flags & DB_FLAG_EXEMPT)
		return ..()
	if(required_playtime <= 0)
		return ..()
	var/current_playtime = user_client?.calc_exp_type(required_role)
	if (current_playtime < required_playtime)
		var/minutes_left = required_playtime - current_playtime
		var/playtime_left = DisplayTimeText(minutes_left * (1 MINUTES))
		to_chat(user, span_danger("You need to play [playtime_left] more as [required_role] to spawn as a Maintenance Drone!"))
		return FALSE
	return ..()
*/
