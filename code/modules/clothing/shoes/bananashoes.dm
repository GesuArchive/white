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
	AddComponent(/datum/component/material_container, list(/datum/material/bananium), 200000, TRUE, /obj/item/stack)
	AddComponent(/datum/component/squeak, list('sound/items/bikehorn.ogg'=1), 75)

/obj/item/clothing/shoes/clown_shoes/banana_shoes/step_action()
	. = ..()
	var/mob/wearer = loc
	var/datum/component/material_container/bananium = GetComponent(/datum/component/material_container)
	if(on && istype(wearer))
		if(bananium.get_material_amount(/datum/material/bananium) < 100)
			on = !on
			if(!always_noslip)
				clothing_flags &= ~NOSLIP
			update_icon()
			to_chat(loc, "<span class='warning'>У вас закончился бананиум!</span>")
		else
			new /obj/item/grown/bananapeel/specialpeel(get_step(src,turn(wearer.dir, 180))) //honk
			bananium.use_amount_mat(100, /datum/material/bananium)

/obj/item/clothing/shoes/clown_shoes/banana_shoes/attack_self(mob/user)
	var/datum/component/material_container/bananium = GetComponent(/datum/component/material_container)
	var/sheet_amount = bananium.retrieve_all()
	if(sheet_amount)
		to_chat(user, "<span class='notice'>Я получил[sheet_amount] листов бананиума из прототипных ботинок.</span>")
	else
		to_chat(user, "<span class='warning'>Я не могу получить бананиум из прототипных ботинки!</span>")

/obj/item/clothing/shoes/clown_shoes/banana_shoes/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Обувь [on ? "включена" : "выключена"].</span>"

/obj/item/clothing/shoes/clown_shoes/banana_shoes/ui_action_click(mob/user)
	var/datum/component/material_container/bananium = GetComponent(/datum/component/material_container)
	if(bananium.get_material_amount(/datum/material/bananium))
		on = !on
		update_icon()
		to_chat(user, "<span class='notice'>Вы [on ? "активировали" : "деактивировали"] прототипные ботинки.</span>")
		if(!always_noslip)
			if(on)
				clothing_flags |= NOSLIP
			else
				clothing_flags &= ~NOSLIP
	else
		to_chat(user, "<span class='warning'>Вам нужен бананиум чтобы включить прототипные ботинки!</span>")

/obj/item/clothing/shoes/clown_shoes/banana_shoes/update_icon_state()
	if(on)
		icon_state = "clown_prototype_on"
	else
		icon_state = "clown_prototype_off"
