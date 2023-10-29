/datum/crafting_recipe/mixedbouquet
	name = "Смешанный букет"
	result = /obj/item/bouquet
	reqs = list(/obj/item/food/grown/poppy/lily =2,
				/obj/item/grown/sunflower = 2,
				/obj/item/food/grown/poppy/geranium = 2)
	category = CAT_MISC

/datum/crafting_recipe/sunbouquet
	name = "Букет из подсолнухов"
	result = /obj/item/bouquet/sunflower
	reqs = list(/obj/item/grown/sunflower = 6)
	category = CAT_MISC

/datum/crafting_recipe/poppybouquet
	name = "Маковый букет"
	result = /obj/item/bouquet/poppy
	reqs = list (/obj/item/food/grown/poppy = 6)
	category = CAT_MISC

/datum/crafting_recipe/rosebouquet
	name = "Букет роз"
	result = /obj/item/bouquet/rose
	reqs = list(/obj/item/food/grown/rose = 6)
	category = CAT_MISC

/datum/crafting_recipe/spooky_camera
	name = "Камера обскура"
	result = /obj/item/camera/spooky
	time = 15
	reqs = list(/obj/item/camera = 1,
				/datum/reagent/water/holywater = 10)
	parts = list(/obj/item/camera = 1)
	category = CAT_MISC


/datum/crafting_recipe/skateboard
	name = "Скейтборд"
	result = /obj/vehicle/ridden/scooter/skateboard/improvised
	time = 60
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/rods = 10)
	category = CAT_MISC

/datum/crafting_recipe/scooter
	name = "Скутер"
	result = /obj/vehicle/ridden/scooter
	time = 65
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/rods = 12)
	category = CAT_MISC

/datum/crafting_recipe/wheelchair
	name = "Инвалидное кресло"
	result = /obj/vehicle/ridden/wheelchair
	reqs = list(/obj/item/stack/sheet/iron = 4,
				/obj/item/stack/rods = 6)
	time = 100
	category = CAT_MISC

