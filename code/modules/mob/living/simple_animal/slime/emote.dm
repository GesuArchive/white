/datum/emote/slime
	mob_type_allowed_typecache = /mob/living/simple_animal/slime
	mob_type_blacklist_typecache = list()

/datum/emote/slime/bounce
	key = "bounce"
	ru_name = "подпрыгнуть"
	key_third_person = "bounces"
	message = "подпрыгивает на месте."

/datum/emote/slime/jiggle
	key = "jiggle"
	ru_name = "трястись"
	key_third_person = "jiggles"
	message = "трясётся!"

/datum/emote/slime/light
	key = "light"
	ru_name = "светиться"
	key_third_person = "lights"
	message = "слабо подсвечивает себя, затем затухает."

/datum/emote/slime/vibrate
	key = "vibrate"
	ru_name = "вибрировать"
	key_third_person = "vibrates"
	message = "вибрирует!"

/datum/emote/slime/mood
	key = "moodnone"
	ru_name = "настроение: пустое"
	var/mood = null

/datum/emote/slime/mood/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/mob/living/simple_animal/slime/slime_user = user
	slime_user.mood = mood
	slime_user.regenerate_icons()

/datum/emote/slime/mood/sneaky
	key = "moodsneaky"
	ru_name = "настроение: подлое"
	mood = "mischievous"

/datum/emote/slime/mood/smile
	key = "moodsmile"
	ru_name = "настроение: мур"
	mood = ":3"

/datum/emote/slime/mood/cat
	key = "moodcat"
	ru_name = "настроение: мур-мур"
	mood = ":33"

/datum/emote/slime/mood/pout
	key = "moodpout"
	ru_name = "настроение: надутое"
	mood = "pout"

/datum/emote/slime/mood/sad
	key = "moodsad"
	ru_name = "настроение: расстроенное"
	mood = "sad"

/datum/emote/slime/mood/angry
	key = "moodangry"
	ru_name = "настроение: злое"
	mood = "angry"
