/datum/bounty/item/mech/New()
	..()
	description = "Высшее руководство попросило отправить одного [name] меха как можно скорее. Отправьте его, чтобы получить большую оплату."

/datum/bounty/item/mech/ship(obj/O)
	if(!applies_to(O))
		return
	if(istype(O, /obj/vehicle/sealed/mecha))
		var/obj/vehicle/sealed/mecha/M = O
		M.wreckage = null // So the mech doesn't explode.
	..()

/datum/bounty/item/mech/ripleymk2
	name = "APLU MK-II \"Рипли\""
	reward = CARGO_CRATE_VALUE * 26
	wanted_types = list(/obj/vehicle/sealed/mecha/working/ripley/mk2)

/datum/bounty/item/mech/clarke
	name = "Кларк"
	reward = CARGO_CRATE_VALUE * 32
	wanted_types = list(/obj/vehicle/sealed/mecha/working/clarke)

/datum/bounty/item/mech/odysseus
	name = "Одиссей"
	reward = CARGO_CRATE_VALUE * 22
	wanted_types = list(/obj/vehicle/sealed/mecha/medical/odysseus)

/datum/bounty/item/mech/gygax
	name = "Гигакс"
	reward = CARGO_CRATE_VALUE * 56
	wanted_types = list(/obj/vehicle/sealed/mecha/combat/gygax)

/datum/bounty/item/mech/durand
	name = "Дюранд"
	reward = CARGO_CRATE_VALUE * 40
	wanted_types = list(/obj/vehicle/sealed/mecha/combat/durand)
