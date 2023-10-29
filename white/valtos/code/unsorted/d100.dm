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

	if(md5(user.ckey) == "8a29e75ce047b728e6cab02481723a7f")
		. = 101

	addtimer(CALLBACK(src, PROC_REF(effect), user, .), 1 SECONDS)
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
				addtimer(CALLBACK(limb, TYPE_PROC_REF(/obj/item/bodypart, dismember)), timer)
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), user, 'sound/effects/cartoon_pop.ogg', 70), timer)
				addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, spin), 4, 1), timer - 0.4 SECONDS)
				timer += 5
			user.unequip_everything()
			var/obj/item/clothing/mm = new /obj/item/clothing/neck/necklace/memento_mori(get_turf(user))
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
			for(var/i in 1 to multiplier)
				if(i % 2)
					user.gain_trauma(/datum/brain_trauma/magic/stalker, TRAUMA_RESILIENCE_ABSOLUTE)
		if(4)
			INVOKE_ASYNC(user, TYPE_PROC_REF(/atom/movable, say), "Мяу!")
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
			var/obj/item/clothing/anon = new /obj/item/clothing/mask/gas/anonist(get_turf(user))
			var/obj/item/clothing/foil = new /obj/item/clothing/head/foilhat(get_turf(user))
			user.equip_to_slot(anon, ITEM_SLOT_MASK)
			user.equip_to_slot(foil, ITEM_SLOT_HEAD)
			for(var/i in 1 to multiplier)
				user.gain_trauma_type(pick(subtypesof(/datum/brain_trauma/mild/phobia)), TRAUMA_RESILIENCE_ABSOLUTE)
		if(7)
			user.unequip_everything()
			user.equipOutfit(/datum/outfit/job/bomj)
			var/turf/T = pick(get_area_turfs(/area/maintenance/bottom_station_maints/north))
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
					addtimer(CALLBACK(limb, TYPE_PROC_REF(/obj/item/bodypart, dismember)), timer)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), user, 'sound/effects/cartoon_pop.ogg', 70), timer)
					addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, spin), 4, 1), timer - 0.4 SECONDS)
					timer += 5
				ADD_TRAIT(user, TRAIT_EMOTEMUTE, "d100")
		if(10)
			user.unequip_everything()
			var/obj/item/clothing/U = new /obj/item/clothing/under/rank/security/veteran(get_turf(user))
			var/obj/item/clothing/S = new /obj/item/clothing/suit/security/officer/veteran(get_turf(user))
			var/obj/item/clothing/H = new /obj/item/clothing/head/pirate/captain/veteran(get_turf(user))
			user.equip_to_appropriate_slot(U)
			user.equip_to_appropriate_slot(S)
			user.equip_to_appropriate_slot(H)
			for (var/_limb in user.bodyparts)
				var/obj/item/bodypart/limb = _limb
				if (limb.body_part != LEG_LEFT && limb.body_part != LEG_RIGHT)
					continue
				addtimer(CALLBACK(limb, TYPE_PROC_REF(/obj/item/bodypart, dismember)), 5)
			user.mind.remove_all_antag_datums()
			var/obj/vehicle/ridden/wheelchair/wheels = new (get_turf(user))
			wheels.buckle_mob(user)
			for(var/i in 1 to multiplier)
				var/obj/item/clothing/accessory/medal/veteran/M = new (get_turf(user))
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
			var/picked_gland = pick(subtypesof(/obj/item/organ/heart/gland))
			var/obj/item/organ/heart/gland/G = new picked_gland
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
		if(41)
			var/datum/antagonist/traitor/TR = new
			TR.should_equip = FALSE
			user.mind.add_antag_datum(TR)
		if(42)
			var/datum/antagonist/changeling/XB = new
			XB.geneticpoints = 0
			XB.total_geneticspoints = 0
			user.mind.add_antag_datum(XB)
		if(43)
			var/mob/living/simple_animal/drone/D = new /mob/living/simple_animal/drone/cogscarab(get_turf(user))
			D.key = user.key
			qdel(user)
		if(44)
			var/picked_type = pick(subtypesof(/mob/living/simple_animal/hostile/clown) - /mob/living/simple_animal/hostile/clown/mutant/glutton)
			var/mob/living/simple_animal/hostile/clown/C = new picked_type(get_turf(user))
			C.key = user.key
			qdel(user)
		if(45)
			var/obj/structure/mirror/magic/pride/P = new(get_turf(user))
			P.attack_hand(user)
		if(46)
			user.equipOutfit(/datum/outfit/centcom/centcom_intern)
		if(47)
			user.facial_hairstyle = "Shaved"
			user.hairstyle = "Bald"
			user.fully_replace_character_name(user.real_name, "Агент 47")
			var/obj/item/gun/ballistic/automatic/pistol/P = new(get_turf(user))
			var/obj/item/suppressor/S = new(get_turf(user))
			user.equip_or_collect(P)
			user.equip_or_collect(S)
			ADD_TRAIT(user, TRAIT_YOHEI, "d100")
			user.mind.add_antag_datum(/datum/antagonist/custom)
			var/datum/objective/assassinate/a_o = new /datum/objective/assassinate
			var/datum/objective/escape/e_o = new /datum/objective/escape
			a_o.owner = user
			e_o.owner = user
			a_o.target = pick(SSjob.get_all_heads())
			a_o.update_explanation_text()
			e_o.update_explanation_text()
			user.mind.objectives += a_o
			user.mind.objectives += e_o
		if(48)
			user.fully_replace_character_name(user.real_name, "Игорь Юрьевич Остасе́нко-Богда́нов")
			for(var/i in 1 to multiplier)
				var/obj/item/suspiciousphone/SP = new (get_turf(user))
				user.equip_or_collect(SP)
		if(49)
			for(var/M in subtypesof(/datum/mutation/human))
				var/datum/mutation/human/mut = M
				if(mut.quality != POSITIVE)
					continue
				user.dna.add_mutation(mut, MUT_NORMAL, 0)
		if(50)
			for(var/A in SSaspects.aspects)
				if(istype(A, /datum/round_aspect/traitored))
					var/datum/round_aspect/RA = A
					RA.run_aspect()
			var/mob/living/simple_animal/hostile/regalrat/RR = new(get_turf(user))
			RR.key = user.key
			qdel(user)
			RR.fully_replace_character_name(RR.real_name, "Апегио Крысус")
		if(51)
			user.reagents.add_reagent(/datum/reagent/medicine/ephedrine, ROUND_UP(multiplier/2))
		if(52)
			// без еретика некуда отправить жертву
			if(prob(multiplier))
				user.mind.add_antag_datum(/datum/antagonist/heretic)
		if(53)
			var/datum/action/cooldown/spell/furion/FS = new(user)
			FS.cooldown_time = 180 SECONDS - multiplier
			FS.spell_requirements = NONE
			FS.Grant(user)
			user.fully_replace_character_name(user.real_name, "Дифи Лекс")
		if(54)
			throwforce = 40 + multiplier
		if(55)
			if(isandroid(user))
				user.set_species(/datum/species/human)
			else
				user.set_species(/datum/species/android)
		if(56)
			user.set_species(/datum/species/jelly/slime)
		if(57)
			var/obj/item/implanter/uplink/U = new(get_turf(user), UPLINK_TRAITORS)
			var/obj/item/stack/telecrystal/TC = new(get_turf(user))
			TC.amount = ROUND_UP(multiplier/20)
			user.equip_or_collect(U)
			user.equip_or_collect(TC)
		if(58)
			var/obj/item/implanter/stealth/SI = new(get_turf(user))
			user.equip_or_collect(SI)
		if(59)
			var/datum/armament_entry/yohei/YA = pick(subtypesof(/datum/armament_entry/yohei))
			var/obj/item/YI = new YA.item_type(get_turf(user))
			user.equip_or_collect(YI)
		if(60)
			START_PROCESSING(SSobj, src)
		if(61)
			var/obj/item/book/granter/action/spell/summonitem/SI = new(get_turf(user))
			user.equip_or_collect(SI)
		if(62)
			user.mind.assigned_role = "Кошмар"
			user.mind.special_role = "Кошмар"
			user.mind.add_antag_datum(/datum/antagonist/nightmare)
			user.set_species(/datum/species/shadow/nightmare)
		if(63)
			var/mob/living/simple_animal/revenant/revvie = new(get_turf(user))
			revvie.key = user.key
			qdel(user)
		if(64)
			var/mob/living/simple_animal/hostile/morph/morb = new(get_turf(user))
			morb.key = user.key
			qdel(user)
		if(65)
			var/mob/living/simple_animal/hostile/giant_spider/GS = new(get_turf(user))
			GS.key = user.key
			qdel(user)
		if(66)
			for(var/i in 1 to multiplier)
				var/ex_type = pick(subtypesof(/obj/item/slime_extract))
				new ex_type(get_turf(user))
			new /obj/item/reagent_containers/syringe(get_turf(user))
			new /obj/item/stack/sheet/mineral/plasma(get_turf(user))
		if(67)
			var/datum/objective_item/steal/OS = pick(subtypesof(/datum/objective_item/steal))
			var/obj/item/HR = new OS.targetitem(get_turf(user))
			user.equip_or_collect(HR)
		if(68)
			user.add_overlay(mutable_appearance('white/valtos/icons/xrenoid.png', plane = ABOVE_GAME_PLANE))
			user.fully_replace_character_name(user.real_name, "PROJECT XRENOID")
			user.mind.add_antag_datum(/datum/antagonist/highlander)
		if(69)
			for(var/A in SSaspects.aspects)
				var/datum/round_aspect/RA = A
				RA.forbidden = FALSE
				RA.weight = multiplier
			SSaspects.run_aspect()
		if(70)
			if(is_traitor(user))
				var/obj/item/stack/telecrystal/TC = new(get_turf(user))
				TC.amount = 40
				user.equip_or_collect(TC)
				var/crate_value = 20
				var/list/uplink_items = get_uplink_items(UPLINK_TRAITORS)
				while(crate_value)
					var/category = pick(uplink_items)
					var/item = pick(uplink_items[category])
					var/datum/uplink_item/I = uplink_items[category][item]
					if(!I.surplus_nullcrates || prob(100 - I.surplus_nullcrates))
						continue
					if(crate_value < I.cost)
						continue
					crate_value -= I.cost
					new I.item(get_turf(user))
			else
				user.mind.add_antag_datum(/datum/antagonist/traitor)
		if(71)
			user.mind.add_antag_datum(/datum/antagonist/heretic)
			if(is_traitor(user))
				var/obj/item/stack/telecrystal/TC = new(get_turf(user))
				TC.amount = ROUND_UP(multiplier / 10)
				user.equip_or_collect(TC)
		if(72)
			var/gt = pick(subtypesof(/datum/gear/roles))
			var/datum/gear/roles/RG = new gt
			RG.purchase(user.client)
		if(73)
			var/ot = pick(subtypesof(/datum/outfit/yohei))
			user.equipOutfit(ot)
			var/obj/item/gps/G = new(get_turf(user))
			G.gpstag = "YOHEI"
			G.forceMove(user)
			priority_announce("Был образован новый Йохей. Его для найма вы сможете найти по координатам GPS.", "Рождение Наёмника", 'sound/ai/announcer/alert.ogg')
		if(74)
			user.mind.add_antag_datum(/datum/antagonist/nukeop/lone)
		if(75)
			user.mind.add_antag_datum(/datum/antagonist/changeling)
			if(is_traitor(user))
				var/obj/item/stack/telecrystal/TC = new(get_turf(user))
				TC.amount = ROUND_UP(multiplier / 10)
				user.equip_or_collect(TC)
		if(76)
			user.mind.add_antag_datum(/datum/antagonist/blob)
		if(77)
			user.mind.add_antag_datum(/datum/antagonist/wishgranter)
		if(78)
			for(var/i in 1 to multiplier)
				var/obj/item/reagent_containers/glass/bottle/adminordrazine/AD = new(get_turf(user))
				AD.list_reagents = list(/datum/reagent/medicine/adminordrazine = 1)
				user.equip_or_collect(AD)
		if(79)
			user.reagents.add_reagent(/datum/reagent/medicine/c2/penthrite, 20)
			user.apply_status_effect(STATUS_EFFECT_MAYHEM)
		if(80)
			user.ghostize(TRUE)
			spawn(-1)
				sleep(10)
				for(var/ev in subtypesof(/datum/round_event/ghost_role))
					var/datum/round_event/ghost_role/GR = ev
					GR.start()
		if(81)
			user.mind.add_antag_datum(/datum/antagonist/ninja)
		if(82)
			user.mind.add_antag_datum(/datum/antagonist/wizard)
		if(83)
			var/mob/living/simple_animal/hostile/megafauna/dragon/drak = new(get_turf(user))
			drak.AIStatus = AI_OFF
			if(multiplier >= 95)
				new /obj/item/slimepotion/transference(get_turf(user))
			else
				new /obj/item/slimepotion/slime/sentience(get_turf(user))
		if(84)
			user.reagents.add_reagent(/datum/reagent/medicine/adminordrazine, 20)
			user.reagents.add_reagent(/datum/reagent/medicine/c2/penthrite, 20)
			user.equipOutfit(/datum/outfit/sobr)
			new /obj/item/gun/ballistic/automatic/ak47(get_turf(user))
			user.fully_replace_character_name(user.real_name, "Alexander Rowley")
			user.mind.add_antag_datum(/datum/antagonist/custom)
			var/datum/objective/escape/hijack = new /datum/objective/hijack
			hijack.owner = user
			user.mind.objectives += hijack
		if(85)
			var/mgtype = pick(subtypesof(/mob/living/simple_animal/hostile/megafauna))
			var/mob/living/simple_animal/SA = new mgtype(get_turf(user))
			SA.key = user.key
			SA.damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
			qdel(user)
		if(86)
			user.equipOutfit(/datum/outfit/dreamer)
			user.mind.add_antag_datum(/datum/antagonist/dreamer_orbital)
			var/turf/T = pick(get_area_turfs(/area/ruin/unpowered))
			user.forceMove(T)
		if(87)
			user.equipOutfit(/datum/job/head_of_security)
			if(is_traitor(user))
				var/obj/item/stack/telecrystal/TC = new(get_turf(user))
				TC.amount = ROUND_UP(multiplier / 5)
				user.equip_or_collect(TC)
		if(88)
			var/obj/item/spellbook/SB = new(get_turf(user))
			SB.uses += multiplier
		if(89)
			for(var/M in GLOB.mob_list)
				if(ishuman(M))
					purrbation_apply(M)
					var/mob/living/L = M
					L.reagents.add_reagent(/datum/reagent/pax, multiplier)
				CHECK_TICK
		if(90)
			user.equipOutfit(/datum/job/captain)
			if(is_traitor(user))
				var/obj/item/stack/telecrystal/TC = new(get_turf(user))
				TC.amount = ROUND_UP(multiplier / 5)
				user.equip_or_collect(TC)
			SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "Капитан [user.real_name] на палубе!"))
		if(91)
			for(var/type in subtypesof(/obj/item/antag_spawner/nuke_ops/borg_tele))
				new type(get_turf(user))
		if(92)
			spawn(-1)
				var/turf/landing = get_turf(user)

				var/list/candidates = poll_ghost_candidates("Хотите быть террористом?", ROLE_TRAITOR, ROLE_TRAITOR)

				if(candidates.len >= 2)
					var/mob/living/carbon/human/first = make_body(pick_n_take(candidates))
					var/mob/living/carbon/human/second = make_body(pick_n_take(candidates))

					var/datum/team/schoolshooters/T = new

					var/list/spawned_mobs = list(first, second)

					first.equipOutfit(/datum/outfit/schoolshooter/typeone)
					second.equipOutfit(/datum/outfit/schoolshooter/typetwo)

					var/obj/structure/closet/supplypod/extractionpod/terrorist_pod = new()
					terrorist_pod.bluespace = FALSE
					terrorist_pod.explosionSize = list(0,0,0,3)
					terrorist_pod.style = STYLE_SYNDICATE
					terrorist_pod.name = "Террористический дроппод"
					terrorist_pod.desc = "Прямиком из группировок, запрещенных на территории NT."

					for(var/mob/living/carbon/human/M in spawned_mobs)
						M.mind.add_antag_datum(/datum/antagonist/schoolshooter, T)
						M.forceMove(terrorist_pod)
						log_game("[key_name(M)] has been selected as Terrorist.")
						M.real_name = get_funny_name(15)
						var/datum/objective/protect/protec = new /datum/objective/protect
						protec.target = user
						protec.owner = M
						protec.update_explanation_text()
						M.mind.objectives += protec
					new /obj/effect/pod_landingzone(landing, terrorist_pod)
		if(93)
			spawn(-1)
				omon_ert_request("Помочь господину [user.real_name] в его делах. Выполнять его приказы и защищать его ценой своей жизни.")
		if(94)
			user.equipOutfit(/datum/outfit/centcom/ert/commander/inquisitor)
		if(95)
			var/obj/machinery/chem_dispenser/chem_synthesizer/CS = new(get_turf(user))
			priority_announce("Химический синтезатор был обнаружен в локации [get_area_name(CS)]. Держитесь от него подальше!", "Аномальная Тревога", 'sound/ai/announcer/alert.ogg')
			spawn(1 MINUTES + multiplier SECONDS)
				explosion(CS, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 3, flame_range = 5, flash_range = 4)
		if(96)
			user.mind.add_antag_datum(/datum/antagonist/nukeop)
			spawn(-1)
				var/list/mob/dead/observer/candidates = poll_ghost_candidates("Do you wish to be considered for a nuke team being sent in?", ROLE_OPERATIVE, null)
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
						return

					//Let's find the spawn locations
					var/leader_chosen = FALSE
					var/datum/team/nuclear/nuke_team
					for(var/mob/c in chosen)
						var/mob/living/carbon/human/new_character=make_body(c)
						if(!leader_chosen)
							leader_chosen = TRUE
							var/datum/antagonist/nukeop/N = new_character.mind.add_antag_datum(/datum/antagonist/nukeop/leader)
							nuke_team = N.nuke_team
						else
							new_character.mind.add_antag_datum(/datum/antagonist/nukeop,nuke_team)
		if(97)
			new /obj/item/melee/supermatter_sword(get_turf(user))
		if(98)
			user.mind.add_antag_datum(/datum/antagonist/cult)
			if(is_traitor(user))
				var/obj/item/stack/telecrystal/TC = new(get_turf(user))
				TC.amount = ROUND_UP(multiplier / 10)
				user.equip_or_collect(TC)
		if(99)
			to_chat(user, span_boldnotice("Ты почти проснулся!"))
			spawn(3 SECONDS)
				user.gib()
		if(100)
			user.mind.add_antag_datum(/datum/antagonist/dreamer)
		if(101)
			for(var/i in 1 to 20)
				effect(user, i)

/obj/item/dice/d100/fate/process()
	slowdown = rand(-10, 10)/10
	if(iscarbon(loc))
		var/mob/living/carbon/wielder = loc
		if(wielder.is_holding(src))
			wielder.update_equipment_speed_mods()

/datum/uplink_item/badass/fate_dice100
	name = "Fate D100"
	desc = "Super prikol."
	item = /obj/item/dice/d100/fate/one_use
	cost = 40
