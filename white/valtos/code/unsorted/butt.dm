/obj/item/organ/butt
	name = "задница"
	desc = "невероятно драгоценная часть тела"
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	icon_state = "butt"
	worn_icon_state = "butt"
	zone = "groin"
	slot = "butt"
	throwforce = 5
	throw_speed = 4
	force = 5
	embedding = list("embed_chance" = 5) // This is a joke
	hitsound = 'white/valtos/sounds/poo2.ogg'
	body_parts_covered = HEAD
	slot_flags = ITEM_SLOT_HEAD
	var/loose = 0

/obj/item/organ/butt/Initialize(mapload)
	. = ..()
	create_storage(
		max_slots = 2,
		max_total_storage = WEIGHT_CLASS_NORMAL,
		max_specific_storage = WEIGHT_CLASS_SMALL
	)
	atom_storage.allow_big_nesting = TRUE
	atom_storage.silent = TRUE

/obj/item/organ/butt/xeno //XENOMORPH BUTTS ARE BEST BUTTS yes i agree
	name = "задница ксеноса"
	desc = "лучший трофей"
	icon_state = "xenobutt"
	worn_icon_state = "xenobutt"

/obj/item/organ/butt/xeno/Initialize()
	. = ..()
	atom_storage.max_slots = 3
	atom_storage.max_total_storage = WEIGHT_CLASS_HUGE
	atom_storage.max_specific_storage = WEIGHT_CLASS_HUGE	//That's a BIG ass yo

/obj/item/organ/butt/bluebutt // bluespace butts, science
	name = "блюспейс задница"
	desc = "Высокотехнологичный протез задницы с подпространственным карманом для хранения предметов."
	icon_state = "bluebutt"
	worn_icon_state = "bluebutt"
	status = ORGAN_ROBOTIC

/obj/item/organ/butt/bluebutt/Initialize()
	. = ..()
	atom_storage.max_slots = 4
	atom_storage.max_total_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL

/obj/item/organ/butt/on_life()
	. = ..()
	if(atom_storage)
		var/list/items_inside = list()
		atom_storage.return_inv(items_inside, FALSE)
		for(var/obj/item/I in items_inside)
			if(I.get_sharpness())
				owner.bleed(4)
				if(prob(25))
					to_chat(owner, span_danger("Что-то режет меня изнутри!"))

/obj/item/organ/butt/attackby(var/obj/item/W, mob/user as mob, params) // copypasting bot manufucturing process, im a lazy fuck
	if(istype(W, /obj/item/bodypart/l_arm/robot) || istype(W, /obj/item/bodypart/r_arm/robot))
		if(istype(src, /obj/item/organ/butt/bluebutt)) //nobody sprited a blue butt buttbot
			to_chat(user, span_warning("Не получится!"))
			return
		user.dropItemToGround(W)
		qdel(W)
		var/turf/T = get_turf(src.loc)
		var/mob/living/simple_animal/bot/buttbot/B = new /mob/living/simple_animal/bot/buttbot(T)
		if(istype(src, /obj/item/organ/butt/xeno))
			B.xeno = 1
			B.icon_state = "buttbot_xeno"
			B.speech_list = list("хссс жопка", "хсс хсс пидор", "отличный трофей, придурок", "жопа", "инспекция жопы пришельца начата")
		to_chat(user, span_notice("Добавлю руку к жопе... Ммм?"))
		user.dropItemToGround(src)
		qdel(src)
	else
		return ..()

/obj/item/organ/butt/throw_impact(atom/hit_atom)
	. = ..()
	playsound(src, 'white/valtos/sounds/poo2.ogg', 50, 1, 5)

///////////////////////////////////////////////////////////////mob stuff

