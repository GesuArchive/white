
/* EMOTE DATUMS */
/datum/emote/living
	mob_type_allowed_typecache = /mob/living
	mob_type_blacklist_typecache = list(/mob/living/simple_animal/slime, /mob/living/brain)

/// The time it takes for the blush visual to be removed
#define BLUSH_DURATION 5.2 SECONDS

/datum/emote/living/blush
	key = "blush"
	ru_name = "краснеть"
	key_third_person = "blushes"
	message = "краснеет."
	/// Timer for the blush visual to wear off
	var/blush_timer = TIMER_ID_NULL

/datum/emote/living/blush/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && isliving(user))
		var/mob/living/living_user = user
		ADD_TRAIT(living_user, TRAIT_BLUSHING, "[type]")
		living_user.update_body()

		// Use a timer to remove the blush effect after the BLUSH_DURATION has passed
		var/list/key_emotes = GLOB.emote_list["blush"]
		for(var/datum/emote/living/blush/living_emote in key_emotes)
			// The existing timer restarts if it's already running
			blush_timer = addtimer(CALLBACK(living_emote, PROC_REF(end_blush), living_user), BLUSH_DURATION, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/emote/living/blush/proc/end_blush(mob/living/living_user)
	if(!QDELETED(living_user))
		REMOVE_TRAIT(living_user, TRAIT_BLUSHING, "[type]")
		living_user.update_body()

#undef BLUSH_DURATION

/datum/emote/living/bow
	key = "bow"
	ru_name = "поклониться"
	key_third_person = "bows"
	message = "кланяется."
	message_param = "кланяется %t."
	hands_use_check = TRUE

/datum/emote/living/burp
	key = "burp"
	ru_name = "отрыгивать"
	key_third_person = "burps"
	message = "отрыгивает."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/burp/get_sound(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.mind || !H.mind.miming)
			if(user.gender == FEMALE)
				return 'white/valtos/sounds/emotes/burp_female.ogg'
			else
				return 'white/valtos/sounds/emotes/burp_male.ogg'

/datum/emote/living/choke
	key = "choke"
	ru_name = "задыхаться"
	key_third_person = "chokes"
	message = "задыхается!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/choke/get_sound(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.mind || !H.mind.miming)
			if(user.gender == FEMALE)
				return pick('white/valtos/sounds/emotes/choke_female_1.ogg',\
							'white/valtos/sounds/emotes/choke_female_2.ogg',\
							'white/valtos/sounds/emotes/choke_female_3.ogg',\
							'white/valtos/sounds/emotes/choke_female_4.ogg')
			else
				return pick('white/valtos/sounds/emotes/choke_male_1.ogg',\
							'white/valtos/sounds/emotes/choke_male_2.ogg',\
							'white/valtos/sounds/emotes/choke_male_3.ogg',\
							'white/valtos/sounds/emotes/choke_male_4.ogg')

/datum/emote/living/cross
	key = "cross"
	ru_name = "скрестить руки"
	key_third_person = "crosses"
	message = "скрещивает свои руки."
	hands_use_check = TRUE

/datum/emote/living/chuckle
	key = "chuckle"
	ru_name = "посмеиваться"
	key_third_person = "chuckles"
	message = "посмеивается."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/collapse
	key = "collapse"
	ru_name = "упасть"
	key_third_person = "collapses"
	message = "изнурённо падает!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/collapse/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Unconscious(40)

/datum/emote/living/cough
	key = "cough"
	ru_name = "кашлять"
	key_third_person = "coughs"
	message = "кашляет!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/cough/can_run_emote(mob/user, status_check = TRUE , intentional)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_SOOTHED_THROAT))
		return FALSE

/datum/emote/living/cough/get_sound(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.mind || !H.mind.miming)
			if(user.gender == FEMALE)
				return pick('white/valtos/sounds/emotes/cough_female_1.ogg',\
							'white/valtos/sounds/emotes/cough_female_2.ogg',\
							'white/valtos/sounds/emotes/cough_female_3.ogg',\
							'white/valtos/sounds/emotes/cough_female_4.ogg',\
							'white/valtos/sounds/emotes/cough_female_5.ogg')
			else
				return pick('white/valtos/sounds/emotes/cough_male_1.ogg',\
							'white/valtos/sounds/emotes/cough_male_2.ogg',\
							'white/valtos/sounds/emotes/cough_male_3.ogg',\
							'white/valtos/sounds/emotes/cough_male_4.ogg',\
							'white/valtos/sounds/emotes/cough_male_5.ogg')

/datum/emote/living/dance
	key = "dance"
	ru_name = "танцевать"
	key_third_person = "dances"
	message = "радостно пританцовывает."
	hands_use_check = TRUE

/datum/emote/living/deathgasp
	key = "deathgasp"
	ru_name = "иммитировать смерть"
	key_third_person = "deathgasps"
	message = "содрогается в последний раз, безжизненный взгляд застывает..."
	message_robot = "сильно дрожит на мгновение, прежде чем замереть неподвижно, глаза медленно темнеют."
	message_AI = "выбрасывает шквал искр, его экран мерцает, когда его системы медленно останавливаются."
	message_alien = "издаёт ослабевающий гортанный визг, зеленая кровь течёт из пасти...."
	message_larva = "издаёт болезненное шипение и падает вяло на пол...."
	message_monkey = "издаёт слабый звук, затем падает и перестаёт двигаться...."
	message_simple =  "перестаёт двигаться..."
	cooldown = (15 SECONDS)
	stat_allowed = HARD_CRIT

/datum/emote/living/deathgasp/run_emote(mob/user, params, type_override, intentional)
	var/mob/living/simple_animal/S = user
	if(istype(S) && S.death_message)
		message_simple = S.death_message
	. = ..()
	message_simple = initial(message_simple)
	if(. && user.deathsound)
		if(isliving(user))
			var/mob/living/L = user
			if(!L.can_speak_vocal() || L.oxyloss >= 50)
				return //stop the sound if oxyloss too high/cant speak
		playsound(user, user.deathsound, 200, TRUE, TRUE)

/datum/emote/living/drool
	key = "drool"
	ru_name = "пускать слюни"
	key_third_person = "drools"
	message = "пускает слюну."

/datum/emote/living/faint
	key = "faint"
	ru_name = "обморок"
	key_third_person = "faints"
	message = "падает в обморок."

/datum/emote/living/faint/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.SetSleeping(200)

/datum/emote/living/flap
	key = "flap"
	ru_name = "хлопать крыльями"
	key_third_person = "flaps"
	message = "хлопает крыльями."
	hands_use_check = TRUE
	var/wing_time = 20

/datum/emote/living/flap/can_run_emote(mob/user, status_check, intentional)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.dna.features["wings"] != "None")
			return TRUE
	. = ..()

