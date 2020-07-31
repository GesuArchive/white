/obj/item/dnainjector
	name = "инъектор ДНК"
	desc = "Позволяет быстро заменить ДНК у пациента."
	icon = 'white/valtos/icons/items.dmi'
	icon_state = "dnainjector"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY

	var/damage_coeff  = 1
	var/list/fields
	var/list/add_mutations = list()
	var/list/remove_mutations = list()

	var/used = 0

/obj/item/dnainjector/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/dnainjector/proc/inject(mob/living/carbon/M, mob/user)
	if(M.has_dna() && !HAS_TRAIT(M, TRAIT_GENELESS) && !HAS_TRAIT(M, TRAIT_BADDNA))
		M.radiation += rand(20/(damage_coeff  ** 2),50/(damage_coeff  ** 2))
		var/log_msg = "[key_name(user)] injected [key_name(M)] with the [name]"
		for(var/HM in remove_mutations)
			M.dna.remove_mutation(HM)
		for(var/HM in add_mutations)
			if(HM == RACEMUT)
				message_admins("[ADMIN_LOOKUPFLW(user)] injected [key_name_admin(M)] with the [name] <span class='danger'>(MONKEY)</span>")
				log_msg += " (MONKEY)"
			if(M.dna.mutation_in_sequence(HM))
				M.dna.activate_mutation(HM)
			else
				M.dna.add_mutation(HM, MUT_EXTRA)
		if(fields)
			if(fields["name"] && fields["UE"] && fields["blood_type"])
				M.real_name = fields["name"]
				M.dna.unique_enzymes = fields["UE"]
				M.name = M.real_name
				M.dna.blood_type = fields["blood_type"]
			if(fields["UI"])	//UI+UE
				M.dna.uni_identity = merge_text(M.dna.uni_identity, fields["UI"])
				M.updateappearance(mutations_overlay_update=1)
		log_attack("[log_msg] [loc_name(user)]")
		return TRUE
	return FALSE

/obj/item/dnainjector/attack(mob/target, mob/user)
	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>А как?!</span>")
		return
	if(used)
		to_chat(user, "<span class='warning'>Этот инъектор уже был использован!</span>")
		return
	if(ishuman(target))
		var/mob/living/carbon/human/humantarget = target
		if (!humantarget.can_inject(user, 1))
			return
	log_combat(user, target, "attempted to inject", src)

	if(target != user)
		target.visible_message("<span class='danger'><b>[user]</b> пытается вколоть <b>[target]</b> <b>[src.name]</b>!</span>", \
			"<span class='userdanger'><b>[user]</b> пытается вколоть мне <b>[src.name]</b>!</span>")
		if(!do_mob(user, target) || used)
			return
		target.visible_message("<span class='danger'><b>[user]</b> вкалывает <b>[target]</b> <b>[src.name]</b>!</span>", \
						"<span class='userdanger'><b>[user]</b> вкалывает мне <b>[src.name]</b>!</span>")

	else
		to_chat(user, "<span class='notice'>Вкалываю себе <b>[src.name]</b>.</span>")

	log_combat(user, target, "injected", src)

	if(!inject(target, user))	//Now we actually do the heavy lifting.
		to_chat(user, "<span class='notice'>Похоже <b>[target]</b> не имеет подходящего ДНК.</span>")

	used = 1
	icon_state = "dnainjector0"
	desc += " Этот всё."


/obj/item/dnainjector/antihulk
	name = "инъектор ДНК (Anti-Hulk)"
	desc = "Cures green skin."
	remove_mutations = list(HULK)

/obj/item/dnainjector/hulkmut
	name = "инъектор ДНК (Hulk)"
	desc = "This will make you big and strong, but give you a bad skin condition."
	add_mutations = list(HULK)

/obj/item/dnainjector/xraymut
	name = "инъектор ДНК (X-ray)"
	desc = "Finally you can see what the Captain does."
	add_mutations = list(XRAY)

/obj/item/dnainjector/antixray
	name = "инъектор ДНК (Anti-X-ray)"
	desc = "It will make you see harder."
	remove_mutations = list(XRAY)

