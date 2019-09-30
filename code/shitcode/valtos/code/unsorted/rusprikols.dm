GLOBAL_LIST_INIT(gachisounds, list(
	'code/shitcode/valtos/sounds/gachi/ass_we_can.ogg',
	'code/shitcode/valtos/sounds/gachi/come_on.ogg',
	'code/shitcode/valtos/sounds/gachi/do_you_like_what_you_see.ogg',
	'code/shitcode/valtos/sounds/gachi/fuck_you.ogg',
	'code/shitcode/valtos/sounds/gachi/fuck_you_leather_man.ogg',
	'code/shitcode/valtos/sounds/gachi/fucking_cumming.ogg',
	'code/shitcode/valtos/sounds/gachi/i_dont_do_anal.ogg',
	'code/shitcode/valtos/sounds/gachi/its_so_fucking_deep.ogg',
	'code/shitcode/valtos/sounds/gachi/penetration_1.ogg',
	'code/shitcode/valtos/sounds/gachi/penetration_2.ogg',
	'code/shitcode/valtos/sounds/gachi/wrong_door.ogg',
	'code/shitcode/valtos/sounds/gachi/you_like_that.ogg'
))

/obj/item/clothing/under/rank/omon
	name = "omon jumpsuit"
	desc = "A tactical security jumpsuit for Russian officers."
	mob_overlay_icon = 'code/shitcode/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'code/shitcode/valtos/icons/clothing/uniforms.dmi'
	icon_state = "omon"
	item_state = "b_suit"

	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)
	strip_delay = 50
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	can_adjust = FALSE

/obj/item/clothing/under/rank/omon/green
	icon_state = "omon-2"
	item_state = "g_suit"

/obj/item/clothing/suit/armor/riot/omon
	name = "omon riot suit"
	desc = "Designed for effective extermination."
	mob_overlay_icon = 'code/shitcode/valtos/icons/clothing/mob/suit.dmi'
	icon = 'code/shitcode/valtos/icons/clothing/suits.dmi'
	icon_state = "omon_riot"

/obj/item/clothing/suit/armor/bulletproof/omon
	name = "bulletproof omon armor"
	desc = "If you wear it, then obviously you are going to kill people."
	mob_overlay_icon = 'code/shitcode/valtos/icons/clothing/mob/suit.dmi'
	icon = 'code/shitcode/valtos/icons/clothing/suits.dmi'
	icon_state = "omon_armor"

/datum/job/officer/omon
	title = "Russian Officer"
	outfit = /datum/outfit/job/security/omon

/datum/outfit/job/security/omon
	name = "Russian Officer uniform"
	jobtype = /datum/job/officer/omon

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/omon/green
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld
	suit_store = /obj/item/gun/ballistic/automatic/pistol/traumatic
	backpack_contents = list(/obj/item/melee/baton/loaded=1, /obj/item/ammo_box/magazine/traumatic=1)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/security

	implants = list(/obj/item/implant/mindshield/)

	chameleon_extras = list(/obj/item/gun/ballistic/automatic/pistol/traumatic, /obj/item/clothing/glasses/hud/security/sunglasses, /obj/item/clothing/head/helmet)

/datum/outfit/job/hos
	implants = list(/obj/item/implant/mindshield/, /obj/item/implant/krav_maga)

/datum/outfit/job/warden
	implants = list(/obj/item/implant/mindshield/)

/datum/outfit/job/security
	implants = list(/obj/item/implant/mindshield/)

/datum/job/officer/kazakh
	title = "Kazakhstan Officer"
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 28
	exp_requirements = 6000
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY,
					ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS, ACCESS_MINERAL_STOREROOM, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP,
					ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS, ACCESS_MECH_ENGINE, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION,
					ACCESS_ATMOSPHERICS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY,
					ACCESS_MINERAL_STOREROOM, ACCESS_ATMOSPHERICS, ACCESS_CONSTRUCTION, ACCESS_MECH_ENGINE, ACCESS_MINERAL_STOREROOM) // See /datum/job/officer/get_access()
	outfit = /datum/outfit/job/security/kazakh

