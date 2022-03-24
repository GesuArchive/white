/datum/component/glutton
	// счётчик пожраного
	var/food_eaten = 0
	var/mob/living/carbon/human/our_eater

/datum/component/glutton/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	our_eater = parent
	START_PROCESSING(SSobj, src)

/datum/component/glutton/process()
	if(!our_eater)
		STOP_PROCESSING(SSobj, src)
	eat()

/datum/component/glutton/proc/eat()
	var/obj/item/food/tasty_thing = pick(GLOB.all_food)
	if(tasty_thing)
		var/datum/component/edible/E = tasty_thing.GetComponent(/datum/component/edible)
		if(E)
			our_eater.visible_message(span_notice("[our_eater] кушает [tasty_thing]."), span_notice("Кушаю [tasty_thing]."))
			E.TakeBite(our_eater, our_eater)

