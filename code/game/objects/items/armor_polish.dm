/obj/item/armorpolish
	name = "Бронирующая полироль"
	desc = "Нечто белое, густое, склизкое... А, это бронирующая полироль!."
	icon = 'icons/obj/traitor.dmi'
	icon_state = "armor_polish"
	w_class = WEIGHT_CLASS_TINY
	var/remaining_uses = 2
	var/melee_armor_max = 30
	var/bullet_armor_max = 30
	var/laser_armor_max = 20
	var/energy_armor_max = 25

/obj/item/armorpolish/examine(mob/user)
	. = ..()
	if(remaining_uses != -1)
		. += "Осталось [remaining_uses] использований."

/obj/item/armorpolish/afterattack(atom/target, mob/user, proximity)
	if(istype(target, /obj/item/clothing/suit) || istype(target, /obj/item/clothing/head))
		var/obj/item/clothing/I = target;
		//theos said 30/30/20/25
		//make sure it's not too strong already ((busted))
		if((I.armor.melee < melee_armor_max) || (I.armor.bullet < bullet_armor_max) || (I.armor.laser < laser_armor_max) || (I.armor.energy < energy_armor_max))
			//it is weak enough to benefit
			I.armor = I.armor.setRating(
				melee = I.armor.melee < melee_armor_max ? melee_armor_max : I.armor.melee,
				bullet = I.armor.bullet < bullet_armor_max ? bullet_armor_max : I.armor.bullet,
				laser = I.armor.laser < laser_armor_max ? laser_armor_max : I.armor.laser,
				energy = I.armor.energy < energy_armor_max ? energy_armor_max : I.armor.energy
			)
			remaining_uses -= 1
			to_chat(user, "Вы применили [src] на [target.name].")
			if(remaining_uses <= 0) {
				to_chat(user, span_warning("[src] обращается в пепел..."))
				qdel(src)
			} else {
				to_chat(user, span_warning("У [src] осталось [remaining_uses] использований."))
			}


		else
			if(istype(target,/obj/item/clothing/suit)) {
				to_chat(user, span_warning("Этот костюм и так достаточно силен! Попробуйте его на чем-то более слабом."))
			} else {
				to_chat(user, span_warning("Этот головной убор и так достаточно прочный! Попробуйте его на чем-то более слабом."))
			}

	else
		to_chat(user, span_warning("Полировать можно только костюмы и головные уборы!"))

/obj/item/armorpolish/adamantine
	name = "Адамантитовая пыль"
	desc = "Горсть адамантиновой пыли, слегка бронирует верхнюю одежду."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "adamantine slime extract"
	w_class = WEIGHT_CLASS_TINY
	remaining_uses = 1
	melee_armor_max = 15
	bullet_armor_max = 10
	laser_armor_max = 10
	energy_armor_max = 10

/obj/item/armorpolish/reflective
    name = "Зеркальная полироль"
    desc = "Полироль для двух использований. Улучшает показатели брони против лазеров и энергетического оружия."
    icon = 'icons/obj/traitor.dmi'
    icon_state = "reflective_polish"
    w_class = WEIGHT_CLASS_TINY
    remaining_uses = 2
    melee_armor_max = 5
    bullet_armor_max = 5
    laser_armor_max = 45
    energy_armor_max = 45