/datum/emote/living/flap/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/open = FALSE
		if(H.dna.features["wings"] != "None")
			if(H.dna.species.mutant_bodyparts["wingsopen"])
				open = TRUE
				H.CloseWings()
			else
				H.OpenWings()
			addtimer(CALLBACK(H, open ? TYPE_PROC_REF(/mob/living/carbon/human, OpenWings) : TYPE_PROC_REF(/mob/living/carbon/human, CloseWings)), wing_time)

/datum/emote/living/flap/aflap
	key = "aflap"
	ru_name = "яростно хлопать крыльями"
	key_third_person = "aflaps"
	message = "яростно хлопает крыльями!"
	hands_use_check = TRUE
	wing_time = 10

/datum/emote/living/frown
	key = "frown"
	ru_name = "хмуриться"
	key_third_person = "frowns"
	message = "хмурится."

/datum/emote/living/gag
	key = "gag"
	ru_name = "давиться"
	key_third_person = "gags"
	message = "давится."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/gasp
	key = "gasp"
	ru_name = "задыхаться"
	key_third_person = "gasps"
	message = "задыхается!"
	emote_type = EMOTE_AUDIBLE
	stat_allowed = HARD_CRIT

/datum/emote/living/gasp/get_sound(mob/living/user)
	if(ismonkey(user))
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.mind || !H.mind.miming)
			if(user.gender == FEMALE)
				return pick('white/valtos/sounds/emotes/gasp_female_1.ogg',\
							'white/valtos/sounds/emotes/gasp_female_2.ogg',\
							'white/valtos/sounds/emotes/gasp_female_3.ogg',\
							'white/valtos/sounds/emotes/gasp_female_4.ogg',\
							'white/valtos/sounds/emotes/gasp_female_5.ogg',\
							'white/valtos/sounds/emotes/gasp_female_6.ogg')
			else
				return pick('white/valtos/sounds/emotes/gasp_male_1.ogg',\
							'white/valtos/sounds/emotes/gasp_male_2.ogg',\
							'white/valtos/sounds/emotes/gasp_male_3.ogg',\
							'white/valtos/sounds/emotes/gasp_male_4.ogg',\
							'white/valtos/sounds/emotes/gasp_male_5.ogg',\
							'white/valtos/sounds/emotes/gasp_male_6.ogg')

/datum/emote/living/giggle
	key = "giggle"
	ru_name = "хихикать"
	key_third_person = "giggles"
	message = "хихикает."
	message_mime = "тихо хихикает!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/giggle/get_sound(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.mind || !H.mind.miming)
			if(isfelinid(H))
				return pick('white/Feline/sounds/emotes/felinid_giggle_1.ogg',\
							'white/Feline/sounds/emotes/felinid_giggle_2.ogg',\
							'white/Feline/sounds/emotes/felinid_giggle_3.ogg',\
							'white/Feline/sounds/emotes/felinid_giggle_4.ogg',\
							'white/Feline/sounds/emotes/felinid_giggle_5.ogg')
			else
				if(user.gender == FEMALE)
					return pick('white/valtos/sounds/emotes/giggle_female_1.ogg',\
								'white/valtos/sounds/emotes/giggle_female_2.ogg')

/datum/emote/living/glare
	key = "glare"
	ru_name = "глазеть"
	key_third_person = "glares"
	message = "глазеет."
	message_param = "глазеет на %t."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/grin
	key = "grin"
	ru_name = "ухмыляться"
	key_third_person = "grins"
	message = "ухмыляется."

/datum/emote/living/grimace
	key = "grimace"
	ru_name = "морщиться"
	key_third_person = "grimaces"
	message = "морщится."

/datum/emote/living/jump
	key = "jump"
	ru_name = "подпрыгивать"
	key_third_person = "jumps"
	message = "подпрыгивает!"
	hands_use_check = TRUE

/datum/emote/living/jump/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	animate(user, pixel_y = user.pixel_y + 4, time = 0.1 SECONDS)
	animate(pixel_y = user.pixel_y - 4, time = 0.1 SECONDS)

/datum/emote/living/jump/get_sound(mob/living/user)
	return 'sound/weapons/thudswoosh.ogg'

/datum/emote/living/kiss
	key = "kiss"
	ru_name = "поцеловать"
	key_third_person = "kisses"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/kiss/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/kiss_type = /obj/item/kisser

	if(HAS_TRAIT(user, TRAIT_KISS_OF_DEATH))
		kiss_type = /obj/item/kisser/death

	var/obj/item/kiss_blower = new kiss_type(user)
	if(user.put_in_hands(kiss_blower))
		to_chat(user, span_notice("Готовлю свою руку для воздушного поцелуя."))
	else
		qdel(kiss_blower)
		to_chat(user, span_warning("Не могу пока целовать!"))

/datum/emote/living/laugh
	key = "laugh"
	ru_name = "смеяться"
	key_third_person = "laughs"
	message = "смеётся."
	message_mime = "тихо смеётся!"
	emote_type = EMOTE_AUDIBLE
	vary = FALSE

/datum/emote/living/laugh/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		return !C.silent

