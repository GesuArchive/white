/obj/item/melee/baseball_bat/hos/debug
	name = "Дебаг блять"
	debug_morph = TRUE
	selectable = FALSE
/obj/item/melee/baseball_bat/hos
	name = "ассбольная бита"
	desc = "Рукоятка обтянута кожей ассистентов. Элегантно и практично."
	icon = 'white/RedFoxIV/icons/obj/weapons/melee/hosbat/hosbat.dmi'
	slot_flags = ITEM_SLOT_BELT
	icon_state = "falloutbat"
	//тгбляди.
	inhand_icon_state = null //судя по всему, где-то выше по коду эта переменная перезаписывается и ломает мне инхенды.
	//Похожее я видел у сабли, где icon_state = "sabre", и на следующей строчке inhand_icon_state тоже приравнивался к сабле.
	//Нахуя это сделано, если используется обычный icon_state при inhand_icon_state равном null, мне не ясно.


	lefthand_file = 'white/RedFoxIV/icons/obj/weapons/melee/hosbat/hosbat_lefthand.dmi'
	righthand_file = 'white/RedFoxIV/icons/obj/weapons/melee/hosbat/hosbat_righthand.dmi'
	force = 25
	block_chance = 25
	worn_icon_state = "katana" //временное решение, пока я не найду в себе силы заспрайтить в себе ещё 9 бит блять
	var/reskinned = FALSE
	///adminbus
	var/debug_morph = FALSE
	///whether it can be selected.
	var/selectable = TRUE
	///the only ckey who is allowed to choose this skin. null for unrestricted access.
	var/list/allowed_ckey = null
	///if not null, the item will be replaced with path stored in this variable.
	var/replace_with = null
	custom_materials = list(/datum/material/iron = MINERAL_MATERIAL_AMOUNT * 3.5)

//<stolen from nullrod code>
/obj/item/melee/baseball_bat/hos/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src) || reskinned)
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE



/obj/item/melee/baseball_bat/hos/attack_self(mob/user)
	. = ..()
	if((!user.mind || reskinned) && !debug_morph)
		return
	var/list/display_names = list()
	var/list/bat_icons = list()

	var/list/available_items = typesof(/obj/item/melee/baseball_bat/hos)
	//if you want to add an item to the selection that is not subtype of /obj/item/melee/baseball_bat/hos, add it here
	var/list/additional_items = list(/obj/item/item_generator/brick)
	//////////////////////////////////////////////////////////////////
	for(var/bat in available_items)
		var/obj/item/melee/baseball_bat/hos/bat_type = bat
		if(!initial(bat_type.selectable))
			continue
		var/ackey = initial(bat_type.allowed_ckey)
		if(ackey)
			if(user.ckey != ackey)
				continue
		display_names[initial(bat_type.name)] = bat_type
		bat_icons += list(initial(bat_type.name) = image(icon = initial(bat_type.icon), icon_state = initial(bat_type.icon_state)))

	for(var/item_type in additional_items)
		var/obj/item/item = item_type
		display_names[initial(item.name)] = item
		bat_icons += list(initial(item.name) = image(icon = initial(item.icon), icon_state = initial(item.icon_state)))
	bat_icons = sort_list(bat_icons)
	var/choice = show_radial_menu(user, src , bat_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 42, require_near = TRUE)
	if(!choice || !check_menu(user))
		return

	var/picked_bat_type = display_names[choice] // This needs to be on a separate var as list member access is not allowed for new
	var/obj/item/melee/baseball_bat/hos/chosen_bat = new picked_bat_type(user.drop_location())

	if(chosen_bat)
		qdel(src)
		if(istype(chosen_bat, /obj/item/melee/baseball_bat/hos))
			if(!debug_morph)
				chosen_bat.reskinned = TRUE
			chosen_bat.debug_morph = debug_morph
		user.put_in_hands(chosen_bat)
//</stolen from nullrod code>


//wzoom
/obj/item/melee/baseball_bat/hos/laserbat
	name = "световая бита"
	desc = "<span class='danger'>Бита элитного бойца</span><font color = 'gray'><br>Вас переполняет сила!<br>Разнесите врагов на мелкие кусочки!"
	icon_state = "laserbat"
	hitsound = 'sound/weapons/blade1.ogg'
	damtype = BURN



//FISH KILL!!
/obj/item/melee/baseball_bat/hos/holymackerel
	name = "\"Поддай леща\""
	desc = "Убийство рыбой - самое унизительное наказание для врага."
	icon_state = "holymackerel"
	hitsound = 'white/RedFoxIV/sounds/weapons/holy_mackerel.ogg'
	force = 7

/obj/item/melee/baseball_bat/hos/holymackerel/attack(mob/living/target, mob/living/user)
	/*
	. = ..(target, user, FALSE) //do not throw people around
	target.adjust_disgust(10)  //make them vomit instead
	user.changeNext_move(5)   //and do it fast
	*/
	var/knockback = FALSE
	if(istype(target,/mob/living/carbon))
		var/mob/living/carbon/C = target
		if(C.disgust > 70) //7 consecutive hits (counting disgust decay)
			knockback = TRUE
		target.adjust_disgust(12)
	. = ..(target, user, knockback)
	user.changeNext_move(5)
	if(target.timeofdeath == world.time)
		visible_message("<span class = 'hypnophrase'>УБИЙСТВО РЫБОЙ!</span>")

