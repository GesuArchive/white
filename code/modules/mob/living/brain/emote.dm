/datum/emote/brain
	mob_type_allowed_typecache = list(/mob/living/brain)
	mob_type_blacklist_typecache = list()

/datum/emote/brain/can_run_emote(mob/user, status_check = TRUE, intentional)
	. = ..()
	var/mob/living/brain/B = user
	if(!istype(B) || (!(B.container && istype(B.container, /obj/item/mmi))))
		return FALSE

/datum/emote/brain/alarm
	key = "alarm"
	message = "издаёт сигнал тревоги."
	emote_type = EMOTE_AUDIBLE

/datum/emote/brain/alert
	key = "alert"
	message = "выпискивает сигнал опасности."
	emote_type = EMOTE_AUDIBLE

/datum/emote/brain/flash
	key = "flash"
	message = "моргает своими фонариками."

/datum/emote/brain/notice
	key = "notice"
	message = "проигрывает громкий звук."
	emote_type = EMOTE_AUDIBLE

/datum/emote/brain/whistle
	key = "whistle"
	key_third_person = "whistles"
	message = "свистит."
	emote_type = EMOTE_AUDIBLE
