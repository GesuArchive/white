/datum/quirk/semiviolent
	name = "ѕолупацифист"
	desc = "ћысль о насилии заставл€ет вас чувствовать себ€ непри€тно. Ќастолько, что вы не можете нанести вред окружающим."
	value = 1
	//mob_trait = TRAIT_PACIFISM
	gain_text = "<span class='danger'>¬ы чувствуете себ€ жутко, подумав о насилии!</span>"
	lose_text = "<span class='notice'>¬ы чувствуете, что вы можете защитить себ€ вновь.</span>"
	medical_record_text = "ѕациент €вл€етс€ пацифистом и не может заставить себ€ причинить вред кому-либо."
	var/ragemode_time = 0
	var/duration = 600
	var/cooldown = 3600
	var/old_color
	var/static/list/red_splash = list(1,0,0,0.8,0.2,0, 0.8,0,0.2,0.1,0,0)
	var/static/list/pure_red = list(0,0,0,0,0,0,0,0,0,1,0,0)


/datum/quirk/semiviolent/on_process()
	if(ragemode_time > 0)
		ragemode_time--
		return
	else if(ragemode_time < 0)
		ragemode_time++
		return

	if(quirk_holder.health < 65)
		if(HAS_TRAIT_FROM(quirk_holder,TRAIT_PACIFISM, "semiviolent"))
			REMOVE_TRAIT(quirk_holder, TRAIT_PACIFISM, "semiviolent")

		ragemode_time += duration
		quirk_holder.reagents.add_reagent(/datum/reagent/medicine/ephedrine,2)
		rage_effect()
	else
		if(!HAS_TRAIT_FROM(quirk_holder,TRAIT_PACIFISM, "semiviolent"))
			ADD_TRAIT(quirk_holder, TRAIT_PACIFISM, "semiviolent")

		ragemode_time -= cooldown
		quirk_holder.reagents.add_reagent(/datum/reagent/toxin/skewium,10)


/datum/quirk/semiviolent/proc/rage_effect()
	if(!quirk_holder.client || !iscarbon(quirk_holder))
		return
	var/mob/living/carbon/M = quirk_holder

	to_chat(M, "<span class='reallybig redtext'>RIP AND TEAR</span>")

	var/old_color = M.client.color

	animate(M.client,color = red_splash, time = 10, easing = SINE_EASING|EASE_OUT)
	sleep(10)
	animate(M.client,color = old_color, time = duration)//, easing = SINE_EASING|EASE_OUT)


/*
var/obj/effect/mine/pickup/bloodbath/B = new(H)
INVOKE_ASYNC(B, /obj/effect/mine/pickup/bloodbath/.proc/mineEffect, H)
*/