//miscellaneous spacesuits
/*
Contains:
	Captain's spacesuit
	Death squad's hardsuit
	SWAT suit
	Officer's beret/spacesuit
	NASA Voidsuit
	Father Christmas' magical clothes
	Pirate's spacesuit
	ERT hardsuit: command, sec, engi, med, janitor
	EVA spacesuit
	Freedom's spacesuit (freedom from vacuum's oppression)
	Carp hardsuit
	Bounty hunter hardsuit
	Blackmarket combat medic hardsuit
*/

	//Death squad armored space suits, not hardsuits!
/obj/item/clothing/suit/space/hardsuit/deathsquad
	name = "MK.III Скафандр Спецназа"
	desc = "Прототип разработанный чтобы заменить устаревший MK.II Спецназа. На основе оптимизированной модели MK.II традиционные керамические и графеновые пластины были заменены на пласталь, предоставляя превосходную защиту от большинства угроз. На спине есть место для устройства энергетической проекции."
	icon_state = "deathsquad"
	inhand_icon_state = "swat_suit"
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/kitchen/knife/combat)
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 60, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 20)
	strip_delay = 130
	slowdown = 0.1
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/deathsquad
	dog_fashion = /datum/dog_fashion/back/deathsquad
	cell = /obj/item/stock_parts/cell/bluespace

/obj/item/clothing/head/helmet/space/hardsuit/deathsquad
	name = "MK.III шлем спецназа"
	desc = "Продвинутый тактический космичесий шлем."
	icon_state = "deathsquad"
	inhand_icon_state = "deathsquad"
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 60, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 20)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	actions_types = list()

/obj/item/clothing/head/helmet/space/hardsuit/deathsquad/attack_self(mob/user)
	return

/obj/item/clothing/head/helmet/space/beret
	name = "офицерский космоберет"
	desc = "Бронированный берет, обычно используемый офицерами спецопераций. Использует продвинутую технологию силового поля, что защищает голову от космоса."
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	icon_state = "beret_badge"
	greyscale_colors = "#972A2A#F2F2F2"
	dynamic_hair_suffix = "+generic"
	dynamic_fhair_suffix = "+generic"
	flags_inv = 0
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 60, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 15)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF

	//NEW SWAT suit
/obj/item/clothing/suit/space/swat
	name = "MK.I Скафандр Спецназа"
	desc = "Устаревший тактический скафандр, впервые разработанный совместными усилиями между ныне несуществующей IS-ERI и NanoTrasen в 20XX для проведения операций в космосе. Проверенный временем экземпляр, в нем очень тяжело ходить, однако это компенсируется надежной защитой от различных угроз!"
	icon_state = "heavy"
	inhand_icon_state = "swat_suit"
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/kitchen/knife/combat)
	armor = list(MELEE = 40, BULLET = 30, LASER = 30,ENERGY = 40, BOMB = 50, BIO = 90, RAD = 20, FIRE = 100, ACID = 100, WOUND = 15)
	strip_delay = 120
	slowdown = 1
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/space/officer
	name = "офицерская куртка"
	desc = "Бронированная, космонепроницаемая куртка используемая в спецоперациях."
	icon_state = "detective"
	inhand_icon_state = "det_suit"
	blood_overlay_type = "coat"
	slowdown = 0
	flags_inv = 0
	w_class = WEIGHT_CLASS_NORMAL
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/tank/jetpack)
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 60, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 15)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF

	//NASA Voidsuit
/obj/item/clothing/head/helmet/space/nasavoid
	name = "космический шлем НАСА"
	desc = "Старый темно-красный шлем от скафандра, разработанный отделением ЦентКом НАСА."
	icon_state = "void"
	inhand_icon_state = "void"

/obj/item/clothing/suit/space/nasavoid
	name = "скафандр НАСА"
	icon_state = "void"
	inhand_icon_state = "void"
	desc = "Старый темно-красный скафандра, разработанный отделением ЦентКом НАСА."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/multitool)

