// stats

/client/var/wpp = 0

/mob/living/carbon/human
	var/list/dstats = list(MOB_STR = 10, MOB_STM = 10, MOB_INT = 10, MOB_DEX = 10)

// do this shit

/mob/living/carbon/human/Initialize()
	. = ..()

	// рандомизируем стартовые статы

	dstats[MOB_STR] = rand(9, 14)
	dstats[MOB_STM] = rand(7, 12)
	dstats[MOB_INT] = rand(8, 16)
	dstats[MOB_DEX] = rand(7, 13)

	recalculate_stats()

/mob/living/carbon/human/proc/recalculate_stats()

	// калькулируем модификаторы

	if(dstats[MOB_STR] >= 30)
		visible_message("<span class='suicide'><b>[name]</b> разлетается на куски!</span>")
		gib()
		return

	if(dstats[MOB_INT] <= 0)
		visible_message("<span class='suicide'><b>[name]</b> падает на пол закатив свои глаза!</span>")
		setOrganLoss(ORGAN_SLOT_BRAIN, 200)
		return

	if(dstats[MOB_INT] >= 30)
		var/obj/item/organ/brain/B = getorganslot(ORGAN_SLOT_BRAIN)
		var/turf/T = get_turf(src)
		var/turf/target = get_ranged_target_turf(src, turn(dir, 180), 1)
		B.Remove(src)
		B.forceMove(T)
		var/datum/callback/gibspawner = CALLBACK(GLOBAL_PROC, /proc/spawn_atom_to_turf, /obj/effect/gibspawner/generic, B, 1, FALSE, src)
		B.throw_at(target, 1, 1, callback=gibspawner)
		visible_message("<span class='suicide'>Мозги <b>[sklonenie(name, VINITELNI, gender)]</b> вырываются из черепной коробки!</span>")
		return

	var/datum/species/TS = dna.species

	maxHealth 					   = FLOOR((100         			 * (dstats[MOB_STR] + dstats[MOB_STM]										  ))  / 20, 1)
	dna.species.armor 			   = FLOOR((TS.armor         	  	 * (dstats[MOB_STR] + dstats[MOB_STM]									 	  ))  / 20, 1)
	dna.species.punchdamagelow 	   = FLOOR((TS.punchdamagelow    	 * (dstats[MOB_STR] + dstats[MOB_STM] + ((dstats[MOB_INT] + dstats[MOB_DEX])/2))) / 30, 1)
	dna.species.punchdamagehigh    = FLOOR((TS.punchdamagehigh   	 * (dstats[MOB_STR] + dstats[MOB_STM] + ((dstats[MOB_INT] + dstats[MOB_DEX])/2))) / 30, 1)
	dna.species.punchstunthreshold = CEILING((TS.punchstunthreshold  * (dstats[MOB_STR] + dstats[MOB_STM] + ((dstats[MOB_INT] + dstats[MOB_DEX])/2))) / 30, 20)
	dna.species.brutemod 		   = (TS.brutemod * (dstats[MOB_STR] + dstats[MOB_STM])) / 20
	dna.species.burnmod 		   = (TS.burnmod  * (dstats[MOB_STR] + dstats[MOB_STM])) / 20
	dna.species.coldmod 		   = (TS.coldmod  * (dstats[MOB_STR] + dstats[MOB_STM])) / 20
	dna.species.heatmod 		   = (TS.heatmod  * (dstats[MOB_STR] + dstats[MOB_STM])) / 20
	dna.species.stunmod 		   = (TS.stunmod  * (dstats[MOB_STR] + dstats[MOB_STM] + dstats[MOB_DEX])) / 30
	dna.species.speedmod 		   = TS.speedmod  / (dstats[MOB_DEX] / 10)
	next_move_modifier			   = next_move_modifier / (dstats[MOB_DEX] / 10)

/mob/living/carbon/human/Stat()
	..()
	if(statpanel("Game"))
		stat(null, "--- \[Персонаж\] ---")
		stat("Сила: ",			dstats["strength"])
		stat("Выносливость:",   dstats["stamina"])
		stat("Интеллект:",      dstats["intelligence"])
		stat("Ловкость:",       dstats["dexterity"])
		stat("Сила воли:",      client.wpp)
