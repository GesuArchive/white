/*
Slimecrossing Mobs
	Mobs and effects added by the slimecrossing system.
	Collected here for clarity.
*/

//Slime transformation power - Burning Black
/datum/action/cooldown/spell/shapeshift/slime_form
	name = "Трансформация в слизь"
	desc = "Трансформируйся из человека в слизь и наоборот!"
	button_icon_state = "transformslime"
	cooldown_time = 0 SECONDS

	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	convert_damage = TRUE
	convert_damage_type = CLONE
	possible_shapes = list(/mob/living/simple_animal/slime/transformed_slime)

	/// If TRUE, we self-delete (remove ourselves) the next time we turn back into a human
	var/remove_on_restore = FALSE

/datum/action/cooldown/spell/shapeshift/slime_form/restore_form(mob/living/shape)
	. = ..()
	if(!.)
		return

	if(remove_on_restore)
		qdel(src)

//Transformed slime - Burning Black
/mob/living/simple_animal/slime/transformed_slime

/mob/living/simple_animal/slime/transformed_slime/Reproduce() //Just in case.
	to_chat(src, span_warning("Не могу ???..."))
	return

//Slime corgi - Chilling Pink
/mob/living/simple_animal/pet/dog/corgi/puppy/slime
	name = "слизневый щенок корги"
	real_name = "slime corgi puppy"
	desc = "Невероятно милый щенок корги из розовой слизи."
	icon_state = "slime_puppy"
	icon_living = "slime_puppy"
	icon_dead = "slime_puppy_dead"
	nofur = TRUE
	gold_core_spawnable = NO_SPAWN
	speak_emote = list("пузырит", "напузыривает", "пузыгавкает")
	emote_hear = list("пузырит!", "пузырится.", "брызгается!")
	emote_see = list("смазывает всё слизью.", "шлёпает.", "покачивается!")
