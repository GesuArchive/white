/datum/component/glutton
	// счётчик пожраного
	var/bites_taken = 0
	// попытки пожрать что-то
	var/attempts_to_eat = 0
	var/mob/living/carbon/human/our_eater

/datum/component/glutton/Initialize(faster_than_light = FALSE)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	our_eater = parent
	if(faster_than_light)
		START_PROCESSING(SSfastprocess, src)
	else
		START_PROCESSING(SSobj, src)

/datum/component/glutton/process()
	if(!our_eater)
		STOP_PROCESSING(SSobj, src)
		STOP_PROCESSING(SSfastprocess, src)
	if(!eat() && attempts_to_eat > 10)
		our_eater.visible_message(span_danger("[our_eater] делает [bites_taken] укусов и лопается!"), span_userdanger("Лопаюсь после [bites_taken] укусов!"))
		our_eater.gib()

/datum/component/glutton/proc/eat()
	var/obj/item/food/tasty_thing = safepick(GLOB.all_food)
	if(tasty_thing)
		var/datum/component/edible/E = tasty_thing.GetComponent(/datum/component/edible)
		if(E)
			our_eater.visible_message(span_notice("[our_eater] кушает [tasty_thing]."), span_notice("Кушаю [tasty_thing]."))
			E.TakeBite(our_eater, our_eater)
			bites_taken++
			attempts_to_eat = 0
			return TRUE
	attempts_to_eat++
	return FALSE

