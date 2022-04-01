/obj/item/bong
	name = "бонг"
	desc = "Технически известен как водопроводная труба, ну или просто бульбулятор."
	icon = 'white/rebolution228/icons/obj/bong.dmi'
	lefthand_file = 'white/rebolution228/icons/obj/mob/lefthand.dmi'
	righthand_file = 'white/rebolution228/icons/obj/mob/righthand.dmi'
	icon_state = "bongoff"
	inhand_icon_state = "bongoff"
	var/icon_on = "bongon"
	var/icon_off = "bongoff"
	var/lit = FALSE
	var/useable_bonghits = 4
	var/bonghits = 0
	var/chem_volume = 30
	var/list_reagents = null
	var/packeditem = FALSE
	var/quarter_volume = 0

/obj/item/bong/Initialize()
	. = ..()
	create_reagents(chem_volume, INJECTABLE | NO_REACT)

/obj/item/bong/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item, /obj/item/food/grown))
		var/obj/item/food/grown/grown_item = used_item
		if(!packeditem)
			if(HAS_TRAIT(grown_item, TRAIT_DRIED))
				to_chat(user, span_notice("Засовываю [grown_item] в [src]."))
				bonghits = useable_bonghits
				packeditem = TRUE
				if(grown_item.reagents)
					grown_item.reagents.trans_to(src, grown_item.reagents.total_volume, transfered_by = user)
					quarter_volume = reagents.total_volume/useable_bonghits
				qdel(grown_item)
			else
				to_chat(user, span_warning("Сначала его нужно высушить!"))
		else
			to_chat(user, span_warning("Уже собран!"))
	else if(istype(used_item, /obj/item/reagent_containers/hash)) //for hash/dabs
		if(!packeditem)
			to_chat(user, span_notice("Засовываю [used_item] в [src]."))
			bonghits = useable_bonghits
			packeditem = TRUE
			if(used_item.reagents)
				used_item.reagents.trans_to(src, used_item.reagents.total_volume, transfered_by = user)
				quarter_volume = reagents.total_volume/useable_bonghits
			qdel(used_item)
	else
		var/lighting_text = used_item.ignition_effect(src,user)
		if(lighting_text)
			if(bonghits > 0)
				light(lighting_text)
				name = "lit [initial(name)]"
			else
				to_chat(user, span_warning("Нечего курить!"))
		else
			return ..()

/obj/item/bong/attack_self(mob/user)
	var/turf/location = get_turf(user)
	if(lit)
		user.visible_message(span_notice("[user] высовывает [src]."), span_notice("Высовываю [src]."))
		lit = FALSE
		icon_state = icon_off
		inhand_icon_state = icon_off
		return
	if(!lit && bonghits > 0)
		to_chat(user, span_notice("Опустошаю [src] в [location]."))
		new /obj/effect/decal/cleanable/ash(location)
		packeditem = FALSE
		bonghits = 0
		reagents.clear_reagents()
	return

/obj/item/bong/attack(mob/hit_mob, mob/user, def_zone)
	if(packeditem && lit)
		if(hit_mob == user)
			hit_mob.visible_message(span_notice("[user] начинает закуривать [src]."))
			playsound(src, 'sound/chemistry/heatdam.ogg', 50, TRUE)
			if(do_after(user,40))
				to_chat(hit_mob, span_notice("Заканчиваю закуривать [src]."))
				if(reagents.total_volume)
					reagents.trans_to(hit_mob, quarter_volume, transfered_by = user, methods = VAPOR)
					bonghits--
				var/turf/open/pos = get_turf(src)
				if(istype(pos) && pos.air.return_pressure() < 2*ONE_ATMOSPHERE)
					pos.atmos_spawn_air("water_vapor=10;TEMP=T20C + 20")
				if(bonghits <= 0)
					to_chat(hit_mob, span_notice("Моя [name] кончается."))
					lit = FALSE
					packeditem = FALSE
					icon_state = icon_off
					inhand_icon_state = icon_off
					name = "[initial(name)]"
					reagents.clear_reagents() //just to make sure

/obj/item/bong/proc/light(flavor_text = null)
	if(lit)
		return
	if(!(flags_1 & INITIALIZED_1))
		icon_state = icon_on
		inhand_icon_state = icon_on
		return

	lit = TRUE
	name = "зажённый [name]"
	if(reagents.get_reagent_amount(/datum/reagent/toxin/plasma)) // the plasma explodes when exposed to fire
		var/datum/effect_system/reagents_explosion/explosion = new()
		explosion.set_up(round(reagents.get_reagent_amount(/datum/reagent/toxin/plasma) / 2.5, 1), get_turf(src), 0, 0)
		explosion.start()
		qdel(src)
		return
	if(reagents.get_reagent_amount(/datum/reagent/fuel)) // the fuel explodes, too, but much less violently
		var/datum/effect_system/reagents_explosion/explosion = new()
		explosion.set_up(round(reagents.get_reagent_amount(/datum/reagent/fuel) / 5, 1), get_turf(src), 0, 0)
		explosion.start()
		qdel(src)
		return
	// allowing reagents to react after being lit
	reagents.flags &= ~(NO_REACT)
	reagents.handle_reactions()
	icon_state = icon_on
	inhand_icon_state = icon_on
	if(flavor_text)
		var/turf/bong_turf = get_turf(src)
		bong_turf.visible_message(flavor_text)

