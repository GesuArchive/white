/obj/item/clothing/under/rank/medical
	icon = 'icons/obj/clothing/under/medical.dmi'
	worn_icon = 'icons/mob/clothing/under/medical.dmi'

/obj/item/clothing/under/rank/medical/chief_medical_officer
	desc = "Это комбинезон, который носят те, у кого есть опыт, чтобы быть \"Главным Врачём\". Он обеспечивает незначительную биологическую защиту."
	name = "комбинезон главного врача"
	icon_state = "cmo"
	inhand_icon_state = "w_suit"
	permeability_coefficient = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 10, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/under/rank/medical/chief_medical_officer/skirt
	name = "юбкомбез главного врача"
	desc = "Это юбкомбез, который носят те, у кого есть опыт, чтобы быть \"Главным Врачём\". Он обеспечивает незначительную биологическую защиту."
	icon_state = "cmo_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/medical/geneticist
	desc = "Он изготовлен из специального волокна, которое обеспечивает особую защиту от биологических опасностей. На нем есть полоска генетического ранга."
	name = "комбинезон генетика"
	icon_state = "genetics"
	inhand_icon_state = "w_suit"
	permeability_coefficient = 0.5
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 10, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/under/rank/medical/geneticist/skirt
	name = "юбкомбез генетика"
	desc = "Он изготовлен из специального волокна, которое обеспечивает особую защиту от биологических опасностей. На нем есть полоска генетического ранга."
	icon_state = "geneticswhite_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/medical/virologist
	desc = "Он изготовлен из специального волокна, которое обеспечивает особую защиту от биологических опасностей. На нём есть полоса звания вирусолога."
	name = "комбинезон вирусолога"
	icon_state = "virology"
	inhand_icon_state = "w_suit"
	permeability_coefficient = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 10, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/under/rank/medical/virologist/skirt
	name = "юбкомбез вирусолога"
	desc = "Он изготовлен из специального волокна, которое обеспечивает особую защиту от биологических опасностей. На нём есть полоса звания вирусолога."
	icon_state = "virologywhite_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/medical/doctor/nurse
	desc = "Это комбинезон, который обычно носят медсестры в медицинском отделении."
	name = "костюм медсестры"
	icon_state = "nursesuit"
	inhand_icon_state = "w_suit"
	permeability_coefficient = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 10, RAD = 0, FIRE = 0, ACID = 0)
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE

/obj/item/clothing/under/rank/medical/doctor
	desc = "Он изготовлен из специального волокна, которое обеспечивает незначительную защиту от биологических опасностей. На груди имеется крестик, указывающий на то, что владелец обучен медицинскому делу."
	name = "комбинезон врача"
	icon_state = "medical"
	inhand_icon_state = "w_suit"
	permeability_coefficient = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 10, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/under/rank/medical/doctor/blue
	name = "синий медицинский халат"
	desc = "Он изготовлен из специального волокна, которое обеспечивает незначительную защиту от биологических опасностей. Этот в голубом цвете."
	icon_state = "scrubsblue"
	can_adjust = FALSE

/obj/item/clothing/under/rank/medical/doctor/green
	name = "зелёный медицинский халат"
	desc = "Он изготовлен из специального волокна, которое обеспечивает незначительную защиту от биологических опасностей. Этот зелёный."
	icon_state = "scrubsgreen"
	can_adjust = FALSE

/obj/item/clothing/under/rank/medical/doctor/purple
	name = "фиолетовый медицинский халат"
	desc = "Он изготовлен из специального волокна, которое обеспечивает незначительную защиту от биологических опасностей. Этот фиолетовый."
	icon_state = "scrubspurple"
	can_adjust = FALSE

/obj/item/clothing/under/rank/medical/doctor/skirt
	name = "юбкомбез врача"
	desc = "Он изготовлен из специального волокна, которое обеспечивает незначительную защиту от биологических опасностей. На груди имеется крестик, указывающий на то, что владелец обучен медицинскому делу."
	icon_state = "medical_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/medical/chemist
	desc = "Он изготовлен из специального волокна, которое обеспечивает особую защиту от биологических опасностей. На нём полоса звания химика."
	name = "комбинезон химика"
	icon_state = "chemistry"
	inhand_icon_state = "w_suit"
	permeability_coefficient = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 10, RAD = 0, FIRE = 50, ACID = 65)

/obj/item/clothing/under/rank/medical/chemist/skirt
	name = "юбкомбез химика"
	desc = "Он изготовлен из специального волокна, которое обеспечивает особую защиту от биологических опасностей. На нём полоса звания химика."
	icon_state = "chemistrywhite_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/medical/paramedic
	desc = "Он сделан из специального волокна, обеспечивающего незначительную защиту от биологических опасностей. На груди есть темно-синий крест, обозначающий, что владелец - обученный фельдшер."
	name = "комбинезон парамедика"
	icon_state = "paramedic"
	inhand_icon_state = "w_suit"
	permeability_coefficient = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 10, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/under/rank/medical/paramedic/skirt
	name = "юбкомбинезон парамедика"
	desc = "Он сделан из специального волокна, обеспечивающего незначительную защиту от биологических опасностей. На груди есть темно-синий крест, обозначающий, что владелец - обученный фельдшер."
	icon_state = "paramedic_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP
