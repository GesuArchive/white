/obj/item/clothing/head/wizard
	name = "шляпа волшебника"
	desc = "Странно выглядящая красная шляпа, которая наверняка принадлежит настоящему магу."
	icon_state = "wizard"
	gas_transfer_coefficient = 0.01 // IT'S MAGICAL OKAY JEEZ +1 TO NOT DIE
	permeability_coefficient = 0.01
	armor = list(MELEE = 30, BULLET = 20, LASER = 20, ENERGY = 30, BOMB = 20, BIO = 20, RAD = 20, FIRE = 100, ACID = 100,  WOUND = 20)
	strip_delay = 50
	equip_delay_other = 50
	clothing_flags = SNUG_FIT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = /datum/dog_fashion/head/blue_wizard

/obj/item/clothing/head/wizard/red
	name = "красная шляпа волшебника"
	desc = "Странно выглядящая красная шляпа, которая наверняка принадлежит настоящему магу."
	icon_state = "redwizard"
	dog_fashion = /datum/dog_fashion/head/red_wizard

/obj/item/clothing/head/wizard/yellow
	name = "желтая шляпа волшебника"
	desc = "Странно выглядящая желтая шляпа, которая наверняка принадлежит настоящему магу."
	icon_state = "yellowwizard"
	dog_fashion = null

/obj/item/clothing/head/wizard/black
	name = "черная шляпа волшебника"
	desc = "Странно выглядящая красная шляпа, которая наверняка принадлежит настоящему скелету. Жутко."
	icon_state = "blackwizard"
	dog_fashion = null

/obj/item/clothing/head/wizard/fake
	name = "шляпа волшебника"
	desc = "На ней блестками нашито ВОЛШЕБНИК. Поставляется с крутой бородой."
	icon_state = "wizard-fake"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	resistance_flags = FLAMMABLE
	dog_fashion = /datum/dog_fashion/head/blue_wizard

/obj/item/clothing/head/wizard/marisa
	name = "шляпа ведьмы"
	desc = "Странно выглядящая шляпа. Вам захотелось метать огненные шары."
	icon_state = "marisa"
	dog_fashion = null

/obj/item/clothing/head/wizard/magus
	name = "\improper Шлем Мага"
	desc = "Таинственный шлем, гудящий от внеземной силы."
	icon_state = "magus"
	inhand_icon_state = "magus"
	dog_fashion = null

/obj/item/clothing/head/wizard/santa
	name = "Шляпа Санты"
	desc = "Хо хо хо. Счастливого рождества!"
	icon_state = "santahat"
	flags_inv = HIDEHAIR|HIDEFACIALHAIR
	dog_fashion = null

/obj/item/clothing/suit/wizrobe
	name = "роба волшебника"
	desc = "Великолепная роба украшенная самоцветами, которая, кажется, излучает могущество."
	icon_state = "wizard"
	inhand_icon_state = "wizrobe"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(MELEE = 30, BULLET = 20, LASER = 20, ENERGY = 30, BOMB = 20, BIO = 20, RAD = 20, FIRE = 100, ACID = 100, WOUND = 20)
	allowed = list(/obj/item/teleportation_scroll)
	flags_inv = HIDEJUMPSUIT
	strip_delay = 50
	equip_delay_other = 50
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/wizrobe/red
	name = "красная роба волшебника"
	desc = "Великолепная красная роба украшенная самоцветами, которая, кажется, излучает могущество.."
	icon_state = "redwizard"
	inhand_icon_state = "redwizrobe"

/obj/item/clothing/suit/wizrobe/yellow
	name = "жёлтая роба волшебника"
	desc = "Великолепная желтая роба украшенная самоцветами, которая, кажется, излучает могущество.."
	icon_state = "yellowwizard"
	inhand_icon_state = "yellowwizrobe"

/obj/item/clothing/suit/wizrobe/black
	name = "чёрная роба волшебника"
	desc = "Устрашающая черная роба украшенная самоцветами, от которой смердит смертью и разложением."
	icon_state = "blackwizard"
	inhand_icon_state = "blackwizrobe"

/obj/item/clothing/suit/wizrobe/marisa
	name = "роба ведьмы"
	desc = "Вся магия вращается вокруг твоей силы заклинаний!"
	icon_state = "marisa"
	inhand_icon_state = "marisarobe"

/obj/item/clothing/suit/wizrobe/magusblue
	name = "\improper роба Мага"
	desc = "Комплект из бронированной робы, которая, кажется, излучает темную силу."
	icon_state = "magusblue"
	inhand_icon_state = "magusblue"

