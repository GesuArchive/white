/mob/living/simple_animal/hostile/megafauna/reimu
	name = "Reimu Hakurei"
	desc = "Wow, cute anime girl."
	health = 1250
	maxHealth = 1250
	attack_verb_continuous = "вхуячивает"
	attack_verb_simple = "въёбывает"
	attack_sound = 'sound/weapons/sonic_jackhammer.ogg'
	icon_state = "hierophant"
	icon_living = "hierophant"
	friendly_verb_continuous = "презрительно смотрит"
	friendly_verb_simple = "презрительно смотрит"
	icon = 'icons/mob/lavaland/hierophant_new.dmi'
	faction = list("boss")
	speak_emote = list("выдаёт")
	armour_penetration = 20
	melee_damage_lower = 15
	melee_damage_upper = 25
	speed = 5
	move_to_delay = 5
	ranged = TRUE
	ranged_cooldown_time = 10
	aggro_vision_range = 21
	loot = list()
	crusher_loot = list(/obj/item/crusher_trophy/vortex_talisman)
	wander = FALSE
	gps_name = "Reimu Signal"
	achievement_type = /datum/award/achievement/boss/reimu_kill
	crusher_achievement_type = /datum/award/achievement/boss/reimu_crusher
	score_achievement_type = /datum/award/score/reimu_score
	del_on_death = TRUE
	deathsound = 'sound/magic/repulse.ogg'
	attack_action_types = list(/datum/action/innate/megafauna_attack/blaster,
							   /datum/action/innate/megafauna_attack/waver,
							   /datum/action/innate/megafauna_attack/intercepter,
							   /datum/action/innate/megafauna_attack/spammer)

/datum/action/innate/megafauna_attack/blaster
	name = "Blaster"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	chosen_message = "<span class='colossus'>Стреляю быстро одиночными.</span>"
	chosen_attack_num = 1

/datum/action/innate/megafauna_attack/waver
	name = "Waver"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "hierophant_squares_indefinite"
	chosen_message = "<span class='colossus'>Стреляю волной.</span>"
	chosen_attack_num = 2

/datum/action/innate/megafauna_attack/intercepter
	name = "Intercepter"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "hierophant_blast_indefinite"
	chosen_message = "<span class='colossus'>Перемещаюсь быстро к цели.</span>"
	chosen_attack_num = 3

/datum/action/innate/megafauna_attack/spammer
	name = "Spammer"
	icon_icon = 'icons/obj/lavaland/artefacts.dmi'
	button_icon_state = "hierophant_club_ready_beacon"
	chosen_message = "<span class='colossus'>Ебошу во все стороны.</span>"
	chosen_attack_num = 4
