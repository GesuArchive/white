/obj/vehicle/sealed/mecha/combat/five_stars
	name = "танк"
	desc = "Использовался фашистами при борьбе с кустарниками."
	icon = 'icons/mecha/mecha_96x96.dmi'
	icon_state = "five_stars"
	armor = list(MELEE = 100, BULLET = 50, LASER = 35, ENERGY = 35, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	exit_delay = 40
	dir_in = 1
	max_integrity = 800
	pixel_x = -32
	pixel_y = -32

/obj/vehicle/sealed/mecha/combat/five_stars/loaded
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg,
		MECHA_UTILITY = list(),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)
