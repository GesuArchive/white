#define DEFAULT_TASTE_SENSITIVITY 15

/mob/living
	var/last_taste_time
	var/last_taste_text

/**
 * Gets taste sensitivity of given mob
 *
 * This is used in calculating what flavours the mob can pick up,
 * with a lower number being able to pick up more distinct flavours.
 */
/mob/living/proc/get_taste_sensitivity()
	return DEFAULT_TASTE_SENSITIVITY

/mob/living/carbon/get_taste_sensitivity()
	var/obj/item/organ/tongue/tongue = get_organ_slot(ORGAN_SLOT_TONGUE)
	if(istype(tongue))
		. = tongue.taste_sensitivity
	else
		// carbons without tongues normally have TRAIT_AGEUSIA but sensible fallback
		. = DEFAULT_TASTE_SENSITIVITY

// non destructively tastes a reagent container
/mob/living/proc/taste(datum/reagents/from)
	if(HAS_TRAIT(src, TRAIT_AGEUSIA))
		return


	if(last_taste_time + 50 < world.time)
		var/taste_sensitivity = get_taste_sensitivity()
		var/text_output = from.generate_taste_message(src, taste_sensitivity)
		// We dont want to spam the same message over and over again at the
		// person. Give it a bit of a buffer.
		if(hallucination > 50 && prob(25))
			text_output = pick("пауки","мечты","кошмары","будущее","прошлое","победа",\
			"поражение","боль","блаженство","месть","отрава","время","космос","смерть","жизнь","правда","ложь","справедливость","память",\
			"сожаления","моя душа","страдания","музыка","шум","кровь","голод","солнцеликий")
		if(text_output != last_taste_text || last_taste_time + 100 < world.time)
			to_chat(src, span_notice("На вкус как [text_output]."))
			// "something indescribable" -> too many tastes, not enough flavor.

			last_taste_time = world.time
			last_taste_text = text_output

#undef DEFAULT_TASTE_SENSITIVITY
