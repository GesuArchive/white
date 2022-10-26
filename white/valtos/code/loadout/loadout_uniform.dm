// Uniform slot
/datum/gear/uniform
	subtype_path = /datum/gear/uniform
	slot = ITEM_SLOT_ICLOTHING
	sort_category = "Униформы"
	species_blacklist = list("plasmaman") //Envirosuit moment
	cost = 50

/datum/gear/uniform/pants
	subtype_path = /datum/gear/uniform/pants

/datum/gear/uniform/pants/bluejeans
	display_name = "синие джинсы"
	path = /obj/item/clothing/under/pants/jeans

/datum/gear/uniform/pants/classicjeans
	display_name = "классические синие джинсы"
	path = /obj/item/clothing/under/pants/classicjeans

/datum/gear/uniform/pants/mustangjeans
	display_name = "мустанговые джинсы"
	path = /obj/item/clothing/under/pants/mustangjeans

/datum/gear/uniform/pants/youngfolksjeans
	display_name = "тёмно-синие джинсы"
	path = /obj/item/clothing/under/pants/youngfolksjeans

/datum/gear/uniform/pants/blackjeans
	display_name = "чёрные джинсы"
	path = /obj/item/clothing/under/pants/blackjeans

/datum/gear/uniform/pants/white
	display_name = "белые штаны"
	path = /obj/item/clothing/under/pants/white

/datum/gear/uniform/pants/red
	display_name = "красные штаны"
	path = /obj/item/clothing/under/pants/red

/datum/gear/uniform/pants/black
	display_name = "чёрные штаны"
	path = /obj/item/clothing/under/pants/black

/datum/gear/uniform/pants/tan
	display_name = "коричневые штаны"
	path = /obj/item/clothing/under/pants/tan

/datum/gear/uniform/pants/track
	display_name = "спортивные штаны"
	path = /obj/item/clothing/under/pants/track

/datum/gear/uniform/pants/khaki
	display_name = "камуфляжные штаны"
	path = /obj/item/clothing/under/pants/khaki

/datum/gear/uniform/pants/camo
	display_name = "камуфляжные штаны 2"
	path = /obj/item/clothing/under/pants/camo

//SKIRTS

/datum/gear/uniform/skirt
	subtype_path = /datum/gear/uniform/skirt
	cost = 60

/datum/gear/uniform/skirt/blue
	display_name = "синяя юбка"
	path = /obj/item/clothing/under/dress/skirt/blue

/datum/gear/uniform/skirt/purple
	display_name = "фиолетовая юбка"
	path = /obj/item/clothing/under/dress/skirt/purple

/datum/gear/uniform/skirt/red
	display_name = "красная юбка"
	path = /obj/item/clothing/under/dress/skirt/red

/datum/gear/uniform/skirt/plaid_skirt
	display_name = "КБ юбка"
	path = /obj/item/clothing/under/dress/skirt/plaid

/datum/gear/uniform/skirt/plaid_skirt/blue
	display_name = "СБ юбка"
	path = /obj/item/clothing/under/dress/skirt/plaid/blue

/datum/gear/uniform/skirt/plaid_skirt/purple
	display_name = "ФБ юбка"
	path = /obj/item/clothing/under/dress/skirt/plaid/purple

/datum/gear/uniform/skirt/plaid_skirt/green
	display_name = "ЗБ юбка"
	path = /obj/item/clothing/under/dress/skirt/plaid/green

//SUITS & SUIT JACKETS

/datum/gear/uniform/suit
	subtype_path = /datum/gear/uniform/suit
	cost = 150

/datum/gear/uniform/suit/suit_jacket
	subtype_path = /datum/gear/uniform/suit/suit_jacket

/datum/gear/uniform/suit/suit_jacket/black
	display_name = "чёрный костюм"
	path = /obj/item/clothing/under/suit/black

/datum/gear/uniform/suit/suit_jacket/really_black
	display_name = "деловой костюм (мужской)"
	path = /obj/item/clothing/under/suit/black_really

/datum/gear/uniform/suit/suit_jacket/female
	display_name = "деловой костюмч (женский)"
	path = /obj/item/clothing/under/suit/black/female

/datum/gear/uniform/suit/suit_jacket/green
	display_name = "зелёный костюм"
	path = /obj/item/clothing/under/suit/green

/datum/gear/uniform/suit/suit_jacket/red
	display_name = "красный костюм"
	path = /obj/item/clothing/under/suit/red

/datum/gear/uniform/suit/suit_jacket/charcoal
	display_name = "угольный костюм"
	path = /obj/item/clothing/under/suit/charcoal

/datum/gear/uniform/suit/suit_jacket/navy
	display_name = "темно-синий костюм"
	path = /obj/item/clothing/under/suit/navy

/datum/gear/uniform/suit/suit_jacket/burgundy
	display_name = "бордовый костюм"
	path = /obj/item/clothing/under/suit/burgundy

/datum/gear/uniform/suit/suit_jacket/checkered
	display_name = "клетчатый костюм"
	path = /obj/item/clothing/under/suit/checkered

/datum/gear/uniform/suit/suit_jacket/tan
	display_name = "деловой костюм"
	path = /obj/item/clothing/under/suit/tan

/datum/gear/uniform/suit/suit_jacket/white
	display_name = "белый костюм"
	path = /obj/item/clothing/under/suit/white

/datum/gear/uniform/suit/scratch
	display_name =  "белый костюм с зеленью"
	path = /obj/item/clothing/under/suit/white_on_white

