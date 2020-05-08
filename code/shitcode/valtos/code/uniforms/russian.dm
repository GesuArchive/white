/obj/item/clothing/under/rank/omon
	name = "костюм омоновца"
	desc = "Тактично пиздец."
	mob_overlay_icon = 'code/shitcode/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'code/shitcode/valtos/icons/clothing/uniforms.dmi'
	icon_state = "omon"
	item_state = "b_suit"

	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)
	strip_delay = 50
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	can_adjust = FALSE

/obj/item/clothing/under/rank/omon/green
	icon_state = "omon-2"
	item_state = "g_suit"

/obj/item/clothing/under/rank/sobr
	name = "тельняшка"
	desc = "Пиндосы ПОШЛИ на хуй."
	mob_overlay_icon = 'code/shitcode/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'code/shitcode/valtos/icons/clothing/uniforms.dmi'
	icon_state = "telnyashka"
	item_state = "telnyashka"

/obj/item/clothing/suit/armor/riot/omon
	name = "omon riot suit"
	desc = "Designed for effective extermination."
	mob_overlay_icon = 'code/shitcode/valtos/icons/clothing/mob/suit.dmi'
	icon = 'code/shitcode/valtos/icons/clothing/suits.dmi'
	icon_state = "omon_riot"

/obj/item/clothing/suit/armor/bulletproof/omon
	name = "bulletproof omon armor"
	desc = "If you wear it, then obviously you are going to kill people."
	mob_overlay_icon = 'code/shitcode/valtos/icons/clothing/mob/suit.dmi'
	icon = 'code/shitcode/valtos/icons/clothing/suits.dmi'
	icon_state = "omon_armor"

/obj/item/clothing/under/rank/security/veteran
	desc = "Знаки отличия на этой форме говорят о том, что эта форма принадлежит <b>ВЕТЕРАНУ</b>."
	name = "костюм ветерана"
	icon_state = "wardenblueclothes"
	item_state = "wardenblueclothes"
	alt_covers_chest = TRUE

/obj/item/clothing/suit/security/officer/veteran
	name = "костюм ветерана"
	desc = "Эта куртка предназначена для тех особых случаев, когда <b>ВЕТЕРАНУ НУЖНО НА ПАРАД</b>."
	icon_state = "veteransuit"
	item_state = "veteransuit"
	mob_overlay_icon = 'code/shitcode/valtos/icons/clothing/mob/suit.dmi'
	icon = 'code/shitcode/valtos/icons/clothing/suits.dmi'

/obj/item/clothing/head/pirate/captain/veteran
	name = "шляпа ветерана"

/obj/item/clothing/accessory/medal/veteran
	name = "медаль"
	desc = "Полностью золотая."
	icon = 'code/shitcode/valtos/icons/clothing/accessory.dmi'
	mob_overlay_icon = 'code/shitcode/valtos/icons/clothing/mob/accessory.dmi'
	icon_state = "medal"
	item_state = ""
	custom_materials = list(/datum/material/gold=8000)

/obj/item/clothing/accessory/medal/veteran/Initialize()
	. = ..()
	var/krutite_baraban = pick("отвагу", "взятие жепы", "героизм", "исключительный онанизм", "особые заслуги", "500 кредитов", "красивые глаза", "доблесть", "приколы", "взятие за щёку", "ветеранство", "героин")
	name = "[name] за [krutite_baraban]"
	icon_state = "[icon_state][rand(1,2)]"