/datum/outfit/job/security/kazakh
	name = "Kazakh Officer uniform"
	jobtype = /datum/job/officer/kazakh

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt/department/engi
	uniform = /obj/item/clothing/under/rank/engineering/atmospheric_technician
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld
	suit_store = /obj/item/gun/ballistic/automatic/pistol/traumatic
	backpack_contents = list(/obj/item/melee/classic_baton/dildon=1, /obj/item/modular_computer/tablet/preset/advanced=1, /obj/item/pipe_dispenser=1, /obj/item/ammo_box/magazine/traumatic=2)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/security

	implants = list(/obj/item/implant/mindshield/, /obj/item/implant/krav_maga)

	chameleon_extras = list(/obj/item/gun/ballistic/automatic/pistol/traumatic, /obj/item/clothing/glasses/hud/security/sunglasses, /obj/item/clothing/head/helmet)


/obj/mecha/working/ripley/buran
	desc = "Гарантия тоталитарной власти. Держится на духовных скрепах."
	name = "\improper APLU MK-IV \"Buran\""
	icon = 'code/shitcode/valtos/icons/mecha.dmi'
	icon_state = "buran"
	max_temperature = 65000
	max_integrity = 150
	deflect_chance = 25
	fast_pressure_step_in = 2 //step_in while in low pressure conditions
	slow_pressure_step_in = 4 //step_in while in normal pressure conditions
	step_in = 4
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	lights_power = 7
	armor = list("melee" = 80, "bullet" = 60, "laser" = 60, "energy" = 60, "bomb" = 90, "bio" = 0, "rad" = 90, "fire" = 100, "acid" = 100)
	max_equip = 3
	wreckage = /obj/structure/mecha_wreckage/ripley/buran
	enclosed = TRUE
	enter_delay = 40
	silicon_icon_state = null
	opacity = TRUE

/obj/mecha/working/ripley/buran/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	ME.attach(src)

/obj/structure/mecha_wreckage/ripley/buran
	name = "\improper Buran wreckage"
	icon_state = "buran-broken"

/obj/machinery/porta_turret/armory
	name = "armory defense turret"
	desc = "An energy blaster auto-turret."
	installation = null
	stun_projectile = /obj/item/projectile/energy/electrode
	stun_projectile_sound = 'sound/weapons/taser.ogg'
	lethal_projectile = /obj/item/projectile/beam/laser/heavylaser/penetrator
	lethal_projectile_sound = 'sound/weapons/lasercannonfire.ogg'
	mode = TURRET_LETHAL
	shoot_unloyal = 1
	//stun_all = 1
	auth_weapons = 1
	always_up = 1
	scan_range = 9
	use_power = NO_POWER_USE
	faction = list("silicon","turret")

/obj/machinery/porta_turret/armory/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/empprotection, EMP_PROTECT_SELF | EMP_PROTECT_WIRES)

/obj/machinery/porta_turret/armory/setup()
	return

/obj/machinery/porta_turret/armory/interact(mob/user)
	return

/obj/item/projectile/beam/laser/heavylaser/penetrator
	movement_type = FLYING | UNSTOPPABLE
	range = 12

/obj/item/melee/classic_baton/dildon
	name = "dildo"
	desc = "При неправильном обращении окажется у тебя в жопе."
	icon = 'code/shitcode/valtos/icons/melee.dmi'
	icon_state = "dildo"
	item_state = "dildo"
	lefthand_file = 'code/shitcode/valtos/icons/lefthand.dmi'
	righthand_file = 'code/shitcode/valtos/icons/righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 10
	w_class = WEIGHT_CLASS_NORMAL
	cooldown = 40

