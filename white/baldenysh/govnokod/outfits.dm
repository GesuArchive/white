/obj/item/clothing/mask/gas/tarelka
	name = "одноразовая тарелка"
	desc = "Просто тарелка с веселой рожицей."
	icon = 'white/baldenysh/icons/obj/masks.dmi'
	worn_icon = 'white/baldenysh/icons/mob/mask.dmi'
	icon_state = "tarelka"
	inhand_icon_state = "tarelka"
	armor = list(MELEE = 10, BULLET = 20, LASER = 0, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 10)
	resistance_flags = INDESTRUCTIBLE
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL

/obj/item/clothing/mask/gas/tarelka/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "Initialize")

/obj/item/clothing/under/color/green/dreamer
	armor = list(MELEE = 10, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 0, FIRE = 95, ACID = 95, WOUND = 10)
	resistance_flags = INDESTRUCTIBLE
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL

/obj/item/clothing/under/color/green/dreamer/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "Initialize")
	START_PROCESSING(SSobj, src)

/obj/item/clothing/under/color/green/dreamer/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/clothing/under/color/green/dreamer/equipped(mob/user, slot)
	var/datum/component/soundplayer/SP = user.AddComponent(/datum/component/soundplayer)
	SP.set_sound(sound('white/baldenysh/sounds/speedrun_loop.ogg'))
	SP.active = TRUE
	SP.playing_volume = 100
/*
/obj/item/clothing/under/color/green/dreamer/process()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		SP.playing_volume
*/

/obj/item/stack/sheet/bluespace_crystal/sixteen
	amount = 16

/datum/outfit/dreamer
	name = "Dreamer"
	uniform = /obj/item/clothing/under/color/green/dreamer
	glasses = /obj/item/clothing/glasses/thermal/monocle
	head = /obj/item/clothing/head/soft/green
	mask = /obj/item/clothing/mask/gas/tarelka
	shoes = /obj/item/clothing/shoes/sneakers/green
	gloves = /obj/item/clothing/gloves/color/green
	belt = /obj/item/storage/belt/sheath/security/hos
	back = /obj/item/gun/ballistic/crossbow
	l_pocket = /obj/item/stack/rods/lava/thirty
	r_pocket = /obj/item/stack/sheet/bluespace_crystal/sixteen
