/obj/structure/closet/crate
	name = "ящик"
	desc = "Прямоугольный ящик, как деревянный, только стальной."
	icon = 'icons/obj/crates.dmi'
	icon_state = "crate"
	req_access = null
	can_weld_shut = FALSE
	horizontal = TRUE
	allow_objects = TRUE
	allow_dense = TRUE
	dense_when_open = TRUE
	delivery_icon = "deliverycrate"
	open_sound = 'sound/machines/crate_open.ogg'
	close_sound = 'sound/machines/crate_close.ogg'
	open_sound_volume = 35
	close_sound_volume = 50
	drag_slowdown = 0
	door_anim_time = 0 // no animation
	var/crate_climb_time = 20
	var/obj/item/paper/fluff/jobs/cargo/manifest/manifest
	/// Where the Icons for lids are located.
	var/lid_icon = 'icons/obj/crates.dmi'
	/// Icon state to use for lid to display when opened. Leave undefined if there isn't one.
	var/lid_icon_state
	/// Controls the X value of the lid, allowing left and right pixel movement.
	var/lid_x = 0
	/// Controls the Y value of the lid, allowing up and down pixel movement.
	var/lid_y = 0

/obj/structure/closet/crate/Initialize(mapload)
	. = ..()
	if(icon_state == "[initial(icon_state)]open")
		opened = TRUE
		AddElement(/datum/element/climbable, climb_time = crate_climb_time * 0.5, climb_stun = 0)
	else
		AddElement(/datum/element/climbable, climb_time = crate_climb_time, climb_stun = 0)
	update_icon()

/obj/structure/closet/crate/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!istype(mover, /obj/structure/closet))
		var/obj/structure/closet/crate/locatedcrate = locate(/obj/structure/closet/crate) in get_turf(mover)
		if(locatedcrate) //you can walk on it like tables, if you're not in an open crate trying to move to a closed crate
			if(opened) //if we're open, allow entering regardless of located crate openness
				return TRUE
			if(!locatedcrate.opened) //otherwise, if the located crate is closed, allow entering
				return TRUE

/obj/structure/closet/crate/update_icon_state()
	icon_state = "[initial(icon_state)][opened ? "open" : ""]"
	return ..()

/obj/structure/closet/crate/closet_update_overlays(list/new_overlays)
	. = new_overlays
	if(manifest)
		. += "manifest"

/obj/structure/closet/crate/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(manifest)
		tear_manifest(user)

/obj/structure/closet/crate/after_open(mob/living/user, force)
	. = ..()
	RemoveElement(/datum/element/climbable, climb_time = crate_climb_time, climb_stun = 0)
	AddElement(/datum/element/climbable, climb_time = crate_climb_time * 0.5, climb_stun = 0)

/obj/structure/closet/crate/after_close(mob/living/user, force)
	. = ..()
	RemoveElement(/datum/element/climbable, climb_time = crate_climb_time * 0.5, climb_stun = 0)
	AddElement(/datum/element/climbable, climb_time = crate_climb_time, climb_stun = 0)


/obj/structure/closet/crate/open(mob/living/user, force = FALSE)
	. = ..()
	if(. && manifest)
		to_chat(user, span_notice("Манифест оторван от [src]."))
		playsound(src, 'sound/items/poster_ripped.ogg', 75, TRUE)
		manifest.forceMove(get_turf(src))
		manifest = null
		update_icon()

/obj/structure/closet/crate/proc/tear_manifest(mob/user)
	to_chat(user, span_notice("Отрываю манифест от [src]."))
	playsound(src, 'sound/items/poster_ripped.ogg', 75, TRUE)

	manifest.forceMove(loc)
	if(ishuman(user))
		user.put_in_hands(manifest)
	manifest = null
	update_icon()