/datum/emote/living/laugh/get_sound(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.mind || !H.mind.miming)
			if(ismoth(H) || isflyperson(H))
				return 'white/tapko4eb/sounds/emotes/mothlaugh.ogg' // bed rustle
			if(isfelinid(H))
				return pick('white/Feline/sounds/emotes/felinid_laugh_1.ogg',\
							'white/Feline/sounds/emotes/felinid_laugh_2.ogg',\
							'white/Feline/sounds/emotes/felinid_laugh_3.ogg',\
							'white/Feline/sounds/emotes/felinid_laugh_4.ogg',\
							'white/Feline/sounds/emotes/felinid_laugh_5.ogg')
			else
				if(user.gender == FEMALE)
					return pick('white/valtos/sounds/emotes/laugh_female_1.ogg',\
								'white/valtos/sounds/emotes/laugh_female_2.ogg',\
								'white/valtos/sounds/emotes/laugh_female_3.ogg',\
								'white/valtos/sounds/emotes/laugh_female_4.ogg',\
								'white/valtos/sounds/emotes/laugh_female_5.ogg',\
								'white/valtos/sounds/emotes/laugh_female_6.ogg',\
								'white/valtos/sounds/emotes/laugh_female_7.ogg')
				if(H.skin_tone == "african1" || H.skin_tone == "african2")
					return pick('white/valtos/sounds/emotes/laugh_africanamericanmemberoflgbtq_1.ogg',\
								'white/valtos/sounds/emotes/laugh_africanamericanmemberoflgbtq_2.ogg')
				else
					return pick('white/valtos/sounds/emotes/laugh_male_1.ogg',\
								'white/valtos/sounds/emotes/laugh_male_2.ogg',\
								'white/valtos/sounds/emotes/laugh_male_3.ogg',\
								'white/valtos/sounds/emotes/laugh_male_4.ogg',\
								'white/valtos/sounds/emotes/laugh_male_5.ogg',\
								'white/valtos/sounds/emotes/laugh_male_6.ogg',\
								'white/valtos/sounds/emotes/laugh_male_7.ogg')

/datum/emote/living/look
	key = "look"
	ru_name = "смотреть"
	key_third_person = "looks"
	message = "смотрит."
	message_param = "смотрит на %t."

/datum/emote/living/nod
	key = "nod"
	ru_name = "кивать"
	key_third_person = "nods"
	message = "кивает."
	message_param = "кивает %t."

/datum/emote/living/point
	key = "point"
	ru_name = "показать на"
	key_third_person = "points"
	message = "показывает."
	message_param = "показывает на %t."
	hands_use_check = TRUE

/datum/emote/living/point/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.usable_hands == 0)
			if(H.usable_legs != 0)
				message_param = "пытается показать на %t своей ногой, <span class='userdanger'>но падает на пол</span> в процессе!"
				H.Paralyze(20)
			else
				message_param = "<span class='userdanger'>бьётся своей головой о землю</span> пытаясь показать на %t."
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
	return ..()

/datum/emote/living/pout
	key = "pout"
	ru_name = "дуть"
	key_third_person = "pouts"
	message = "дует."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/scream
	key = "scream"
	ru_name = "кричать"
	key_third_person = "screams"
	message = "кричит!"
	message_mime = "изображает крик!"
	emote_type = EMOTE_AUDIBLE
	mob_type_blacklist_typecache = list(/mob/living/carbon/human) //Humans get specialized scream.

/datum/emote/living/scream/select_message_type(mob/user, intentional)
	. = ..()
	if(!intentional && isanimal(user))
		return "издает громкий и страдальческий крик."

/datum/emote/living/scowl
	key = "scowl"
	ru_name = "хмуриться"
	key_third_person = "scowls"
	message = "хмурится."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/shake
	key = "shake"
	ru_name = "качать головой"
	key_third_person = "shakes"
	message = "качает головой."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/shiver
	key = "shiver"
	ru_name = "дрожать"
	key_third_person = "shiver"
	message = "дрожит."
	emote_type = EMOTE_AUDIBLE

#define SHIVER_LOOP_DURATION (1 SECONDS)
/datum/emote/living/shiver/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	animate(user, pixel_x = user.pixel_x + 1, time = 0.1 SECONDS)
	for(var/i in 1 to SHIVER_LOOP_DURATION / (0.2 SECONDS)) //desired total duration divided by the iteration duration to give the necessary iteration count
		animate(pixel_x = user.pixel_x - 1, time = 0.1 SECONDS)
		animate(pixel_x = user.pixel_x + 1, time = 0.1 SECONDS)
	animate(pixel_x = user.pixel_x - 1, time = 0.1 SECONDS)
#undef SHIVER_LOOP_DURATION

/datum/emote/living/sigh
	key = "sigh"
	ru_name = "вздыхать"
	key_third_person = "sighs"
	message = "вздыхает."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/sigh/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.mind?.miming)
		return
	if(user.gender == MALE)
		return pick('white/valtos/sounds/emotes/sigh_male_1.ogg',\
					'white/valtos/sounds/emotes/sigh_male_2.ogg',\
					'white/valtos/sounds/emotes/sigh_male_3.ogg',\
					'white/valtos/sounds/emotes/sigh_male_4.ogg')
	else
		return 'white/valtos/sounds/emotes/sigh_female.ogg'