/obj/item/gun/ballistic/automatic/pistol/traumatic
	name = "\improper Enforcer T46"
	desc = "Эти штуки были взяты буквально с боем. Теперь это обыденность."
	icon = 'code/shitcode/valtos/icons/gun.dmi'
	icon_state = "enforcer"
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/traumatic
	can_suppress = TRUE
	var/boltcolor
	var/list/possible_colors = list("black", "green", "tan", "red", "grey")

/obj/item/gun/ballistic/automatic/pistol/traumatic/Initialize()
	icon_state = "enforcer_[pick(possible_colors)]"
	if (!boltcolor)
		boltcolor = pick(possible_colors)
	. = ..()

/obj/item/gun/ballistic/automatic/pistol/traumatic/update_icon()
	if (QDELETED(src))
		return
	..()
	cut_overlays()
	if (bolt_type == BOLT_TYPE_LOCKING)
		add_overlay("[icon_state]_[boltcolor]_bolt[bolt_locked ? "_locked" : ""]")
	if (suppressed)
		add_overlay("[icon_state]_supp")

/obj/item/gun/ballistic/automatic/pistol/traumatic/no_mag
	spawnwithmagazine = FALSE

/obj/item/ammo_box/magazine/traumatic
	name = "handgun traumatic magazine (9mm)"
	icon_state = "45-8"
	ammo_type = /obj/item/ammo_casing/traumatic
	caliber = "9mm"
	max_ammo = 8

/obj/item/ammo_box/magazine/traumatic/update_icon()
	..()
	if (ammo_count() >= 8)
		icon_state = "45-8"
	else
		icon_state = "45-[ammo_count()]"

/obj/item/ammo_casing/traumatic
	name = "9mm traumatic bullet casing"
	desc = "A 9mm traumatic bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/traumatic

/obj/item/projectile/bullet/traumatic
	name = "9mm traumatic bullet"
	damage = 3 //наша резина делает больно, не более
	stamina = 90

/datum/design/traumatic
	name = "9mm traumatic magazine"
	id = "traumatic"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 5000)
	build_path = /obj/item/ammo_box/magazine/traumatic
	category = list("initial", "Security")

/obj/item/gun/energy/lovegun
	name = "love gun"
	icon_state = "dildo"
	item_state = "dildo"
	icon = 'code/shitcode/valtos/icons/melee.dmi'
	desc = "Сила магии дружбы проникает в тебя, пока ты смотришь на это."
	fire_sound = 'code/shitcode/valtos/sounds/love/shot1.ogg'
	var/list/random_sound = list('code/shitcode/valtos/sounds/love/shot1.ogg',
							'code/shitcode/valtos/sounds/love/shot2.ogg',
							'code/shitcode/valtos/sounds/love/shot3.ogg',
							'code/shitcode/valtos/sounds/love/shot4.ogg',
							'code/shitcode/valtos/sounds/love/shot5.ogg',
							'code/shitcode/valtos/sounds/love/shot6.ogg',
							'code/shitcode/valtos/sounds/love/shot7.ogg',
							'code/shitcode/valtos/sounds/love/shot8.ogg',
							'code/shitcode/valtos/sounds/love/shot9.ogg')
	ammo_type = list(/obj/item/ammo_casing/energy/lovegun)
	selfcharge = 1
	burst_size = 1
	clumsy_check = 0
	item_flags = NONE

/obj/item/gun/energy/lovegun/process_chamber()
	. = ..()
	fire_sound = pick(random_sound)

/obj/item/ammo_casing/energy/lovegun
	projectile_type = /obj/item/projectile/beam/lovegun
	select_name = "lovegun"
	harmful = FALSE

/obj/item/projectile/beam/lovegun
	name = "heart"
	icon_state = "heart"
	icon = 'code/shitcode/valtos/icons/projectiles.dmi'
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 0
	speed = 3
	light_range = 2
	eyeblur = 0
	damage_type = STAMINA
	light_color = LIGHT_COLOR_PINK

