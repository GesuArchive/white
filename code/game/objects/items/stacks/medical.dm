/obj/item/stack/medical
	name = "медипак"
	var/skloname = "медипак"
	singular_name = "медипак"
	icon = 'icons/obj/stack_medical.dmi'
	amount = 6
	max_amount = 6
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	resistance_flags = FLAMMABLE
	max_integrity = 40
	novariants = FALSE
	item_flags = NOBLUDGEON
	cost = 250
	source = /datum/robot_energy_storage/medical
	merge_type = /obj/item/stack/medical
	/// How long it takes to apply it to yourself
	var/self_delay = 5 SECONDS
	/// How long it takes to apply it to someone else
	var/other_delay = 0
	/// If we've still got more and the patient is still hurt, should we keep going automatically?
	var/repeating = FALSE
	/// How much brute we heal per application. This is the only number that matters for simplemobs
	var/heal_brute
	/// How much burn we heal per application
	var/heal_burn
	/// How much we reduce bleeding per application on cut wounds
	var/stop_bleeding
	/// How much sanitization to apply to burn wounds on application
	var/sanitization
	/// How much we add to flesh_healing for burn wounds on application
	var/flesh_regeneration

/obj/item/stack/medical/attack(mob/living/M, mob/user)
	. = ..()
	try_heal(M, user)

/// In which we print the message that we're starting to heal someone, then we try healing them. Does the do_after whether or not it can actually succeed on a targeted mob
/obj/item/stack/medical/proc/try_heal(mob/living/patient, mob/user, silent = FALSE)
	if(!patient.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
		return
	if(patient == user)
		if(!silent)
			user.visible_message(span_notice("<b>[user]</b> начинает применять <b>[skloname]</b> на себе...") , span_notice("Начинаю применять <b>[skloname]</b> на себе..."))
		if(!do_mob(user, patient, self_delay, extra_checks=CALLBACK(patient, /mob/living/proc/try_inject, user, null, INJECT_TRY_SHOW_ERROR_MESSAGE)))
			return
	else if(other_delay)
		if(!silent)
			user.visible_message(span_notice("<b>[user]</b> начинает применять <b>[skloname]</b> на <b>[patient]</b>.") , span_notice("Начинаю применять <b>[skloname]</b> на <b>[patient]</b>..."))
		if(!do_mob(user, patient, other_delay, extra_checks=CALLBACK(patient, /mob/living/proc/try_inject, user, null, INJECT_TRY_SHOW_ERROR_MESSAGE)))
			return

	if(heal(patient, user))
		log_combat(user, patient, "healed", src.name)
		use(1)
		if(repeating && amount > 0)
			try_heal(patient, user, TRUE)

/// Apply the actual effects of the healing if it's a simple animal, goes to [/obj/item/stack/medical/proc/heal_carbon] if it's a carbon, returns TRUE if it works, FALSE if it doesn't
/obj/item/stack/medical/proc/heal(mob/living/patient, mob/user)
	if(patient.stat == DEAD)
		to_chat(user, span_warning("[patient] мертв! Ничем не могу помочь [patient.ru_na()]."))
		return
	if(isanimal(patient) && heal_brute) // only brute can heal
		var/mob/living/simple_animal/critter = patient
		if (!critter.healable)
			to_chat(user, span_warning("Не могу использовать [src] на [patient]!"))
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, span_notice("[patient] полностью здоров."))
			return FALSE
		user.visible_message(span_green("[user] использует [src] на [patient].") , span_green("Использую [src] на [patient]."))
		patient.heal_bodypart_damage((heal_brute * 0.5))
		return TRUE
	if(iscarbon(patient))
		return heal_carbon(patient, user, heal_brute, heal_burn)
	to_chat(user, span_warning("Не могу вылечить [patient] с помощью [src]!"))

/// The healing effects on a carbon patient. Since we have extra details for dealing with bodyparts, we get our own fancy proc. Still returns TRUE on success and FALSE on fail
/obj/item/stack/medical/proc/heal_carbon(mob/living/carbon/C, mob/user, brute, burn)
	var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
	if(!affecting) //Missing limb?
		to_chat(user, span_warning("А у <b>[C]</b> совсем отсутствует <b>[ru_exam_parse_zone(parse_zone(user.zone_selected))]</b>!"))
		return FALSE
	if(affecting.status != BODYPART_ORGANIC) //Limb must be organic to be healed - RR
		to_chat(user,  span_warning("<b>[capitalize(src)]</b> не будет работать на механической конечности!"))
		return FALSE
	if(affecting.brute_dam && brute || affecting.burn_dam && burn)
		user.visible_message(span_green("<b>[user]</b> применяет <b>[skloname]</b> на <b>[ru_parse_zone(affecting.name)] [C]</b>.") , span_green("Применяю <b>[skloname]</b> на <b>[ru_parse_zone(affecting.name)] [C]</b>."))
		var/previous_damage = affecting.get_damage()
		if(affecting.heal_damage(brute, burn))
			C.update_damage_overlays()
		post_heal_effects(max(previous_damage - affecting.get_damage(), 0), C, user)
		return TRUE
	to_chat(user, span_warning("<b>[capitalize(affecting.name)] [C]</b> не может быть вылечена при помощи [src]!"))
	return FALSE