/datum/emote/living/sit
	key = "sit"
	ru_name = "сесть"
	key_third_person = "sits"
	message = "садится."

/datum/emote/living/smile
	key = "smile"
	ru_name = "улыбаться"
	key_third_person = "smiles"
	message = "улыбается."

/datum/emote/living/sneeze
	key = "sneeze"
	ru_name = "чихать"
	key_third_person = "sneezes"
	message = "чихает."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/sneeze/get_sound(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.mind || !H.mind.miming)
			if(user.gender == FEMALE)
				return pick('white/valtos/sounds/emotes/sneeze_female_1.ogg',\
							'white/valtos/sounds/emotes/sneeze_female_2.ogg',\
							'white/valtos/sounds/emotes/sneeze_female_3.ogg')
			else
				return pick('white/valtos/sounds/emotes/sneeze_male_1.ogg',\
							'white/valtos/sounds/emotes/sneeze_male_2.ogg',\
							'white/valtos/sounds/emotes/sneeze_male_3.ogg')

/datum/emote/living/smug
	key = "smug"
	ru_name = "ухмыляться"
	key_third_person = "smugs"
	message = "ухмыляется самодовольно."

/datum/emote/living/sniff
	key = "sniff"
	ru_name = "сопеть"
	key_third_person = "sniffs"
	message = "сопит."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/snore
	key = "snore"
	ru_name = "храпеть"
	key_third_person = "snores"
	message = "храпит."
	message_mime = "громко храпит."
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS

/datum/emote/living/plot
	key = "plot"
	ru_name = "жажда"
	key_third_person = "корчится от жажды"
	message = "корчится от жажды!"
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS

/datum/emote/living/snore/get_sound(mob/living/user)
	if(ishuman(user))
		return pick('white/valtos/sounds/emotes/snore_1.ogg',\
					'white/valtos/sounds/emotes/snore_2.ogg',\
					'white/valtos/sounds/emotes/snore_3.ogg',\
					'white/valtos/sounds/emotes/snore_4.ogg',\
					'white/valtos/sounds/emotes/snore_5.ogg',\
					'white/valtos/sounds/emotes/snore_6.ogg',\
					'white/valtos/sounds/emotes/snore_7.ogg',\
					'white/valtos/sounds/emotes/snore_8.ogg',\
					'white/valtos/sounds/emotes/snore_9.ogg',\
					'white/valtos/sounds/emotes/snore_10.ogg',\
					'white/valtos/sounds/emotes/snore_11.ogg',\
					'white/valtos/sounds/emotes/snore_12.ogg',\
					'white/valtos/sounds/emotes/snore_13.ogg',\
					'white/valtos/sounds/emotes/snore_14.ogg',\
					'white/valtos/sounds/emotes/snore_15.ogg',\
					'white/valtos/sounds/emotes/snore_16.ogg',\
					'white/valtos/sounds/emotes/snore_17.ogg',\
					'white/valtos/sounds/emotes/snore_18.ogg',\
					'white/valtos/sounds/emotes/snore_19.ogg')

/datum/emote/living/stare
	key = "stare"
	ru_name = "пялиться"
	key_third_person = "stares"
	message = "пялится."
	message_param = "пялится на %t."

/datum/emote/living/strech
	key = "stretch"
	ru_name = "протянуть руки"
	key_third_person = "stretches"
	message = "протягивает руки."

/datum/emote/living/sulk
	key = "sulk"
	ru_name = "дуться"
	key_third_person = "sulks"
	message = "грустно дуется."

/datum/emote/living/surrender
	key = "surrender"
	ru_name = "сдаться"
	key_third_person = "surrenders"
	message = "кладёт свои руки за голову, падает на пол и сдаётся!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/surrender/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Paralyze(200)

/datum/emote/living/sway
	key = "sway"
	ru_name = "качаться"
	key_third_person = "sways"
	message = "головокружительно качается вокруг."