/obj/item/clothing/head/helmet/space/nasavoid/old
	name = "старый космический шлем"
	desc = "Темно-красный шлем скафандра ЦентКом. Несмотря на то, что он уже старый и пыльный, он все еще может выполнять свою работу."
	icon_state = "void"
	inhand_icon_state = "void"

/obj/item/clothing/suit/space/nasavoid/old
	name = "старый скафандр"
	icon_state = "void"
	inhand_icon_state = "void"
	desc = "Темно-красный космический костюм ЦентКом. Морально устарел и покрылся пылью, в нём весьма трудно передвигаться."
	slowdown = 4
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/multitool)

	//Space santa outfit suit
/obj/item/clothing/head/helmet/space/santahat
	name = "Шапка Санты"
	desc = "Хо хо хо. Счастлииивого рождества!"
	icon_state = "santahat"
	flags_cover = HEADCOVERSEYES

	dog_fashion = /datum/dog_fashion/head/santa

/obj/item/clothing/suit/space/santa
	name = "Костюм Санты"
	desc = "Праздничный!"
	icon_state = "santa"
	inhand_icon_state = "santa"
	slowdown = 0
	allowed = list(/obj/item) //for stuffing exta special presents


	//Space pirate outfit
/obj/item/clothing/head/helmet/space/pirate
	name = "модифицированный космический шлем"
	desc = "Йарр."
	icon_state = "spacepirate"
	inhand_icon_state = "spacepiratehelmet"
	armor = list(MELEE = 30, BULLET = 50, LASER = 30,ENERGY = 40, BOMB = 30, BIO = 30, RAD = 30, FIRE = 60, ACID = 75)
	strip_delay = 40
	equip_delay_other = 20

/obj/item/clothing/head/helmet/space/pirate/bandana
	icon_state = "spacebandana"
	inhand_icon_state = "spacepiratehelmet"

/obj/item/clothing/suit/space/pirate
	name = "модифицированный скафандр"
	desc = "Йарр."
	icon_state = "spacepirate"
	w_class = WEIGHT_CLASS_NORMAL
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/melee/energy/sword/pirate, /obj/item/clothing/glasses/eyepatch, /obj/item/reagent_containers/food/drinks/bottle/rum)
	slowdown = 0
	armor = list(MELEE = 30, BULLET = 50, LASER = 30,ENERGY = 40, BOMB = 30, BIO = 30, RAD = 30, FIRE = 60, ACID = 75)
	strip_delay = 40
	equip_delay_other = 20

	//Emergency Response Team suits
/obj/item/clothing/head/helmet/space/hardsuit/ert
	name = "командирский космический шлем ЕРТ"
	desc = "Встроенный шлем защитного костюма ЕРТ, этот шлем имеет синюю подсветку."
	icon_state = "hardsuit0-ert_commander"
	inhand_icon_state = "hardsuit0-ert_commander"
	hardsuit_type = "ert_commander"
	armor = list(MELEE = 65, BULLET = 50, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 100, RAD = 100, FIRE = 80, ACID = 80)
	strip_delay = 130
	light_range = 7
	resistance_flags = FIRE_PROOF
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/head/helmet/space/hardsuit/ert/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, LOCKED_HELMET_TRAIT)

/obj/item/clothing/suit/space/hardsuit/ert
	name = "командирский скафандр ЕРТ"
	desc = "Высококачественный современный скафандр с синими вставками. Обеспечивает превосходную защиту от всех вредных воздействий окружающей среды."
	icon_state = "ert_command"
	inhand_icon_state = "ert_command"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/tank/jetpack)
	armor = list(MELEE = 65, BULLET = 50, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 100, RAD = 100, FIRE = 80, ACID = 80)
	slowdown = 0
	strip_delay = 130
	resistance_flags = FIRE_PROOF
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	cell = /obj/item/stock_parts/cell/bluespace

