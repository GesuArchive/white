//banana flavored chaos and horror ahead

/obj/item/clothing/shoes/clown_shoes/banana_shoes
	name = "Прототипные ботинки мк-онк"
	desc = "Потерянный прототип передовой технологии клоунов. Приведенные в действие бананиумом, эти ботинки оставляют за собой след хаоса."
	icon_state = "clown_prototype_off"
	actions_types = list(/datum/action/item_action/toggle)
	var/on = FALSE
	var/always_noslip = FALSE

/obj/item/clothing/shoes/clown_shoes/banana_shoes/Initialize()
	. = ..()
	if(always_noslip)
		clothing_flags |= NOSLIP

/obj/item/clothing/shoes/clown_shoes/banana_shoes/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(/datum/component/material_container, list(/datum/material/bananium), 100 * MINERAL_MATERIAL_AMOUNT, MATCONTAINER_EXAMINE|MATCONTAINER_ANY_INTENT|MATCONTAINER_SILENT, allowed_items=/obj/item/stack)
	AddComponent(/datum/component/squeak, list('sound/items/bikehorn.ogg'=1), 75, falloff_exponent = 20)
	RegisterSignal(src, COMSIG_SHOES_STEP_ACTION, .proc/on_step)

/obj/item/clothing/shoes/clown_shoes/banana_shoes/proc/on_step()
	SIGNAL_HANDLER

	var/mob/wearer = loc
	var/datum/component/material_container/bananium = GetComponent(/datum/component/material_container)
	if(on && istype(wearer))
		if(bananium.get_material_amount(/datum/material/bananium) < 100)
			on = !on
			if(!always_noslip)
				clothing_flags &= ~NOSLIP
			update_icon()
			to_chat(loc, span_warning("У вас закончился бананиум!"))
		else
			new /obj/item/grown/bananapeel/specialpeel(get_step(src,turn(wearer.dir, 180))) //honk
			bananium.use_amount_mat(100, /datum/material/bananium)

/obj/item/clothing/shoes/clown_shoes/banana_shoes/attack_self(mob/user)
	var/datum/component/material_container/bananium = GetComponent(/datum/component/material_container)
	var/sheet_amount = bananium.retrieve_all()
	if(sheet_amount)
		to_chat(user, span_notice("Получил[sheet_amount] листов бананиума из прототипных ботинок."))
	else
		to_chat(user, span_warning("Не могу получить бананиум из прототипных ботинки!"))

/obj/item/clothing/shoes/clown_shoes/banana_shoes/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Обувь [on ? "включена" : "выключена"].</span>"

/obj/item/clothing/shoes/clown_shoes/banana_shoes/ui_action_click(mob/user)
	var/datum/component/material_container/bananium = GetComponent(/datum/component/material_container)
	if(bananium.get_material_amount(/datum/material/bananium))
		on = !on
		update_icon()
		to_chat(user, span_notice("[on ? "Активирую" : "Деактивирую"] прототипные ботинки."))
		if(!always_noslip)
			if(on)
				clothing_flags |= NOSLIP
			else
				clothing_flags &= ~NOSLIP
	else
		to_chat(user, span_warning("Вам нужен бананиум чтобы включить прототипные ботинки!"))

/obj/item/clothing/shoes/clown_shoes/banana_shoes/update_icon_state()
	if(on)
		icon_state = "clown_prototype_on"
	else
		icon_state = "clown_prototype_off"
