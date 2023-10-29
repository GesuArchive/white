/obj/item/clothing/shoes/sneakers/mime
	name = "обутки мима"
	greyscale_colors = "#ffffff#ffffff"

/obj/item/clothing/shoes/sneakers/marisa
	desc = "A pair of magic black shoes."
	name = "magic shoes"
	worn_icon_state = "marisa"
	greyscale_colors = "#545454#ffffff"
	greyscale_config = /datum/greyscale_config/sneakers_marisa
	greyscale_config_worn = null
	strip_delay = 5
	equip_delay_other = 50
	can_be_tied = FALSE
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/shoes/combat //basic syndicate combat boots for nuke ops and mob corpses
	name = "боевые ботинки"
	desc = "Высокоскоростные ботинки с низким сопротивлением."
	icon_state = "jackboots"
	inhand_icon_state = "jackboots"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	armor = list(MELEE = 25, BULLET = 25, LASER = 25, ENERGY = 25, BOMB = 50, BIO = 90, RAD = 0, FIRE = 70, ACID = 50)
	strip_delay = 40
	resistance_flags = NONE
	lace_time = 12 SECONDS

/obj/item/clothing/shoes/combat/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/combat/sneakboots
	name = "скрытные ботинки"
	desc = "Ботинки со специальной шумоподавляющей подошвой. Были бы идеальны для скрытного проникновения, если бы не их цветовая гамма."
	icon_state = "sneakboots"
	inhand_icon_state = "sneakboots"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF |  ACID_PROOF
	clothing_traits = list(TRAIT_SILENT_FOOTSTEPS)

/obj/item/clothing/shoes/combat/swat //overpowered boots for death squads
	name = "\improper SWAT-буты"
	desc = "Высокоскоростные ботинки без сопротивления."
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 0, ACID = 0)
	clothing_flags = NOSLIP
	armor = list(MELEE = 40, BULLET = 30, LASER = 25, ENERGY = 25, BOMB = 50, BIO = 30, RAD = 30, FIRE = 90, ACID = 50)

/obj/item/clothing/shoes/sandal
	desc = "Пара довольно простых деревянных сандалий."
	name = "тапочки"
	icon_state = "wizard"
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 0.5)
	strip_delay = 5
	equip_delay_other = 50
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 10, FIRE = 0, ACID = 0)
	can_be_tied = FALSE
	species_exception = list(/datum/species/golem)

/obj/item/clothing/shoes/sandal/marisa
	desc = "Пара волшебных чёрных туфель."
	name = "магические туфли"
	resistance_flags = FIRE_PROOF |  ACID_PROOF
	species_exception = null

/obj/item/clothing/shoes/sandal/magic
	name = "магические тапочки"
	desc = "Пара тапочек, наполненных магией."
	resistance_flags = FIRE_PROOF |  ACID_PROOF

/obj/item/clothing/shoes/galoshes
	desc = "Пара желтых резиновых ботинок, предназначенных для предотвращения соскальзывания на влажных поверхностях."
	name = "галоши"
	icon_state = "galoshes"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 0, ACID = 0)
	clothing_flags = NOSLIP
	slowdown = SHOES_SLOWDOWN+1
	strip_delay = 30
	equip_delay_other = 50
	resistance_flags = NONE
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 40, ACID = 75)
	can_be_bloody = FALSE
	custom_price = PAYCHECK_EASY * 3
	can_be_tied = FALSE

/obj/item/clothing/shoes/galoshes/dry
	name = "абсорбирующие галоши"
	desc = "Пара оранжевых резиновых ботинок, предназначенных для предотвращения соскальзывания на влажных поверхностях, а также для их сушки."
	icon_state = "galoshes_dry"

/obj/item/clothing/shoes/galoshes/dry/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_SHOES_STEP_ACTION, PROC_REF(on_step))

/obj/item/clothing/shoes/galoshes/dry/proc/on_step()
	SIGNAL_HANDLER

	var/turf/open/t_loc = get_turf(src)
	SEND_SIGNAL(t_loc, COMSIG_TURF_MAKE_DRY, TURF_WET_WATER, TRUE, INFINITY)

/obj/item/clothing/shoes/clown_shoes
	desc = "Стандартные шутничающие ботинки клоунады для клоунады. Черт, они огромные! Удерживая нажатой клавишу Ctrl, переключайте воздушные демпферы."
	name = "обутки клоуна"
	icon_state = "clown"
	inhand_icon_state = "clown_shoes"
	slowdown = SHOES_SLOWDOWN+1
	var/enabled_waddle = TRUE
	lace_time = 20 SECONDS // how the hell do these laces even work??
	species_exception = list(/datum/species/golem/bananium)

