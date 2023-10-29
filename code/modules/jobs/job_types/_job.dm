/datum/job
	//The name of the job , used for preferences, bans and more. Make sure you know what you're doing before changing this.
	var/title = "NOPE"

	/// Innate skill levels unlocked at roundstart. Based on config.jobs_have_minimal_access config setting, for example with a skeleton crew. Format is list(/datum/skill/foo = SKILL_EXP_NOVICE) with exp as an integer or as per code/_DEFINES/skills.dm
	var/list/skills
	/// Innate skill levels unlocked at roundstart. Based on config.jobs_have_minimal_access config setting, for example with a full crew. Format is list(/datum/skill/foo = SKILL_EXP_NOVICE) with exp as an integer or as per code/_DEFINES/skills.dm
	var/list/minimal_skills

	//Determines who can demote this position
	var/department_head = list()

	//Tells the given channels that the given mob is the new department head. See communications.dm for valid channels.
	var/list/head_announce = null

	//Bitflags for the job
	var/auto_deadmin_role_flags = NONE

	//Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = "None"

	//How many players can be this job
	var/total_positions = 0

	//How many players can spawn in as this job
	var/spawn_positions = 0

	//How many players have this job
	var/current_positions = 0

	//Supervisors, who this person answers to directly
	var/supervisors = ""

	//Sellection screen color
	var/selection_color = "#ffffff"


	//If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify

	//If you have the use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0
//	var/maximum_player_age = -1
	var/inverted_player_age = FALSE

	var/outfit = null

	var/exp_requirements = 0

	var/exp_type = ""
	var/exp_type_department = ""

	//The amount of good boy points playing this role will earn you towards a higher chance to roll antagonist next round
	//can be overridden by antag_rep.txt config
	var/antag_rep = 3

	var/paycheck = PAYCHECK_MINIMAL
	var/paycheck_department = ACCOUNT_CIV

	var/list/mind_traits // Traits added to the mind of the mob assigned this job

	///Lazylist of traits added to the liver of the mob assigned this job (used for the classic "cops heal from donuts" reaction, among others)
	var/list/liver_traits = null

	var/display_order = JOB_DISPLAY_ORDER_DEFAULT

	var/bounty_types = CIV_JOB_BASIC

	var/metalocked = FALSE
	/// Goodies that can be received via the mail system.
	// this is a weighted list.
	/// Keep the _job definition for this empty and use /obj/item/mail to define general gifts.
	var/list/mail_goodies = list()

	/// If this job's mail goodies compete with generic goodies.
	var/exclusive_mail_goodies = FALSE

	/// Lazy list with the departments this job belongs to.
	/// Required to be set for playable jobs.
	/// The first department will be used in the preferences menu,
	/// unless department_for_prefs is set.
	var/list/departments_list = null

	///Bitfield of departments this job belongs wit
	var/departments = NONE

	/// Should this job be allowed to be picked for the bureaucratic error event?
	var/allow_bureaucratic_error = TRUE

	///RPG job names, for the memes
	var/rpg_title
	var/rpg_title_ru

	var/list/whitelisted = list()

	var/allow_new_players = TRUE

/datum/job/New()
	. = ..()
	var/list/jobs_changes = get_map_changes()
	if(!jobs_changes)
		return
	if(isnum(jobs_changes["spawn_positions"]))
		spawn_positions = jobs_changes["spawn_positions"]
	if(isnum(jobs_changes["total_positions"]))
		total_positions = jobs_changes["total_positions"]

/// Loads up map configs if necessary and returns job changes for this job.
/datum/job/proc/get_map_changes()
	var/string_type = "[type]"
	var/list/splits = splittext(string_type, "/")
	var/endpart = splits[splits.len]

	SSmapping.HACK_LoadMapConfig()

	var/list/job_changes = SSmapping.config.job_changes
	if(!(endpart in job_changes))
		return list()

	return job_changes[endpart]

