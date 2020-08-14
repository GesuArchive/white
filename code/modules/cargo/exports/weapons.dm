// Weapon exports. Stun batons, disablers, etc.

/datum/export/weapon
	include_subtypes = FALSE

/datum/export/weapon/baton
	cost = 100
	unit_name = "стан батон"
	export_types = list(/obj/item/melee/baton)
	exclude_types = list(/obj/item/melee/baton/cattleprod)
	include_subtypes = TRUE

/datum/export/weapon/knife
	cost = 100
	unit_name = "боевой нож"
	export_types = list(/obj/item/kitchen/knife/combat)


/datum/export/weapon/taser
	cost = 200
	unit_name = "продвинутый электрошокер"
	export_types = list(/obj/item/gun/energy/e_gun/advtaser)

/datum/export/weapon/laser
	cost = 200
	unit_name = "Лазерная винтовка"
	export_types = list(/obj/item/gun/energy/laser)

/datum/export/weapon/disabler
	cost = 100
	unit_name = "Дизаблер"
	export_types = list(/obj/item/gun/energy/disabler)

/datum/export/weapon/energy_gun
	cost = 300
	unit_name = "Е-Ган"
	export_types = list(/obj/item/gun/energy/e_gun)

/datum/export/weapon/wt550
	cost = 300
	unit_name = "автоматическая винтовка WT-550"
	export_types = list(/obj/item/gun/ballistic/automatic/wt550)

/datum/export/weapon/shotgun
	cost = 300
	unit_name = "боевой дробовик"
	export_types = list(/obj/item/gun/ballistic/shotgun/automatic/combat)


/datum/export/weapon/flashbang
	cost = 5
	unit_name = "флешка"
	export_types = list(/obj/item/grenade/flashbang)

/datum/export/weapon/teargas
	cost = 5
	unit_name = "граната со слезоточивым газом"
	export_types = list(/obj/item/grenade/chem_grenade/teargas)


/datum/export/weapon/flash
	cost = 5
	unit_name = "ручной флэш"
	export_types = list(/obj/item/assembly/flash)
	include_subtypes = TRUE

/datum/export/weapon/handcuffs
	cost = 3
	unit_name = "пара"
	message = "наручников"
	export_types = list(/obj/item/restraints/handcuffs)
