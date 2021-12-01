//traits with no real impact that can be taken freely
//MAKE SURE THESE DO NOT MAJORLY IMPACT GAMEPLAY. those should be positive or negative traits.

/datum/quirk/no_taste
	name = "Агевзия"
	desc = "Вы потеряли свои вкусовые рецепторы и больше не сможете ощущать вкус еды. Токсичная пища всё ещё будет отравлять вас."
	value = 0
	mob_trait = TRAIT_AGEUSIA
	gain_text = span_notice("Больше не чувствую вкус еды!")
	lose_text = span_notice("Теперь можно почувствовать вкус еды!")
	medical_record_text = "Пациент страдает от агавзии и неспособен чувствовать вкус еды или жидкости."

/datum/quirk/foreigner
	name = "Мигрант"
	desc = "Вы не знаете галактический язык."
	value = 0
	gain_text = span_notice("Вы не понимаете ни слова.")
	lose_text = span_notice("Вы научились понимать основной галактический язык.")
	medical_record_text = "Пациент не разговаривает на основном галактическом языке."

/datum/quirk/foreigner/add()
	var/mob/living/carbon/human/H = quirk_holder
	H?.add_blocked_language(/datum/language/common)
	if(ishumanbasic(H))
		H.grant_language(/datum/language/uncommon)

/datum/quirk/foreigner/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H?.remove_blocked_language(/datum/language/common)
	if(ishumanbasic(H))
		H.remove_language(/datum/language/uncommon)

/datum/quirk/vegetarian
	name = "Вегетарианец"
	desc = "Вы находите идею есть мясо физически и морально отталкивающим."
	value = 0
	gain_text = span_notice("Нахожу идею есть мясо физически и морально отталкивающим.")
	lose_text = span_notice("А мясо-то довольно вкусное!")
	medical_record_text = "Пациент сообщает о вегетарианской диете."

/datum/quirk/vegetarian/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.liked_food &= ~MEAT
	species.disliked_food |= MEAT

/datum/quirk/vegetarian/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		if(initial(species.liked_food) & MEAT)
			species.liked_food |= MEAT
		if(!(initial(species.disliked_food) & MEAT))
			species.disliked_food &= ~MEAT

/datum/quirk/snob
	name = "Snob"
	desc = "Вас заботит чистый вид помещений. Если комната выглядит не такой уж и красивой, стоит ли это того?"
	value = 0
	gain_text = span_notice("Чуствую, как-будто знаю, как по-настоящему должны выглядеть комнаты.")
	lose_text = span_notice("Ну. Кого вообще заботят какие-то декорации?")
	medical_record_text = "Пациент демонстрирует напористость."
	mob_trait = TRAIT_SNOB

/datum/quirk/pineapple_liker
	name = "Любитель ананасов"
	desc = "Вы так обожаете ананасы!"
	value = 0
	gain_text = span_notice("Чувствую, что испытываю сильную тягу к ананасам.")
	lose_text = span_notice("Моя любовь к ананасам медленно угасает.")
	medical_record_text = "Пациент демонстрирует патологическую любовь к ананасу."

/datum/quirk/pineapple_liker/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.liked_food |= PINEAPPLE

/datum/quirk/pineapple_liker/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		species.liked_food &= ~PINEAPPLE

/datum/quirk/pineapple_hater
	name = "Отвращение к ананасам"
	desc = "Я ненавижу ананасы. Серьёзно, они же совсем невкусные! И кто вообще посмеет положить их в пиццу!?"
	value = 0
	gain_text = span_notice("Думаю над тем, какой кусок идиота любит ананасы...")
	lose_text = span_notice("Моя ненависть к ананасам медленнно угасает...")
	medical_record_text = "Пациент считает, что ананасы отвратительны."

/datum/quirk/pineapple_hater/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.disliked_food |= PINEAPPLE

/datum/quirk/pineapple_hater/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		species.disliked_food &= ~PINEAPPLE

/datum/quirk/deviant_tastes
	name = "Девиантные вкусы"
	desc = "Вы не любите ту еду, которое большинство предпочитает употреблять. Тем не менее, вы любите то, чего не любят они."
	value = 0
	gain_text = span_notice("У вас возникает жажда съесть что-нибудь странное на вкус.")
	lose_text = span_notice("Мне хочется поесть нормальную еду.")
	medical_record_text = "Пациент демонстрирует необычные предпочтения к еде."