//Only override this proc
//H is usually a human unless an /equip override transformed it
/datum/job/proc/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	var/client/C = H.client ? H.client : M.client
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_JOB_AFTER_SPAWN, src, H, C)
	//do actions on H but send messages to M as the key may not have been transferred_yet
	if(mind_traits)
		for(var/t in mind_traits)
			ADD_TRAIT(H.mind, t, JOB_TRAIT)

	var/obj/item/organ/liver/liver = H.get_organ_slot(ORGAN_SLOT_LIVER)

	if(liver)
		for(var/t in liver_traits)
			ADD_TRAIT(liver, t, JOB_TRAIT)

	var/list/roundstart_experience

	if(!ishuman(H))
		return

	if(!config)	//Needed for robots.
		roundstart_experience = minimal_skills

	if(CONFIG_GET(flag/jobs_have_minimal_access))
		roundstart_experience = minimal_skills
	else
		roundstart_experience = skills

	if(roundstart_experience)
		var/mob/living/carbon/human/experiencer = H
		for(var/i in roundstart_experience)
			experiencer.mind.adjust_experience(i, roundstart_experience[i], TRUE)

	if(istype(src, /datum/job/ai) || istype(src, /datum/job/cyborg))
		return

	equip_gear(H, C, FALSE)

	//// новый год 2022
	if(SSevents.holidays && SSevents.holidays[NEW_YEAR])
		var/obj/item/stack/garland_pack/fifty/garl = new(get_turf(H))
		H.put_in_hands(garl)
		H.equip_to_slot(garl, ITEM_SLOT_BACKPACK)
	//// новый год 2022

/datum/job/proc/equip_gear(mob/living/H, client/our_client, only_view = TRUE)
	if(SSviolence.active)
		return
	var/mob/living/carbon/human/human = H
	var/list/gear_leftovers = list()
	if(our_client && LAZYACCESS(our_client.prefs.equipped_gear_by_character, our_client.prefs.default_slot) && LAZYLEN(our_client.prefs.equipped_gear_by_character[our_client.prefs.default_slot]))
		var/list/equiped_names = list()
		for(var/gear in our_client.prefs.equipped_gear_by_character[our_client.prefs.default_slot])
			var/datum/gear/G = GLOB.gear_datums[gear]
			if(G)
				var/permitted = FALSE

				if(G.allowed_roles && H.mind && (H.mind.assigned_role in G.allowed_roles))
					permitted = TRUE
				else if(!G.allowed_roles)
					permitted = TRUE
				else
					permitted = FALSE

				if(G.species_blacklist && (human.dna.species.id in G.species_blacklist))
					permitted = FALSE

				if(G.species_whitelist && !(human.dna.species.id in G.species_whitelist))
					permitted = FALSE

				if(!permitted && !only_view)
					to_chat(our_client, span_warning("Не удалость пронести <b>[G.display_name]</b> на станцию!"))
					continue

				if(G.slot)
					var/obj/item/item_in_slot = H.get_item_by_slot(G.slot)
					if(H.dropItemToGround(item_in_slot, force = FALSE, silent = TRUE, invdrop = FALSE))
						if(H.equip_to_slot_if_possible(G.spawn_item(H), G.slot, bypass_equip_delay_self = TRUE))
							if(!only_view)
								LAZYADD(equiped_names, G.display_name)
						else
							H.equip_to_slot_if_possible(item_in_slot, G.slot, bypass_equip_delay_self = TRUE)
							gear_leftovers += G
					else
						gear_leftovers += G
				else
					gear_leftovers += G
			else
				our_client.prefs.equipped_gear_by_character[our_client.prefs.default_slot] -= gear
		if(!only_view)
			to_chat(our_client, span_notice("\nЭкипируем [english_list(equiped_names)]!"))

	if(!only_view && gear_leftovers.len)
		for(var/datum/gear/G in gear_leftovers)
			var/metadata = our_client.prefs.equipped_gear_by_character[our_client.prefs.default_slot][G.id]
			var/obj/item = G.spawn_item(null, metadata)
			var/atom/placed_in = human.equip_or_collect(item)

			if(istype(placed_in))
				if(isturf(placed_in))
					to_chat(our_client, span_notice("[capitalize(G.display_name)] находится в [placed_in]!"))
				else
					to_chat(our_client, "<span class='noticed'>[capitalize(G.display_name)] находится на [placed_in.name]]")
				continue

			if(H.equip_to_appropriate_slot(item))
				to_chat(our_client, span_notice("[capitalize(G.display_name)] удалось успешно пронести!"))
				continue
			if(H.put_in_hands(item))
				to_chat(our_client, span_notice("[capitalize(G.display_name)] у меня в руках!"))
				continue

			var/obj/item/storage/B = (locate() in H)
			if(B && item)
				item.forceMove(B)
				to_chat(our_client, span_notice("[capitalize(G.display_name)] в [B.name]!"))
				continue

			to_chat(our_client, span_danger("Что-то пришлось оставить..."))
			qdel(item)

