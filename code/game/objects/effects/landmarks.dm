/obj/effect/landmark
	name = "landmark"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	anchored = TRUE
	layer = TURF_LAYER
	plane = GAME_PLANE
	invisibility = INVISIBILITY_ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/effect/landmark/singularity_act()
	return

/obj/effect/landmark/singularity_pull()
	return

INITIALIZE_IMMEDIATE(/obj/effect/landmark)

/obj/effect/landmark/Initialize(mapload)
	. = ..()
	GLOB.landmarks_list += src

/obj/effect/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "x"
	anchored = TRUE
	layer = MOB_LAYER
	var/jobspawn_override = FALSE
	var/delete_after_roundstart = TRUE
	var/used = FALSE

/obj/effect/landmark/start/proc/after_round_start()
	if(delete_after_roundstart)
		qdel(src)

/obj/effect/landmark/start/Initialize(mapload)
	. = ..()
	GLOB.start_landmarks_list += src
	if(jobspawn_override)
		LAZYADDASSOCLIST(GLOB.jobspawn_overrides, name, src)
	if(name != "start")
		tag = "start*[name]"

/obj/effect/landmark/start/Destroy()
	GLOB.start_landmarks_list -= src
	if(jobspawn_override)
		LAZYREMOVEASSOC(GLOB.jobspawn_overrides, name, src)
	return ..()

// START LANDMARKS FOLLOW. Don't change the names unless
// you are refactoring shitty landmark code.
/obj/effect/landmark/start/assistant
	name = JOB_ASSISTANT
	icon_state = JOB_ASSISTANT //icon_state is case sensitive. why are all of these capitalized? because fuck you that's why

/obj/effect/landmark/start/combatant
	name = "Combantant"
	icon_state = JOB_ASSISTANT
	jobspawn_override = TRUE
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/combatant/red
	name = JOB_COMBATANT_RED
	color = "#ff0000"

/obj/effect/landmark/start/combatant/blue
	name = JOB_COMBATANT_BLUE
	color = "#0000ff"

/obj/effect/landmark/start/assistant/override
	jobspawn_override = TRUE
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/prisoner
	name = JOB_PRISONER
	icon_state = JOB_PRISONER
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/freelancer
	name = JOB_FREELANCER
	icon_state = JOB_FREELANCER
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/bomj
	name = JOB_BOMJ
	icon_state = JOB_PRISONER

/obj/effect/landmark/start/janitor
	name = JOB_JANITOR
	icon_state = JOB_JANITOR

/obj/effect/landmark/start/cargo_technician
	name = JOB_CARGO_TECHNICIAN
	icon_state = JOB_CARGO_TECHNICIAN

/obj/effect/landmark/start/bartender
	name = JOB_BARTENDER
	icon_state = JOB_BARTENDER

/obj/effect/landmark/start/clown
	name = JOB_CLOWN
	icon_state = JOB_CLOWN

/obj/effect/landmark/start/mime
	name = JOB_MIME
	icon_state = JOB_MIME

/obj/effect/landmark/start/quartermaster
	name = JOB_QUARTERMASTER
	icon_state = JOB_QUARTERMASTER

/obj/effect/landmark/start/atmospheric_technician
	name = JOB_ATMOSPHERIC_TECHNICIAN
	icon_state = JOB_ATMOSPHERIC_TECHNICIAN

/obj/effect/landmark/start/cook
	name = JOB_COOK
	icon_state = JOB_COOK

/obj/effect/landmark/start/shaft_miner
	name = JOB_SHAFT_MINER
	icon_state = JOB_SHAFT_MINER

/obj/effect/landmark/start/hunter
	name = JOB_HUNTER
	icon_state = JOB_SHAFT_MINER

/obj/effect/landmark/start/exploration
	name = JOB_RANGER
	icon_state = JOB_RANGER

/obj/effect/landmark/start/security_officer
	name = JOB_SECURITY_OFFICER
	icon_state = JOB_SECURITY_OFFICER

/obj/effect/landmark/start/botanist
	name = JOB_BOTANIST
	icon_state = JOB_BOTANIST

/obj/effect/landmark/start/head_of_security
	name = JOB_HEAD_OF_SECURITY
	icon_state = JOB_HEAD_OF_SECURITY

/obj/effect/landmark/start/captain
	name = JOB_CAPTAIN
	icon_state = JOB_CAPTAIN

/obj/effect/landmark/start/detective
	name = JOB_DETECTIVE
	icon_state = JOB_DETECTIVE

/obj/effect/landmark/start/warden
	name = JOB_WARDEN
	icon_state = JOB_WARDEN

/obj/effect/landmark/start/chief_engineer
	name = JOB_CHIEF_ENGINEER
	icon_state = JOB_CHIEF_ENGINEER

/obj/effect/landmark/start/head_of_personnel
	name = JOB_HEAD_OF_PERSONNEL
	icon_state = JOB_HEAD_OF_PERSONNEL

/obj/effect/landmark/start/librarian
	name = JOB_CURATOR
	icon_state = JOB_CURATOR

/obj/effect/landmark/start/lawyer
	name = JOB_LAWYER
	icon_state = JOB_LAWYER

