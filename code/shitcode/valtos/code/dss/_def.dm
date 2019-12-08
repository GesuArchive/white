// stats

/client/var/wpp = 0

/mob/living/carbon/human
	var/list/dstats = list(MOB_STR = 10, MOB_STM = 10, MOB_INT = 10, MOB_DEX = 10)
	var/list/bs = list()

// do this shit

/mob/living/carbon/human/proc/StatsInit()
	// рандомизируем стартовые статы

	dstats[MOB_STR] = rand(9, 14)
	dstats[MOB_STM] = rand(7, 12)
	dstats[MOB_INT] = rand(8, 16)
	dstats[MOB_DEX] = rand(7, 13)

	// запоминаем базовые значения

	bs["maxHealth"]			= maxHealth
	bs["armor"]				= dna.species.armor
	bs["punchdamagelow"]	= dna.species.punchdamagelow
	bs["punchdamagehigh"]   = dna.species.punchdamagehigh
	bs["punchstunthreshold"]= dna.species.punchstunthreshold
	bs["brutemod"]			= dna.species.brutemod
	bs["burnmod"]			= dna.species.burnmod
	bs["coldmod"]			= dna.species.coldmod
	bs["heatmod"]			= dna.species.heatmod
	bs["stunmod"]			= dna.species.stunmod
	bs["speedmod"]			= dna.species.speedmod
	bs["next_move_modifier"]= next_move_modifier

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
				dstats[MOB_STR] += rand(1, 5)
				dstats[MOB_STM] += rand(1, 5)
				dstats[MOB_INT] += rand(1, 5)
				dstats[MOB_DEX] += rand(1, 5)

		recalculate_stats()

/mob/living/carbon/human/proc/recalculate_stats()

	// калькулируем модификаторы

	if(dstats[MOB_INT] <= 0)
		visible_message("<span class='suicide'><b>[name]</b> падает на пол закатив свои глаза!</span>")
		setOrganLoss(ORGAN_SLOT_BRAIN, 200)
		return

	maxHealth 					   = FLOOR((bs["maxHealth"]           	 * (dstats[MOB_STR] + dstats[MOB_STM]										  ))  / 20, 1)
	dna.species.armor 			   = FLOOR((bs["armor"]         	  	 * (dstats[MOB_STR] + dstats[MOB_STM]									 	  ))  / 20, 1)
	dna.species.punchdamagelow 	   = FLOOR((bs["punchdamagelow"]    	 * (dstats[MOB_STR] + dstats[MOB_STM] + ((dstats[MOB_INT] + dstats[MOB_DEX])/2))) / 30, 1)
	dna.species.punchdamagehigh    = FLOOR((bs["punchdamagehigh"]   	 * (dstats[MOB_STR] + dstats[MOB_STM] + ((dstats[MOB_INT] + dstats[MOB_DEX])/2))) / 30, 1)
	dna.species.punchstunthreshold = CEILING((bs["punchstunthreshold"]   * (dstats[MOB_STR] + dstats[MOB_STM] + ((dstats[MOB_INT] + dstats[MOB_DEX])/2))) / 30, 20)
	dna.species.brutemod 		   = bs["brutemod"]			  			 / ((dstats[MOB_STR] + dstats[MOB_STM]) / 20)
	dna.species.burnmod 		   = bs["burnmod"]			  			 / ((dstats[MOB_STR] + dstats[MOB_STM]) / 20)
	dna.species.coldmod 		   = bs["coldmod"]			  			 / ((dstats[MOB_STR] + dstats[MOB_STM]) / 20)
	dna.species.heatmod 		   = bs["heatmod"]			  			 / ((dstats[MOB_STR] + dstats[MOB_STM]) / 20)
	dna.species.stunmod 		   = bs["stunmod"]   		  			 / ((dstats[MOB_STR] + dstats[MOB_STM] + dstats[MOB_DEX]) / 30)
	dna.species.speedmod 		   = bs["speedmod"]  		  			 / (dstats[MOB_DEX] / 10)
	next_move_modifier			   = bs["next_move_modifier"] 			 / (dstats[MOB_DEX] / 10)

/mob/living/carbon/human/UnarmedAttack(atom/A, proximity)
	. = ..()
	if(dstats[MOB_STR] <= 29)
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
		stat("Сила: ",			FLOOR(dstats["strength"], 1))
		stat("Выносливость:",   FLOOR(dstats["stamina"], 1))
		stat("Интеллект:",      FLOOR(dstats["intelligence"], 1))
		stat("Ловкость:",       FLOOR(dstats["dexterity"], 1))
		stat("Сила воли:",      client.wpp)
