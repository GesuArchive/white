/obj/structure/musician
	name = "Не пианино"
	desc = "Что-то сломалось, свяжитесь с coderbus."
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND | INTERACT_ATOM_UI_INTERACT | INTERACT_ATOM_REQUIRES_DEXTERITY
	var/can_play_unanchored = FALSE
	var/list/allowed_instrument_ids = list("r3grand","r3harpsi","crharpsi","crgrand1","crbright1", "crichugan", "crihamgan","piano")
	var/datum/song/song

/obj/structure/musician/Initialize(mapload)
	. = ..()
	song = new(src, allowed_instrument_ids)
	allowed_instrument_ids = null

/obj/structure/musician/Destroy()
	QDEL_NULL(song)
	return ..()

/obj/structure/musician/proc/should_stop_playing(atom/music_player)
	if(!(anchored || can_play_unanchored) || !ismob(music_player))
		return STOP_PLAYING
	var/mob/user = music_player
	if(!user.canUseTopic(src, FALSE, TRUE, FALSE, FALSE)) //can play with TK and while resting because fun.
		return STOP_PLAYING

/obj/structure/musician/ui_interact(mob/user)
	. = ..()
	song.ui_interact(user)

/obj/structure/musician/wrench_act(mob/living/user, obj/item/I)
	default_unfasten_wrench(user, I, 40)
	return TRUE

/obj/structure/musician/piano
	name = "космический минимуг"
	icon = 'icons/obj/musician.dmi'
	icon_state = "minimoog"
	anchored = TRUE
	density = TRUE

/obj/structure/musician/piano/unanchored
	anchored = FALSE

/obj/structure/musician/piano/Initialize(mapload)
	. = ..()
	if(prob(50) && icon_state == initial(icon_state))
		name = "космический минимуг"
		desc = "Это минимуг, как космическое пианино, но более космический! Иногда его называют космическим синтезатором."
		icon_state = "minimoog"
	else
		name = "космическое пианино"
		desc = "Это космическое пианино, как обычное пианино, но всегда настроено! Даже, когда нет музыканта."
		icon_state = "piano"