// ERT suit's gets EMP Protection
/obj/item/clothing/suit/space/hardsuit/ert/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_CONTENTS)

	//ERT Security
/obj/item/clothing/head/helmet/space/hardsuit/ert/sec
	name = "штурмовой космический шлем ЕРТ"
	desc = "Встроенный шлем защитного скафандра ЕРТ с красной маркировкой."
	icon_state = "hardsuit0-ert_security"
	inhand_icon_state = "hardsuit0-ert_security"
	hardsuit_type = "ert_security"

/obj/item/clothing/suit/space/hardsuit/ert/sec
	name = "штурмовой скафандр ЕРТ"
	desc = "Высококачественный современный скафандр с красными вставками. Обеспечивает превосходную защиту от всех вредных воздействий окружающей среды."
	icon_state = "ert_security"
	inhand_icon_state = "ert_security"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/sec

	//ERT Engineering
/obj/item/clothing/head/helmet/space/hardsuit/ert/engi
	name = "инженерный космический шлем ЕРТ"
	desc = "Встроенный шлем защитного скафандра ЕРТ с оранжевой маркировкой."
	icon_state = "hardsuit0-ert_engineer"
	inhand_icon_state = "hardsuit0-ert_engineer"
	hardsuit_type = "ert_engineer"

/obj/item/clothing/suit/space/hardsuit/ert/engi
	name = "инженерный скафандр ЕРТ"
	desc = "Высококачественный современный скафандр с оранжевыми вставками. Обеспечивает превосходную защиту от всех вредных воздействий окружающей среды."
	icon_state = "ert_engineer"
	inhand_icon_state = "ert_engineer"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/engi

	//ERT Medical
/obj/item/clothing/head/helmet/space/hardsuit/ert/med
	name = "медицинский космический шлем ЕРТ"
	desc = "Встроенный шлем защитного скафандра ЕРТ с белой маркировкой."
	icon_state = "hardsuit0-ert_medical"
	inhand_icon_state = "hardsuit0-ert_medical"
	hardsuit_type = "ert_medical"

/obj/item/clothing/suit/space/hardsuit/ert/med
	name = "медицинский скафандр ЕРТ"
	desc = "Высококачественный современный скафандр с белыми вставками. Обеспечивает превосходную защиту от всех вредных воздействий окружающей среды."
	icon_state = "ert_medical"
	inhand_icon_state = "ert_medical"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/med

	//ERT Janitor
/obj/item/clothing/head/helmet/space/hardsuit/ert/jani
	name = "санитарный космический шлем ЕРТ"
	desc = "Встроенный шлем защитного скафандра ЕРТ с фиолетовой маркировкой."
	icon_state = "hardsuit0-ert_janitor"
	inhand_icon_state = "hardsuit0-ert_janitor"
	hardsuit_type = "ert_janitor"

/obj/item/clothing/suit/space/hardsuit/ert/jani
	name = "санитарный скафандр ЕРТ"
	desc = "Высококачественный современный скафандр с фиолетовыми вставками. Обеспечивает превосходную защиту от всех вредных воздействий окружающей среды."
	icon_state = "ert_janitor"
	inhand_icon_state = "ert_janitor"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/jani
	allowed = list(/obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/storage/bag/trash, /obj/item/melee/flyswatter, /obj/item/mop, /obj/item/holosign_creator, /obj/item/reagent_containers/glass/bucket, /obj/item/reagent_containers/spray/chemsprayer/janitor)

	//ERT Clown
/obj/item/clothing/head/helmet/space/hardsuit/ert/clown
	name = "клоунский космический шлем ЕРТ"
	desc = "Встроенный шлем защитного скафандра ЕРТ с радужной маркировкой."
	icon_state = "hardsuit0-ert_clown"
	inhand_icon_state = "hardsuit0-ert_clown"
	hardsuit_type = "ert_clown"

