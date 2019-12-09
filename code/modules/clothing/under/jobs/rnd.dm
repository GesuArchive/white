/obj/item/clothing/under/rank/rnd
	icon = 'icons/obj/clothing/under/rnd.dmi'
	mob_overlay_icon = 'icons/mob/clothing/under/rnd.dmi'

/obj/item/clothing/under/rank/rnd/research_director
	desc = "Это костюм, который носят те, кто обладает ноу-хау для достижения позиции \"Научного Руководителя\". Его ткань обеспечивает незначительную защиту от биологических загрязнений."
	name = "костюм научного руководителя"
	icon_state = "director"
	item_state = "lb_suit"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 0, "acid" = 35)
	can_adjust = FALSE

/obj/item/clothing/under/rank/rnd/research_director/skirt
	name = "костюм научного руководителя с юбкой"
	desc = "Это костюм, который носят те, кто обладает ноу-хау для достижения позиции \"Научного Руководителя\". Его ткань обеспечивает незначительную защиту от биологических загрязнений."
	icon_state = "director_skirt"
	item_state = "lb_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/rnd/research_director/alt
	desc = "Может, когда-нибудь ты сможешь создать свое собственное получеловечное, полуживое существо. Его ткань обеспечивает незначительную защиту от биологических загрязнений."
	name = "рыжевато-коричневый костюм научного руководителя"
	icon_state = "rdwhimsy"
	item_state = "rdwhimsy"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 0, "acid" = 0)
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/rnd/research_director/alt/skirt
	name = "рыжевато-коричневый костюм научного руководителя с юбкой"
	desc = "Может, когда-нибудь ты сможешь создать свое собственное получеловечное, полуживое существо. Его ткань обеспечивает незначительную защиту от биологических загрязнений."
	icon_state = "rdwhimsy_skirt"
	item_state = "rdwhimsy"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/rnd/research_director/turtleneck
	desc = "Темно-фиолетовая водолазка и загар хакис, для режиссера с превосходным чувством стиля."
	name = "водолазка научного руководителя"
	icon_state = "rdturtle"
	item_state = "p_suit"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 0, "acid" = 0)
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/rnd/research_director/turtleneck/skirt
	name = "водолазка с юбкой"
	desc = "Темно-фиолетовая водолазка и загар хакис, для режиссера с превосходным чувством стиля."
	icon_state = "rdturtle_skirt"
	item_state = "p_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/rnd/scientist
	desc = "Он изготовлен из специального волокна, обеспечивающего незначительную защиту от взрывчатки. У него есть маркировка, обозначающая, что носитель является ученым."
	name = "кобинезон учёного"
	icon_state = "toxins"
	item_state = "w_suit"
	permeability_coefficient = 0.5
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/under/rank/rnd/scientist/skirt
	name = "юбкомбез учёного"
	desc = "Он изготовлен из специального волокна, обеспечивающего незначительную защиту от взрывчатки. У него есть маркировка, обозначающая, что носитель является ученым."
	icon_state = "toxinswhite_skirt"
	item_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/rnd/roboticist
	desc = "Он изготовлен из специального волокна, обеспечивающего незначительную защиту от взрывчатки. У него есть маркировка, обозначающая, что носитель является ученым."
	name = "комбинезон робототехника"
	icon_state = "robotics"
	item_state = "robotics"
	resistance_flags = NONE

/obj/item/clothing/under/rank/rnd/roboticist/skirt
	name = "юбкомбез робототехника"
	desc = "Он изготовлен из специального волокна, обеспечивающего незначительную защиту от взрывчатки. У него есть маркировка, обозначающая, что носитель является ученым."
	icon_state = "robotics_skirt"
	item_state = "robotics"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP
