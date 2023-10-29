//Contains: Engineering department jumpsuits

/obj/item/clothing/under/rank/engineering
	icon = 'icons/obj/clothing/under/engineering.dmi'
	worn_icon = 'icons/mob/clothing/under/engineering.dmi'

/obj/item/clothing/under/rank/engineering/chief_engineer
	desc = "Костюм высокой видимости, предоставленный инженерам, достаточно сумасшедшим, чтобы достичь ранга \"Старшего Инженера\". Он имеет незначительную радиационную защиту."
	name = "комбинезон старшего инженера"
	icon_state = "chiefengineer"
	inhand_icon_state = "gy_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 10, FIRE = 80, ACID = 40)
	resistance_flags = NONE

/obj/item/clothing/under/rank/engineering/chief_engineer/skirt
	name = "юбкомбез старшего инженера"
	desc = "Юбкомбез высокой видимости, который дается достаточно безумным инженерам, чтобы достичь ранга \"Старшего Инженера\". Он имеет незначительную радиационную защиту."
	icon_state = "chief_skirt"
	inhand_icon_state = "gy_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE

/obj/item/clothing/under/rank/engineering/atmospheric_technician
	desc = "Комбинезон, который носят технические специалисты по атмосфере."
	name = "комбинезон атмостеха"
	icon_state = "atmos"
	inhand_icon_state = "atmos_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 10, FIRE = 60, ACID = 20)
	resistance_flags = NONE

/obj/item/clothing/under/rank/engineering/atmospheric_technician/skirt
	name = "юбкомбез атмостеха"
	desc = "Юбкомбез, который носят технические специалисты по атмосфере."
	icon_state = "atmos_skirt"
	inhand_icon_state = "atmos_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE

/obj/item/clothing/under/rank/engineering/engineer
	desc = "Оранжевый комбинезон с высокой видимостью, который носят инженеры. Он имеет незначительную радиационную защиту."
	name = "комбинезон инженера"
	icon_state = "engine"
	inhand_icon_state = "engi_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 10, FIRE = 60, ACID = 20)
	resistance_flags = NONE
	species_exception = list(/datum/species/golem/uranium)

/obj/item/clothing/under/rank/engineering/engineer/hazard
	name = "комбинезон инженера"
	desc = "Оранжевый комбинезон с высокой видимостью, который носят инженеры. Он имеет незначительную радиационную защиту."
	icon_state = "hazard"
	inhand_icon_state = "suit-orange"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/engineering/engineer/skirt
	name = "юбкомбез инженера"
	desc = "Оранжевый юбкомбез с высокой видимостью, который носят инженеры. Он имеет незначительную радиационную защиту."
	icon_state = "engine_skirt"
	inhand_icon_state = "engi_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE

