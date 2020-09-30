
/obj/item/clothing/under/rank/civilian/mime
	name = "костюм мима"
	desc = "Он не шибко насыщен красками."
	icon_state = "mime"
	inhand_icon_state = "mime"

/obj/item/clothing/under/rank/civilian/mime/skirt
	name = "юбка мима"
	desc = "Она не шибко насыщенна красками."
	icon_state = "mime_skirt"
	inhand_icon_state = "mime"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/civilian/mime/sexy
	name = "сексуальный наряд мима"
	desc = "Единственный раз когда вам НЕ нравится смотреть на чьи-то буфера."
	icon_state = "sexymime"
	inhand_icon_state = "sexymime"
	body_parts_covered = CHEST|GROIN|LEGS
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/clown
	name = "костюм клоуна"
	desc = "<i>'ХОНК!'</i>"
	icon_state = "clown"
	inhand_icon_state = "clown"
/obj/item/clothing/under/rank/civilian/clown/Initialize()
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CLOWN, CELL_VIRUS_TABLE_GENERIC, rand(2,3), 0)

/obj/item/clothing/under/rank/civilian/clown/blue
	name = "синий костюм клоуна"
	desc = "<i>'СИНИЙ ХОНК!'</i>"
	icon_state = "blueclown"
	inhand_icon_state = "blueclown"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/clown/green
	name = "зелёный костюм клоуна"
	desc = "<i>'ЗЕЛЕНЫЙ ХОНК!'</i>"
	icon_state = "greenclown"
	inhand_icon_state = "greenclown"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/clown/yellow
	name = "жёлтый костюм клоуна"
	desc = "<i>'ЖЕЛТЫЙ ХОНК!'</i>"
	icon_state = "yellowclown"
	inhand_icon_state = "yellowclown"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/clown/purple
	name = "фиолетовый костюм клоуна"
	desc = "<i>'ФИОЛЕТОВЫЙ ХОНК!'</i>"
	icon_state = "purpleclown"
	inhand_icon_state = "purpleclown"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/clown/orange
	name = "оранжевый  костюм клоуна"
	desc = "<i>'ОРАНЖЕВЫЙ ХОНК!'</i>"
	icon_state = "orangeclown"
	inhand_icon_state = "orangeclown"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/clown/rainbow
	name = "радужный костюм клоуна"
	desc = "<i>'Р А Д У Ж Н Ы Й ХОНК!'</i>"
	icon_state = "rainbowclown"
	inhand_icon_state = "rainbowclown"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/clown/jester
	name = "костюм шута"
	desc = "Веселое одеяние, отлично подойдет для развлечения вашего хозяина."
	icon_state = "jester"
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/clown/jester/alt
	icon_state = "jester2"

/obj/item/clothing/under/rank/civilian/clown/sexy
	name = "сексуальный костюм клоуна"
	desc = "В нем вы выглядите ХОНКибельно!"
	icon_state = "sexyclown"
	inhand_icon_state = "sexyclown"
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/clown/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/items/bikehorn.ogg'=1), 50)