/datum/job/proc/announce(mob/living/carbon/human/H, announce_captaincy = FALSE)
	if(head_announce)
		announce_head(H, head_announce)

/mob/living/proc/dress_up_as_job(datum/job/equipping, visual_only = FALSE)
	return

/mob/living/carbon/human/dress_up_as_job(datum/job/equipping, visual_only = FALSE)
	//dna.species.pre_equip_species_outfit(equipping, src, visual_only)
	equipOutfit(equipping.outfit, visual_only)

/datum/job/proc/override_latejoin_spawn(mob/living/carbon/human/H)		//Return TRUE to force latejoining to not automatically place the person in latejoin shuttle/whatever.
	return FALSE

//Used for a special check of whether to allow a client to latejoin as this job.
/datum/job/proc/special_check_latejoin(client/C)
	return TRUE

/datum/job/proc/GetAntagRep()
	. = CONFIG_GET(keyed_list/antag_rep)[lowertext(title)]
	if(. == null)
		return antag_rep

//Don't override this unless the job transforms into a non-human (Silicons do this for example)
/datum/job/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, datum/outfit/outfit_override = null, client/preference_source, is_captain = FALSE)
	if(!H)
		return FALSE
	if(CONFIG_GET(flag/enforce_human_authority) && (title in GLOB.command_positions))
		if(H.dna.species.id != "human")
			H.set_species(/datum/species/human)
			H.apply_pref_name("human", preference_source)
	if(!visualsOnly)
		var/datum/bank_account/bank_account = new(H.real_name, src, H.dna.species.payday_modifier)
		if(!latejoin)
			bank_account.payday(STARTING_PAYCHECKS, TRUE)
		else
			bank_account.payday(1, TRUE)
		H.account_id = bank_account.account_id

	//Equip the rest of the gear
	H.dna.species.before_equip_job(src, H, visualsOnly)

	if(outfit_override || outfit)
		H.equipOutfit(outfit_override ? outfit_override : outfit, visualsOnly)

	if(!visualsOnly && is_captain)
		var/is_acting_captain = (title != JOB_CAPTAIN)
		SSjob.promote_to_captain(H, is_acting_captain)

	H.dna.species.after_equip_job(src, H, visualsOnly)

	if(latejoin && SSjob.forced_name)
		switch(SSjob.forced_name)
			if("KEY")
				H.fully_replace_character_name(H.real_name, "[H.key]")
			if("TATAR")
				H.fully_replace_character_name(H.real_name, get_funny_name(3))
			else
				H.fully_replace_character_name(H.real_name, "[SSjob.forced_name] \Roman[SSjob.forced_num]")
		SSjob.forced_num++

	if(!visualsOnly && announce)
		announce(H, is_captain)

/datum/job/proc/announce_head(mob/living/carbon/human/H, channels) //tells the given channel that the given mob is the new department head. See communications.dm for valid channels.
	if(H && GLOB.announcement_systems.len)
		//timer because these should come after the captain announcement
		SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_addtimer), CALLBACK(pick(GLOB.announcement_systems), /obj/machinery/announcement_system/proc/announce, "NEWHEAD", H.real_name, H.job, channels), 1))

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	if(available_in_days(C) == 0)
		return TRUE	//Available in 0 days = available right now = player is old enough to play.
	return FALSE

/datum/job/proc/available_in_days(client/C)
	if(!C)
		return 0
	if(!CONFIG_GET(flag/use_age_restriction_for_jobs))
		return 0
//	if(!SSdbcore.Connect())
//		return 0 //Without a database connection we can't get a player's age so we'll assume they're old enough for all jobs
	if(!isnum(minimal_player_age))
		return 0

	if(inverted_player_age)
		return min(0, minimal_player_age - C.player_age)
	else
		return max(0, minimal_player_age - C.player_age)

/*
/datum/job/proc/player_to_old(client/C)
//	if(not_available_in_days(C) == -1)	// По умолчанию без ограничений
//	if(not_available_in_days(C))	// По умолчанию без ограничений
//		return FALSE
	return not_available_in_days(C)

/datum/job/proc/not_available_in_days(client/C)
	if(!C)
		return TRUE
	if(!CONFIG_GET(flag/use_age_restriction_for_jobs))
		return TRUE
	if(!SSdbcore.Connect())
		return TRUE //Without a database connection we can't get a player's age so we'll assume they're old enough for all jobs
	if(!isnum(maximum_player_age))
		return TRUE

	if(maximum_player_age == -1)
		return TRUE

	if((maximum_player_age - C.player_age) < 0)	// Слишком стар
		return FALSE

//	return min(0, C.player_age - maximum_player_age)
*/