///Override this proc for special post heal effects.
/obj/item/stack/medical/proc/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/user)
	return

/obj/item/stack/medical/bruise_pack
	name = "гель и пластыри"
	singular_name = "гель и пластыри"
	skloname = "гель и пластыри"
	desc = "Терапевтический гель и пластыри, предназначенные для лечения травм."
	icon_state = "brutepack"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	heal_brute = 40
	self_delay = 4 SECONDS
	other_delay = 2 SECONDS
	grind_results = list(/datum/reagent/medicine/c2/libital = 10)
	merge_type = /obj/item/stack/medical/bruise_pack

/obj/item/stack/medical/bruise_pack/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] избивает [user.ru_na()]себя с помощью [src]! Это выглядит будто [user.p_theyre()] пытается совершить самоубийство!"))
	return (BRUTELOSS)

/obj/item/stack/medical/gauze
	name = "медицинский бинт"
	skloname = "медицинский бинт"
	desc = "Рулон эластичной ткани, который чрезвычайно эффективен при остановке кровотечения, правит переломы, но не заживляет раны."
	gender = PLURAL
	singular_name = "медицинская марля"
	icon_state = "gauze"
	self_delay = 5 SECONDS
	other_delay = 2 SECONDS
	max_amount = 12
	amount = 6
	grind_results = list(/datum/reagent/cellulose = 2)
	custom_price = PAYCHECK_ASSISTANT * 2
	absorption_rate = 0.125
	absorption_capacity = 5
	splint_factor = 0.35
	merge_type = /obj/item/stack/medical/gauze

// gauze is only relevant for wounds, which are handled in the wounds themselves
/obj/item/stack/medical/gauze/try_heal(mob/living/M, mob/user, silent)
	var/obj/item/bodypart/limb = M.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		to_chat(user, span_notice("Здесь нечего перевязывать!"))
		return
	if(!LAZYLEN(limb.wounds))
		to_chat(user, span_notice("Рана не требует перевязки на [limb.name][user==M ? "" : " [M]"]!")) // good problem to have imo
		return

	var/gauzeable_wound = FALSE
	for(var/i in limb.wounds)
		var/datum/wound/woundies = i
		if(woundies.wound_flags & ACCEPTS_GAUZE)
			gauzeable_wound = TRUE
			break
	if(!gauzeable_wound)
		to_chat(user, span_notice("Рана не требует перевязки на [limb.name][user==M ? "" : " [M]"]!")) // good problem to have imo
		return

	if(limb.current_gauze && (limb.current_gauze.absorption_capacity * 0.8 > absorption_capacity)) // ignore if our new wrap is < 20% better than the current one, so someone doesn't bandage it 5 times in a row
		to_chat(user, span_warning("Бинт на [limb.name] [user==M ? "" : "[M]"] всё ещё в норме!"))
		return

	user.visible_message(span_warning("[user] начинает оборачивать [limb.name] [M] используя [src.name]...") , span_warning("Начинаю оборачивать [limb.name] [user == M ? "" : "[M]"] используя [src.name]..."))

	if(!do_after(user, (user == M ? self_delay : other_delay), target=M))
		return

	user.visible_message(span_green("[user] применяет [src.name] на [limb.name] [M].") , span_green("Перевязываю раны на [limb.name] [user == M ? "yourself" : "[M]"]."))
	limb.apply_gauze(src)

/obj/item/stack/medical/gauze/twelve
	amount = 12

/obj/item/stack/medical/gauze/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER || I.get_sharpness())
		if(get_amount() < 2)
			to_chat(user, span_warning("На как минимум два кусочка бинта!"))
			return
		new /obj/item/stack/sheet/cloth(user.drop_location())
		user.visible_message(span_notice("<b>[user]</b> нарезает <b>[src]</b> на куски ткани при помощи <b>[I]</b>.") , \
			span_notice("Нарезаю <b>[src]</b> на куски ткани при помощи <b>[I]</b>.") , \
			span_hear("Слышу как что-то режет ткань."))
		use(2)
	else
		return ..()

/obj/item/stack/medical/gauze/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] начинает затягивать [src] на шее [user.ru_ego()]! Это выглядит как будто [user.ru_who()] забыл как оказывать медицинскую помощь!"))
	return OXYLOSS