/obj/item/clothing/suit/space/hardsuit/ert/clown
	name = "санитарный скафандр ЕРТ"
	desc = "Высококачественный современный скафандр с фиолетовыми вставками. Обеспечивает превосходную защиту от всех вредных воздействий окружающей среды. Не обеспечивает защиту от разъяренного экипажа."
	icon_state = "ert_clown"
	inhand_icon_state = "ert_clown"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/clown
	allowed = list(/obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/bikehorn, /obj/item/instrument, /obj/item/food/grown/banana, /obj/item/grown/bananapeel)

/obj/item/clothing/suit/space/eva
	name = "скафандр"
	desc = "Легкий космический костюм, обладающий базовой способностью защищать владельца от космического вакуума во время чрезвычайных ситуаций."
	icon_state = "space"
	inhand_icon_state = "s_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 100, RAD = 20, FIRE = 50, ACID = 65)

/obj/item/clothing/head/helmet/space/eva
	name = "космический шлем"
	desc = "Легкий космический шлем, обладающий базовой способностью защищать владельца от космического вакуума во время чрезвычайных ситуаций."
	icon_state = "space"
	inhand_icon_state = "space"
	flash_protect = FLASH_PROTECTION_NONE
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 100, RAD = 20, FIRE = 50, ACID = 65)

/obj/item/clothing/head/helmet/space/freedom
	name = "космический шлем \"Орлёнок\""
	desc = "Усовершенствованный, герметичный шлем. Похоже, он создан по образу орла старого света."
	icon_state = "griffinhat"
	inhand_icon_state = "griffinhat"
	armor = list(MELEE = 20, BULLET = 40, LASER = 30, ENERGY = 40, BOMB = 100, BIO = 100, RAD = 100, FIRE = 80, ACID = 80)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = ACID_PROOF | FIRE_PROOF

/obj/item/clothing/suit/space/freedom
	name = "скафандр \"Орлёнок\""
	desc = "Усовершенствованный легкий костюм, изготовленный из смеси синтетических перьев и прочного материала. Кобура для пистолета, по-видимому, встроена в костюм, а крылья, по-видимому, находятся в режиме \"свободы\"."
	icon_state = "freedom"
	inhand_icon_state = "freedom"
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/tank/jetpack)
	armor = list(MELEE = 20, BULLET = 40, LASER = 30,ENERGY = 40, BOMB = 100, BIO = 100, RAD = 100, FIRE = 80, ACID = 80)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = ACID_PROOF | FIRE_PROOF
	slowdown = 0

//Carpsuit, bestsuit, lovesuit
/obj/item/clothing/head/helmet/space/hardsuit/carp
	name = "космический шлем \"Космический карп\""
	desc = "Кругленький и выглядит он как голова космического карпа. Пахнет соответствующе."
	icon_state = "carp_helm"
	inhand_icon_state = "syndicate"
	armor = list(MELEE = -20, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 75, FIRE = 60, ACID = 75)	//As whimpy as a space carp
	light_system = NO_LIGHT_SUPPORT
	light_range = 0 //luminosity when on
	actions_types = list()
	flags_inv = HIDEEARS|HIDEHAIR|HIDEFACIALHAIR //facial hair will clip with the helm, this'll need a dynamic_fhair_suffix at some point.

/obj/item/clothing/head/helmet/space/hardsuit/carp/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, LOCKED_HELMET_TRAIT)

/obj/item/clothing/suit/space/hardsuit/carp
	name = "скафандр \"Космический карп\""
	desc = "Тонкий скафандр сомнительной технологии. Решение о превосходстве внешнего вида над функционалом сыграло с ним злую шутку - данный скафандр пусть и не замедляет владельца, но вот в ближнем бою оный будет страдать даже сильнее чем если бы его били в исподнем."
	icon_state = "carp_suit"
	inhand_icon_state = "space_suit_syndicate"
	slowdown = 0	//Space carp magic, never stop believing
	armor = list(MELEE = -20, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 75, FIRE = 60, ACID = 75) //As whimpy whimpy whoo
	allowed = list(/obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/gun/ballistic/rifle/boltaction/harpoon)	//I'm giving you a hint here
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/carp

