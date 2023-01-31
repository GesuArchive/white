// Note, the order these in are deliberate, as it affects
// the order they are shown via radial.
GLOBAL_LIST_INIT(runed_metal_recipes, list( \
	new /datum/stack_recipe/radial( \
		title = "пилон", \
		result_type = /obj/structure/destructible/cult/pylon, \
		req_amount = 4, \
		time = 4 SECONDS, \
		one_per_turf = TRUE, \
		on_floor = TRUE, \
		desc = span_cultbold("Лечит (и регенерирует кровь) находящихся поблизости кровавых культистов и конструктов, но также превращает полы поблизости в гравированные."), \
		required_noun = "листов рунического металла", \
		category = CAT_CULT
	), \
	new /datum/stack_recipe/radial( \
		title = "алтарь", \
		result_type = /obj/structure/destructible/cult/talisman, \
		req_amount = 3, \
		time = 4 SECONDS, \
		one_per_turf = TRUE, \
		on_floor = TRUE, \
		desc = span_cultbold("Можно создать жуткие точильные камни, оболочки конструктов и фляги с несвятой водой."), \
		required_noun = "листов рунического металла", \
		category = CAT_CULT
	), \
	new /datum/stack_recipe/radial( \
		title = "архивы", \
		result_type = /obj/structure/destructible/cult/tome, \
		req_amount = 3, \
		time = 4 SECONDS, \
		one_per_turf = TRUE, \
		on_floor = TRUE, \
		desc = span_cultbold("Можно создать глазные повязки фанатиков, сферы проклятия шаттлов, и оборудование идущего по завесе."), \
		required_noun = "листов рунического металла", \
		category = CAT_CULT
	), \
	new /datum/stack_recipe/radial( \
		title = "демоническая кузня", \
		result_type = /obj/structure/destructible/cult/forge, \
		req_amount = 3, \
		time = 4 SECONDS, \
		one_per_turf = TRUE, \
		on_floor = TRUE, \
		desc = span_cultbold("Можно создать защищенные робы, робы флагелянтов и зеркальные щиты."), \
		required_noun = "листов рунического металла", \
		category = CAT_CULT
	), \
	new /datum/stack_recipe/radial( \
		title = "руническая дверь", \
		result_type = /obj/machinery/door/airlock/cult, \
		time = 5 SECONDS, \
		one_per_turf = TRUE, \
		on_floor = TRUE, \
		desc = span_cultbold("Не слишком прочная дверь, оглушает коснувшихся не культистов."), \
		required_noun = "листов рунического металла", \
		category = CAT_CULT
	), \
	new /datum/stack_recipe/radial( \
		title = "руническая балка", \
		result_type = /obj/structure/girder/cult, \
		time = 5 SECONDS, \
		one_per_turf = TRUE, \
		on_floor = TRUE, \
		desc = span_cultbold("Не рекомендованное использование рунного металла."), \
		required_noun = "листов рунического металла", \
		category = CAT_CULT
	), \
))

/obj/item/stack/sheet/runed_metal
	name = "рунический металл"
	desc = "Листы холодного, покрытого меняющимися надписями, металла."
	singular_name = "лист рунического металла"
	icon_state = "sheet-runed"
	inhand_icon_state = "sheet-runed"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/runedmetal = MINERAL_MATERIAL_AMOUNT)
	sheettype = "runed"
	merge_type = /obj/item/stack/sheet/runed_metal
	novariants = TRUE
	grind_results = list(/datum/reagent/iron = 5, /datum/reagent/blood = 15)
	material_type = /datum/material/runedmetal
	has_unique_girder = TRUE
	use_radial = TRUE

/obj/item/stack/sheet/runed_metal/interact(mob/user)
	if(!IS_CULTIST(user))
		to_chat(user, span_warning("Только обладающий запретными знаниями имеет шанс поработать с этим металлом..."))
		return FALSE

	var/turf/user_turf = get_turf(user)
	var/area/user_area = get_area(user)

	var/is_valid_turf = user_turf && (is_station_level(user_turf.z) || is_mining_level(user_turf.z))
	var/is_valid_area = user_area && (user_area.area_flags & CULT_PERMITTED)

	if(!is_valid_turf || !is_valid_area)
		to_chat(user, span_warning("Завеса здесь недостаточно слабая."))
		return FALSE

	return ..()

/obj/item/stack/sheet/runed_metal/radial_check(mob/builder)
	return ..() && IS_CULTIST(builder)

/obj/item/stack/sheet/runed_metal/get_main_recipes()
	. = ..()
	. += GLOB.runed_metal_recipes

/obj/item/stack/sheet/runed_metal/fifty
	amount = 50

/obj/item/stack/sheet/runed_metal/ten
	amount = 10

/obj/item/stack/sheet/runed_metal/five
	amount = 5