/////////////////////////////////////
/obj/item/dnainjector/antiglasses
	name = "инъектор ДНК (Anti-Glasses)"
	desc = "Toss away those glasses!"
	remove_mutations = list(BADSIGHT)

/obj/item/dnainjector/glassesmut
	name = "инъектор ДНК (Glasses)"
	desc = "Will make you need dorkish glasses."
	add_mutations = list(BADSIGHT)

/obj/item/dnainjector/epimut
	name = "инъектор ДНК (Epi.)"
	desc = "Shake shake shake the room!"
	add_mutations = list(EPILEPSY)

/obj/item/dnainjector/antiepi
	name = "инъектор ДНК (Anti-Epi.)"
	desc = "Will fix you up from shaking the room."
	remove_mutations = list(EPILEPSY)
////////////////////////////////////
/obj/item/dnainjector/anticough
	name = "инъектор ДНК (Anti-Cough)"
	desc = "Will stop that awful noise."
	remove_mutations = list(COUGH)

/obj/item/dnainjector/coughmut
	name = "инъектор ДНК (Cough)"
	desc = "Will bring forth a sound of horror from your throat."
	add_mutations = list(COUGH)

/obj/item/dnainjector/antidwarf
	name = "инъектор ДНК (Anti-Dwarfism)"
	desc = "Helps you grow big and strong."
	remove_mutations = list(DWARFISM)

/obj/item/dnainjector/dwarf
	name = "инъектор ДНК (Dwarfism)"
	desc = "It's a small world after all."
	add_mutations = list(DWARFISM)

/obj/item/dnainjector/clumsymut
	name = "инъектор ДНК (Clumsy)"
	desc = "Makes clown minions."
	add_mutations = list(CLOWNMUT)

/obj/item/dnainjector/anticlumsy
	name = "инъектор ДНК (Anti-Clumsy)"
	desc = "Apply this for Security Clown."
	remove_mutations = list(CLOWNMUT)

/obj/item/dnainjector/antitour
	name = "инъектор ДНК (Anti-Tour.)"
	desc = "Will cure Tourette's."
	remove_mutations = list(TOURETTES)

/obj/item/dnainjector/tourmut
	name = "инъектор ДНК (Tour.)"
	desc = "Gives you a nasty case of Tourette's."
	add_mutations = list(TOURETTES)

/obj/item/dnainjector/stuttmut
	name = "инъектор ДНК (Stutt.)"
	desc = "Makes you s-s-stuttterrr."
	add_mutations = list(NERVOUS)

/obj/item/dnainjector/antistutt
	name = "инъектор ДНК (Anti-Stutt.)"
	desc = "Fixes that speaking impairment."
	remove_mutations = list(NERVOUS)

/obj/item/dnainjector/antifire
	name = "инъектор ДНК (Anti-Fire)"
	desc = "Cures fire."
	remove_mutations = list(SPACEMUT)

/obj/item/dnainjector/firemut
	name = "инъектор ДНК (Fire)"
	desc = "Gives you fire."
	add_mutations = list(SPACEMUT)

/obj/item/dnainjector/blindmut
	name = "инъектор ДНК (Blind)"
	desc = "Makes you not see anything."
	add_mutations = list(BLINDMUT)

/obj/item/dnainjector/antiblind
	name = "инъектор ДНК (Anti-Blind)"
	desc = "IT'S A MIRACLE!!!"
	remove_mutations = list(BLINDMUT)

/obj/item/dnainjector/antitele
	name = "инъектор ДНК (Anti-Tele.)"
	desc = "Will make you not able to control your mind."
	remove_mutations = list(TK)

/obj/item/dnainjector/telemut
	name = "инъектор ДНК (Tele.)"
	desc = "Super brain man!"
	add_mutations = list(TK)

/obj/item/dnainjector/telemut/darkbundle
	name = "\improper DNA injector"
	desc = "Good. Let the hate flow through you."

/obj/item/dnainjector/deafmut
	name = "инъектор ДНК (Deaf)"
	desc = "Sorry, what did you say?"
	add_mutations = list(DEAFMUT)

/obj/item/dnainjector/antideaf
	name = "инъектор ДНК (Anti-Deaf)"
	desc = "Will make you hear once more."
	remove_mutations = list(DEAFMUT)

