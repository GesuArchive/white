/datum/emote/living/carbon
	mob_type_allowed_typecache = list(/mob/living/carbon)

/datum/emote/living/carbon/airguitar
	key = "airguitar"
	ru_name = "гитарить"
	message = "играет на воздухе и трясет головой, как шимпанзе-сафари."
	hands_use_check = TRUE

/datum/emote/living/carbon/blink
	key = "blink"
	ru_name = "моргнуть"
	key_third_person = "blinks"
	message = "моргает."

/datum/emote/living/carbon/blink_r
	key = "blink_r"
	ru_name = "быстро моргнуть"
	message = "быстро моргает."

/datum/emote/living/carbon/clap
	key = "clap"
	ru_name = "хлопать"
	key_third_person = "claps"
	message = "хлопает."
	muzzle_ignore = TRUE
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/carbon/clap/get_sound(mob/living/user)
	if(ishuman(user))
		if(!user.get_bodypart(BODY_ZONE_L_ARM) || !user.get_bodypart(BODY_ZONE_R_ARM))
			return
		else
			return pick('sound/misc/clap1.ogg',
							'sound/misc/clap2.ogg',
							'sound/misc/clap3.ogg',
							'sound/misc/clap4.ogg')

/datum/emote/living/carbon/crack
	key = "crack"
	ru_name = "крэкать"
	key_third_person = "cracks"
	message = "хрустит своими пальцами."
	sound = 'sound/misc/knuckles.ogg'
	cooldown = 6 SECONDS

/datum/emote/living/carbon/crack/can_run_emote(mob/living/carbon/user, status_check = TRUE , intentional)
	if(isliving(user))
		if(user.usable_hands < 2)
			return FALSE
	return ..()

/datum/emote/living/carbon/moan
	key = "moan"
	ru_name = "стонать"
	key_third_person = "moans"
	message = "стонет!"
	message_mime = "изображает стон!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/moan/get_sound(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.mind || !H.mind.miming)
			if(user.gender == FEMALE)
				return pick('white/valtos/sounds/exrp/interactions/moan_f1.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_f2.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_f3.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_f4.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_f5.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_f6.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_f7.ogg')
			else
				return pick('white/valtos/sounds/exrp/interactions/moan_m0.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_m1.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_m2.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_m3.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_m4.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_m5.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_m6.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_m7.ogg',\
							'white/valtos/sounds/exrp/interactions/moan_m12.ogg')

/datum/emote/living/carbon/roll
	key = "roll"
	ru_name = "перекатываться"
	key_third_person = "rolls"
	message = "перекатывается."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)
	hands_use_check = TRUE

/datum/emote/living/carbon/scratch
	key = "scratch"
	ru_name = "чесаться"
	key_third_person = "scratches"
	message = "чешется."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)
	hands_use_check = TRUE

/datum/emote/living/carbon/sign
	key = "sign"
	ru_name = "петь"
	key_third_person = "signs"
	message_param = "поёт ноту %t."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)
	hands_use_check = TRUE

/datum/emote/living/carbon/sign/select_param(mob/user, params)
	. = ..()
	if(!isnum(text2num(params)))
		return message

/datum/emote/living/carbon/sign/signal
	key = "signal"
	ru_name = "сигнал"
	key_third_person = "signals"
	message_param = "поднимает %t палец."
	mob_type_allowed_typecache = list(/mob/living/carbon/human)
	hands_use_check = TRUE

/datum/emote/living/carbon/tail
	key = "tail"
	ru_name = "махать"
	message = "машет хвостом."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)

/datum/emote/living/carbon/wink
	key = "wink"
	ru_name = "подмигнуть"
	key_third_person = "winks"
	message = "подмигивает."

/datum/emote/living/carbon/circle
	key = "circle"
	ru_name = "рука-круг"
	key_third_person = "circles"
	hands_use_check = TRUE

/datum/emote/living/carbon/circle/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!length(user.get_empty_held_indexes()))
		to_chat(user, span_warning("Да у меня и рук свободных нет."))
		return
	var/obj/item/circlegame/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, span_notice("Изображаю круг рукой."))

/datum/emote/living/carbon/slap
	key = "slap"
	ru_name = "шлёпать"
	key_third_person = "slaps"
	hands_use_check = TRUE

/datum/emote/living/carbon/slap/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/obj/item/slapper/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, span_notice("Готовлюсь шлёпать."))
	else
		qdel(N)
		to_chat(user, span_warning("Пока не могу шлёпать."))

