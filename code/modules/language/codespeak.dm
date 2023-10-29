/datum/language/codespeak
	name = "Codespeak"
	desc = "Оперативники Синдиката могут использовать серию кодовых слов для передачи сложной информации, звучащей как случайные понятия и напитки для всех, кто их подслушивает."
	key = "t"
	default_priority = 0
	flags = TONGUELESS_SPEECH | LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD
	icon_state = "codespeak"

/datum/language/codespeak/scramble(input)
	var/lookup = check_cache(input)
	if(lookup)
		return lookup

	. = ""
	var/list/words = list()
	while(length_char(.) < length_char(input))
		words += generate_code_phrase(return_list=TRUE)
		. = jointext(words, ", ")

	. = capitalize(.)

	var/input_ending = copytext_char(input, -1)

	var/static/list/endings
	if(!endings)
		endings = list("!", "?", ".")

	if(input_ending in endings)
		. += input_ending

	add_to_cache(input, .)
