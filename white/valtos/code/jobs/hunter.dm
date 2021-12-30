/datum/job/hunter
	title = "Hunter"
	ru_title = "Охотник"
	department_head = list()
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "никому"
	selection_color = "#ff4040"

	exp_type = EXP_TYPE_CREW
	exp_requirements = 9000

	outfit = /datum/outfit/job/hunter

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_CAR

	display_order = JOB_DISPLAY_ORDER_SHAFT_MINER
	bounty_types = CIV_JOB_MINE

	rpg_title = "Боссхантер"

	metalocked = TRUE

/datum/outfit/job/hunter
	name = "Hunter"
	jobtype = /datum/job/hunter

	belt = /obj/item/pda/hunter
	ears = /obj/item/radio/headset/headset_cargo/mining
	shoes = /obj/item/clothing/shoes/workboots/mining
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/cargo/miner/lavaland
	suit = /obj/item/clothing/suit/space/hardsuit/berserker
	mask = /obj/item/clothing/mask/gas/explorer
	glasses = /obj/item/clothing/glasses/meson/night
	suit_store = /obj/item/tank/internals/oxygen/red
	l_pocket = /obj/item/reagent_containers/hypospray/medipen/survival/luxury
	r_pocket = /obj/item/kitchen/knife/combat
	backpack_contents = list(
		/obj/item/flashlight/seclite=1,\
		/obj/item/mining_voucher=1,\
		/obj/item/t_scanner/adv_mining_scanner=1,\
		/obj/item/gun/energy/kinetic_accelerator/super_kinetic_accelerator=1)

	backpack = /obj/item/storage/backpack/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	duffelbag = /obj/item/storage/backpack/duffelbag
	box = /obj/item/storage/box/survival/mining

	chameleon_extras = /obj/item/gun/energy/kinetic_accelerator/super_kinetic_accelerator

	id_trim = /datum/id_trim/job/hunter

/datum/outfit/job/hunter/equipped/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	if(istype(H.wear_suit, /obj/item/clothing/suit/space/hardsuit))
		var/obj/item/clothing/suit/space/hardsuit/S = H.wear_suit
		S.ToggleHelmet()
	spawn(50)
		var/obj/item/card/id/ID = H.get_idcard()
		if(ID)
			ID.mining_points = 2000

/datum/id_trim/job/hunter
	assignment = "Hunter"
	trim_state = "trim_hunter"
	full_access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE)
	minimal_access = list(ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE)
	config_job = "hunter"
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOP, ACCESS_CHANGE_IDS)
	trim_icon = 'white/valtos/icons/card.dmi'
