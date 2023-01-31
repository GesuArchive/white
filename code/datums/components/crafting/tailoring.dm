/datum/crafting_recipe/durathread_vest //На счет отдельной категории брони ещё вопрос стоит...
	name = "Дюратканевый бронежилет"
	result = /obj/item/clothing/suit/armor/vest/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 5,
				/obj/item/stack/sheet/leather = 4)
	time = 50
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_helmet
	name = "Дюратканевый шлем"
	result = /obj/item/clothing/head/helmet/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 4,
				/obj/item/stack/sheet/leather = 5)
	time = 40
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_jumpsuit
	name = "Дюратканевый комбинезон"
	result = /obj/item/clothing/under/misc/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 4)
	time = 40
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_beret
	name = "Дюратканевый берет"
	result = /obj/item/clothing/head/beret/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 2)
	time = 40
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_beanie
	name = "Дюратканевая шапочка"
	result = /obj/item/clothing/head/beanie/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 2)
	time = 40
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_bandana
	name = "Дюратканевая бандана"
	result = /obj/item/clothing/mask/bandana/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 1)
	time = 25
	category = CAT_CLOTHING

/datum/crafting_recipe/fannypack
	name = "Барсетка"
	result = /obj/item/storage/belt/fannypack
	reqs = list(/obj/item/stack/sheet/cloth = 2,
				/obj/item/stack/sheet/leather = 1)
	time = 20
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsunsec
	name = "Тактические очки офицера"
	result = /obj/item/clothing/glasses/hud/security/sunglasses
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/security = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsunsecremoval
	name = "Разборка тактических очков офицера"
	result = /obj/item/clothing/glasses/sunglasses
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/security/sunglasses = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsunmed
	name = "Тактические медицинские очки"
	result = /obj/item/clothing/glasses/hud/health/sunglasses
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/health = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsunmedremoval
	name = "Разборка тактических медицинских очков"
	result = /obj/item/clothing/glasses/sunglasses
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/health/sunglasses = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsundiag
	name = "Тактические диагностические очки"
	result = /obj/item/clothing/glasses/hud/diagnostic/sunglasses
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsundiagremoval
	name = "Разборка тактических диагностических очков"
	result = /obj/item/clothing/glasses/sunglasses
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic/sunglasses = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/scienceglasses
	name = "Тактические научные очки"
	result = /obj/item/clothing/glasses/sunglasses/chemical
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/science = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/scienceglassesremoval
	name = "Разборка тактических научных очков"
	result = /obj/item/clothing/glasses/sunglasses
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/sunglasses/chemical = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudpresmed
	name = "Медицинские очки по рецепту"
	result = /obj/item/clothing/glasses/hud/health/prescription
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/health = 1,
				  /obj/item/clothing/glasses/regular/ = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudpressec
	name = "Офицерские очки по рецепту"
	result = /obj/item/clothing/glasses/hud/security/prescription
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/security = 1,
				  /obj/item/clothing/glasses/regular/ = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudpressci
	name = "Научные очки по рецепту"
	result = /obj/item/clothing/glasses/science/prescription
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/science = 1,
				  /obj/item/clothing/glasses/regular/ = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudpresmeson
	name = "Мезонные очки по рецепту"
	result = /obj/item/clothing/glasses/meson/prescription
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/meson = 1,
				  /obj/item/clothing/glasses/regular/ = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudpresdiag
	name = "Диагностические очки по рецепту"
	result = /obj/item/clothing/glasses/hud/diagnostic/prescription
	time = 20
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic = 1,
				  /obj/item/clothing/glasses/regular/ = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/ghostsheet
	name = "Саван неприкаянного"
	result = /obj/item/clothing/suit/ghost_sheet
	time = 5
	tool_behaviors = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/bedsheet = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/cowboyboots
	name = "Ковбойские сапоги"
	result = /obj/item/clothing/shoes/cowboy
	reqs = list(/obj/item/stack/sheet/leather = 2)
	time = 45
	category = CAT_CLOTHING

/datum/crafting_recipe/lizardboots
	name = "Сапоги из кожи ящера"
	result = /obj/effect/spawner/lootdrop/lizardboots
	reqs = list(/obj/item/stack/sheet/animalhide/lizard = 1, /obj/item/stack/sheet/leather = 1)
	time = 60
	category = CAT_CLOTHING

/datum/crafting_recipe/prisonsuit
	name = "Комбинезон заключенного"
	result = /obj/item/clothing/under/rank/prisoner
	reqs = list(/obj/item/stack/sheet/cloth = 3, /obj/item/stack/license_plates = 1)
	time = 20
	category = CAT_CLOTHING

/datum/crafting_recipe/prisonskirt
	name = "Юбкомбез заключенной"
	result = /obj/item/clothing/under/rank/prisoner/skirt
	reqs = list(/obj/item/stack/sheet/cloth = 3, /obj/item/stack/license_plates = 1)
	time = 20
	category = CAT_CLOTHING

/datum/crafting_recipe/prisonshoes
	name = "Тюремные ботинки"
	result = /obj/item/clothing/shoes/sneakers/orange
	reqs = list(/obj/item/stack/sheet/cloth = 2, /obj/item/stack/license_plates = 1)
	time = 10
	category = CAT_CLOTHING

/datum/crafting_recipe/rainbowbunchcrown
	name = "Радужная цветочная корона"
	result = /obj/item/clothing/head/rainbowbunchcrown/
	time = 20
	reqs = list(/obj/item/food/grown/rainbow_flower = 5,
				/obj/item/stack/cable_coil = 3)
	category = CAT_CLOTHING

/datum/crafting_recipe/sunflowercrown
	name = "Солнечная цветочная корона"
	result = /obj/item/clothing/head/sunflowercrown/
	time = 20
	reqs = list(/obj/item/grown/sunflower = 5,
				/obj/item/stack/cable_coil = 3)
	category = CAT_CLOTHING

/datum/crafting_recipe/poppycrown
	name = "Алая цветочная корона"
	result = /obj/item/clothing/head/poppycrown/
	time = 20
	reqs = list(/obj/item/food/grown/poppy = 5,
				/obj/item/stack/cable_coil = 3)
	category = CAT_CLOTHING

/datum/crafting_recipe/lilycrown
	name = "Невинная цветочная корона"
	result = /obj/item/clothing/head/lilycrown/
	time = 20
	reqs = list(/obj/item/food/grown/poppy/lily = 3,
				/obj/item/stack/cable_coil = 3)
	category = CAT_CLOTHING
