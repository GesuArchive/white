/obj/item/minespawner/explosive
	name = "deactivated explosive landmine"
	desc = "When activated, will deploy into a highly explosive mine after 3 seconds passes, perfect for lazy marines looking to cover their fortifications with no effort."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "uglymine"

	mine_type = /obj/effect/mine/explosive

/obj/item/storage/box/nri_survival_pack
	name = "NRI survival pack"
	desc = "A box filled with useful emergency items, supplied by the NRI."
	icon_state = "survival_pack"
	icon = 'white/valtos/icons/black_mesa/survival_pack.dmi'
	illustration = null

/obj/item/storage/box/nri_survival_pack/PopulateContents()
	new /obj/item/storage/mre(src)
	new /obj/item/flashlight/glowstick(src)
	new /obj/item/tank/internals/emergency_oxygen/double(src)
	new /obj/item/reagent_containers/food/drinks/waterbottle(src)
	new /obj/item/reagent_containers/blood/o_minus(src)
	new /obj/item/reagent_containers/syringe(src)
	new /obj/item/storage/pill_bottle/multiver(src)

/obj/item/storage/box/rations
	name = "box of rations"
	desc = "A box containing ration packs!"

/obj/item/storage/box/rations/PopulateContents()
	new /obj/item/food/rationpack(src)
	new /obj/item/food/rationpack(src)
	new /obj/item/food/rationpack(src)
	new /obj/item/food/rationpack(src)
	new /obj/item/food/rationpack(src)
	new /obj/item/food/rationpack(src)