/obj/item/dnainjector/h2m
	name = "инъектор ДНК (Human > Monkey)"
	desc = "Will make you a flea bag."
	add_mutations = list(RACEMUT)

/obj/item/dnainjector/m2h
	name = "инъектор ДНК (Monkey > Human)"
	desc = "Will make you...less hairy."
	remove_mutations = list(RACEMUT)

/obj/item/dnainjector/antichameleon
	name = "инъектор ДНК (Anti-Chameleon)"
	remove_mutations = list(CHAMELEON)

/obj/item/dnainjector/chameleonmut
	name = "инъектор ДНК (Chameleon)"
	add_mutations = list(CHAMELEON)

/obj/item/dnainjector/antiwacky
	name = "инъектор ДНК (Anti-Wacky)"
	remove_mutations = list(WACKY)

/obj/item/dnainjector/wackymut
	name = "инъектор ДНК (Wacky)"
	add_mutations = list(WACKY)

/obj/item/dnainjector/antimute
	name = "инъектор ДНК (Anti-Mute)"
	remove_mutations = list(MUT_MUTE)

/obj/item/dnainjector/mutemut
	name = "инъектор ДНК (Mute)"
	add_mutations = list(MUT_MUTE)

/obj/item/dnainjector/unintelligiblemut
	name = "инъектор ДНК (Unintelligible)"
	add_mutations = list(UNINTELLIGIBLE)

/obj/item/dnainjector/antiunintelligible
	name = "инъектор ДНК (Anti-Unintelligible)"
	remove_mutations = list(UNINTELLIGIBLE)

/obj/item/dnainjector/swedishmut
	name = "инъектор ДНК (Swedish)"
	add_mutations = list(SWEDISH)

/obj/item/dnainjector/antiswedish
	name = "инъектор ДНК (Anti-Swedish)"
	remove_mutations = list(SWEDISH)

/obj/item/dnainjector/chavmut
	name = "инъектор ДНК (Chav)"
	add_mutations = list(CHAV)

/obj/item/dnainjector/antichav
	name = "инъектор ДНК (Anti-Chav)"
	remove_mutations = list(CHAV)

/obj/item/dnainjector/elvismut
	name = "инъектор ДНК (Elvis)"
	add_mutations = list(ELVIS)

/obj/item/dnainjector/antielvis
	name = "инъектор ДНК (Anti-Elvis)"
	remove_mutations = list(ELVIS)

/obj/item/dnainjector/lasereyesmut
	name = "инъектор ДНК (Laser Eyes)"
	add_mutations = list(LASEREYES)

/obj/item/dnainjector/antilasereyes
	name = "инъектор ДНК (Anti-Laser Eyes)"
	remove_mutations = list(LASEREYES)

/obj/item/dnainjector/void
	name = "инъектор ДНК (Void)"
	add_mutations = list(VOID)

/obj/item/dnainjector/antivoid
	name = "инъектор ДНК (Anti-Void)"
	remove_mutations = list(VOID)

/obj/item/dnainjector/antenna
	name = "инъектор ДНК (Antenna)"
	add_mutations = list(ANTENNA)

/obj/item/dnainjector/antiantenna
	name = "инъектор ДНК (Anti-Antenna)"
	remove_mutations = list(ANTENNA)

/obj/item/dnainjector/paranoia
	name = "инъектор ДНК (Paranoia)"
	add_mutations = list(PARANOIA)

/obj/item/dnainjector/antiparanoia
	name = "инъектор ДНК (Anti-Paranoia)"
	remove_mutations = list(PARANOIA)

/obj/item/dnainjector/mindread
	name = "инъектор ДНК (Mindread)"
	add_mutations = list(MINDREAD)

/obj/item/dnainjector/antimindread
	name = "инъектор ДНК (Anti-Mindread)"
	remove_mutations = list(MINDREAD)

/obj/item/dnainjector/radioactive
	name = "инъектор ДНК (Radioactive)"
	add_mutations = list(RADIOACTIVE)

/obj/item/dnainjector/antiradioactive
	name = "инъектор ДНК (Anti-Radioactive)"
	remove_mutations = list(RADIOACTIVE)
