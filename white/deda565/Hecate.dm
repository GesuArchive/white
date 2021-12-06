/obj/item/gun/ballistic/rifle/boltaction/hecate
	name = "Hecate II"
	desc = "Винтовка твоего прадеда. Твой прадед имел ПТР и взрывал танки. Ахуеть."
	icon = 'white/deda565/WWIII.dmi'
	icon_state = "hecate"
	inhand_icon_state = "hecate"
	lefthand_file = 'white/deda565/hecateleftw.dmi'
	righthand_file = 'white/deda565/hecaterightw.dmi'
	recoil = 16
	slot_flags = ITEM_SLOT_BACK
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 5
	item_flags = SLOWS_WHILE_IN_HAND
	fire_delay = 30
	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'white/deda565/hecate_fire.ogg'
	slowdown = 4
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/hecate
	extra_damage = 45 //удалить при имбовости
	inhand_x_dimension = 1
	inhand_y_dimension = 1

/obj/item/ammo_box/magazine/internal/boltaction/hecate
	max_ammo = 1
	ammo_type = /obj/item/ammo_casing/p50
	caliber = ".50"


