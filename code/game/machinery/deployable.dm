#define SINGLE "одиночном"
#define VERTICAL "вертикальном"
#define HORIZONTAL "горизонтальном"

#define METAL 1
#define WOOD 2
#define SAND 3

//Barricades/cover

/obj/structure/barricade
	name = "баррикада"
	desc = "Похоже она может послужить неплохим укрытием."
	anchored = TRUE
	density = TRUE
	max_integrity = 100
	var/proj_pass_rate = 50 //How many projectiles will pass the cover. Lower means stronger cover
	var/bar_material = METAL

/obj/structure/barricade/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		make_debris()
	qdel(src)

/obj/structure/barricade/proc/make_debris()
	return

/obj/structure/barricade/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WELDER && user.a_intent != INTENT_HARM && bar_material == METAL)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=0))
				return

			to_chat(user, span_notice("Начинаю ремонтировать [src]..."))
			if(I.use_tool(src, user, 40, volume=40))
				obj_integrity = clamp(obj_integrity + 20, 0, max_integrity)
	else
		return ..()

/obj/structure/barricade/CanAllowThrough(atom/movable/mover, border_dir)//So bullets will fly over and stuff.
	. = ..()
	if(locate(/obj/structure/barricade) in get_turf(mover))
		return TRUE
	else if(istype(mover, /obj/projectile))
		if(!anchored)
			return TRUE
		var/obj/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return TRUE
		if(prob(proj_pass_rate))
			return TRUE
		return FALSE



/////BARRICADE TYPES///////

/obj/structure/barricade/wooden
	name = "деревянная баррикада"
	desc = "Ты здесь не пройдешь! Наверное..."
	icon = 'icons/obj/structures.dmi'
	icon_state = "woodenbarricade"
	bar_material = WOOD
	var/drop_amount = 3

/obj/structure/barricade/wooden/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/sheet/mineral/wood/W = I
		if(W.amount < 5)
			to_chat(user, span_warning("Для укрепления баррикады мне понадобится хотя бы 5 досок!"))
			return
		else
			to_chat(user, span_notice("Начинаю укреплять баррикаду [src]..."))
			if(do_after(user, 50, target=src))
				W.use(5)
				var/turf/T = get_turf(src)
				T.PlaceOnTop(/turf/closed/wall/mineral/wood/nonmetal)
				qdel(src)
				return
	return ..()


/obj/structure/barricade/wooden/crude
	name = "грубая деревянная баррикада"
	desc = "Проход перегорожен разномастными досками."
	icon_state = "woodenbarricade-old"
	drop_amount = 1
	max_integrity = 50
	proj_pass_rate = 65

/obj/structure/barricade/wooden/crude/snow
	desc = "Проход перегорожен разномастными, покрытыми снегом, досками."
	icon_state = "woodenbarricade-snow-old"
	max_integrity = 75

/obj/structure/barricade/wooden/make_debris()
	new /obj/item/stack/sheet/mineral/wood(get_turf(src), drop_amount)

/obj/structure/barricade/sandbags
	name = "мешки с песком"
	desc = "Стена из мешков с песком - дешево и сердито."
	icon = 'icons/obj/smooth_structures/sandbags.dmi'
	icon_state = "sandbags-0"
	base_icon_state = "sandbags"
	max_integrity = 280
	proj_pass_rate = 20
	pass_flags_self = LETPASSTHROW
	bar_material = SAND
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_SANDBAGS)
	canSmoothWith = list(SMOOTH_GROUP_SANDBAGS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SECURITY_BARRICADE)

/obj/structure/barricade/sandbags/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)

/obj/structure/barricade/security
	name = "защитный барьер"
	desc = "Развертываемое укрепление, предоставляет неплохую защиту от выстрелов."
	icon = 'icons/obj/objects.dmi'
	icon_state = "barrier0"
	density = FALSE
	anchored = FALSE
	max_integrity = 180
	proj_pass_rate = 20
	armor = list(MELEE = 10, BULLET = 50, LASER = 50, ENERGY = 50, BOMB = 10, BIO = 100, RAD = 100, FIRE = 10, ACID = 0)

	var/deploy_time = 40
	var/deploy_message = TRUE


