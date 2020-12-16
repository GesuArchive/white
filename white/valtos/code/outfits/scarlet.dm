/datum/outfit/x031
	name = "x031 shell"
	uniform = /obj/item/clothing/under/misc/adminsuit/x031
	suit = /obj/item/clothing/suit/space/x031
	head = /obj/item/clothing/head/x031
	glasses = /obj/item/clothing/glasses/debug/x031
	ears = /obj/item/radio/headset/headset_cent/commander/x031
	mask = /obj/item/clothing/mask/gas/syndicate/x031
	gloves = /obj/item/clothing/gloves/combat/x031
	id = /obj/item/card/id/ert/deathsquad/x031
	suit_store = /obj/item/tank/internals/emergency_oxygen/recharge/x031
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/outfit/x031/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()

/obj/item/clothing/glasses/debug/x031
	name = "х031 техочки"
	desc = "AH@(XNHMX"

/obj/item/clothing/glasses/debug/x031/equipped(mob/user, slot)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/suit/space/x031
	name = "х031 техзащита"
	desc = "#(&GB#*&R"
	icon = 'white/valtos/icons/clothing/suits.dmi'
	worn_icon = 'white/valtos/icons/clothing/mob/suit.dmi'
	icon_state = "scarlet"
	slowdown = 0
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 100)
	body_parts_covered = FULL_BODY
	cold_protection = FULL_BODY
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT | HIDESUITSTORAGE
	heat_protection = null
	max_heat_protection_temperature = null
	item_flags = ABSTRACT | DROPDEL
	clothing_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	strip_delay = 1000
	equip_delay_other = 1000
	var/static/mutable_appearance/scanlines

/obj/item/clothing/suit/space/x031/equipped(mob/user, slot)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
	scanlines = mutable_appearance('white/valtos/icons/clothing/mob/suit.dmi', "sl_shell", EFFECTS_LAYER)
	user.add_overlay(scanlines)
	if(ishuman(user))
		INVOKE_ASYNC(src, .proc/bootSequence, user)

/obj/item/clothing/suit/space/x031/proc/bootSequence(mob/living/carbon/human/H)
	H.Paralyze(200)
	H.overlay_fullscreen("scarlet", /atom/movable/screen/fullscreen/scarlet, 1)
	sleep(50)
	H.overlay_fullscreen("scarlet", /atom/movable/screen/fullscreen/scarlet, 2)
	to_chat(H, "<span class='revenboldnotice'><center> -|- ИНИЦИАЛИЗАЦИЯ -|- </center></span>")
	sleep(15)
	for(var/i in 1 to 10)
		to_chat(H, "<span class='revenboldnotice'><center> -|- [md5("[rand(0, 999)][H]")] -|- </center></span>")
		playsound(src, 'sound/machines/beep.ogg', 50, FALSE)
		sleep(1)
	sleep(20)
	H.overlay_fullscreen("scarlet", /atom/movable/screen/fullscreen/scarlet, 4)
	to_chat(H, "<span class='revenboldnotice'><center> -|- УСПЕШНАЯ ОШИБКА -|- </center></span>")
	sleep(5)
	H.overlay_fullscreen("scarlet", /atom/movable/screen/fullscreen/scarlet, 3)
	to_chat(H, "<span class='revenboldnotice'><center> -|- ПОДКЛЮЧЕНИЕ -|- </center></span>")
	sleep(20)
	H.overlay_fullscreen("scarlet", /atom/movable/screen/fullscreen/scarlet, 4)
	to_chat(H, "<span class='revenboldnotice'><center> -|- УСПЕШНАЯ ОШИБКА -|- </center></span>")
	sleep(5)
	H.overlay_fullscreen("scarlet", /atom/movable/screen/fullscreen/scarlet, 3)
	to_chat(H, "<span class='revenboldnotice'><center> -|- АДАПТАЦИЯ -|- </center></span>")
	sleep(10)
	H.overlay_fullscreen("scarlet", /atom/movable/screen/fullscreen/scarlet, 4)
	to_chat(H, "<span class='revenboldnotice'><center> -|- УСПЕШНАЯ ОШИБКА -|- </center></span>")
	sleep(5)
	H.overlay_fullscreen("scarlet", /atom/movable/screen/fullscreen/scarlet, 2)
	to_chat(H, "<span class='revenboldnotice'><center> -|- ПОДКЛЮЧЕНИЕ -|- </center></span>")
	for(var/i in 1 to 7)
		to_chat(H, "<span class='revenboldnotice'><center> -|- [md5("[rand(0, 999)][H]")] -|- </center></span>")
		playsound(src, 'sound/machines/beep.ogg', 50, FALSE)
		sleep(1)
	H.overlay_fullscreen("scarlet", /atom/movable/screen/fullscreen/scarlet, 5)
	to_chat(H, "<span class='revenboldnotice'><center> -|- КРИТИЧЕСКАЯ ОШИБКА -|- </center></span>")
	sleep(20)
	H.overlay_fullscreen("scarlet", /atom/movable/screen/fullscreen/scarlet, 6)
	to_chat(H, "<span class='revenboldnotice'><center> -|- АДАПТАЦИЯ -|- </center></span>")
	sleep(20)
	H.overlay_fullscreen("scarlet", /atom/movable/screen/fullscreen/scarlet, 4)
	to_chat(H, "<span class='revenboldnotice'><center> -|- УСПЕХ -|- </center></span>")
	sleep(20)
	H.overlay_fullscreen("scarlet", /atom/movable/screen/fullscreen/scarlet, 7)
	to_chat(H, "<span class='revenboldnotice'><center> -!- ЗАПУСК -!- </center></span>")
	sleep(20)
	to_chat(H, "<span class='revenboldnotice'><center> -!- СИСТЕМА В СЕТИ -!- </center></span>")
	H.clear_fullscreen("scarlet", 10)

/atom/movable/screen/fullscreen/scarlet
	icon = 'white/valtos/icons/fullscreen_scarlet.dmi'
	layer = SPLASHSCREEN_LAYER
	plane = SPLASHSCREEN_PLANE
	icon_state = "scarlet1"

/obj/item/clothing/head/x031
	name = "х031 техшлем"
	desc = "SH&*(@UQ"
	icon = 'white/valtos/icons/clothing/hats.dmi'
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon_state = "scarlet"
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 100)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	item_flags = ABSTRACT | DROPDEL
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	var/static/mutable_appearance/scanlines

/obj/item/clothing/head/x031/equipped(mob/user, slot)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
	scanlines = mutable_appearance('white/valtos/icons/clothing/mob/suit.dmi', "sl_head", EFFECTS_LAYER)
	user.add_overlay(scanlines)

/obj/item/clothing/mask/gas/syndicate/x031
	name = "х031 техмаска"
	desc = "JINE@($!"

/obj/item/clothing/mask/gas/syndicate/x031/equipped(mob/user, slot)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/gloves/combat/x031
	name = "х031 техперчатки"
	desc = "(&#HDD"

/obj/item/clothing/gloves/combat/x031/equipped(mob/user, slot)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/radio/headset/headset_cent/commander/x031
	name = "х031 гарнитура"
	desc = "C$@!*&"

/obj/item/radio/headset/headset_cent/commander/x031/equipped(mob/user, slot)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/card/id/ert/deathsquad/x031
	name = "х031 ID"
	desc = "DHWA*("

/obj/item/card/id/ert/deathsquad/x031/equipped(mob/user, slot)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/under/misc/adminsuit/x031
	name = "х031 оболочка"
	desc = "&D*GSAD"

/obj/item/clothing/under/misc/adminsuit/x031/equipped(mob/user, slot)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/tank/internals/emergency_oxygen/recharge/x031
	name = "х031 сосуд"
	desc = "DB!*#$"

/obj/item/tank/internals/emergency_oxygen/recharge/x031/equipped(mob/user, slot)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
