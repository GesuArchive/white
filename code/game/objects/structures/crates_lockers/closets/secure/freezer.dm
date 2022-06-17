/obj/structure/closet/secure_closet/freezer
	icon_state = "freezer"
	door_anim_squish = 0.22
	door_anim_angle = 123
	door_anim_time = 4
	var/jones = FALSE

/obj/structure/closet/secure_closet/freezer/Destroy()
	recursive_organ_check(src)
	..()

/obj/structure/closet/secure_closet/freezer/Initialize(mapload)
	. = ..()
	recursive_organ_check(src)

/obj/structure/closet/secure_closet/freezer/open(mob/living/user, force = FALSE)
	if(opened || !can_open(user, force))	//dupe check just so we don't let the organs decay when someone fails to open the locker
		return FALSE
	recursive_organ_check(src)
	return ..()

/obj/structure/closet/secure_closet/freezer/close(mob/living/user)
	if(..())	//if we actually closed the locker
		recursive_organ_check(src)

/obj/structure/closet/secure_closet/freezer/ex_act()
	if(!jones)
		jones = TRUE
	else
		..()

/obj/structure/closet/secure_closet/freezer/kitchen
	name = "кухонный шкаф"
	req_access = list(ACCESS_KITCHEN)

/obj/structure/closet/secure_closet/freezer/kitchen/PopulateContents()
	..()
	for(var/i = 0, i < 3, i++)
		new /obj/item/reagent_containers/food/condiment/flour(src)
	new /obj/item/reagent_containers/food/condiment/rice(src)
	new /obj/item/reagent_containers/food/condiment/sugar(src)

/obj/structure/closet/secure_closet/freezer/kitchen/maintenance
	name = "подпольный холодильник"
	desc = "Этот холодильник выглядит довольно пыльным, есть ли внутри что-нибудь съедобное?"
	req_access = list()

/obj/structure/closet/secure_closet/freezer/kitchen/maintenance/PopulateContents()
	..()
	for(var/i = 0, i < 5, i++)
		new /obj/item/reagent_containers/food/condiment/milk(src)
	for(var/i = 0, i < 5, i++)
		new /obj/item/reagent_containers/food/condiment/soymilk(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/storage/fancy/egg_box(src)

/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = list()

/obj/structure/closet/secure_closet/freezer/meat
	name = "мясной холодильник"
	req_access = list(ACCESS_KITCHEN)

/obj/structure/closet/secure_closet/freezer/meat/PopulateContents()
	..()
	for(var/i = 0, i < 4, i++)
		new /obj/item/food/meat/slab/monkey(src)

/obj/structure/closet/secure_closet/freezer/meat/open
	req_access = list()
	locked = FALSE

/obj/structure/closet/secure_closet/freezer/gulag_fridge
	name = "холодильник"

/obj/structure/closet/secure_closet/freezer/gulag_fridge/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/food/drinks/beer/light(src)

/obj/structure/closet/secure_closet/freezer/fridge
	name = "холодильник"
	req_access = list(ACCESS_KITCHEN)

/obj/structure/closet/secure_closet/freezer/fridge/PopulateContents()
	..()
	for(var/i = 0, i < 5, i++)
		new /obj/item/reagent_containers/food/condiment/milk(src)
	for(var/i = 0, i < 5, i++)
		new /obj/item/reagent_containers/food/condiment/soymilk(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/storage/fancy/egg_box(src)

/obj/structure/closet/secure_closet/freezer/fridge/open
	req_access = null
	locked = FALSE

/obj/structure/closet/secure_closet/freezer/money
	name = "морозильная камера"
	desc = "Холодная наличность."
	req_access = list(ACCESS_VAULT)

/obj/structure/closet/secure_closet/freezer/money/PopulateContents()
	..()
	for(var/i = 0, i < 3, i++)
		new /obj/item/stack/spacecash/c100(src)
	for(var/i = 0, i < 5, i++)
		new /obj/item/stack/spacecash/c50(src)
	for(var/i = 0, i < 6, i++)
		new /obj/item/stack/spacecash/c20(src)

/obj/structure/closet/secure_closet/freezer/cream_pie
	name = "морозилка с пирогами"
	desc = "Содержит пироги со сливками и/или заварным кремом, болваны."
	req_access = list(ACCESS_THEATRE)

/obj/structure/closet/secure_closet/freezer/cream_pie/PopulateContents()
	..()
	new /obj/item/food/pie/cream(src)

/obj/structure/closet/secure_closet/freezer/empty
	name = "холодильник"
	req_access = list()

/obj/structure/closet/secure_closet/freezer/empty/PopulateContents()
	return
