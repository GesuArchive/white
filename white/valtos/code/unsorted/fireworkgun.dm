/obj/item/gun/magic/fireworkgun
	name = "фейрпушка"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "fireworkgun"
	inhand_icon_state = "fireworkgun"
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	fire_sound = 'sound/weapons/emitter.ogg'
	item_flags = NEEDS_PERMIT | NO_MAT_REDEMPTION
	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	var/list/color_variations = list("#FFFFFF")

	ammo_type = /obj/item/ammo_casing/magic/fireworkgun

/obj/item/gun/magic/fireworkgun/Initialize()
	. = ..()
	create_reagents(100, OPENCONTAINER)

/obj/item/gun/magic/fireworkgun/attackby(obj/item/I, mob/user, params)
	. = ..()
	color_variations.Cut()
	if(!reagents.reagent_list.len)
		color_variations = list("#FFFFFF")
		return
	for(var/datum/reagent/R in reagents.reagent_list)
		color_variations.Add(R.color)

/obj/item/gun/magic/fireworkgun/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(chambered?.BB)
		var/obj/projectile/magic/fireworkgun/AB = chambered.BB
		AB.color_variations = color_variations.Copy()
	. = ..()

/obj/item/ammo_casing/magic/fireworkgun
	projectile_type = /obj/projectile/magic/fireworkgun
	harmful = TRUE

/obj/item/ammo_casing/magic/fireworkgun/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", extra_damage = 0, extra_penetration = 0)
	if(!BB)
		return
	if(istype(loc, /obj/item/gun/magic/fireworkgun))
		var/obj/item/gun/magic/fireworkgun/FG = loc
		FG.reagents.remove_any(10)
	return ..()

/obj/projectile/magic/fireworkgun
	name = "заряд фейрверков"
	icon = 'white/valtos/icons/projectiles.dmi'
	icon_state = "railgun"
	var/list/color_variations = list("#FFFFFF")

/obj/projectile/magic/fireworkgun/Initialize()
	. = ..()
	color = pick(color_variations)

/obj/projectile/magic/fireworkgun/on_hit(target)
	. = ..()
	var/obj/effect/fireworkgun_main/FM = new /obj/effect/fireworkgun_main(get_turf(src))
	FM.color_variations = color_variations.Copy()

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
	var/list/color_variations = list("#FF0000", "#0000FF", "#00FF00")

/obj/effect/fireworkgun_main/Initialize()
	. = ..()
	icon_state = pick("star", "tristar", "fourstar", "jew")
	SpinAnimation(5, -1, prob(50))
	color = pick(color_variations)
	for(var/i in 1 to 25)
		if(QDELETED(src))
			return
		var/obj/effect/overlay/sparkles/fireworkgun/S = new /obj/effect/overlay/sparkles/fireworkgun(get_turf(src))
		S.color = pick(color_variations)
		S.alpha = 255
		sparkles += S
	spawn(50)
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
	animate(src, pixel_y = rand(-64, 64), pixel_x = rand(-64, 64), time = 5, loop = 0)
	. = ..()
