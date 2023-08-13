/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	ru_name = "плакать"
	key_third_person = "cries"
	message = "плачет."
	emote_type = EMOTE_AUDIBLE


/datum/emote/living/carbon/human/dap
	key = "dap"
	ru_name = "пожать руку"
	key_third_person = "daps"
	message = "озадаченно не может найти кому пожать руку и жмёт свою. Позорище."
	message_param = "приветственно жмёт руку братку %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	ru_name = "поднять бровь"
	message = "поднимает бровь."

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	ru_name = "ворчать"
	key_third_person = "grumbles"
	message = "ворчит!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	ru_name = "пожать руку"
	message = "пожимает свои руки."
	message_param = "пожимает руку %t."
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/hug
	key = "hug"
	ru_name = "обнять"
	key_third_person = "hugs"
	message = "обнимает себя."
	message_param = "обнимает %t."
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	ru_name = "бормотать"
	key_third_person = "mumbles"
	message = "бормочет!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/scream
	key = "scream"
	ru_name = "кричать"
	key_third_person = "screams"
	message = "кричит!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = FALSE
	vary = TRUE

/datum/emote/living/carbon/human/scream/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.mind?.miming)
		return
	if(ishumanbasic(H) || isfelinid(H))
		if(user.gender == FEMALE)
			return pick('white/valtos/sounds/emotes/scream_female_1.ogg',\
						'white/valtos/sounds/emotes/scream_female_2.ogg',\
						'white/valtos/sounds/emotes/scream_female_3.ogg',\
						'white/valtos/sounds/emotes/scream_female_4.ogg')
		else
			return pick('white/valtos/sounds/emotes/scream_male_1.ogg',\
						'white/valtos/sounds/emotes/scream_male_2.ogg',\
						'sound/voice/human/malescream_1.ogg',\
						'sound/voice/human/malescream_2.ogg',\
						'sound/voice/human/malescream_3.ogg',\
						'sound/voice/human/malescream_4.ogg',\
						'sound/voice/human/malescream_5.ogg',\
						'sound/voice/human/malescream_6.ogg')
	else if(ismoth(H))
		return 'sound/voice/moth/scream_moth.ogg'
	else if(ismonkey(user)) //If its a monkey, override it.
		return pick('sound/creatures/monkey/monkey_screech_1.ogg',\
					'sound/creatures/monkey/monkey_screech_2.ogg',\
					'sound/creatures/monkey/monkey_screech_3.ogg',\
					'sound/creatures/monkey/monkey_screech_4.ogg',\
					'sound/creatures/monkey/monkey_screech_5.ogg',\
					'sound/creatures/monkey/monkey_screech_6.ogg',\
					'sound/creatures/monkey/monkey_screech_7.ogg')

/datum/emote/living/carbon/human/scream/screech //If a human tries to screech it'll just scream.
	key = "screech"
	ru_name = "визжать"
	key_third_person = "screeches"
	message = "визжит."
	emote_type = EMOTE_AUDIBLE
	vary = FALSE

/datum/emote/living/carbon/human/agony
	key = "agony"
	ru_name = "агония"
	key_third_person = "agonizes"
	message = "кричит в агонии!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	vary = TRUE

/datum/emote/living/carbon/human/agony/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.mind?.miming)
		return
	if(ismonkey(user))
		return pick('sound/creatures/monkey/monkey_screech_1.ogg',\
					'sound/creatures/monkey/monkey_screech_2.ogg',\
					'sound/creatures/monkey/monkey_screech_3.ogg',\
					'sound/creatures/monkey/monkey_screech_4.ogg',\
					'sound/creatures/monkey/monkey_screech_5.ogg',\
					'sound/creatures/monkey/monkey_screech_6.ogg',\
					'sound/creatures/monkey/monkey_screech_7.ogg')
	if(ishumanbasic(H) || isfelinid(H))
		if(user.gender == FEMALE)
			return pick('white/valtos/sounds/emotes/agony_female_1.ogg',\
						'white/valtos/sounds/emotes/agony_female_2.ogg',\
						'white/valtos/sounds/emotes/agony_female_3.ogg')
		else
			return pick('white/valtos/sounds/emotes/agony_male_1.ogg',\
						'white/valtos/sounds/emotes/agony_male_2.ogg',\
						'white/valtos/sounds/emotes/agony_male_3.ogg',\
						'white/valtos/sounds/emotes/agony_male_4.ogg',\
						'white/valtos/sounds/emotes/agony_male_5.ogg',\
						'white/valtos/sounds/emotes/agony_male_6.ogg',\
						'white/valtos/sounds/emotes/agony_male_7.ogg',\
						'white/valtos/sounds/emotes/agony_male_8.ogg',\
						'white/valtos/sounds/emotes/agony_male_9.ogg')
	else if(ismoth(H))
		return 'sound/voice/moth/scream_moth.ogg'


