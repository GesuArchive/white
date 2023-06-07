/obj/item/clothing/shoes/magboots
	name = "магнитки"
	desc = "Магнитные ботинки, часто используемые во время работы в космической невесомости, для надежной фиксации пользователя к металическим конструкциям."
	icon_state = "magboots0"
	var/magboot_state = "magboots"
	var/magpulse = FALSE
	var/slowdown_active = 2
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, FIRE = 0, ACID = 0)
	actions_types = list(/datum/action/item_action/toggle)
	strip_delay = 70
	equip_delay_other = 70
	resistance_flags = FIRE_PROOF

/obj/item/clothing/shoes/magboots/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_FEET)
		update_gravity_trait(user)
	else
		REMOVE_TRAIT(user, TRAIT_NEGATES_GRAVITY, type)

/obj/item/clothing/shoes/magboots/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_NEGATES_GRAVITY, type)

/obj/item/clothing/shoes/magboots/verb/toggle()
	set name = "Toggle Magboots"
	set category = "Объект"
	set src in usr
	if(!can_use(usr))
		return
	attack_self(usr)


/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		clothing_flags &= ~NOSLIP
		slowdown = SHOES_SLOWDOWN
	else
		clothing_flags |= NOSLIP
		slowdown = slowdown_active
	magpulse = !magpulse
	icon_state = "[magboot_state][magpulse]"
	to_chat(user, span_notice("Переключаю магниты в состояние [magpulse ? "вкл" : "выкл"]."))
	update_gravity_trait(user)
	user.update_inv_shoes()	//so our mob-overlays update
	user.update_gravity(user.has_gravity())
	user.update_equipment_speed_mods() //we want to update our speed so we arent running at max speed in regular magboots
	update_item_action_buttons()

/obj/item/clothing/shoes/magboots/examine(mob/user)
	. = ..()
	. += "<hr>Они [magpulse ? "включены" : "выключены"]."

///Adds/removes the gravity negation trait from the wearer depending on if the magpulse system is turned on.
/obj/item/clothing/shoes/magboots/proc/update_gravity_trait(mob/user)
	if(magpulse)
		ADD_TRAIT(user, TRAIT_NEGATES_GRAVITY, type)
	else
		REMOVE_TRAIT(user, TRAIT_NEGATES_GRAVITY, type)

/obj/item/clothing/shoes/magboots/advance
	desc = "Усовершенствованные магнитные ботинки, которые имеют более легкое магнитное притяжение, уменьшая нагрузку на пользователя."
	name = "продвинутые магнитки"
	icon_state = "advmag0"
	magboot_state = "advmag"
	slowdown_active = SHOES_SLOWDOWN
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/clothing/shoes/magboots/syndie
	desc = "Магнитные сапоги обратной разработки которые имеют сильное магнитное притяжение. Собственность Мародеров Горлекс."
	name = "кроваво-красные магнитки"
	icon_state = "syndiemag0"
	magboot_state = "syndiemag"
