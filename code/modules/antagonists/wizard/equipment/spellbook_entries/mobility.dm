// Wizard spells that aid mobiilty(or stealth?)
/datum/spellbook_entry/mindswap
	name = "Обмен разумов"
	desc = "Позволяет вам обменяться телами с разумным гуманоидом находящимся рядом. Вы оба потеряете сознание, когда это произойдет, и будет совершенно очевидно, что вы поменялись телами, тем более если кто то это увидел."
	spell_type = /datum/action/cooldown/spell/pointed/mind_transfer
	category = "Mobility"

/datum/spellbook_entry/knock
	name = "Стук"
	desc = "Открывает любые двери и шкафчики рядом с вами."
	spell_type = /datum/action/cooldown/spell/aoe/knock
	category = "Mobility"
	cost = 1

/datum/spellbook_entry/blink
	name = "Блик"
	desc = "Случайным образом телепортирует вас на короткое расстояние."
	spell_type = /datum/action/cooldown/spell/teleport/radius_turf/blink
	category = "Mobility"

/datum/spellbook_entry/teleport
	name = "Телепортация"
	desc = "Телепортирует вас в выбранную вами область станции."
	spell_type = /datum/action/cooldown/spell/teleport/area_teleport/wizard
	category = "Mobility"

/datum/spellbook_entry/jaunt
	name = "Бестелесная прогулка"
	desc = "Преремещает ваше тело в иную часть реальности, временно делая вас невидимым и способным проходить сквозь стены."
	spell_type = /datum/action/cooldown/spell/jaunt/ethereal_jaunt
	category = "Mobility"

/datum/spellbook_entry/swap
	name = "Обмен"
	desc = "Поменяйтесь местами с любой живой целью в пределах девяти метров. Щелкните правой кнопкой мыши, чтобы отметить вторичную цель. Вы всегда будете переключаться на свою основную цель."
	spell_type = /datum/action/cooldown/spell/pointed/swap
	category = "Mobility"
	cost = 1

/datum/spellbook_entry/item/warpwhistle
	name = "Варп-свисток"
	desc = "Вызывает смерч, способный забрать вас и высадить в случайном месте на станции."
	item_path = /obj/item/warp_whistle
	category = "Mobility"
	cost = 1

/datum/spellbook_entry/item/staffdoor
	name = "Жезл Создания Дверей"
	desc = "Особый жезл, способный превращать тусклые стены в прекрасные двери. Полезно для передвижения при отсутствии иных альтернатив. Не работает на стекле."
	item_path = /obj/item/gun/magic/staff/door
	cost = 1
	category = "Mobility"