/obj/item/melee/baseball_bat/hos/holymackerel/attack_obj(obj/O, mob/living/user)
	. = ..()
	user.changeNext_move(5)


//кирпич
/obj/item/item_generator/brick //Сегодня мы пиздим у Молдаван
	name = "Мешок с кирпичами"
	desc = "Ворует кирпичи у Молдаван используя блюспейс технологию. Достаточно теплый на ощупь"
	slot_flags = ITEM_SLOT_BELT
	charges = 3
	max_charges = 3
	self_charge = TRUE
	recharge_time = 12 SECONDS
	items = list(/obj/item/melee/brick)
	bluespace_effect = TRUE
	word1 = "кирпич"
	word2 = "кирпича"
	word5 = "кирпичей"

/obj/item/item_generator/brick/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/item_generator/brick/update_overlays()
	. = ..()
	. += "overlay_bluespace"

/obj/item/melee/brick
	name = "кирпич"
	desc = "Необычайно тяжёлый кирпич. Удобно сидит в вашей руке."
	icon = 'white/RedFoxIV/icons/obj/weapons/melee/hosbat/hosbat.dmi'
	icon_state = "brick"
	force = 5
	throwforce = 20
	w_class = WEIGHT_CLASS_SMALL

/obj/item/melee/brick/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(isliving(loc) && prob(75)) //i have no fucking idea if this works lmfao
		return
	if(!istype(hit_atom,/mob/living))
		src.visible_message(message = span_alert("The brick shatters into a fine mist upon impact, like it never existed to begin with..."))
		qdel(src)
		return

	var/mob/living/L = hit_atom
	L.Paralyze(5)
	L.Jitter(15)
	L.blur_eyes(10)
	if (prob(0.1)) //расколбас
		var/obj/item/bodypart/head/head = L.get_bodypart(BODY_ZONE_HEAD)
		if(!head)
			qdel(src)
			return
		L.visible_message(span_danger("Голова [L] распидорашивается кирпичом нахуй!") , span_userdanger("Кирпич уничтожает мою голову!"))
		new /obj/effect/gibspawner/generic(get_turf(L), L)
		head.dismember(BRUTE)
		head.drop_organs()
		qdel(head)
		L.regenerate_icons()
	qdel(src)

/obj/item/melee/baseball_bat/hos/stopsign
	name = "дорожный знак"
	desc = "Где ты его вообще достал? В космосе ведь нет дорог."
	icon_state = "stopsign"
	force = 17
	sharpness = SHARP_EDGED

// /obj/item/melee/baseball_bat/hos/stopsign/attack(mob/living/target, mob/living/user)



//уёбищная бита, заменить на другую
/*
/obj/item/melee/baseball_bat/hos/bonebat
	name = "костяная бита"
	desc = "Не имеет никакого отношения к Костяну. Сделана из костей ассистентов."
*/






//The violence has escalated.
/obj/item/melee/baseball_bat/hos/ak47
	name = "AK-47"
	desc = "Отрывает лицо с очереди. Использует противотанковый калибр 7.62."
	icon_state = "74ka"

//Молот ЧВК
/obj/item/melee/baseball_bat/hos/hammer
	name = "кувалда"
	desc = "То же самое, что и обычный молоток, только в два раза больше (и в два раза больнее!)"
	icon_state = "hammer"
	var/wielded = FALSE
	var/datum/component/two_handed/wieldcomp

/obj/item/melee/baseball_bat/hos/hammer/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=17, force_wielded=30, icon_wielded = "hammer_wielded")


//зачем нахуй? почему тгшники обязательно должны жрать говно?..
/obj/item/melee/baseball_bat/hos/hammer/update_icon_state()
	. = ..()
	icon_state = "hammer"

/obj/item/melee/baseball_bat/hos/hammer/attack(mob/living/target, mob/living/user)
	. = ..(target, user, wielded)
	if(wielded)
		user.changeNext_move(CLICK_CD_MELEE*2)

/obj/item/melee/baseball_bat/hos/hammer/attack_obj(obj/O, mob/living/user)
	. = ..(O, user, FALSE)
	if(wielded)
		user.changeNext_move(CLICK_CD_MELEE*2)


						//<stolen from fireaxe code>
/obj/item/melee/baseball_bat/hos/hammer/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))


/// triggered on wield of two handed item
/obj/item/melee/baseball_bat/hos/hammer/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/melee/baseball_bat/hos/hammer/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

						//</stolen from fireaxe code>


//Хрюкни
/obj/item/melee/baseball_bat/hos/hrukni
	name = "сранклин"
	desc = "Хрюкни."
	icon_state = "hrukni"
	force = 15
	allowed_ckey = "sranklin"

/obj/item/melee/baseball_bat/hos/hrukni/attack(mob/living/target, mob/living/user)
	. = ..()
	target.emote("poo")
	if(prob(30))
		to_chat(target, "<span notice='userdanger'>[pick("Врата прорвало!", "Не могу перестать СРАТЬ!")]</span>")
		target.Immobilize(20)
		for(var/i = 1, i< rand(4,10),i++)
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, emote), "poo"), 12*i)
