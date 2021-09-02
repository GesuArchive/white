/**
 * # Spider Charge
 *
 * A unique version of c4 possessed only by the space ninja.  Has a stronger blast radius.
 * Can only be detonated by space ninjas with the bombing objective.  Can only be set up where the objective says it can.
 * When it primes, the space ninja responsible will have their objective set to complete.
 *
 */
/obj/item/grenade/c4/ninja
	name = "Заряд паука"
	desc = "Модифицированный заряд C-4, предоставленный вам кланом пауков. Его взрывная сила была увеличена, но он работает только в одной конкретной области."
	boom_sizes = list(4, 8, 12)
	var/mob/detonator = null

/obj/item/grenade/c4/ninja/afterattack(atom/movable/AM, mob/user, flag)
	var/datum/antagonist/ninja/ninja_antag = user.mind.has_antag_datum(/datum/antagonist/ninja)
	if(!ninja_antag)
		to_chat(user, span_notice("Несмотря на то, что вроде как всё в порядке, я не могу взорвать заряд."))
		return
	var/datum/objective/plant_explosive/objective = locate() in ninja_antag.objectives
	if(!objective)
		to_chat(user, span_notice("Кажется, я не могу активировать заряд. Он должен детонировать в какой-то конкретной локации, но я не знаю, где его взорвать."))
		return
	if(objective.detonation_location != get_area(user))
		to_chat(user, span_notice("Это не то место, где я должен это использовать!"))
		return
	detonator = user
	return ..()

/obj/item/grenade/c4/ninja/detonate(mob/living/lanced_by)
	. = ..()
	//Since we already did the checks in afterattack, the denonator must be a ninja with the bomb objective.
	if(!detonator)
		return
	var/datum/antagonist/ninja/ninja_antag = detonator.mind.has_antag_datum(/datum/antagonist/ninja)
	var/datum/objective/plant_explosive/objective = locate() in ninja_antag.objectives
	objective.completed = TRUE
