/obj/vehicle/sealed/mecha/working/ripley/buran
	desc = "Гарантия тоталитарной власти. Держится на духовных скрепах."
	name = "APLU MK-IV \"Буран\""
	icon = 'white/valtos/icons/mecha.dmi'
	icon_state = "buran"
	max_temperature = 65000
	max_integrity = 150
	deflect_chance = 25
	fast_pressure_step_in = 2 //step_in while in low pressure conditions
	slow_pressure_step_in = 4 //step_in while in normal pressure conditions
	movedelay = 4
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	lights_power = 7
	armor = list("melee" = 80, "bullet" = 60, "laser" = 60, "energy" = 60, "bomb" = 90, "bio" = 0, "rad" = 90, "fire" = 100, "acid" = 100)
	max_equip = 3
	wreckage = /obj/structure/mecha_wreckage/ripley/buran
	enclosed = TRUE
	enter_delay = 40
	silicon_icon_state = null
	opacity = TRUE

/obj/vehicle/sealed/mecha/working/ripley/buran/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	ME.attach(src)

/obj/structure/mecha_wreckage/ripley/buran
	name = "Ошмётки Бурана"
	icon_state = "buran-broken"

/obj/machinery/porta_turret/armory
	name = "armory defense turret"
	desc = "An energy blaster auto-turret."
	installation = null
	stun_projectile = /obj/projectile/energy/electrode
	stun_projectile_sound = 'sound/weapons/taser.ogg'
	lethal_projectile = /obj/projectile/beam/laser/heavylaser/penetrator
	lethal_projectile_sound = 'sound/weapons/lasercannonfire.ogg'
	mode = TURRET_LETHAL
	turret_flags = TURRET_FLAG_SHOOT_UNSHIELDED | TURRET_FLAG_SHOOT_CRIMINALS | TURRET_FLAG_AUTH_WEAPONS
	//stun_all = 1
	always_up = 1
	scan_range = 9
	use_power = NO_POWER_USE
	faction = list("silicon","turret")

/obj/machinery/porta_turret/armory/ComponentInitialize()
	. = ..()
	AddComponent(/datum/element/empprotection, EMP_PROTECT_SELF | EMP_PROTECT_WIRES)

/obj/machinery/porta_turret/armory/setup()
	return

/obj/machinery/porta_turret/armory/interact(mob/user)
	return

/obj/projectile/beam/laser/heavylaser/penetrator
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB))
	range = 12

/obj/item/melee/classic_baton/dildon
	name = "дилдо"
	desc = "При неправильном обращении окажется у меня в жопе."
	icon = 'white/valtos/icons/melee.dmi'
	icon_state = "dildo"
	inhand_icon_state = "dildo"
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 10
	w_class = WEIGHT_CLASS_NORMAL
	cooldown = 40

/mob/living
	var/headstamp //надпись на башне

/obj/item/stock_parts/capacitor/noneuclid
	name = "неевклидный конденсатор"
	desc = "Емкостной конденсатор используется в конструкции самых разных устройств."
	icon_state = "quadratic_capacitor"
	rating = 5
	custom_materials = list(/datum/material/iron=1, /datum/material/glass=1)
	color = "#ff3333"

/obj/item/stock_parts/scanning_module/noneuclid
	name = "неевклидный сканирующий модуль"
	desc = "Компактный неевклидный сканирующий модуль сверхвысокого разрешения, используемый в конструкции некоторых устройств."
	icon_state = "triphasic_scan_module"
	rating = 5
	custom_materials = list(/datum/material/iron=1, /datum/material/glass=1)
	color = "#ff3333"

/obj/item/stock_parts/manipulator/noneuclid
	name = "неевклидовый-манипулятор"
	desc = "Крошечный манипулятор, используемый при создании некоторых устройств."
	icon_state = "femto_mani"
	rating = 5
	custom_materials = list(/datum/material/iron=1)
	color = "#ff3333"

/obj/item/stock_parts/micro_laser/noneuclid
	name = "неевклидный микролазер"
	icon_state = "quadultra_micro_laser"
	desc = "Крошечный лазер, используемый в некоторых устройствах."
	rating = 5
	custom_materials = list(/datum/material/iron=1, /datum/material/glass=1)
	color = "#ff3333"

