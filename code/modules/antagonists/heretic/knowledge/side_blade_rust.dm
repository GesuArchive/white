// Sidepaths for knowledge between Rust and Blade.
/datum/heretic_knowledge/armor
	name = "Ритуал Оружейника"
	desc = "Позволяет трансмутировать стол и противогаз для создания Древней Брони. \
		Она отлично защищает, так же помогая сфокусировать мысли для заклинаний, когда надет капюшон."
	gain_text = "Ржавые Холмы добро приветствовали Кузнеца. И тот щедро отплатил им."
	next_knowledge = list(
		/datum/heretic_knowledge/rust_regen,
		/datum/heretic_knowledge/blade_dance,
	)
	required_atoms = list(
		/obj/structure/table = 1,
		/obj/item/clothing/mask/gas = 1,
	)
	result_atoms = list(/obj/item/clothing/suit/hooded/cultrobes/eldritch)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/crucible
	name = "Оскаленный Котел"
	desc = "Позволяет трансмутировать бак с водой и стол для создания Котла. \
		Он предоставляет возможность варить мощные зелья для боя и лечения. \
		Но перед использованием необходимо добыть некоторые части тел и органы"
	gain_text = "Это настоящая агония. Я не смог воззвать к Аристократу, \
		но благодаря помощи Жреца я наткнулся на другой рецепт..."
	next_knowledge = list(
		/datum/heretic_knowledge/duel_stance,
		/datum/heretic_knowledge/spell/area_conversion,
	)
	required_atoms = list(
		/obj/structure/reagent_dispensers/watertank = 1,
		/obj/structure/table = 1,
	)
	result_atoms = list(/obj/structure/destructible/eldritch_crucible)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/rifle
	name = "Винтовка Зверобоя"
	desc = "Позволяет трансмутировать огнестрельное оружие, шкуру \
		любого животного, деревеянную доску и фотокамеру для создания Винтовки Зверобоя. \
		Винтовка Зверобоя - это трехзарядное дальнобойное баллистическое оружие. \
		Выстрелы крайне мощны, но если стрелять с близкой дистанции \
		или по неодушевленным объектам, урон заметно снизится. Если же стрелять по врагам вдали, \
		то выстрел станет гораздо смертоноснее, а пуля застрянет в теле жертвы."
	gain_text = "Я встретил старика, что торговал в антикварном магазине. На одной из пыльных полок лежало очень необычное оружие. \
		В тот раз я не смог его купить. Но продавец показал, как изготавливали это оружие многие годы назад."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/furious_steel,
		/datum/heretic_knowledge/spell/entropic_plume,
		/datum/heretic_knowledge/rifle_ammo,
	)
	required_atoms = list(
		/obj/item/gun/ballistic = 1,
		/obj/item/stack/sheet/animalhide = 1,
		/obj/item/stack/sheet/mineral/wood = 1,
		/obj/item/camera = 1,
	)
	result_atoms = list(/obj/item/gun/ballistic/rifle/lionhunter)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/rifle_ammo
	name = "Патроны Винтовки Зверобоя"
	desc = "Позволяет трансмутировать 3 пулевые гильзы (использованные или нет) любого калибра, \
	со шкурой животного, чтобы создать дополнительный магазин для Винтовки Зверобоя."
	gain_text = "В комплекте с оружием было три железных шарика, используемые в качестве пуль. \
		Они были довольно эффективны, особенно для простого железа, но их мало. Слишком мало \
		Ни одна другая пуля не могла заменить их. Винтовка стреляла исключительно железными шариками."
	required_atoms = list(
		/obj/item/stack/sheet/animalhide = 1,
		/obj/item/ammo_casing = 3,
	)
	result_atoms = list(/obj/item/ammo_box/a762/lionhunter)
	cost = 1
	route = PATH_SIDE
	/// A list of calibers that the ritual will deny. Only ballistic calibers are allowed.
	var/static/list/caliber_blacklist = list(
		CALIBER_LASER,
		CALIBER_ENERGY,
		CALIBER_FOAM,
		CALIBER_ARROW,
		CALIBER_HARPOON,
		CALIBER_HOOK,
	)

/datum/heretic_knowledge/rifle_ammo/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	for(var/obj/item/ammo_casing/casing in atoms)
		if(!(casing.caliber in caliber_blacklist))
			continue

		// Remove any casings in the caliber_blacklist list from atoms
		atoms -= casing

	// We removed any invalid casings from the atoms list,
	// return to allow the ritual to fill out selected atoms with the new list
	return TRUE
