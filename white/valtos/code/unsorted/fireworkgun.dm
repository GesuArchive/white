/obj/item/gun/magic/fireworkgun
	name = "фейрпушка"
	desc = "Выстрели в голову, давай!" // в пизду эту ёблю с реагентами
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "fireworkgun"
	inhand_icon_state = "fireworkgun"
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	fire_sound = 'sound/weapons/emitter.ogg'
	item_flags = NEEDS_PERMIT | NO_MAT_REDEMPTION
	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY

	ammo_type = /obj/item/ammo_casing/magic/fireworkgun

/obj/item/ammo_casing/magic/fireworkgun
	projectile_type = /obj/projectile/magic/fireworkgun
	harmful = TRUE

/obj/projectile/magic/fireworkgun
	name = "заряд фейрверков"
	icon = 'white/valtos/icons/projectiles.dmi'
	icon_state = "railgun"

/obj/projectile/magic/fireworkgun/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.adjust_fire_stacks(1)
		L.adjustFireLoss(5)
		L.IgniteMob()

/obj/effect/fireworkgun_main
	name = "искорка"
	icon = 'white/valtos/icons/effects.dmi'
	icon_state = "star"
	anchored = TRUE
	var/list/sparkles = list()
	var/list/color_variations = list(LIGHT_COLOR_CYAN, COLOR_SOFT_RED, LIGHT_COLOR_ORANGE, LIGHT_COLOR_GREEN, LIGHT_COLOR_YELLOW, LIGHT_COLOR_DARK_BLUE, LIGHT_COLOR_LAVENDER, COLOR_WHITE,  LIGHT_COLOR_SLIME_LAMP, LIGHT_COLOR_FIRE)

/obj/effect/fireworkgun_main/Initialize()
	. = ..()
	icon_state = pick("star", "tristar", "fourstar", "jew")
	SpinAnimation(1, -1, prob(50))
	color = pick(color_variations)
	for(var/i in 1 to 25)
		if(QDELETED(src))
			return
		var/obj/effect/overlay/sparkles/fireworkgun/S = new /obj/effect/overlay/sparkles/fireworkgun(get_turf(src))
		S.color = pick(color_variations)
		S.alpha = 255
		sparkles += S
	spawn(6)
		QDEL_LIST(sparkles)
		qdel(src)

/obj/effect/overlay/sparkles/fireworkgun
	gender = PLURAL
	name = "искорка"
	icon = 'white/valtos/icons/effects.dmi'
	icon_state = "ministar"
	anchored = TRUE

/obj/effect/overlay/sparkles/fireworkgun/Initialize()
	icon_state = pick("ministar", "microstar")
	animate(src, pixel_y = rand(-128, 128), pixel_x = rand(-128, 128), time = 5, alpha = 0, loop = 0)
	. = ..()
