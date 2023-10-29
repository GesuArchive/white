/datum/language/ratvar
	name = "Ratvarian"
	desc = "A timeless language full of power and incomprehensible to the unenlightened."
	key = "r"
	default_priority = 10
	spans = list(SPAN_ROBOT)
	icon_state = "ratvar"

/datum/language/ratvar/scramble(input)
	. = text2ratvar(input)
