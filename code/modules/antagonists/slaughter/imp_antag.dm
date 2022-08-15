//////////////////Imp

/mob/living/simple_animal/hostile/imp
	name = "Имп"
	real_name = "imp"
	unique_name = TRUE
	desc = "Не очень крупное отталкивающее, мерзкое существо, покрытое угольно-чёрной крепкой чешуей."
	speak_emote = list("кудахчет")
	emote_hear = list("кудахчет","визжит")
	response_help_continuous = "прикасается"
	response_help_simple = "прикасается"
	response_disarm_continuous = "цепляется"
	response_disarm_simple = "цепляется"
	response_harm_continuous = "бьёт"
	response_harm_simple = "бьёт"
	icon = 'icons/mob/mob.dmi'
	icon_state = "imp"
	icon_living = "imp"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speed = 1
	a_intent = INTENT_HARM
	stop_automated_movement = TRUE
	status_flags = CANPUSH
	attack_sound = 'sound/magic/demon_attack1.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 270 //Weak to cold
	maxbodytemp = INFINITY
	faction = list("hell")
	attack_verb_continuous = "яростно разрывает"
	attack_verb_simple = "яростно разрывает"
	maxHealth = 70
	health = 70
	healable = 0
	obj_damage = 15
	melee_damage_lower = 10
	melee_damage_upper = 10
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	del_on_death = TRUE
	death_message = "издаёт ужасный рёв, и распадается на серый дым."
	deathsound = 'sound/magic/demon_dies.ogg'
	var/playstyle_string = "<span class='big bold'>Вы Имп,</span><B> ужасное исчадие из ада. У вас самый низкий ранг в Аду. Даже грешники в Аду ценятся выше вас - они хотя бы забавно визжат, а вы и на это не годны.\
							Вы мерзкий, трусливый, глупый, пошлый, чревоугодливый паразит. Вы очень хотите повышения, а условием для этого является абсолютное, раболепное и угодливое служение старшему Дьяволу. А это значит что: <br>Вы исполняете все приказы Дьявола без исключений.<br>Вам запрещено нападать на Дьявола и других Бесов.<br>Людишки и прочие создания это законная добыча Дьявола и трогать ее без разрешения нельзя.<br>Не создавать лишних проблем Дьяволу или он отправит вас черпать гавно на нижние планы Ада где варятся чревоугодники.<br>Вам правда больше не хочется туда.</B>"
	discovery_points = 10000