/datum/emote/living/sway/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	animate(user, pixel_x = user.pixel_x + 2, time = 0.5 SECONDS)
	for(var/i in 1 to 2)
		animate(pixel_x = user.pixel_x - 4, time = 1.0 SECONDS)
		animate(pixel_x = user.pixel_x + 4, time = 1.0 SECONDS)
	animate(pixel_x = user.pixel_x - 2, time = 0.5 SECONDS)

/datum/emote/living/tremble
	key = "tremble"
	ru_name = "бояться"
	key_third_person = "trembles"
	message = "дрожит от страха!"

#define TREMBLE_LOOP_DURATION (4.4 SECONDS)
/datum/emote/living/tremble/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	animate(user, pixel_x = user.pixel_x + 2, time = 0.2 SECONDS)
	for(var/i in 1 to TREMBLE_LOOP_DURATION / (0.4 SECONDS)) //desired total duration divided by the iteration duration to give the necessary iteration count
		animate(pixel_x = user.pixel_x - 2, time = 0.2 SECONDS)
		animate(pixel_x = user.pixel_x + 2, time = 0.2 SECONDS)
	animate(pixel_x = user.pixel_x - 2, time = 0.2 SECONDS)
#undef TREMBLE_LOOP_DURATION

/datum/emote/living/twitch
	key = "twitch"
	ru_name = "дёрнуться"
	key_third_person = "twitches"
	message = "резко дёргается."

/datum/emote/living/twitch/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	animate(user, pixel_x = user.pixel_x - 1, time = 0.1 SECONDS)
	animate(pixel_x = user.pixel_x + 1, time = 0.1 SECONDS)
	animate(time = 0.1 SECONDS)
	animate(pixel_x = user.pixel_x - 1, time = 0.1 SECONDS)
	animate(pixel_x = user.pixel_x + 1, time = 0.1 SECONDS)

/datum/emote/living/twitch_s
	key = "twitch_s"
	ru_name = "слабо дёрнуться"
	message = "дёргается."

/datum/emote/living/twitch_s/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	animate(user, pixel_x = user.pixel_x - 1, time = 0.1 SECONDS)
	animate(pixel_x = user.pixel_x + 1, time = 0.1 SECONDS)

/datum/emote/living/wave
	key = "wave"
	ru_name = "махать"
	key_third_person = "waves"
	message = "машет."

/datum/emote/living/whimper
	key = "whimper"
	ru_name = "хныкать"
	key_third_person = "whimpers"
	message = "хныкает."
	message_mime = "изображает обиду."

/datum/emote/living/wsmile
	key = "wsmile"
	ru_name = "слабо улыбаться"
	key_third_person = "wsmiles"
	message = "слабо улыбается."

/// The base chance for your yawn to propagate to someone else if they're on the same tile as you
#define YAWN_PROPAGATE_CHANCE_BASE 60
/// The base chance for your yawn to propagate to someone else if they're on the same tile as you
#define YAWN_PROPAGATE_CHANCE_DECAY 10

/datum/emote/living/yawn
	key = "yawn"
	ru_name = "зевать"
	key_third_person = "yawns"
	message = "зевает."
	emote_type = EMOTE_AUDIBLE
	cooldown = 3 SECONDS

/datum/emote/living/yawn/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!. || !isliving(user))
		return

	if(!TIMER_COOLDOWN_CHECK(user, COOLDOWN_YAWN_PROPAGATION))
		TIMER_COOLDOWN_START(user, COOLDOWN_YAWN_PROPAGATION, cooldown * 3)

	var/mob/living/carbon/carbon_user = user
	if(istype(carbon_user) && ((carbon_user.wear_mask?.flags_inv & HIDEFACE) || carbon_user.head?.flags_inv & HIDEFACE))
		return // if your face is obscured, skip propagation

	var/propagation_distance = user.client ? 5 : 2 // mindless mobs are less able to spread yawns

	for(var/mob/living/iter_living in view(user, propagation_distance))
		if(IS_DEAD_OR_INCAP(iter_living) || TIMER_COOLDOWN_CHECK(user, COOLDOWN_YAWN_PROPAGATION))
			continue

		var/dist_between = get_dist(user, iter_living)
		var/recently_examined = FALSE // if you yawn just after someone looks at you, it forces them to yawn as well. Tradecraft!

		if(iter_living.client)
			var/examine_time = LAZYACCESS(iter_living.client?.recent_examines, user)
			if(examine_time && (world.time - examine_time < YAWN_PROPAGATION_EXAMINE_WINDOW))
				recently_examined = TRUE

		if(!recently_examined && !prob(YAWN_PROPAGATE_CHANCE_BASE - (YAWN_PROPAGATE_CHANCE_DECAY * dist_between)))
			continue

		var/yawn_delay = rand(0.25 SECONDS, 0.75 SECONDS) * dist_between
		addtimer(CALLBACK(src, PROC_REF(propagate_yawn), iter_living), yawn_delay)

