/*
Slimecrossing Armor
	Armor added by the slimecrossing system.
	Collected here for clarity.
*/

//Rebreather mask - Chilling Blue
/obj/item/clothing/mask/nobreath
	name = "маска-ребризер"
	desc = "Прозрачная маска, напоминающая обычную дыхательную маску, но сделанная из голубоватой слизи. Кажется, что не имеет трубки для подачи воздуха."
	icon_state = "slime"
	inhand_icon_state = "slime"
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_SMALL
	clothing_traits = list(TRAIT_NOBREATH)
	gas_transfer_coefficient = 0
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 50, FIRE = 0, ACID = 0)
	flags_cover = MASKCOVERSMOUTH
	resistance_flags = NONE

/obj/item/clothing/mask/nobreath/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_MASK)
		user.failed_last_breath = FALSE
		user.clear_alert("not_enough_oxy")
		user.apply_status_effect(/datum/status_effect/rebreathing)

/obj/item/clothing/mask/nobreath/dropped(mob/living/carbon/human/user)
	..()
	user.remove_status_effect(/datum/status_effect/rebreathing)

/obj/item/clothing/glasses/prism_glasses
	name = "призматические очки"
	desc = "Похоже что линзы слегка светятся и отражают свет ослепляющими цветами."
	icon = 'icons/obj/slimecrossing.dmi'
	icon_state = "prismglasses"
	actions_types = list(/datum/action/item_action/change_prism_colour, /datum/action/item_action/place_light_prism)
	var/glasses_color = "#FFFFFF"

/obj/item/clothing/glasses/prism_glasses/item_action_slot_check(slot)
	if(slot == ITEM_SLOT_EYES)
		return TRUE

/obj/structure/light_prism
	name = "световая призма"
	desc = "Сияющий полупрозрачный кристалл. Выглядит хрупким."
	icon = 'icons/obj/slimecrossing.dmi'
	icon_state = "lightprism"
	density = FALSE
	anchored = TRUE
	max_integrity = 10

/obj/structure/light_prism/Initialize(mapload, newcolor)
	. = ..()
	color = newcolor
	set_light_color(newcolor)
	set_light(5)

/obj/structure/light_prism/attack_hand(mob/user)
	to_chat(user, span_notice("Рассеиваю [src]."))
	qdel(src)

/datum/action/item_action/change_prism_colour
	name = "Отрегулировать Призматическую Линзу"
	button_icon = 'icons/obj/slimecrossing.dmi'
	button_icon_state = "prismcolor"

/datum/action/item_action/change_prism_colour/Trigger(trigger_flags)
	if(!IsAvailable())
		return
	var/obj/item/clothing/glasses/prism_glasses/glasses = target
	var/new_color = input(owner, "Choose the lens color:", "Color change",glasses.glasses_color) as color|null
	if(!new_color)
		return
	glasses.glasses_color = new_color

/datum/action/item_action/place_light_prism
	name = "Изготовить Световую Призму"
	button_icon = 'icons/obj/slimecrossing.dmi'
	button_icon_state = "lightprism"

/datum/action/item_action/place_light_prism/Trigger(trigger_flags)
	if(!IsAvailable())
		return
	var/obj/item/clothing/glasses/prism_glasses/glasses = target
	if(locate(/obj/structure/light_prism) in get_turf(owner))
		to_chat(owner, span_warning("Не хватает окружающей энергии для изготовления еще одной световой призмы."))
		return
	if(istype(glasses))
		if(!glasses.glasses_color)
			to_chat(owner, span_warning("Линза на удивление непрозрачная..."))
			return
		to_chat(owner, span_notice("Направляю ближайший свет в сияющую эфирную призму."))
		new /obj/structure/light_prism(get_turf(owner), glasses.glasses_color)

/obj/item/clothing/head/peaceflower
	name = "бутон героина"
	desc = "Цветок, вызывающий чрезвычайное привыкание, наполненный магией мира."
	icon = 'icons/obj/slimecrossing.dmi'
	icon_state = "peaceflower"
	inhand_icon_state = "peaceflower"
	slot_flags = ITEM_SLOT_HEAD
	clothing_traits = list(TRAIT_PACIFISM)
	body_parts_covered = NONE
	dynamic_hair_suffix = ""
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/clothing/head/peaceflower/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head)
			to_chat(user, span_warning("Чувствую себя спокойно. <b style='color:pink'>Зачем нужно что-нибудь ещё?</b>"))
			return
	return ..()

/obj/item/clothing/suit/armor/heavy/adamantine
	name = "адамантиновая броня"
	desc = "Полный комплект адамантиновых пластинчатых доспехов. Впечатляюще устойчив к урону, но весит примерно столько же, сколько и ты."
	icon_state = "adamsuit"
	inhand_icon_state = "adamsuit"
	flags_inv = NONE
	obj_flags = IMMUTABLE_SLOW
	slowdown = 4
	var/hit_reflect_chance = 40

/obj/item/clothing/suit/armor/heavy/adamantine/IsReflect(def_zone)
	if(def_zone in list(BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG) && prob(hit_reflect_chance))
		return TRUE
	else
		return FALSE
