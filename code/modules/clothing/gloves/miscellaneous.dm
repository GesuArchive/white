
/obj/item/clothing/gloves/fingerless
	name = "перчатки без пальцев"
	desc = "Обычные черные перчатки без кончиков пальцев для тяжелой работы."
	icon_state = "fingerless"
	inhand_icon_state = "fingerless"
	transfer_prints = TRUE
	strip_delay = 40
	equip_delay_other = 20
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	custom_price = PAYCHECK_ASSISTANT * 1.5
	undyeable = TRUE

/obj/item/clothing/gloves/botanic_leather
	name = "кожаные перчатки ботаника"
	desc = "Эти кожаные перчатки защищают от терний, колючек, колючек, шипов и других вредных объектов растительного происхождения. Они также довольно теплые."
	icon_state = "leather"
	inhand_icon_state = "ggloves"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	clothing_traits = list(TRAIT_PLANT_SAFE)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 10, RAD = 0, FIRE = 70, ACID = 30)

/obj/item/clothing/gloves/combat
	name = "боевые перчатки"
	desc = "Тактические перчатки, предоставляющие владельцу защиту от ударов током и огня."
	icon_state = "cgloves"
	inhand_icon_state = "blackgloves"
	siemens_coefficient = 0
	strip_delay = 80
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, RAD = 0, FIRE = 80, ACID = 50)

/obj/item/clothing/gloves/bracer
	name = "костяные перчатки"
	desc = "Для получения ударов по запястью. Обеспечивает скромную защиту ваших рук."
	icon_state = "bracers"
	inhand_icon_state = "bracers"
	transfer_prints = TRUE
	strip_delay = 40
	equip_delay_other = 20
	body_parts_covered = ARMS
	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list(MELEE = 15, BULLET = 25, LASER = 15, ENERGY = 15, BOMB = 20, BIO = 10, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/gloves/rapid
	name = "Перчатки Северной Звезды"
	desc = "Просто глядя на них, ты испытываешь сильное желание выбить дерьмо из людей."
	icon_state = "rapid"
	inhand_icon_state = "rapid"
	transfer_prints = TRUE

/obj/item/clothing/gloves/rapid/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/punchcooldown)


/obj/item/clothing/gloves/color/plasmaman
	desc = "Прикрывает эти возмутительные костлявые руки."
	name = "герметичные перчатки плазмамена"
	icon_state = "plasmaman"
	inhand_icon_state = "plasmaman"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, RAD = 0, FIRE = 95, ACID = 95)

/obj/item/clothing/gloves/color/plasmaman/black
	name = "черные герметичные перчатки"
	icon_state = "blackplasma"
	inhand_icon_state = "blackplasma"

/obj/item/clothing/gloves/color/plasmaman/white
	name = "белые герметичные перчатки"
	icon_state = "whiteplasma"
	inhand_icon_state = "whiteplasma"

/obj/item/clothing/gloves/color/plasmaman/robot
	name = "герметичные перчатки робототехника"
	icon_state = "robotplasma"
	inhand_icon_state = "robotplasma"

/obj/item/clothing/gloves/color/plasmaman/janny
	name = "герметичные перчатки уборщика"
	icon_state = "jannyplasma"
	inhand_icon_state = "jannyplasma"

/obj/item/clothing/gloves/color/plasmaman/cargo
	name = "герметичные перчатки грузчика"
	icon_state = "cargoplasma"
	inhand_icon_state = "cargoplasma"

/obj/item/clothing/gloves/color/plasmaman/engineer
	name = "герметичные перчатки инженера"
	icon_state = "engieplasma"
	inhand_icon_state = "engieplasma"
	siemens_coefficient = 0

/obj/item/clothing/gloves/color/plasmaman/atmos
	name = "герметичные перчатки атмосферного техника"
	icon_state = "atmosplasma"
	inhand_icon_state = "atmosplasma"
	siemens_coefficient = 0

/obj/item/clothing/gloves/color/plasmaman/explorer
	name = "герметичные перчатки исследователя"
	icon_state = "explorerplasma"
	inhand_icon_state = "explorerplasma"

/obj/item/clothing/gloves/color/botanic_leather/plasmaman
	name = "герметичные перчатки ботаника"
	desc = "Прикрывает эти возмутительные костлявые руки."
	icon_state = "botanyplasma"
	inhand_icon_state = "botanyplasma"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, RAD = 0, FIRE = 95, ACID = 95)

/obj/item/clothing/gloves/color/plasmaman/prototype
	name = "прототип герметичных перчаток"
	icon_state = "protoplasma"
	inhand_icon_state = "protoplasma"

/obj/item/clothing/gloves/color/plasmaman/clown
	name = "герметичные перчатки клоуна"
	icon_state = "clownplasma"
	inhand_icon_state = "clownplasma"

/obj/item/clothing/gloves/combat/wizard
	name = "зачарованные перчатки"
	desc = "На эти перчатки наложено заклинание, которое делает их электроизолированными и огнеустойчивыми."
	icon_state = "wizard"
	inhand_icon_state = "purplegloves"

/obj/item/clothing/gloves/radio
	name = "перчатки передатчик"
	desc = "Пара электронных перчаток которая удаленно подключается к ближайшим радиостанциям. Позволяет знающим язык жестов 'говорить' через интеркомы"
	icon_state = "radio_g"
	inhand_icon_state = "radio_g"
	clothing_traits = list(TRAIT_CAN_SIGN_ON_COMMS)

/obj/item/clothing/gloves/color/plasmaman/head_of_personnel
	name = "герметичные перчатки Главы Персонала"
	desc = "Прикрывают эти тощенькие ручки. Скорее всего, являются попыткой создать копию перчаток капитана."
	icon_state = "hopplasma"
	inhand_icon_state = "hopplasma"

/obj/item/clothing/gloves/color/plasmaman/chief_engineer
	name = "герметичные перчатки главного инженера"
	icon_state = "ceplasma"
	inhand_icon_state = "ceplasma"

/obj/item/clothing/gloves/color/plasmaman/research_director
	name = "герметичные перчатки руководителя исследований"
	icon_state = "rdplasma"
	inhand_icon_state = "rdplasma"

/obj/item/clothing/gloves/color/plasmaman/centcom_commander
	name = "герметичные перчатки командующего ЦентКома"
	icon_state = "commanderplasma"
	inhand_icon_state = "commanderplasma"

/obj/item/clothing/gloves/color/plasmaman/centcom_official
	name = "герметичные перчатки представителя ЦентКома"
	icon_state = "officialplasma"
	inhand_icon_state = "officialplasma"

/obj/item/clothing/gloves/color/plasmaman/centcom_intern
	name = "герметичные перчатки интерна ЦентКома"
	icon_state = "internplasma"
	inhand_icon_state = "internplasma"

/obj/item/clothing/gloves/race
	name = "гоночные перчатки"
	desc = "Высококачественные перчатки, используются гонщиками."
	clothing_traits = list(TRAIT_DOUBLE_TAP)
	icon_state = "black"
	inhand_icon_state = "blackgloves"
