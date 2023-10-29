/datum/job/station_engineer/specialist
	title = JOB_SPECIALIST
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY

	outfit = /datum/outfit/job/specialist

	skills = list(/datum/skill/engineering = SKILL_EXP_EXPERT)
	minimal_skills = list(/datum/skill/engineering = SKILL_EXP_EXPERT)

	paycheck = PAYCHECK_HARD
	metalocked = TRUE

/datum/id_trim/job/specialist
	assignment = JOB_SPECIALIST
	trim_state = "trim_specialist"
	full_access = list(ACCESS_BRIG_SPECIALIST, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MECH_MEDICAL, ACCESS_WEAPONS,
						ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS, ACCESS_MECH_ENGINE, ACCESS_AUX_BASE,
						ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS, ACCESS_TCOMSAT, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_BRIG_SPECIALIST, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MECH_MEDICAL, ACCESS_WEAPONS,
						ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS, ACCESS_MECH_ENGINE, ACCESS_AUX_BASE,
						ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_TCOMSAT, ACCESS_MINERAL_STOREROOM)
	config_job = "specialist"
	template_access = list(ACCESS_CAPTAIN, ACCESS_CE, ACCESS_CHANGE_IDS)

/datum/outfit/job/specialist
	name = "Специалист"
	jobtype = /datum/job/station_engineer/specialist

	head = /obj/item/clothing/head/helmet/specialist
	belt = /obj/item/storage/belt/specialist
	ears = /obj/item/radio/headset/headset_eng_sec/alt
	uniform = /obj/item/clothing/under/rank/engineering/specialist
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor/vest/specialist
	suit_store = /obj/item/tactical_recharger/disabler

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/survival/engineer
	pda_slot = ITEM_SLOT_LPOCKET

	r_pocket = /obj/item/restraints/handcuffs
	l_pocket = /obj/item/modular_computer/tablet/pda/specialist

	implants = list(/obj/item/implant/mindshield)

	skillchips = list(/obj/item/skillchip/job/engineer)

	id_trim = /datum/id_trim/job/specialist

/datum/outfit/job/specialist/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_DIAGNOSTIC_ADVANCED]
	hud.show_to(H)
	ADD_TRAIT(H, TRAIT_DIAGNOSTIC_HUD, ORGAN_TRAIT)

/obj/item/storage/bag/garment/specialist
	name = "сумка для одежды специалиста"

/obj/item/storage/bag/garment/specialist/PopulateContents()
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/head/helmet/sec(src)
	new /obj/item/clothing/under/rank/engineering/specialist(src)
	new /obj/item/clothing/under/rank/engineering/specialist/skirt(src)
	new /obj/item/clothing/suit/armor/vest/specialist/empty(src)
	new /obj/item/clothing/head/helmet/specialist(src)
	new /obj/item/storage/belt/specialist/empty(src)
	new /obj/item/clothing/shoes/jackboots/sec(src)
	new /obj/item/radio/headset/headset_eng_sec(src)
	new /obj/item/radio/headset/headset_eng_sec/alt(src)
	new /obj/item/radio/headset/headset_sec(src)
	new /obj/item/radio/headset/headset_sec/alt(src)

// Шкаф Специалиста
/obj/structure/closet/secure_closet/security/specialist
	name = "шкаф специалиста"
	req_access = list(ACCESS_BRIG_SPECIALIST)
	icon = 'white/Feline/icons/closet.dmi'
	icon_state = "specialist"

/obj/structure/closet/secure_closet/security/specialist/PopulateContents()
	new /obj/item/storage/bag/garment/specialist(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/storage/box/barbed_wire(src)
	new /obj/item/restraints/legcuffs/beartrap(src)
	new /obj/item/restraints/legcuffs/beartrap(src)
	new /obj/item/door_seal/sb(src)
	new /obj/item/door_seal/sb(src)
	new /obj/item/flasher_portable_item(src)
	new /obj/item/flasher_portable_item(src)
	new /obj/item/quikdeploy/cade/plasteel(src)
	new /obj/item/quikdeploy/cade/plasteel(src)
	new /obj/item/recharger_item(src)

// Усмиритель специалиста
/obj/item/gun/energy/e_gun/suppressor
	name = "подавитель"
	desc = "Прототипная разработка нового усмирителя. К основному режиму стрельбы добавлена возможность вести огонь ослабленными ионными зарядами. К сожалению после модификации размеры устройства не позволяют переносить его в кобуре или сумке."
	icon = 'white/Feline/icons/suppressor.dmi'
	icon_state = "suppressor"
	w_class = WEIGHT_CLASS_BULKY
	force = 12
	cell_type = /obj/item/stock_parts/cell/weapon/cell_3000
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/e_150, /obj/item/ammo_casing/energy/ion/e_300) // 20 дисаблеров 10 ионок
	charge_sections = 3
	ammo_x_offset = 5
	toggle_sound = 'white/Feline/sounds/suppressor_toggle.ogg'

/obj/item/gun/energy/e_gun/suppressor/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'white/Feline/icons/suppressor.dmi', \
		light_overlay = "suppressor_light")
//		overlay_x = 19,
//		overlay_y = 13)

// Сумка специалиста
/obj/item/storage/belt/specialist
	name = "поясная сумка специалиста"
	desc = "Дополнительная сумка для хранения оборонительных средств полевого развертывания."
	icon = 'white/Feline/icons/engi_items.dmi'
	icon_state = "sapper"
	inhand_icon_state = "security"
	worn_icon_state = "sapper"
	content_overlays = FALSE
	w_class = WEIGHT_CLASS_BULKY
	var/loaded = TRUE

/obj/item/storage/belt/specialist/empty
	loaded = FALSE

/obj/item/storage/belt/specialist/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	atom_storage.max_slots = 8
	atom_storage.screen_max_columns = 8
	atom_storage.max_total_storage = 24
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY
	atom_storage.set_holdable(list(
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/ballistic/revolver,
		/obj/item/gun/energy/e_gun/mini,
		/obj/item/kitchen/knife,
		/obj/item/ammo_box,
		/obj/item/grenade,
		/obj/item/forcefield_projector,
		/obj/item/shield/riot/tele,
		/obj/item/clothing/glasses,
		/obj/item/clothing/gloves,
		/obj/item/door_seal/sb,
		/obj/item/flasher_portable_item,
		/obj/item/quikdeploy,
		/obj/item/restraints,
		/obj/item/assembly/flash
		))

/obj/item/storage/belt/specialist/PopulateContents()
	if(loaded)
		new /obj/item/door_seal/sb(src)
		new /obj/item/door_seal/sb(src)
		new /obj/item/flasher_portable_item(src)
		new /obj/item/quikdeploy/cade/plasteel(src)
		new /obj/item/restraints/legcuffs/beartrap(src)
		new /obj/item/grenade/barrier(src)
		new /obj/item/grenade/flashbang(src)
		new /obj/item/assembly/flash(src)
		update_appearance()

// 	Одежда
/obj/item/clothing/head/helmet/specialist
	name = "шлем специалиста"
	desc = "Первое чему учатся солдаты в окопах это то, что если уж ты решил высунуть свою голову из надежного укрытия, то делай это в каске."
	icon = 'white/Feline/icons/specialist_head.dmi'
	icon_state = "helmet_specialist"
	worn_icon = 'white/Feline/icons/specialist_head_body.dmi'
	inhand_icon_state = "helmetalt"
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 70, BIO = 30, RAD = 90, FIRE = 90, ACID = 30, WOUND = 20)
	can_flashlight = TRUE
/*
/obj/item/clothing/head/helmet/specialist/Initialize(mapload)
	set_attached_light(new /obj/item/flashlight/seclite)
	update_helmlight()
	update_icon()
	. = ..()
*/

/obj/item/clothing/under/rank/engineering/specialist
	name = "комбинезон специалиста"
	desc = "Он изготовлен из специального волокна, которое немного защищает от техногенных опасностей."
	icon = 'white/Feline/icons/specialist_under.dmi'
	icon_state = "specialist"
	worn_icon = 'white/Feline/icons/specialist_under_body.dmi'
	inhand_icon_state = "w_suit"
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 10, FIRE = 50, ACID = 0)
	alt_covers_chest = TRUE
	can_adjust = FALSE
	max_integrity = 500
	limb_integrity = 100

/obj/item/clothing/under/rank/engineering/specialist/skirt
	name = "юбкомбинезон специалиста"
	desc = "Он изготовлен из специального волокна, которое немного защищает от техногенных опасностей."
	icon_state = "specialist_skirt"
	inhand_icon_state = "w_suit"
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE
