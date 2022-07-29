/obj/item/dice/d100/fate
	name = "Кубик Судьбы"
	desc = "Кубик с сотней сторон. Чувствую неестественную энергию, исходящую от него. Использовать на свой страх и риск."
	microwave_riggable = FALSE
	var/reusable = TRUE
	var/used = FALSE
	var/multiplier = 0
	COOLDOWN_DECLARE(roll_cd)

/obj/item/dice/d100/fate/one_use
	reusable = FALSE

/obj/item/dice/d100/fate/cursed
	name = "Проклятый Кубик Судьбы"
	desc = "Кубик с сотней сторон. Кидать такой будет ОЧЕНЬ плохой идеей."
	color = "#00BB00"

	rigged = DICE_TOTALLY_RIGGED
	rigged_value = 1

/obj/item/dice/d100/fate/cursed/one_use
	reusable = FALSE

/obj/item/dice/d100/fate/diceroll(mob/user)
	if(!COOLDOWN_FINISHED(src, roll_cd))
		to_chat(user, span_warning("Подожди, [src] еще не оправился после твоего предыдущего броска!"))
		return

	. = ..()
	if(used)
		return

	if(!multiplier)
		to_chat(user, span_warning("Это множитель. Нужно бросить ещё раз для эффекта."))
		multiplier = result
		return

	if(!ishuman(user) || !user.mind || (user.mind in SSticker.mode.wizards))
		to_chat(user, span_warning("Чувствую что магия кубика доступна только обычным людям!"))
		return

	if(!reusable)
		used = TRUE

	var/turf/T = get_turf(src)
	T.visible_message(span_userdanger("[src] тихонько мерцает."))

	addtimer(CALLBACK(src, .proc/effect, user, .), 1 SECONDS)
	COOLDOWN_START(src, roll_cd, 2.5 SECONDS)

/obj/item/dice/d100/fate/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user) || !user.mind || (user.mind in SSticker.mode.wizards))
		to_chat(user, span_warning("Чувствую что магия кубика доступна только обычным людям! Лучше перестать его трогать."))
		user.dropItemToGround(src)

