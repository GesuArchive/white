/////Xeno organs/////
//alien
/obj/item/organ/tail/lizard/alien
	name = "alien tail"
	desc = "A severed alien tail."
	icon = 'white/Gargule/icons.dmi'
	icon_state = "severedtail"
	tail_type = "Alien"
	color = null
	actions_types = list(/datum/action/cooldown/spell/aoe/repulse/xeno/weak)

/obj/item/organ/tail/lizard/alien/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(istype(H))
		H.dna.species.mutant_bodyparts -= "tail_lizard"
		H.dna.species.mutant_bodyparts -= "spines"
		color = "#" + H.dna.features["mcolor"]
		tail_type = H.dna.features["tail_lizard"]
		spines = H.dna.features["spines"]
		H.update_body()

/obj/item/organ/tail/lizard/alien/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		if(!("tail_lizard" in H.dna.species.mutant_bodyparts))
			H.dna.species.mutant_bodyparts |= "tail_lizard"
			H.dna.features["tail_lizard"] = tail_type

		if(!("spines" in H.dna.species.mutant_bodyparts))
			H.dna.features["spines"] = spines
			H.dna.species.mutant_bodyparts |= "spines"
			H.update_body()

/datum/sprite_accessory/tails/lizard/alien
	name = "Alien"
	icon = 'white/Gargule/icons.dmi'
	icon_state = "cat"
	locked = FALSE
	color_src = 0

/datum/sprite_accessory/tails_animated/lizard/alien
	name = "Alien"
	icon = 'white/Gargule/icons.dmi'
	icon_state = "cat"
	locked = FALSE
	color_src = 0

/////Implants/////
/obj/item/organ/cyberimp/arm/alien
	icon = 'white/Gargule/icons.dmi'
	icon_state = "surgery"
	name = "Имплант инопланетных инструментов"
	desc = "Набор инопланетных хирургических инструментов скрывающийся за скрытой панелью на руке пользователя."
	items_to_create = list(/obj/item/retractor/alien, /obj/item/hemostat/alien, /obj/item/cautery/alien, /obj/item/surgicaldrill/alien, /obj/item/scalpel/alien, /obj/item/circular_saw/alien, /obj/item/surgical_drapes)

/obj/item/organ/cyberimp/eyes/hud/diagnostic
	name = "Имплант диагностического интерфейса"
	desc = "Выводит диагностический интерфейс поверх всего что вы видите. Сканирует технику: мехов, киборгов, наниты и шлюзы."
	HUD_type = DATA_HUD_DIAGNOSTIC_BASIC

/obj/item/organ/cyberimp/eyes/hud/science
	name = "Имплант научного интерфейса"
	desc = "Выводит научный интерфейс поверх всего что вы видите. Сканирует реагенты и предметы."
	HUD_trait = TRAIT_RESEARCH_SCANNER

/////Simple organs/////

/obj/item/organ/heart/light
	name = "heart of Light"
	desc = "Full of Light essence."
	//synthetic = TRUE //floral power prevents heart attacks
	actions_types = list(/datum/action/item_action/toggle_light)
	icon = 'white/Gargule/icons.dmi'
	icon_state = "heartlight-on"
	var/power = 3
	var/on = FALSE
	var/brightness_on = 5 //range of light when on
	var/flashlight_power = 1 //strength of the light when on
	var/inside = 0

/obj/item/organ/heart/light/on_life()
	. = ..()
	if(ispodperson(owner)) //extra healing for podmans
		owner.nutrition += 5
		owner.heal_overall_damage(power,power,power/2)
		owner.adjustToxLoss(-power)
		owner.adjustOxyLoss(-power)
		if(owner.nutrition > NUTRITION_LEVEL_FULL)
			owner.nutrition = NUTRITION_LEVEL_FULL

/obj/item/organ/heart/light/proc/update_brightness(mob/user = null)
	if(on)
		icon_state = "[initial(icon_state)]-on"
		if(flashlight_power)
			set_light(l_range = brightness_on, l_power = flashlight_power)
		else
			set_light(brightness_on)
	else
		icon_state = initial(icon_state)
		set_light(0)

/obj/item/organ/heart/light/Insert()
	. = ..()
	inside = 1
	if(!src.loc)
		src.loc = owner

/obj/item/organ/heart/light/Remove(mob/living/carbon/M, special = FALSE)
	. = ..()
	inside = 0
	src.loc = null

/obj/item/organ/heart/light/attack_self(mob/user)
	. = ..()
	if(inside)
		on = !on
		update_brightness(user)
		update_item_action_buttons()
		if(on)
			owner.show_message("Your skin emmits light!")
		else
			owner.show_message("You wanna stay in darkness")
		return 1

/obj/item/organ/heart/light/attack(mob/M, mob/living/carbon/user, obj/target)
	if(M != user)
		return ..()
	user.show_message("You raise your mouth and devour it!")
	playsound(user, 'sound/magic/demon_consume.ogg', 50, 1)
	user.show_message("It tastes sweet and grows inside of you")
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	Insert(user)
