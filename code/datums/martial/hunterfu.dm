#define BODYSLAM_COMBO "GH"
#define STAKESTAB_COMBO "HH"
#define NECKSNAP_COMBO "GDH"
#define HOLYKICK_COMBO "DG"

// From CQC.dm
/datum/martial_art/hunterfu
	name = "Hunter-Fu"
	id = MARTIALART_HUNTERFU
	help_verb = /mob/living/carbon/human/proc/hunterfu_help
	block_chance = 60
	allow_temp_override = TRUE
	var/old_grab_state = null

/datum/martial_art/hunterfu/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak, BODYSLAM_COMBO))
		streak = ""
		body_slam(A, D)
		return TRUE
	if(findtext(streak, STAKESTAB_COMBO))
		streak = ""
		stake_stab(A, D)
		return TRUE
	if(findtext(streak, NECKSNAP_COMBO))
		streak = ""
		neck_snap(A, D)
		return TRUE
	if(findtext(streak, HOLYKICK_COMBO))
		streak = ""
		holy_kick(A, D)
		return TRUE
	return FALSE

/datum/martial_art/hunterfu/proc/body_slam(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(D.mobility_flags & MOBILITY_STAND)
		D.visible_message(
			"<span class='danger'>[A] slams both them and [D] into the ground!</span>",
			"<span class='userdanger'>You're slammed into the ground by [A]!</span>",
			"<span class='hear'>Слышу звук разрывающейся плоти!</span>",
		)
		to_chat(A, "<span class='danger'>You slam [D] into the ground!</span>")
		playsound(get_turf(A), 'sound/weapons/slam.ogg', 50, TRUE, -1)
		log_combat(A, D, "bodyslammed (Hunter-Fu)")
		if(!D.mind)
			D.Paralyze(40)
			A.Paralyze(25)
			return TRUE
		if(D.mind.has_antag_datum(/datum/antagonist/changeling))
			to_chat(D, "<span class='cultlarge'>Our DNA shakes as we are body slammed!</span>")
			D.apply_damage(A.dna.species.punchdamagehigh + 5, BRUTE)	//15 damage
			D.Paralyze(60)
			A.Paralyze(25)
			return TRUE
		else
			D.Paralyze(40)
			A.Paralyze(25)
	else
		harm_act(A, D)
	return TRUE

/datum/martial_art/hunterfu/proc/stake_stab(mob/living/carbon/human/A, mob/living/carbon/human/D)
	D.visible_message(
		"<span class='danger'>[A] stabs [D] in the heart!</span>",
		"<span class='userdanger'>You're staked in the heart by [A]!</span>",
		"<span class='hear'>Слышу звук разрывающейся плоти!</span>",
	)
	to_chat(A, "<span class='danger'>You stab [D] viciously!</span>")
	playsound(get_turf(A), 'sound/weapons/bladeslice.ogg', 50, TRUE, -1)
	log_combat(A, D, "stakestabbed (Hunter-Fu)")
	var/stake_damagehigh = A.dna.species.punchdamagehigh * 1.5 + 10	//25 damage
	if(!D.mind)
		D.apply_damage(A.dna.species.punchdamagehigh + 5, BRUTE, BODY_ZONE_CHEST)	//15 damage
		return TRUE
	if(D.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(D, "<span class='danger'>Their arm tears through our monstrous form!</span>")
		D.apply_damage(stake_damagehigh, BRUTE, BODY_ZONE_CHEST)
		return TRUE
	if(D.mind.has_antag_datum(/datum/antagonist/bloodsucker))
		to_chat(D, "<span class='cultlarge'>Their arm stakes straight into our undead flesh!</span>")
		D.apply_damage(A.dna.species.punchdamagehigh + 10, BURN)				//20 damage
		D.apply_damage(A.dna.species.punchdamagehigh, BRUTE, BODY_ZONE_CHEST)	//10 damage
		return TRUE
	else
		D.apply_damage(A.dna.species.punchdamagehigh + 5, BRUTE, BODY_ZONE_CHEST)	//15 damage
	return TRUE

/datum/martial_art/hunterfu/proc/neck_snap(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat)
		D.visible_message(
			"<span class='danger'>[A] snapped [D]'s neck!</span>",
			"<span class='userdanger'>Your neck is snapped by [A]!</span>",
			"<span class='hear'>You hear a snap!</span>",
		)
		to_chat(A, "<span class='danger'>You snap [D]'s neck!</span>")
		playsound(get_turf(A), 'sound/effects/snap.ogg', 50, TRUE, -1)
		log_combat(A, D, "neck snapped (Hunter-Fu)")
		if(!D.mind)
			D.SetSleeping(30)
			playsound(get_turf(A), 'sound/effects/snap.ogg', 50, TRUE, -1)
			log_combat(A, D, "neck snapped (Hunter-Fu)")
			return TRUE
		if(D.mind.has_antag_datum(/datum/antagonist/changeling))
			to_chat(D, "<span class='warning'>Our monstrous form protects us from being put to sleep!</span>")
			return TRUE
		if(D.mind.has_antag_datum(/datum/antagonist/heretic))
			to_chat(D, "<span class='cultlarge'>The power of the Codex Cicatrix flares as we are swiftly put to sleep!</span>")
			D.apply_damage(A.dna.species.punchdamagehigh + 5, BRUTE, BODY_ZONE_HEAD)	//15 damage
			D.SetSleeping(40)
			return TRUE
		if(D.mind.has_antag_datum(/datum/antagonist/bloodsucker))
			to_chat(D, "<span class='warning'>Our undead form protects us from being put to sleep!</span>")
			return TRUE
		else
			D.SetSleeping(30)
	return TRUE

/datum/martial_art/hunterfu/proc/holy_kick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	D.visible_message(
		"<span class='warning'>[A] kicks [D], splashing holy water in every direction!</span>",
		"<span class='userdanger'>You're kicked by [A], with holy water dripping down on you!</span>",
		"<span class='hear'>Слышу звук разрывающейся плоти!</span>",
	)
	to_chat(A, "<span class='danger'>You holy kick [D]!</span>")
	playsound(get_turf(A), 'sound/weapons/slash.ogg', 50, TRUE, -1)
	log_combat(A, D, "holy kicked (Hunter-Fu)")
	var/holykick_staminadamage = A.dna.species.punchdamagehigh * 3 + 30 //60 damage (holy shit)
	var/holykick_hereticburn = A.dna.species.punchdamagehigh * 1.5 + 10	//25 damage
	if(!D.mind)
		D.apply_damage(holykick_staminadamage, STAMINA)
		D.Paralyze(20)
		return TRUE
	if(D.mind.has_antag_datum(/datum/antagonist/heretic))
		to_chat(D, "<span class='cultlarge'>The holy water burns our flesh!</span>")
		D.apply_damage(holykick_hereticburn, BURN)
		D.apply_damage(holykick_staminadamage, STAMINA)
		D.Paralyze(20)
		return TRUE
	if(D.mind.has_antag_datum(/datum/antagonist/bloodsucker))
		to_chat(D, "<span class='warning'>This just seems like regular water...</span>")
		return TRUE
	if(D.mind.has_antag_datum(/datum/antagonist/cult))
		for(var/datum/action/innate/cult/blood_magic/BD in D.actions)
			to_chat(D, "<span class='cultlarge'>Our blood rites falter as the holy water drips onto our body!</span>")
			for(var/datum/action/innate/cult/blood_spell/BS in BD.spells)
				qdel(BS)
		D.apply_damage(holykick_staminadamage, STAMINA)
		D.Paralyze(20)
		return TRUE
	if(D.mind.has_antag_datum(/datum/antagonist/wizard) || (/datum/antagonist/wizard/apprentice))
		to_chat(D, "<span class='danger'>The holy water seems to be muting us somehow!</span>")
		if(D.silent <= 10)
			D.silent = clamp(D.silent + 10, 0, 10)
		D.apply_damage(holykick_staminadamage, STAMINA)
		D.Paralyze(20)
		return TRUE
	else
		D.apply_damage(holykick_staminadamage, STAMINA)
		D.Paralyze(20)
	return TRUE

/// Intents
/datum/martial_art/hunterfu/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D", D)
	if(check_streak(A, D))
		return TRUE
	log_combat(A, D, "disarmed (Hunter-Fu)")
	return ..()

/datum/martial_art/hunterfu/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H", D)
	if(check_streak(A, D))
		return TRUE
	var/obj/item/bodypart/affecting = D.get_bodypart(ran_zone(A.zone_selected))
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	var/atk_verb = pick("kick", "chop", "hit", "slam")
	var/harm_damage = A.dna.species.punchdamagehigh + rand(0,5)	//10-15 damage
	D.visible_message(
		"<span class='danger'>[A] [atk_verb]s [D]!</span>",
		"<span class='userdanger'>[A] [atk_verb]s you!</span>",
	)
	to_chat(A, "<span class='danger'>You [atk_verb] [D]!</span>")
	D.apply_damage(harm_damage, BRUTE, affecting, wound_bonus = CANT_WOUND)
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 25, TRUE, -1)
	log_combat(A, D, "harmed (Hunter-Fu)")
	return TRUE

/datum/martial_art/hunterfu/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(A!=D && can_use(A))
		add_to_streak("G", D)
		if(check_streak(A, D)) // If a combo is made no grab upgrade is done
			return TRUE
		old_grab_state = A.grab_state
		D.grabbedby(A, 1)
		if(old_grab_state == GRAB_PASSIVE)
			D.drop_all_held_items()
			A.grab_state = GRAB_AGGRESSIVE // Instant agressive grab
			log_combat(A, D, "grabbed (Hunter-Fu)")
			D.visible_message(
				"<span class='warning'>[A] violently grabs [D]!</span>",
				"<span class='userdanger'>You're grabbed violently by [A]!</span>",
				"<span class='hear'>You hear sounds of aggressive fondling!</span>",
			)
			to_chat(A, "<span class='danger'>You violently grab [D]!</span>")
		return TRUE
	..()

/mob/living/carbon/human/proc/hunterfu_help()
	set name = "Remember The Basics"
	set desc = "You try to remember some of the basics of Hunter-Fu."
	set category = "Hunter-Fu"
	to_chat(usr, "<span class='notice'><b><i>You try to remember some of the basics of Hunter-Fu.</i></b></span>")

	to_chat(usr, "<span class='notice'><b>Body Slam</b>: Grab Harm. Slam opponent into the ground, knocking you both down.</span>")
	to_chat(usr, "<span class='notice'><b>Stake Stab</b>: Harm Harm. Stabs opponent with your bare fist, as strong as a Stake.</span>")
	to_chat(usr, "<span class='notice'><b>Neck Snap</b>: Grab Disarm Harm. Snaps an opponents neck, knocking them out.</span>")
	to_chat(usr, "<span class='notice'><b>Holy Kick</b>: Disarm Grab. Splashes the user with Holy Water, removing Cult Spells, while dealing stamina damage.</span>")

	to_chat(usr, "<span class='notice'><b><i>In addition, by having your throw mode on, you take a defensive position, allowing you to block and sometimes even counter attacks done to you.</i></b></span>")
