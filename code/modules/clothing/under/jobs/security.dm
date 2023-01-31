/*
 * Contains:
 *		Security
 *		Detective
 *		Navy uniforms
 */

/*
 * Security
 */

/obj/item/clothing/under/rank/security
	icon = 'icons/obj/clothing/under/security.dmi'
	worn_icon = 'icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/officer
	name = "комбинезон офицера"
	desc = "Тактический защитный комбинезон для офицеров в комплекте с ремнем безопасности NanoTrasen."
	icon_state = "rsecurity"
	inhand_icon_state = "r_suit"
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 30, ACID = 30, WOUND = 10)
	strip_delay = 50
	alt_covers_chest = TRUE
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/security/officer/grey
	name = "серый комбинезон офицера"
	desc = "Тактическая реликвия прошлых лет до того, как NanoTrasen решил, что покрасить костюмы в красный цвет дешевле, чем смывать кровь."
	icon_state = "security"
	inhand_icon_state = "gy_suit"

/obj/item/clothing/under/rank/security/officer/skirt
	name = "юбкомбез офицера"
	desc = "Защитный \"тактический\" комбинезон с юбкой вместо штанов."
	icon_state = "secskirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = NO_FEMALE_UNIFORM

/obj/item/clothing/under/rank/security/officer/blueshirt
	name = "голубая рубашка и галстук"
	desc = "I'm a little busy right now, Calhoun."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/officer/formal
	name = "костюм офицера"
	desc = "Новейшие модные костюмы для охраны."
	icon_state = "officerblueclothes"
	inhand_icon_state = "officerblueclothes"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/constable
	name = "constable outfit"
	desc = "A british looking outfit."
	icon_state = "constable"
	inhand_icon_state = "constable"
	can_adjust = FALSE
	custom_price = PAYCHECK_HARD

/obj/item/clothing/under/rank/security/warden
	name = "костюм офицера"
	desc = "Формальный защитный костюм для офицеров в комплекте с пряжкой на поясе NanoTrasen."
	icon_state = "rwarden"
	inhand_icon_state = "r_suit"
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 30, ACID = 30, WOUND = 10)
	strip_delay = 50
	alt_covers_chest = TRUE
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/security/warden/grey
	name = "серый костюм офицера"
	desc = "Классическая реликвия прошлых лет до того, как NanoTrasen решил, что покрасить костюмы в красный цвет дешевле, чем смывать кровь."
	icon_state = "warden"
	inhand_icon_state = "gy_suit"

/obj/item/clothing/under/rank/security/warden/skirt
	name = "костюм надзирателя с юбкой"
	desc = "Формальный защитный костюм для офицеров в комплекте с пряжкой на поясе NanoTrasen."
	icon_state = "rwarden_skirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = NO_FEMALE_UNIFORM

/obj/item/clothing/under/rank/security/warden/formal
	desc = "Знаки отличия на этой форме говорят о том, что эта форма принадлежит Надзирателю."
	name = "костюм надзирателя"
	icon_state = "wardenblueclothes"
	inhand_icon_state = "wardenblueclothes"
	alt_covers_chest = TRUE

/*
 * Detective
 */
/obj/item/clothing/under/rank/security/detective
	name = "жёсткий костюм"
	desc = "Кто-то, кто носит это, точно в деле."
	icon_state = "detective"
	inhand_icon_state = "det"
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 30, ACID = 30, WOUND = 10)
	strip_delay = 50
	alt_covers_chest = TRUE
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/security/detective/skirt
	name = "жёсткий костюм с юбочкой"
	desc = "Кто-то, кто носит это, точно в деле."
	icon_state = "detective_skirt"
	inhand_icon_state = "det"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/security/detective/grey
	name = "нуарный костюм"
	desc = "Серый костюм частного детектива в закалённом виде, в комплекте с зажимом для галстука."
	icon_state = "greydet"
	inhand_icon_state = "greydet"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/detective/grey/skirt
	name = "нуарный костюм с юбкой"
	desc = "Серый костюм с юбкой частного детектива в закалённом виде, в комплекте с зажимом для галстука."
	icon_state = "greydet_skirt"
	inhand_icon_state = "greydet"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/security/detective/disco
	name = "superstar cop uniform"
	desc = "Flare cut trousers and a dirty shirt that might have been classy before someone took a piss in the armpits. It's the dress of a superstar."
	icon_state = "jamrock_suit"
	inhand_icon_state = "jamrock_suit"
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/detective/kim
	name = "aerostatic suit"
	desc = "A crisp and well-pressed suit; professional, comfortable and curiously authoritative."
	icon_state = "aerostatic_suit"
	inhand_icon_state = "aerostatic_suit"
	can_adjust = FALSE