/obj/item/clothing/head/helmet/space/hardsuit/carp/equipped(mob/living/carbon/human/user, slot)
	..()
	if (slot == ITEM_SLOT_HEAD)
		user.faction |= "carp"

/obj/item/clothing/head/helmet/space/hardsuit/carp/dropped(mob/living/carbon/human/user)
	..()
	if (user.head == src)
		user.faction -= "carp"

/obj/item/clothing/suit/space/hardsuit/carp/old
	name = "потрепанный скафандр \"Космический карп\""
	desc = "Он покрыт следами укусов и царапинами, но, похоже, все еще вполне работоспособен."
	slowdown = 1

/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal
	name = "паранормальный космический шлем ЕРТ"
	desc = "Шлем, который носят те, кто зарабатывает на жизнь борьбой с паранормальными угрозами."
	icon_state = "hardsuit0-prt"
	inhand_icon_state = "hardsuit0-prt"
	hardsuit_type = "prt"
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	actions_types = list()
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/space/hardsuit/ert/paranormal
	name = "паранормальный скафандр ЕРТ"
	desc = "В этот костюм встроены мощные защитные устройства, защищающие пользователя от всевозможных паранормальных угроз."
	icon_state = "knight_grey"
	inhand_icon_state = "knight_grey"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/space/hardsuit/ert/paranormal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, TRUE, ITEM_SLOT_OCLOTHING)

/obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor
	name = "скафандр инквизиции"
	icon_state = "hardsuit-inq"
	inhand_icon_state = "hardsuit-inq"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/inquisitor

/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/inquisitor
	name = "космический шлем инквизиции"
	icon_state = "hardsuit0-inq"
	inhand_icon_state = "hardsuit0-inq"
	hardsuit_type = "inq"

/obj/item/clothing/suit/space/hardsuit/berserker
	name = "скафандр берсерка"
	desc = "Голоса исходящие от скафандра, способны свести пользователя с ума вогнав в кровавое безумие."
	icon_state = "hardsuit-berserker"
	inhand_icon_state = "hardsuit-berserker"
	slowdown = 0
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/berserker
	armor = list(MELEE = 30, BULLET = 30, LASER = 10, ENERGY = 20, BOMB = 50, BIO = 100, RAD = 10, FIRE = 100, ACID = 100)
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/pickaxe, /obj/item/spear, /obj/item/organ/regenerative_core/legion, /obj/item/kitchen/knife, /obj/item/kinetic_crusher, /obj/item/resonator, /obj/item/melee/cleaving_saw)



/obj/item/clothing/suit/space/hardsuit/berserker/RemoveHelmet()
	var/obj/item/clothing/head/helmet/space/hardsuit/berserker/helm = helmet
	if(helm?.berserk_active)
		return
	return ..()

#define MAX_BERSERK_CHARGE 100
#define PROJECTILE_HIT_MULTIPLIER 1.5
#define DAMAGE_TO_CHARGE_SCALE 0.75
#define CHARGE_DRAINED_PER_SECOND 5
#define BERSERK_MELEE_ARMOR_ADDED 50
#define BERSERK_ATTACK_SPEED_MODIFIER 0.25

/obj/item/clothing/head/helmet/space/hardsuit/berserker
	name = "шлем берсерка"
	desc = "Даже если смотреть в глаза этому шлему, быстро начинаешь осознавать свою ничтожность."
	icon_state = "hardsuit0-berserker"
	inhand_icon_state = "hardsuit0-berserker"
	hardsuit_type = "berserker"
	armor = list(MELEE = 30, BULLET = 30, LASER = 10, ENERGY = 20, BOMB = 50, BIO = 100, RAD = 10, FIRE = 100, ACID = 100)
	actions_types = list(/datum/action/item_action/berserk_mode)
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	/// Current charge of berserk, goes from 0 to 100
	var/berserk_charge = 0
	/// Status of berserk
	var/berserk_active = FALSE