/datum/job/proc/config_check()
	return TRUE

/datum/job/proc/map_check()
	var/list/job_changes = get_map_changes()
	if(!job_changes)
		return FALSE
	return TRUE

/datum/job/proc/radio_help_message(mob/M)
	to_chat(M, span_smallnotice("\nЕсли добавить :h перед сообщением, то получится говорить в канал отдела. Чтобы увидеть другие каналы, стоит посмотреть на наушник."))

/datum/outfit/job
	name = "Standard Gear"

	var/jobtype = null

	uniform = /obj/item/clothing/under/color/grey
	id = /obj/item/card/id/advanced
	ears = /obj/item/radio/headset
	belt = /obj/item/modular_computer/tablet/pda
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/sneakers/black
	box = /obj/item/storage/box/survival

	preload = TRUE // These are used by the prefs ui, and also just kinda could use the extra help at roundstart

	var/backpack = /obj/item/storage/backpack
	var/satchel  = /obj/item/storage/backpack/satchel
	var/duffelbag = /obj/item/storage/backpack/duffelbag

	var/pda_slot = ITEM_SLOT_BELT

/datum/outfit/job/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	switch(H.backpack)
		if(GBACKPACK)
			back = /obj/item/storage/backpack //Grey backpack
		if(GSATCHEL)
			back = /obj/item/storage/backpack/satchel //Grey satchel
		if(GDUFFELBAG)
			back = /obj/item/storage/backpack/duffelbag //Grey Duffel bag
		if(LSATCHEL)
			back = /obj/item/storage/backpack/satchel/leather //Leather Satchel
		if(DSATCHEL)
			back = satchel //Department satchel
		if(DDUFFELBAG)
			back = duffelbag //Department duffel bag
		else
			back = backpack //Department backpack

	//converts the uniform string into the path we'll wear, whether it's the skirt or regular variant
	var/holder
	if(H.jumpsuit_style == PREF_SKIRT)
		holder = "[uniform]/skirt"
		if(!text2path(holder))
			holder = "[uniform]"
	else
		holder = "[uniform]"
	uniform = text2path(holder)

/datum/outfit/job/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/datum/job/J = SSjob.GetJobType(jobtype)
	if(!J)
		J = SSjob.GetJob(H.job)

	var/obj/item/card/id/C = H.wear_id
	if(istype(C))
		shuffle_inplace(C.access) // Shuffle access list to make NTNet passkeys less predictable
		C.registered_name = H.real_name
		if(H.age)
			C.registered_age = H.age
		C.update_label()
		C.update_icon()
		var/datum/bank_account/B = SSeconomy.bank_accounts_by_id["[H.account_id]"]
		if(B && B.account_id == H.account_id)
			C.registered_account = B
			B.bank_cards += C
		H.sec_hud_set_ID()

	var/obj/item/modular_computer/tablet/pda/pda = H.get_item_by_slot(pda_slot)

	if(istype(pda))
		pda.saved_identification = H.real_name
		pda.saved_job = J.title
		pda.UpdateDisplay()

	if(H.client?.prefs.playtime_reward_cloak)
		neck = /obj/item/clothing/neck/cloak/skill_reward/playing


/datum/outfit/proc/special_equip(mob/living/carbon/human/H)
	//SS13 WHITE
	head = /obj/item/clothing/head/helmet/izanhelm
	uniform = /obj/item/clothing/under/m35jacket
	shoes = /obj/item/clothing/shoes/jackboots

/datum/outfit/job/get_chameleon_disguise_info()
	var/list/types = ..()
	types -= /obj/item/storage/backpack //otherwise this will override the actual backpacks
	types += backpack
	types += satchel
	types += duffelbag
	return types

/datum/outfit/job/get_types_to_preload()
	var/list/preload = ..()
	preload += backpack
	preload += satchel
	preload += duffelbag
	preload += /obj/item/storage/backpack/satchel/leather
	var/skirtpath = "[uniform]/skirt"
	preload += text2path(skirtpath)
	return preload

/// An overridable getter for more dynamic goodies.
/datum/job/proc/get_mail_goodies(mob/recipient)
	return mail_goodies