/obj/structure/barricade/security/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(deploy)), deploy_time)

/obj/structure/barricade/security/proc/deploy()
	icon_state = "barrier1"
	set_density(TRUE)
	set_anchored(TRUE)
	if(deploy_message)
		visible_message(span_warning("[capitalize(src.name)] развертывается в укрытие!"))


/obj/item/grenade/barrier
	name = "барьерная граната"
	desc = "Карманное укрытие."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "barrier_1x1"
	inhand_icon_state = "flashbang"
	actions_types = list(/datum/action/item_action/toggle_barrier_spread)
	var/mode = SINGLE
	var/arm_state = "barrier_1x1"

/obj/item/grenade/barrier/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>В данный момент [capitalize(src.name)] находится в <b>[mode]</b> режиме развертывания.</span>"
	. += "<hr><span class='notice'>ПКМ для смены направления развертывания.</span>"

/obj/item/grenade/barrier/AltClick(mob/living/carbon/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	toggle_mode(user)

/obj/item/grenade/barrier/proc/toggle_mode(mob/user)
	switch(mode)
		if(SINGLE)
			mode = VERTICAL
			arm_state = "barrier_1x3"
		if(VERTICAL)
			mode = HORIZONTAL
			arm_state = "barrier_3x1"
		if(HORIZONTAL)
			mode = SINGLE
			arm_state = "barrier_1x1"
	icon_state = arm_state
	to_chat(user, span_notice("В данный момент [capitalize(src.name)] находится в <b>[mode]</b> режиме развертывания."))

/obj/item/grenade/barrier/arm_grenade(mob/user, delayoverride, msg = TRUE, volume = 60)
	var/turf/T = get_turf(src)
	log_grenade(user, T) //Inbuilt admin procs already handle null users
	if(user)
		add_fingerprint(user)
		if(msg)
			to_chat(user, span_warning("Активирую барьерную гранату! Детонация через: <b>[capitalize(DisplayTimeText(det_time))]</b>!"))
	if(shrapnel_type && shrapnel_radius)
		shrapnel_initialized = TRUE
		AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
	playsound(src, 'sound/weapons/armbomb.ogg', volume, TRUE)
	active = TRUE
	icon_state = arm_state + "_active"
	SEND_SIGNAL(src, COMSIG_GRENADE_ARMED, det_time, delayoverride)
	addtimer(CALLBACK(src, PROC_REF(detonate)), isnull(delayoverride)? det_time : delayoverride)

/obj/item/grenade/barrier/detonate(mob/living/lanced_by)
	. = ..()
	new /obj/structure/barricade/security(get_turf(src.loc))
	switch(mode)
		if(VERTICAL)
			var/turf/target_turf = get_step(src, NORTH)
			if(!target_turf.is_blocked_turf())
				new /obj/structure/barricade/security(target_turf)

			var/turf/target_turf2 = get_step(src, SOUTH)
			if(!target_turf2.is_blocked_turf())
				new /obj/structure/barricade/security(target_turf2)
		if(HORIZONTAL)
			var/turf/target_turf = get_step(src, EAST)
			if(!target_turf.is_blocked_turf())
				new /obj/structure/barricade/security(target_turf)

			var/turf/target_turf2 = get_step(src, WEST)
			if(!target_turf2.is_blocked_turf())
				new /obj/structure/barricade/security(target_turf2)
	qdel(src)

/obj/item/grenade/barrier/ui_action_click(mob/user)
	toggle_mode(user)

/obj/item/deployable_turret_folded
	name = "развертываемая туррель"
	desc = "Тяжелая переносная турель для огневой поддержки."
	icon = 'icons/obj/turrets.dmi'
	icon_state = "folded_hmg"
	max_integrity = 250
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK

/obj/item/deployable_turret_folded/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/deployable, 5 SECONDS, /obj/machinery/deployable_turret/hmg, delete_on_use = TRUE)

#undef SINGLE
#undef VERTICAL
#undef HORIZONTAL

#undef METAL
#undef WOOD
#undef SAND