/datum/quirk/deviant_tastes/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	var/liked = species.liked_food
	species.liked_food = species.disliked_food
	species.disliked_food = liked

/datum/quirk/deviant_tastes/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		species.liked_food = initial(species.liked_food)
		species.disliked_food = initial(species.disliked_food)

/datum/quirk/monochromatic
	name = "Монохромия"
	desc = "Вы не можете различать цвета и вижу весь мир в черно-белых тонах."
	value = 0
	medical_record_text = "У пациента было обнаружено нарушение цветового зрения."

/datum/quirk/monochromatic/add()
	quirk_holder.add_client_colour(/datum/client_colour/monochrome)

/datum/quirk/monochromatic/post_add()
	if(quirk_holder.mind.assigned_role == "Detective")
		to_chat(quirk_holder, span_boldannounce("Ммм. На этой станции нет ничего чистого. Это всё оттенки серого..."))
		quirk_holder.playsound_local(quirk_holder, 'sound/ambience/ambidet1.ogg', 50, FALSE)

/datum/quirk/monochromatic/remove()
	if(quirk_holder)
		quirk_holder.remove_client_colour(/datum/client_colour/monochrome)

/datum/quirk/phobia
	name = "Фобия"
	desc = "Вы чего-то боитесь."
	value = 0
	medical_record_text = "Пациент чего-то очень сильно боится."

/datum/quirk/phobia/post_add()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(new /datum/brain_trauma/mild/phobia(H.client?.prefs.phobia), TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/phobia/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		H.cure_trauma_type(/datum/brain_trauma/mild/phobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/needswayfinder
	name = "Проблемы с навигацией"
	desc = "Не зная, как выглядят те или иные станции, вы предпочитаете брать с собой путеводитель-указатель."
	value = 0
	medical_record_text = "Пациент демонстрирует тягу к заблужению."

	var/obj/item/pinpointer/wayfinding/wayfinder
	var/where

/datum/quirk/needswayfinder/on_spawn()
	if(!GLOB.wayfindingbeacons.len)
		return
	var/mob/living/carbon/human/H = quirk_holder

	wayfinder = new /obj/item/pinpointer/wayfinding
	wayfinder.owner = H.real_name
	wayfinder.roundstart = TRUE

	var/list/slots = list(
		"in your left pocket" = ITEM_SLOT_LPOCKET,
		"in your right pocket" = ITEM_SLOT_RPOCKET,
		"in your backpack" = ITEM_SLOT_BACKPACK
	)
	where = H.equip_in_one_of_slots(wayfinder, slots, FALSE) || "at your feet"

/datum/quirk/needswayfinder/post_add()
	if(!GLOB.wayfindingbeacons.len)
		return
	if(where == "in your backpack")
		var/mob/living/carbon/human/H = quirk_holder
		SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_SHOW, H)

	to_chat(quirk_holder, span_notice("У вас с собой указатель [where], который поможет вам найти путь в какой-либо отсек. Нажмите в руке, чтобы активировать."))

/datum/quirk/bald
	name = "Лысый"
	desc = "У вас нет волос и чувствуете себя некомфортно от этого! Необходимо носить с собой парик или носить то, что закрывает голову."
	value = 0
	mob_trait = TRAIT_BALD
	gain_text = span_notice("Лысый. Удивительно, не правда ли?")
	lose_text = span_notice("Моя голова чешется... у меня что, растут волосы?!")
	medical_record_text = "Пациент во время осмотра категорически отказывался снять свой головной убор."
	///The user's starting hairstyle
	var/old_hair

/datum/quirk/bald/add()
	var/mob/living/carbon/human/H = quirk_holder
	old_hair = H.hairstyle
	H.hairstyle = "Bald"
	H.update_hair()
	RegisterSignal(H, COMSIG_CARBON_EQUIP_HAT, .proc/equip_hat)
	RegisterSignal(H, COMSIG_CARBON_UNEQUIP_HAT, .proc/unequip_hat)

/datum/quirk/bald/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H.hairstyle = old_hair
	H.update_hair()
	UnregisterSignal(H, list(COMSIG_CARBON_EQUIP_HAT, COMSIG_CARBON_UNEQUIP_HAT))
	SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "bad_hair_day")

