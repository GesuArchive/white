////////////////////////////////////////////
// POO POO PEE PEE
// what the fuck now are you retarded?
/////////////////////////////////////

/obj/item/food/poo
	name = "говно"
	desc = "Продукт человеческой единицы."
	icon = 'white/valtos/icons/poo.dmi'
	icon_state = "truepoo"
	tastes = list("shit" = 1, "poo" = 1)
	var/random_icon_states = list("poo1", "poo2", "poo3", "poo4", "poo5", "poo6")
	food_reagents = list(/datum/reagent/toxin/poo = 5)
	microwaved_type = /obj/item/food/poo/cooked
	foodtypes = MEAT | RAW | TOXIC
	grind_results = list()

/obj/item/food/poo/Initialize()
	. = ..()
	if (random_icon_states && (icon_state == initial(icon_state)) && length(random_icon_states) > 0)
		icon_state = pick(random_icon_states)

/obj/item/food/poo/cooked
	name = "жареное говно"
	icon_state = "ppoo1"
	random_icon_states = list("ppoo1", "ppoo2", "ppoo3", "ppoo4", "ppoo5", "ppoo6")

/datum/reagent/toxin/poo
	name = "Говно"
	description = "Говно?"
	color = "#4B3320"
	toxpwr = 2.5
	taste_description = "говно"

/datum/reagent/toxin/poo/on_mob_add(mob/living/C)
	if(C?.client)
		C.client.give_award(/datum/award/score/poo_eaten, C, 1)
	SSblackbox.record_feedback("tally", "poo", 1, "Poo Eaten")
	return ..()

/datum/reagent/toxin/poo/expose_turf(turf/open/T, reac_volume)//splash the poo all over the place
	. = ..()
	if(!istype(T))
		return
	if(reac_volume >= 1)
		T.MakeSlippery(TURF_WET_WATER, 15 SECONDS, min(reac_volume * 2 SECONDS, 120))

	var/obj/effect/decal/cleanable/poo/B = locate() in T //find some poo here
	if(!B)
		B = new(T)

/datum/element/decal/poo
	//dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/element/decal/poo/generate_appearance(_icon, _icon_state, _dir, _layer, _color, _alpha, source)
	var/obj/item/I = source
	if(!_icon)
		_icon = 'white/valtos/icons/poo.dmi'
	if(!_icon_state)
		_icon_state = "itempoo"
	var/icon = initial(I.icon)
	var/icon_state = initial(I.icon_state)
	if(!icon || !icon_state)
		icon = I.icon
		icon_state = I.icon_state
	var/static/list/poo_splatter_appearances = list()
	var/index = "[REF(icon)]-[icon_state]"
	pic = poo_splatter_appearances[index]

	if(!pic)
		var/icon/poo_splatter_icon = icon(initial(I.icon), initial(I.icon_state), , 1)
		poo_splatter_icon.Blend("#fff", ICON_ADD)
		poo_splatter_icon.Blend(icon(_icon, _icon_state), ICON_MULTIPLY)
		pic = mutable_appearance(poo_splatter_icon, initial(I.icon_state))
		poo_splatter_appearances[index] = pic
	return TRUE

/obj/effect/decal/cleanable/poo
	name = "шоколадный каток"
	desc = "И кто это тут размазал?"
	icon = 'white/valtos/icons/poo.dmi'
	icon_state = "splat1"
	random_icon_states = list("splat1", "splat2", "splat3", "splat4", "splat5", "splat6", "splat7", "splat8")

/obj/item/food/poo/throw_impact(atom/hit_atom)
	. = ..()
	if(!.) //if we're not being caught
		splat(hit_atom)

