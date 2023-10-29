// Guns
/obj/item/gun/ballistic/shotgun/fallout/lever
	name = "дезинтегратор"
	desc = "Не только мощный дробовик, но ещё и неплохое оружие ближнего боя."
	icon_state = "levershot"
	inhand_icon_state = "levershot"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/lever
	fire_sound = 'white/valtos/sounds/fallout/gunsounds/levershot/levershot2.ogg'
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	force = 25
	fire_delay = 5

/obj/item/gun/ballistic/shotgun/fallout/huntingshot
	name = "hunting shotgun"
	desc = "A pre-war pump action shotgun with an extended tube capable of holding eight shells and a bulky stock that excels in melee combat."
	icon_state = "huntingshot"
	inhand_icon_state = "huntingshot"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/huntingshot
	fire_sound = 'white/valtos/sounds/fallout/gunsounds/huntingshot/huntingshot2.ogg'
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	force = 30
	fire_delay = 5

/obj/item/gun/ballistic/shotgun/fallout/trail
	name = "trail carbine"
	desc = "A lever action repeater chambered for .44 Magnum with a solid capacity."
	icon_state = "trail"
	inhand_icon_state = "trail"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/tube44
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'white/valtos/sounds/fallout/trailfire.ogg'
	fire_delay = 5
	extra_damage = 40
	extra_penetration = 10

/obj/item/gun/ballistic/shotgun/fallout/cowboy
	name = "рычажной карабин"
	desc = "Классический карабин со скобой Генри под .357 калибр."
	icon_state = "cowboy"
	inhand_icon_state = "cowboy"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/tube357
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'white/valtos/sounds/fallout/gunsounds/repeater/repeater1.ogg'
	fire_delay = 5
	extra_penetration = 10

/obj/item/gun/ballistic/shotgun/fallout/brush
	name = "дезинтегратор"
	desc = "A lever action repeater chambered for the deadly .45-70 cartridge. Can't carry a lot of rounds and doesn't fire very fast, but with so much damage does that really matter?"
	icon_state = "brush"
	inhand_icon_state = "brush"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/tube4570
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'white/valtos/sounds/fallout/brushfire.ogg'
	fire_delay = 5
	extra_damage = 55
	extra_penetration = 10

/obj/item/gun/ballistic/shotgun/automatic/fallout/battle
	name = "battle rifle"
	desc = "A very old but very reliable semi-automatic, clip fed rifle from long before the war. Chambered for .308."
	icon_state = "battler"
	inhand_icon_state = "battler"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/battler
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'white/valtos/sounds/fallout/battlerifle.ogg'
	fire_delay = 5
	extra_damage = 40
	extra_penetration = 15

/obj/item/gun/ballistic/shotgun/automatic/fallout/battle/sks
	name = "СКС"
	desc = "Самозарядный карабин Симонова калибра 7.62 обладает приличной огневой мощью и несъемным магазином на 10 патронов. Заряжается патронами поштучно или при помощи скорозарядника."
	icon_state = "sks"
	inhand_icon_state = "sks"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/sks
	fire_sound = 'white/valtos/sounds/fallout/gunsounds/sks/sks1.ogg'
	extra_damage = 30
	extra_penetration = 10

/obj/item/gun/ballistic/shotgun/automatic/fallout/battle/sks/scoped
	name = "Снайперский СКС"
	desc = "Самозарядный карабин Симонова калибра 7.62 обладает приличной огневой мощью и несъемным магазином на 10 патронов. Заряжается патронами поштучно или при помощи скорозарядника. Эта версия отличается наличием прицела и дополнительной пробивной способностью."
	icon_state = "scoped_sks"
	inhand_icon_state = "scoped_sks"
	extra_penetration = 15

/obj/item/gun/ballistic/shotgun/automatic/fallout/battle/sks/scoped/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2)

//Magazines
/obj/item/ammo_box/magazine/internal/shot/tube4570
	name = "4570 internal tube magazine"
	ammo_type = /obj/item/ammo_casing/fallout/c4570
	caliber = "4570"
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/shot/tube44
	name = ".44 magnum internal tube magazine"
	ammo_type = /obj/item/ammo_casing/fallout/m44
	caliber = "44"
	max_ammo = 8

/obj/item/ammo_box/magazine/internal/shot/tube357
	name = ".357 magnum internal tube magazine"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = "357"
	max_ammo = 7

/obj/item/ammo_box/magazine/internal/shot/battler
	name = "battle rifle internal magazine (.308)"
	ammo_type = /obj/item/ammo_casing/fallout/a308
	caliber = "a308"
	max_ammo = 8

/obj/item/ammo_box/magazine/internal/shot/sks
	name = "SKS internal magazine (7.62)"
	ammo_type = /obj/item/ammo_casing/fallout/a762
	caliber = "a762"
	max_ammo = 10

/obj/item/ammo_box/magazine/internal/shot/lever
	name = "lever action shotgun internal tube magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 5

/obj/item/ammo_box/magazine/internal/shot/huntingshot
	name = "hunting shotgun internal tube magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 8

/obj/item/ammo_box/magazine/internal/shot/huntingshot/fire
	ammo_type = /obj/item/ammo_casing/shotgun/incendiary

//Loaders
/obj/item/ammo_box/fallout/tube4570
	name = ".45-70 speed loader tube"
	icon = 'white/valtos/icons/fallout/ammo.dmi'
	icon_state = "4570tube"
	ammo_type = /obj/item/ammo_casing/fallout/c4570
	caliber = "4570"
	max_ammo = 6

/obj/item/ammo_box/fallout/tube44
	name = ".44 speed loader tube"
	icon = 'white/valtos/icons/fallout/ammo.dmi'
	icon_state = "44tube"
	ammo_type = /obj/item/ammo_casing/fallout/m44
	caliber = "44"
	max_ammo = 8

/obj/item/ammo_box/fallout/tube357
	name = "винтовочный скорозарядник .357 калибра"
	icon = 'white/valtos/icons/fallout/ammo.dmi'
	icon_state = "357tube"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = "357"
	max_ammo = 7

/obj/item/ammo_box/fallout/battler
	name = "battle rifle stripper clip (.308)"
	icon = 'white/valtos/icons/fallout/ammo.dmi'
	icon_state = "battler"
	ammo_type = /obj/item/ammo_casing/fallout/a308
	caliber = "a308"
	max_ammo = 8

/obj/item/ammo_box/fallout/sks
	name = "винтовочный скорозарядник калибра 7.62"
	desc = "Вмещает до 10 пуль калибра 7.62. Подходит к СКС."
	icon = 'white/valtos/icons/fallout/ammo.dmi'
	icon_state = "sksclip"
	ammo_type = /obj/item/ammo_casing/fallout/a762
	caliber = "a762"
	max_ammo = 10
