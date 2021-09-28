
GLOBAL_LIST_INIT(cursed_animal_masks, list(
		/obj/item/clothing/mask/animal/pig/cursed,
		/obj/item/clothing/mask/animal/frog/cursed,
		/obj/item/clothing/mask/animal/cowmask/cursed,
		/obj/item/clothing/mask/animal/horsehead/cursed,
		/obj/item/clothing/mask/animal/rat/cursed,
		/obj/item/clothing/mask/animal/rat/fox/cursed,
		/obj/item/clothing/mask/animal/rat/bee/cursed,
		/obj/item/clothing/mask/animal/rat/bear/cursed,
		/obj/item/clothing/mask/animal/rat/bat/cursed,
		/obj/item/clothing/mask/animal/rat/raven/cursed,
		/obj/item/clothing/mask/animal/rat/jackal/cursed
	))

/obj/item/clothing/mask/animal
	w_class = WEIGHT_CLASS_SMALL
	clothing_flags = VOICEBOX_TOGGLABLE
	modifies_speech = TRUE
	flags_cover = MASKCOVERSMOUTH

	var/animal_type ///what kind of animal the masks represents. used for automatic name and description generation.
	var/list/animal_sounds ///phrases to be said when the player attempts to talk when speech modification / voicebox is enabled.
	var/list/animal_sounds_alt ///lower probability phrases to be said when talking.
	var/animal_sounds_alt_probability ///probability for alternative sounds to play.

	var/cursed ///if it's a cursed mask variant.
	var/curse_spawn_sound ///sound to play when the cursed mask variant is spawned.

/obj/item/clothing/mask/animal/Initialize()
	. = ..()
	if(cursed)
		make_cursed()

/obj/item/clothing/mask/animal/vv_edit_var(vname, vval)
	if(vname == NAMEOF(src, cursed))
		if(vval)
			if(!cursed)
				make_cursed()
		else if(cursed)
			clear_curse()
	return ..()

/obj/item/clothing/mask/animal/examine(mob/user)
	. = ..()
	if(clothing_flags & VOICEBOX_TOGGLABLE)
		. += span_notice("Its voicebox is currently [clothing_flags & VOICEBOX_DISABLED ? "disabled" : "enabled"]. <b>ПКМ</b> to toggle it.")

/obj/item/clothing/mask/animal/AltClick(mob/user)
	. = ..()
	if(clothing_flags & VOICEBOX_TOGGLABLE)
		clothing_flags ^= VOICEBOX_DISABLED
		to_chat(user, span_notice("You [clothing_flags & VOICEBOX_DISABLED ? "disabled" : "enabled"] [src] voicebox."))

/obj/item/clothing/mask/animal/proc/make_cursed() //apply cursed effects.
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT)
	clothing_flags = NONE //force animal sounds to always on.
	if(flags_inv == initial(flags_inv))
		flags_inv = HIDEFACIALHAIR
	name = "Морда [animal_type] "
	desc = "Оно выглядит как маска [animal_type], но если приглядеться получше, то видно, что оно вплавилось в лицо этого человека!"
	if(curse_spawn_sound)
		playsound(src, curse_spawn_sound, 50, TRUE)
	var/update_speech_mod = !modifies_speech && LAZYLEN(animal_sounds)
	if(update_speech_mod)
		modifies_speech = TRUE
	if(ismob(loc))
		var/mob/M = loc
		if(M.get_item_by_slot(ITEM_SLOT_MASK) == src)
			if(update_speech_mod)
				RegisterSignal(M, COMSIG_MOB_SAY, .proc/handle_speech)
			to_chat(M, span_userdanger("[capitalize(src.name)] был проклят!"))
			M.update_inv_wear_mask()

/obj/item/clothing/mask/animal/proc/clear_curse()
	REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT)
	clothing_flags = initial(clothing_flags)
	flags_inv = initial(flags_inv)
	name = initial(name)
	desc = initial(desc)
	var/update_speech_mod = modifies_speech && !initial(modifies_speech)
	if(update_speech_mod)
		modifies_speech = FALSE
	if(ismob(loc))
		var/mob/M = loc
		if(M.get_item_by_slot(ITEM_SLOT_MASK) == src)
			to_chat(M, span_notice("Проклятье было снято с [capitalize(src.name)]!"))
			if(update_speech_mod)
				UnregisterSignal(M, COMSIG_MOB_SAY)
			M.update_inv_wear_mask()

/obj/item/clothing/mask/animal/handle_speech(datum/source, list/speech_args)
	if(clothing_flags & VOICEBOX_DISABLED)
		return
	if(!modifies_speech || !LAZYLEN(animal_sounds))
		return
	speech_args[SPEECH_MESSAGE] = pick((prob(animal_sounds_alt_probability) && LAZYLEN(animal_sounds_alt)) ? animal_sounds_alt : animal_sounds)

/obj/item/clothing/mask/animal/equipped(mob/user, slot)
	if(!iscarbon(user))
		return ..()
	if(slot == ITEM_SLOT_MASK && HAS_TRAIT_FROM(src, TRAIT_NODROP, CURSED_MASK_TRAIT))
		to_chat(user, span_userdanger("[capitalize(src.name)] был проклят!"))
	return ..()


