/datum/action/cooldown/spell/aoe/area_conversion
	name = "Преобразование пространства"
	desc = "Заклинание, которое мгновенно конвертирует небольшую область вокруг вас."
	background_icon_state = "bg_cult"
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "areaconvert"

	school = SCHOOL_TRANSMUTATION
	cooldown_time = 5 SECONDS

	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	aoe_radius = 2

/datum/action/cooldown/spell/aoe/area_conversion/get_things_to_cast_on(atom/center)
	var/list/things = list()
	for(var/turf/nearby_turf in range(aoe_radius, center))
		things += nearby_turf

	return things

/datum/action/cooldown/spell/aoe/area_conversion/cast_on_thing_in_aoe(turf/victim, atom/caster)
	playsound(victim, 'sound/items/welder.ogg', 75, TRUE)
	victim.narsie_act(FALSE, TRUE, 100 - (get_dist(victim, caster) * 25))
