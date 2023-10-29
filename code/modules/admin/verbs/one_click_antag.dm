/client/proc/one_click_antag()
	set name = "Create Antagonist"
	set desc = "Auto-create an antagonist of your choice"
	set category = "Адм.События"

	if(holder)
		holder.one_click_antag()
	return


/datum/admins/proc/one_click_antag()
	var/dat = {"
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=traitors'>Make Traitors</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=changelings'>Make Changelings</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=bloodsuckers'>Make Bloodsuckers</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=revs'>Make Revs</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=cult'>Make Cult</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=clockcult'>Make ClockCult</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=blob'>Make Blob</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=dreamer'>Make Dreamer</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=wizard'>Make Wizard (Requires Ghosts)</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=nukeops'>Make Nuke Team (Requires Ghosts)</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=centcom'>Make CentCom Response Team (Requires Ghosts)</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=abductors'>Make Abductor Team (Requires Ghosts)</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=revenant'>Make Revenant (Requires Ghost)</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=nerd'>Make N.E.R.D. (Requires Ghost)</a><br>
		<a href='?src=[REF(src)];[HrefToken()];makeAntag=cops'>Make cops. (Requires Ghosts)</a><br>
		"}

	var/datum/browser/popup = new(usr, "oneclickantag", "Quick-Create Antagonist", 400, 400)
	popup.set_content(dat)
	popup.open()

/datum/admins/proc/isReadytoRumble(mob/living/carbon/human/applicant, targetrole, onstation = TRUE, conscious = TRUE)
	if(applicant.mind.special_role)
		return FALSE
	if(!(targetrole in applicant.client.prefs.be_special))
		return FALSE
	if(onstation)
		var/turf/T = get_turf(applicant)
		if(!is_station_level(T.z))
			return FALSE
	if(conscious && applicant.stat) //incase you don't care about a certain antag being unconcious when made, ie if they have selfhealing abilities.
		return FALSE
	if(!considered_alive(applicant.mind) || considered_afk(applicant.mind)) //makes sure the player isn't a zombie, brain, or just afk all together
		return FALSE
	return !is_banned_from(applicant.ckey, list(targetrole, ROLE_SYNDICATE))


/datum/admins/proc/makeTraitors()
	var/datum/game_mode/traitor/temp = new

	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += JOB_ASSISTANT

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(isReadytoRumble(applicant, ROLE_TRAITOR))
			if(temp.age_check(applicant.client))
				if(!(applicant.job in temp.restricted_jobs))
					candidates += applicant

	if(candidates.len)
		var/numTraitors = min(candidates.len, 3)

		for(var/i = 0, i<numTraitors, i++)
			H = pick(candidates)
			H.mind.make_Traitor()
			candidates.Remove(H)

		return TRUE


	return FALSE


/datum/admins/proc/makeChangelings()

	var/datum/game_mode/changeling/temp = new
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += JOB_ASSISTANT

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(isReadytoRumble(applicant, ROLE_CHANGELING))
			if(temp.age_check(applicant.client))
				if(!(applicant.job in temp.restricted_jobs))
					candidates += applicant

	if(candidates.len)
		var/numChangelings = min(candidates.len, 3)

		for(var/i = 0, i<numChangelings, i++)
			H = pick(candidates)
			H.mind.make_Changeling()
			candidates.Remove(H)

		return TRUE

	return FALSE

/datum/admins/proc/makeSuckers()
	var/datum/game_mode/bloodsucker/temp = new

	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += JOB_ASSISTANT

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(isReadytoRumble(applicant, ROLE_BLOODSUCKER))
			if(temp.age_check(applicant.client))
				if(!(applicant.job in temp.restricted_jobs))
					candidates += applicant

	if(candidates.len)
		var/numSuckers = min(candidates.len, 3)

		for(var/i = 0, i<numSuckers, i++)
			H = pick(candidates)
			H.mind.make_bloodsucker()
			candidates.Remove(H)

		return TRUE

	return FALSE

/datum/admins/proc/makeRevs()

	var/datum/game_mode/revolution/temp = new
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += JOB_ASSISTANT

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(isReadytoRumble(applicant, ROLE_REV))
			if(temp.age_check(applicant.client))
				if(!(applicant.job in temp.restricted_jobs))
					candidates += applicant

	if(candidates.len)
		var/numRevs = min(candidates.len, 3)

		for(var/i = 0, i<numRevs, i++)
			H = pick(candidates)
			H.mind.make_Rev()
			candidates.Remove(H)
		return TRUE

	return FALSE

/datum/admins/proc/makeWizard()

	var/list/mob/dead/observer/candidates = poll_ghost_candidates("Do you wish to be considered for the position of a Wizard Foundation 'diplomat'?", ROLE_WIZARD, null)

	var/mob/dead/observer/selected = pick_n_take(candidates)

	var/mob/living/carbon/human/new_character = make_body(selected)
	new_character.mind.make_Wizard()
	return TRUE


/datum/admins/proc/makeCult()
	var/datum/game_mode/cult/temp = new
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += JOB_ASSISTANT

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(isReadytoRumble(applicant, ROLE_CULTIST))
			if(temp.age_check(applicant.client))
				if(!(applicant.job in temp.restricted_jobs))
					candidates += applicant

	if(candidates.len)
		var/numCultists = min(candidates.len, 4)

		for(var/i = 0, i<numCultists, i++)
			H = pick(candidates)
			H.mind.make_Cultist()
			candidates.Remove(H)

		return TRUE

	return FALSE

/datum/admins/proc/makeClockCult()
	var/datum/game_mode/clockcult/temp = new
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += JOB_ASSISTANT

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(isReadytoRumble(applicant, ROLE_SERVANT_OF_RATVAR))
			if(temp.age_check(applicant.client))
				if(!(applicant.job in temp.restricted_jobs))
					candidates += applicant

	if(candidates.len)
		var/numCultists = min(candidates.len, 4)

		LoadReebe()

		var/list/spawns = GLOB.servant_spawns.Copy()

		temp.main_cult = new
		temp.main_cult.setup_objectives()

		for(var/i = 0, i<numCultists, i++)
			H = pick(candidates)
			H.forceMove(pick_n_take(spawns))
			H.set_species(/datum/species/human)
			var/datum/antagonist/servant_of_ratvar/S = add_servant_of_ratvar(H, team = temp.main_cult)
			S.equip_servant()
			var/obj/item/clockwork/clockwork_slab/slab = new(get_turf(H))
			H.put_in_hands(slab)
			slab.pickup(H)
			S.prefix = CLOCKCULT_PREFIX_MASTER
			candidates.Remove(H)

		generate_clockcult_scriptures()

		return TRUE

	return FALSE


/datum/admins/proc/makeNukeTeam()
	var/choice = tgui_alert(usr, "Обыкновенная или клоуны?", "Nuke Creation", list("Обычная", "HONK!"))
	if(!choice)
		return FALSE

	var/list/mob/dead/observer/candidates = poll_ghost_candidates("Do you wish to be considered for a [choice == "HONK!" ? "CLOWN" : ""] nuke team being sent in?", ROLE_OPERATIVE, null)
	var/list/mob/dead/observer/chosen = list()
	var/mob/dead/observer/theghost = null

	if(candidates.len)
		var/numagents = 5
		var/agentcount = 0

		for(var/i = 0, i<numagents,i++)
			shuffle_inplace(candidates) //More shuffles means more randoms
			for(var/mob/j in candidates)
				if(!j || !j.client)
					candidates.Remove(j)
					continue

				theghost = j
				candidates.Remove(theghost)
				chosen += theghost
				agentcount++
				break
		//Making sure we have atleast 3 Nuke agents, because less than that is kinda bad
		if(agentcount < 3)
			return FALSE

		//Let's find the spawn locations
		var/leader_chosen = FALSE
		var/datum/team/nuclear/nuke_team
		if(choice == "Обычная")
			for(var/mob/c in chosen)
				var/mob/living/carbon/human/new_character=make_body(c)
				if(!leader_chosen)
					leader_chosen = TRUE
					var/datum/antagonist/nukeop/N = new_character.mind.add_antag_datum(/datum/antagonist/nukeop/leader)
					nuke_team = N.nuke_team
				else
					new_character.mind.add_antag_datum(/datum/antagonist/nukeop,nuke_team)
		if(choice == "HONK!")
			for(var/obj/machinery/nuclearbomb/syndicate/S in GLOB.nuke_list)
				var/turf/T = get_turf(S)
				if(T)
					qdel(S)
					new /obj/machinery/nuclearbomb/syndicate/bananium(T)
			for(var/mob/c in chosen)
				var/mob/living/carbon/human/new_character=make_body(c)
				if(!leader_chosen)
					leader_chosen = TRUE
					var/datum/antagonist/nukeop/N = new_character.mind.add_antag_datum(/datum/antagonist/nukeop/leader/clownop)
					nuke_team = N.nuke_team
				else
					new_character.mind.add_antag_datum(/datum/antagonist/nukeop/clownop,nuke_team)

		return TRUE
	else
		return FALSE

/datum/admins/proc/makeDreamer()
	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null
	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(isReadytoRumble(applicant, ROLE_TRAITOR))
			candidates += applicant
	if(candidates.len)
		H = pick(candidates)
		H.mind.make_Dreamer()
		return TRUE
	return FALSE

/datum/admins/proc/makeAliens()
	var/datum/round_event/ghost_role/alien_infestation/E = new(FALSE)
	E.spawncount = 3
	// TODO The fact we have to do this rather than just have events start
	// when we ask them to, is bad.
	E.processing = TRUE
	return TRUE

/datum/admins/proc/makeSpaceNinja()
	new /datum/round_event/ghost_role/space_ninja()
	return TRUE

// DEATH SQUADS
/datum/admins/proc/makeDeathsquad()
	return makeEmergencyresponseteam(/datum/ert/deathsquad)

// CENTCOM RESPONSE TEAM

/datum/admins/proc/makeERTTemplateModified(list/settings)
	. = settings
	var/datum/ert/newtemplate = settings["mainsettings"]["template"]["value"]
	if (isnull(newtemplate))
		return
	if (!ispath(newtemplate))
		newtemplate = text2path(newtemplate)
	newtemplate = new newtemplate
	.["mainsettings"]["teamsize"]["value"] = newtemplate.teamsize
	.["mainsettings"]["mission"]["value"] = newtemplate.mission
	.["mainsettings"]["polldesc"]["value"] = newtemplate.polldesc
	.["mainsettings"]["open_armory"]["value"] = newtemplate.opendoors ? "Yes" : "No"


/datum/admins/proc/equipAntagOnDummy(mob/living/carbon/human/dummy/mannequin, datum/antagonist/antag)
	for(var/I in mannequin.get_equipped_items(TRUE))
		qdel(I)
	if (ispath(antag, /datum/antagonist/ert))
		var/datum/antagonist/ert/ert = antag
		mannequin.equipOutfit(initial(ert.outfit), TRUE)
	else if (ispath(antag, /datum/antagonist/official))
		mannequin.equipOutfit(/datum/outfit/centcom/centcom_official, TRUE)

/datum/admins/proc/makeERTPreviewIcon(list/settings)
	// Set up the dummy for its photoshoot
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_ADMIN)

	var/prefs = settings["mainsettings"]
	var/datum/ert/template = prefs["template"]["value"]
	if (isnull(template))
		return null
	if (!ispath(template))
		template = text2path(prefs["template"]["value"]) // new text2path ... doesn't compile in 511

	template = new template
	var/datum/antagonist/ert/ert = template.leader_role

	equipAntagOnDummy(mannequin, ert)

	CHECK_TICK
	var/icon/preview_icon = icon('icons/effects/effects.dmi', "nothing")
	preview_icon.Scale(48+32, 16+32)
	CHECK_TICK
	mannequin.setDir(NORTH)
	var/icon/stamp = getFlatIcon(mannequin)
	CHECK_TICK
	preview_icon.Blend(stamp, ICON_OVERLAY, 25, 17)
	CHECK_TICK
	mannequin.setDir(WEST)
	stamp = getFlatIcon(mannequin)
	CHECK_TICK
	preview_icon.Blend(stamp, ICON_OVERLAY, 1, 9)
	CHECK_TICK
	mannequin.setDir(SOUTH)
	stamp = getFlatIcon(mannequin)
	CHECK_TICK
	preview_icon.Blend(stamp, ICON_OVERLAY, 49, 1)
	CHECK_TICK
	preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.
	CHECK_TICK
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_ADMIN)
	return preview_icon

