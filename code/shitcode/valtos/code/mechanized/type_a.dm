/obj/mecha/mechanized/type_a
	name = "TYPE-A Mech"
	desc = "БЕГИ!!!"
	icon = 'code/shitcode/valtos/icons/mechanized/type_a.dmi'
	icon_state = "type_a"
	pixel_x = -16
	step_in = 2
	resistance_flags = FIRE_PROOF | ACID_PROOF
	layer = ABOVE_MOB_LAYER
	force = 5
	normal_step_energy_drain = 100
	step_energy_drain = 100
	melee_energy_drain = 150
	overload_step_energy_drain_min = 1000
	max_integrity = 1300
	deflect_chance = 5
	armor = list("melee" = 40, "bullet" = 40, "laser" = 40, "energy" = 40, "bomb" = 40, "bio" = 40, "rad" = 40, "fire" = 100, "acid" = 100)
	bumpsmash = TRUE
	max_equip = 5
	stepsound = 'code/shitcode/valtos/sounds/mechanized/type_a_move.wav'
	turnsound = 'code/shitcode/valtos/sounds/mechanized/type_a_move.wav'
	melee_cooldown = 15
	enter_delay = 150
	exit_delay = 100
	hud_possible = list (DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD, DIAG_TRACK_HUD)
	mouse_pointer = 'icons/mecha/mecha_mouse.dmi'

/obj/mecha/mechanized/restore_equipment()
	mouse_pointer = 'icons/mecha/mecha_mouse.dmi'
	. = ..()

/obj/item/mecha_parts/mecha_equipment/drill/lance
	name = "энергокопьё KR1"
	desc = "Че смотришь? БЕГИ!!!"
	icon = 'code/shitcode/valtos/icons/mechanized/type_a.dmi'
	icon_state = "kr1"
	equip_cooldown = 35
	energy_drain = 1000
	force = 90
	harmful = TRUE
	tool_behaviour = TOOL_DRILL
	toolspeed = 1.9
	drill_delay = 3

/obj/item/mecha_parts/mecha_equipment/drill/lance/attach(obj/mecha/M)
	..()
	M.add_overlay(icon)

/obj/item/mecha_parts/mecha_equipment/drill/lance/attach(obj/mecha/M)
	..()
	M.cut_overlay(icon)