/obj/item/clothing/shoes/clown_shoes/Initialize(mapload)
	. = ..()
	create_storage(type = /datum/storage/pockets/shoes/clown)
	LoadComponent(/datum/component/squeak, list('sound/effects/clownstep1.ogg'=1,'sound/effects/clownstep2.ogg'=1), 50, 0, 0, 0, 0, 20, 0) //die off quick please
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CLOWN, CELL_VIRUS_TABLE_GENERIC, rand(2,3), 0)

/obj/item/clothing/shoes/clown_shoes/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_FEET)
		if(enabled_waddle)
			user.AddElement(/datum/element/waddling)
		if(user.mind && user.mind.assigned_role == JOB_CLOWN)
			SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "clownshoes", /datum/mood_event/clownshoes)

/obj/item/clothing/shoes/clown_shoes/dropped(mob/user)
	. = ..()
	user.RemoveElement(/datum/element/waddling)
	if(user.mind && user.mind.assigned_role == JOB_CLOWN)
		SEND_SIGNAL(user, COMSIG_CLEAR_MOOD_EVENT, "clownshoes")

/obj/item/clothing/shoes/clown_shoes/CtrlClick(mob/living/user)
	if(!isliving(user))
		return
	if(user.get_active_held_item() != src)
		to_chat(user, span_warning("Мне нужно держать [src] в руке чтобы это сделать!"))
		return
	if (!enabled_waddle)
		to_chat(user, span_notice("Выключил походочные демперы!"))
		enabled_waddle = TRUE
	else
		to_chat(user, span_notice("Включил походочные демперы!"))
		enabled_waddle = FALSE

/obj/item/clothing/shoes/clown_shoes/jester
	name = "обутки шута"
	desc = "Обувь придворного шута, дополненная современными скрипучими технологиями."
	icon_state = "jester_shoes"

/obj/item/clothing/shoes/jackboots
	name = "сапоги"
	desc = "Боевые ботинки NanoTrasen для боевых сценариев или боевых ситуаций. Все время в бою."
	icon_state = "jackboots"
	inhand_icon_state = "jackboots"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	strip_delay = 30
	equip_delay_other = 50
	resistance_flags = NONE
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, FIRE = 0, ACID = 0)
	can_be_tied = FALSE

/obj/item/clothing/shoes/jackboots/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/jackboots/fast
	slowdown = -1

/obj/item/clothing/shoes/jackboots/sec
	icon_state = "jackboots_sec"

/obj/item/clothing/shoes/winterboots
	name = "зимняя обувь"
	desc = "Сапоги, обшитые \"синтетическим\" мехом животных."
	icon_state = "winterboots"
	inhand_icon_state = "winterboots"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 80, FIRE = 0, ACID = 0)
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	lace_time = 8 SECONDS

/obj/item/clothing/shoes/winterboots/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/winterboots/ice_boots
	name = "ботинки ледохода"
	desc = "Пара зимней обуви со специальными захватами внизу, разработанными для предотвращения скольжения на замерзших поверхностях."
	icon_state = "iceboots"
	inhand_icon_state = "iceboots"
	clothing_flags = NOSLIP_ICE

/obj/item/clothing/shoes/workboots
	name = "рабочие ботинки"
	desc = "NanoTrasen выпускает инженерные шнуровочные рабочие ботинки для особо рабочих воротничков."
	icon_state = "workboots"
	inhand_icon_state = "jackboots"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 80, FIRE = 0, ACID = 0)
	strip_delay = 20
	equip_delay_other = 40
	lace_time = 8 SECONDS
	species_exception = list(/datum/species/golem/uranium)

/obj/item/clothing/shoes/workboots/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/workboots/mining
	name = "шахтёрские ботинки"
	desc = "Стальные горно-шахтные ботинки для горнодобывающей промышленности во взрывоопасных условиях. Отлично держит пальцы ног не раздавленными."
	icon_state = "explorer"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/shoes/cult
	name = "ботинки служителя Нар'Си"
	desc = "Пара ботинок, которые носят служители Нар'Си."
	icon_state = "cult"
	inhand_icon_state = "cult"
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	lace_time = 10 SECONDS

/obj/item/clothing/shoes/cult/alt
	name = "обутки культиста"
	icon_state = "cultalt"

