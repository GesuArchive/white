/datum/bounty/item/mech/New()
	..()
	description = "Высшее руководство попросило отправить одного меха [name] как можно скорее. Отправьте его, чтобы получить большую оплату."

/datum/bounty/item/mech/ship(obj/O)
	if(!applies_to(O))
		return
	if(istype(O, /obj/vehicle/sealed/mecha))
		var/obj/vehicle/sealed/mecha/M = O
		M.wreckage = null // So the mech doesn't explode.
	..()

/datum/bounty/item/mech/ripleymk2
	name = "АПЛУ MK-II \"Рипли\""
	reward = CARGO_CRATE_VALUE * 150
	wanted_types = list(/obj/vehicle/sealed/mecha/working/ripley/mk2)

/datum/bounty/item/mech/clarke
	name = "Кларк"
	reward = CARGO_CRATE_VALUE * 165
	wanted_types = list(/obj/vehicle/sealed/mecha/working/clarke)

/datum/bounty/item/mech/odysseus
	name = "Одиссей"
	reward = CARGO_CRATE_VALUE * 200
	wanted_types = list(/obj/vehicle/sealed/mecha/medical/odysseus)

/datum/bounty/item/mech/gygax
	name = "Гигакс"
	reward = CARGO_CRATE_VALUE * 500
	wanted_types = list(/obj/vehicle/sealed/mecha/combat/gygax)

/datum/bounty/item/mech/durand
	name = "Дюранд"
	reward = CARGO_CRATE_VALUE * 500
	wanted_types = list(/obj/vehicle/sealed/mecha/combat/durand)