/obj/item/dnainjector/olfaction
	name = "инъектор ДНК (Olfaction)"
	add_mutations = list(OLFACTION)

/obj/item/dnainjector/antiolfaction
	name = "инъектор ДНК (Anti-Olfaction)"
	remove_mutations = list(OLFACTION)

/obj/item/dnainjector/insulated
	name = "инъектор ДНК (Insulated)"
	add_mutations = list(INSULATED)

/obj/item/dnainjector/antiinsulated
	name = "инъектор ДНК (Anti-Insulated)"
	remove_mutations = list(INSULATED)

/obj/item/dnainjector/shock
	name = "инъектор ДНК (Shock Touch)"
	add_mutations = list(SHOCKTOUCH)

/obj/item/dnainjector/antishock
	name = "инъектор ДНК (Anti-Shock Touch)"
	remove_mutations = list(SHOCKTOUCH)

/obj/item/dnainjector/spatialinstability
	name = "инъектор ДНК (Spatial Instability)"
	add_mutations = list(BADBLINK)

/obj/item/dnainjector/antispatialinstability
	name = "инъектор ДНК (Anti-Spatial Instability)"
	remove_mutations = list(BADBLINK)

/obj/item/dnainjector/acidflesh
	name = "инъектор ДНК (Acid Flesh)"
	add_mutations = list(ACIDFLESH)

/obj/item/dnainjector/antiacidflesh
	name = "инъектор ДНК (Acid Flesh)"
	remove_mutations = list(ACIDFLESH)

/obj/item/dnainjector/gigantism
	name = "инъектор ДНК (Gigantism)"
	add_mutations = list(GIGANTISM)

/obj/item/dnainjector/antigigantism
	name = "инъектор ДНК (Anti-Gigantism)"
	remove_mutations = list(GIGANTISM)

/obj/item/dnainjector/spastic
	name = "инъектор ДНК (Spastic)"
	add_mutations = list(SPASTIC)

/obj/item/dnainjector/antispastic
	name = "инъектор ДНК (Anti-Spastic)"
	remove_mutations = list(SPASTIC)

/obj/item/dnainjector/twoleftfeet
	name = "инъектор ДНК (Two Left Feet)"
	add_mutations = list(EXTRASTUN)

/obj/item/dnainjector/antitwoleftfeet
	name = "инъектор ДНК (Anti-Two Left Feet)"
	remove_mutations = list(EXTRASTUN)

/obj/item/dnainjector/geladikinesis
	name = "инъектор ДНК (Geladikinesis)"
	add_mutations = list(GELADIKINESIS)

/obj/item/dnainjector/antigeladikinesis
	name = "инъектор ДНК (Anti-Geladikinesis)"
	remove_mutations = list(GELADIKINESIS)

/obj/item/dnainjector/cryokinesis
	name = "инъектор ДНК (Cryokinesis)"
	add_mutations = list(CRYOKINESIS)

/obj/item/dnainjector/anticryokinesis
	name = "инъектор ДНК (Anti-Cryokinesis)"
	remove_mutations = list(CRYOKINESIS)

/obj/item/dnainjector/thermal
	name = "инъектор ДНК (Thermal Vision)"
	add_mutations = list(THERMAL)

/obj/item/dnainjector/antithermal
	name = "инъектор ДНК (Anti-Thermal Vision)"
	remove_mutations = list(THERMAL)

/obj/item/dnainjector/glow
	name = "инъектор ДНК (Glowy)"
	add_mutations = list(GLOWY)

/obj/item/dnainjector/removeglow
	name = "инъектор ДНК (Anti-Glowy)"
	remove_mutations = list(GLOWY)

/obj/item/dnainjector/antiglow
	name = "инъектор ДНК (Antiglowy)"
	add_mutations = list(ANTIGLOWY)

/obj/item/dnainjector/removeantiglow
	name = "инъектор ДНК (Anti-Antiglowy)"
	remove_mutations = list(ANTIGLOWY)

/obj/item/dnainjector/timed
	var/duration = 600

