// Weapon exports. Stun batons, disablers, etc.

/datum/export/weapon
	include_subtypes = FALSE

/datum/export/weapon/baton
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "Электрошоковая дубинка"
	export_types = list(/obj/item/melee/baton)
	exclude_types = list(/obj/item/melee/baton/cattleprod)
	include_subtypes = TRUE

/datum/export/weapon/knife
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "Боевой нож"
	export_types = list(/obj/item/kitchen/knife/combat)


/datum/export/weapon/taser
	cost = CARGO_CRATE_VALUE
	unit_name = "Гибридный тазер"
	export_types = list(/obj/item/gun/energy/e_gun/advtaser)

/datum/export/weapon/laser
	cost = CARGO_CRATE_VALUE
	unit_name = "Лазерная винтовка"
	export_types = list(/obj/item/gun/energy/laser)

/datum/export/weapon/disabler
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "Усмиритель"
	export_types = list(/obj/item/gun/energy/disabler)

/datum/export/weapon/energy_gun
	cost = CARGO_CRATE_VALUE * 1.5
	unit_name = "Е-Ган"
	export_types = list(/obj/item/gun/energy/e_gun)

/datum/export/weapon/inferno
	cost = CARGO_CRATE_VALUE * 1.5
	unit_name = "Пиролучевой пистолет"
	export_types = list(/obj/item/gun/energy/laser/thermal/inferno)

/datum/export/weapon/cryo
	cost = CARGO_CRATE_VALUE * 1.5
	unit_name = "Криолучевой пистолет"
	export_types = list(/obj/item/gun/energy/laser/thermal/cryo)

/datum/export/weapon/shotgun
	cost = CARGO_CRATE_VALUE * 1.5
	unit_name = "Боевой дробовик"
	export_types = list(/obj/item/gun/ballistic/shotgun/automatic/combat)

/datum/export/weapon/flashbang
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "Светошумовая граната"
	export_types = list(/obj/item/grenade/flashbang)

/datum/export/weapon/teargas
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "Слезоточивая граната"
	export_types = list(/obj/item/grenade/chem_grenade/teargas)


/datum/export/weapon/flash
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "Вспышка"
	export_types = list(/obj/item/assembly/flash)
	include_subtypes = TRUE

/datum/export/weapon/handcuffs
	cost = CARGO_CRATE_VALUE * 0.015
	unit_name = "Наручники"
	export_types = list(/obj/item/restraints/handcuffs)
