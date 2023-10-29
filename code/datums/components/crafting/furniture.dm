/datum/crafting_recipe/elder_atmosian_statue
	name = "Статуя древнего атмосферного техника"
	result = /obj/structure/statue/elder_atmosian
	time = 6 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/metal_hydrogen = 20,
				/obj/item/stack/sheet/mineral/zaukerite = 15,
				/obj/item/stack/sheet/iron = 30,
				)
	category = CAT_FURNITURE

/datum/crafting_recipe/aquarium
	name = "Аквариум"
	result = /obj/structure/aquarium
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/iron = 15,
				/obj/item/stack/sheet/glass = 10,
				/obj/item/aquarium_kit = 1
				)
	category = CAT_FURNITURE
