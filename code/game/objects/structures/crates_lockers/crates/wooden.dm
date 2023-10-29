/obj/structure/closet/crate/wooden
	name = "деревянный ящик"
	desc = "Как металлический, только деревянный."
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 6
	icon_state = "wooden"
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

/obj/structure/closet/crate/wooden/toy
	name = "коробка с игрушками"
	desc = "Снизу маркером написано \"Клоун + Мим\" ."

/obj/structure/closet/crate/wooden/toy/PopulateContents()
	. = ..()
	new	/obj/item/megaphone/clown(src)
	new	/obj/item/reagent_containers/food/drinks/soda_cans/canned_laughter(src)
	new /obj/item/pneumatic_cannon/pie(src)
	new /obj/item/food/pie/cream(src)
	new /obj/item/storage/crayons(src)