/obj/structure/closet/crate/closet_update_overlays(list/new_overlays)
	. = new_overlays
	if(opened && lid_icon_state)
		var/mutable_appearance/lid = mutable_appearance(icon = lid_icon, icon_state = lid_icon_state)
		lid.pixel_x = lid_x
		lid.pixel_y = lid_y
		lid.layer = layer
		. += lid
	. += ..()

/obj/structure/closet/crate/coffin
	name = "гроб"
	desc = "Погребальный сосуд для тел тех, кто сейчас в лучшем мире."
	icon_state = "coffin"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 5
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

/obj/structure/closet/crate/maint

/obj/structure/closet/crate/maint/Initialize(mapload)
	..()

	var/static/list/possible_crates = RANDOM_CRATE_LOOT

	var/crate_path = pick_weight(possible_crates)

	var/obj/structure/closet/crate = new crate_path(loc)
	crate.RegisterSignal(crate, COMSIG_CLOSET_POPULATE_CONTENTS, TYPE_PROC_REF(/obj/structure/closet, populate_with_random_maint_loot))
	if (prob(50))
		crate.opened = TRUE
		crate.update_appearance()

	return INITIALIZE_HINT_QDEL

/obj/structure/closet/proc/populate_with_random_maint_loot()
	SIGNAL_HANDLER

	for (var/i in 1 to rand(2,6))
		new /obj/effect/spawner/random/maintenance(src)

/obj/structure/closet/crate/trashcart/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_SLUDGE, CELL_VIRUS_TABLE_GENERIC, rand(2,3), 15)

/obj/structure/closet/crate/trashcart/filled

/obj/structure/closet/crate/trashcart/filled/PopulateContents()
	. = ..()
	for(var/i in 1 to rand(7,15))
		new /obj/effect/spawner/lootdrop/garbage_spawner(src)
		if(prob(12))
			new /obj/item/storage/bag/trash/filled(src)
	new /obj/effect/spawner/scatter/grime(loc)

/obj/structure/closet/crate/internals
	desc = "Ящик неотложной помощи."
	name = "Ящик экстренной помощи"
	icon_state = "o2crate"

/obj/structure/closet/crate/trashcart //please make this a generic cart path later after things calm down a little
	desc = "Тяжелая металлическая мусорная тележка на колесиках."
	name = "тележка для мусора"
	icon_state = "trashcart"

/obj/structure/closet/crate/trashcart/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(has_gravity())
		playsound(src, 'sound/effects/roll.ogg', 100, TRUE)

/obj/structure/closet/crate/trashcart/laundry
	name = "тележка для белья"
	desc = "Большая тележка для перевозки большого количества белья. Большой стирке большая тележка"
	icon_state = "laundry"

/obj/structure/closet/crate/medical
	desc = "Медицинский ящик."
	name = "ящик с медицинским оборудованием"
	icon_state = "medicalcrate"

/obj/structure/closet/crate/freezer
	desc = "Фризер."
	name = "морозильник"
	icon_state = "freezer"

//Snowflake organ freezer code
//Order is important, since we check source, we need to do the check whenever we have all the organs in the crate

/obj/structure/closet/crate/freezer/open(mob/living/user, force = FALSE)
	recursive_organ_check(src)
	..()

/obj/structure/closet/crate/freezer/close()
	..()
	recursive_organ_check(src)

/obj/structure/closet/crate/freezer/Destroy()
	recursive_organ_check(src)
	return ..()

/obj/structure/closet/crate/freezer/Initialize(mapload)
	. = ..()
	recursive_organ_check(src)



/obj/structure/closet/crate/freezer/blood
	name = "морозильник для крови"
	desc = "Холодильник с пакетами крови."