/datum/quirk/bald/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/head/wig/natural/W = new(get_turf(H))
	if (old_hair == "Bald")
		W.hairstyle = pick(GLOB.hairstyles_list - "Bald")
	else
		W.hairstyle = old_hair
	W.update_icon()
	var/list/slots = list (
		"head" = ITEM_SLOT_HEAD,
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS,
	)
	H.equip_in_one_of_slots(W, slots , qdel_on_fail = TRUE)

///Checks if the headgear equipped is a wig and sets the mood event accordingly
/datum/quirk/bald/proc/equip_hat(mob/user, obj/item/hat)
	SIGNAL_HANDLER

	if(istype(hat, /obj/item/clothing/head/wig))
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "bad_hair_day", /datum/mood_event/confident_mane) //Our head is covered, but also by a wig so we're happy.
	else
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "bad_hair_day") //Our head is covered

///Applies a bad moodlet for having an uncovered head
/datum/quirk/bald/proc/unequip_hat(mob/user, obj/item/clothing, force, newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER

	SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "bad_hair_day", /datum/mood_event/bald)


/datum/quirk/tongue_tied
	name = "Поврежденный язык"
	desc = "С вашим языком произошел слегка неприятный инцидент. Возможность к коммуникации теперь осуществляется с помощью рук."
	value = 0
	medical_record_text = "Во время физического осмотра, язык пациента оказался сильно поврежден."

//Adds tongue & gloves
/datum/quirk/tongue_tied/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/organ/tongue/old_tongue = locate() in H.internal_organs
	var/obj/item/organ/tongue/tied/new_tongue = new(get_turf(H))
	var/obj/item/clothing/gloves/radio/gloves = new(get_turf(H))
	old_tongue.Remove(H)
	new_tongue.Insert(H)
	qdel(old_tongue)
	if(!H.equip_to_slot_if_possible(gloves, ITEM_SLOT_GLOVES, bypass_equip_delay_self = TRUE))
		H.put_in_hands(gloves)

/datum/quirk/tongue_tied/post_add()
	to_chat(quirk_holder, span_boldannounce("Because you speak with your hands, having them full hinders your ability to communicate!"))

/datum/quirk/photographer
	name = "Фотограф"
	desc = "Вы знаете, как обращаться с камерой, и умеете сокращать задержку между каждым снимком."
	value = 0
	mob_trait = TRAIT_PHOTOGRAPHER
	gain_text = span_notice("Знаю всё о фотографировании.")
	lose_text = span_danger("Забываю, как работают фотоаппараты.")
	medical_record_text = "Пациент упоминал фотографирование как хобби, снимающее стресс."

/datum/quirk/photographer/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/storage/photo_album/personal/photo_album = new(get_turf(H))
	var/list/album_slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS
	)
	H.equip_in_one_of_slots(photo_album, album_slots , qdel_on_fail = TRUE)
	photo_album.persistence_id = "personal_[H.mind.key]" // this is a persistent album, the ID is tied to the account's key to avoid tampering
	photo_album.persistence_load()
	photo_album.name = "[H.real_name] photo album"
	var/obj/item/camera/camera = new(get_turf(H))
	var/list/camera_slots = list (
		"neck" = ITEM_SLOT_NECK,
		"left pocket" = ITEM_SLOT_LPOCKET,
		"right pocket" = ITEM_SLOT_RPOCKET,
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS
	)
	H.equip_in_one_of_slots(camera, camera_slots , qdel_on_fail = TRUE)
	H.regenerate_icons()

/datum/quirk/colorist
	name = "Colorist"
	desc = "You like carrying around a hair dye spray to quickly apply color patterns to your hair."
	value = 0
	medical_record_text = "Patient enjoys dyeing their hair with pretty colors."

/datum/quirk/colorist/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/dyespray/spraycan = new(get_turf(H))
	H.put_in_hands(spraycan)
	H.equip_to_slot(spraycan, ITEM_SLOT_BACKPACK)
	H.regenerate_icons()