/obj/item/food/poo/proc/splat(atom/movable/hit_atom)
	if(isliving(loc)) //someone caught us!
		return
	var/turf/T = get_turf(hit_atom)
	new/obj/effect/decal/cleanable/poo(T)
	if(reagents && reagents.total_volume)
		reagents.expose(hit_atom, TOUCH)
	if(ishuman(hit_atom))
		var/mob/living/carbon/human/H = hit_atom
		var/mutable_appearance/pooverlay = mutable_appearance('white/valtos/icons/poo.dmi')
		//H.Paralyze(5) //splat!
		H.adjust_blurriness(1)
		H.visible_message(span_warning("<b>[H]</b> ловит <b>[src]</b> своим телом!") , span_userdanger("Ловлю <b>[src]</b> своим телом!"))
		playsound(H, "desceration", 50, TRUE)
		if(!H.pooed) // one layer at a time
			pooverlay.icon_state = "facepoo"
			H.add_overlay(pooverlay)
			pooverlay.icon_state = "uniformpoo"
			H.add_overlay(pooverlay)
			pooverlay.icon_state = "suitpoo"
			H.add_overlay(pooverlay)
			H.pooed = TRUE
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "pooed", /datum/mood_event/pooed)
			SSblackbox.record_feedback("tally", "poo", 1, "Poo Splats")
	if(isitem(hit_atom))
		hit_atom.AddElement(/datum/element/decal/poo)
	qdel(src)

/datum/emote/living/poo
	key = "poo"
	ru_name = "наложить"
	key_third_person = "shits on the floor"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/poo/run_emote(mob/living/user, params)
	. = ..()
	if(.)
		user.try_poo()

/mob/living/proc/try_poo()
	var/list/random_poo = list("покакунькивает", "срёт", "какает", "производит акт дефекации", "обсирается", "выдавливает какулину")
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/guts = H.internal_organs_slot[ORGAN_SLOT_GUTS]
		var/turf/T = get_turf(src)
		var/poo_amount = guts.reagents.get_reagent_amount(/datum/reagent/toxin/poo)
		if(poo_amount >= 25)
			if(HAS_TRAIT(H, TRAIT_LIGHT_POOER))
				H.visible_message(span_notice("<b>[H]</b> [prob(75) ? pick(random_poo) : uppertext(pick(random_poo))] себе прямо в руку!") , \
					span_notice("Выдавливаю какаху из своего тела."))
				playsound(H, 'white/valtos/sounds/poo2.ogg', 25, 1) //silence hunter
				var/obj/item/food/poo/P = new(T)
				H.put_in_hands(P)
				if(!H.throw_mode)
					H.throw_mode_on(THROW_MODE_TOGGLE)
				guts.reagents.remove_reagent(/datum/reagent/toxin/poo, 25)
				SSblackbox.record_feedback("tally", "poo", 1, "Poo Created")
				return
			else
				if(H.get_item_by_slot(ITEM_SLOT_ICLOTHING))
					H.visible_message(span_notice("<b>[H]</b> [prob(75) ? pick(random_poo) : uppertext(pick(random_poo))] себе в штаны!") , \
						span_notice("Сру себе в штаны."))
					playsound(H, 'white/valtos/sounds/poo2.ogg', 50, 1)
					guts.reagents.remove_reagent(/datum/reagent/toxin/poo, 25)
					if(!H.pooed)
						var/mutable_appearance/pooverlay = mutable_appearance('white/valtos/icons/poo.dmi')
						pooverlay.icon_state = "uniformpoo"
						H.add_overlay(pooverlay)
						pooverlay.icon_state = "suitpoo"
						H.add_overlay(pooverlay)
						H.pooed = TRUE
						SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "pooed", /datum/mood_event/pooed)
					SSblackbox.record_feedback("tally", "poo", 1, "Poo Self")
					return
				else if(locate(/obj/structure/toilet) in T || locate(/obj/structure/toilet/greyscale) in T)
					H.visible_message(span_notice("<b>[H]</b> [prob(75) ? pick(random_poo) : uppertext(pick(random_poo))] в туалет!") , \
						span_notice("Выдавливаю какаху прямиком в туалет."))
					playsound(H, 'white/valtos/sounds/poo2.ogg', 50, 1)
					guts.reagents.remove_reagent(/datum/reagent/toxin/poo, 25)
					SSblackbox.record_feedback("tally", "poo", 1, "Poo Created")
					return
				else
					H.visible_message(span_notice("<b>[H]</b> [prob(75) ? pick(random_poo) : uppertext(pick(random_poo))] на пол!") , \
						span_notice("Выдавливаю какаху из своего тела."))
					playsound(H, 'white/valtos/sounds/poo2.ogg', 50, 1)
					new /obj/item/food/poo(T)
					guts.reagents.remove_reagent(/datum/reagent/toxin/poo, 25)
					SSblackbox.record_feedback("tally", "poo", 1, "Poo Created")
					return
		else if(H.stat == CONSCIOUS)
			H.visible_message(span_notice("<b>[H]</b> тужится!") , \
					span_notice("Вам нечем какать."))
			H.adjust_blurriness(1)
			SSblackbox.record_feedback("tally", "poo", 1, "Poo Creation Failed")
			return

