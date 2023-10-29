/obj/structure/closet/cabinet
	name = "деревянный шкаф"
	desc = "Винтаж всегда в моде."
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 30
	close_sound_volume = 50
	max_integrity = 70
	door_anim_time = 0 // no animation

/obj/structure/closet/acloset
	name = "странный шкаф"
	desc = "Выглядит чуждым!"
	icon_state = "alien"


/obj/structure/closet/gimmick
	name = "кладовка администраторов"
	desc = "Хранилище для запрещенных вещей."
	icon_state = "syndicate"

/obj/structure/closet/gimmick/russian
	name = "Русский шкаф с припасами"
	desc = "Хранилище для стандартных Русских припасов."

/obj/structure/closet/gimmick/russian/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/clothing/head/ushanka(src)
	for(var/i in 1 to 5)
		new /obj/item/clothing/under/costume/soviet(src)

/obj/structure/closet/gimmick/tacticool
	name = "шкаф для тактического снаряжения"
	desc = "Хранилище тактического снаряжения."

/obj/structure/closet/gimmick/tacticool/PopulateContents()
	..()
	new /obj/item/clothing/glasses/eyepatch(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/gloves/tackler/combat(src)
	new /obj/item/clothing/gloves/tackler/combat(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/mask/gas/sechailer/swat(src)
	new /obj/item/clothing/mask/gas/sechailer/swat(src)
	new /obj/item/clothing/shoes/combat/swat(src)
	new /obj/item/clothing/shoes/combat/swat(src)
	new /obj/item/mod/control/pre_equipped/apocryphal(src)
	new /obj/item/mod/control/pre_equipped/apocryphal(src)
	new /obj/item/clothing/under/syndicate/tacticool(src)
	new /obj/item/clothing/under/syndicate/tacticool(src)


/obj/structure/closet/thunderdome
	name = "\improper шкаф Тандердома"
	desc = "Все, что тебе нужно!"
	anchored = TRUE

/obj/structure/closet/thunderdome/tdred
	name = "шкаф красной команды Тандердома"
	icon_door = "red"

/obj/structure/closet/thunderdome/tdred/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/armor/tdome/red(src)
	for(var/i in 1 to 3)
		new /obj/item/melee/energy/sword/saber(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser(src)
	for(var/i in 1 to 3)
		new /obj/item/melee/baton/loaded(src)
	for(var/i in 1 to 3)
		new /obj/item/storage/box/flashbangs(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/helmet/thunderdome(src)

/obj/structure/closet/thunderdome/tdgreen
	name = "шкаф зеленой команды Тандердома"
	icon_door = "green"

/obj/structure/closet/thunderdome/tdgreen/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/armor/tdome/green(src)
	for(var/i in 1 to 3)
		new /obj/item/melee/energy/sword/saber(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser(src)
	for(var/i in 1 to 3)
		new /obj/item/melee/baton/loaded(src)
	for(var/i in 1 to 3)
		new /obj/item/storage/box/flashbangs(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/helmet/thunderdome(src)

/obj/structure/closet/malf/suits
	desc = "Хранилище для оперативного оборудования."
	icon_state = "syndicate"

/obj/structure/closet/malf/suits/PopulateContents()
	..()
	new /obj/item/tank/jetpack/void(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/head/helmet/space/nasavoid(src)
	new /obj/item/clothing/suit/space/nasavoid(src)
	new /obj/item/crowbar(src)
	new /obj/item/stock_parts/cell(src)
	new /obj/item/multitool(src)

/obj/structure/closet/mini_fridge
	name = "грязный минихолодильник"
	desc = "Небольшое приспособление, предназначенное для охлаждения напитков. Однако сейчас используется только как домик для тараканов."
	icon_state = "mini_fridge"
	icon_reinforced = null
	icon_welded = "welded_small"
	max_mob_size = MOB_SIZE_SMALL
	storage_capacity = 7

/obj/structure/closet/mini_fridge/PopulateContents()
	. = ..()
	new /obj/effect/spawner/lootdrop/refreshing_beverage(src)
	new /obj/effect/spawner/lootdrop/refreshing_beverage(src)
	if(prob(50))
		new /obj/effect/spawner/lootdrop/refreshing_beverage(src)
	if(prob(40))
		new /obj/item/food/pizzaslice/moldy(src)
	else if(prob(30))
		new /obj/item/food/syndicake(src)
