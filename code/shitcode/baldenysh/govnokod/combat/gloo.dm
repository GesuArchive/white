/datum/component/glooed
	var/times_glooed = 0

	var/obj_fullgloo = 3
	var/carbon_fullgloo = 15

	var/head_glooed = FALSE
	var/chest_glooed = FALSE
	var/larm_glooed = FALSE
	var/rarm_glooed = FALSE
	var/lleg_glooed = FALSE
	var/rleg_glooed = FALSE

/datum/component/glooed/Initialize()
	if(!ismovable(parent))
		qdel(src)

/datum/component/glooed/RegisterWithParent()
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, .proc/ungloo)

/datum/component/glooed/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT)

/datum/component/glooed/proc/ungloo()
	qdel(src)

/datum/component/glooed/proc/fullgloo()
	var/atom/movable/A = parent
	var/obj/structure/spider/cocoon/gloo/G = new(get_turf(A))
	A.forceMove(G)
	qdel(src)

/datum/component/glooed/proc/get_glooed()
	if(isitem(parent))
		fullgloo()
		return

	times_glooed++

	if(isobj(parent) && times_glooed == obj_fullgloo)
		fullgloo()
		return

	if(iscarbon(parent) && times_glooed == carbon_fullgloo)
		fullgloo()
		return

/datum/component/glooed/proc/get_glooed_carbon(def_zone)
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

	if(ismovable(target) && !target.density && !target.anchored)
		var/datum/component/glooed/G = target.GetComponent(/datum/component/glooed)
		if(!G)
			G = target.AddComponent(/datum/component/glooed)
		G.get_glooed()

		if(iscarbon(target))
			G.get_glooed_carbon(def_zone)

	else if(isturf(target))
		return //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa где спрайты

/obj/item/gun/gloogun
	name = "ГИПС-пушка"
	desc = "Прикол."
	fire_sound = 'sound/items/syringeproj.ogg'
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	automatic = TRUE
	spread = 15
	fire_delay = 0
	var/obj/item/gloocan/bolon

/obj/item/gun/gloogun/Initialize()
	. = ..()
	chambered = new /obj/item/ammo_casing/gloo(src)

/obj/item/gun/gloogun/can_shoot()
	if(bolon && bolon.cur_ammo)
		return TRUE
	return FALSE

/obj/item/gun/gloogun/process_chamber()
	if(chambered && !chambered.BB && bolon && bolon.cur_ammo)
		chambered.newshot()

/obj/item/gun/gloogun/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/gloocan) && !bolon)
		bolon = I
		I.forceMove(src)
	..()

/obj/item/gun/gloogun/attack_self(mob/user)
	if(bolon)
		if(user)
			user.put_in_hands(bolon)
		else
			bolon.forceMove(get_turf(src))
	..()

/obj/item/ammo_casing/gloo
	name = "гелиопенический рекомбинатор"
	desc = "Ааааааааааааааааааааааа"
	projectile_type = /obj/projectile/bullet/gloo
	caliber = "gloo"
	icon = 'icons/effects/effects.dmi'
	icon_state = "frozen_smoke_capsule"
	firing_effect_type = null

/obj/item/ammo_casing/gloo/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	if(!BB)
		return
	if(istype(loc, /obj/item/gun/gloogun))
		var/obj/item/gun/gloogun/G = loc
		if(!G.bolon || G.bolon.cur_ammo <= 0)
			return
		G.bolon.cur_ammo--
	..()



/obj/item/gloocan //зделать нормальный газовохимический некостыль потом когданибудь
	name = "канистра (Гелиопена)"
	icon = 'code/shitcode/valtos/icons/tank.dmi'
	icon_state = "generic"
	var/max_ammo = 77
	var/cur_ammo = 77

/obj/item/gloocan/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Канистра заполнена на [round((cur_ammo/max_ammo)*100, 0.1)]%.</span>"