/datum/admins/proc/makeEmergencyresponseteam(datum/ert/ertemplate = null)
	if (ertemplate)
		ertemplate = new ertemplate
	else
		ertemplate = new /datum/ert/centcom_official

	var/list/settings = list(
		"preview_callback" = CALLBACK(src, PROC_REF(makeERTPreviewIcon)),
		"mainsettings" = list(
		"template" = list("desc" = "Template", "callback" = CALLBACK(src, PROC_REF(makeERTTemplateModified)), "type" = "datum", "path" = "/datum/ert", "subtypesonly" = TRUE, "value" = ertemplate.type),
		"teamsize" = list("desc" = "Team Size", "type" = "number", "value" = ertemplate.teamsize),
		"mission" = list("desc" = "Mission", "type" = "string", "value" = ertemplate.mission),
		"polldesc" = list("desc" = "Ghost poll description", "type" = "string", "value" = ertemplate.polldesc),
		"open_armory" = list("desc" = "Open armory doors", "type" = "boolean", "value" = "[(ertemplate.opendoors ? "Yes" : "No")]"),
		)
	)

	var/list/prefreturn = presentpreflikepicker(usr,"Customize ERT", "Customize ERT", Button1="Ok", width = 600, StealFocus = 1,Timeout = 0, settings=settings)

	if (isnull(prefreturn))
		return FALSE

	if (prefreturn["button"] == 1)
		var/list/prefs = settings["mainsettings"]

		var/templtype = prefs["template"]["value"]
		if (!ispath(prefs["template"]["value"]))
			templtype = text2path(prefs["template"]["value"]) // new text2path ... doesn't compile in 511

		if (ertemplate.type != templtype)
			ertemplate = new templtype

		ertemplate.teamsize = prefs["teamsize"]["value"]
		ertemplate.mission = prefs["mission"]["value"]
		ertemplate.polldesc = prefs["polldesc"]["value"]
		ertemplate.enforce_human = FALSE
		ertemplate.opendoors = prefs["open_armory"]["value"] == "Yes" ? TRUE : FALSE

		var/list/mob/dead/observer/candidates = poll_ghost_candidates("Хотите быть в [ertemplate.polldesc]?", "deathsquad", null)
		var/teamSpawned = FALSE

		if(candidates.len > 0)
			//Pick the (un)lucky players
			var/numagents = min(ertemplate.teamsize,candidates.len)

			//Create team
			var/datum/team/ert/ert_team = new ertemplate.team
			if(ertemplate.rename_team)
				ert_team.name = ertemplate.rename_team

			//Asign team objective
			var/datum/objective/missionobj = new
			missionobj.team = ert_team
			missionobj.explanation_text = ertemplate.mission
			missionobj.completed = TRUE
			missionobj.reward = 20
			ert_team.objectives += missionobj
			ert_team.mission = missionobj

			var/list/spawnpoints = GLOB.emergencyresponseteamspawn
			var/index = 0
			while(numagents && candidates.len)
				var/spawnloc = spawnpoints[index+1]
				//loop through spawnpoints one at a time
				index = (index + 1) % spawnpoints.len
				var/mob/dead/observer/chosen_candidate = pick(candidates)
				candidates -= chosen_candidate
				if(!chosen_candidate.key)
					continue

				//Spawn the body
				var/mob/living/carbon/human/ERTOperative = new ertemplate.mobtype(spawnloc)
				chosen_candidate.client.prefs.copy_to(ERTOperative)
				ERTOperative.key = chosen_candidate.key

				if(ertemplate.enforce_human || !(ERTOperative.dna.species.changesource_flags & ERT_SPAWN)) // Don't want any exploding plasmemes
					ERTOperative.set_species(/datum/species/human)

				//Give antag datum
				var/datum/antagonist/ert/ert_antag

				if(numagents == 1)
					ert_antag = new ertemplate.leader_role
				else
					ert_antag = ertemplate.roles[WRAP(numagents,1,length(ertemplate.roles) + 1)]
					ert_antag = new ert_antag

				ERTOperative.mind.add_antag_datum(ert_antag,ert_team)
				ERTOperative.mind.assigned_role = ert_antag.name

				//Logging and cleanup
				log_game("[key_name(ERTOperative)] has been selected as an [ert_antag.name]")
				numagents--
				teamSpawned++

			if (teamSpawned)
				message_admins("[ertemplate.polldesc] has spawned with the mission: [ertemplate.mission]")

			//Open the Armory doors
			if(ertemplate.opendoors)
				for(var/obj/machinery/door/poddoor/ert/door in GLOB.airlocks)
					door.open()
					CHECK_TICK
			return TRUE
		else
			return FALSE

	return