/obj/item/clothing/shoes/cult/alt/ghost
	item_flags = DROPDEL

/obj/item/clothing/shoes/cult/alt/ghost/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CULT_TRAIT)

/obj/item/clothing/shoes/sneakers/cyborg
	name = "обутки киборка"
	desc = "Обувь для киборгского костюма."
	greyscale_colors = "#4e4e4e#4e4e4e"

/obj/item/clothing/shoes/laceup
	name = "шнуровочные туфли"
	desc = "Высота моды, и они предварительно отполированы!"
	icon_state = "laceups"
	equip_delay_other = 50

/obj/item/clothing/shoes/roman
	name = "римские сандалии"
	desc = "Сандалии с кожаными ремнями с пряжками на них"
	icon_state = "roman"
	inhand_icon_state = "roman"
	strip_delay = 100
	equip_delay_other = 100
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 10, FIRE = 0, ACID = 0)
	can_be_tied = FALSE

/obj/item/clothing/shoes/griffin
	name = "обувь гриффона"
	desc = "Пара костюмированных ботинок, сделанных по мотивам птичьих когтей."
	icon_state = "griffinboots"
	inhand_icon_state = "griffinboots"
	lace_time = 8 SECONDS

/obj/item/clothing/shoes/griffin/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/bhop
	name = "прыжковые ботинки"
	desc = "Специализированная пара боевых ботинок со встроенной двигательной установкой для быстрого передвижения."
	icon_state = "jetboots"
	inhand_icon_state = "jetboots"
	resistance_flags = FIRE_PROOF
	actions_types = list(/datum/action/item_action/bhop)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, FIRE = 0, ACID = 0)
	strip_delay = 30
	var/jumpdistance = 5 //-1 from to see the actual distance, e.g 4 goes over 3 tiles
	var/jumpspeed = 3
	var/recharging_rate = 60 //default 6 seconds between each dash
	var/recharging_time = 0 //time until next dash

/obj/item/clothing/shoes/bhop/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/bhop/ui_action_click(mob/user, action)
	if(!isliving(user))
		return

	if(recharging_time > world.time)
		to_chat(user, span_warning("Внутренней силовой установке ботинок всё еще требуется перезарядка!"))
		return

	var/atom/target = get_edge_target_turf(user, user.dir) //gets the user's direction

	if (user.throw_at(target, jumpdistance, jumpspeed, spin = FALSE, diagonals_first = TRUE))
		playsound(src, 'sound/effects/stealthoff.ogg', 50, TRUE, TRUE)
		user.visible_message(span_warning("[usr] взлетает в воздух!"))
		recharging_time = world.time + recharging_rate
	else
		to_chat(user, span_warning("Что-то мешает мне взлететь!"))

/obj/item/clothing/shoes/bhop/rocket
	name = "rocket boots"
	desc = "Very special boots with built-in rocket thrusters! SHAZBOT!"
	icon_state = "rocketboots"
	inhand_icon_state = "rocketboots"
	actions_types = list(/datum/action/item_action/bhop/brocket)
	jumpdistance = 20 //great for throwing yourself into walls and people at high speeds
	jumpspeed = 5

/obj/item/clothing/shoes/singery
	name = "желтые ботинки артиста"
	desc = "Эти сапоги были сделаны для танцев."
	icon_state = "ysing"
	equip_delay_other = 50

/obj/item/clothing/shoes/singerb
	name = "синие ботинки артиста"
	desc = "Эти сапоги были сделаны для танцев."
	icon_state = "bsing"
	equip_delay_other = 50

/obj/item/clothing/shoes/bronze
	name = "латунные ботинки"
	desc = "Гигантская, неуклюжая пара туфель, грубо сделанных из латуни. Зачем кому-то их носить?"
	icon = 'icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "clockwork_treads"
	can_be_tied = FALSE

/obj/item/clothing/shoes/bronze/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/machines/clockcult/integration_cog_install.ogg' = 1, 'sound/magic/clockwork/fellowship_armory.ogg' = 1), 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

