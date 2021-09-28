#define LIGHT_HEAL_THRESHOLD 2
#define LIGHT_DAMAGE_TAKEN 7
#define LIGHT_DAM_THRESHOLD 0.25

#define ANTAG_DATUM_THRALL		/datum/antagonist/thrall
#define ANTAG_DATUM_SLING		/datum/antagonist/shadowling

/*
SHADOWLING: A gamemode based on previously-run events
Aliens called shadowlings are on the station.
These shadowlings can 'enthrall' crew members and enslave them.
They also burn in the light but heal rapidly whilst in the dark.
The game will end under two conditions:
	1. The shadowlings die
	2. The emergency shuttle docks at CentCom
Shadowling strengths:
	- The dark
	- Hard vacuum (They are not affected by it, but are affected by starlight!)
	- Their thralls who are not harmed by the light
	- Stealth
Shadowling weaknesses:
	- The light
	- Fire
	- Enemy numbers
	- Burn-based weapons and items (flashbangs, lasers, etc.)
Shadowlings start off disguised as normal crew members, and they only have two abilities: Hatch and Enthrall.
They can still enthrall and perhaps complete their objectives in this form.
Hatch will, after a short time, cast off the human disguise and assume the shadowling's true identity.
They will then assume the normal shadowling form and gain their abilities.
The shadowling will seem OP, and that's because it kinda is. Being restricted to the dark while being alone most of the time is extremely difficult and as such the shadowling needs powerful abilities.
Made by Xhuis
*/
/*
	GAMEMODE
*/
/datum/game_mode
	var/list/datum/mind/shadows = list()
	var/list/datum/mind/thralls = list()
	var/required_thralls = 10 //How many thralls are needed (this is changed in pre_setup, so it scales based on pop)
	var/shadowling_ascended = FALSE //If at least one shadowling has ascended
	var/thrall_ratio = 1

/datum/game_mode/proc/replace_jobbaned_player(mob/living/M, role_type, pref)
	var/list/mob/dead/observer/candidates = poll_candidates_for_mob("Do you want to play as a [role_type]?", "[role_type]", null, pref, 50, M)
	var/mob/dead/observer/theghost = null
	if(candidates.len)
		theghost = pick(candidates)
		to_chat(M, "Your mob has been taken over by a ghost! Appeal your job ban if you want to avoid this in the future!")
		message_admins("[key_name_admin(theghost)] has taken control of ([key_name_admin(M)]) to replace a jobbaned player.")
		M.ghostize(0)
		M.key = theghost.key

/datum/game_mode/shadowling
	name = "shadowling"
	config_tag = "shadowling"
	antag_flag = ROLE_SHADOWLING
	required_players = 15
	required_enemies = 1
	recommended_enemies = 3
	enemy_minimum_age = 14
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Security Officer", "Russian Officer", "Veteran", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Research Director", "Chief Engineer", "Chief Medical Officer")

/datum/game_mode/shadowling/announce()
	to_chat(world, "<b>The current game mode is - Shadowling!</b>")
	to_chat(world, "<b>There are alien <span class='shadowling'>shadowlings</span> on the station. Crew: Kill the shadowlings before they can enthrall the crew. Shadowlings: Enthrall the crew while remaining in hiding.</b>")

/datum/game_mode/shadowling/pre_setup()
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs
	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += "Assistant"
	var/shadowlings = max(3, round(num_players()/14))
	while(shadowlings)
		var/datum/mind/shadow = pick(antag_candidates)
		shadows += shadow
		antag_candidates -= shadow
		shadow.special_role = "Shadowling"
		shadow.restricted_roles = restricted_jobs
		shadowlings--
	var/thrall_scaling = round(num_players() / 3)
	required_thralls = clamp(thrall_scaling, 15, 30)
	thrall_ratio = required_thralls / 15
	return TRUE

/datum/game_mode/shadowling/generate_report()
	return "В вашем районе наблюдались странные инопланетные существа. Эти \
	инопланетяне якобы обладают способностью порабощать ничего не подозревающих \
	людей и лишать их власти. Остерегайтесь темных участков и следите за тем, \
	чтобы все источники света были в хорошем состоянии. Внимательно следите \
	за всем экипажем на предмет подозрительного поведения и выполняйте операцию \
	по освобождению от рабства, если у них есть очевидные подсказки. Изучите все \
	сообщения о необычных или подозрительных случаях обнаружения в ходе технического обслуживания."

/datum/game_mode/shadowling/post_setup()
	for(var/T in shadows)
		var/datum/mind/shadow = T
		log_game("[shadow.key] (ckey) has been selected as a Shadowling.")
		shadow.current.add_sling()
	. = ..()
	return

/datum/game_mode/shadowling/proc/check_shadow_victory()
	return shadowling_ascended

