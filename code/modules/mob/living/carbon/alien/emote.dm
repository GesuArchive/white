/datum/emote/living/alien
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)

/datum/emote/living/alien/gnarl
	key = "gnarl"
	ru_name = "корчиться"
	key_third_person = "gnarls"
	message = "корчится и скалит зубы..."

/datum/emote/living/alien/hiss
	key = "hiss"
	ru_name = "шипеть"
	key_third_person = "hisses"
	message_alien = "шипит."
	message_larva = "мило шипит."

/datum/emote/living/alien/hiss/get_sound(mob/living/user)
	if(isalienadult(user))
		return "hiss"

/datum/emote/living/alien/roar
	key = "roar"
	ru_name = "рычать"
	key_third_person = "roars"
	message_alien = "рычит."
	message_larva = "мило рычит."
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/alien/roar/get_sound(mob/living/user)
	if(isalienadult(user))
		return 'sound/voice/hiss5.ogg'
