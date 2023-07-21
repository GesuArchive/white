/datum/bounty/item/medical/heart
	name = "Сердце"
	description = "Командир Джонсон находится в критическом состоянии после очередного сердечного приступа. Врачи говорят, что ему нужно новое сердце. Отправьте одно, быстро!"
	reward = CARGO_CRATE_VALUE * 100
	wanted_types = list(/obj/item/organ/heart)
	exclude_types = list(/obj/item/organ/heart/cybernetic)//Excluding tier 1s, no cheesing.
	special_include_types = list(/obj/item/organ/heart/cybernetic/tier2, /obj/item/organ/heart/cybernetic/tier3)

/datum/bounty/item/medical/lung
	name = "Лёгкие"
	description = "Недавний взрыв на ЦК оставил множество сотрудников с проколотыми легкими. Отправка запасных лёгких будет вознаграждена."
	reward = CARGO_CRATE_VALUE * 100
	required_count = 3
	wanted_types = list(/obj/item/organ/lungs)
	exclude_types = list(/obj/item/organ/lungs/cybernetic)//As above, for all printable organs.
	special_include_types = list(/obj/item/organ/lungs/cybernetic/tier2, /obj/item/organ/lungs/cybernetic/tier3)

/datum/bounty/item/medical/appendix
	name = "Аппендицит"
	description = "Шеф-повар Гибб Центрального командования хочет приготовить еду, используя особый деликатес: аппендицит. Если вы отправите один, он вам заплатит."
	reward = CARGO_CRATE_VALUE * 150
	wanted_types = list(/obj/item/organ/appendix)

/datum/bounty/item/medical/ears
	name = "Уши"
	description = "Несколько сотрудников на Станции 12 остались глухими из-за несанкционированной клоунады. Отправь им новые уши."
	reward = CARGO_CRATE_VALUE * 70
	required_count = 3
	wanted_types = list(/obj/item/organ/ears)
	exclude_types = list(/obj/item/organ/ears/cybernetic)
	special_include_types = list(/obj/item/organ/ears/cybernetic/upgraded)

/datum/bounty/item/medical/liver
	name = "Печень"
	description = "Несколько высокопоставленных дипломатов ЦК были госпитализированы с печеночной недостаточностью после недавней встречи с послами стран Третьего Советского Союза. Помоги нам, ладно?"
	reward = CARGO_CRATE_VALUE * 60
	required_count = 3
	wanted_types = list(/obj/item/organ/liver)
	exclude_types = list(/obj/item/organ/liver/cybernetic)
	special_include_types = list(/obj/item/organ/liver/cybernetic/tier2, /obj/item/organ/liver/cybernetic/tier3)

/datum/bounty/item/medical/eye
	name = "Глаза"
	description = "Директор по исследованиям станции 5 Виллем запрашивает несколько пар глаз. Не задавайте вопросы, просто отправляйте их."
	reward = CARGO_CRATE_VALUE * 55
	required_count = 3
	wanted_types = list(/obj/item/organ/eyes)
	exclude_types = list(/obj/item/organ/eyes/robotic)

/datum/bounty/item/medical/tongue
	name = "Язык"
	description = "Недавнее нападение мимов экстремистов оставило персонал на Станции 23 безмолвным. Отправьте несколько запасных языков."
	reward = CARGO_CRATE_VALUE * 70
	required_count = 3
	wanted_types = list(/obj/item/organ/tongue)

/datum/bounty/item/medical/lizard_tail
	name = "Хвост ящерицы"
	description = "Федерация Волшебников закончила поставку для НаноТрейзен хвостов ящериц. Пока ЦК ведёт переговоры с волшебниками, может ли станция обеспечить нас хотя бы одним хвостом?"
	reward = CARGO_CRATE_VALUE * 200 // Да.
	wanted_types = list(/obj/item/organ/tail/lizard)

/datum/bounty/item/medical/cat_tail
	name = "Хвост кошки"
	description = "Центральное командование исчерпало запас хвостиков. Можете ли вы отправить хвост кошки, чтобы помочь им?"
	reward = CARGO_CRATE_VALUE * 190
	wanted_types = list(/obj/item/organ/tail/cat)

/datum/bounty/item/medical/chainsaw
	name = "Циркулярная пила"
	description = "У СМО в ЦК проблемы с операцией на големамах. Она просит одну циркулярную пилу или бензопилу, пожалуйста."
	reward = CARGO_CRATE_VALUE * 70
	wanted_types = list(/obj/item/chainsaw,
						/obj/item/circular_saw)

/datum/bounty/item/medical/tail_whip //Like the cat tail bounties, with more processing.
	name = "Девятихвостый кнут"
	description = "Коммандер Джексон ищет прекрасное дополнение к своей коллекции экзотического оружия. Она щедро вознаградит вас за кнут из ящера или кота."
	reward = CARGO_CRATE_VALUE * 310
	wanted_types = list(/obj/item/melee/chainofcommand/tailwhip)

/datum/bounty/item/medical/surgerycomp
	name = "Операционный компьютер"
	description = "После очередного странного инцидента с взрывом бомбы на нашем ежегодном сырном фестивале в ЦентКоме у нас уже собралась огромная группа раненых. Пожалуйста, пришлите нам новый хирургический компьютер, если это возможно."
	reward = CARGO_CRATE_VALUE * 140
	wanted_types = list(/obj/machinery/computer/operating, /obj/item/circuitboard/computer/operating)

/datum/bounty/item/medical/surgerytable
	name = "Операционный стол"
	description = "После недавнего притока раненых членов экипажа после взрыва мы поняли, что на операции в полевых условиях протекают слишком медленно. Серебряные операционные столы могут помочь, пришлите нам один для использования."
	reward = CARGO_CRATE_VALUE * 100
	wanted_types = list(/obj/structure/table/optable, /obj/item/optable)