/datum/game_mode/shadowling/proc/check_shadow_death()
	for(var/SM in get_antag_minds(/datum/antagonist/shadowling))
		var/datum/mind/shadow_mind = SM
		if(istype(shadow_mind))
			var/turf/T = get_turf(shadow_mind.current)
			if((shadow_mind) && (shadow_mind.current.stat != DEAD) && T && is_station_level(T.z) && ishuman(shadow_mind.current))
				return FALSE
	return TRUE

/datum/game_mode/shadowling/check_finished()
	. = ..()
	if(check_shadow_death())
		return TRUE

/datum/game_mode/proc/auto_declare_completion_shadowling()
	var/text = ""
	if(shadows.len)
		text += "<br><span class='big'><b>The shadowlings were:</b></span>"
		for(var/S in shadows)
			var/datum/mind/shadow = S
			text += printplayer(shadow)
		text += "<br>"
		if(thralls.len)
			text += "<br><span class='big'><b>The thralls were:</b></span>"
			for(var/T in thralls)
				var/datum/mind/thrall = T
				text += printplayer(thrall)
	text += "<br>"
	to_chat(world, text)

/datum/game_mode/shadowling/set_round_result()
	..()
	if(check_shadow_victory())
		SSticker.mode_result = "win - shadowlings have ascended"
	else
		SSticker.mode_result = "loss - staff stopped the shadowlings"

/*
	MISCELLANEOUS
*/
/datum/species/shadow/ling
	//Normal shadowpeople but with enhanced effects
	name = "Shadowling"
	id = "shadowling"
	say_mod = "шепелявит"
	species_traits = list(NOBLOOD,NO_UNDERWEAR,NO_DNA_COPY,NOTRANSSTING,NOEYESPRITES,TRAIT_NOFLASH)
	inherent_traits = list(TRAIT_NOGUNS, TRAIT_RESISTCOLD, TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE, TRAIT_NOBREATH, TRAIT_RADIMMUNE, TRAIT_VIRUSIMMUNE, TRAIT_PIERCEIMMUNE)
	no_equip = list(ITEM_SLOT_MASK, ITEM_SLOT_EYES, ITEM_SLOT_GLOVES, ITEM_SLOT_FEET, ITEM_SLOT_ICLOTHING, ITEM_SLOT_OCLOTHING)
	nojumpsuit = TRUE
	mutanteyes = /obj/item/organ/eyes/night_vision/alien/sling
	burnmod = 1.5 //1.5x burn damage, 2x is excessive
	heatmod = 1.5
	var/mutable_appearance/eyes_overlay
	var/shadow_charges = 3
	var/last_charge = 0

/datum/species/shadow/ling/on_species_gain(mob/living/carbon/human/C)
	C.draw_custom_races(TRUE)
	eyes_overlay = mutable_appearance('white/valtos/icons/sling.dmi', "eyes", 25)
	C.add_overlay(eyes_overlay)
	. = ..()

/datum/species/shadow/ling/on_species_loss(mob/living/carbon/human/C)
	C.draw_custom_races(FALSE)
	if(eyes_overlay)
		C.cut_overlay(eyes_overlay)
		QDEL_NULL(eyes_overlay)
	. = ..()

/datum/species/shadow/ling/spec_life(mob/living/carbon/human/H)
	H.nutrition = NUTRITION_LEVEL_WELL_FED //i aint never get hongry
	if(isturf(H.loc))
		var/turf/T = H.loc
		var/light_amount = T.get_lumcount()
		if(light_amount > LIGHT_DAM_THRESHOLD) //Can survive in very small light levels. Also doesn't take damage while incorporeal, for shadow walk purposes
			H.take_overall_damage(0, LIGHT_DAMAGE_TAKEN)
			if(H.stat != DEAD)
				to_chat(H, span_userdanger("The light burns you!")) //Message spam to say "GET THE FUCK OUT"
				H.playsound_local(get_turf(H), 'sound/weapons/sear.ogg', 150, 1, pressure_affected = FALSE)
		else if (light_amount < LIGHT_HEAL_THRESHOLD  && !istype(H.loc, /obj/effect/dummy/phased_mob/shadowling)) //Can't heal while jaunting
			H.heal_overall_damage(5,5)
			H.adjustToxLoss(-5)
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN, -25) //Shad O. Ling gibbers, "CAN U BE MY THRALL?!!"
			H.adjustCloneLoss(-1)
			H.SetKnockdown(0)
			H.SetStun(0)
			H.SetParalyzed(0)
	var/charge_time = 400 - ((SSticker.mode.thralls && SSticker.mode.thralls.len) || 0)*10
	if(world.time >= charge_time+last_charge)
		shadow_charges = min(shadow_charges + 1, 3)
		last_charge = world.time

/datum/species/shadow/ling/bullet_act(obj/projectile/P, mob/living/carbon/human/H)
	var/turf/T = H.loc
	if(istype(T) && shadow_charges > 0)
		var/light_amount = T.get_lumcount()
		if(light_amount < LIGHT_DAM_THRESHOLD)
			H.visible_message(span_danger("The shadows around [H] ripple as they absorb [P]!"))
			playsound(T, "bullet_miss", 75, 1)
			shadow_charges = min(shadow_charges - 1, 0)
			return -1
	return 0