/datum/crafting_recipe/motorized_wheelchair
	name = "Моторизованное инвалидное кресло"
	result = /obj/vehicle/ridden/wheelchair/motorized
	reqs = list(/obj/item/stack/sheet/iron = 10,
		/obj/item/stack/rods = 8,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 1)
	parts = list(/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	time = 200
	category = CAT_MISC

/datum/crafting_recipe/trapdoor_kit
	name = "Строительный комплект для Люка"
	result = /obj/item/trapdoor_kit
	reqs = list(/obj/item/stack/sheet/iron = 4,
		/obj/item/stack/rods = 4,
		/obj/item/stack/cable_coil = 10,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/assembly/signaler = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 10 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/trapdoor_remote
	name = "Пульт дистанционного управления люком"
	result = /obj/item/trapdoor_remote/crafted // since its useless without its assembly just require an assembly to craft it
	reqs = list(
		/obj/item/compact_remote = 1,
		/obj/item/stack/cable_coil = 5,
		/obj/item/assembly/trapdoor = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 5 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/mousetrap
	name = "Мышеловка"
	result = /obj/item/assembly/mousetrap
	time = 10
	reqs = list(/obj/item/stack/sheet/cardboard = 1,
				/obj/item/stack/rods = 1)
	category = CAT_MISC

/datum/crafting_recipe/papersack
	name = "Бумажный мешок"
	result = /obj/item/storage/box/papersack
	time = 10
	reqs = list(/obj/item/paper = 5)
	category = CAT_MISC


/datum/crafting_recipe/flashlight_eyes
	name = "Глаза фонарики"
	result = /obj/item/organ/eyes/robotic/flashlight
	time = 10
	reqs = list(
		/obj/item/flashlight = 2,
		/obj/item/restraints/handcuffs/cable = 1
	)
	category = CAT_MISC

/datum/crafting_recipe/paperframes
	name = "Бумажный фрейм"
	result = /obj/item/stack/sheet/paperframes/five
	time = 10
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5, /obj/item/paper = 20)
	category = CAT_MISC

/datum/crafting_recipe/naturalpaper
	name = "Спрессованная руками бумага"
	time = 30
	reqs = list(/datum/reagent/water = 50, /obj/item/stack/sheet/mineral/wood = 1)
	tool_paths = list(/obj/item/hatchet)
	result = /obj/item/paper_bin/bundlenatural
	category = CAT_MISC

/datum/crafting_recipe/toysword
	name = "Игрушечный меч"
	reqs = list(/obj/item/light/bulb = 1, /obj/item/stack/cable_coil = 1, /obj/item/stack/sheet/plastic = 4)
	result = /obj/item/toy/sword
	category = CAT_MISC

/datum/crafting_recipe/blackcarpet
	name = "Черный ковер"
	reqs = list(/obj/item/stack/tile/carpet = 50, /obj/item/toy/crayon/black = 1)
	result = /obj/item/stack/tile/carpet/black/fifty
	category = CAT_MISC

/datum/crafting_recipe/curtain
	name = "Занавески"
	reqs = 	list(/obj/item/stack/sheet/cloth = 4, /obj/item/stack/rods = 1)
	result = /obj/structure/curtain/cloth
	category = CAT_MISC

/datum/crafting_recipe/showercurtain
	name = "Занавески для душа"
	reqs = 	list(/obj/item/stack/sheet/cloth = 2, /obj/item/stack/sheet/plastic = 2, /obj/item/stack/rods = 1)
	result = /obj/structure/curtain
	category = CAT_MISC

/datum/crafting_recipe/extendohand_r
	name = "Длинн-о-рука (Правая)"
	reqs = list(/obj/item/bodypart/r_arm/robot = 1, /obj/item/clothing/gloves/boxing = 1)
	result = /obj/item/extendohand
	category = CAT_MISC

/datum/crafting_recipe/extendohand_l
	name = "Длинн-о-рука (Левая)"
	reqs = list(/obj/item/bodypart/l_arm/robot = 1, /obj/item/clothing/gloves/boxing = 1)
	result = /obj/item/extendohand
	category = CAT_MISC

/datum/crafting_recipe/gold_horn
	name = "Золотой гудок"
	result = /obj/item/bikehorn/golden
	time = 20
	reqs = list(/obj/item/stack/sheet/mineral/bananium = 5,
				/obj/item/bikehorn = 1)
	category = CAT_MISC

/datum/crafting_recipe/rcl
	name = "Самодельный фильтр для труб"
	result = /obj/item/rcl/ghetto
	time = 40
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	reqs = list(/obj/item/stack/sheet/iron = 15)
	category = CAT_MISC

/datum/crafting_recipe/aitater
	name = "Картофельная интелкарта"
	result = /obj/item/aicard/aitater
	time = 30
	tool_behaviors = list(TOOL_WIRECUTTER)
	reqs = list(
		/obj/item/electronics/apc = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/stack/cable_coil = 5)
	category = CAT_MISC
/*
/datum/crafting_recipe/aitater/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/aicard/aicard = collected_requirements[/obj/item/aicard][1]
	if(!aicard.AI)
		return TRUE

	to_chat(user, span_boldwarning("Я не могу это сделать, пока в интелкарту загружен ИИ!"))
	return FALSE
*/

/datum/crafting_recipe/aispook
	name = "Тыквенная интелкарта"
	result = /obj/item/aicard/aispook
	time = 30
	tool_behaviors = list(TOOL_WIRECUTTER)
	reqs = list(
		/obj/item/electronics/apc = 1,
		/obj/item/food/grown/pumpkin = 1,
		/obj/item/stack/cable_coil = 5)
	category = CAT_MISC

/datum/crafting_recipe/underwater_basket
	name = "Подводная корзина из бамбука"
	reqs = list(
		/obj/item/stack/sheet/mineral/bamboo = 20
	)
	result = /obj/item/storage/basket
	category = CAT_MISC
	additional_req_text = " being underwater, underwater basketweaving mastery"

/datum/crafting_recipe/underwater_basket/check_requirements(mob/user, list/collected_requirements)
	. = ..()
	if(!HAS_TRAIT(user,TRAIT_UNDERWATER_BASKETWEAVING_KNOWLEDGE))
		return FALSE
	var/turf/T = get_turf(user)
	if(istype(T,/turf/open/water) || istype(T,/turf/open/floor/plating/beach/water))
		return TRUE
	var/obj/machinery/shower/S = locate() in T
	if(S?.actually_on)
		return TRUE

//Same but with wheat
/datum/crafting_recipe/underwater_basket/wheat
	name = "Подводная корзина из пшеницы"
	reqs = list(
		/obj/item/food/grown/wheat = 50
	)

/datum/crafting_recipe/coffee_cartridge
	name = "Картридж Бутлег-кофе"
	result = /obj/item/coffee_cartridge/bootleg
	time = 2 SECONDS
	reqs = list(
		/obj/item/blank_coffee_cartridge = 1,
		/datum/reagent/toxin/coffeepowder = 10,
	)
	category = CAT_MISC
/datum/crafting_recipe/potato_cell
	name = "Батарейка из картошки"
	result = /obj/item/stock_parts/cell/potato
	reqs = list(/obj/item/food/grown/potato = 1,
				/obj/item/stack/cable_coil = 10)
	time = 25
	category = CAT_MISC

/datum/crafting_recipe/reciever
	name = "Модульная затворная коробка"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER, TOOL_SAW)
	result = /obj/item/weaponcrafting/receiver
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/sticky_tape = 1,
				/obj/item/screwdriver = 1,
				/obj/item/assembly/mousetrap = 1)
	time = 100
	category = CAT_MISC

/datum/crafting_recipe/riflestock
	name = "Винтовочный приклад"
	tool_paths = list(/obj/item/hatchet)
	result = /obj/item/weaponcrafting/stock
	reqs = list(/obj/item/stack/sheet/mineral/wood = 8,
				/obj/item/stack/sticky_tape = 1)
	time = 50
	category = CAT_MISC