/datum/emote/living/carbon/human/pale
	key = "pale"
	ru_name = "побледнеть"
	message = "бледнеет на секунду."

/datum/emote/living/carbon/human/raise
	key = "raise"
	ru_name = "поднять руки"
	key_third_person = "raises"
	message = "поднимает руки."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/salute
	key = "salute"
	ru_name = "отдать честь"
	key_third_person = "salutes"
	message = "отдаёт честь."
	message_param = "отдаёт честь %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	ru_name = "пожать плечами"
	key_third_person = "shrugs"
	message = "пожимает плечами."

/datum/emote/living/carbon/human/wag
	key = "wag"
	ru_name = "вилять"
	key_third_person = "wags"
	message = "виляет хвостом."

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.dna || !H.dna.species || !H.dna.species.can_wag_tail(H))
		return
	if(!H.dna.species.is_wagging_tail())
		H.dna.species.start_wagging_tail(H)
	else
		H.dna.species.stop_wagging_tail(H)

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	return H.dna && H.dna.species && H.dna.species.can_wag_tail(user)

/datum/emote/living/carbon/human/wag/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!H.dna || !H.dna.species)
		return
	if(H.dna.species.is_wagging_tail())
		. = null

/datum/emote/living/carbon/human/wing
	key = "wing"
	ru_name = "крылья"
	key_third_person = "wings"
	message = "свои крылья."

/datum/emote/living/carbon/human/wing/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		var/mob/living/carbon/human/H = user
		if(findtext(select_message_type(user,intentional), "open"))
			H.OpenWings()
		else
			H.CloseWings()

/datum/emote/living/carbon/human/wing/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(H.dna.species.mutant_bodyparts["wings"])
		. = "раскрывает " + message
	else
		. = "убирает " + message

/datum/emote/living/carbon/human/wing/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.dna && H.dna.species && (H.dna.features["wings"] != "None"))
		return TRUE

/mob/living/carbon/human/proc/OpenWings()
	if(!dna || !dna.species)
		return
	if(dna.species.mutant_bodyparts["wings"])
		dna.species.mutant_bodyparts["wingsopen"] = dna.species.mutant_bodyparts["wings"]
		dna.species.mutant_bodyparts -= "wings"
	update_body()

/mob/living/carbon/human/proc/CloseWings()
	if(!dna || !dna.species)
		return
	if(dna.species.mutant_bodyparts["wingsopen"])
		dna.species.mutant_bodyparts["wings"] = dna.species.mutant_bodyparts["wingsopen"]
		dna.species.mutant_bodyparts -= "wingsopen"
	update_body()
	if(isturf(loc))
		var/turf/T = loc
		T.Entered(src)

///Snowflake emotes only for le epic chimp
/datum/emote/living/carbon/human/monkey

/datum/emote/living/carbon/human/monkey/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(ismonkey(user))
		return ..()
	return FALSE

/datum/emote/living/carbon/human/monkey/gnarl
	key = "gnarl"
	ru_name = "рычать"
	key_third_person = "gnarls"
	message = "рычит и обнажает свои зубы..."

/datum/emote/living/carbon/human/monkey/roll
	key = "roll"
	ru_name = "перекатываться"
	key_third_person = "rolls"
	message = "перекатывается."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/monkey/scratch
	key = "scratch"
	ru_name = "чесаться"
	key_third_person = "scratches"
	message = "чешется."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/monkey/screech/roar
	key = "roar"
	ru_name = "реветь"
	key_third_person = "roars"
	message = "ревёт."

/datum/emote/living/carbon/human/monkey/tail
	key = "tail"
	ru_name = "махать хвостом"
	message = "машет хвостом."

/datum/emote/living/carbon/human/monkeysign
	key = "sign"
	ru_name = "петь"
	key_third_person = "signs"
	message_param = "поёт ноту %t."
	hands_use_check = TRUE
