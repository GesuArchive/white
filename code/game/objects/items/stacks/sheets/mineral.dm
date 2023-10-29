/*
Mineral Sheets
	Contains:
		- Sandstone
		- Sandbags
		- Diamond
		- Snow
		- Uranium
		- Plasma
		- Gold
		- Silver
		- Clown
		- Titanium
		- Plastitanium
	Others:
		- Adamantine
		- Mythril
		- Alien Alloy
		- Coal
*/

/*
 * Sandstone
 */

GLOBAL_LIST_INIT(sandstone_recipes, list ( \
	new/datum/stack_recipe("Куча грязи", /obj/machinery/hydroponics/soil, 3, time = 10, one_per_turf = TRUE, on_floor = TRUE, category = CAT_TOOLS), \
	new/datum/stack_recipe("Дверь из Песчаника", /obj/structure/mineral_door/sandstone, 10, one_per_turf = TRUE, on_floor = TRUE, category = CAT_DOORS), \
	new/datum/stack_recipe("Статуя Ассистента", /obj/structure/statue/sandstone/assistant, 5, one_per_turf = TRUE, on_floor = TRUE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("Breakdown into sand", /obj/item/stack/ore/glass, 1, one_per_turf = FALSE, on_floor = TRUE, category = CAT_MISC) \
	))

/obj/item/stack/sheet/mineral/sandstone
	name = "Кирпич из песчаника"
	desc = "Кажется, это комбинация из песка и камня."
	singular_name = "sandstone brick"
	icon_state = "sheet-sandstone"
	inhand_icon_state = "sheet-sandstone"
	throw_speed = 3
	throw_range = 5
	mats_per_unit = list(/datum/material/sandstone=MINERAL_MATERIAL_AMOUNT)
	sheettype = "sandstone"
	merge_type = /obj/item/stack/sheet/mineral/sandstone
	walltype = /turf/closed/wall/mineral/sandstone
	material_type = /datum/material/sandstone

/obj/item/stack/sheet/mineral/sandstone/get_main_recipes()
	. = ..()
	. += GLOB.sandstone_recipes

/obj/item/stack/sheet/mineral/sandstone/thirty
	amount = 30

/*
 * Sandbags
 */

/obj/item/stack/sheet/mineral/sandbags
	name = "Мешки с песком"
	icon_state = "sandbags"
	singular_name = "Мешок с песком"
	layer = LOW_ITEM_LAYER
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/mineral/sandbags

GLOBAL_LIST_INIT(sandbag_recipes, list ( \
	new/datum/stack_recipe("мешки с песком", /obj/structure/barricade/sandbags, 1, time = 25, one_per_turf = 1, on_floor = 1, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("направленные мешки", /obj/structure/deployable_barricade/sandbags, 1, time = 25, one_per_turf = 1, on_floor = 1, category = CAT_STRUCTURE), \
	))

/obj/item/stack/sheet/mineral/sandbags/get_main_recipes()
	. = ..()
	. += GLOB.sandbag_recipes

/obj/item/emptysandbag
	name = "пустой мешок для песка"
	desc = "Мешок для песка."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "sandbag"
	w_class = WEIGHT_CLASS_TINY

/obj/item/emptysandbag/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/ore/glass))
		var/obj/item/stack/ore/glass/G = W
		to_chat(user, span_notice("Наполняю мешок с песком."))
		var/obj/item/stack/sheet/mineral/sandbags/I = new /obj/item/stack/sheet/mineral/sandbags(drop_location())
		qdel(src)
		if (Adjacent(user) && !issilicon(user))
			user.put_in_hands(I)
		G.use(1)
	else
		return ..()

/*
 * Diamond
 */
/obj/item/stack/sheet/mineral/diamond
	name = "алмаз"
	icon_state = "sheet-diamond"
	inhand_icon_state = "sheet-diamond"
	singular_name = "алмаз"
	sheettype = "diamond"
	mats_per_unit = list(/datum/material/diamond=MINERAL_MATERIAL_AMOUNT)
	multivariant = TRUE
	grind_results = list(/datum/reagent/carbon = 20)
	point_value = 25
	merge_type = /obj/item/stack/sheet/mineral/diamond
	material_type = /datum/material/diamond
	walltype = /turf/closed/wall/mineral/diamond