/obj/item/stock_parts/matter_bin/noneuclid
	name = "неевклидовый контейнер материалов"
	desc = "Контейнер, предназначенный для хранения неевклидного вещества, ожидающего реконструкции."
	icon_state = "bluespace_matter_bin"
	rating = 5
	custom_materials = list(/datum/material/iron=1)
	color = "#ff3333"

/obj/item/storage/part_replacer/bluespace/tier5
	color = "#ff3333"
	w_class = WEIGHT_CLASS_TINY

/obj/item/storage/part_replacer/bluespace/tier5/PopulateContents()
	for(var/i in 1 to 50)
		new /obj/item/stock_parts/capacitor/noneuclid(src)
		new /obj/item/stock_parts/scanning_module/noneuclid(src)
		new /obj/item/stock_parts/manipulator/noneuclid(src)
		new /obj/item/stock_parts/micro_laser/noneuclid(src)
		new /obj/item/stock_parts/matter_bin/noneuclid(src)

/datum/techweb_node/noneuclidic
	id = "noneuclidic"
	display_name = "Non-Euclid Research"
	description = "Experiments in the field of bluespace technologies led to the discovery of non-Euclidean spaces."
	prereq_ids = list("bluespace_travel", "practical_bluespace", "bluespace_storage")
	design_ids = list("noneuclid_matter_bin", "noneuclid_mani", "noneuclid_scanning", "noneuclid_capacitor", "noneuclid_micro_laser")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 250000)
	required_experiments = list(/datum/experiment/explosion/maxcap)
	discount_experiments = list(/datum/experiment/explosion/medium = 500000)

/datum/design/noneuclid_matter_bin
	name = "Noneuclid Matter Bin"
	desc = "A stock part used in the construction of various devices."
	id = "noneuclid_matter_bin"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2500, /datum/material/diamond = 1000, /datum/material/bluespace = 1000)
	build_path = /obj/item/stock_parts/matter_bin/noneuclid
	category = list("Запчасти оборудования")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noneuclid_mani
	name = "Noneuclid Manipulator"
	desc = "A stock part used in the construction of various devices."
	id = "noneuclid_mani"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/diamond = 300, /datum/material/titanium = 300)
	build_path = /obj/item/stock_parts/manipulator/noneuclid
	category = list("Запчасти оборудования")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noneuclid_scanning
	name = "Noneuclid Scanning Module"
	desc = "A stock part used in the construction of various devices."
	id = "noneuclid_scanning"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000, /datum/material/diamond = 300, /datum/material/bluespace = 300)
	build_path = /obj/item/stock_parts/scanning_module/noneuclid
	category = list("Запчасти оборудования")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noneuclid_capacitor
	name = "Noneuclid Capacitor"
	desc = "A stock part used in the construction of various devices."
	id = "noneuclid_capacitor"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000, /datum/material/gold = 1000, /datum/material/diamond = 100)
	build_path = /obj/item/stock_parts/capacitor/noneuclid
	category = list("Запчасти оборудования")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noneuclid_micro_laser
	name = "Noneuclid Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	id = "noneuclid_micro_laser"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000, /datum/material/uranium = 1000, /datum/material/diamond = 600)
	build_path = /obj/item/stock_parts/micro_laser/noneuclid
	category = list("Запчасти оборудования")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/emote/living/ask_to_stop
	key = "ats"
	ru_name = "ОСТАНОВИТЬ"
	key_third_person = "ats"
	message = "жестом просит остановиться!"
	emote_type = EMOTE_VISIBLE|EMOTE_AUDIBLE

/datum/emote/living/ask_to_stop/get_sound(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.mind || !H.mind.miming)
			if(user.gender == FEMALE)
				return pick('white/valtos/sounds/emotes/hey_female_1.ogg',\
							'white/valtos/sounds/emotes/hey_female_2.ogg')
			else
				return pick('white/valtos/sounds/emotes/hey_male_1.ogg',\
							'white/valtos/sounds/emotes/hey_male_2.ogg')
