/obj/machinery/ai_slipper
	name = "пеномёт"
	desc = "Активируется удалённо для контроля зоны."
	icon = 'icons/obj/device.dmi'
	icon_state = "ai-slipper0"
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	plane = FLOOR_PLANE
	max_integrity = 200
	armor = list(MELEE = 50, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)

	var/uses = 20
	COOLDOWN_DECLARE(foam_cooldown)
	var/cooldown_time = 10 SECONDS // just about enough cooldown time so you cant waste foam
	req_access = list(ACCESS_AI_UPLOAD)

/obj/machinery/ai_slipper/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Внутри осталось <b>[uses]</b> зарядов.</span>"

/obj/machinery/ai_slipper/update_icon_state()
	if(machine_stat & BROKEN)
		return
	if((machine_stat & NOPOWER) || !COOLDOWN_FINISHED(src, foam_cooldown) || !uses)
		icon_state = "ai-slipper0"
	else
		icon_state = "ai-slipper1"

/obj/machinery/ai_slipper/interact(mob/user)
	if(!allowed(user))
		to_chat(user, span_danger("Доступ запрещён."))
		return
	if(!uses)
		to_chat(user, span_warning("[capitalize(src.name)] полностью разряжен!"))
		return
	if(!COOLDOWN_FINISHED(src, foam_cooldown))
		to_chat(user, span_warning("[capitalize(src.name)] на перезарядке, осталось <b>[COOLDOWN_TIMELEFT(src, foam_cooldown)]</b>!"))
		return
	var/datum/effect_system/fluid_spread/foam/foam = new
	foam.set_up(4, holder = src, location = loc)
	foam.start()
	uses--
	to_chat(user, span_notice("Активирую [src.name]. Внутри осталось <b>[uses]</b> зарядов."))
	COOLDOWN_START(src, foam_cooldown,cooldown_time)
	power_change()
	addtimer(CALLBACK(src, .proc/power_change), cooldown_time)
