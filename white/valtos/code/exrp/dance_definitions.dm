/datum/interaction/assslap
	command = "assslap"
	description = "Шлёпнуть по заднице."
	simple_message = "USER шлёпает TARGET по заднице!"
	simple_style = "danger"
	interaction_sound = 'white/valtos/sounds/exrp/interactions/slap.ogg'
	needs_physical_contact = 1
	max_distance = 1
	write_log_user = "ass-slapped"
	write_log_target = "was ass-slapped by"

/datum/interaction/dancero
	command = "dancero"
	description = "Отполировать пельмешку."
	require_user_mouth = 1
	require_target_danceress = 1
	write_log_user = "gave head to"
	write_log_target = "was given head by"
	interaction_sound = null
	user_not_tired = 1
	require_target_naked = 1
	max_distance = 1
	write_log_user = "dancered"
	write_log_target = "was dancered by"

/datum/interaction/dancero/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_dancero")

/datum/interaction/dancero/dancejob
	command = "dancejob"
	description = "Отполировать огурец."
	require_target_danceress = 0
	require_target_dancer = 1
	target_not_tired = 1
	write_log_user = "dancejobed"
	write_log_target = "was dancejobed by"

/datum/interaction/dance
	command = "dance"
	description = "Раскромсать вареник."
	require_user_dancer = 1
	require_target_danceress = 1
	write_log_user = "danced"
	write_log_target = "was danced by"
	interaction_sound = null
	user_not_tired = 1
	require_user_naked = 1
	require_target_naked = 1
	max_distance = 0
	write_log_user = "danced"
	write_log_target = "was danced by"

/datum/interaction/dance/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_dance")

/datum/interaction/dance/dancor
	command = "danceass"
	description = "Пробить шоколадницу."
	require_target_danceress = 0
	require_target_dancor = 1
	user_not_tired = 1
	write_log_user = "ass-danced"
	write_log_target = "was ass-danced by"

/datum/interaction/dance/dancor/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_dancor")


/datum/interaction/dancering
	command = "dancering"
	description = "Засунуть сигарету в пепельницу."
	require_user_hands = 1
	require_target_danceress = 1
	interaction_sound = null
	user_not_tired = 1
	require_target_naked = 1
	max_distance = 1
	write_log_user = "dancered"
	write_log_target = "was dancered by"

/datum/interaction/finger/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_dancering")

/datum/interaction/fingerdance
	command = "fingerdance"
	description = "Почесать шоколадный глаз."
	interaction_sound = null
	require_user_hands = 1
	require_target_dancor = 1
	user_not_tired = 1
	require_target_naked = 1
	max_distance = 1
	write_log_user = "fingerdanced"
	write_log_target = "was fingerdanced by"

/datum/interaction/fingerdance/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_fingerdance")


/datum/interaction/facedance
	command = "facedance"
	description = "Проверить глубину проруби."
	interaction_sound = null
	require_target_mouth = 1
	user_not_tired = 1
	require_user_naked = 1
	max_distance = 0
	write_log_user = "face-danced"
	write_log_target = "was face-danced by"

/datum/interaction/facedance/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_facedance")

/datum/interaction/throatdance
	command = "throatdance"
	description = "Утопить муму в проруби."
	interaction_sound = null
	require_user_dancer = 1
	require_target_mouth = 1
	user_not_tired = 1
	require_user_naked = 1
	max_distance = 0
	write_log_user = "throat-danced"
	write_log_target = "was throat-danced by"

/datum/interaction/throatdance/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_throatdance")

/datum/interaction/handdance
	command = "handdance"
	description = "Полировать ствол."
	interaction_sound = null
	require_user_hands = 1
	require_target_dancer = 1
	target_not_tired = 1
	require_target_naked = 1
	max_distance = 1
	write_log_user = "danced-off"
	write_log_target = "was danced-off by"

/datum/interaction/handdance/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_handdance")

/datum/interaction/breastdance
	command = "breastdance"
	description = "Проскользить между двух горок."
	interaction_sound = null
	require_user_dancer = 1
	user_not_tired = 1
	require_user_naked = 1
	require_target_naked = 1
	require_target_danceress = 1
	max_distance = 0
	write_log_user = "breast-danced"
	write_log_target = "was breast-danced by"

/datum/interaction/breastdance/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_breastdance")

/datum/interaction/mount
	command = "mount"
	description = "Покататься на карусели."
	interaction_sound = null
	require_user_danceress = 1
	require_target_dancer = 1
	user_not_tired = 1
	target_not_tired = 1
	require_user_naked = 1
	require_target_naked = 1
	max_distance = 0
	write_log_user = "rode"
	write_log_target = "was rode by"

/datum/interaction/mount/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_mount")

/datum/interaction/assdance
	command = "assdance"
	description = "Присесть на выступ."
	interaction_sound = null
	require_user_danceress = 0
	require_user_dancor = 1
	require_target_dancer = 1
	user_not_tired = 1
	target_not_tired = 1
	require_user_naked = 1
	require_target_naked = 1
	max_distance = 0
	write_log_user = "assdance"
	write_log_target = "was assdance by"

/datum/interaction/assdance/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_assdance")

/datum/interaction/rimdance
	command = "rimdance"
	description = "Скушать шоколад."
	interaction_sound = null
	require_user_mouth = 1
	require_target_dancor = 1
	user_not_tired = 1
	require_target_naked = 1
	max_distance = 0
	write_log_user = "rimdanced"
	write_log_target = "was rimdanced by"

/datum/interaction/rimdance/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_rimdance")

/datum/interaction/mountdance
	command = "mountdance"
	description = "Промариновать лимончик."
	interaction_sound = null
	require_target_mouth = 1
	require_user_dancor = 1
	user_not_tired = 1
	require_user_naked = 1
	max_distance = 0
	write_log_user = "made-them-rim"
	write_log_target = "was made-to-rim by"

/datum/interaction/mountdance/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_mountdance")

/datum/interaction/danceface
	command = "danceface"
	description = "Дать понюхать ноги."
	interaction_sound = null
	require_target_mouth = 1
	max_distance = 0
	write_log_user = "feet-faced"
	write_log_target = "had feet grinded against their face by"

/datum/interaction/danceface/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_danceface")

/datum/interaction/dancemouth
	command = "dancemouth"
	description = "Угостить ногами."
	interaction_sound = null
	require_target_mouth = 1
	max_distance = 0
	write_log_user = "feet-mouthed"
	write_log_target = "had feet grinding against their tongue by"

/datum/interaction/dancemouth/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_dancemouth")

/datum/interaction/eggs
	command = "eggs"
	description = "Накормить яишницей."
	interaction_sound = null
	require_user_naked = 1
	require_user_dancer = 1
	require_target_mouth = 1
	max_distance = 0
	write_log_user = "make-them-eat-some-eggs"
	write_log_target = "was made to eat eggs by"

/datum/interaction/eggs/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_eggs")

/datum/interaction/thighs
	command = "thighs"
	description = "Взять в захват ногами."
	interaction_sound = null
	max_distance = 0
	require_user_naked = 1
	require_target_mouth = 1
	write_log_user = "thigh-trapped"
	write_log_target = "was smothered by"

/datum/interaction/thighs/display_interaction(var/mob/living/user, var/mob/living/target)
	. = ..()
	user.do_dance(target, "do_thighs")