/obj/item/bong/lungbuster
	name = "lungbuster"
	desc = "30 дюймов обреченности."
	icon_state = "lungbusteroff"
	inhand_icon_state = "lungbusteroff"
	icon_on = "lungbusteron"
	icon_off = "lungbusteroff"
	useable_bonghits = 2
	chem_volume = 50

/obj/item/bong/lungbuster/attack(mob/hit_mob, mob/user, def_zone)
	if(packeditem && lit)
		if(hit_mob == user)
			hit_mob.visible_message(span_notice("[user] начинает закуривать [src]."))
			playsound(src, 'sound/chemistry/heatdam.ogg', 50, TRUE)
			if(do_after(user,40))
				to_chat(hit_mob, span_notice("Заканчиваю закуривать [src]."))
				if(reagents.total_volume)
					reagents.trans_to(hit_mob, quarter_volume, transfered_by = user, methods = VAPOR)
					bonghits--
				var/turf/open/pos = get_turf(src)
				if(istype(pos) && pos.air.return_pressure() < 2*ONE_ATMOSPHERE)
					pos.atmos_spawn_air("water_vapor=30;TEMP=T20C + 20")
				if(prob(50))
					playsound(hit_mob, pick('white/rebolution228/sounds/misc/lungbust_moan1.ogg','white/rebolution228/sounds/misc/lungbust_moan2.ogg', 'white/rebolution228/sounds/misc/lungbust_moan3.ogg'), 50, TRUE)
					hit_mob.emote("moan")
				else
					playsound(hit_mob, pick('white/rebolution228/sounds/misc/lungbust_cough1.ogg','white/rebolution228/sounds/misc/lungbust_cough2.ogg'), 50, TRUE)
					hit_mob.emote("cough")
				if(bonghits <= 0)
					to_chat(hit_mob, span_notice("Моя [name] кончилась."))
					lit = FALSE
					packeditem = FALSE
					icon_state = icon_off
					inhand_icon_state = icon_off
					name = "[initial(name)]"
					reagents.clear_reagents() //just to make sure

/datum/crafting_recipe/bong
	name = "Бонг"
	result = /obj/item/bong
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/sheet/glass = 10)
	time = 20
	category = CAT_CHEMISTRY

/datum/crafting_recipe/lungbuster
	name = "The Lungbuster"
	result = /obj/item/bong/lungbuster
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/stack/sheet/glass = 20)
	time = 30
	category = CAT_CHEMISTRY

/obj/item/clothing/mask/cigarette/pipe/crackpipe
	name = "трубка для наркотиков"
	desc = "Трубка из тонкого стекла, предназначенная для курения одной вещи: крэка."
	icon = 'white/rebolution228/icons/unsorted/crack.dmi'
	worn_icon = 'white/rebolution228/icons/unsorted/mask.dmi'
	icon_state = "glass_pipeoff" //it seems like theres some unused crack pipe sprite in masks.dmi, sweet!
	inhand_icon_state = "glass_pipeoff"
	icon_on = "glass_pipeon"
	icon_off = "glass_pipeoff"
	chem_volume = 20

/obj/item/clothing/mask/cigarette/pipe/crackpipe/process(delta_time)
	smoketime -= delta_time
	if(smoketime <= 0)
		if(ismob(loc))
			var/mob/living/smoking_mob = loc
			to_chat(smoking_mob, span_notice("Моя [name] кончается."))
			lit = FALSE
			icon_state = icon_off
			inhand_icon_state = icon_off
			smoking_mob.update_inv_wear_mask()
			packeditem = FALSE
			name = "пустая [initial(name)]"
		STOP_PROCESSING(SSobj, src)
		return
	open_flame()
	if(reagents?.total_volume) // check if it has any reagents at all
		handle_reagents()


/obj/item/clothing/mask/cigarette/pipe/crackpipe/attackby(obj/item/used_item, mob/user, params)
	if(is_type_in_list(used_item, list(/obj/item/reagent_containers/crack,/obj/item/reagent_containers/blacktar)))
		to_chat(user, span_notice("Засовываю [used_item] в [src]."))
		smoketime = 2 * 60
		name = "заполненная [used_item.name] [initial(name)]"
		if(used_item.reagents)
			used_item.reagents.trans_to(src, used_item.reagents.total_volume, transfered_by = user)
		qdel(used_item)
	else
		var/lighting_text = used_item.ignition_effect(src,user)
		if(lighting_text)
			if(smoketime > 0)
				light(lighting_text)
			else
				to_chat(user, span_warning("Нечего курить!"))
		else
			return ..()

/datum/crafting_recipe/crackpipe
	name = "трубка для наркотиков"
	result = /obj/item/clothing/mask/cigarette/pipe/crackpipe
	reqs = list(/obj/item/stack/cable_coil = 5,
				/obj/item/shard = 1,
				/obj/item/stack/rods = 10)
	parts = list(/obj/item/shard = 1)
	time = 20
	category = CAT_CHEMISTRY

/obj/item/reagent_containers/blacktar
	name = "черный деготь героина"
	desc = "Камень из черной смолы героина, нечистой свободной формы героина."
	icon = 'white/rebolution228/icons/unsorted/crack.dmi'
	icon_state = "blacktar"
	volume = 5
	possible_transfer_amounts = list()
	list_reagents = list(/datum/reagent/drug/opium/blacktar = 5)
