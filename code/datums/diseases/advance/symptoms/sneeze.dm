/*
//////////////////////////////////////

Sneezing

	Very Noticable.
	Increases resistance.
	Doesn't increase stage speed.
	Very transmissible.
	Low Level.

Bonus
	Forces a spread type of AIRBORNE
	with extra range!

//////////////////////////////////////
*/

/datum/symptom/sneeze
	name = "Чихание"
	desc = "Вирус вызывает раздражение носовой полости, иногда заставляя хозяина чихать. Чихание, вызванное этим симптомом, будет распространять вирус в конусе длиной 4 метра перед носителем."
	stealth = -2
	resistance = 3
	stage_speed = 0
	transmittable = 4
	level = 1
	severity = 1
	symptom_delay_min = 5
	symptom_delay_max = 35
	var/spread_range = 4
	var/cartoon_sneezing = FALSE //ah, ah, AH, AH-CHOO!!
	threshold_descs = list(
		"Передача 9" = "Увеличивает дальность чихания, распространяя вирус по конусу длиной 6 метров вместо конуса длиной 4 метра.",
		"Скрытность 4" = "Симптом остается скрытым до тех пор, пока не станет активным.",
		"Скорость 17" = "Сила каждого чихания отбрасывает носителя назад, потенциально оглушая его и слегка повреждая его, если он ударится о стену или другого человека в полете."
	)

/datum/symptom/sneeze/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["transmittable"] >= 9) //longer spread range
		spread_range = 6
	if(A.properties["stealth"] >= 4)
		suppress_warning = TRUE
	if(A.properties["stage_rate"] >= 17) //Yep, stage speed 17, not stage speed 7. This is a big boy threshold (effect), like the language-scrambling transmission one for the voice change symptom.
		cartoon_sneezing = TRUE //for a really fun time, distribute a disease with this threshold met while the gravity generator is down

/datum/symptom/sneeze/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1, 2, 3)
			if(!suppress_warning)
				M.emote("sniff")
		else
			M.emote("sneeze")
			if(M.CanSpreadAirborneDisease()) //don't spread germs if they covered their mouth
				for(var/mob/living/L in oview(spread_range, M))
					if(is_A_facing_B(M, L) && disease_air_spread_walk(get_turf(M), get_turf(L)))
						L.AirborneContractDisease(A, TRUE)
			if(cartoon_sneezing) //Yeah, this can fling you around even if you have a space suit helmet on. It's, uh, bluespace snot, yeah.
				var/sneeze_distance = rand(2,4) //twice as far as a normal baseball bat strike will fling you
				var/turf/target = get_ranged_target_turf(M, turn(M.dir, 180), sneeze_distance)
				M.throw_at(target, sneeze_distance, rand(1,4)) //with the wounds update, sneezing at 7 speed was causing peoples bones to spontaneously explode, turning cartoonish sneezing into a nightmarishly lethal GBS 2.0 outbreak
