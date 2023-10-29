/datum/action/item_action/ninja_stealth
	name = "Переключение скрытности"
	desc = "Включает и выключает скрытый режим."
	button_icon_state = "ninja_cloak"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'

/**
 * Proc called to toggle ninja stealth.
 *
 * Proc called to toggle whether or not the ninja is in stealth mode.
 * If cancelling, calls a separate proc in case something else needs to quickly cancel stealth.
 */
/obj/item/clothing/suit/space/space_ninja/proc/toggle_stealth()
	var/mob/living/carbon/human/ninja = affecting
	if(!ninja)
		return
	if(stealth)
		cancel_stealth()
	else
		if(cell.charge <= 0)
			to_chat(ninja, span_warning("У вас недостаточно энергии, чтобы включить скрытность!"))
			return
		stealth = !stealth
		animate(ninja, alpha = 20,time = 12)
		ninja.visible_message(span_warning("[ninja.name] исчезает в воздухе!") , \
						span_notice("Теперь я в основном невидим для обычного обнаружения."))

/**
 * Proc called to cancel stealth.
 *
 * Called to cancel the stealth effect if it is ongoing.
 * Does nothing otherwise.
 * Arguments:
 * * Returns false if either the ninja no longer exists or is already visible, returns true if we successfully made the ninja visible.
 */
/obj/item/clothing/suit/space/space_ninja/proc/cancel_stealth()
	var/mob/living/carbon/human/ninja = affecting
	if(!ninja)
		return FALSE
	if(stealth)
		stealth = !stealth
		animate(ninja, alpha = 255, time = 12)
		ninja.visible_message(span_warning("[ninja.name] появляется из ниоткуда!") , \
						span_notice("Теперь я видим."))
		return TRUE
	return FALSE
