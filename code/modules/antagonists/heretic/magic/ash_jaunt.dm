/datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash
	name = "Пепельная тропа"
	desc = "На короткий промежуток времени этот навык позволяет проходить вам сквозь стены и другие препятствия."
	background_icon_state = "bg_ecult"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "ash_shift"
	sound = null

	school = SCHOOL_FORBIDDEN
	cooldown_time = 15 SECONDS

	invocation = "ASH'N P'SSG'"
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

	exit_jaunt_sound = null
	jaunt_duration = 1.1 SECONDS
	jaunt_in_time = 1.3 SECONDS
	jaunt_out_time = 0.6 SECONDS
	jaunt_in_type = /obj/effect/temp_visual/dir_setting/ash_shift
	jaunt_out_type = /obj/effect/temp_visual/dir_setting/ash_shift/out

/datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash/do_steam_effects()
	return

/datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash/long
	name = "Ashen Walk"
	desc = "A long range spell that allows you pass unimpeded through multiple walls."
	jaunt_duration = 5 SECONDS

/obj/effect/temp_visual/dir_setting/ash_shift
	name = "ash_shift"
	icon = 'icons/mob/mob.dmi'
	icon_state = "ash_shift2"
	duration = 1.3 SECONDS

/obj/effect/temp_visual/dir_setting/ash_shift/out
	icon_state = "ash_shift"
