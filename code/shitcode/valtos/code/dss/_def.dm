// stats

/client/var/wpp = 0

/mob/living/carbon/human
	var/list/dstats = list(MOB_STR = 10, MOB_STM = 10, MOB_INT = 10, MOB_DEX = 10)

// do this shit

/mob/living/carbon/human/create_dna()
	. = ..()

	// рандомизируем стартовые статы

	dstats[MOB_STR] = rand(9, 14)
	dstats[MOB_STM] = rand(7, 12)
	dstats[MOB_INT] = rand(8, 16)
	dstats[MOB_DEX] = rand(7, 13)

	// аугментируем статы согласно ролям
	spawn(50)
		if(mind)
			switch(mind.assigned_role)
				if("Captain")
					dstats[MOB_STR] += rand(-2, 4)
					dstats[MOB_STM] += rand(-3, 3)
					dstats[MOB_INT] += rand( 0, 5)
					dstats[MOB_DEX] += rand(-1, 6)

				if("Head of Security")
					dstats[MOB_STR] += rand(5, 9)
					dstats[MOB_STM] += rand(6, 9)
					dstats[MOB_INT] += rand(1, 6)
					dstats[MOB_DEX] += rand(3, 6)

				if("Kazakhstan Officer")
					dstats[MOB_STR] += rand(3, 7)
					dstats[MOB_STM] += rand(4, 7)
					dstats[MOB_INT] += rand(4, 7)
					dstats[MOB_DEX] += rand(3, 4)

				if("Warden")
					dstats[MOB_STR] += rand(-2, 3)
					dstats[MOB_STM] += rand( 1, 4)
					dstats[MOB_INT] += rand( 3, 6)
					dstats[MOB_DEX] += rand(-2, 3)

				if("Detective")
					dstats[MOB_STR] += rand(-3, 1)
					dstats[MOB_STM] += rand(4, 6)
					dstats[MOB_INT] += rand(1, 4)
					dstats[MOB_DEX] += rand(4, 10)

				if("Russian Officer")
					dstats[MOB_STR] += rand( 1, 5)
					dstats[MOB_STM] += rand( 3, 6)
					dstats[MOB_INT] += rand(-1, 2)
					dstats[MOB_DEX] += rand( 2, 4)

				if("International Officer")
					dstats[MOB_STR] += rand(1, 3)
					dstats[MOB_STM] += rand(3, 4)
					dstats[MOB_INT] += rand(0, 4)
					dstats[MOB_DEX] += rand(3, 6)

				if("Lawyer")
					dstats[MOB_STR] += rand(-4, 0)
					dstats[MOB_STM] += rand(-5, 1)
					dstats[MOB_INT] += rand( 1, 6)
					dstats[MOB_DEX] += rand(-2, 3)

				if("Head of Personnel")
					dstats[MOB_STR] += rand(-3, 1)
					dstats[MOB_STM] += rand(-4, 2)
					dstats[MOB_INT] += rand( 2, 6)
					dstats[MOB_DEX] += rand(-3, 1)

				if("Quartermaster")
					dstats[MOB_STR] += rand( 1, 3)
					dstats[MOB_STM] += rand(-1, 2)
					dstats[MOB_INT] += rand( 4, 5)
					dstats[MOB_DEX] += rand( 4, 12)

				if("Cargo Technician")
					dstats[MOB_STR] += rand( 3, 6)
					dstats[MOB_STM] += rand( 2, 4)
					dstats[MOB_INT] += rand(-6, 1)
					dstats[MOB_DEX] += rand( 10, 15)

				if("Shaft Miner")
					dstats[MOB_STR] += rand(5, 8)
					dstats[MOB_STM] += rand(4, 9)
					dstats[MOB_INT] += rand(2, 3)
					dstats[MOB_DEX] += rand(6, 9)

				if("Clown") // HONK
					dstats[MOB_STR] += rand(-5, 7)
					dstats[MOB_STM] += rand(-5, 7)
					dstats[MOB_INT] += rand(-5, 7)
					dstats[MOB_DEX] += rand(-5, 7)

				if("Mime")
					dstats[MOB_STR] += rand(-2, 2)
					dstats[MOB_STM] += rand(-2, 2)
					dstats[MOB_INT] += rand( 4, 9)
					dstats[MOB_DEX] += rand( 5, 9)

				if("Janitor")
					dstats[MOB_STR] += rand(-3, 1)
					dstats[MOB_STM] += rand(-2, 1)
					dstats[MOB_INT] += rand(-4, 0)
					dstats[MOB_DEX] += rand( 2, 4)

				if("Cook")
					dstats[MOB_STR] += rand( 5, 9)
					dstats[MOB_STM] += rand( 1, 4)
					dstats[MOB_INT] += rand(-1, 2)
					dstats[MOB_DEX] += rand( 2, 6)

				if("Botanist")
					dstats[MOB_STR] += rand( 2, 4)
					dstats[MOB_STM] += rand(-2, 2)
					dstats[MOB_INT] += rand( 4, 6)
					dstats[MOB_DEX] += rand( 1, 3)

				if("Bartender")
					dstats[MOB_STR] += rand( 2, 3)
					dstats[MOB_STM] += rand(-3, 4)
					dstats[MOB_INT] += rand( 1, 3)
					dstats[MOB_DEX] += rand( 7, 12)

				if("Curator")
					dstats[MOB_STR] += rand(-2, 6)
					dstats[MOB_STM] += rand(-5, 2)
					dstats[MOB_INT] += rand( 6, 9)
					dstats[MOB_DEX] += rand( 2, 6)

				if("Chaplain")
					dstats[MOB_STR] += rand( 2, 5)
					dstats[MOB_STM] += rand( 2, 4)
					dstats[MOB_INT] += rand(-6, 2)
					dstats[MOB_DEX] += rand( 2, 2)

				if("Assistant") // никому не нужный (tm)
					dstats[MOB_STR] += rand(-3, 2)
					dstats[MOB_STM] += rand(-3, 3)
					dstats[MOB_INT] += rand(-6, 3)
					dstats[MOB_DEX] += rand(-3, 3)

				if("Chief Medical Officer")
					dstats[MOB_STR] += rand(1, 4)
					dstats[MOB_STM] += rand(-1, 4)
					dstats[MOB_INT] += rand(5, 7)
					dstats[MOB_DEX] += rand(3, 7)

				if("Medical Doctor")
					dstats[MOB_STR] += rand(-1, 2)
					dstats[MOB_STM] += rand(-2, 3)
					dstats[MOB_INT] += rand(2, 5)
					dstats[MOB_DEX] += rand(2, 3)

				if("Chemist") // сторчался
					dstats[MOB_STR] += rand(-4, 4)
					dstats[MOB_STM] += rand(-4, 4)
					dstats[MOB_INT] += rand(-4, 4)
					dstats[MOB_DEX] += rand(-4, 4)

				if("Virologist")
					dstats[MOB_STR] += rand( 1, 2)
					dstats[MOB_STM] += rand(-2, 3)
					dstats[MOB_INT] += rand( 1, 5)
					dstats[MOB_DEX] += rand(-3, 1)

				if("Geneticist")
					dstats[MOB_STR] += rand( 3, 7)
					dstats[MOB_STM] += rand( 1, 5)
					dstats[MOB_INT] += rand( 6, 10)
					dstats[MOB_DEX] += rand(-3, 1)

				if("Chief Engineer")
					dstats[MOB_STR] += rand(1, 5)
					dstats[MOB_STM] += rand(2, 3)
					dstats[MOB_INT] += rand(2, 7)
					dstats[MOB_DEX] += rand(2, 5)

				if("Station Engineer")
					dstats[MOB_STR] += rand(3, 6)
					dstats[MOB_STM] += rand(1, 3)
					dstats[MOB_INT] += rand(-1, 4)
					dstats[MOB_DEX] += rand(4, 9)

				if("Atmospheric Technician")
					dstats[MOB_STR] += rand(2, 4)
					dstats[MOB_STM] += rand(-1, 2)
					dstats[MOB_INT] += rand(4, 8)
					dstats[MOB_DEX] += rand(5, 10)

				if("Research Director")
					dstats[MOB_STR] += rand(-5, 3)
					dstats[MOB_STM] += rand(-6, 2)
					dstats[MOB_INT] += rand(12, 15)
					dstats[MOB_DEX] += rand(-4, 2)

				if("Scientist")
					dstats[MOB_STR] += rand(-1, 4)
					dstats[MOB_STM] += rand(-1, 3)
					dstats[MOB_INT] += rand(9, 12)
					dstats[MOB_DEX] += rand(-2, 3)

				if("Roboticist")
					dstats[MOB_STR] += rand(2, 3)
					dstats[MOB_STM] += rand(-3, 1)
					dstats[MOB_INT] += rand(7, 10)
					dstats[MOB_DEX] += rand(-4, 1)

			// если антаг, то
			if(mind.special_role) // пока бустаем статы всем антагам
				dstats[MOB_STR] += rand(5, 10)
				dstats[MOB_STM] += rand(5, 10)
				dstats[MOB_INT] += rand(5, 10)
				dstats[MOB_DEX] += rand(5, 10)

		recalculate_stats()

