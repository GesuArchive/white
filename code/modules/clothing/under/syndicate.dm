/obj/item/clothing/under/syndicate
	name = "тактическая водолазка"
	desc = "Неописуемая и слегка подозрительно выглядящая водолазка с цифровыми камуфляжными штанами."
	icon_state = "syndicate"
	inhand_icon_state = "bl_suit"
	has_sensor = NO_SENSORS
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 40)
	alt_covers_chest = TRUE
	icon = 'icons/obj/clothing/under/syndicate.dmi'
	worn_icon = 'icons/mob/clothing/under/syndicate.dmi'

/obj/item/clothing/under/syndicate/skirt
	name = "тактическая юбка"
	desc = "Юбка для спецопераций."
	icon_state = "syndicate_skirt"
	inhand_icon_state = "bl_suit"
	has_sensor = NO_SENSORS
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 40)
	alt_covers_chest = TRUE
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/syndicate/bloodred
	name = "blood-red sneaksuit"
	desc = "It still counts as stealth if there are no witnesses."
	icon_state = "bloodred_pajamas"
	inhand_icon_state = "bl_suit"
	armor = list(MELEE = 10, BULLET = 10, LASER = 10,ENERGY = 10, BOMB = 0, BIO = 0, RAD = 10, FIRE = 50, ACID = 40)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	can_adjust = FALSE

/obj/item/clothing/under/syndicate/bloodred/sleepytime
	name = "blood-red pajamas"
	desc = "Do operatives dream of nuclear sheep?"
	icon_state = "bloodred_pajamas"
	inhand_icon_state = "bl_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 40)

/obj/item/clothing/under/syndicate/tacticool
	name = "тактическая водолазка"
	desc = "Просто взглянув на это, хочется купить SKS, пойти в лес и -оперативничать-."
	icon_state = "tactifool"
	inhand_icon_state = "bl_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 40)

/obj/item/clothing/under/syndicate/tacticool/skirt
	name = "тактическая юбка"
	desc = "Просто взглянув на это, хочется купить SKS, пойти в лес и -оперативничать-."
	icon_state = "tactifool_skirt"
	inhand_icon_state = "bl_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 40)
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/syndicate/sniper
	name = "тактический костюм"
	desc = "Тактическая водолазка с двойным швом, замаскированная под шелковый костюм гражданского уровня. Предназначен для самого деловитого оператора. Воротник действительно острый."
	icon = 'icons/obj/clothing/under/suits.dmi'
	icon_state = "really_black_suit"
	inhand_icon_state = "bl_suit"
	worn_icon = 'icons/mob/clothing/under/suits.dmi'
	can_adjust = FALSE

/obj/item/clothing/under/syndicate/camo
	name = "камуфляжная одежда"
	desc = "Зеленая военная камуфляжная форма."
	icon_state = "camogreen"
	inhand_icon_state = "g_suit"
	can_adjust = FALSE

/obj/item/clothing/under/syndicate/soviet
	name = "Ratnik 5 спорткостюм"
	desc = "Плохо переведенные этикетки говорят вам, чтобы очистить это в водке. Отлично подходит для танцев вприсядку."
	icon_state = "trackpants"
	can_adjust = FALSE
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	resistance_flags = NONE

/obj/item/clothing/under/syndicate/combat
	name = "боевая одежда"
	desc = "С костюмом на подкладке так много карманов, вы готовы к работе."
	icon_state = "syndicate_combat"
	can_adjust = FALSE

/obj/item/clothing/under/syndicate/rus_army
	name = "передовой военный спортивный костюм"
	desc = "Идеально для боевых действий."
	icon_state = "rus_under"
	can_adjust = FALSE
	armor = list(MELEE = 5, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	resistance_flags = NONE
