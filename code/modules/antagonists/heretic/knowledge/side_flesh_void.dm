// Sidepaths for knowledge between Flesh and Void.

/datum/heretic_knowledge/void_cloak
	name = "Плащ Пустоты"
	desc = "Плащ с тремя карманами, способный становиться невидимым, скрывая все хранимые предметы. \
		Для создания трансмутируйте осколок стекла, одежу, которую можно одеть поверх униформы и простыню."
	gain_text = "Сова - хранительница тех вещей, которых в реальности нет, но могли бы быть. А таких вещей множество."
	next_knowledge = list(
		/datum/heretic_knowledge/limited_amount/flesh_ghoul,
		/datum/heretic_knowledge/cold_snap,
	)
	required_atoms = list(
		/obj/item/shard = 1,
		/obj/item/clothing/suit = 1,
		/obj/item/bedsheet = 1,
	)
	result_atoms = list(/obj/item/clothing/suit/hooded/cultrobes/void)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/spell/blood_siphon
	name = "Поглощение Крови"
	desc = "Открывает вам Поглощение Крови, заклинание, которое крадет кровь и здоровье жертвы, передавая их вам. \
		Также имеет небольшой шанс перенести ваши травмы жертве."
	gain_text = "\"Неважно кто перед тобой - если его можно ранить, значит, его можно и убить.\" Так сказал мне Маршал."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/void_phase,
		/datum/heretic_knowledge/summon/raw_prophet,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/blood_siphon
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/spell/cleave
	name = "Кровавый Раскол"
	desc = "Дарует вам Раскол, заклинание вызывающее сильное кровотечение, \
		и обильную кровопотерю, у всех пораженных в зоне действия"
	gain_text = "Сначала я не понимал этих орудий войны и пыток, что даровал мне Жрец. \
		Но с каждым новым инструментом убийства, он повторял, что скоро я познаю всю их мощь"
	next_knowledge = list(
		/datum/heretic_knowledge/summon/stalker,
		/datum/heretic_knowledge/spell/void_pull,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/cleave
	cost = 1
	route = PATH_SIDE
