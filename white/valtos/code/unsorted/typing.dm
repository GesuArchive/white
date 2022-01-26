GLOBAL_DATUM_INIT(human_typing_indicator, /mutable_appearance, mutable_appearance('icons/mob/talk.dmi', "default0", -TYPING_LAYER))

/mob/proc/create_typing_indicator()
	return

/mob/proc/remove_typing_indicator()
	return

/mob/set_stat(new_stat)
	. = ..()
	if(.)
		remove_typing_indicator()

/mob/proc/get_input_text()
	return copytext_char(winget(src, "outputwindow.input", "text"), 10)

////Wrappers////
//Keybindings were updated to change to use these wrappers. If you ever remove this file, revert those keybind changes
/mob/verb/say_wrapper()
	set name = ".сказать"
	set hidden = 1
	set instant = 1

	create_typing_indicator()
	var/message = input("", pick("Эй, послушай...", "И конечно же мы скажем...", "Вероятно надо сказать...", "Хотелось бы сказать...", "Слушай внимательно...")) as text|null
	remove_typing_indicator()
	if(message)
		say_verb(message)

///Human Typing Indicators///
/mob/living/carbon/human/create_typing_indicator()
	if(!overlays_standing[TYPING_LAYER] && stat == CONSCIOUS) //Prevents sticky overlays and typing while in any state besides conscious
		overlays_standing[TYPING_LAYER] = GLOB.human_typing_indicator
		apply_overlay(TYPING_LAYER)

/mob/living/carbon/human/remove_typing_indicator()
	remove_overlay(TYPING_LAYER)