/datum/species/shadow/ling/lesser //Empowered thralls. Obvious, but powerful
	name = "Lesser Shadowling"
	id = "l_shadowling"
	say_mod = "шепелявит"
	species_traits = list(NOBLOOD,NO_DNA_COPY,NOTRANSSTING,NOEYESPRITES,TRAIT_NOFLASH)
	inherent_traits = list(TRAIT_NOBREATH, TRAIT_RADIMMUNE)
	burnmod = 1.1
	heatmod = 1.1

/datum/species/shadow/ling/lesser/spec_life(mob/living/carbon/human/H)
	H.nutrition = NUTRITION_LEVEL_WELL_FED //i aint never get hongry
	if(isturf(H.loc))
		var/turf/T = H.loc
		var/light_amount = T.get_lumcount()
		if(light_amount > LIGHT_DAM_THRESHOLD && !H.incorporeal_move)
			H.take_overall_damage(0, LIGHT_DAMAGE_TAKEN/2)
		else if (light_amount < LIGHT_HEAL_THRESHOLD)
			H.heal_overall_damage(3,3)
			H.adjustToxLoss(-5)
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN, -25)
			H.adjustCloneLoss(-1)

/datum/game_mode/proc/update_shadow_icons_added(datum/mind/shadow_mind)
	var/datum/atom_hud/antag/shadow_hud = GLOB.huds[ANTAG_HUD_SHADOW]
	shadow_hud.join_hud(shadow_mind.current)
	set_antag_hud(shadow_mind.current, ((is_shadow(shadow_mind.current)) ? "shadowling" : "thrall"))

/datum/game_mode/proc/update_shadow_icons_removed(datum/mind/shadow_mind)
	var/datum/atom_hud/antag/shadow_hud = GLOB.huds[ANTAG_HUD_SHADOW]
	shadow_hud.leave_hud(shadow_mind.current)
	set_antag_hud(shadow_mind.current, null)

/mob/living/proc/add_thrall()
	if(!istype(mind))
		return FALSE
	return mind.add_antag_datum(ANTAG_DATUM_THRALL)

/mob/living/proc/add_sling()
	if(!istype(mind))
		return FALSE
	return mind.add_antag_datum(ANTAG_DATUM_SLING)

/mob/living/proc/remove_thrall()
	if(!istype(mind))
		return FALSE
	return mind.remove_antag_datum(ANTAG_DATUM_THRALL)

/mob/living/proc/remove_sling()
	if(!istype(mind))
		return FALSE
	return mind.remove_antag_datum(ANTAG_DATUM_SLING)
/*
/datum/antagonist/shadowling/roundend_report()
	var/list/round_credits = list()
	var/len_before_addition

	round_credits += "<center><h1>The Shadowlings:</h1>"
	len_before_addition = round_credits.len
	for(var/datum/antagonist/shadowling/shadow in GLOB.antagonists)
		round_credits += "<center><h2>[printplayer(shadow.owner)]</h2>"
	if(len_before_addition == round_credits.len)
		round_credits += list("<center><h2>The Shadowlings have moved to the shadows!</h2>", "<center><h2>We couldn't locate them!</h2>")
	round_credits += "<br>"

	round_credits += ..()
	return round_credits
*/
////////////////////
/////BODYPARTS/////
////////////////////
/obj/item/bodypart
	var/should_draw_custom_races = FALSE

/mob/living/carbon/proc/draw_custom_races(do_it)
	for(var/O in bodyparts)
		var/obj/item/bodypart/B = O
		B.should_draw_custom_races = do_it

/datum/species
	var/yogs_draw_robot_hair = FALSE //DAMN ROBOTS STEALING OUR HAIR AND AIR
	var/yogs_virus_infect_chance = 100
	var/virus_resistance_boost = 0
	var/virus_stealth_boost = 0
	var/virus_stage_rate_boost = 0
	var/virus_transmittable_boost = 0

/datum/species/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	if(yogs_draw_robot_hair)
		for(var/obj/item/bodypart/BP in C.bodyparts)
			BP.yogs_draw_robot_hair = TRUE

/datum/species/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	for(var/obj/item/bodypart/BP in C.bodyparts)
		BP.yogs_draw_robot_hair = initial(BP.yogs_draw_robot_hair)

/datum/species/proc/spec_AltClickOn(atom/A,mob/living/carbon/human/H)
	return FALSE



/obj/item/bodypart
	var/yogs_draw_robot_hair = FALSE

/datum/mood_event/thrall
	description = "<span class='shadowling'><i>The darkness is true. I love them. I love the masters.</i></span>\n"
	mood_change = 40

/datum/mood_event/sling
	description = "<span class='shadowling'><b>The keys to reality are within my grasp.</b></span>\n"
	mood_change = 20
