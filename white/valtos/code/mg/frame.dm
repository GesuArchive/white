#define MG_PART_NONE 0
#define MG_PART_FRAME 1
#define MG_PART_BARREL 2
#define MG_PART_DAMPENER 3
#define MG_PART_BOLT 4
#define MG_PART_SCOPE 5
#define MG_PART_NAB 6
#define MG_PART_MAG 7
#define MG_PART_BUTT 8

/obj/item/gun/modular
	name = "рама оружия"
	desc = "Основная часть любого огнестрельного оружия, позволяющая удерживать всё вместе."

	var/frame = null
	var/barrel = null
	var/dampener = null
	var/bolt = null
	var/scope = null
	var/nab = null
	var/mag = null
	var/butt = null

/obj/item/gun/modular/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/modular_gun_part))
		var/obj/item/modular_gun_part/MGP = I
		if(!check_compatibility(MGP))
			return
		switch(MGP.modular_part_type)
			if(MG_PART_FRAME)
				return
			if(MG_PART_BARREL)
				return
			if(MG_PART_DAMPENER)
				return
			if(MG_PART_BOLT)
				return
			if(MG_PART_SCOPE)
				return
			if(MG_PART_NAB)
				return
			if(MG_PART_MAG)
				return
			if(MG_PART_BUTT)
				return
	else
		..()

/obj/item/gun/modular/proc/check_compatibility(obj/item/modular_gun_part/MGP)
	if(!barrel && MGP.modular_part_type != MG_PART_BARREL)
		return FALSE
	return TRUE

/obj/item/modular_gun_part
	name = "болванка"
	desc = "Что с ней делать?"

	var/modular_part_type = MG_PART_NONE

/obj/item/modular_gun_part/frame
	name = "корпус"
	desc = "Если ствол без корпуса, то он скорее всего разлетится у стрелка в руках."

	modular_part_type = MG_PART_FRAME

/obj/item/modular_gun_part/barrel
	name = "ствол"
	desc = "Отсюда вылетает птичка."

	modular_part_type = MG_PART_BARREL

	var/caliber = "m9mm"

/obj/item/modular_gun_part/dampener
	name = "возвратная пружина"
	desc = "Позволяет каждый раз не передёргивать затвор."

	modular_part_type = MG_PART_DAMPENER

/obj/item/modular_gun_part/bolt
	name = "затвор"
	desc = "Позволяет быстро и удобно перезаряжать ваш ствол."

	modular_part_type = MG_PART_BOLT

/obj/item/modular_gun_part/scope
	name = "прицел"
	desc = "Необходим для точной стрельбы."

	modular_part_type = MG_PART_SCOPE

/obj/item/modular_gun_part/nab
	name = "курок"
	desc = "Без курка стрелять не очень удобно, верно?"

	modular_part_type = MG_PART_NAB

/obj/item/modular_gun_part/mag
	name = "магазин"
	desc = "Для возможности выстрелить не один раз."

	modular_part_type = MG_PART_MAG

/obj/item/modular_gun_part/butt
	name = "приклад"
	desc = "Чтоб руки не дрожали."

	modular_part_type = MG_PART_BUTT
