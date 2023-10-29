/datum/crafting_recipe/lizardhat
	name = "Колпак ящерицы"
	result = /obj/item/clothing/head/lizard
	time = 10
	reqs = list(/obj/item/organ/tail/lizard = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/lizardhat_alternate
	name = "Колпак ящерицы"
	result = /obj/item/clothing/head/lizard
	time = 10
	reqs = list(/obj/item/stack/sheet/animalhide/lizard = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/kittyears
	name = "Кошачьи ушки"
	result = /obj/item/clothing/head/kitty/genuine
	time = 10
	reqs = list(/obj/item/organ/tail/cat = 1,
				/obj/item/organ/ears/cat = 1)
	category = CAT_CLOTHING


/datum/crafting_recipe/radiogloves
	name = "Радиоперчатки"
	result = /obj/item/clothing/gloves/radio
	time = 15
	reqs = list(/obj/item/clothing/gloves/color/black = 1,
				/obj/item/stack/cable_coil = 2,
				/obj/item/radio = 1)
	tool_behaviors = list(TOOL_WIRECUTTER)
	category = CAT_CLOTHING

/datum/crafting_recipe/bonearmor
	name = "Костяная броня"
	result = /obj/item/clothing/suit/armor/bone
	time = 30
	reqs = list(/obj/item/stack/sheet/bone = 6)
	category = CAT_CLOTHING

/datum/crafting_recipe/bonetalisman
	name = "Костяной талисман"
	result = /obj/item/clothing/accessory/talisman
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2,
				/obj/item/stack/sheet/sinew = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/bonecodpiece
	name = "Костяной гульфик"
	result = /obj/item/clothing/accessory/skullcodpiece
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2,
				/obj/item/stack/sheet/animalhide/goliath_hide = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/skilt
	name = "Килт из сухожилий"
	result = /obj/item/clothing/accessory/skilt
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 1,
				/obj/item/stack/sheet/sinew = 2)
	category = CAT_CLOTHING

/datum/crafting_recipe/bracers
	name = "Костяные наручи"
	result = /obj/item/clothing/gloves/bracer
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2,
				/obj/item/stack/sheet/sinew = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/skullhelm
	name = "Костяной шлем"
	result = /obj/item/clothing/head/helmet/skull
	time = 30
	reqs = list(/obj/item/stack/sheet/bone = 4)
	category = CAT_CLOTHING

/datum/crafting_recipe/goliathcloak
	name = "Накидка из голиафа"
	result = /obj/item/clothing/suit/hooded/cloak/goliath
	time = 50
	reqs = list(/obj/item/stack/sheet/leather = 2,
				/obj/item/stack/sheet/sinew = 2,
				/obj/item/stack/sheet/animalhide/goliath_hide = 2) //it takes 4 goliaths to make 1 cloak if the plates are skinned
	category = CAT_CLOTHING

/datum/crafting_recipe/drakecloak
	name = "Броня пепельного дракона"
	result = /obj/item/clothing/suit/hooded/cloak/drake
	time = 60
	reqs = list(/obj/item/stack/sheet/bone = 10,
				/obj/item/stack/sheet/sinew = 2,
				/obj/item/stack/sheet/animalhide/ashdrake = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/mummy
	name = "Повязки для мумификации (Голова)"
	result = /obj/item/clothing/mask/mummy
	time = 10
	tool_paths = list(/obj/item/nullrod/egyptian)
	reqs = list(/obj/item/stack/sheet/cloth = 2)
	category = CAT_CLOTHING

/datum/crafting_recipe/mummy/body
	name = "Повязки для мумификации (Тело)"
	result = /obj/item/clothing/under/costume/mummy
	reqs = list(/obj/item/stack/sheet/cloth = 5)

/datum/crafting_recipe/chaplain_hood
	name = "Роба последователей священника"
	result = /obj/item/clothing/suit/hooded/chaplain_hoodie
	time = 10
	tool_paths = list(/obj/item/clothing/suit/hooded/chaplain_hoodie, /obj/item/storage/book/bible)
	reqs = list(/obj/item/stack/sheet/cloth = 4)
	category = CAT_CLOTHING

/datum/crafting_recipe/gripperoffbrand
	name = "Самодельные хватательные перчатки"
	reqs = list(
		/obj/item/clothing/gloves/fingerless = 1,
		/obj/item/stack/sticky_tape = 1,
	)
	result = /obj/item/clothing/gloves/tackler/offbrand
	category = CAT_CLOTHING

/datum/crafting_recipe/boh
	name = "Блюспейс рюкзак"
	reqs = list(
		/obj/item/bag_of_holding_inert = 1,
		/obj/item/assembly/signaler/anomaly/bluespace = 1,
	)
	result = /obj/item/storage/backpack/holding
	category = CAT_CLOTHING