/obj/item/projectile/beam/lovegun/on_hit(atom/target, blocked = FALSE)
	. = ..()
	playsound(target, pick(GLOB.gachisounds), 25, FALSE)
	new /obj/effect/temp_visual/love_heart(get_turf(target.loc))
	new /obj/effect/temp_visual/love_heart(get_turf(target.loc))
	new /obj/effect/temp_visual/love_heart(get_turf(target.loc))

/mob/living
	var/headstamp //надпись на башне

/obj/item/stock_parts/capacitor/noneuclid
	name = "noneuclid capacitor"
	desc = "An capacity capacitor used in the construction of a variety of devices."
	icon_state = "quadratic_capacitor"
	rating = 8
	materials = list(/datum/material/iron=1, /datum/material/glass=1)
	color = "#ff3333"

/obj/item/stock_parts/scanning_module/noneuclid
	name = "noneuclid scanning module"
	desc = "A compact, ultra resolution noneuclid scanning module used in the construction of certain devices."
	icon_state = "triphasic_scan_module"
	rating = 8
	materials = list(/datum/material/iron=1, /datum/material/glass=1)
	color = "#ff3333"

/obj/item/stock_parts/manipulator/noneuclid
	name = "noneuclid-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "femto_mani"
	rating = 8
	materials = list(/datum/material/iron=1)
	color = "#ff3333"

/obj/item/stock_parts/micro_laser/noneuclid
	name = "noneuclid micro-laser"
	icon_state = "quadultra_micro_laser"
	desc = "A tiny laser used in certain devices."
	rating = 8
	materials = list(/datum/material/iron=1, /datum/material/glass=1)
	color = "#ff3333"

/obj/item/stock_parts/matter_bin/noneuclid
	name = "noneuclid matter bin"
	desc = "A container designed to hold noneuclid matter awaiting reconstruction."
	icon_state = "bluespace_matter_bin"
	rating = 8
	materials = list(/datum/material/iron=1)
	color = "#ff3333"

/obj/item/storage/part_replacer/bluespace/tier8
	color = "#ff3333"
	w_class = WEIGHT_CLASS_TINY

/obj/item/storage/part_replacer/bluespace/tier8/PopulateContents()
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
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 200000)
	export_price = 100000

/datum/design/noneuclid_matter_bin
	name = "Noneuclid Matter Bin"
	desc = "A stock part used in the construction of various devices."
	id = "noneuclid_matter_bin"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2500, /datum/material/diamond = 1000, /datum/material/bluespace = 1000)
	build_path = /obj/item/stock_parts/matter_bin/noneuclid
	category = list("Stock Parts")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noneuclid_mani
	name = "Noneuclid Manipulator"
	desc = "A stock part used in the construction of various devices."
	id = "noneuclid_mani"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/diamond = 300, /datum/material/titanium = 300)
	build_path = /obj/item/stock_parts/manipulator/noneuclid
	category = list("Stock Parts")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noneuclid_scanning
	name = "Noneuclid Scanning Module"
	desc = "A stock part used in the construction of various devices."
	id = "noneuclid_scanning"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000, /datum/material/diamond = 300, /datum/material/bluespace = 300)
	build_path = /obj/item/stock_parts/scanning_module/noneuclid
	category = list("Stock Parts")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noneuclid_capacitor
	name = "Noneuclid Capacitor"
	desc = "A stock part used in the construction of various devices."
	id = "noneuclid_capacitor"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000, /datum/material/gold = 1000, /datum/material/diamond = 100)
	build_path = /obj/item/stock_parts/capacitor/noneuclid
	category = list("Stock Parts")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/noneuclid_micro_laser
	name = "Noneuclid Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	id = "noneuclid_micro_laser"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 2000, /datum/material/uranium = 1000, /datum/material/diamond = 600)
	build_path = /obj/item/stock_parts/micro_laser/noneuclid
	category = list("Stock Parts")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE
