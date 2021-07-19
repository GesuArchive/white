/obj/item/clothing/under/rank/rnd
	icon = 'icons/obj/clothing/under/rnd.dmi'
	worn_icon = 'icons/mob/clothing/under/rnd.dmi'

/obj/item/clothing/under/rank/rnd/research_director
	desc = "Это костюм, который носят те, кто обладает ноу-хау для достижения позиции \"Научного Руководителя\". Его ткань обеспечивает незначительную защиту от биологических загрязнений."
	name = "комбинезон научного руководителя"
	icon_state = "director"
	inhand_icon_state = "w_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 10, BIO = 10, RAD = 0, FIRE = 0, ACID = 35)
	can_adjust = FALSE

/obj/item/clothing/under/rank/rnd/research_director/doctor_hilbert
	desc = "A Research Director jumpsuit belonging to the late and great Doctor Hilbert. The suit sensors have long since fizzled out from the stress of the Hilbert's Hotel."
	has_sensor = NO_SENSORS
	random_sensor = FALSE

/obj/item/clothing/under/rank/rnd/research_director/skirt
	name = "комбинезон научного руководителя с юбкой"
	desc = "Это костюм, который носят те, кто обладает ноу-хау для достижения позиции \"Научного Руководителя\". Его ткань обеспечивает незначительную защиту от биологических загрязнений."
	icon_state = "director_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = NO_FEMALE_UNIFORM

/obj/item/clothing/under/rank/rnd/research_director/alt
	desc = "Может, когда-нибудь ты сможешь создать свое собственное получеловечное, полуживое существо. Его ткань обеспечивает незначительную защиту от биологических загрязнений."
	name = "рыжевато-коричневый костюм научного руководителя"
	icon_state = "rdwhimsy"
	inhand_icon_state = "rdwhimsy"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 10, BIO = 10, RAD = 0, FIRE = 0, ACID = 0)
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/rnd/research_director/vest
	desc = "Это костюм, который носят те, кто обладает ноу-хау для достижения позиции \"Научного Руководителя\". Его ткань обеспечивает незначительную защиту от биологических загрязнений."
	name = "костюм научного руководителя"
	icon_state = "rd_vest"
	inhand_icon_state = "lb_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 10, BIO = 10, RAD = 0, FIRE = 0, ACID = 0)
	can_adjust = FALSE

/obj/item/clothing/under/rank/rnd/research_director/alt/skirt
	name = "рыжевато-коричневый костюм научного руководителя с юбкой"
	desc = "Может, когда-нибудь ты сможешь создать свое собственное получеловечное, полуживое существо. Его ткань обеспечивает незначительную защиту от биологических загрязнений."
	icon_state = "rdwhimsy_skirt"
	inhand_icon_state = "rdwhimsy"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/rnd/research_director/turtleneck
	desc = "Темно-фиолетовая водолазка и загар хакис, для режиссера с превосходным чувством стиля."
	name = "водолазка научного руководителя"
	icon_state = "rdturtle"
	inhand_icon_state = "p_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 10, BIO = 10, RAD = 0, FIRE = 0, ACID = 0)
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/rnd/research_director/turtleneck/skirt
	name = "водолазка с юбкой"
	desc = "Темно-фиолетовая водолазка и загар хакис, для режиссера с превосходным чувством стиля."
	icon_state = "rdturtle_skirt"
	inhand_icon_state = "p_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/rnd/scientist
	desc = "Он изготовлен из специального волокна, обеспечивающего незначительную защиту от взрывчатки. У него есть маркировка, обозначающая, что носитель является ученым."
	name = "комбинезон учёного"
	icon_state = "toxins"
	inhand_icon_state = "w_suit"
	permeability_coefficient = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/under/rank/rnd/scientist/skirt
	name = "юбкомбез учёного"
	desc = "Он изготовлен из специального волокна, обеспечивающего незначительную защиту от взрывчатки. У него есть маркировка, обозначающая, что носитель является ученым."
	icon_state = "toxinswhite_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE

/obj/item/clothing/under/rank/rnd/roboticist
	desc = "Он изготовлен из специального волокна, обеспечивающего незначительную защиту от взрывчатки. У него есть маркировка, обозначающая, что носитель является ученым."
	name = "комбинезон робототехника"
	icon_state = "robotics"
	inhand_icon_state = "robotics"
	resistance_flags = NONE

/obj/item/clothing/under/rank/rnd/roboticist/skirt
	name = "юбкомбез робототехника"
	desc = "Он изготовлен из специального волокна, обеспечивающего незначительную защиту от взрывчатки. У него есть маркировка, обозначающая, что носитель является ученым."
	icon_state = "robotics_skirt"
	inhand_icon_state = "robotics"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/rnd/geneticist
	desc = "Сделан из специального волокна, которое обеспечивает особую защиту от биологических угроз. На нем есть маркировка генетики."
	name = "комбинезон генетика"
	icon_state = "genetics"
	inhand_icon_state = "w_suit"
	permeability_coefficient = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 10, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/under/rank/rnd/geneticist/skirt
	name = "комбинезон с юбкой генетика"
	desc = "Сделан из специального волокна, которое обеспечивает особую защиту от биологических угроз. На нем есть маркировка генетики"
	icon_state = "geneticswhite_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE
