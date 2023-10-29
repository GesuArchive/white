//copy pasta of the space piano, don't hurt me -Pete
/obj/item/instrument
	name = "generic instrument"
	force = 10
	max_integrity = 100
	resistance_flags = FLAMMABLE
	icon = 'icons/obj/musician.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/instruments_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/instruments_righthand.dmi'
	/// Our song datum.
	var/datum/song/handheld/song
	/// Our allowed list of instrument ids. This is nulled on initialize.
	var/list/allowed_instrument_ids
	/// How far away our song datum can be heard.
	var/instrument_range = 15

/obj/item/instrument/Initialize(mapload)
	. = ..()
	song = new(src, allowed_instrument_ids, instrument_range)
	allowed_instrument_ids = null			//We don't need this clogging memory after it's used.

/obj/item/instrument/Destroy()
	QDEL_NULL(song)
	return ..()

/obj/item/instrument/proc/should_stop_playing(atom/music_player)
	if(!ismob(music_player))
		return STOP_PLAYING
	var/mob/user = music_player
	if(user.incapacitated() || !((loc == user) || (isturf(loc) && Adjacent(user)))) // sorry, no more TK playing.
		return STOP_PLAYING

/obj/item/instrument/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] begins to play 'Gloomy Sunday'! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (BRUTELOSS)

/obj/item/instrument/attack_self(mob/user)
	if(!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("У меня не хватает ловкости для этого!"))
		return TRUE
	interact(user)

/obj/item/instrument/interact(mob/user)
	ui_interact(user)

/obj/item/instrument/ui_interact(mob/living/user)
	if(!isliving(user) || user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return

	user.set_machine(src)
	song.ui_interact(user)

/obj/item/instrument/violin
	name = "космическая скрипка"
	desc = "Деревянный музыкальный инструмент с четырьмя струнами и смычком. \"Дьявол объявился на станции, он искал ассистента для стеба\"."
	icon_state = "violin"
	inhand_icon_state = "violin"
	hitsound = "swing_hit"
	allowed_instrument_ids = "violin"

/obj/item/instrument/violin/golden
	name = "золотая скрипка"
	desc = "Золотой музыкальный инструмент с четырьмя струнами и смычком. \"Дьявол объявился на станции, он искал ассистента для стеба\"."
	icon_state = "golden_violin"
	inhand_icon_state = "golden_violin"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/instrument/banjo
	name = "банджо"
	desc = "Банджо марки 'Мура'. Это просто барабан с грифом и струнами."
	icon_state = "banjo"
	inhand_icon_state = "banjo"
	attack_verb_continuous = list("scruggs-styles", "hum-diggitys", "shin-digs", "clawhammers")
	attack_verb_simple = list("scruggs-style", "hum-diggity", "shin-dig", "clawhammer")
	hitsound = 'sound/weapons/banjoslap.ogg'
	allowed_instrument_ids = "banjo"

/obj/item/instrument/guitar
	name = "гитара"
	desc = "Она сделана из дерева и у неё бронзовые струны."
	icon_state = "guitar"
	inhand_icon_state = "guitar"
	attack_verb_continuous = list("играет металл", "серенадирует", "инструментирует", "применяет по делу")
	attack_verb_simple = list("играет металл", "серенадирует", "инструментирует", "применяет по делу")
	hitsound = 'sound/weapons/stringsmash.ogg'
	allowed_instrument_ids = list("guitar","csteelgt","cnylongt", "ccleangt", "cmutedgt")

/obj/item/instrument/eguitar
	name = "электрогитара"
	desc = "Выражает всю вашу деструктивную натуру."
	icon_state = "eguitar"
	inhand_icon_state = "eguitar"
	force = 12
	attack_verb_continuous = list("играет металл", "серенадирует", "инструментирует", "применяет по делу")
	attack_verb_simple = list("играет металл", "серенадирует", "инструментирует", "применяет по делу")
	hitsound = 'sound/weapons/stringsmash.ogg'
	allowed_instrument_ids = "eguitar"

/obj/item/instrument/glockenspiel
	name = "ксилофон"
	desc = "Гладкие металлические прутья идеально подходят для любого марширующего оркестра."
	icon_state = "glockenspiel"
	allowed_instrument_ids = list("glockenspiel","crvibr", "sgmmbox", "r3celeste")
	inhand_icon_state = "glockenspiel"

/obj/item/instrument/accordion
	name = "аккордион"
	desc = "Пун-Пун в комплект не входит."
	icon_state = "accordion"
	allowed_instrument_ids = list("crack", "crtango", "accordion")
	inhand_icon_state = "accordion"

/obj/item/instrument/trumpet
	name = "труба"
	desc = "Для объявления о прибытии короля!"
	icon_state = "trumpet"
	allowed_instrument_ids = "crtrumpet"
	inhand_icon_state = "trumpet"

/obj/item/instrument/trumpet/spectral
	name = "спектральная труба"
	desc = "Всё становится ужасным!"
	icon_state = "spectral_trumpet"
	inhand_icon_state = "spectral_trumpet"
	force = 0
	attack_verb_continuous = list("играет","джаззует","трампетирует","горнирует","дудит","спукает")
	attack_verb_simple = list("играет","джаззует","трампетирует","горнирует","дудит","спукает")

/obj/item/instrument/trumpet/spectral/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/spooky)

/obj/item/instrument/trumpet/spectral/attack(mob/living/carbon/C, mob/user)
	playsound (src, 'sound/runtime/instruments/trombone/En4.mid', 100,1,-1)
	..()