/obj/item/stack/medical/gauze/improvised
	name = "импровизированный бинт"
	skloname = "импровизированный бинт"
	singular_name = "импровизированный бинт"
	desc = "Рулон эластичной ткани, который чрезвычайно эффективен при остановке кровотечения, правит переломы, но не заживляет раны. Менее эффективен своих аналогов."
	self_delay = 6 SECONDS
	other_delay = 3 SECONDS
	absorption_rate = 0.075
	absorption_capacity = 4
	merge_type = /obj/item/stack/medical/gauze/improvised

	/*
	The idea is for the following medical devices to work like a hybrid of the old brute packs and tend wounds,
	they heal a little at a time, have reduced healing density and does not allow for rapid healing while in combat.
	However they provice graunular control of where the healing is directed, this makes them better for curing work-related cuts and scrapes.

	The interesting limb targeting mechanic is retained and i still believe they will be a viable choice, especially when healing others in the field.
	 */

/obj/item/stack/medical/suture
	name = "хирургическая нить"
	skloname = "хирургическую нить"
	desc = "Стерильные швы используются для герметизации порезов и разрывов."
	gender = FEMALE
	singular_name = "нить"
	icon_state = "suture"
	self_delay = 3 SECONDS
	other_delay = 1 SECONDS
	amount = 10
	max_amount = 10
	repeating = TRUE
	heal_brute = 10
	stop_bleeding = 0.6
	grind_results = list(/datum/reagent/medicine/spaceacillin = 2)
	merge_type = /obj/item/stack/medical/suture

/obj/item/stack/medical/suture/emergency
	name = "экстренный шов"
	desc = "Набор дешевых швов, не очень хорош для залатывания ран, однако эффективно останавливает кровотечения."
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "suture_white"
	heal_brute = 5
	amount = 5
	max_amount = 10
	stop_bleeding = 0.75
	merge_type = /obj/item/stack/medical/suture/emergency

/obj/item/stack/medical/suture/medicated
	name = "лечебная хирургическая нить"
	skloname = "лечебную хирургическую нить"
	icon_state = "suture_purp"
	desc = "Нить, наполненная лекарственными средствами, ускоряющими заживление раны на обработанной ране."
	heal_brute = 15
	stop_bleeding = 0.75
	grind_results = list(/datum/reagent/medicine/polypyr = 1)
	merge_type = /obj/item/stack/medical/suture/medicated

/obj/item/stack/medical/ointment
	name = "мазь"
	skloname = "мазь"
	desc = "Используется для лечения этих неприятных ожоговых ран."
	gender = FEMALE
	singular_name = "мазь"
	icon_state = "ointment"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	amount = 8
	max_amount = 8
	self_delay = 4 SECONDS
	other_delay = 2 SECONDS

	heal_burn = 5
	flesh_regeneration = 2.5
	sanitization = 0.25
	grind_results = list(/datum/reagent/medicine/c2/lenturi = 10)
	merge_type = /obj/item/stack/medical/ointment

/obj/item/stack/medical/ointment/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is squeezing [src] into [user.ru_ego()] mouth! [user.p_do(TRUE)]n't [user.ru_who()] know that stuff is toxic?"))
	return TOXLOSS

/obj/item/stack/medical/mesh
	name = "регенеративная сетка"
	skloname = "регенеративную сетку"
	desc = "Бактериостатическая сетка используется для прижигания ожогов. Для использования необходимо снять стерильную пленку."
	gender = PLURAL
	singular_name = "регенеративная сетка"
	icon_state = "regen_mesh"
	self_delay = 3 SECONDS
	other_delay = 1 SECONDS
	amount = 15
	heal_burn = 10
	max_amount = 15
	repeating = TRUE
	sanitization = 0.75
	flesh_regeneration = 3

	var/is_open = TRUE ///This var determines if the sterile packaging of the mesh has been opened.
	grind_results = list(/datum/reagent/medicine/spaceacillin = 2)
	merge_type = /obj/item/stack/medical/mesh

/obj/item/stack/medical/mesh/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	if(amount == max_amount)	 //only seal full mesh packs
		is_open = FALSE
		update_icon()

/obj/item/stack/medical/mesh/update_icon_state()
	if(!is_open)
		icon_state = "regen_mesh_closed"
	else
		return ..()

/obj/item/stack/medical/mesh/try_heal(mob/living/M, mob/user, silent = FALSE)
	if(!is_open)
		to_chat(user, span_warning("Надо бы открыть <b>[src]</b> сначала."))
		return
	return ..()

/obj/item/stack/medical/mesh/AltClick(mob/living/user)
	if(!is_open)
		to_chat(user, span_warning("Надо бы открыть <b>[src]</b> сначала."))
		return
	return ..()