//Abductors
/datum/admins/proc/makeAbductorTeam()
	new /datum/round_event/ghost_role/abductor
	return TRUE

/datum/admins/proc/makeRevenant()
	new /datum/round_event/ghost_role/revenant(TRUE, TRUE)
	return TRUE

/datum/admins/proc/makeNerd()
	var/spawnpoint = pick(GLOB.blobstart)
	var/list/mob/dead/observer/candidates
	var/mob/dead/observer/chosen_candidate
	var/mob/living/simple_animal/drone/nerd
	var/teamsize

	teamsize = input(usr, "How many drones?", "N.E.R.D. team size", 2) as num|null

	if(teamsize <= 0)
		return FALSE

	candidates = poll_ghost_candidates("Do you wish to be considered for a Nanotrasen emergency response drone?", "Drone")

	if(length(candidates) == 0)
		return FALSE

	while(length(candidates) && teamsize)
		chosen_candidate = pick(candidates)
		candidates -= chosen_candidate
		nerd = new /mob/living/simple_animal/drone(spawnpoint)
		nerd.key = chosen_candidate.key
		log_game("[key_name(nerd)] has been selected as a Nanotrasen emergency response drone")
		teamsize--

	return TRUE

/datum/admins/proc/makeCops()
	var/list/mob/dead/observer/candidates = poll_ghost_candidates("Устроим полицейский беспредел?", "deathsquad", null)
	var/list/mob/dead/observer/chosen = list()
	var/mob/dead/observer/theghost = null

	if(candidates.len)
		var/numcops = 6
		var/copscount = 0

		for(var/i = 0, i<numcops,i++)
			shuffle_inplace(candidates) //roll
			for(var/mob/j in candidates)
				if(!j || !j.client)
					candidates.Remove(j)
					continue

				theghost = j
				candidates.Remove(theghost)
				chosen += theghost
				copscount++
				break
		//Копы работают минимум вдвоем
		if(copscount < 2)
			return FALSE
		var/obj/structure/closet/supplypod/bluespacepod/banka = new()
		var/parking = find_safe_turf()
		for(var/mob/dead/observer/c in chosen)
			var/mob/living/carbon/human/cop = new(GLOB.newplayer_start)
			c.client.prefs.copy_to(cop)
			cop.key = c.key
			cop.mind.add_antag_datum(/datum/antagonist/ert/spacepol)
			cop.equipOutfit(/datum/outfit/spacepol)
			cop.forceMove(banka)
		new /obj/effect/pod_landingzone(parking, banka)
		priority_announce("Внимание, в вашем районе проходит облава.", sound('white/alexs410/sound/manhunt.ogg'), sender_override = "Главное управление Спецотряда")
		return TRUE
