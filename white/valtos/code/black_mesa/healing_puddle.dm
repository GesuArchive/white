/obj/structure/water_source/puddle/healing
	name = "целебный прудик"
	desc = "С помощью какой-то потусторонней силы эта лужа воды, кажется, медленно восстанавливает организм!"
	color = "#71ffff"
	light_range = 3
	light_color = "#71ffff"
	/// How much do we heal the current person?
	var/heal_amount = 2

/obj/structure/water_source/puddle/healing/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/water_source/puddle/healing/process(delta_time)
	for(var/mob/living/iterating_mob in loc)
		iterating_mob.heal_overall_damage(2, 2)
		playsound(src, 'white/valtos/sounds/black_mesa/jelly_scream.ogg', 100)

