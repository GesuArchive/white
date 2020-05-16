/datum/component/glooed
	var/times_glooed = 0
	var/fullgloo = 15

	var/head_glooed = FALSE
	var/chest_glooed = FALSE
	var/larm_glooed = FALSE
	var/rarm_glooed = FALSE
	var/lleg_glooed = FALSE
	var/rleg_glooed = FALSE

/datum/component/glooed/Initialize()
	if(!iscarbon(parent))
		qdel(src)

/datum/component/glooed/RegisterWithParent()
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, .proc/ungloo)

/datum/component/glooed/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT)

/datum/component/glooed/proc/ungloo()
	qdel(src)

/datum/component/glooed/proc/fullgloo()
	var/mob/living/carbon/C = parent
	var/obj/structure/spider/cocoon/gloo/G = new(get_turf(C))
	C.forceMove(G)

/datum/component/glooed/proc/get_glooed(def_zone)
	times_glooed++

	if(times_glooed == fullgloo)
		fullgloo()

	if(def_zone == BODY_ZONE_HEAD)
		head_glooed = TRUE
	if(def_zone == BODY_ZONE_CHEST)
		chest_glooed = TRUE
	if(def_zone == BODY_ZONE_L_ARM)
		larm_glooed = TRUE
	if(def_zone == BODY_ZONE_R_ARM)
		rarm_glooed = TRUE
	if(def_zone == BODY_ZONE_L_LEG)
		lleg_glooed = TRUE
	if(def_zone == BODY_ZONE_R_LEG)
		rleg_glooed = TRUE

	if(head_glooed&&chest_glooed&&larm_glooed&&rarm_glooed&&lleg_glooed&&rleg_glooed)
		fullgloo()


/obj/structure/spider/cocoon/gloo
	name = "гелиопеновый кокон"
	desc = "Something wrapped in geliofoam."

/obj/projectile/bullet/gloo
	name = "сгусток гелиопены"
	damage = 3
	damage_type = STAMINA
	icon = 'icons/effects/effects.dmi'
	icon_state = "frozen_smoke_capsule"

/obj/projectile/bullet/gloo/on_hit(atom/target)
	. = ..()

	if(iscarbon(target))
		var/datum/component/glooed/G = target.GetComponent(/datum/component/glooed)
		if(!G)
			G = target.AddComponent(/datum/component/glooed)
		G.get_glooed(def_zone)

	else if(isopenturf(target))
		return

/obj/item/gun/ballistic/gloogun
	name = "ГИПС-пушка"
	desc = "Прикол."
	mag_type = /obj/item/ammo_box/magazine/gloogun
	fire_sound = 'sound/items/syringeproj.ogg'
	casing_ejector = FALSE
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	automatic = TRUE
	spread = 15
	fire_delay = 0

/obj/item/ammo_casing/caseless/gloo
	name = "сгусток гелиопены"
	desc = "Ааааааааааааааааааааааа"
	projectile_type = /obj/projectile/bullet/gloo
	caliber = "gloo"
	icon = 'icons/effects/effects.dmi'
	icon_state = "frozen_smoke_capsule"
	custom_materials = list()

/obj/item/ammo_box/magazine/gloogun
	name = "канистра (Гелиопена)"
	icon_state = "a762-50"
	ammo_type = /obj/item/ammo_casing/caseless/gloo
	caliber = "gloo"
	max_ammo = 77

/obj/item/ammo_box/magazine/gloogun/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Канистра заполнена на [round((ammo_count()/max_ammo)*100, 0.1)]%.</span>"