/mob/living/carbon/human/proc/checkbuttinspect(mob/living/carbon/user)
	if(user.zone_selected != BODY_ZONE_PRECISE_GROIN)
		return FALSE

	var/obj/item/organ/butt/butt_organ = getorgan(/obj/item/organ/butt)
	if(!butt_organ)
		to_chat(user, span_warning("А задница-то отсутствует!"))
		return TRUE

	if(w_uniform)
		if(user == src)
			user.visible_message(span_warning("[user] хватает себя за зад!"), span_warning("Хватаю себя за зад!"))
			to_chat(user,  span_warning("Надо бы снять одежду сперва!"))
		else
			user.visible_message(span_warning("[user] хватает [src] за задницу!"), span_warning("Хватаю задницу [src]!"))
			to_chat(user, span_warning("Надо бы снять с [src] одежду!"))
			to_chat(src, span_userdanger("Мой зад кто-то схватил!"))
		return TRUE

	if(butt_organ && butt_organ.atom_storage)
		user.visible_message(span_warning("[user] начинает инспектировать [user == src ? "свою задницу" : "задницу [src]"]!"), span_warning("Начинаю инспектировать [user == src ? "свою задницу" : "задницу [src]"]!"))
		if(do_mob(user, src, 40))
			user.visible_message(span_warning("[user] инспектирует [user == src ? "свою задницу" : "задницу [src]"]!"), span_warning("Инспектирую [user == src ? "свою задницу" : "задницу [src]"]!"))
			if (user.active_storage)
				user.active_storage.hide_contents(user)
			butt_organ.atom_storage.show_contents(user)
			return TRUE
		else
			user.visible_message(span_warning("[user] проваливает попытку инспекции [user == src ? "своей задницы" : "задницы [src]"]!"), span_warning("Не вышло проинспектировать [user == src ? "свою задницу" : "задницу [src]"]!"))
			return TRUE
	else
		to_chat(user, span_warning("Задницы нет!"))
		return TRUE

/mob/living/carbon/human/grabbedby(mob/living/user, supress_message = FALSE)
	if (checkbuttinspect(user))
		return FALSE
	return ..()

/mob/living/carbon/proc/checkbuttinsert(obj/item/I, mob/living/carbon/user)
	if(user.zone_selected != BODY_ZONE_PRECISE_GROIN)
		return FALSE

	if(user.a_intent != INTENT_GRAB)
		return FALSE

	var/mob/living/carbon/human/butt_owner = src
	if(!istype(butt_owner))
		return TRUE

	if(butt_owner.w_uniform)
		to_chat(user, span_danger("Надо бы снять одежду сперва!"))
		return TRUE

	var/obj/item/organ/butt/butt_organ = butt_owner.getorgan(/obj/item/organ/butt)
	if(!butt_organ?.atom_storage)
		return TRUE

	user.visible_message(span_warning("[user] начинает прятать [I] в [user == src ? "свою задницу" : "задницу [src]"]."), span_warning("Начинаю прятать [I] в [user == src ? "свою задницу" : "задницу [src]"]."))

	if(butt_organ.atom_storage.attempt_insert(I, user, override = TRUE))
		user.visible_message(span_warning("[user] прячет [I] внутри [user == src ? "своей задницы" : "задницы [src]"]."), span_warning("Прячу [I] внутри [user == src ? "своей задницы" : "задницы [src]"]."))

	return TRUE

///////////////////////////////////////////////////////////////////other

/mob/living/simple_animal/bot/buttbot
	name = "жопобот"
	desc = "Жопа с рукой. Вопросы???"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "buttbot"
	layer = 5.0
	density = 0
	anchored = 0
	health = 25
	var/xeno = 0 //Do we hiss when buttspeech?
	var/cooldown = 0
	var/list/speech_buffer = list()
	var/list/speech_list = list("жопа.", "жопы.", "задница.", "пук.", "assblast usa", "НАЧИНАЮ ИНСПЕКЦИЮ ЗАДНИЦ", "вуп") //Hilarious.

/mob/living/simple_animal/bot/buttbot/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()
	if(xeno)
		icon_state = "buttbot_xeno"
		speech_list = list("хссс жопка", "хсс хсс пидор", "отличный трофей, придурок", "жопа", "инспекция жопы пришельца начата")

/mob/living/simple_animal/bot/buttbot/explode()
	visible_message(span_userdanger("[capitalize(src.name)] взрывается!"))
	var/turf/T = get_turf(src)

	if(prob(50))
		new /obj/item/bodypart/l_arm/robot(T)
	if(xeno)
		new /obj/item/organ/butt/xeno(T)
	else
		new /obj/item/organ/butt(T)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()


	. = ..()

/mob/living/simple_animal/bot/buttbot/handle_automated_action()
	if (!..())
		return

	if(isturf(src.loc))
		var/anydir = pick(GLOB.cardinals)
		if(Process_Spacemove(anydir))
			Move(get_step(src, anydir), anydir)

	if(prob(5) && cooldown < world.time)
		cooldown = world.time + 200 //20 seconds
		if(xeno) //Hiss like a motherfucker
			playsound(loc, "hiss", 15, 1, 1)
		if(prob(70) && speech_buffer.len)
			speak(buttificate(pick(speech_buffer)))
			if(prob(5))
				speech_buffer.Remove(pick(speech_buffer)) //so they're not magic wizard guru buttbots that hold arcane information collected during an entire round.
		else
			speak(pick(speech_list))

/mob/living/simple_animal/bot/buttbot/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq)
	//Also dont imitate ourselves. Imitate other buttbots though heheh
	if(speaker != src && prob(40))
		if(speech_buffer.len >= 20)
			speech_buffer -= pick(speech_buffer)
		speech_buffer |= html_decode(raw_message)
	..()

/proc/buttificate(phrase)
	var/params = replacetext_char(phrase, " ", "&")
	var/list/buttphrase = params2list(params)
	var/finalphrase = ""
	for(var/p in buttphrase)
		if(prob(20))
			p="жопа"
		finalphrase = finalphrase+p+" "
	finalphrase = replacetext_char(finalphrase, " #39 ","'")
	finalphrase = replacetext_char(finalphrase, " s "," ") //this is really dumb and hacky, gets rid of trailing 's' character on the off chance that '#39' gets swapped
	if(findtext_char(finalphrase,"жопа"))
		return finalphrase
	return

/datum/crafting_recipe/food/buttkebab
	name = "Кебаб из задницы"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/organ/butt = 1
	)
	result = /obj/item/food/kebab/butt
	subcategory = CAT_MEAT

/obj/item/food/kebab/butt
	name = "butt-kebab"
	desc = "Butt on a stick."
	icon_state = "buttkebab"
	icon = 'white/valtos/icons/objects.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("жопа" = 2, "метал" = 1)
	foodtypes = MEAT | GROSS

/datum/crafting_recipe/food/assburger
	name = "Жопобургер"
	reqs = list(
			/obj/item/food/meat/steak/plain = 1,
			/obj/item/food/bun = 1,
			/obj/item/organ/butt = 1
	)

	result = /obj/item/food/burger/assburger
	subcategory = CAT_BURGER

/obj/item/food/burger/assburger
	name = "assburger"
	desc = "What the hell, that's not domesticated donkey meat, it's a literal buttburger!"
	tastes = list("butt" = 4)
	foodtypes = MEAT | GRAIN | GROSS
	food_reagents = list(/datum/reagent/drug/fartium = 10, /datum/reagent/consumable/nutriment = 2)
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "assburger"

/datum/crafting_recipe/food/asspie
	name = "Пирог из жопы"
	reqs = list(
		/datum/reagent/consumable/blackpepper = 1,
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/pie/plain = 1,
		/obj/item/organ/butt = 1)
	result = /obj/item/food/pie/asspie
	subcategory = CAT_PIE

/obj/item/food/pie/asspie
	name = "asspie"
	desc = "A delicious pie made from domesticated donkey, OH WAIT IS THAT A BUTT!"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "asspie"
	tastes = list("пирог" = 2, "жопа" = 4)
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/drug/fartium = 10)
	foodtypes = GRAIN | DAIRY | SUGAR | GROSS

/datum/crafting_recipe/buttshoes
	name = "Жопобуты"
	result = /obj/item/clothing/shoes/buttshoes
	reqs = list(/obj/item/organ/butt = 2,
				/obj/item/clothing/shoes/sneakers = 1)
	tool_paths = list(/obj/item/wirecutters)
	time = 50
	category = CAT_CLOTHING

/obj/item/clothing/shoes/buttshoes
	desc = "Зачем?"
	name = "жопобуты"
	worn_icon = 'white/valtos/icons/clothing/mob/shoe.dmi'
	icon = 'white/valtos/icons/clothing/shoes.dmi'
	icon_state = "buttshoes"
	worn_icon_state = "buttshoes"

/obj/item/clothing/shoes/buttshoes/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('white/valtos/sounds/poo2.ogg'), 50)

/mob/living/carbon/human/create_internal_organs()
	internal_organs += new /obj/item/organ/butt
	return ..()