/obj/structure/closet/crate/freezer/blood/PopulateContents()
	. = ..()
	new /obj/item/reagent_containers/blood(src)
	new /obj/item/reagent_containers/blood(src)
	new /obj/item/reagent_containers/blood/a_minus(src)
	new /obj/item/reagent_containers/blood/b_minus(src)
	new /obj/item/reagent_containers/blood/b_plus(src)
	new /obj/item/reagent_containers/blood/o_minus(src)
	new /obj/item/reagent_containers/blood/o_plus(src)
	new /obj/item/reagent_containers/blood/lizard(src)
	new /obj/item/reagent_containers/blood/ethereal(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/blood/random(src)

/obj/structure/closet/crate/freezer/surplus_limbs
	name = "бюджетные протезы конечностей"
	desc = "Ящик с набором бюджетных протезов."

/obj/structure/closet/crate/freezer/surplus_limbs/PopulateContents()
	. = ..()
	new /obj/item/bodypart/l_arm/robot/surplus(src)
	new /obj/item/bodypart/l_arm/robot/surplus(src)
	new /obj/item/bodypart/r_arm/robot/surplus(src)
	new /obj/item/bodypart/r_arm/robot/surplus(src)
	new /obj/item/bodypart/l_leg/robot/surplus(src)
	new /obj/item/bodypart/l_leg/robot/surplus(src)
	new /obj/item/bodypart/r_leg/robot/surplus(src)
	new /obj/item/bodypart/r_leg/robot/surplus(src)

/obj/structure/closet/crate/radiation
	desc = "Ящик с знаком радиации на нем."
	name = "радиационный ящик"
	icon_state = "radiation"

/obj/structure/closet/crate/hydroponics
	name = "ящик гидропоники"
	desc = "Все, что вам нужно, для уничтожения надоедливых сорняков и вредителей."
	icon_state = "hydrocrate"

/obj/structure/closet/crate/engineering
	name = "инженерный ящик"
	icon_state = "engi_crate"

/obj/structure/closet/crate/engineering/electrical
	icon_state = "engi_e_crate"

/obj/structure/closet/crate/rcd
	desc = "Ящик для хранения RCD."
	name = "\improper ящик для RCD"
	icon_state = "engi_crate"

/obj/structure/closet/crate/rcd/PopulateContents()
	..()
	for(var/i in 1 to 4)
		new /obj/item/rcd_ammo(src)
	new /obj/item/construction/rcd(src)

/obj/structure/closet/crate/science
	name = "ящик научного отдела"
	desc = "Ящик научного отдела."
	icon_state = "scicrate"

/obj/structure/closet/crate/solarpanel_small
	name = "ящик бюджетных солнечных батарей"
	icon_state = "engi_e_crate"

/obj/structure/closet/crate/solarpanel_small/PopulateContents()
	..()
	for(var/i in 1 to 13)
		new /obj/item/solar_assembly(src)
	new /obj/item/circuitboard/computer/solar_control(src)
	new /obj/item/paper/guides/jobs/engi/solars(src)
	new /obj/item/electronics/tracker(src)

/obj/structure/closet/crate/goldcrate
	name = "золотой ящик"

/obj/structure/closet/crate/goldcrate/PopulateContents()
	..()
	new /obj/item/storage/belt/champion(src)

/obj/structure/closet/crate/goldcrate/populate_contents_immediate()
	. = ..()

	// /datum/objective_item/stack/gold
	for(var/i in 1 to 10)
		new /obj/item/stack/sheet/mineral/gold(src, 1, FALSE)
	for(var/i in 1 to 5)
		new /obj/item/coin/gold(src)

/obj/structure/closet/crate/silvercrate
	name = "серебряный ящик"

/obj/structure/closet/crate/silvercrate/PopulateContents()
	..()
	for(var/i in 1 to 10)
		new /obj/item/stack/sheet/mineral/silver(src, 1, FALSE)
	for(var/i in 1 to 5)
		new /obj/item/coin/silver(src)

/obj/structure/closet/crate/decorations
	icon_state = "engi_crate"

/obj/structure/closet/crate/decorations/PopulateContents()
	. = ..()
	for(var/i in 1 to 4)
		new /obj/effect/spawner/lootdrop/decorations_spawner(src)