/obj/item/clothing/head/helmet/space/hardsuit/berserker/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, LOCKED_HELMET_TRAIT)

/obj/item/clothing/head/helmet/space/hardsuit/berserker/examine()
	. = ..()
	. += span_notice("<hr>Заряд берсерка [berserk_charge]%.")

/obj/item/clothing/head/helmet/space/hardsuit/berserker/process(delta_time)
	. = ..()
	if(berserk_active)
		berserk_charge = clamp(berserk_charge - CHARGE_DRAINED_PER_SECOND * delta_time, 0, MAX_BERSERK_CHARGE)
	if(!berserk_charge)
		if(ishuman(loc))
			end_berserk(loc)

/obj/item/clothing/head/helmet/space/hardsuit/berserker/dropped(mob/user)
	. = ..()
	end_berserk(user)

/obj/item/clothing/head/helmet/space/hardsuit/berserker/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(berserk_active)
		return
	var/berserk_value = damage * DAMAGE_TO_CHARGE_SCALE
	if(attack_type == PROJECTILE_ATTACK)
		berserk_value *= PROJECTILE_HIT_MULTIPLIER
	berserk_charge = clamp(round(berserk_charge + berserk_value), 0, MAX_BERSERK_CHARGE)
	if(berserk_charge >= MAX_BERSERK_CHARGE)
		to_chat(owner, span_notice("Режим берсерка заряжен."))
		balloon_alert(owner, "берсерк готов")

/obj/item/clothing/head/helmet/space/hardsuit/berserker/IsReflect()
	if(berserk_active)
		return TRUE

/// Starts berserk, giving the wearer 50 melee armor, doubled attacking speed, NOGUNS trait, adding a color and giving them the berserk movespeed modifier
/obj/item/clothing/head/helmet/space/hardsuit/berserker/proc/berserk_mode(mob/living/carbon/human/user)
	to_chat(user, span_warning("ВХОЖУ В РЕЖИМ БЕРСЕРКА!"))
	playsound(user, 'sound/magic/staff_healing.ogg', 50)
	user.add_movespeed_modifier(/datum/movespeed_modifier/berserk)
	user.physiology.armor.melee += BERSERK_MELEE_ARMOR_ADDED
	user.next_move_modifier *= BERSERK_ATTACK_SPEED_MODIFIER
	user.add_atom_colour(COLOR_BUBBLEGUM_RED, TEMPORARY_COLOUR_PRIORITY)
	ADD_TRAIT(user, TRAIT_NOGUNS, BERSERK_TRAIT)
	ADD_TRAIT(src, TRAIT_NODROP, BERSERK_TRAIT)
	berserk_active = TRUE

/// Ends berserk, reverting the changes from the proc [berserk_mode]
/obj/item/clothing/head/helmet/space/hardsuit/berserker/proc/end_berserk(mob/living/carbon/human/user)
	if(!berserk_active)
		return
	to_chat(user, span_warning("Выхожу из режима берсера."))
	playsound(user, 'sound/magic/summonitems_generic.ogg', 50)
	user.remove_movespeed_modifier(/datum/movespeed_modifier/berserk)
	user.physiology.armor.melee -= BERSERK_MELEE_ARMOR_ADDED
	user.next_move_modifier /= BERSERK_ATTACK_SPEED_MODIFIER
	user.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, COLOR_BUBBLEGUM_RED)
	REMOVE_TRAIT(user, TRAIT_NOGUNS, BERSERK_TRAIT)
	REMOVE_TRAIT(src, TRAIT_NODROP, BERSERK_TRAIT)
	berserk_active = FALSE

#undef MAX_BERSERK_CHARGE
#undef PROJECTILE_HIT_MULTIPLIER
#undef DAMAGE_TO_CHARGE_SCALE
#undef CHARGE_DRAINED_PER_SECOND
#undef BERSERK_MELEE_ARMOR_ADDED
#undef BERSERK_ATTACK_SPEED_MODIFIER

