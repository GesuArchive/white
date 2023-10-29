/datum/emote/silicon
	mob_type_allowed_typecache = list(/mob/living/silicon)
	emote_type = EMOTE_AUDIBLE

/datum/emote/silicon/boop
	key = "boop"
	ru_name = "бупать"
	key_third_person = "boops"
	message = "бупает."

/datum/emote/silicon/buzz
	key = "buzz"
	ru_name = "гудеть"
	key_third_person = "buzzes"
	message = "гудит."
	message_param = "гудит на %t."
	sound = 'white/valtos/sounds/error1.ogg'

/datum/emote/silicon/buzz2
	key = "buzz2"
	ru_name = "гудеть дважды"
	message = "гудит дважды."
	sound = 'white/valtos/sounds/error2.ogg'

/datum/emote/silicon/chime
	key = "chime"
	ru_name = "звонить"
	key_third_person = "chimes"
	message = "звонит."
	sound = 'sound/machines/chime.ogg'

/datum/emote/silicon/honk
	key = "honk"
	ru_name = "хонкать"
	key_third_person = "honks"
	message = "хонкает."
	vary = TRUE
	sound = 'sound/items/bikehorn.ogg'

/datum/emote/silicon/ping
	key = "ping"
	ru_name = "пинговать"
	key_third_person = "pings"
	message = "пингует."
	message_param = "пингует %t."
	sound = 'sound/machines/ping.ogg'

/datum/emote/silicon/sad
	key = "sad"
	ru_name = "потеря потерь"
	message = "проигрывает грустную мелодию..."
	sound = 'sound/misc/sadtrombone.ogg'

/datum/emote/silicon/warn
	key = "warn"
	ru_name = "тревога"
	message = "издаёт сигнал тревоги!"
	sound = 'sound/machines/warning-buzzer.ogg'
