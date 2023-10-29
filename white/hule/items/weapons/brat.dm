/obj/item/ammo_casing/shotgun/diyslug
	name = "makeshift glass slug"
	desc = "Как вообще из спичек, бумаги и сахара можно сделать боеприпас?"
	icon = 'white/hule/icons/obj/weapons.dmi'
	icon_state = "cshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_glassslug
	pellets = 5
	variance = 25

/obj/item/ammo_casing/shotgun/diyslug/plasma
	name = "makeshift plasmaglass slug"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_plasmaslug


/obj/projectile/bullet/pellet/shotgun_plasmaslug
	name = "makeshift plasmaglass slug"
	damage = 8

/obj/projectile/bullet/pellet/shotgun_glassslug
	name = "makeshift glass slug"
	damage = 4
	stamina = 2

/datum/crafting_recipe/plasmaslug
	name = "Самодельный ружейный патрон с плазма стеклом"
	result = /obj/item/ammo_casing/shotgun/diyslug/plasma
	time = 25
	reqs = list(/obj/effect/decal/cleanable/glass/plasma = 1,
				/obj/item/paper = 2,
				/datum/reagent/fuel = 5,
				/datum/reagent/consumable/sugar = 5,
				/obj/item/match = 3,
				/obj/item/stack/sheet/iron = 1)
	tool_behaviors = list(TOOL_WIRECUTTER)
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/glassslug
	name = "Самодельный ружейный патрон с битым стеклом"
	result = /obj/item/ammo_casing/shotgun/diyslug
	time = 25
	reqs = list(/obj/effect/decal/cleanable/glass = 1,
				/obj/item/paper = 2,
				/datum/reagent/fuel = 5,
				/datum/reagent/consumable/sugar = 5,
				/obj/item/match = 3,
				/obj/item/stack/sheet/iron = 1)
	tool_behaviors = list(TOOL_WIRECUTTER)
	category = CAT_WEAPON_AMMO