/mob/living/carbon/human/proc/recalculate_stats()

	// калькулируем модификаторы

	if(dstats[MOB_STR] >= 40)
		visible_message("<span class='suicide'><b>[name]</b> разлетается на куски!</span>")
		gib()
		return

	if(dstats[MOB_INT] <= 0)
		visible_message("<span class='suicide'><b>[name]</b> падает на пол закатив свои глаза!</span>")
		setOrganLoss(ORGAN_SLOT_BRAIN, 200)
		return

	if(dstats[MOB_INT] >= 40)
		var/obj/item/organ/brain/B = getorganslot(ORGAN_SLOT_BRAIN)
		var/turf/T = get_turf(src)
		var/turf/target = get_ranged_target_turf(src, turn(dir, 180), 1)
		B.Remove(src)
		B.forceMove(T)
		var/datum/callback/gibspawner = CALLBACK(GLOBAL_PROC, /proc/spawn_atom_to_turf, /obj/effect/gibspawner/generic, B, 1, FALSE, src)
		B.throw_at(target, 1, 1, callback=gibspawner)
		visible_message("<span class='suicide'>Мозги <b>[sklonenie(name, VINITELNI, gender)]</b> вырываются из черепной коробки!</span>")
		return

//	if(!dna)
//		return
	var/datum/species/TS = dna.species

	maxHealth 					   = FLOOR((100         			 * (dstats[MOB_STR] + dstats[MOB_STM]										  ))  / 20, 1)
	dna.species.armor 			   = FLOOR((TS.armor         	  	 * (dstats[MOB_STR] + dstats[MOB_STM]									 	  ))  / 20, 1)
	dna.species.punchdamagelow 	   = FLOOR((TS.punchdamagelow    	 * (dstats[MOB_STR] + dstats[MOB_STM] + ((dstats[MOB_INT] + dstats[MOB_DEX])/2))) / 30, 1)
	dna.species.punchdamagehigh    = FLOOR((TS.punchdamagehigh   	 * (dstats[MOB_STR] + dstats[MOB_STM] + ((dstats[MOB_INT] + dstats[MOB_DEX])/2))) / 30, 1)
	dna.species.punchstunthreshold = CEILING((TS.punchstunthreshold  * (dstats[MOB_STR] + dstats[MOB_STM] + ((dstats[MOB_INT] + dstats[MOB_DEX])/2))) / 30, 20)
	dna.species.brutemod 		   = TS.brutemod * ((dstats[MOB_STR] + dstats[MOB_STM]) / 20)
	dna.species.burnmod 		   = TS.burnmod  * ((dstats[MOB_STR] + dstats[MOB_STM]) / 20)
	dna.species.coldmod 		   = TS.coldmod  * ((dstats[MOB_STR] + dstats[MOB_STM]) / 20)
	dna.species.heatmod 		   = TS.heatmod  * ((dstats[MOB_STR] + dstats[MOB_STM]) / 20)
	dna.species.stunmod 		   = TS.stunmod  * ((dstats[MOB_STR] + dstats[MOB_STM] + dstats[MOB_DEX]) / 30)
	dna.species.speedmod 		   = TS.speedmod  / (dstats[MOB_DEX] / 10)
	next_move_modifier			   = 1 / (dstats[MOB_DEX] / 10)

/mob/living/carbon/human/UnarmedAttack(atom/A, proximity)
	. = ..()
	if(dstats[MOB_STR] <= 30)
		return
	if(!proximity)
		return
	if(src.a_intent != INTENT_HARM)
		return
	if(A.attack_hulk(src))
		log_combat(src, A, "punched", "hulk powers")
		src.do_attack_animation(A, ATTACK_EFFECT_SMASH)
		src.changeNext_move(CLICK_CD_MELEE)
		return COMPONENT_NO_ATTACK_HAND


/mob/living/carbon/human/Stat()
	..()
	if(statpanel("Game"))
		stat(null, "--- \[Персонаж\] ---")
		stat("Сила: ",			dstats["strength"])
		stat("Выносливость:",   dstats["stamina"])
		stat("Интеллект:",      dstats["intelligence"])
		stat("Ловкость:",       dstats["dexterity"])
		stat("Сила воли:",      client.wpp)
