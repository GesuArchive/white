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

	maxHealth 					   = FLOOR((maxHealth         			  * (dstats[MOB_STR] + dstats[MOB_STM]											))  / 20, 1)
	dna.species.armor 			   = FLOOR((dna.species.armor         	  * (dstats[MOB_STR] + dstats[MOB_STM]									 		))  / 20, 1)
	dna.species.punchdamagelow 	   = FLOOR((dna.species.punchdamagelow    * (dstats[MOB_STR] + dstats[MOB_STM] + ((dstats[MOB_INT] + dstats[MOB_DEX])/2))) / 30, 1)
	dna.species.punchdamagehigh    = FLOOR((dna.species.punchdamagehigh   * (dstats[MOB_STR] + dstats[MOB_STM] + ((dstats[MOB_INT] + dstats[MOB_DEX])/2))) / 30, 1)
	dna.species.punchstunthreshold = FLOOR((dna.species.punchstunthreshold* (dstats[MOB_STR] + dstats[MOB_STM] + ((dstats[MOB_INT] + dstats[MOB_DEX])/2))) / 30, 1)
	dna.species.brutemod 		   = FLOOR((dna.species.brutemod          * (dstats[MOB_STR] + dstats[MOB_STM]									  		)) / 20, 1)
	dna.species.burnmod 		   = FLOOR((dna.species.burnmod           * (dstats[MOB_STR] + dstats[MOB_STM]									  		)) / 20, 1)
	dna.species.coldmod 		   = FLOOR((dna.species.coldmod           * (dstats[MOB_STR] + dstats[MOB_STM]									  		)) / 20, 1)
	dna.species.heatmod 		   = FLOOR((dna.species.heatmod           * (dstats[MOB_STR] + dstats[MOB_STM]									  		)) / 20, 1)
	dna.species.stunmod 		   = FLOOR((dna.species.stunmod           * (dstats[MOB_STR] + dstats[MOB_STM] + dstats[MOB_DEX]				 		)) / 30, 1)
	dna.species.speedmod 		   = FLOOR(dna.species.speedmod		  	  / (dstats[MOB_DEX] / 10), 1)
	next_move_modifier			   = FLOOR(next_move_modifier			  / (dstats[MOB_DEX] / 10), 1)

/mob/living/carbon/human/Stat()
	..()
	if(statpanel("Game"))
		stat(null, "--- \[Персонаж\] ---")
		stat(null, "Сила:         [dstats["strength"]]")
		stat(null, "Выносливость: [dstats["stamina"]]")
		stat(null, "Интеллект:    [dstats["intelligence"]]")
		stat(null, "Ловкость:     [dstats["dexterity"]]")
		stat(null, "Сила воли:    [client.wpp]")