/*
 * Head of Security
 */
/obj/item/clothing/under/rank/security/head_of_security
	name = "комбинезон начальника охраны"
	desc = "Защитный комбинезон, украшенный для тех немногих самоотверженным стремлением занять пост начальника охраны."
	icon_state = "rhos"
	inhand_icon_state = "r_suit"
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 10)
	strip_delay = 60
	alt_covers_chest = TRUE
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/security/head_of_security/skirt
	name = "юбкомбез начальника охраны"
	desc = "Защитный комбинезон, украшенный для тех немногих самоотверженным стремлением занять пост начальника охраны."
	icon_state = "rhos_skirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = NO_FEMALE_UNIFORM

/obj/item/clothing/under/rank/security/head_of_security/grey
	name = "серый костюм начальника охраны"
	desc = "Есть старики, есть смельчаки, есть смельчаки, но очень мало стариков, есть смельчаки."
	icon_state = "hos"
	inhand_icon_state = "gy_suit"

/obj/item/clothing/under/rank/security/head_of_security/alt
	name = "водолазка начальника охраны"
	desc = "Стильная альтернатива обычному костюму начальника охраны, в комплекте с тактическими штанами."
	icon_state = "hosalt"
	inhand_icon_state = "bl_suit"

/obj/item/clothing/under/rank/security/head_of_security/alt/skirt
	name = "водолазка начальника охраны с юбкой"
	desc = "Стильная альтернатива обычному головному костюму безопасности, в комплекте с тактической юбкой."
	icon_state = "hosalt_skirt"
	inhand_icon_state = "bl_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/security/head_of_security/parade
	name = "парадный костюм начальника охраны"
	desc = "Мужская роскошная одежда начальника охраны, для особых случаев."
	icon_state = "hos_parade_male"
	inhand_icon_state = "r_suit"
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/head_of_security/parade/female
	name = "парадный костюм начальника охраны"
	desc = "Женская роскошная одежда начальника охраны, для особых случаев."
	icon_state = "hos_parade_fem"
	inhand_icon_state = "r_suit"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/head_of_security/formal
	desc = "Знаки отличия на этой форме говорят о том, что эта форма принадлежит начальнику службы безопасности."
	name = "костюм главы службы безопасности"
	icon_state = "hosblueclothes"
	inhand_icon_state = "hosblueclothes"
	alt_covers_chest = TRUE

/*
 *Spacepol
 */

/obj/item/clothing/under/rank/security/officer/spacepol
	name = "полицейская униформа"
	desc = "Космос, не контролируемый мегакорпорациями, планетами или пиратами, находится под юрисдикцией Космопола."
	icon_state = "spacepol"
	inhand_icon_state = "spacepol"
	can_adjust = FALSE

/obj/item/clothing/under/rank/prisoner
	name = "комбинезон заключенного"
	desc = "Унифицированная тюремная одежда NanoTrasen. Его датчики костюма застряли в положении \"Полностью ВКЛ\"."
	icon_state = "jumpsuit"
	icon_preview = 'icons/obj/previews.dmi'
	icon_state_preview = "prisonsuit"
	greyscale_colors = "#ff8300"
	greyscale_config = /datum/greyscale_config/jumpsuit_prison
	greyscale_config_inhand_left = /datum/greyscale_config/jumpsuit_prison_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/jumpsuit_prison_inhand_right
	greyscale_config_worn = /datum/greyscale_config/jumpsuit_prison_worn
	has_sensor = LOCKED_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/prisoner/skirt
	name = "юбкомбез заключенной"
	desc = "Унифицированная тюремная одежда NanoTrasen. Его датчики костюма застряли в положении \"Полностью ВКЛ\"."
	icon_state = "jumpskirt"
	icon_preview = 'icons/obj/previews.dmi'
	icon_state_preview = "prisonskirt"
	greyscale_colors = "#ff8300"
	greyscale_config = /datum/greyscale_config/jumpsuit_prison
	greyscale_config_inhand_left = /datum/greyscale_config/jumpsuit_prison_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/jumpsuit_prison_inhand_right
	greyscale_config_worn = /datum/greyscale_config/jumpsuit_prison_worn
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/security/officer/beatcop
	name = "форма космической полиции"
	desc = "Полицейская форма, часто мелькает перед глазами в очередях у магазинов пончиков."
	icon_state = "spacepolice_families"
	inhand_icon_state = "spacepolice_families"
	can_adjust = FALSE