/obj/item/clothing/head/helmet/space/fragile
	name = "аварийный космический шлем"
	desc = "Громоздкий герметичный шлем, предназначенный для защиты пользователя в чрезвычайных ситуациях. Сделан крайне не качественно, но вы должны радоваться одному факту его наличия."
	icon_state = "syndicate-helm-orange"
	inhand_icon_state = "syndicate-helm-orange"
	armor = list(MELEE = 5, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 10, FIRE = 0, ACID = 0)
	strip_delay = 65

/obj/item/clothing/suit/space/fragile
	name = "аварийный скафандр"
	desc = "Громоздкий герметичный костюм, предназначенный для защиты пользователя в чрезвычайных ситуациях. Сделан крайне не качественно, но вы должны радоваться одному факту его наличия."
	var/torn = FALSE
	icon_state = "syndicate-orange"
	inhand_icon_state = "syndicate-orange"
	slowdown = 2
	armor = list(MELEE = 5, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 10, FIRE = 0, ACID = 0)
	strip_delay = 65

/obj/item/clothing/suit/space/fragile/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!torn && prob(50))
		to_chat(owner, span_warning("[capitalize(src.name)] разрывается из-за повреждения, нарушая герметичность обшивки!"))
		clothing_flags &= ~STOPSPRESSUREDAMAGE
		name = "дырявый [src]."
		desc = "Громоздкий костюм, предназначенный для защиты пользователя во время чрезвычайных ситуаций, по крайней мере, до тех пор, пока кто-нибудь не проделает в костюме дыру."
		torn = TRUE
		playsound(loc, 'sound/weapons/slashmiss.ogg', 50, TRUE)
		playsound(loc, 'sound/effects/refill.ogg', 50, TRUE)

/obj/item/clothing/suit/space/hunter
	name = "скафандр охотников за головами"
	desc = "Доработанная версия костюм спецназа MK-II, модифицированная на дополнительную прочность и выносливость. Работает как скафандр, если вы сможете найти шлем."
	icon_state = "hunter"
	inhand_icon_state = "swat_suit"
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/kitchen/knife/combat)
	armor = list(MELEE = 60, BULLET = 40, LASER = 40, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100)
	strip_delay = 130
	resistance_flags = FIRE_PROOF | ACID_PROOF
	cell = /obj/item/stock_parts/cell/hyper

//We can either be alive monsters or dead monsters, you choose.
/obj/item/clothing/head/helmet/space/hardsuit/combatmedic
	name = "эпидемиологический космический шлем"
	desc = "Встроенный шлем медицинского скафандра с яркой светящейся маской для лица."
	icon_state = "hardsuit0-combatmedic"
	inhand_icon_state = "hardsuit0-combatmedic"
	armor = list(MELEE = 35, BULLET = 10, LASER = 20, ENERGY = 30, BOMB = 5, BIO = 100, RAD = 50, FIRE = 65, ACID = 75)
	hardsuit_type = "combatmedic"

/obj/item/clothing/suit/space/hardsuit/combatmedic
	name = "эпидемиологический скафандр"
	desc = "Стандартный защитный костюм для сотрудников по инфекционным заболеваниям перед формированием бригад скорой медицинской помощи. Эта модель имеет маркировку \"Спутник-Лайт\"."
	icon_state = "combatmedic"
	inhand_icon_state = "combatmedic"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/combatmedic
	armor = list(MELEE = 35, BULLET = 10, LASER = 20, ENERGY = 30, BOMB = 5, BIO = 100, RAD = 50, FIRE = 65, ACID = 75)
	allowed = list(/obj/item/gun, /obj/item/melee/baton, /obj/item/circular_saw, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/storage/box/pillbottles,\
	/obj/item/storage/firstaid, /obj/item/stack/medical/gauze, /obj/item/stack/medical/suture, /obj/item/stack/medical/mesh, /obj/item/storage/bag/chemistry)