/obj/effect/landmark/start/station_engineer
	name = JOB_STATION_ENGINEER
	icon_state = JOB_STATION_ENGINEER

/obj/effect/landmark/start/mechanic
	name = JOB_MECHANIC
	icon_state = JOB_STATION_ENGINEER

/obj/effect/landmark/start/medical_doctor
	name = JOB_MEDICAL_DOCTOR
	icon_state = JOB_MEDICAL_DOCTOR

/obj/effect/landmark/start/field_medic
	name = JOB_FIELD_MEDIC
	icon_state = JOB_FIELD_MEDIC

/obj/effect/landmark/start/specialist
	name = JOB_SPECIALIST
	icon_state = JOB_SPECIALIST

/obj/effect/landmark/start/paramedic
	name = JOB_PARAMEDIC
	icon_state = JOB_PARAMEDIC

/obj/effect/landmark/start/scientist
	name = JOB_SCIENTIST
	icon_state = JOB_SCIENTIST

/obj/effect/landmark/start/chemist
	name = JOB_CHEMIST
	icon_state = JOB_CHEMIST

/obj/effect/landmark/start/roboticist
	name = JOB_ROBOTICIST
	icon_state = JOB_ROBOTICIST

/obj/effect/landmark/start/research_director
	name = JOB_RESEARCH_DIRECTOR
	icon_state = JOB_RESEARCH_DIRECTOR

/obj/effect/landmark/start/geneticist
	name = JOB_GENETICIST
	icon_state = JOB_GENETICIST

/obj/effect/landmark/start/chief_medical_officer
	name = JOB_CHIEF_MEDICAL_OFFICER
	icon_state = JOB_CHIEF_MEDICAL_OFFICER

/obj/effect/landmark/start/virologist
	name = JOB_VIROLOGIST
	icon_state = JOB_VIROLOGIST

/obj/effect/landmark/start/psychologist
	name = JOB_PSYCHOLOGIST
	icon_state = JOB_PSYCHOLOGIST

/obj/effect/landmark/start/chaplain
	name = JOB_CHAPLAIN
	icon_state = JOB_CHAPLAIN

/obj/effect/landmark/start/cyborg
	name = JOB_CYBORG
	icon_state = JOB_CYBORG

/obj/effect/landmark/start/ai
	name = JOB_AI
	icon_state = JOB_AI
	delete_after_roundstart = FALSE
	var/primary_ai = TRUE
	var/latejoin_active = TRUE

/obj/effect/landmark/start/ai/after_round_start()
	if(latejoin_active && !used)
		new /obj/structure/ai_core/latejoin_inactive(loc)
	return ..()

/obj/effect/landmark/start/ai/secondary
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "ai_spawn"
	primary_ai = FALSE
	latejoin_active = FALSE

//Department Security spawns

/obj/effect/landmark/start/depsec
	name = "department_sec"
	icon_state = JOB_SECURITY_OFFICER

/obj/effect/landmark/start/depsec/New()
	..()
	GLOB.department_security_spawns += src

/obj/effect/landmark/start/depsec/Destroy()
	GLOB.department_security_spawns -= src
	return ..()

/obj/effect/landmark/start/depsec/supply
	name = "supply_sec"

/obj/effect/landmark/start/depsec/medical
	name = "medical_sec"

/obj/effect/landmark/start/depsec/engineering
	name = "engineering_sec"

/obj/effect/landmark/start/depsec/science
	name = "science_sec"

//Antagonist spawns

/obj/effect/landmark/start/wizard
	name = "wizard"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "wiznerd_spawn"

/obj/effect/landmark/start/wizard/Initialize(mapload)
	..()
	GLOB.wizardstart += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/nukeop
	name = "nukeop"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_spawn"

/obj/effect/landmark/start/nukeop/Initialize(mapload)
	..()
	GLOB.nukeop_start += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/nukeop_leader
	name = "nukeop leader"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_leader_spawn"

/obj/effect/landmark/start/nukeop_leader/Initialize(mapload)
	..()
	GLOB.nukeop_leader_start += loc
	return INITIALIZE_HINT_QDEL

// Must be immediate because players will
// join before SSatom initializes everything.
INITIALIZE_IMMEDIATE(/obj/effect/landmark/start/new_player)

/obj/effect/landmark/start/new_player
	name = "New Player"

/obj/effect/landmark/start/new_player/Initialize(mapload)
	..()
	GLOB.newplayer_start += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/latejoin
	name = "JoinLate"

/obj/effect/landmark/latejoin/Initialize(mapload)
	..()
	SSjob.latejoin_trackers += loc
	return INITIALIZE_HINT_QDEL

//space carps, magicarps, lone ops, slaughter demons, possibly revenants spawn here
/obj/effect/landmark/carpspawn
	name = "carpspawn"
	icon_state = "carp_spawn"

//observer start
/obj/effect/landmark/observer_start
	name = "Observer-Start"
	icon_state = "observer_start"

//xenos, morphs and nightmares spawn here
/obj/effect/landmark/xeno_spawn
	name = "xeno_spawn"
	icon_state = "xeno_spawn"

