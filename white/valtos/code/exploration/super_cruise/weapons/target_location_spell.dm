/*
 * To target ships, we need to be able to see which turf is being targetted.
 * The problem with this is that ByondUI doesn't have an onclick function.
 * However, the turf you click on, counts as being a turf even if you click on the ByondUI.
 * This is cool, because we can give a weapon target spell,
 * get the turf that was clicked on, check if its on the ship selected and then boom, weapon targetted.
 *
 * Honestly, this is super janky and it kind of triggers me a little that I haven't figured out a better way to do it.
 * Perhaps just overlay another screen that intercepts all clicks over the top of the displayed map?
*/

/datum/action/cooldown/spell/pointed/set_weapon_target
	name = "Выбрать цель"
	desc = "Выбрать цель?"
	panel = ""
	ranged_mousepointer = 'icons/effects/mouse_pointers/cult_target.dmi'
	spell_requirements = NONE
	var/obj/machinery/computer/weapons/linked_console
	cast_range = 255
	active_msg = "Готовлю орудие"
	deactive_msg = "Деактивирую орудие"

/datum/action/cooldown/spell/pointed/set_weapon_target/InterceptClickOn(mob/living/caller, params, atom/target)
	if(!linked_console)
		to_chat(caller, "<span class='warning'>Не вижу консоль.</span>")
		unset_click_ability(caller)
		return FALSE
	if(!linked_console.can_interact(caller))
		to_chat(caller, "<span class='warning'>Слишком далеко!</span>")
		unset_click_ability(caller)
		return FALSE
	var/turf/T = get_turf(target)
	if(!T)
		unset_click_ability(caller)
		return FALSE
	to_chat(caller, "<span class='notice'>Цель выбрана.</span>")
	if(prob(2))
		caller.say("ОГОНЬ!!!!", forced = "Shuttle weapon firing")
	var/obj/machinery/shuttle_weapon/weapon = linked_console.selected_weapon_system.resolve()
	caller.log_message("fired [weapon ? "[weapon] " : ""] at [AREACOORD(T)]", LOG_ATTACK, color="purple")
	log_shuttle_attack("fired [weapon ? "[weapon] " : ""] at [AREACOORD(T)]")
	linked_console.on_target_location(T)
	unset_click_ability(caller, FALSE)
	return TRUE

/datum/action/cooldown/spell/pointed/set_weapon_target/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(!.)
		return

	qdel(src)
