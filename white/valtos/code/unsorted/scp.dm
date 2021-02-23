/obj/item/clothing/under/prison/d
	name = "комбинезон D-666"
	desc = "А что означает эта буква?"
	worn_icon = 'white/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'white/valtos/icons/clothing/uniforms.dmi'
	icon_state = "d"
	has_sensor = LOCKED_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = 0

/obj/item/clothing/under/prison/d/Initialize()
	..()
	name = "комбинезон D-[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"

/obj/effect/mob_spawn/human/prison/prisoner/d
	name = "шконка класса D"
	flavour_text = "Мне дали шанс искупить свою вину отправив в этот комплекс. Кстати, отправили меня сюда за "
	outfit = /datum/outfit/scp_prisoner_d
	assignedrole = "SCP: Class-D"

/obj/effect/mob_spawn/human/prison/prisoner/rd
	name = "шконка научного сотрудника"
	flavour_text = "Мне дали шанс искупить свою вину отправив в этот комплекс следить за другими заключёнными. Где-то тут должна быть карта доступа. Кстати, отправили меня сюда за "
	outfit = /datum/outfit/scp_rd
	assignedrole = "SCP: RD"

/datum/outfit/scp_prisoner_d
	name = "SCP: Prisoner D"
	uniform = /obj/item/clothing/under/prison/d
	shoes = /obj/item/clothing/shoes/sneakers/orange

/datum/outfit/scp_rd
	name = "SCP: Scientist"
	uniform = /obj/item/clothing/under/rank/engineering/engineer/wzzzz/morpheus
	shoes = /obj/item/clothing/shoes/sneakers/brown
