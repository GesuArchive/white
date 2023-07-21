/obj/item/storage/cans
	name = "упаковка для банок"
	desc = "Вмещает до шести банок с напитками."
	icon = 'icons/obj/storage.dmi'
	icon_state = "canholder"
	inhand_icon_state = "cola"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	custom_materials = list(/datum/material/plastic = 1200)
	max_integrity = 500

/obj/item/storage/cans/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins popping open a final cold one with the boys! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS

/obj/item/storage/cans/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][contents.len]"

/obj/item/storage/cans/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/storage/cans/Initialize()
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.max_total_storage = 12
	atom_storage.max_slots = 6
	atom_storage.set_holdable(list(
		/obj/item/reagent_containers/food/drinks/soda_cans,
		/obj/item/reagent_containers/food/drinks/beer,
		/obj/item/reagent_containers/food/drinks/ale,
		/obj/item/reagent_containers/food/drinks/waterbottle
		))

/obj/item/storage/cans/sixsoda
	name = "упаковка колы"
	desc = "Хранит шесть банок колы."

/obj/item/storage/cans/sixsoda/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/drinks/soda_cans/cola(src)

/obj/item/storage/cans/sixbeer
	name = "упаковка пива"
	desc = "Хранит шесть банок пива"

/obj/item/storage/cans/sixbeer/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/drinks/beer(src)