/obj/item/dice/d100/fate/proc/effect(mob/living/carbon/human/user, roll)
	switch(roll)
		if(1)
			user.reagents.add_reagent(/datum/reagent/drug/labebium, 120)
			var/timer = 5
			for (var/_limb in user.bodyparts)
				var/obj/item/bodypart/limb = _limb
				if (limb.body_part == HEAD || limb.body_part == CHEST)
					continue
				addtimer(CALLBACK(limb, /obj/item/bodypart/.proc/dismember), timer)
				addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, user, 'sound/effects/cartoon_pop.ogg', 70), timer)
				addtimer(CALLBACK(user, /mob/living/.proc/spin, 4, 1), timer - 0.4 SECONDS)
				timer += 5
			user.unequip_everything()
			var/obj/item/clothing/mm = new /obj/item/clothing/neck/necklace/memento_mori(get_turf(src))
			user.equip_to_slot(mm, ITEM_SLOT_NECK)
			spawn(multiplier MINUTES)
				user.gib()
		if(2)
			spawn(-1)
				for(var/i in 1 to multiplier)
					user.reagents.add_reagent(/datum/reagent/toxin/rotatium, 5)
					user.end_dance()
					sleep(10 SECONDS)
		if(3)
			user.gain_trauma(pick(subtypesof(BRAIN_TRAUMA_SEVERE)), TRAUMA_RESILIENCE_ABSOLUTE)
			user.gain_trauma(pick(subtypesof(BRAIN_TRAUMA_SEVERE)), TRAUMA_RESILIENCE_ABSOLUTE)
			user.gain_trauma(/datum/brain_trauma/magic/stalker, TRAUMA_RESILIENCE_ABSOLUTE)
			var/datum/brain_trauma/magic/stalker/S = user.has_trauma_type(/datum/brain_trauma/magic/stalker, TRAUMA_RESILIENCE_ABSOLUTE)
			for(var/i in 1 to multiplier)
				if(i % 2)
					S.create_stalker()
		if(4)
			user.set_species(/datum/species/human/felinid)
			user.fully_replace_character_name(user.real_name, "Мяукалка")
			user.fucking_anime_girl_noises_oh_nya = TRUE
			ADD_TRAIT(user, TRAIT_PACIFISM, "d100")
			var/obj/item/organ/ears/cat/tts/kitty_ears = new
			kitty_ears.Insert(user, TRUE, FALSE)
			user.age -= multiplier
		if(5)
			var/datum/disease/advance/random/D = new /datum/disease/advance/random()
			user.ForceContractDisease(D, FALSE, TRUE)
			for(var/thing in D.symptoms)
				var/datum/symptom/S = thing
				S.resistance = multiplier
				S.stage_speed = multiplier
		if(6)
			user.unequip_everything()
			var/obj/item/clothing/anon = new /obj/item/clothing/mask/gas/anonist(get_turf(src))
			var/obj/item/clothing/foil = new /obj/item/clothing/head/foilhat(get_turf(src))
			user.equip_to_slot(anon, ITEM_SLOT_MASK)
			user.equip_to_slot(foil, ITEM_SLOT_HEAD)
			for(var/i in 1 to multiplier)
				user.gain_trauma_type(pick(subtypesof(/datum/brain_trauma/mild/phobia)), TRAUMA_RESILIENCE_ABSOLUTE)
		if(7)
			user.unequip_everything()
			user.equipOutfit(/datum/outfit/job/bomj)
			var/turf/T
			for(var/_sloc in GLOB.start_landmarks_list)
				var/obj/effect/landmark/start/sloc = _sloc
				if(sloc.name != "Bomj")
					continue
				T = get_turf(sloc)
			user.forceMove(T)
			user.fully_replace_character_name(user.real_name, get_funny_name())
			user.reagents.add_reagent(/datum/reagent/consumable/ethanol/boyarka, multiplier)
		if(8)
			user.unequip_everything()
			user.equipOutfit(/datum/outfit/durka)
			user.fully_replace_character_name(user.real_name, get_funny_name())
			user.add_quirk(pick(SSquirks.hardcore_quirks), TRUE)
			if(prob(multiplier))
				user.add_quirk(pick(SSquirks.hardcore_quirks), TRUE)
				if(prob(multiplier))
					user.add_quirk(pick(SSquirks.hardcore_quirks), TRUE)
			var/datum/antagonist/shizoid/shiz = new
			user.mind.add_antag_datum(shiz)
			var/turf/T = pick(get_area_turfs(/area/medical/medbay/aft))
			user.forceMove(T)
		if(9)
			var/obj/item/organ/eye = user.internal_organs_slot[ORGAN_SLOT_EYES]
			var/obj/item/organ/tong = user.internal_organs_slot[ORGAN_SLOT_TONGUE]
			var/obj/item/organ/ear = user.internal_organs_slot[ORGAN_SLOT_EARS]
			eye.Remove(user)
			tong.Remove(user)
			ear.Remove(user)
			user.hal_screwyhud = SCREWYHUD_HEALTHY
			if(multiplier >= 90)
				var/timer = 5
				for (var/_limb in user.bodyparts)
					var/obj/item/bodypart/limb = _limb
					if (limb.body_part == HEAD || limb.body_part == CHEST)
						continue
					addtimer(CALLBACK(limb, /obj/item/bodypart/.proc/dismember), timer)
					addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, user, 'sound/effects/cartoon_pop.ogg', 70), timer)
					addtimer(CALLBACK(user, /mob/living/.proc/spin, 4, 1), timer - 0.4 SECONDS)
					timer += 5
				ADD_TRAIT(user, TRAIT_EMOTEMUTE, "d100")
		if(10)
			user.unequip_everything()
			var/obj/item/clothing/U = new /obj/item/clothing/under/rank/security/veteran(get_turf(src))
			var/obj/item/clothing/S = new /obj/item/clothing/suit/security/officer/veteran(get_turf(src))
			var/obj/item/clothing/H = new /obj/item/clothing/head/pirate/captain/veteran(get_turf(src))
			user.equip_to_appropriate_slot(U)
			user.equip_to_appropriate_slot(S)
			user.equip_to_appropriate_slot(H)
			for (var/_limb in user.bodyparts)
				var/obj/item/bodypart/limb = _limb
				if (limb.body_part != LEG_LEFT && limb.body_part != LEG_RIGHT)
					continue
				addtimer(CALLBACK(limb, /obj/item/bodypart/.proc/dismember), 5)
			user.mind.remove_all_antag_datums()
			var/obj/vehicle/ridden/wheelchair/wheels = new (get_turf(src))
			wheels.buckle_mob(user)
			for(var/i in 1 to multiplier)
				var/obj/item/clothing/accessory/medal/veteran/M = new (get_turf(src))
				user.equip_or_collect(M)
		if(11)
			for(var/thing in subtypesof(/datum/reagent/consumable/ethanol))
				user.reagents.add_reagent(thing, multiplier)
		if(12)
			spawn(-1)
				for(var/i in 1 to multiplier * 10)
					user.emote("flip")
					sleep(1)
		if(13)
			var/datum/data/record/R = find_record("name", user.real_name, GLOB.data_core.security)
			R.fields["criminal"] = "*Arrest*"
			user.sec_hud_set_security_status()
			user.set_handcuffed(new /obj/item/restraints/handcuffs(user))
			user.update_handcuffed()
			var/bounty = 1000 * multiplier
			user.AddComponent(/datum/component/bounty, bounty)
			priority_announce("За голову [user] назначена награда в размере [bounty] кредит[get_num_string(bounty)]. Цель будет подсвечена лазерной наводкой для удобства.", "Охота за головами",'sound/ai/announcer/alert.ogg')
		if(14)
			user.gib()
		if(15)
			explosion(user, devastation_range = 1, heavy_impact_range = 3, light_impact_range = ROUND_UP(multiplier / 10), flame_range = ROUND_UP(multiplier / 5))
		if(16)
			user.spill_organs()
		if(17)
			user.adjustOxyLoss(200)
			user.suicide_log()
			user.set_suicide(TRUE)
			user.death(FALSE)
			user.ghostize(FALSE)
		if(18)
			user.apply_status_effect(/datum/status_effect/hypertrance)
		if(19)
			var/datum/disease/D = new /datum/disease/heart_failure()
			user.ForceContractDisease(D, FALSE, TRUE)
		if(20)
			user.death()
		if(21)
			user.bodytemperature = 2.7
			user.reagents.add_reagent(/datum/reagent/consumable/frostoil, 30 * multiplier)
		if(22)
			user.bodytemperature = 1000
			user.reagents.add_reagent(/datum/reagent/clf3, 10)
			user.reagents.add_reagent(/datum/reagent/napalm, 5 * multiplier)
			user.reagents.add_reagent(/datum/reagent/consumable/cooking_oil, 10)
			user.adjust_fire_stacks(multiplier)
			user.ignite_mob()
		if(23)
			for(var/i in 1 to multiplier)
				var/direction = pick(GLOB.alldirs)
				new /mob/living/simple_animal/hostile/scavenger(get_step(get_turf(user), direction))
		if(24)
			for(var/i in 1 to multiplier)
				var/direction = pick(GLOB.alldirs)
				new /mob/living/carbon/human/species/monkey/angry(get_step(get_turf(user), direction))
		if(25)
			for(var/M in subtypesof(/datum/mutation/human))
				var/datum/mutation/human/mut = M
				if(mut.quality != NEGATIVE)
					continue
				user.dna.add_mutation(mut, MUT_OTHER, 0)
			user.reagents.add_reagent(/datum/reagent/toxin/mutagen, multiplier)
		if(26)
			var/obj/item/bodypart/l_arm/robot/surplus/la = new(user)
			var/obj/item/bodypart/r_arm/robot/surplus/ra = new(user)
			var/obj/item/bodypart/l_leg/robot/surplus/ll = new(user)
			var/obj/item/bodypart/r_leg/robot/surplus/rl = new(user)
			la.replace_limb(user, FALSE)
			ra.replace_limb(user, FALSE)
			ll.replace_limb(user, FALSE)
			rl.replace_limb(user, FALSE)
			if(multiplier >= 50)
				var/obj/item/bodypart/chest/robot/che = new(user)
				che.replace_limb(user, FALSE)
			if(multiplier >= 90)
				var/obj/item/bodypart/head/robot/he = new(user)
				he.replace_limb(user, FALSE)
		if(27)
			user.reagents.add_reagent(pick(subtypesof(/datum/reagent/drug)), 30 + multiplier)
		if(28)
			user.set_nutrition(multiplier * 100)
			user.hydration = HYDRATION_LEVEL_DEHYDRATED
		if(29)
			user.reagents.add_reagent(/datum/reagent/consumable/sugar, 300)
			user.reagents.add_reagent(/datum/reagent/consumable/honey, multiplier)
		if(30)
			user.reagents.add_reagent(pick(subtypesof(/datum/reagent/medicine)), 100)
		if(31)
			user.add_quirk(/datum/quirk/allergic/hyper, TRUE)
		if(32)
			var/obj/item/organ/heart/gland/G = pick(subtypesof(/obj/item/organ/heart/gland))
			G.Insert(user, TRUE, FALSE)
			G.uses = multiplier
		if(33)
			var/mob/M = wabbajack(user)
			spawn(-1)
				for(var/i in 1 to multiplier)
					sleep(10)
					M = wabbajack(M)
		if(34)
			var/datum/smite/berforate/B = new
			B.hatred = "FUCK THIS DUDE"
			B.effect(user, user)
			qdel(B)
		if(35)
			var/datum/smite/berforate/B = new
			B.hatred = "So fucking much"
			B.effect(user, user)
			qdel(B)
		if(36)
			lightningbolt(user)
		if(37)
			var/datum/smite/fireball/B = new
			B.effect(user, user)
			qdel(B)
		if(38)
			user.setOrganLoss(ORGAN_SLOT_BRAIN, 199)
		if(39)
			var/turf/CT
			for(var/turf/T in view(7, get_turf(user)))
				if(!isclosedturf(T))
					continue
				CT = T
				break
			spawn(-1)
				for(var/i in 1 to multiplier)
					user.throw_at(CT, 10, 10)
					sleep(3)
		if(40)
			var/mob/L = new /mob/living/carbon/human/raper(get_turf(user))
			QDEL_IN(L, 10 SECONDS + multiplier SECONDS)
