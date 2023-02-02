/datum/crafting_recipe/lance
	name = "Взрывное копье (Граната)"
	result = /obj/item/spear/explosive
	reqs = list(/obj/item/spear = 1,
				/obj/item/grenade = 1)
	blacklist = list(/obj/item/spear/bonespear, /obj/item/spear/bamboospear)
	parts = list(/obj/item/spear = 1,
				/obj/item/grenade = 1)
	time = 15
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/stunprod
	name = "Самодельный электрошокер"
	result = /obj/item/melee/baton/cattleprod
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/rods = 1,
				/obj/item/assembly/igniter = 1)
	time = 40
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/teleprod
	name = "Телепортационное копьё"
	result = /obj/item/melee/baton/cattleprod/teleprod
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/rods = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/stack/ore/bluespace_crystal = 1)
	time = 40
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/tailclub
	name = "Бита из хвоста"
	result = /obj/item/tailclub
	reqs = list(/obj/item/organ/tail/lizard = 1,
				/obj/item/stack/sheet/iron = 1)
	blacklist = list(/obj/item/organ/tail/lizard/fake)
	time = 40
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/tailwhip
	name = "Плеть из хвостов ящериц"
	result = /obj/item/melee/chainofcommand/tailwhip
	reqs = list(/obj/item/organ/tail/lizard = 1,
				/obj/item/stack/cable_coil = 1)
	blacklist = list(/obj/item/organ/tail/lizard/fake)
	time = 40
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/catwhip
	name = "Плеть из кошачьих хвостов"
	result = /obj/item/melee/chainofcommand/tailwhip/kitty
	reqs = list(/obj/item/organ/tail/cat = 1,
				/obj/item/stack/cable_coil = 1)
	time = 40
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/chainsaw
	name = "Бензопила"
	result = /obj/item/chainsaw
	reqs = list(/obj/item/circular_saw = 1,
				/obj/item/stack/cable_coil = 3,
				/obj/item/stack/sheet/plasteel = 5)
	tool_behaviors = list(TOOL_WELDER)
	time = 50
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/spear
	name = "Копьё"
	result = /obj/item/spear
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/shard = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/shard = 1)
	time = 40
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/bonedagger
	name = "Костяной Кинжал"
	result = /obj/item/kitchen/knife/combat/bone
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2)
	category = CAT_WEAPON_MELEE
/datum/crafting_recipe/bonespear
	name = "Костяное Копье"
	result = /obj/item/spear/bonespear
	time = 30
	reqs = list(/obj/item/stack/sheet/bone = 4,
				/obj/item/stack/sheet/sinew = 1)
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/boneaxe
	name = "Костяной Топор"
	result = /obj/item/fireaxe/boneaxe
	time = 50
	reqs = list(/obj/item/stack/sheet/bone = 6,
				/obj/item/stack/sheet/sinew = 3)
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/elder_atmosian_fireaxe
	name = "Топор древнего атмосферного техника"
	result = /obj/item/fireaxe/elder_atmosian_fireaxe
	time = 60
	reqs = list(/obj/item/fireaxe/metal_h2_axe = 1,
				/obj/item/stack/sheet/mineral/zaukerite = 10,
				)
	category = CAT_WEAPON_MELEE