/obj/item/instrument/saxophone
	name = "саксофон"
	desc = "Этот успокаивающий звук обязательно повергнет вашу аудиторию в слезы."
	icon_state = "saxophone"
	allowed_instrument_ids = "saxophone"
	inhand_icon_state = "saxophone"

/obj/item/instrument/saxophone/spectral
	name = "спектральный саксофон"
	desc = "Этот жуткий звук наверняка вызовет у смертных мурашки по коже."
	icon_state = "saxophone"
	inhand_icon_state = "saxophone"
	force = 0
	attack_verb_continuous = list("играет","саксирует","горнирует","дудит","спукает")
	attack_verb_simple = list("играет","саксирует","горнирует","дудит","спукает")

/obj/item/instrument/saxophone/spectral/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/spooky)

/obj/item/instrument/saxophone/spectral/attack(mob/living/carbon/C, mob/user)
	playsound (src, 'sound/runtime/instruments/saxophone/En4.mid', 100,1,-1)
	..()

/obj/item/instrument/trombone
	name = "тромбон"
	desc = "Как может любой бильярдный стол когда-либо надеяться конкурировать?"
	icon_state = "trombone"
	allowed_instrument_ids = list("crtrombone", "crbrass", "trombone")
	inhand_icon_state = "trombone"

/obj/item/instrument/trombone/spectral
	name = "спектральный тромбон"
	desc = "Любимый инструмент скелета. Применяйте непосредственно к смертным."
	icon_state = "trombone"
	inhand_icon_state = "trombone"
	force = 0
	attack_verb_continuous = list("играет","тромбирует","дудит","спукает")
	attack_verb_simple = list("играет","тромбирует","дудит","спукает")

/obj/item/instrument/trombone/spectral/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/spooky)

/obj/item/instrument/trombone/spectral/attack(mob/living/carbon/C, mob/user)
	playsound (src, 'sound/runtime/instruments/trombone/Cn4.mid', 100,1,-1)
	..()

/obj/item/instrument/recorder
	name = "блокфлейта"
	desc = "Прямо как в школе, умение играть и все такое."
	force = 5
	icon_state = "recorder"
	allowed_instrument_ids = "recorder"
	inhand_icon_state = "recorder"

/obj/item/instrument/harmonica
	name = "губная гармошка"
	desc = "На тот случай, если вам дьявольски захочется исполнить космо блюз!"
	icon_state = "harmonica"
	allowed_instrument_ids = list("crharmony", "harmonica")
	inhand_icon_state = "harmonica"
	slot_flags = ITEM_SLOT_MASK
	force = 5
	w_class = WEIGHT_CLASS_SMALL
	actions_types = list(/datum/action/item_action/instrument)

/obj/item/instrument/harmonica/proc/handle_speech(datum/source, list/speech_args)
	if(song.playing && ismob(loc))
		to_chat(loc, span_warning("You stop playing the harmonica to talk..."))
		song.playing = FALSE

/obj/item/instrument/harmonica/equipped(mob/M, slot)
	. = ..()
	RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/obj/item/instrument/harmonica/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)

/datum/action/item_action/instrument
	name = "Использовать инструмент"
	desc = "Использовать выбранный инструмент"

/datum/action/item_action/instrument/Trigger(trigger_flags)
	if(istype(target, /obj/item/instrument))
		var/obj/item/instrument/I = target
		I.interact(usr)
		return
	return ..()

/obj/item/instrument/bikehorn
	name = "позолоченный велосипедный гудок"
	desc = "Изысканно оформленный велосипедный гудок, способный издавать различные звуки."
	icon_state = "bike_horn"
	inhand_icon_state = "bike_horn"
	lefthand_file = 'icons/mob/inhands/equipment/horns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/horns_righthand.dmi'
	allowed_instrument_ids = list("bikehorn", "honk")
	attack_verb_continuous = list("невероятно красиво ХОНКАЕТ")
	attack_verb_simple = list("невероятно красиво ХОНКАЕТ")
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throw_speed = 3
	throw_range = 15
	hitsound = 'sound/items/bikehorn.ogg'

/obj/item/choice_beacon/music
	name = "маяк доставки музыкального инструмента"
	desc = "Призовите свой инструмент искусства."
	icon_state = "gangtool-red"

/obj/item/choice_beacon/music/generate_display_names()
	var/static/list/instruments
	if(!instruments)
		instruments = list()
		var/list/templist = list(/obj/item/instrument/violin,
							/obj/item/instrument/piano_synth,
							/obj/item/instrument/banjo,
							/obj/item/instrument/guitar,
							/obj/item/instrument/eguitar,
							/obj/item/instrument/glockenspiel,
							/obj/item/instrument/accordion,
							/obj/item/instrument/trumpet,
							/obj/item/instrument/saxophone,
							/obj/item/instrument/trombone,
							/obj/item/instrument/recorder,
							/obj/item/instrument/harmonica,
							/obj/item/instrument/piano_synth/headphones
							)
		for(var/V in templist)
			var/atom/A = V
			instruments[initial(A.name)] = A
	return instruments

/obj/item/instrument/musicalmoth
	name = "музыкальный мотылек"
	desc = "Несмотря на свою популярность, эта спорная музыкальная игрушка в конечном итоге была запрещена из-за неэтично сэмплированных звуков кричащих в агонии мотыльков."
	icon_state = "mothsician"
	allowed_instrument_ids = "mothscream"
	attack_verb_continuous = list("flutters", "flaps")
	attack_verb_simple = list("flutter", "flap")
	w_class = WEIGHT_CLASS_TINY
	force = 0
	hitsound = 'sound/voice/moth/scream_moth.ogg'
	custom_price = PAYCHECK_HARD * 2.37
	custom_premium_price = PAYCHECK_HARD * 2.37