/datum/gear/uniform/suit/sl_suit
	display_name = "представительный костюм"
	path = /obj/item/clothing/under/suit/sl

//MEME & COSTUME ITEMS

/datum/gear/uniform/misc
	subtype_path = /datum/gear/uniform/misc
	cost = 100

/datum/gear/uniform/misc/jabroni
	display_name = "кожаный костюм БДСМ"
	path = /obj/item/clothing/under/costume/jabroni
	cost = 500

/datum/gear/uniform/misc/soviet
	display_name = "советская военная форма"
	path = /obj/item/clothing/under/costume/soviet

/datum/gear/uniform/misc/pirate
	display_name = "пиратская матроска"
	path = /obj/item/clothing/under/costume/pirate

/datum/gear/uniform/misc/sailor
	display_name = "униформа моряка"
	path = /obj/item/clothing/under/costume/sailor

//RANK SUBTYPE

/datum/gear/uniform/rank
	subtype_path = /datum/gear/uniform/rank
	cost = 50

//ASSISTANTS FORMALS


/datum/gear/uniform/rank/assistant
	subtype_path = /datum/gear/uniform/rank/assistant
	allowed_roles = list(JOB_ASSISTANT)

/datum/gear/uniform/rank/assistant/formal
	display_name = "настоящая форма ассистента"
	path = /obj/item/clothing/under/misc/assistantformal
	cost = 50

/datum/gear/uniform/rank/assistant/vice
	display_name = "комбинезон заместителя офицера"
	path = /obj/item/clothing/under/misc/vice_officer
	cost = 100

//CARGO ALT UNIS

/datum/gear/uniform/rank/cargo
	subtype_path = /datum/gear/uniform/rank/cargo
	allowed_roles = list(JOB_QUARTERMASTER, JOB_CARGO_TECHNICIAN, JOB_SHAFT_MINER, JOB_HUNTER)

/datum/gear/uniform/rank/cargo/overalls
	display_name = "рабочий комбинезон"
	path = /obj/item/clothing/under/misc/overalls
	cost = 50
	allowed_roles = list(JOB_CHIEF_ENGINEER, JOB_STATION_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN)

/datum/gear/uniform/rank/cargo/mining_classic
	display_name = "старый комбинезон шахтера"
	description = "Пурпурный, грязный комбинезон. Стандартная одежда шахтера шахт NanoTrasen, когда Лаваленд еще не был открыт и использован для плазмы."
	path = /obj/item/clothing/under/rank/cargo/miner
	allowed_roles = list (JOB_SHAFT_MINER, JOB_HUNTER)
	cost = 100


//MEDICAL ALT UNIS

/datum/gear/uniform/rank/medical
	subtype_path = /datum/gear/uniform/rank/medical
	allowed_roles = list(JOB_PARAMEDIC, JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER)
	cost = 50

/datum/gear/uniform/rank/medical/scrubs_blue
	display_name = "синий медицинский халат"
	path = /obj/item/clothing/under/rank/medical/doctor/blue

/datum/gear/uniform/rank/medical/scrubs_green
	display_name = "зелёный медицинский халат"
	path = /obj/item/clothing/under/rank/medical/doctor/green

/datum/gear/uniform/rank/medical/scrubs_purple
	display_name = "фиолетовый медицинский халат"
	path = /obj/item/clothing/under/rank/medical/doctor/purple


//ENGINEERING ALT UNIS

/datum/gear/uniform/rank/engineering
	subtype_path = /datum/gear/uniform/rank/engineering
	allowed_roles = list(JOB_CHIEF_ENGINEER, JOB_STATION_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN, JOB_MECHANIC)

/datum/gear/uniform/rank/engineering/hazard
	display_name = "комбинезон инженера"
	path = /obj/item/clothing/under/rank/engineering/engineer/hazard


//RND

/datum/gear/uniform/rank/science
	allowed_roles = list(JOB_SCIENTIST, JOB_ROBOTICIST, JOB_RESEARCH_DIRECTOR)




//SECURITY ALT UNIS

/datum/gear/uniform/sharovari
	display_name = "шаровары"
	path = /obj/item/clothing/under/costume/sharovari
	cost = 500
/datum/gear/uniform/wizgirl
	display_name = "костюм волшебницы"
	path = /obj/item/clothing/under/costume/wizgirl
	cost = 250

/datum/gear/uniform/kimono
	display_name = "кимоно"
	path = /obj/item/clothing/under/costume/kimono
	cost = 300

/datum/gear/uniform/kimono/dark
	display_name = "тёмное кимоно"
	path = /obj/item/clothing/under/costume/kimono/dark

/datum/gear/uniform/kimono/sakura
	display_name = "кимоно цвета сакуры"
	path = /obj/item/clothing/under/costume/kimono/sakura

/datum/gear/uniform/kimono/fancy
	display_name = "красивое кимоно"
	path = /obj/item/clothing/under/costume/kimono/fancy

/datum/gear/uniform/kamishimo
	display_name = "камишимо"
	path = /obj/item/clothing/under/costume/kamishimo
	cost = 450

/datum/gear/uniform/bathrobe
	display_name = "халат"
	path = /obj/item/clothing/under/costume/bathrobe
	cost = 300

//

/datum/gear/uniform/chronos
	display_name = "Военный костюм Новой Мекки"
	path = /obj/item/clothing/under/chronos
	cost = 650
