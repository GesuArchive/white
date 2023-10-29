/obj/item/minespawner/explosive
	name = "наземная мина"
	desc = "При активации через 3 секунды активируется, идеально подходит прикрыть то, что надо защитить."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "uglymine"

	mine_type = /obj/effect/mine/explosive

/obj/item/storage/box/nri_survival_pack
	name = "аптечка первой помощи"
	desc = "Аптечка, наполненная полезными предметами первой необходимости, предоставленная институтом Номара для выживания в агрессивной среде."
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
	name = "набор МРП"
	desc = "Коробка с пайками!"

/obj/item/storage/box/rations/PopulateContents()
	new /obj/item/food/rationpack(src)
	new /obj/item/food/rationpack(src)
	new /obj/item/food/rationpack(src)
	new /obj/item/food/rationpack(src)
	new /obj/item/food/rationpack(src)
	new /obj/item/food/rationpack(src)