/obj/item/clothing/suit/wizrobe/magusred
	name = "\improper роба Мага"
	desc = "Комплект из бронированной робы, которая, кажется, излучает темную силу."
	icon_state = "magusred"
	inhand_icon_state = "magusred"


/obj/item/clothing/suit/wizrobe/santa
	name = "костюм Санты"
	desc = "Праздничный!"
	icon_state = "santa"
	inhand_icon_state = "santa"

/obj/item/clothing/suit/wizrobe/fake
	name = "роба волшебника"
	desc = "Тусклая синяя мантия, имитирующая настоящие робы волшебников."
	icon_state = "wizard-fake"
	inhand_icon_state = "wizrobe"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	resistance_flags = FLAMMABLE

/obj/item/clothing/head/wizard/marisa/fake
	name = "шляпа ведьмы"
	desc = "Странно выглядящая шляпа. Вам захотелось метать огненные шары."
	icon_state = "marisa"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	resistance_flags = FLAMMABLE

/obj/item/clothing/suit/wizrobe/marisa/fake
	name = "роба ведьмы"
	desc = "Вся магия вращается вокруг твоей силы заклинаний!"
	icon_state = "marisa"
	inhand_icon_state = "marisarobe"
	gas_transfer_coefficient = 1
	permeability_coefficient = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	resistance_flags = FLAMMABLE

/obj/item/clothing/suit/wizrobe/paper
	name = "papier-mache robe" // no non-latin characters!
	desc = "Роба скрепленная кучей скотча и клея."
	icon_state = "wizard-paper"
	inhand_icon_state = "wizard-paper"
	var/robe_charge = TRUE
	actions_types = list(/datum/action/item_action/stickmen)


/obj/item/clothing/suit/wizrobe/paper/ui_action_click(mob/user, action)
	stickmen()


/obj/item/clothing/suit/wizrobe/paper/verb/stickmen()
	set category = "Объект"
	set name = "Summon Stick Minions"
	set src in usr
	if(!isliving(usr))
		return
	if(!robe_charge)
		to_chat(usr, "<span class='warning'>\The robe's internal magic supply is still recharging!</span>")
		return

	usr.say("Rise, my creation! Off your page into this realm!", forced = "stickman summoning")
	playsound(src.loc, 'sound/magic/summon_magic.ogg', 50, TRUE, TRUE)
	var/mob/living/M = new /mob/living/simple_animal/hostile/stickman(get_turf(usr))
	var/list/factions = usr.faction
	M.faction = factions
	src.robe_charge = FALSE
	sleep(30)
	src.robe_charge = TRUE
	to_chat(usr, "<span class='notice'>\The robe hums, its internal magic supply restored.</span>")


//Shielded Armour

/obj/item/clothing/suit/space/hardsuit/shielded/wizard
	name = "броня боевого мага"
	desc = "Не все волшебники боятся сокращения дистанции."
	icon_state = "battlemage"
	inhand_icon_state = "battlemage"
	recharge_rate = 0
	current_charges = 15
	recharge_cooldown = INFINITY
	shield_state = "shield-red"
	shield_on = "shield-red"
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/wizard
	armor = list(MELEE = 30, BULLET = 20, LASER = 20, ENERGY = 30, BOMB = 20, BIO = 20, RAD = 20, FIRE = 100, ACID = 100)
	slowdown = 0
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/head/helmet/space/hardsuit/shielded/wizard
	name = "шлем боевого мага"
	desc = "В надлежащей степени впечатляющий шлем."
	icon_state = "battlemage"
	inhand_icon_state = "battlemage"
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	armor = list(MELEE = 30, BULLET = 20, LASER = 20, ENERGY = 30, BOMB = 20, BIO = 20, RAD = 20, FIRE = 100, ACID = 100)
	actions_types = null //No inbuilt light
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/head/helmet/space/hardsuit/shielded/wizard/attack_self(mob/user)
	return

/obj/item/wizard_armour_charge
	name = "заряды щита боевого мага"
	desc = "Мощная руна которая увеличит количество ударов, которое может выдержать броня боевого мага, перед тем как сломаться.."
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity2"

/obj/item/wizard_armour_charge/afterattack(obj/item/clothing/suit/space/hardsuit/shielded/wizard/W, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(!istype(W))
		to_chat(user, "<span class='warning'>Руна может быть использована только на броне боевого мага!</span>")
		return
	W.current_charges += 8
	to_chat(user, "<span class='notice'>Я зарядил \the [W]. Теперь она может поглотить [W.current_charges] ударов.</span>")
	qdel(src)
