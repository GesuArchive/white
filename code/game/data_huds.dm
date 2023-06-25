/*
 * Data HUDs have been rewritten in a more generic way.
 * In short, they now use an observer-listener pattern.
 * See code/datum/hud.dm for the generic hud datum.
 * Update the HUD icons when needed with the appropriate hook. (see below)
 */

/* DATA HUD DATUMS */

/atom/proc/add_to_all_human_data_huds()
	for(var/datum/atom_hud/data/human/hud in GLOB.huds)
		hud.add_atom_to_hud(src)

/atom/proc/remove_from_all_data_huds()
	for(var/datum/atom_hud/data/hud in GLOB.huds)
		hud.remove_atom_from_hud(src)

/datum/atom_hud/data

/datum/atom_hud/data/human/medical
	hud_icons = list(STATUS_HUD, HEALTH_HUD, NANITE_HUD)

/datum/atom_hud/data/human/medical/basic

/datum/atom_hud/data/human/medical/basic/proc/check_sensors(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	var/obj/item/clothing/under/U = H.w_uniform
	if(!istype(U))
		return FALSE
	if(U.sensor_mode <= SENSOR_VITALS)
		return FALSE
	return TRUE

/datum/atom_hud/data/human/medical/basic/add_atom_to_single_mob_hud(mob/M, mob/living/carbon/H)
	if(check_sensors(H))
		..()

/datum/atom_hud/data/human/medical/basic/proc/update_suit_sensors(mob/living/carbon/H)
	check_sensors(H) ? add_atom_to_hud(H) : remove_atom_from_hud(H)

/datum/atom_hud/data/human/medical/advanced

/datum/atom_hud/data/human/security

/datum/atom_hud/data/human/security/basic
	hud_icons = list(ID_HUD)

/datum/atom_hud/data/human/security/advanced
	hud_icons = list(ID_HUD, IMPTRACK_HUD, IMPLOYAL_HUD, IMPCHEM_HUD, WANTED_HUD, NANITE_HUD)

/datum/atom_hud/data/human/fan_hud
	hud_icons = list(FAN_HUD)

/datum/atom_hud/data/human/psih_hud
	hud_icons = list(PSIH_HUD)

/datum/atom_hud/data/diagnostic

/datum/atom_hud/data/diagnostic/basic
	hud_icons = list(DIAG_HUD, DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD, DIAG_BOT_HUD, DIAG_CIRCUIT_HUD, DIAG_TRACK_HUD, DIAG_AIRLOCK_HUD, DIAG_NANITE_FULL_HUD, DIAG_LAUNCHPAD_HUD)

/datum/atom_hud/data/diagnostic/advanced
	hud_icons = list(DIAG_HUD, DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD, DIAG_BOT_HUD, DIAG_CIRCUIT_HUD, DIAG_TRACK_HUD, DIAG_AIRLOCK_HUD, DIAG_NANITE_FULL_HUD, DIAG_LAUNCHPAD_HUD, DIAG_PATH_HUD)

/datum/atom_hud/data/bot_path
	// This hud exists so the bot can see itself, that's all
	uses_global_hud_category = FALSE
	hud_icons = list(DIAG_PATH_HUD)

/datum/atom_hud/abductor
	hud_icons = list(GLAND_HUD)

/datum/atom_hud/sentient_disease
	hud_icons = list(SENTIENT_DISEASE_HUD)

/datum/atom_hud/ai_detector
	hud_icons = list(AI_DETECT_HUD)

/datum/atom_hud/ai_detector/show_to(mob/new_viewer)
	..()
	if(!new_viewer || hud_users.len != 1)
		return
	for(var/mob/camera/ai_eye/eye as anything in GLOB.aiEyes)
		eye.update_ai_detect_hud()

/* MED/SEC/DIAG HUD HOOKS */

/*
 * THESE HOOKS SHOULD BE CALLED BY THE MOB SHOWING THE HUD
 */

/***********************************************
Medical HUD! Basic mode needs suit sensors on.
************************************************/

//HELPERS

//called when a carbon changes virus
/mob/living/carbon/proc/check_virus()
	var/threat
	var/severity
	if(HAS_TRAIT(src, TRAIT_DISEASELIKE_SEVERITY_MEDIUM))
		severity = DISEASE_SEVERITY_MEDIUM
		threat = get_disease_severity_value(severity)

	for(var/thing in diseases)
		var/datum/disease/D = thing
		if(!(D.visibility_flags & HIDDEN_SCANNER))
			if(!threat || get_disease_severity_value(D.severity) > threat) //a buffing virus gets an icon
				threat = get_disease_severity_value(D.severity)
				severity = D.severity
	return severity

//helper for getting the appropriate health status
/proc/RoundHealth(mob/living/M)
	if(M.stat == DEAD || (HAS_TRAIT(M, TRAIT_FAKEDEATH)))
		return "health-100" //what's our health? it doesn't matter, we're dead, or faking
	var/maxi_health = M.maxHealth
	if(iscarbon(M) && M.health < 0)
		maxi_health = 100 //so crit shows up right for aliens and other high-health carbon mobs; noncarbons don't have crit.
	var/resulthealth = (M.health / maxi_health) * 100
	switch(resulthealth)
		if(100 to INFINITY)
			return "health100"
		if(90.625 to 100)
			return "health93.75"
		if(84.375 to 90.625)
			return "health87.5"
		if(78.125 to 84.375)
			return "health81.25"
		if(71.875 to 78.125)
			return "health75"
		if(65.625 to 71.875)
			return "health68.75"
		if(59.375 to 65.625)
			return "health62.5"
		if(53.125 to 59.375)
			return "health56.25"
		if(46.875 to 53.125)
			return "health50"
		if(40.625 to 46.875)
			return "health43.75"
		if(34.375 to 40.625)
			return "health37.5"
		if(28.125 to 34.375)
			return "health31.25"
		if(21.875 to 28.125)
			return "health25"
		if(15.625 to 21.875)
			return "health18.75"
		if(9.375 to 15.625)
			return "health12.5"
		if(1 to 9.375)
			return "health6.25"
		if(-50 to 1)
			return "health0"
		if(-85 to -50)
			return "health-50"
		if(-99 to -85)
			return "health-85"
		else
			return "health-100"

//HOOKS

//called when a human changes suit sensors
/mob/living/carbon/proc/update_suit_sensors()
	var/datum/atom_hud/data/human/medical/basic/B = GLOB.huds[DATA_HUD_MEDICAL_BASIC]
	B.update_suit_sensors(src)

//called when a living mob changes health
/mob/living/proc/med_hud_set_health()
	var/image/holder = hud_list[HEALTH_HUD]
	holder.icon_state = "hud[RoundHealth(src)]"
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size

//for carbon suit sensors
/mob/living/carbon/med_hud_set_health()
	..()

//called when a carbon changes stat, virus or XENO_HOST
/mob/living/proc/med_hud_set_status()
	var/image/holder = hud_list[STATUS_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		holder.icon_state = "huddead"
	else
		holder.icon_state = "hudhealthy"

/mob/living/carbon/med_hud_set_status()
	var/image/holder = hud_list[STATUS_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	var/virus_threat = check_virus()
	holder.pixel_y = I.Height() - world.icon_size

	var/obj/item/organ/zombie_infection/infection
	infection = get_organ_slot(ORGAN_SLOT_ZOMBIE)
	if(infection)
		holder.icon_state = "hudzed"

	else if(HAS_TRAIT(src, TRAIT_XENO_HOST))
		holder.icon_state = "hudxeno"
	else if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		if((key || get_ghost(FALSE, TRUE)) && (can_defib() & DEFIB_REVIVABLE_STATES))
			holder.icon_state = "huddefib"
		else
			holder.icon_state = "huddead"
	else
		switch(virus_threat)
			if(DISEASE_SEVERITY_BIOHAZARD)
				holder.icon_state = "hudill5"
			if(DISEASE_SEVERITY_DANGEROUS)
				holder.icon_state = "hudill4"
			if(DISEASE_SEVERITY_HARMFUL)
				holder.icon_state = "hudill3"
			if(DISEASE_SEVERITY_MEDIUM)
				holder.icon_state = "hudill2"
			if(DISEASE_SEVERITY_MINOR)
				holder.icon_state = "hudill1"
			if(DISEASE_SEVERITY_NONTHREAT)
				holder.icon_state = "hudill0"
			if(DISEASE_SEVERITY_POSITIVE)
				holder.icon_state = "hudbuff"
			if(null)
				holder.icon_state = "hudhealthy"


/***********************************************
ХУДы Психолога - Определяют церебралы
************************************************/

//  Проверка церебралов
/mob/living/carbon/proc/check_cerebrals()
	var/psychosis
	var/psychosis_max
	var/obj/item/organ/brain/B = get_organ_slot(ORGAN_SLOT_BRAIN)

	if(mind?.has_antag_datum(/datum/antagonist/brainwashed) || mind?.has_antag_datum(/datum/antagonist/abductee))
		psychosis = 15
		return psychosis

	if(!B)
		return 1

	for(var/i in B.traumas)
		var/datum/brain_trauma/trauma = i

		if(istype(trauma, /datum/brain_trauma/special/obsessed))
			psychosis = 14
			return psychosis
		else if(istype(trauma, /datum/brain_trauma/severe/pacifism))
			psychosis = 13
			return psychosis
		else
			switch(trauma.resilience)
				if(TRAUMA_RESILIENCE_BASIC)
					psychosis = 1
				if(TRAUMA_RESILIENCE_WOUND)
					psychosis = 2
				if(TRAUMA_RESILIENCE_SURGERY)
					psychosis = 2
				if(TRAUMA_RESILIENCE_LOBOTOMY)
					psychosis = 3
				if(TRAUMA_RESILIENCE_ABSOLUTE)
					psychosis = 4
		if(psychosis >= psychosis_max)
			psychosis_max = psychosis
	return psychosis_max

/mob/living/carbon/proc/psih_hud_set_status()
	var/image/holder = hud_list[PSIH_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	var/cerebral_threat = check_cerebrals()
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon = 'white/Feline/icons/psih.dmi'
	holder.icon_state = "hud_psih_no"
	if(cerebral_threat)
		switch(cerebral_threat)
			if(1)
				holder.icon_state = "hud_psih_1"
			if(2)
				holder.icon_state = "hud_psih_2"
			if(3)
				holder.icon_state = "hud_psih_3"
			if(4)
				holder.icon_state = "hud_psih_4"
			if(13)
				holder.icon_state = "peace"
			if(14)
				holder.icon_state = "yandere"
			if(15)
				holder.icon_state = "brainwashed"
			if(null)
				holder.icon_state = "hud_psih_no"

/***********************************************
FAN HUDs! For identifying other fans on-sight.
************************************************/

//HOOKS

/mob/living/carbon/human/proc/fan_hud_set_fandom()
	var/image/holder = hud_list[FAN_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "hudfan_no"
	var/obj/item/clothing/under/U = get_item_by_slot(ITEM_SLOT_ICLOTHING)
	if(!U)
		set_hud_image_inactive(FAN_HUD)
		return

	if(istype(U.attached_accessory, /obj/item/clothing/accessory/fan_mime_pin))
		holder.icon_state = "fan_mime_pin"

	else if(istype(U.attached_accessory, /obj/item/clothing/accessory/fan_clown_pin))
		holder.icon_state = "fan_clown_pin"
	set_hud_image_active(FAN_HUD)
	return

/***********************************************
Security HUDs! Basic mode shows only the job.
************************************************/

//HOOKS

/mob/living/carbon/human/proc/sec_hud_set_ID()
	var/image/holder = hud_list[ID_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	var/sechud_icon_state = wear_id?.get_sechud_job_icon_state()

	if(!sechud_icon_state)
		sechud_icon_state = "hudno_id"
	holder.icon_state = sechud_icon_state
	sec_hud_set_security_status()

/mob/living/proc/sec_hud_set_implants()
	var/image/holder
	for(var/i in list(IMPTRACK_HUD, IMPLOYAL_HUD, IMPCHEM_HUD))
		holder = hud_list[i]
		holder.icon_state = null
		set_hud_image_inactive(i)

	for(var/obj/item/implant/I in implants)
		if(istype(I, /obj/item/implant/tracking))
			holder = hud_list[IMPTRACK_HUD]
			var/icon/IC = icon(icon, icon_state, dir)
			holder.pixel_y = IC.Height() - world.icon_size
			holder.icon_state = "hud_imp_tracking"
			set_hud_image_active(IMPTRACK_HUD)

		else if(istype(I, /obj/item/implant/chem))
			holder = hud_list[IMPCHEM_HUD]
			var/icon/IC = icon(icon, icon_state, dir)
			holder.pixel_y = IC.Height() - world.icon_size
			holder.icon_state = "hud_imp_chem"
			set_hud_image_active(IMPCHEM_HUD)

	if(HAS_TRAIT(src, TRAIT_MINDSHIELD))
		holder = hud_list[IMPLOYAL_HUD]
		var/icon/IC = icon(icon, icon_state, dir)
		holder.pixel_y = IC.Height() - world.icon_size
		holder.icon_state = "hud_imp_loyal"
		set_hud_image_active(IMPLOYAL_HUD)

/mob/living/carbon/human/proc/sec_hud_set_security_status()
	var/image/holder = hud_list[WANTED_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	var/perpname = get_face_name(get_id_name(""))
	if(perpname && GLOB.data_core)
		var/datum/data/record/R = find_record("name", perpname, GLOB.data_core.security)
		if(R)
			var/has_criminal_entry = TRUE
			switch(R.fields["criminal"])
				if("*Arrest*")
					holder.icon_state = "hudwanted"
				if("Incarcerated")
					holder.icon_state = "hudincarcerated"
				if("Paroled")
					holder.icon_state = "hudparolled"
				if("Discharged")
					holder.icon_state = "huddischarged"
				else
					has_criminal_entry = FALSE
			if(has_criminal_entry)
				set_hud_image_active(WANTED_HUD)
				return

	holder.icon_state = null
	set_hud_image_inactive(WANTED_HUD)

/***********************************************
Diagnostic HUDs!
************************************************/

/mob/living/proc/hud_set_nanite_indicator()
	var/image/holder = hud_list[NANITE_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = null
	if(HAS_TRAIT(src, TRAIT_NANITE_MONITORING))
		holder.icon_state = "nanite_ping"

//For Diag health and cell bars!
/proc/RoundDiagBar(value)
	switch(value * 100)
		if(95 to INFINITY)
			return "max"
		if(80 to 100)
			return "good"
		if(60 to 80)
			return "high"
		if(40 to 60)
			return "med"
		if(20 to 40)
			return "low"
		if(1 to 20)
			return "crit"
		else
			return "dead"

//Sillycone hooks
/mob/living/silicon/proc/diag_hud_set_health()
	var/image/holder = hud_list[DIAG_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(stat == DEAD)
		holder.icon_state = "huddiagdead"
	else
		holder.icon_state = "huddiag[RoundDiagBar(health/maxHealth)]"

/mob/living/silicon/proc/diag_hud_set_status()
	var/image/holder = hud_list[DIAG_STAT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	switch(stat)
		if(CONSCIOUS)
			holder.icon_state = "hudstat"
		if(UNCONSCIOUS, HARD_CRIT)
			holder.icon_state = "hudoffline"
		else
			holder.icon_state = "huddead2"

//Borgie battery tracking!
/mob/living/silicon/robot/proc/diag_hud_set_borgcell()
	var/image/holder = hud_list[DIAG_BATT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(cell)
		var/chargelvl = (cell.charge/cell.maxcharge)
		holder.icon_state = "hudbatt[RoundDiagBar(chargelvl)]"
	else
		holder.icon_state = "hudnobatt"

//borg-AI shell tracking
/mob/living/silicon/robot/proc/diag_hud_set_aishell() //Shows tracking beacons on the mech
	var/image/holder = hud_list[DIAG_TRACK_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(!shell) //Not an AI shell
		holder.icon_state = null
		set_hud_image_inactive(DIAG_TRACK_HUD)
		return
	else if(deployed) //AI shell in use by an AI
		holder.icon_state = "hudtrackingai"
	else //Empty AI shell
		holder.icon_state = "hudtracking"
	set_hud_image_active(DIAG_TRACK_HUD)

//AI side tracking of AI shell control
/mob/living/silicon/ai/proc/diag_hud_set_deployed() //Shows tracking beacons on the mech
	var/image/holder = hud_list[DIAG_TRACK_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(!deployed_shell)
		holder.icon_state = null
		set_hud_image_inactive(DIAG_TRACK_HUD)
	else //AI is currently controlling a shell
		holder.icon_state = "hudtrackingai"
		set_hud_image_active(DIAG_TRACK_HUD)

/*~~~~~~~~~~~~~~~~~~~~
	BIG STOMPY MECHS
~~~~~~~~~~~~~~~~~~~~~*/
/obj/vehicle/sealed/mecha/proc/diag_hud_set_mechhealth()
	var/image/holder = hud_list[DIAG_MECH_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "huddiag[RoundDiagBar(obj_integrity/max_integrity)]"


/obj/vehicle/sealed/mecha/proc/diag_hud_set_mechcell()
	var/image/holder = hud_list[DIAG_BATT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(cell)
		var/chargelvl = cell.charge/cell.maxcharge
		holder.icon_state = "hudbatt[RoundDiagBar(chargelvl)]"
	else
		holder.icon_state = "hudnobatt"


/obj/vehicle/sealed/mecha/proc/diag_hud_set_mechstat()
	var/image/holder = hud_list[DIAG_STAT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(internal_damage)
		holder.icon_state = "hudwarn"
		set_hud_image_active(DIAG_STAT_HUD)
	holder.icon_state = null
	set_hud_image_inactive(DIAG_STAT_HUD)

///Shows tracking beacons on the mech
/obj/vehicle/sealed/mecha/proc/diag_hud_set_mechtracking()
	var/image/holder = hud_list[DIAG_TRACK_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	var/new_icon_state //This var exists so that the holder's icon state is set only once in the event of multiple mech beacons.
	for(var/obj/item/mecha_parts/mecha_tracking/T in trackers)
		if(T.ai_beacon) //Beacon with AI uplink
			new_icon_state = "hudtrackingai"
			break //Immediately terminate upon finding an AI beacon to ensure it is always shown over the normal one, as mechs can have several trackers.
		else
			new_icon_state = "hudtracking"
	holder.icon_state = new_icon_state

/*~~~~~~~~~
	Bots!
~~~~~~~~~~*/
/mob/living/simple_animal/bot/proc/diag_hud_set_bothealth()
	var/image/holder = hud_list[DIAG_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "huddiag[RoundDiagBar(health/maxHealth)]"

/mob/living/simple_animal/bot/proc/diag_hud_set_botstat() //On (With wireless on or off), Off, EMP'ed
	var/image/holder = hud_list[DIAG_STAT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(on)
		holder.icon_state = "hudstat"
	else if(stat) //Generally EMP causes this
		holder.icon_state = "hudoffline"
	else //Bot is off
		holder.icon_state = "huddead2"

/mob/living/simple_animal/bot/proc/diag_hud_set_botmode() //Shows a bot's current operation
	var/image/holder = hud_list[DIAG_BOT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(client) //If the bot is player controlled, it will not be following mode logic!
		holder.icon_state = "hudsentient"
		return

	switch(mode)
		if(BOT_SUMMON, BOT_RESPONDING) //Responding to PDA or AI summons
			holder.icon_state = "hudcalled"
		if(BOT_CLEANING, BOT_REPAIRING, BOT_HEALING) //Cleanbot cleaning, Floorbot fixing, or Medibot Healing
			holder.icon_state = "hudworking"
		if(BOT_PATROL, BOT_START_PATROL) //Patrol mode
			holder.icon_state = "hudpatrol"
		if(BOT_PREP_ARREST, BOT_ARREST, BOT_HUNT) //STOP RIGHT THERE, CRIMINAL SCUM!
			holder.icon_state = "hudalert"
		if(BOT_MOVING, BOT_DELIVER, BOT_GO_HOME, BOT_NAV) //Moving to target for normal bots, moving to deliver or go home for MULES.
			holder.icon_state = "hudmove"
		else
			holder.icon_state = ""

/mob/living/simple_animal/bot/mulebot/proc/diag_hud_set_mulebotcell()
	var/image/holder = hud_list[DIAG_BATT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(cell)
		var/chargelvl = (cell.charge/cell.maxcharge)
		holder.icon_state = "hudbatt[RoundDiagBar(chargelvl)]"
	else
		holder.icon_state = "hudnobatt"

/*~~~~~~~~~~~~
	Airlocks!
~~~~~~~~~~~~~*/
/obj/machinery/door/airlock/proc/diag_hud_set_electrified()
	var/image/holder = hud_list[DIAG_AIRLOCK_HUD]
	if(secondsElectrified == MACHINE_NOT_ELECTRIFIED)
		holder.icon_state = "" // this thing looks horribly wrong in my mind but FUCK it's works. TODO: valera please check out where you nasral in https://github.com/frosty-dev/white/commit/27e36d9d5b9ec5d0b68c933ca5377055846cbd9f that it gone broken af
		set_hud_image_inactive(DIAG_AIRLOCK_HUD)
		return

	holder.icon_state = "electrified"
	set_hud_image_active(DIAG_AIRLOCK_HUD)
