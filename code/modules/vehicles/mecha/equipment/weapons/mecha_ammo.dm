/obj/item/mecha_ammo
	name = "generic ammo box"
	desc = "A box of ammo for an unknown weapon."
	w_class = WEIGHT_CLASS_BULKY
	icon = 'icons/mecha/mecha_ammo.dmi'
	icon_state = "empty"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	var/rounds = 0
	var/round_term = "патрон"
	var/direct_load //For weapons where we re-load the weapon itself rather than adding to the ammo storage.
	var/load_audio = 'sound/weapons/gun/general/mag_bullet_insert.ogg'
	var/ammo_type

/obj/item/mecha_ammo/update_name()
	if(!rounds)
		name = "Пустой цинк из-под боеприпасов"
		desc = "Коробка с боеприпасами для экзокостюма, которая была опустошена. Пожалуйста, отправьте на переработку."
		icon_state = "empty"
	return ..()

/obj/item/mecha_ammo/attack_self(mob/user)
	..()
	if(rounds)
		to_chat(user, span_warning("Вы не можете расплющить коробку с боеприпасами, пока она не опустеет!"))
		return

	to_chat(user, span_notice("Вы расплющиваете [src]."))
	var/trash = new /obj/item/stack/sheet/iron(user.loc)
	qdel(src)
	user.put_in_hands(trash)

/obj/item/mecha_ammo/examine(mob/user)
	. = ..()
	if(rounds)
		. += "<hr>Внутри [rounds] [round_term][rounds > 1?"":"а"]."

/obj/item/mecha_ammo/incendiary
	name = "Зажигательные боеприпасы к БК-БЗ \"Аид\""
	desc = "Коробка зажигательных боеприпасов для использования в карабинах для экзокостюмов."
	icon_state = "incendiary"
	rounds = 24
	ammo_type = "incendiary"

/obj/item/mecha_ammo/scattershot
	name = "Картечные боеприпасы к \"Дуплету\""
	desc = "Коробка крупной картечи для использования в дробовиках для экзокостюмов."
	icon_state = "scattershot"
	rounds = 40
	ammo_type = "scattershot"

/obj/item/mecha_ammo/lmg
	name = "Пулеметные боеприпасы к Ультра АК-2"
	desc = "Коробка ленточных боеприпасов, предназначенная для пулемета в экзокостюмах."
	icon_state = "lmg"
	rounds = 300
	ammo_type = "lmg"

/obj/item/mecha_ammo/missiles_br
	name = "Ракеты РСЗО \"Пробой-6\""
	desc = "Коробка с ракетами, готовая к загрузке в ракетную систему экзокостюма."
	icon_state = "missile_br"
	rounds = 6
	round_term = "ракет"
	direct_load = TRUE
	load_audio = 'sound/weapons/gun/general/mag_bullet_insert.ogg'
	ammo_type = "missiles_br"

/obj/item/mecha_ammo/bfg
	name = "Энергоячейски к \"РПГ\""
	desc = "Коробка энергоячеек к Радиоактивной пушке Грейз."
	icon_state = "bfg"
	rounds = 5
	ammo_type = "bfg"

/obj/item/mecha_ammo/missiles_he
	name = "Ракеты РСЗО \"Шторм-8\""
	desc = "Коробка с ракетами, готовая к загрузке в ракетную систему экзокостюма."
	icon_state = "missile_he"
	rounds = 8
	round_term = "ракет"
	direct_load = TRUE
	load_audio = 'sound/weapons/gun/general/mag_bullet_insert.ogg'
	ammo_type = "missiles_he"


/obj/item/mecha_ammo/flashbang
	name = "Светошумовые граната к АГС \"Заря\""
	desc = "Коробка гранат для использования в АГС экзокостюма. Оснащены электрическим детонатором и немогут быть использованы вне АГЦ."
	icon_state = "flashbang"
	rounds = 6
	round_term = "гранат"
	ammo_type = "flashbang"

/obj/item/mecha_ammo/clusterbang
	name = "Светошумовые граната к АГС \"Матрёшка\""
	desc = "Коробка кластерных гранат для использования в АГС экзокостюма. Оснащены электрическим детонатором и немогут быть использованы вне АГЦ."
	icon_state = "clusterbang"
	rounds = 3
	round_term = "кластер"
	direct_load = TRUE
	ammo_type = "clusterbang"