/atom/proc/wash_poo()
	return TRUE

/mob/living/carbon/human/wash_poo()
	if(pooed)
		cut_overlay(mutable_appearance('white/valtos/icons/poo.dmi', "facepoo"))
		cut_overlay(mutable_appearance('white/valtos/icons/poo.dmi', "uniformpoo"))
		cut_overlay(mutable_appearance('white/valtos/icons/poo.dmi', "suitpoo"))
		pooed = FALSE
		SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "pooed")

/datum/quirk/legkoserya
	name = "Легкосеря"
	desc = "Древнее умение какать прямо себе в руку и не только."
	value = 2
	mob_trait = TRAIT_LIGHT_POOER
	gain_text = span_notice("Теперь я знаю древние техники покакунек.")
	lose_text = span_danger("Забываю как правильно какать.")
	medical_record_text = "Дефекационные навыки пациента стоят за гранью понимания." //prikol

/datum/quirk/legkoserya/post_add()
	var/mob/living/carbon/human/H = quirk_holder
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/poop_barricade)

/datum/crafting_recipe/poop_barricade
	name = "стена говна"
	result = /obj/structure/poop_barricade
	tool_behaviors = list()
	reqs = list(/obj/item/food/poo = 5)
	time = 25
	category = CAT_STRUCTURE
	always_available = FALSE

/obj/structure/poop_barricade
	name = "стена говна"
	desc = "ПАХНЕТ!"
	icon = 'white/valtos/icons/poo.dmi'
	icon_state = "barricade"
	density = TRUE
	anchored = TRUE

/obj/structure/poop_barricade/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	for(var/mob/M in T)
		dir = M.dir
		break
	if(dir == SOUTH)
		layer = ABOVE_MOB_LAYER
	AddElement(/datum/element/climbable)

/obj/structure/poop_barricade/attackby(obj/item/I, mob/living/user, params)
	..()
	add_fingerprint(user)

	if(istype(I, /obj/item/food/poo) && user.a_intent == INTENT_HELP)
		if(obj_integrity < max_integrity)
			to_chat(user, span_notice("Начинаю чинить стену говна..."))
			if(do_after(user, 20, target = src))
				obj_integrity = max_integrity
				to_chat(user, span_notice("Чиню стену говна говном."))
		else
			to_chat(user, span_warning("[capitalize(src.name)] уже в порядке!"))
		return

/obj/structure/poop_barricade/deconstruct(disassembled)
	. = ..()
	if(!loc)
		return
	if(!(flags_1 & NODECONSTRUCT_1))
		var/obj/item/food/poo/P = new /obj/item/food/poo(drop_location(), 3)
		transfer_fingerprints_to(P)
		qdel(src)

/obj/structure/barricade/CanAllowThrough(atom/movable/mover, border_dir)
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
