/obj/item/clothing/gloves/tackler
	name = "перчатки перехвата"
	desc = "Особые перчатки манипулирующие кровеносными сосудами рук владельца, дающие ему возможность врезаться в стены."
	icon_state = "tackle"
	inhand_icon_state = "tackle"
	transfer_prints = TRUE
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	resistance_flags = NONE
	custom_premium_price = PAYCHECK_HARD * 3.5
	/// For storing our tackler datum so we can remove it after
	var/datum/component/tackler
	/// See: [/datum/component/tackler/var/stamina_cost]
	var/tackle_stam_cost = 25
	/// See: [/datum/component/tackler/var/base_knockdown]
	var/base_knockdown = 1 SECONDS
	/// See: [/datum/component/tackler/var/range]
	var/tackle_range = 4
	/// See: [/datum/component/tackler/var/min_distance]
	var/min_distance = 0
	/// See: [/datum/component/tackler/var/speed]
	var/tackle_speed = 1
	/// See: [/datum/component/tackler/var/skill_mod]
	var/skill_mod = 0

/obj/item/clothing/gloves/tackler/Destroy()
	tackler = null
	return ..()

/obj/item/clothing/gloves/tackler/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == ITEM_SLOT_GLOVES)
		var/mob/living/carbon/human/H = user
		tackler = H.AddComponent(/datum/component/tackler, stamina_cost=tackle_stam_cost, base_knockdown = base_knockdown, range = tackle_range, speed = tackle_speed, skill_mod = skill_mod, min_distance = min_distance)

/obj/item/clothing/gloves/tackler/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		QDEL_NULL(tackler)

/obj/item/clothing/gloves/tackler/dolphin
	name = "дельфиньи перчатки"
	desc = "Гладкие аэродиномичные перчатки перехвата, которые менее эффективны при бросках, но куда более эффективны при скольжении по корридорам и непреднамеренной порчи имущества и здоровья."
	icon_state = "tackledolphin"
	inhand_icon_state = "tackledolphin"

	tackle_stam_cost = 15
	base_knockdown = 0.5 SECONDS
	tackle_range = 5
	tackle_speed = 2
	min_distance = 2
	skill_mod = -2

/obj/item/clothing/gloves/tackler/combat
	name = "перчатки повстанца"
	desc = "Усиленные боевые перчатки высокого качества, предоставляющие владельцу умение выполнять захваты, однако их использование изматывает быстрее, чем у классических перчаток перехвата."
	icon_state = "cgloves"
	inhand_icon_state = "blackgloves"

	tackle_stam_cost = 30
	base_knockdown = 1.25 SECONDS
	tackle_range = 5
	skill_mod = 2

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE

/obj/item/clothing/gloves/tackler/combat/insulated
	name = "перчатки боевика"
	desc = "Боевые перчатки превосходного качества, идеально подходящие для выполнения захватов, к тому же поглощают удары током."
	siemens_coefficient = 0
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, FIRE = 0, ACID = 0)

/obj/item/clothing/gloves/tackler/rocket
	name = "ракетные перчатки"
	desc = "Максимальный риск с максимальной отдачей, идеальны когда вам нужно остановить преступника с расстояния в 15 метров, или же умереть пытаясь. Запрещены в большинстве футбольных и регбийных лиг."
	icon_state = "tacklerocket"
	inhand_icon_state = "tacklerocket"

	tackle_stam_cost = 50
	base_knockdown = 2 SECONDS
	tackle_range = 10
	min_distance = 7
	tackle_speed = 6
	skill_mod = 7

/obj/item/clothing/gloves/tackler/offbrand
	name = "импровизированные перчатки перехвата"
	desc = "Жалко выглядящие перчатки без пальцев обмотанные клейкой лентой. Остерегайтесь тех кто их носит, ибо им нечего стыдиться и нечего терять."
	icon_state = "fingerless"
	inhand_icon_state = "fingerless"

	tackle_stam_cost = 30
	base_knockdown = 1.75 SECONDS
	min_distance = 2
	skill_mod = -1

/obj/item/clothing/gloves/tackler/football
	name = "football gloves"
	desc = "Gloves for football players! Teaches them how to tackle like a pro."
	icon_state = "tackle_gloves"
	inhand_icon_state = "tackle_gloves"
