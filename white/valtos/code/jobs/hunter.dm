/datum/job/hunter
	title = JOB_HUNTER
	department_head = list()
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "никому"
	selection_color = "#ff4040"

	exp_type = EXP_TYPE_CREW
	exp_requirements = 900

	outfit = /datum/outfit/job/hunter

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_CAR

	display_order = JOB_DISPLAY_ORDER_SHAFT_MINER
	bounty_types = CIV_JOB_MINE

	departments_list = list(
		/datum/job_department/cargo,
	)

	rpg_title = "Bosshunter"
	rpg_title_ru = "Боссхантер"

	metalocked = TRUE

/datum/outfit/job/hunter
	name = JOB_HUNTER
	jobtype = /datum/job/hunter

	belt = /obj/item/energylance
	ears = /obj/item/radio/headset/headset_cargo/mining
	shoes = /obj/item/clothing/shoes/workboots/mining
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/cargo/miner/lavaland
	suit = /obj/item/clothing/suit/space/hardsuit/berserker
	mask = /obj/item/clothing/mask/gas/explorer
	glasses = /obj/item/clothing/glasses/meson/night
	suit_store = /obj/item/tank/internals/oxygen/yellow
	l_pocket = /obj/item/reagent_containers/hypospray/medipen/survival/luxury
	r_pocket = /obj/item/modular_computer/tablet/pda/hunter
	backpack_contents = list(
		/obj/item/flashlight/seclite = 1,
		/obj/item/mining_voucher = 1,
		/obj/item/t_scanner/adv_mining_scanner = 1,
		/obj/item/gun/energy/kinetic_accelerator/super_kinetic_accelerator = 1,
	)

	backpack = /obj/item/storage/backpack/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	duffelbag = /obj/item/storage/backpack/duffelbag
	box = /obj/item/storage/box/survival/mining
	pda_slot = ITEM_SLOT_RPOCKET

	chameleon_extras = /obj/item/gun/energy/kinetic_accelerator/super_kinetic_accelerator

	id_trim = /datum/id_trim/job/hunter

/datum/outfit/job/hunter/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	spawn(50)
		var/obj/item/card/id/ID = H.get_idcard()
		if(ID)
			ID.mining_points = 2000

/datum/id_trim/job/hunter
	assignment = JOB_HUNTER
	trim_state = "trim_hunter"
	full_access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE, ACCESS_GATEWAY)
	minimal_access = list(ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE, ACCESS_GATEWAY)
	config_job = "hunter"
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOP, ACCESS_CHANGE_IDS)

/obj/item/energylance
	name = "энергокопьё"
	desc = "Данный образец был обнаружен при раскопках в каком-то пирамидальном сооружении. На данный момент был доблестно украден текущим владельцем в качестве \"трофея\"."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "energylance"
	righthand_file = 'white/valtos/icons/righthand.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	worn_icon = 'white/valtos/icons/clothing/mob/belt.dmi'
	worn_icon_state = "energylance"
	embedding = list("embed_chance" = 55, "embedded_fall_chance" = 0.5, "embedded_impact_pain_multiplier" = 3)
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT
	force = 6
	throwforce = 12
	armour_penetration = 10
	pickup_sound = 'white/valtos/sounds/brasssneath1.ogg'
	hitsound = 'sound/weapons/stab1.ogg'
	attack_verb_continuous = list("бьёт", "тычет")
	attack_verb_simple = list("бьёт", "тычет")
	w_class = WEIGHT_CLASS_NORMAL
	item_flags = NONE
	bare_wound_bonus = 5
	var/extended = FALSE
	var/active_force = 12
	var/collected_force = 0

/obj/item/energylance/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += span_green("Накоплено урона: <b>[collected_force]</b>")

/obj/item/energylance/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, .proc/on_transform)

/obj/item/energylance/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = active_force + collected_force, \
		throwforce_on = (active_force + collected_force) * 2, \
		hitsound_on = hitsound, \
		w_class_on = WEIGHT_CLASS_BULKY, \
		clumsy_check = FALSE, \
		attack_verb_continuous_on = list("протыкает", "насаживает", "тычет", "пробивает"), \
		attack_verb_simple_on = list("протыкает", "насаживает", "тычет", "пробивает"))

/obj/item/energylance/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	righthand_file = active ? 'white/valtos/icons/96x96_righthand.dmi' : 'white/valtos/icons/righthand.dmi'
	lefthand_file = active ? 'white/valtos/icons/96x96_lefthand.dmi' : 'white/valtos/icons/lefthand.dmi'
	inhand_x_dimension = active ? -32 : 32
	extended = active
	reach = active ? 2 : 1
	slot_flags = active ? NONE : (ITEM_SLOT_BACK | ITEM_SLOT_BELT)
	icon_state = active ? "energylanceon" : "energylance"
	inhand_icon_state = active ? "energylanceon" : "energylance"
	balloon_alert(user, "[src] [active ? "активно" : "не активно"]")
	playsound(user ? user : src, sound('sound/weapons/batonextend.ogg'), 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/energylance/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	. = ..()
	check_backstab(target, user, proximity_flag)

/obj/item/energylance/proc/check_backstab(atom/target, mob/living/user, proximity_flag)
	if(!extended || !lavaland_equipment_pressure_check(get_turf(target)))
		return
	if(proximity_flag && isliving(target))
		var/mob/living/L = target
		if(!QDELETED(L))
			var/backstab_dir = get_dir(user, L)
			var/def_check = L.getarmor(type = BOMB)
			if((user.dir & backstab_dir) && (L.dir & backstab_dir))
				new /obj/effect/temp_visual/lance_impact(get_turf(L))
				L.apply_damage((active_force + collected_force) * 1.5, BRUTE, blocked = def_check)
				playsound(user, 'sound/weapons/kenetic_accel.ogg', 100, TRUE)
		check_upgrade(target, user, proximity_flag)

/obj/item/energylance/proc/check_upgrade(atom/target, mob/living/user, proximity_flag)
	if(proximity_flag && isanimal(target))
		var/mob/living/L = target
		if(!L || (L && L.health <= 0 && L.maxHealth > 90))
			collected_force++
			L.dust(TRUE, TRUE)
			if(user)
				to_chat(user, span_green("Копьё усилено."))

/obj/item/energylance/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	check_upgrade(hit_atom, proximity_flag = TRUE)