/obj/item/clothing/shoes/wheelys
	name = "Вилли-Хилс"
	desc = "Использует запатентованную технологию выдвижных колес. Никогда не жертвуйте скоростью ради стиля - не то, чтобы это давало много и того, и другого." //Thanks Fel
	worn_icon_state = "wheelys"
	greyscale_colors = "#545454#ffffff"
	icon_state = "sneakers"
	greyscale_config = /datum/greyscale_config/sneakers_wheelys
	inhand_icon_state = "wheelys"
	worn_icon = 'icons/mob/large-worn-icons/64x64/feet.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	clothing_flags = LARGE_WORN_ICON
	actions_types = list(/datum/action/item_action/wheelys)
	///False means wheels are not popped out
	var/wheelToggle = FALSE
	///The vehicle associated with the shoes
	var/obj/vehicle/ridden/scooter/skateboard/wheelys/wheels = /obj/vehicle/ridden/scooter/skateboard/wheelys

/obj/item/clothing/shoes/wheelys/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	wheels = new wheels(null)
	wheels.link_shoes(src)

/obj/item/clothing/shoes/wheelys/ui_action_click(mob/user, action)
	if(!isliving(user))
		return
	if(!istype(user.get_item_by_slot(ITEM_SLOT_FEET), /obj/item/clothing/shoes/wheelys))
		to_chat(user, span_warning("Стоит надеть вилли-хилс чтобы их использовать!"))
		return
	if(!(wheels.is_occupant(user)))
		wheelToggle = FALSE
	if(wheelToggle)
		wheels.unbuckle_mob(user)
		wheelToggle = FALSE
		return
	wheels.forceMove(get_turf(user))
	wheels.buckle_mob(user)
	wheelToggle = TRUE

/obj/item/clothing/shoes/wheelys/dropped(mob/user)
	if(wheelToggle)
		wheels.unbuckle_mob(user)
		wheelToggle = FALSE
	..()

/obj/item/clothing/shoes/wheelys/proc/toggle_wheels(status)
	if (status)
		worn_icon_state = "[initial(worn_icon_state)]-on"
	else
		worn_icon_state = "[initial(worn_icon_state)]"
	playsound(src, 'sound/weapons/tap.ogg', 10, TRUE)
	update_icon()

/obj/item/clothing/shoes/wheelys/Destroy()
	QDEL_NULL(wheels)
	. = ..()

/obj/item/clothing/shoes/wheelys/rollerskates
	name = "роликовые коньки"
	desc = "Пара роликовых коньков марки EightO. Колеса убираются, но слишком громоздкие чтобы ходить."
	icon_state = "rollerskates"
	greyscale_colors = null
	greyscale_config = null
	worn_icon_state = "rollerskates"
	slowdown = SHOES_SLOWDOWN+1
	wheels = /obj/vehicle/ridden/scooter/skateboard/wheelys/rollerskates
	custom_premium_price = PAYCHECK_EASY * 5
	custom_price = PAYCHECK_EASY * 5

/obj/item/clothing/shoes/wheelys/skishoes
	name = "лыжные ботинки"
	desc = "Пара ботинок со складными лыжами! Очень удобна для передвижения по снежной местности."
	icon_state = "skishoes"
	greyscale_colors = null
	greyscale_config = null
	worn_icon_state = "skishoes"
	slowdown = SHOES_SLOWDOWN+1
	wheels = /obj/vehicle/ridden/scooter/skateboard/wheelys/skishoes
	custom_premium_price = PAYCHECK_EASY * 1.6
	custom_price = PAYCHECK_EASY * 1.6

/obj/item/clothing/shoes/kindle_kicks
	name = "Kindle Kicks"
	desc = "Они обязательно зажгут в тебе что-нибудь, и это не детская ностальгия..."
	icon_state = "kindleKicks"
	inhand_icon_state = "kindleKicks"
	actions_types = list(/datum/action/item_action/kindle_kicks)
	light_system = MOVABLE_LIGHT
	light_range = 2
	light_power = 3
	light_on = FALSE
	var/lightCycle = 0
	var/active = FALSE


/obj/item/clothing/shoes/kindle_kicks/ui_action_click(mob/user, action)
	if(active)
		return
	active = TRUE
	set_light_color(rgb(rand(0, 255), rand(0, 255), rand(0, 255)))
	set_light_on(active)
	addtimer(CALLBACK(src, PROC_REF(lightUp)), 0.5 SECONDS)

/obj/item/clothing/shoes/kindle_kicks/proc/lightUp(mob/user)
	if(lightCycle < 15)
		set_light_color(rgb(rand(0, 255), rand(0, 255), rand(0, 255)))
		lightCycle++
		addtimer(CALLBACK(src, PROC_REF(lightUp)), 0.5 SECONDS)
	else
		lightCycle = 0
		active = FALSE
		set_light_on(active)

/obj/item/clothing/shoes/russian
	name = "кирзачи"
	desc = "Древние военные ботинки."
	icon_state = "rus_shoes"
	inhand_icon_state = "rus_shoes"
	lace_time = 8 SECONDS

/obj/item/clothing/shoes/russian/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/cowboy
	name = "ковбойские ботинки"
	desc = "Небольшая наклейка дает вам знать, что они были проверены на наличие змей. Неясно, как давно проводилась проверка..."
	icon_state = "cowboy_brown"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, FIRE = 0, ACID = 0)
	custom_price = PAYCHECK_EASY
	var/list/occupants = list()
	var/max_occupants = 4
	can_be_tied = FALSE

/obj/item/clothing/shoes/cowboy/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/shoes)

	if(prob(2))
		var/mob/living/simple_animal/hostile/retaliate/poison/snake/bootsnake = new/mob/living/simple_animal/hostile/retaliate/poison/snake(src)
		occupants += bootsnake


/obj/item/clothing/shoes/cowboy/equipped(mob/living/carbon/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_FEET)
		for(var/mob/living/occupant in occupants)
			occupant.forceMove(user.drop_location())
			user.visible_message(span_warning("[user] recoils as something slithers out of [src].") , span_userdanger("You feel a sudden stabbing pain in your [pick("foot", "toe", "ankle")]!"))
			user.Knockdown(20) //Is one second paralyze better here? I feel you would fall on your ass in some fashion.
			user.apply_damage(5, BRUTE, pick(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
			if(istype(occupant, /mob/living/simple_animal/hostile/retaliate/poison))
				user.reagents.add_reagent(/datum/reagent/toxin, 7)
		occupants.Cut()

/obj/item/clothing/shoes/cowboy/MouseDrop_T(mob/living/target, mob/living/user)
	. = ..()
	if(!(user.mobility_flags & MOBILITY_USE) || user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) || !Adjacent(user) || !user.Adjacent(target) || target.stat == DEAD)
		return
	if(occupants.len >= max_occupants)
		to_chat(user, span_warning("[capitalize(src.name)] заполнены!"))
		return
	if(istype(target, /mob/living/simple_animal/hostile/retaliate/poison/snake) || istype(target, /mob/living/simple_animal/hostile/headcrab) || istype(target, /mob/living/carbon/alien/larva))
		occupants += target
		target.forceMove(src)
		to_chat(user, span_notice("[target] скользит в [src]."))

/obj/item/clothing/shoes/cowboy/container_resist_act(mob/living/user)
	if(!do_after(user, 10, target = user))
		return
	user.forceMove(user.drop_location())
	occupants -= user

/obj/item/clothing/shoes/cowboy/white
	name = "белые ковбойские сапоги"
	icon_state = "cowboy_white"

/obj/item/clothing/shoes/cowboy/black
	name = "чёрные ковбойские сапоги"
	desc = "У меня такое чувство, что кто-то мог быть повешен в этих ботинках."
	icon_state = "cowboy_black"

/obj/item/clothing/shoes/cowboy/fancy
	name = "сапоги Билтона Уэнглера"
	desc = "Пара аутентичных ботинок высокой моды из Японифорнии. Ты сомневаешься, что они когда-либо были близки со скотом."
	icon_state = "cowboy_fancy"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 95, FIRE = 0, ACID = 0)

/obj/item/clothing/shoes/cowboy/lizard
	name = "сапоги из кожи ящера"
	desc = "Изнутри ботинок можно услышать слабое шипение; надеешься, что это просто скорбный призрак."
	icon_state = "lizardboots_green"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, RAD = 0, FIRE = 40, ACID = 0) //lizards like to stay warm

/obj/item/clothing/shoes/cowboy/lizard/masterwork
	name = "облегающие сапоги из кожи ящера"
	desc = "Пара мастерски изготовленных кожаных ботинок ящерицы. Наконец-то отличное приложение для самых беспокойных жителей станции."
	icon_state = "lizardboots_blue"

/obj/effect/spawner/lootdrop/lizardboots
	name = "random lizard boot quality"
	desc = "Which ever gets picked, the lizard race loses"
	icon = 'icons/obj/clothing/shoes.dmi'
	icon_state = "lizardboots_green"
	loot = list(
		/obj/item/clothing/shoes/cowboy/lizard = 7,
		/obj/item/clothing/shoes/cowboy/lizard/masterwork = 1)