GLOBAL_LIST_INIT(diamond_recipes, list ( \
	new/datum/stack_recipe("Алмазная дверь", /obj/structure/mineral_door/transparent/diamond, 10, one_per_turf = 1, on_floor = 1, category = CAT_DOORS), \
	new/datum/stack_recipe("Алмазная плитка", /obj/item/stack/tile/mineral/diamond, 1, 4, 20, category = CAT_TILES),  \
	new/datum/stack_recipe("Статуя Капитана", /obj/structure/statue/diamond/captain, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("Статуя с Голограммой ИИ", /obj/structure/statue/diamond/ai1, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("Статуя Ядра ИИ", /obj/structure/statue/diamond/ai2, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	))

/obj/item/stack/sheet/mineral/diamond/get_main_recipes()
	. = ..()
	. += GLOB.diamond_recipes

/obj/item/stack/sheet/mineral/diamond/update_icon_state()
	var/amount_icon
	switch(amount)
		if(1)
			amount_icon = 1
		if(2 to 9)
			amount_icon = 2
		if(10 to 19)
			amount_icon = 3
		if(20 to 29)
			amount_icon = 4
		if(30 to 39)
			amount_icon = 5
		if(40 to 49)
			amount_icon = 6
		else
			amount_icon = 7
	icon_state = "[initial(icon_state)]_[amount_icon]"
	return ..()

/*
 * Uranium
 */
/obj/item/stack/sheet/mineral/uranium
	name = "уран"
	icon_state = "sheet-uranium"
	inhand_icon_state = "sheet-uranium"
	singular_name = "урановый лист"
	sheettype = "uranium"
	multivariant = TRUE
	mats_per_unit = list(/datum/material/uranium=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/uranium = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/uranium
	material_type = /datum/material/uranium
	walltype = /turf/closed/wall/mineral/uranium

GLOBAL_LIST_INIT(uranium_recipes, list ( \
	new/datum/stack_recipe("Урановая дверь", /obj/structure/mineral_door/uranium, 10, one_per_turf = 1, on_floor = 1, category = CAT_DOORS), \
	new/datum/stack_recipe("Урановая плитка", /obj/item/stack/tile/mineral/uranium, 1, 4, 20, category = CAT_TILES), \
	new/datum/stack_recipe("Статуя Ядерной Бомбы", /obj/structure/statue/uranium/nuke, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("Статуя Инженера", /obj/structure/statue/uranium/eng, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	))

/obj/item/stack/sheet/mineral/uranium/get_main_recipes()
	. = ..()
	. += GLOB.uranium_recipes

/obj/item/stack/sheet/mineral/uranium/update_icon_state()
	var/amount_icon
	switch(amount)
		if(1)
			amount_icon = 1
		if(2 to 12)
			amount_icon = 2
		if(13 to 24)
			amount_icon = 3
		if(25 to 37)
			amount_icon = 4
		if(38 to 49)
			amount_icon = 5
		else
			amount_icon = 6
	icon_state = "[initial(icon_state)]_[amount_icon]"
	return ..()

/obj/item/stack/sheet/mineral/uranium/five
	amount = 5

/obj/item/stack/sheet/mineral/uranium/twenty
	amount = 20

/*
 * Plasma
 */
/obj/item/stack/sheet/mineral/plasma
	name = "твердая плазма"
	icon_state = "sheet-plasma"
	inhand_icon_state = "sheet-plasma"
	singular_name = "лист плазмы"
	sheettype = "plasma"
	resistance_flags = FLAMMABLE
	multivariant = TRUE
	max_integrity = 100
	mats_per_unit = list(/datum/material/plasma=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/toxin/plasma = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/plasma
	material_type = /datum/material/plasma
	walltype = /turf/closed/wall/mineral/plasma

/obj/item/stack/sheet/mineral/plasma/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] начинает облизывать <b>[src.name]</b>! Похоже [user.p_theyre()] пытается совершить самоубийство!"))
	return TOXLOSS//dont you kids know that stuff is toxic?

GLOBAL_LIST_INIT(plasma_recipes, list ( \
	new/datum/stack_recipe("Плазменная дверь", /obj/structure/mineral_door/transparent/plasma, 10, one_per_turf = 1, on_floor = 1, category = CAT_DOORS), \
	new/datum/stack_recipe("Плазменная плитка", /obj/item/stack/tile/mineral/plasma, 1, 4, 20, category = CAT_TILES), \
	new/datum/stack_recipe("Статуя Ученого", /obj/structure/statue/plasma/scientist, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	))

/obj/item/stack/sheet/mineral/plasma/get_main_recipes()
	. = ..()
	. += GLOB.plasma_recipes

/obj/item/stack/sheet/mineral/plasma/update_icon_state()
	var/amount_icon
	switch(amount)
		if(1)
			amount_icon = 1
		if(2 to 7)
			amount_icon = 2
		if(8 to 16)
			amount_icon = 3
		if(17 to 24)
			amount_icon = 4
		if(25 to 32)
			amount_icon = 5
		if(33 to 41)
			amount_icon = 6
		if(42 to 49)
			amount_icon = 7
		else
			amount_icon = 8
	icon_state = "[initial(icon_state)]_[amount_icon]"
	return ..()

/obj/item/stack/sheet/mineral/plasma/attackby(obj/item/W as obj, mob/user as mob, params)
	if(W.get_temperature() > 300)//If the temperature of the object is over 300, then ignite
		var/turf/T = get_turf(src)
		message_admins("Plasma sheets ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("Plasma sheets ignited by [key_name(user)] in [AREACOORD(T)]")
		fire_act(W.get_temperature())
	else
		return ..()

/obj/item/stack/sheet/mineral/plasma/fire_act(exposed_temperature, exposed_volume)
	atmos_spawn_air("plasma=[amount*10];TEMP=[exposed_temperature]")
	qdel(src)

/obj/item/stack/sheet/mineral/plasma/five
	amount = 5

/obj/item/stack/sheet/mineral/plasma/ten
	amount = 10

/obj/item/stack/sheet/mineral/plasma/thirty
	amount = 30

/*
 * Gold
 */
/obj/item/stack/sheet/mineral/gold
	name = "золото"
	icon_state = "sheet-gold"
	inhand_icon_state = "sheet-gold"
	singular_name = "золотой слиток"
	sheettype = "gold"
	multivariant = TRUE
	mats_per_unit = list(/datum/material/gold=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/gold = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/gold
	material_type = /datum/material/gold
	walltype = /turf/closed/wall/mineral/gold

GLOBAL_LIST_INIT(gold_recipes, list ( \
	new/datum/stack_recipe("Золотая дверь", /obj/structure/mineral_door/gold, 10, one_per_turf = 1, on_floor = 1, category = CAT_DOORS), \
	new/datum/stack_recipe("Золотая плитка", /obj/item/stack/tile/mineral/gold, 1, 4, 20, category = CAT_TILES), \
	new/datum/stack_recipe("Пустая табличка", /obj/item/plaque, 1, category = CAT_FURNITURE), \
	new/datum/stack_recipe("Статуя Главы Службы Безопасности", /obj/structure/statue/gold/hos, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("Статуя Главы Персонала", /obj/structure/statue/gold/hop, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("Статуя Главного Инженера", /obj/structure/statue/gold/ce, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("Статуя Руководителя Исследований", /obj/structure/statue/gold/rd, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("Обычная Корона", /obj/item/clothing/head/crown, 5, category = CAT_CLOTHING), \
	new/datum/stack_recipe("Статуя Главного Врача", /obj/structure/statue/gold/cmo, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	))

/obj/item/stack/sheet/mineral/gold/get_main_recipes()
	. = ..()
	. += GLOB.gold_recipes

/obj/item/stack/sheet/mineral/gold/update_icon_state()
	var/amount_icon
	switch(amount)
		if(1)
			amount_icon = 1
		if(2 to 12)
			amount_icon = 2
		if(13 to 24)
			amount_icon = 3
		if(25 to 37)
			amount_icon = 4
		if(38 to 49)
			amount_icon = 5
		else
			amount_icon = 6
	icon_state = "[initial(icon_state)]_[amount_icon]"
	return ..()

/obj/item/stack/sheet/mineral/gold/five
	amount = 5

/obj/item/stack/sheet/mineral/gold/twenty
	amount = 20

/*
 * Silver
 */
/obj/item/stack/sheet/mineral/silver
	name = "серебро"
	icon_state = "sheet-silver"
	inhand_icon_state = "sheet-silver"
	singular_name = "серебряный слиток"
	sheettype = "silver"
	multivariant = TRUE
	mats_per_unit = list(/datum/material/silver=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/silver = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/silver
	material_type = /datum/material/silver
	tableVariant = /obj/structure/table/optable
	walltype = /turf/closed/wall/mineral/silver

GLOBAL_LIST_INIT(silver_recipes, list ( \
	new/datum/stack_recipe("Серебряная дверь", /obj/structure/mineral_door/silver, 10, one_per_turf = 1, on_floor = 1, category = CAT_DOORS), \
	new/datum/stack_recipe("Серебряная плитка", /obj/item/stack/tile/mineral/silver, 1, 4, 20, category = CAT_TILES), \
	new/datum/stack_recipe("Статуя Доктора", /obj/structure/statue/silver/md, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("Статуя Уборщика", /obj/structure/statue/silver/janitor, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("Статуя Офицера Безопасности", /obj/structure/statue/silver/sec, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("Статуя Охранного Киборга ", /obj/structure/statue/silver/secborg, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("Статуя Медицинского Киборга", /obj/structure/statue/silver/medborg, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	))

/obj/item/stack/sheet/mineral/silver/get_main_recipes()
	. = ..()
	. += GLOB.silver_recipes

/obj/item/stack/sheet/mineral/silver/update_icon_state()
	var/amount_icon
	switch(amount)
		if(1)
			amount_icon = 1
		if(2 to 12)
			amount_icon = 2
		if(13 to 24)
			amount_icon = 3
		if(25 to 37)
			amount_icon = 4
		if(38 to 49)
			amount_icon = 5
		else
			amount_icon = 6
	icon_state = "[initial(icon_state)]_[amount_icon]"
	return ..()

/obj/item/stack/sheet/mineral/silver/twenty
	amount = 20

/*
 * Clown
 */
/obj/item/stack/sheet/mineral/bananium
	name = "бананий"
	icon_state = "sheet-bananium"
	inhand_icon_state = "sheet-bananium"
	singular_name = "лист банания"
	sheettype = "bananium"
	mats_per_unit = list(/datum/material/bananium=MINERAL_MATERIAL_AMOUNT)
	novariants = TRUE
	grind_results = list(/datum/reagent/consumable/banana = 20)
	point_value = 50
	merge_type = /obj/item/stack/sheet/mineral/bananium
	material_type = /datum/material/bananium
	walltype = /turf/closed/wall/mineral/bananium

GLOBAL_LIST_INIT(bananium_recipes, list ( \
	new/datum/stack_recipe("Бананиевая плитка", /obj/item/stack/tile/mineral/bananium, 1, 4, 20, category = CAT_TILES), \
	new/datum/stack_recipe("Статуя Клоуна", /obj/structure/statue/bananium/clown, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	))

/obj/item/stack/sheet/mineral/bananium/get_main_recipes()
	. = ..()
	. += GLOB.bananium_recipes

/obj/item/stack/sheet/mineral/bananium/ten
	amount = 10

/*
 * Titanium
 */
/obj/item/stack/sheet/mineral/titanium
	name = "титан"
	icon_state = "sheet-titanium"
	inhand_icon_state = "sheet-titanium"
	singular_name = "лист титана"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	sheettype = "titanium"
	mats_per_unit = list(/datum/material/titanium=MINERAL_MATERIAL_AMOUNT)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/titanium
	material_type = /datum/material/titanium
	walltype = /turf/closed/wall/mineral/titanium

GLOBAL_LIST_INIT(titanium_recipes, list ( \
	new/datum/stack_recipe("Титановая плитка", /obj/item/stack/tile/mineral/titanium, 1, 4, 20, category = CAT_TILES), \
	new/datum/stack_recipe("Сиденье для шаттла", /obj/structure/chair/comfy/shuttle, 2, one_per_turf = TRUE, on_floor = TRUE, category = CAT_FURNITURE), \
	))

/obj/item/stack/sheet/mineral/titanium/get_main_recipes()
	. = ..()
	. += GLOB.titanium_recipes

/obj/item/stack/sheet/mineral/titanium/twenty
	amount = 20

/obj/item/stack/sheet/mineral/titanium/fifty
	amount = 50

/*
 * Plastitanium
 */
/obj/item/stack/sheet/mineral/plastitanium
	name = "пластитан"
	desc = "Пластитан является сплавом титана и плазмы. Довольно крепкий, однако из за новизны ученые еще не спроектировали основные производственные чертежи."
	icon_state = "sheet-plastitanium"
	inhand_icon_state = "sheet-plastitanium"
	singular_name = "лист пластитаниума"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	sheettype = "plastitanium"
	mats_per_unit = list(/datum/material/alloy/plastitanium=MINERAL_MATERIAL_AMOUNT)
	point_value = 45
	material_type = /datum/material/alloy/plastitanium
	merge_type = /obj/item/stack/sheet/mineral/plastitanium
	material_flags = MATERIAL_NO_EFFECTS
//	walltype = /turf/closed/wall/mineral/plastitanium

GLOBAL_LIST_INIT(plastitanium_recipes, list ( \
	new/datum/stack_recipe("Пластитаниумная плитка", /obj/item/stack/tile/mineral/plastitanium, 1, 4, 20), \
	))

/obj/item/stack/sheet/mineral/plastitanium/get_main_recipes()
	. = ..()
	. += GLOB.plastitanium_recipes


/*
 * Snow
 */

/obj/item/stack/sheet/mineral/snow
	name = "снег"
	icon_state = "sheet-snow"
	inhand_icon_state = "sheet-snow"
	mats_per_unit = list(/datum/material/snow = MINERAL_MATERIAL_AMOUNT)
	singular_name = "блок снега"
	force = 1
	throwforce = 2
	grind_results = list(/datum/reagent/consumable/ice = 20)
	merge_type = /obj/item/stack/sheet/mineral/snow
	walltype = /turf/closed/wall/mineral/snow
	material_type = /datum/material/snow

GLOBAL_LIST_INIT(snow_recipes, list ( \
	new/datum/stack_recipe("стена из снега", /turf/closed/wall/mineral/snow, 5, one_per_turf = 1, on_floor = 1, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("снеговик", /obj/structure/statue/snow/snowman, 5, one_per_turf = 1, on_floor = 1, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("баррикада", /obj/structure/deployable_barricade/snow, 5, one_per_turf = 1, on_floor = 1, category = CAT_FURNITURE), \
	new/datum/stack_recipe("снежок", /obj/item/toy/snowball, 1, category = CAT_MISC), \
	new/datum/stack_recipe("снежный пол", /obj/item/stack/tile/mineral/snow, 1, 4, 20, category = CAT_TILES), \
	))

/obj/item/stack/sheet/mineral/snow/get_main_recipes()
	. = ..()
	. += GLOB.snow_recipes

/****************************** Others ****************************/

/*
 * Adamantine
*/


GLOBAL_LIST_INIT(adamantine_recipes, list(
	new /datum/stack_recipe("незаконченная оболочка голема-слуги", /obj/item/golem_shell/servant, req_amount=25, res_amount=1, category = CAT_MISC),
	))

/obj/item/stack/sheet/mineral/adamantine
	name = "адамантий"
	icon_state = "sheet-adamantine"
	inhand_icon_state = "sheet-adamantine"
	singular_name = "лист адамантия"
	mats_per_unit = list(/datum/material/adamantine=MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/adamantine

/obj/item/stack/sheet/mineral/adamantine/get_main_recipes()
	. = ..()
	. += GLOB.adamantine_recipes

/*
 * Runite
 */

/obj/item/stack/sheet/mineral/runite
	name = "Рунит"
	desc = "Редкий материал найденный в далеких краях."
	singular_name = "рунитовый слиток"
	icon_state = "sheet-runite"
	inhand_icon_state = "sheet-runite"
	mats_per_unit = list(/datum/material/runite=MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/runite
	material_type = /datum/material/runite


/*
 * Mythril
 */
/obj/item/stack/sheet/mineral/mythril
	name = "мифрил"
	icon_state = "sheet-mythril"
	inhand_icon_state = "sheet-mythril"
	singular_name = "лист мифрила"
	novariants = TRUE
	mats_per_unit = list(/datum/material/mythril=MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/mythril

/*
 * Alien Alloy
 */
/obj/item/stack/sheet/mineral/abductor
	name = "инопланетный сплав"
	desc = "Загадочный материал с неизведанными свойствами."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "sheet-abductor"
	inhand_icon_state = "sheet-abductor"
	singular_name = "лист инопланетного сплава"
	sheettype = "abductor"
	mats_per_unit = list(/datum/material/alloy/alien=MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/abductor
	material_type = /datum/material/alloy/alien
	walltype = /turf/closed/wall/mineral/abductor

GLOBAL_LIST_INIT(abductor_recipes, list ( \
	new/datum/stack_recipe("инопланетная постель", /obj/structure/bed/abductor, 2, one_per_turf = 1, on_floor = 1, category = CAT_FURNITURE), \
	new/datum/stack_recipe("инопланетный шкафчик", /obj/structure/closet/abductor, 2, time = 15, one_per_turf = 1, on_floor = 1, category = CAT_FURNITURE), \
	new/datum/stack_recipe("инопланетная рама стола", /obj/structure/table_frame/abductor, 1, time = 15, one_per_turf = 1, on_floor = 1, category = CAT_FURNITURE), \
	new/datum/stack_recipe("сборка инопланетного шлюза", /obj/structure/door_assembly/door_assembly_abductor, 4, time = 20, one_per_turf = 1, on_floor = 1, category = CAT_DOORS), \
	null, \
	new/datum/stack_recipe("инопланетный пол", /obj/item/stack/tile/mineral/abductor, 1, 4, 20, category = CAT_TILES), \
	))

/obj/item/stack/sheet/mineral/abductor/get_main_recipes()
	. = ..()
	. += GLOB.abductor_recipes

/*
 * Coal
 */

/obj/item/stack/sheet/mineral/coal
	name = "уголь"
	icon = 'white/valtos/icons/prison/prison.dmi'
	desc = "Черный как негр."
	icon_state = "coal"
	singular_name = "кусок угля"
	merge_type = /obj/item/stack/sheet/mineral/coal
	grind_results = list(/datum/reagent/carbon = 20)

/obj/item/stack/sheet/mineral/coal/attackby(obj/item/W, mob/user, params)
	if(W.get_temperature() > 300)//If the temperature of the object is over 300, then ignite
		var/turf/T = get_turf(src)
		message_admins("Coal ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("Coal ignited by [key_name(user)] in [AREACOORD(T)]")
		fire_act(W.get_temperature())
		return TRUE
	else
		return ..()

/obj/item/stack/sheet/mineral/coal/fire_act(exposed_temperature, exposed_volume)
	atmos_spawn_air("co2=[amount*10];TEMP=[exposed_temperature]")
	qdel(src)

/obj/item/stack/sheet/mineral/coal/five
	amount = 5

/obj/item/stack/sheet/mineral/coal/ten
	amount = 10

//Metal Hydrogen
GLOBAL_LIST_INIT(metalhydrogen_recipes, list(
	new /datum/stack_recipe("незаконченная оболочка голема-слуги", /obj/item/golem_shell/servant, req_amount=20, res_amount=1, category = CAT_TILES),
	new /datum/stack_recipe("древняя броня", /obj/item/clothing/suit/armor/elder_atmosian, req_amount = 8, res_amount = 1, category = CAT_MISC),
	new /datum/stack_recipe("древний шлем", /obj/item/clothing/head/helmet/elder_atmosian, req_amount = 5, res_amount = 1, category = CAT_MISC),
	new /datum/stack_recipe("топор из металлического водорода", /obj/item/fireaxe/metal_h2_axe, req_amount = 15, res_amount = 1, category = CAT_WEAPON_MELEE),
	))

/obj/item/stack/sheet/mineral/metal_hydrogen
	name = "металлический водород"
	icon_state = "sheet-metalhydrogen"
	inhand_icon_state = "sheet-metalhydrogen"
	singular_name = "лист металлического водорода"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF | LAVA_PROOF | ACID_PROOF | INDESTRUCTIBLE
	point_value = 100
	mats_per_unit = list(/datum/material/metalhydrogen = MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/metal_hydrogen

/obj/item/stack/sheet/mineral/metal_hydrogen/get_main_recipes()
	. = ..()
	. += GLOB.metalhydrogen_recipes

/obj/item/stack/sheet/mineral/zaukerite
	name = "Заукерит"
	icon_state = "zaukerite"
	inhand_icon_state = "sheet-zaukerite"
	singular_name = "zaukerite crystal"
	w_class = WEIGHT_CLASS_NORMAL
	point_value = 120
	mats_per_unit = list(/datum/material/zaukerite = MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/zaukerite
	material_type = /datum/material/zaukerite
