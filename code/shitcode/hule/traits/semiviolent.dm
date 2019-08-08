/datum/quirk/semiviolent
	name = "Полупацифист"
	desc = "Мысль о насилии заставляет вас чувствовать себя неприятно. Но всему есть предел..."
	value = 0
	//mob_trait = TRAIT_PACIFISM
	gain_text = "<span class='danger'>Вы чувствуете себя жутко, подумав о насилии!</span>"
	lose_text = "<span class='notice'>Вы чувствуете, что вы можете защитить себя вновь.</span>"
	medical_record_text = "Пациент является пацифистом и не может заставить себя причинить вред кому-либо."
	var/ragemode = FALSE
	var/ragemode_time = 0
	var/duration = 600
	var/cooldown = 3600

/datum/quirk/semiviolent/on_spawn()
	ADD_TRAIT(quirk_holder, TRAIT_PACIFISM, "semiviolent")

/datum/quirk/semiviolent/on_process()
	if(ragemode_time > 0)
		ragemode_time--
		return
	else if(ragemode_time < 0)
		ragemode_time++
		return

	if(quirk_holder.health < 65 && HAS_TRAIT_FROM(quirk_holder,TRAIT_PACIFISM, "semiviolent"))
		REMOVE_TRAIT(quirk_holder, TRAIT_PACIFISM, "semiviolent")

		ragemode_time += duration
		quirk_holder.reagents.add_reagent(/datum/reagent/medicine/ephedrine,2)
		rage_effect()

	else if(!HAS_TRAIT_FROM(quirk_holder,TRAIT_PACIFISM, "semiviolent"))
		ADD_TRAIT(quirk_holder, TRAIT_PACIFISM, "semiviolent")

		ragemode_time -= cooldown
		quirk_holder.reagents.add_reagent(/datum/reagent/toxin/skewium,10)
		ragemode = FALSE

/datum/quirk/semiviolent/proc/rage_effect()
	if(!quirk_holder.client || !iscarbon(quirk_holder))
		return
	var/mob/living/carbon/M = quirk_holder

	to_chat(M, "<span class='reallybig redtext'>RIP AND TEAR</span>")

	var/old_color = M.client.color

	var/static/list/red_splash = list(1,0,0,0.8,0.2,0, 0.8,0,0.2,0.1,0,0)
	var/static/list/pure_red = list(0,0,0,0,0,0,0,0,0,1,0,0)

	animate(M.client,color = red_splash, time = 10, easing = SINE_EASING|EASE_OUT)
	sleep(10)
	animate(M.client,color = old_color, time = duration)//, easing = SINE_EASING|EASE_OUT)


/*
var/obj/effect/mine/pickup/bloodbath/B = new(H)
INVOKE_ASYNC(B, /obj/effect/mine/pickup/bloodbath/.proc/mineEffect, H)
*/