/obj/item/clothing/mask/animal/pig
	name = "маска свиньи"
	desc = "Резиновая маска свиньи со встроенным модулятором голоса."
	animal_type = "pig"
	icon_state = "pig"
	inhand_icon_state = "pig"
	animal_sounds = list("Oink!","Squeeeeeeee!","Oink Oink!")
	curse_spawn_sound = 'sound/magic/pighead_curse.ogg'
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/mask/animal/pig/cursed
	cursed = TRUE

///frog mask - reeee!!
/obj/item/clothing/mask/animal/frog
	name = "маска лягушки"
	desc = "Древняя маска выполненная в форме лягушачьей головы. <br> Безумие, оно, как гравитация — нужно всего-лишь слегка подтолкнуть."
	icon_state = "frog"
	inhand_icon_state = "frog"
	animal_sounds = list("Ree!!", "Reee!!","REEE!!","REEEEE!!")
	animal_sounds_alt_probability = 5
	animal_sounds_alt = list("HUUUUU!!","SMOOOOOKIN'!!","Hello my baby, hello my honey, hello my rag-time gal.", "Feels bad, man.", "GIT DIS GUY OFF ME!!" ,"SOMEBODY STOP ME!!", "NORMIES, GET OUT!!")
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/mask/animal/frog/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/cowmask
	name = "коровья маска"
	icon_state = "cowmask"
	inhand_icon_state = "cowmask"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	curse_spawn_sound = 'sound/magic/cowhead_curse.ogg'
	animal_sounds = list("Moooooooo!","Moo!","Moooo!")

/obj/item/clothing/mask/animal/cowmask/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/horsehead
	name = "маска в виде лошадиной головы"
	desc = "Маска из мягкого винила и латекса в виде лошадиной головы."
	animal_type = "horse"
	icon_state = "horsehead"
	inhand_icon_state = "horsehead"
	animal_sounds = list("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEEYES|HIDEEARS|HIDESNOUT
	curse_spawn_sound = 'sound/magic/horsehead_curse.ogg'

/obj/item/clothing/mask/animal/horsehead/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/rat
	name = "маска крысы"
	desc = "Маска из мягкого винила и латекса в виде крысиной головы."
	animal_type = "rat"
	icon_state = "rat"
	inhand_icon_state = "rat"
	flags_inv = HIDEFACE|HIDESNOUT
	modifies_speech = FALSE
	animal_sounds = list("Skree!","SKREEE!","Squeak!")

/obj/item/clothing/mask/animal/rat/make_cursed()
	flags_inv = NONE
	return ..()

/obj/item/clothing/mask/animal/rat/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/rat/fox
	name = "маска лисы"
	desc = "Маска из мягкого винила и латекса в виде лисьей головы."
	animal_type = "fox"
	icon_state = "fox"
	inhand_icon_state = "fox"
	animal_sounds = list("Ack-Ack!","Ack-Ack-Ack-Ackawoooo!","Geckers!","AWOO!","TCHOFF!")

/obj/item/clothing/mask/animal/rat/fox/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/rat/bee
	name = "маска пчелы"
	desc = "Маска из мягкого винила и латекса в виде пчелиной головы."
	animal_type = "bee"
	icon_state = "bee"
	inhand_icon_state = "bee"
	animal_sounds = list("BZZT!", "BUZZZ!", "B-zzzz!", "Bzzzzzzttttt!")

/obj/item/clothing/mask/animal/rat/bee/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/rat/bear
	name = "маска медведя"
	desc = "Маска из мягкого винила и латекса в виде медвежьей головы."
	animal_type = "bear"
	icon_state = "bear"
	inhand_icon_state = "bear"
	animal_sounds = list("RAWR!","Rawr!","GRR!","Growl!")

/obj/item/clothing/mask/animal/rat/bear/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/rat/bat
	name = "маска летучей мыши"
	desc = "Маска из мягкого винила и латекса в виде головы летучей мыши."
	animal_type = "bat"
	icon_state = "bat"
	inhand_icon_state = "bat"

/obj/item/clothing/mask/animal/rat/bat/cursed
	cursed = TRUE


/obj/item/clothing/mask/animal/rat/raven
	name = "маска ворона"
	desc = "Маска из мягкого винила и латекса в виде вороньей головы."
	icon_state = "raven"
	inhand_icon_state = "raven"
	animal_type = "raven"
	animal_sounds = list("CAW!", "C-CAWW!", "Squawk!")
	animal_sounds_alt = list("Nevermore...")
	animal_sounds_alt_probability = 1

/obj/item/clothing/mask/animal/rat/raven/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/rat/jackal
	name = "маска шакала"
	desc = "Маска из мягкого винила и латекса в виде шакальей головы."
	animal_type = "jackal"
	icon_state = "jackal"
	inhand_icon_state = "jackal"
	animal_sounds = list("YAP!", "Woof!", "Bark!", "AUUUUUU!")

/obj/item/clothing/mask/animal/rat/jackal/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/rat/tribal
	name = "маска племени"
	desc = "Маска вырезанная из дерева с тщательной ручной детализацией."
	animal_type = "tribal" //honk.
	icon_state = "bumba"
	inhand_icon_state = "bumba"
	animal_sounds = list("Bad juju, mon!", "Da Iwa be praised!", "Sum bad mojo, dat!", "You do da voodoo, mon!")
	animal_sounds_alt = list("Eekum-bokum!", "Oomenacka!", "In mah head..... Zombi.... Zombi!")
	animal_sounds_alt_probability = 5

/obj/item/clothing/mask/animal/rat/tribal/cursed //adminspawn only.
	cursed = TRUE