/obj/effect/landmark/xeno_spawn/Initialize(mapload)
	..()
	GLOB.xeno_spawn += loc
	return INITIALIZE_HINT_QDEL

//objects with the stationloving component (nuke disk) respawn here.
//also blobs that have their spawn forcemoved (running out of time when picking their spawn spot) and santa
/obj/effect/landmark/blobstart
	name = "blobstart"
	icon_state = "blob_start"

/obj/effect/landmark/blobstart/Initialize(mapload)
	..()
	GLOB.blobstart += loc
	return INITIALIZE_HINT_QDEL

//spawns sec equipment lockers depending on the number of sec officers
/obj/effect/landmark/secequipment
	name = "secequipment"
	icon_state = "secequipment"

/obj/effect/landmark/secequipment/Initialize(mapload)
	..()
	GLOB.secequipment += loc
	return INITIALIZE_HINT_QDEL

//players that get put in admin jail show up here
/obj/effect/landmark/prisonwarp
	name = "prisonwarp"
	icon_state = "prisonwarp"

/obj/effect/landmark/prisonwarp/Initialize(mapload)
	..()
	GLOB.prisonwarp += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/ert_spawn
	name = "Emergencyresponseteam"
	icon_state = "ert_spawn"

/obj/effect/landmark/ert_spawn/Initialize(mapload)
	..()
	GLOB.emergencyresponseteamspawn += loc
	return INITIALIZE_HINT_QDEL

//ninja energy nets teleport victims here
/obj/effect/landmark/holding_facility
	name = "Holding Facility"
	icon_state = "holding_facility"

/obj/effect/landmark/holding_facility/Initialize(mapload)
	..()
	GLOB.holdingfacility += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/observe
	name = "tdomeobserve"
	icon_state = "tdome_observer"

/obj/effect/landmark/thunderdome/observe/Initialize(mapload)
	..()
	GLOB.tdomeobserve += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/one
	name = "tdome1"
	icon_state = "tdome_t1"

/obj/effect/landmark/thunderdome/one/Initialize(mapload)
	..()
	GLOB.tdome1	+= loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/two
	name = "tdome2"
	icon_state = "tdome_t2"

/obj/effect/landmark/thunderdome/two/Initialize(mapload)
	..()
	GLOB.tdome2 += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/admin
	name = "tdomeadmin"
	icon_state = "tdome_admin"

/obj/effect/landmark/thunderdome/admin/Initialize(mapload)
	..()
	GLOB.tdomeadmin += loc
	return INITIALIZE_HINT_QDEL

//Servant spawn locations
/obj/effect/landmark/servant_of_ratvar
	name = "servant of ratvar spawn"
	icon_state = "clockwork_orange"
	layer = MOB_LAYER

/obj/effect/landmark/servant_of_ratvar/Initialize(mapload)
	..()
	GLOB.servant_spawns += loc
	return INITIALIZE_HINT_QDEL

//City of Cogs entrances
/obj/effect/landmark/city_of_cogs
	name = "city of cogs entrance"
	icon_state = "city_of_cogs"

/obj/effect/landmark/city_of_cogs/Initialize(mapload)
	..()
	GLOB.city_of_cogs_spawns += loc
	return INITIALIZE_HINT_QDEL

//generic event spawns
/obj/effect/landmark/event_spawn
	name = "generic event spawn"
	icon_state = "generic_event"
	layer = OBJ_LAYER


/obj/effect/landmark/event_spawn/New()
	..()
	GLOB.generic_event_spawns += src

/obj/effect/landmark/event_spawn/Destroy()
	GLOB.generic_event_spawns -= src
	return ..()

/obj/effect/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/obj/effect/landmark/ruin/New(loc, my_ruin_template)
	name = "ruin_[GLOB.ruin_landmarks.len + 1]"
	..(loc)
	ruin_template = my_ruin_template
	GLOB.ruin_landmarks |= src

/obj/effect/landmark/ruin/Destroy()
	GLOB.ruin_landmarks -= src
	ruin_template = null
	. = ..()

// handled in portals.dm, id connected to one-way portal
/obj/effect/landmark/portal_exit
	name = "portal exit"
	icon_state = "portal_exit"
	var/id

// yohei shit beacon
/obj/effect/landmark/yohei_beacon
	name = "yohei beacon"
	icon_state = "generic_event"

/obj/effect/landmark/yohei_beacon/New()
	..()
	GLOB.yohei_beacons += src

/obj/effect/landmark/yohei_beacon/Destroy()
	GLOB.yohei_beacons -= src
	return ..()

/obj/effect/landmark/bomb_plant_location
	name = "bomb plant marker"
	icon_state = "x"

/obj/effect/landmark/bomb_plant_location/New()
	..()
	GLOB.violence_bomb_locations += src

/obj/effect/landmark/bomb_plant_location/Destroy()
	GLOB.violence_bomb_locations -= src
	return ..()

/// Marks the bottom left of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_bottom_left
	name = "unit test zone bottom left"

/// Marks the top right of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_top_right
	name = "unit test zone top right"