/obj/item/clothing/shoes/cookflops
	desc = "Все эти разговоры об антагах, грейтайде и гриферах.... Я просто хочу жарить на гриле, ради Бога!"
	name = "тапочки грильмена"
	icon_state = "cookflops"
	can_be_tied = FALSE
	species_exception = list(/datum/species/golem)

/obj/item/clothing/shoes/yakuza
	name = "обувь клана тодзё"
	desc = "Стальной носок устрашает."
	icon_state = "MajimaShoes"
	inhand_icon_state = "MajimaShoes_worn"

/obj/item/clothing/shoes/jackbros
	name = "frosty boots"
	desc = "For when you're stepping on up to the plate."
	icon_state = "JackFrostShoes"
	inhand_icon_state = "JackFrostShoes_worn"

/obj/item/clothing/shoes/swagshoes
	name = "swag shoes"
	desc = "They got me for my foams!"
	icon_state = "SwagShoes"
	inhand_icon_state = "SwagShoes"

/obj/item/clothing/shoes/phantom
	name = "phantom shoes"
	desc = "Excellent for when you need to do cool flashy flips."
	icon_state = "phantom_shoes"
	inhand_icon_state = "phantom_shoes"

/obj/item/clothing/shoes/saints
	name = "saints sneakers"
	desc = "Officially branded Saints sneakers. Incredibly valuable!"
	icon_state = "saints_shoes"
	inhand_icon_state = "saints_shoes"

/obj/item/clothing/shoes/morningstar
	name = "morningstar boots"
	desc = "The most expensive boots on this station. Wearing them dropped the value by about 50%."
	icon_state = "morningstar_shoes"
	inhand_icon_state = "morningstar_shoes"

/obj/item/clothing/shoes/deckers
	name = "deckers rollerskates"
	desc = "t3h c00L3st sh03z j00'LL 3v3r f1nd."
	icon_state = "decker_shoes"
	inhand_icon_state = "decker_shoes"

/obj/item/clothing/shoes/sybil_slickers
	name = "sybil slickers shoes"
	desc = "FOOTBALL! YEAH!"
	icon_state = "sneakers_blue"
	inhand_icon_state = "sneakers_blue"

/obj/item/clothing/shoes/basil_boys
	name = "basil boys shoes"
	desc = "FOOTBALL! YEAH!"
	icon_state = "sneakers_red"
	inhand_icon_state = "sneakers_red"

/obj/item/clothing/shoes/discoshoes
	name = "green lizardskin shoes"
	desc = "They may have lost some of their lustre over the years, but these green lizardskin shoes fit you perfectly."
	icon_state = "lizardskin_shoes"
	inhand_icon_state = "lizardskin_shoes"

/obj/item/clothing/shoes/kim
	name = "aerostatic boots"
	desc = "A crisp, clean set of boots for working long hours on the beat."
	icon_state = "aerostatic_boots"
	inhand_icon_state = "aerostatic_boots"

/obj/item/clothing/shoes/leetball
	name = "ботинки футболиста"
	desc = "Специализированная пара спортивных ботинок предназначенных для игры в профессиональный футбол."
	icon_state = "leetball"
	inhand_icon_state = "leetball"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	actions_types = list(/datum/action/item_action/leetball)
	armor = list(MELEE = 5, BULLET = 5, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, FIRE = 0, ACID = 0)
	strip_delay = 30
	COOLDOWN_DECLARE(recharging_time)

/obj/item/clothing/shoes/leetball/ui_action_click(mob/user, action)
	if(!isliving(user))
		return

	if(!COOLDOWN_FINISHED(src, recharging_time))
		to_chat(user, "<span class='warning'>Надо подождать немного!</span>")
		return

	var/atom/movable/throw_thing = user.get_active_held_item()
	if(!throw_thing)
		var/turf/T = get_step(user, user.dir)
		for(var/atom/movable/AM in T)
			if(isobj(AM) && ismob(AM))
				continue
			throw_thing = AM

	if(throw_thing && throw_thing.throw_at(get_edge_target_turf(user, user.dir), 15, 5, spin = TRUE, diagonals_first = TRUE))
		playsound(src, 'sound/weapons/resonator_blast.ogg', 50, TRUE, TRUE)
		user.visible_message("<span class='warning'>[user] пинает [throw_thing]!</span>")
		COOLDOWN_START(src, recharging_time, 5 SECONDS)
	else
		to_chat(user, "<span class='warning'>Нечего пинать!</span>")
