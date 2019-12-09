
/obj/item/clothing/gloves/fingerless
	name = "перчатки без пальцев"
	desc = "Обычные черные перчатки без кончиков пальцев для тяжелой работы."
	icon_state = "fingerless"
	item_state = "fingerless"
	transfer_prints = TRUE
	strip_delay = 40
	equip_delay_other = 20
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	custom_price = 10
	undyeable = TRUE

/obj/item/clothing/gloves/botanic_leather
	name = "кожаные перчатки ботаника"
	desc = "Эти кожаные перчатки защищают от терний, колючек, колючек, шипов и других вредных объектов растительного происхождения.  Они также довольно теплые."
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.9
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 70, "acid" = 30)

/obj/item/clothing/gloves/combat
	name = "боевые перчатки"
	desc = "Эти тактические перчатки огнеупорны и электрически изолированы."
	icon_state = "black"
	item_state = "blackgloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	strip_delay = 80
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 50)

/obj/item/clothing/gloves/bracer
	name = "костяные перчатки"
	desc = "Потому что когда ты ожидаешь, что тебя ударят по запястью. Обеспечивает скромную защиту ваших рук."
	icon_state = "bracers"
	item_state = "bracers"
	transfer_prints = TRUE
	strip_delay = 40
	equip_delay_other = 20
	body_parts_covered = ARMS
	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list("melee" = 15, "bullet" = 25, "laser" = 15, "energy" = 15, "bomb" = 20, "bio" = 10, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/gloves/rapid
	name = "Перчатки Северной Звезды"
	desc = "Просто глядя на это, ты испытываешь сильное желание выбить дерьмо из людей."
	icon_state = "rapid"
	item_state = "rapid"
	transfer_prints = TRUE

/obj/item/clothing/gloves/rapid/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/punchcooldown)
