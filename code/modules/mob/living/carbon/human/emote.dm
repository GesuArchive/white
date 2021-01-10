/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	message = "плачет."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/dap
	key = "dap"
	key_third_person = "daps"
	message = "озадаченно не может найти кому пожать руку и жмёт свою. Позорище."
	message_param = "приветственно жмёт руку братку %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	message = "поднимает бровь."

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "grumbles"
	message = "ворчит!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message = "пожимает свои руки."
	message_param = "пожимает руку %t."
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/hug
	key = "hug"
	key_third_person = "hugs"
	message = "обнимает себя."
	message_param = "обнимает %t."
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	message = "бормочет!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/scream
	key = "scream"
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
			return pick('white/valtos/sounds/emotes/scream_male_1.ogg', 'white/valtos/sounds/emotes/scream_male_2.ogg', 'sound/voice/human/malescream_1.ogg', 'sound/voice/human/malescream_2.ogg', 'sound/voice/human/malescream_3.ogg', 'sound/voice/human/malescream_4.ogg', 'sound/voice/human/malescream_5.ogg', 'sound/voice/human/malescream_6.ogg')
	else if(ismoth(H))
		return 'sound/voice/moth/scream_moth.ogg'
	else if(ismonkey(user)) //If its a monkey, override it.
		return pick('sound/creatures/monkey/monkey_screech_1.ogg',
					'sound/creatures/monkey/monkey_screech_2.ogg',
					'sound/creatures/monkey/monkey_screech_3.ogg',
					'sound/creatures/monkey/monkey_screech_4.ogg',
					'sound/creatures/monkey/monkey_screech_5.ogg',
					'sound/creatures/monkey/monkey_screech_6.ogg',
					'sound/creatures/monkey/monkey_screech_7.ogg')

/datum/emote/living/carbon/human/scream/screech //If a human tries to screech it'll just scream.
	key = "screech"
	key_third_person = "screeches"
	message = "визжит."
	emote_type = EMOTE_AUDIBLE
	vary = FALSE

/datum/emote/living/carbon/human/pale
	key = "pale"
	message = "бледнеет на секунду."

/datum/emote/living/carbon/human/raise
	key = "raise"
	key_third_person = "raises"
	message = "поднимает руки."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "salutes"
	message = "отдаёт честь."
	message_param = "отдаёт честь %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "shrugs"
	message = "пожимает плечами."

/datum/emote/living/carbon/human/wag
	key = "wag"
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

//Ayy lmao

/datum/emote/living/carbon/human/dab
	key = "dab"
	key_third_person = "dabs"
	message = "бьёт себя рукой по лбу!"

/datum/emote/living/carbon/human/dab/run_emote(mob/living/carbon/user, params)
	. = ..()
	if(. && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/light_dab_angle = rand(35,55)
		var/light_dab_speed = rand(3,7)
		H.DabAnimation(angle = light_dab_angle , speed = light_dab_speed)
		H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)

///Snowflake emotes only for le epic chimp
/datum/emote/living/carbon/human/monkey

/datum/emote/living/carbon/human/monkey/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(ismonkey(user))
		return ..()
	return FALSE

/datum/emote/living/carbon/human/monkey/gnarl
	key = "gnarl"
	key_third_person = "gnarls"
	message = "рычит и обнажает свои зубы..."

/datum/emote/living/carbon/human/monkey/roll
	key = "roll"
	key_third_person = "rolls"
	message = "перекатывается."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/monkey/scratch
	key = "scratch"
	key_third_person = "scratches"
	message = "чешется."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/monkey/screech/roar
	key = "roar"
	key_third_person = "roars"
	message = "ревёт."

/datum/emote/living/carbon/human/monkey/tail
	key = "tail"
	message = "машет хвостом."

/datum/emote/living/carbon/human/monkeysign
	key = "sign"
	key_third_person = "signs"
	message_param = "поёт ноту %t."
	hands_use_check = TRUE