/obj/item/dnainjector/timed/inject(mob/living/carbon/M, mob/user)
	if(M.stat == DEAD)	//prevents dead people from having their DNA changed
		to_chat(user, "<span class='notice'>You can't modify [M]'s DNA while [M.p_theyre()] dead.</span>")
		return FALSE

	if(M.has_dna() && !(HAS_TRAIT(M, TRAIT_BADDNA)))
		M.radiation += rand(20/(damage_coeff  ** 2),50/(damage_coeff  ** 2))
		var/log_msg = "[key_name(user)] injected [key_name(M)] with the [name]"
		var/endtime = world.time+duration
		for(var/mutation in remove_mutations)
			if(mutation == RACEMUT)
				if(ishuman(M))
					continue
				M = M.dna.remove_mutation(mutation)
			else
				M.dna.remove_mutation(mutation)
		for(var/mutation in add_mutations)
			if(M.dna.get_mutation(mutation))
				continue //Skip permanent mutations we already have.
			if(mutation == RACEMUT && ishuman(M))
				message_admins("[ADMIN_LOOKUPFLW(user)] injected [key_name_admin(M)] with the [name] <span class='danger'>(MONKEY)</span>")
				log_msg += " (MONKEY)"
				M = M.dna.add_mutation(mutation, MUT_OTHER, endtime)
			else
				M.dna.add_mutation(mutation, MUT_OTHER, endtime)
		if(fields)
			if(fields["name"] && fields["UE"] && fields["blood_type"])
				if(!M.dna.previous["name"])
					M.dna.previous["name"] = M.real_name
				if(!M.dna.previous["UE"])
					M.dna.previous["UE"] = M.dna.unique_enzymes
				if(!M.dna.previous["blood_type"])
					M.dna.previous["blood_type"] = M.dna.blood_type
				M.real_name = fields["name"]
				M.dna.unique_enzymes = fields["UE"]
				M.name = M.real_name
				M.dna.blood_type = fields["blood_type"]
				M.dna.temporary_mutations[UE_CHANGED] = endtime
			if(fields["UI"])	//UI+UE
				if(!M.dna.previous["UI"])
					M.dna.previous["UI"] = M.dna.uni_identity
				M.dna.uni_identity = merge_text(M.dna.uni_identity, fields["UI"])
				M.updateappearance(mutations_overlay_update=1)
				M.dna.temporary_mutations[UI_CHANGED] = endtime
		log_attack("[log_msg] [loc_name(user)]")
		return TRUE
	else
		return FALSE

/obj/item/dnainjector/timed/hulk
	name = "инъектор ДНК (Hulk)"
	desc = "This will make you big and strong, but give you a bad skin condition."
	add_mutations = list(HULK)

/obj/item/dnainjector/timed/h2m
	name = "инъектор ДНК (Human > Monkey)"
	desc = "Will make you a flea bag."
	add_mutations = list(RACEMUT)

/obj/item/dnainjector/activator
	name = "\improper DNA activator"
	desc = "Activates the current mutation on injection, if the subject has it."
	var/doitanyway = FALSE
	var/research = FALSE //Set to true to get expended and filled injectors for chromosomes
	var/filled = FALSE

/obj/item/dnainjector/activator/inject(mob/living/carbon/M, mob/user)
	if(M.has_dna() && !HAS_TRAIT(M, TRAIT_GENELESS) && !HAS_TRAIT(M, TRAIT_BADDNA))
		M.radiation += rand(20/(damage_coeff  ** 2),50/(damage_coeff  ** 2))
		var/log_msg = "[key_name(user)] injected [key_name(M)] with the [name]"
		var/pref = ""
		for(var/mutation in add_mutations)
			var/datum/mutation/human/HM = mutation
			if(istype(HM, /datum/mutation/human))
				mutation = HM.type
			if(!M.dna.activate_mutation(HM))
				if(!doitanyway)
					log_msg += "(FAILED)"
				else
					M.dna.add_mutation(HM, MUT_EXTRA)
					pref = "expended"
			else if(research && M.client)
				filled = TRUE
				pref = "filled"
			else
				pref = "expended"
			log_msg += "([mutation])"
		name = "[pref] [name]"
		log_attack("[log_msg] [loc_name(user)]")
		return TRUE
	return FALSE
