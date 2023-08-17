/datum/gear/suit
	subtype_path = /datum/gear/suit
	slot = ITEM_SLOT_OCLOTHING
	sort_category = "Верхняя одежда"
	cost = 25

//WINTER COATS
/datum/gear/suit/wintercoat
	subtype_path = /datum/gear/suit/wintercoat
	cost = 80

/datum/gear/suit/wintercoat/grey
	display_name = "зимнее пальто"
	path = /obj/item/clothing/suit/hooded/wintercoat
	cost = 60

/datum/gear/suit/wintercoat/captain
	display_name = "зимнее пальто капитана"
	path = /obj/item/clothing/suit/hooded/wintercoat/captain
	allowed_roles = list(JOB_CAPTAIN)

/datum/gear/suit/wintercoat/security
	display_name = "защитное зимнее пальто"
	path = /obj/item/clothing/suit/hooded/wintercoat/security
	allowed_roles = list(JOB_SECURITY_OFFICER, JOB_HEAD_OF_SECURITY)

/datum/gear/suit/wintercoat/medical
	display_name = "медицинское зимнее пальто"
	path = /obj/item/clothing/suit/hooded/wintercoat/medical
	allowed_roles = list(JOB_PARAMEDIC, JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER, JOB_CHEMIST, JOB_GENETICIST)

/datum/gear/suit/wintercoat/science
	display_name = "научное зимнее пальто"
	path = /obj/item/clothing/suit/hooded/wintercoat/science
	allowed_roles = list(JOB_SCIENTIST, JOB_ROBOTICIST, JOB_RESEARCH_DIRECTOR)

/datum/gear/suit/wintercoat/engineering
	display_name = "инженерное зимнее пальто"
	path = /obj/item/clothing/suit/hooded/wintercoat/engineering
	allowed_roles = list(JOB_CHIEF_ENGINEER, JOB_STATION_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN, JOB_MECHANIC)

/datum/gear/suit/wintercoat/hydro
	display_name = "гидропоническое зимнее пальто"
	path = /obj/item/clothing/suit/hooded/wintercoat/hydro
	allowed_roles = list(JOB_BOTANIST)

/datum/gear/suit/wintercoat/cargo
	display_name = "грузовое зимнее пальто"
	path = /obj/item/clothing/suit/hooded/wintercoat/cargo
	allowed_roles = list(JOB_CARGO_TECHNICIAN, JOB_QUARTERMASTER)

/datum/gear/suit/wintercoat/miner
	display_name = "шахтёрское зимнее пальто"
	path = /obj/item/clothing/suit/hooded/wintercoat/miner
	allowed_roles = list(JOB_SHAFT_MINER, JOB_HUNTER)

/datum/gear/suit/karabakh
	display_name = "куртка рейнджера Карабаха"
	path = /obj/item/clothing/suit/armor/hos/ranger
	cost = 450

//JACKETS

/datum/gear/suit/jacket
	subtype_path = /datum/gear/suit/jacket
	cost = 90

/datum/gear/suit/jacket/bomber
	display_name = "куртка бомбер"
	path = /obj/item/clothing/suit/jacket

/datum/gear/suit/jacket/leather
	display_name = "кожаный пиджак"
	path = /obj/item/clothing/suit/jacket/leather

/datum/gear/suit/jacket/leather/overcoat
	display_name = "кожаное пальто"
	path = /obj/item/clothing/suit/jacket/leather/overcoat
	cost = 250

/datum/gear/suit/jacket/miljacket
	display_name = "военная куртка"
	path = /obj/item/clothing/suit/jacket/miljacket

/datum/gear/suit/jacket/letterman
	display_name = "куртка леттермана"
	path = /obj/item/clothing/suit/jacket/letterman

/datum/gear/suit/jacket/letterman_red
	display_name = "красная куртка леттермана"
	path = /obj/item/clothing/suit/jacket/letterman_red

/datum/gear/suit/jacket/letterman_nanotrasen
	display_name = "синяя куртка леттермана"
	path = /obj/item/clothing/suit/jacket/letterman_nanotrasen
	cost = 150

/datum/gear/suit/jacket/letterman_syndie
	display_name = "кроваво-красная куртка леттермана"
	path = /obj/item/clothing/suit/jacket/letterman_syndie
	cost = 150

/datum/gear/suit/jacket/oversized_jacket
	display_name = "пиджак с большими плечами"
	path = /obj/item/clothing/suit/jacket/oversized

/datum/gear/suit/jacket/lawyer
	display_name = "синий пиджак"
	path = /obj/item/clothing/suit/toggle/lawyer
	allowed_roles = list(JOB_LAWYER)

/datum/gear/suit/jacket/lawyer/purple
	display_name = "фиолетовый пиджак"
	path = /obj/item/clothing/suit/toggle/lawyer/purple
	allowed_roles = list(JOB_LAWYER)

/datum/gear/suit/jacket/lawyer/black
	display_name = "чёрный пиджак"
	path = /obj/item/clothing/suit/toggle/lawyer/black
	allowed_roles = list(JOB_LAWYER)

/datum/gear/suit/jacket/vyshivanka
	display_name = "вышиванка"
	path = /obj/item/clothing/suit/vyshivanka
	cost = 500

//PONCHOS

/datum/gear/suit/poncho
	subtype_path = /datum/gear/suit/poncho
	cost = 60

/datum/gear/suit/poncho/classic
	display_name = "классический пончо"
	path = /obj/item/clothing/suit/poncho

/datum/gear/suit/poncho/green
	display_name = "зелёный пончо"
	path = /obj/item/clothing/suit/poncho/green

/datum/gear/suit/poncho/red
	display_name = "красный пончо"
	path = /obj/item/clothing/suit/poncho/red

/datum/gear/suit/samurai
	display_name = "броня самурая"
	path = /obj/item/clothing/suit/costume/samurai
	cost = 400

//COSTUMES

/datum/gear/suit/costume
	subtype_path = /datum/gear/suit/costume
	cost = 500

/datum/gear/suit/costume/soviet_suit
	display_name = "советское бронированное пальто"
	path = /obj/item/clothing/suit/costume/soviet
	cost = 1500