/obj/item/stack/medical/mesh/attack_hand(mob/user)
	if(!is_open && user.get_inactive_held_item() == src)
		to_chat(user, span_warning("Надо бы открыть <b>[src]</b> сначала."))
		return
	return ..()

/obj/item/stack/medical/mesh/attack_self(mob/user)
	if(!is_open)
		is_open = TRUE
		to_chat(user, span_notice("Открываю стерильную упаковку сетки."))
		update_icon()
		playsound(src, 'sound/items/poster_ripped.ogg', 20, TRUE)
		return
	return ..()

/obj/item/stack/medical/mesh/advanced
	name = "продвинутая регенеративная сетка"
	skloname = "продвинутую регенеративную сетку"
	desc = "Передовая сетка из экстрактов алоэ и стерилизующих химикатов, используемых для лечения ожогов."
	gender = FEMALE
	singular_name = "продвинутая регенеративная сетка"
	icon_state = "aloe_mesh"
	heal_burn = 15
	sanitization = 1.25
	flesh_regeneration = 3.5
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)
	merge_type = /obj/item/stack/medical/mesh/advanced

/obj/item/stack/medical/mesh/advanced/update_icon_state()
	if(!is_open)
		icon_state = "aloe_mesh_closed"
	else
		return ..()

/obj/item/stack/medical/aloe
	name = "крем алоэ"
	skloname = "крем алоэ"
	gender = PLURAL
	singular_name = "aloe cream"
	icon_state = "aloe_paste"
	self_delay = 2 SECONDS
	other_delay = 1 SECONDS
	novariants = TRUE
	amount = 20
	max_amount = 20
	repeating = TRUE
	heal_brute = 3
	heal_burn = 3
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)
	merge_type = /obj/item/stack/medical/aloe

/obj/item/stack/medical/bone_gel
	name = "Костный гель"
	singular_name = "bone gel"
	desc = "Мощный медицинский гель, который при нанесении на поврежденную кость в надлежащих хирургических условиях вызывает сращивание кости. Может применяться вместе с хирургической липкой лентой к сломанной кости в чрезвычайных ситуациях, хотя это и не рекомендуется ведь это вредно для пациента."

	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

	amount = 1
	self_delay = 20
	grind_results = list(/datum/reagent/bone_dust = 10, /datum/reagent/carbon = 10)
	novariants = TRUE
	merge_type = /obj/item/stack/medical/bone_gel

/obj/item/stack/medical/bone_gel/attack(mob/living/M, mob/user)
	to_chat(user, span_warning("Костный гель можно использовать только на сломанных конечностях!"))
	return

/obj/item/stack/medical/bone_gel/suicide_act(mob/user)
	if(!iscarbon(user))
		return
	var/mob/living/carbon/C = user
	C.visible_message(span_suicide("[C] впрыскивает весь [src] в рот [C.ru_ego ()]! Это неправильная процедура! Похоже, [C.p_theyre ()] пытается покончить жизнь самоубийством!"))
	if(!do_after(C, 2 SECONDS))
		C.visible_message(span_suicide("[C] облажался и все равно умирает!"))
		return (BRUTELOSS)

	C.emote("agony")
	for(var/i in C.bodyparts)
		var/obj/item/bodypart/bone = i
		var/datum/wound/blunt/severe/oof_ouch = new
		oof_ouch.apply_wound(bone)
		var/datum/wound/blunt/critical/oof_OUCH = new
		oof_OUCH.apply_wound(bone)

	for(var/i in C.bodyparts)
		var/obj/item/bodypart/bone = i
		bone.receive_damage(brute=60)
	use(1)
	return (BRUTELOSS)

/obj/item/stack/medical/bone_gel/four
	amount = 4

/obj/item/stack/medical/poultice
	name = "поминальные припарки"
	singular_name = "mourning poultice"
	desc = "Тип примитивной травяной припарки. \nХотя она традиционно используется для подготовки покойника к прощанию, ей также можно лечить царапины и ожоги у живых, однако при таком применении может вызвать сбивчивое дыхание. \nМудрость предков."
	icon_state = "poultice"
	amount = 15
	max_amount = 15
	heal_brute = 10
	heal_burn = 10
	self_delay = 40
	other_delay = 10
	repeating = TRUE
	drop_sound = 'sound/misc/moist_impact.ogg'
	mob_throw_hit_sound = 'sound/misc/moist_impact.ogg'
	hitsound = 'sound/misc/moist_impact.ogg'
	merge_type = /obj/item/stack/medical/poultice

/obj/item/stack/medical/poultice/heal(mob/living/M, mob/user)
	if(iscarbon(M))
		playsound(src, 'sound/misc/soggy.ogg', 30, TRUE)
		return heal_carbon(M, user, heal_brute, heal_burn)
	return ..()

/obj/item/stack/medical/poultice/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/user)
	. = ..()
	healed_mob.adjustOxyLoss(amount_healed)