/// This yawn has been triggered by someone else yawning specifically, likely after a delay. Check again if they don't have the yawned recently trait
/datum/emote/living/yawn/proc/propagate_yawn(mob/user)
	if(!istype(user) || TIMER_COOLDOWN_CHECK(user, COOLDOWN_YAWN_PROPAGATION))
		return
	user.emote("yawn")

#undef YAWN_PROPAGATE_CHANCE_BASE
#undef YAWN_PROPAGATE_CHANCE_DECAY

/datum/emote/living/gurgle
	key = "gurgle"
	ru_name = "булькать"
	key_third_person = "gurgles"
	message = "издает неприятное бульканье."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/custom
	key = "me"
	key_third_person = "custom"
	message = null

/datum/emote/living/custom/can_run_emote(mob/user, status_check, intentional)
	. = ..() && intentional

/datum/emote/living/custom/proc/check_invalid(mob/user, input)
	var/static/regex/stop_bad_mime = regex(@"говорит|восклицает|кричит|спрашивает")
	if(stop_bad_mime.Find(input, 1, 1))
		to_chat(user, span_danger("Не знаю что делать!"))
		return TRUE
	return FALSE

/datum/emote/living/custom/run_emote(mob/user, params, type_override = null, intentional = FALSE)
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	if(is_banned_from(user.ckey, "Emote"))
		to_chat(user, span_boldwarning("You cannot send custom emotes (banned)."))
		return FALSE
	else if(QDELETED(user))
		return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, span_boldwarning("You cannot send IC messages (muted)."))
		return FALSE
	else if(!params)
		var/custom_emote = copytext(sanitize(input("Choose an emote to display.") as text|null), 1, MAX_MESSAGE_LEN)
		if(custom_emote && !check_invalid(user, custom_emote))
			var/type = tgui_input_list(usr, "Is this a visible or hearable emote?", , list("Visible", "Hearable"))
			switch(type)
				if("Visible")
					emote_type = EMOTE_VISIBLE
				if("Hearable")
					emote_type = EMOTE_AUDIBLE
				else
					tgui_alert(usr,"Unable to use this emote, must be either hearable or visible.")
					return
			message = custom_emote
	else
		message = params
		if(type_override)
			emote_type = type_override
	. = ..()
	message = null
	emote_type = EMOTE_VISIBLE

/datum/emote/living/custom/replace_pronoun(mob/user, message)
	return message

/datum/emote/living/help
	key = "help"

/datum/emote/living/help/run_emote(mob/user, params, type_override, intentional)
	var/list/keys = list()
	var/list/message = list("Доступный список эмоций. Их можно использовать в поле say \"*emote\": ")

	for(var/key in GLOB.emote_list)
		for(var/datum/emote/P in GLOB.emote_list[key])
			if(P.key in keys)
				continue
			if(P.can_run_emote(user, status_check = FALSE , intentional = TRUE))
				keys += P.key

	keys = sort_list(keys)

	for(var/emote in keys)
		if(LAZYLEN(message) > 1)
			message += ", [emote]"
		else
			message += "[emote]"

	message += "."

	message = jointext(message, "")

	to_chat(user, message)

/datum/emote/beep
	key = "beep"
	ru_name = "бипать"
	key_third_person = "бипает"
	message = "пищит."
	message_param = "пищит на %t."
	sound = 'sound/machines/twobeep.ogg'
	mob_type_allowed_typecache = list(/mob/living/brain, /mob/living/silicon)

/datum/emote/inhale
	key = "inhale"
	ru_name = "вдохнуть"
	key_third_person = "inhales"
	message = "делает вдох."

/datum/emote/exhale
	key = "exhale"
	ru_name = "выдохнуть"
	key_third_person = "exhales"
	message = "делает выдох."
