//////////////////////////
//
//stealware
//
//////////////////////////

//clothing

/obj/item/clothing/under/m35jacket
	name = "m35 jacket"
	desc = "Ммм. Хайль Вайт."
	worn_icon = 'white/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'white/valtos/icons/clothing/uniforms.dmi'
	icon_state = "m35_jacket"
	inhand_icon_state = "m35_jacket"

	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	can_adjust = FALSE

/obj/item/clothing/under/m35jacket/officer
	icon_state = "m35_jacket_officer"
	inhand_icon_state = "m35_jacket_officer"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/under/m35jacket/elite
	icon_state = "m35_elite_jacket"
	inhand_icon_state = "m35_elite_jacket"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/under/m35jacket/elite/super
	icon_state = "m35_super_elite_jacket"
	inhand_icon_state = "m35_super_elite_jacket"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/under/magistrate
	name = "magistrate uniform"
	desc = "Ммм. Хайль Вайт."
	worn_icon = 'white/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'white/valtos/icons/clothing/uniforms.dmi'
	icon_state = "magistrate"
	inhand_icon_state = "magistrate"

	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	can_adjust = FALSE

/obj/item/clothing/under/arbiter
	name = "arbiter uniform"
	desc = "Ммм. Хайль Вайт."
	worn_icon = 'white/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'white/valtos/icons/clothing/uniforms.dmi'
	icon_state = "arbiter"
	inhand_icon_state = "arbiter"

	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	can_adjust = FALSE

//suits

/obj/item/clothing/suit/armor/vest/izan
	name = "bulletproof vest"
	desc = "Спасёт твою грудь от пуль. Пахнет китайским пластиком."
	worn_icon = 'white/valtos/icons/clothing/mob/suit.dmi'
	icon = 'white/valtos/icons/clothing/suits.dmi'
	icon_state = "opvest"

	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/suit/armor/vest/izan/arbiter
	icon_state = "arbiter"

/obj/item/clothing/suit/armor/vest/izan/army_coat
	icon_state = "army_coat"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/suit/armor/vest/izan/elite_army_coat
	icon_state = "elite_army_coat"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/suit/armor/vest/izan/super_elite_army_coat
	icon_state = "super_elite_army_coat"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/suit/cowl
	name = "cowl"
	desc = "Красивое покрывало."
	worn_icon = 'white/valtos/icons/clothing/mob/suit.dmi'
	icon = 'white/valtos/icons/clothing/suits.dmi'
	icon_state = "cowl"
	slot_flags = ITEM_SLOT_NECK

/obj/item/clothing/suit/cowl/robe
	name = "роба"
	desc = "Модное покрывало."
	icon_state = "robes_blue"

/obj/item/clothing/suit/cowl/robe/Initialize()
	. = ..()
	icon_state = pick("robes_blue", "robes_red")

//gloves

/obj/item/clothing/gloves/arbiter
	name = "arbiter gloves"
	worn_icon = 'white/valtos/icons/clothing/mob/glove.dmi'
	icon = 'white/valtos/icons/clothing/gloves.dmi'
	icon_state = "arbiter"

/obj/item/clothing/gloves/arbiter/undertaker
	name = "undertaker gloves"
	icon_state = "undertaker"

//hats

/obj/item/clothing/head/helmet/arbiter
	name = "arbiter helmet"
	desc = "Ммм. Хайль Вайт."
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	icon_state = "arbiter"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/head/helmet/arbiter/inquisitor
	name = "inquisitor helmet"
	icon_state = "inquisitor"

/obj/item/clothing/head/helmet/izanhelm
	name = "m35 cap"
	desc = "Ммм. Хайль Вайт."
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	icon_state = "officer_cap"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/head/helmet/izanhelm/elite
	name = "m35 elite cap"
	icon_state = "m35_elite_cap"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/head/helmet/izanhelm/helmet
	name = "m35 helmet"
	icon_state = "m35_helmet"

/obj/item/clothing/head/helmet/izanhelm/helmet/elite
	name = "m35 elite helmet"
	icon_state = "m35_elite_helmet"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/head/helmet/izanhelm/helmet/pickelhelm
	name = "pickelhelm"
	icon_state = "pickelhelm"

/obj/item/clothing/head/helmet/richard
	name = "richard's head"
	desc = "Пахнет кровью."
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	icon_state = "richard"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

//masks

/obj/item/clothing/mask/gas/izan
	name = "old style gas mask"
	desc = "Ммм. Хайль Вайт."
	flags_inv = 256
	worn_icon = 'white/valtos/icons/clothing/mob/mask.dmi'
	icon = 'white/valtos/icons/clothing/masks.dmi'
	icon_state = "fullgas"

/obj/item/clothing/mask/gas/izan/german
	name = "german gas mask"
	flags_inv = 256
	icon_state = "german_gasmask"

/obj/item/clothing/mask/gas/izan/german/alt
	name = "gas mask"
	flags_inv = 256
	icon_state = "gas_alt"

/obj/item/clothing/mask/gas/izan/respirator
	name = "respirator mask"
	icon_state = "respirator"

/obj/item/clothing/mask/izanclava
	name = "balaclava"
	desc = "Ммм. Хайль Вайт."
	flags_inv = 256
	worn_icon = 'white/valtos/icons/clothing/mob/mask.dmi'
	icon = 'white/valtos/icons/clothing/masks.dmi'
	icon_state = "balaclava"

/obj/item/clothing/mask/izanclava/swat
	name = "swatclava"
	icon_state = "swatclava"

//shoes

/obj/item/clothing/shoes/jackboots/arbiter
	name = "arbiter boots"
	desc = "Ммм. Хайль Вайт."
	worn_icon = 'white/valtos/icons/clothing/mob/shoe.dmi'
	icon = 'white/valtos/icons/clothing/shoes.dmi'
	icon_state = "arbiter"

//guns

/obj/item/gun/ballistic/automatic/pistol/makarov
	name = "\improper Makarov"
	desc = "Ммм. Хайль Вайт."
	icon = 'white/valtos/icons/gun.dmi'
	icon_state = "makarov"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/m9mm
	can_suppress = FALSE

/obj/item/gun/ballistic/automatic/ak47
	name = "AK-47"
	desc = "Отрывает лицо с очереди. Использует противотанковый калибр 7.62."
	icon = 'white/valtos/icons/gun.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	worn_icon = 'white/valtos/icons/weapons/mob/back.dmi'
	fire_sound = 'white/valtos/sounds/ak74_shot.ogg'
	icon_state = "ak47"
	inhand_icon_state = "ak47"
	worn_icon_state = "ak47"
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	mag_type = /obj/item/ammo_box/magazine/ak47mag
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 3
	can_bayonet = TRUE
	knife_x_offset = 28
	knife_y_offset = 12

/obj/item/ammo_box/magazine/ak47mag
	name = "AK-47 magazine (7.62)"
	icon = 'white/valtos/icons/ammo.dmi'
	icon_state = "akm"
	ammo_type = /obj/item/ammo_casing/a762
	caliber = "a762"
	max_ammo = 30

/obj/item/ammo_box/magazine/ak47mag/update_icon()
	..()
	icon_state = "akm-[ammo_count() ? "30" : "0"]"

/obj/item/clothing/head/hijab
	name = "хиджаб"
	desc = "Ммм."
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	dynamic_hair_suffix = ""
	icon_state = "hijab"
	inhand_icon_state = "hijab"
	armor = list("melee" = 5, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 0)

/obj/item/clothing/head/taqiyah
	name = "такиях"
	desc = "Ооох."
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "taqiyah"
	inhand_icon_state = "taqiyah"

/obj/item/clothing/head/turban
	name = "тюрбан"
	desc = "Мягкий, ых."
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "turban"
	inhand_icon_state = "turban"


/obj/item/storage/belt/military/assault/terrorist_m

/obj/item/storage/belt/military/assault/terrorist_m/PopulateContents()
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)

/obj/item/storage/belt/military/assault/terrorist_f

/obj/item/storage/belt/military/assault/terrorist_f/PopulateContents()
	new /obj/item/grenade/firecracker(src)
	new /obj/item/grenade/firecracker(src)
	new /obj/item/grenade/firecracker(src)
	new /obj/item/grenade/firecracker(src)
	new /obj/item/grenade/frag(src)
	new /obj/item/grenade/frag(src)

/datum/outfit/terrorist_m
	name = "Террорист: Мужчина"

	head = /obj/item/clothing/head/turban
	uniform = /obj/item/clothing/under/color/white
	suit = /obj/item/clothing/suit/chaplainsuit/studentuni
	shoes = /obj/item/clothing/shoes/sandal
	gloves = /obj/item/clothing/gloves/combat

	r_pocket = /obj/item/card/emag/doorjack
	l_pocket = /obj/item/soap/syndie

	belt = /obj/item/storage/belt/military/assault/terrorist_m

	back = /obj/item/gun/ballistic/automatic/ak47

/datum/outfit/terrorist_f
	name = "Террорист: Женщина"

	glasses = /obj/item/clothing/glasses/sunglasses
	head = /obj/item/clothing/head/hijab
	mask = /obj/item/clothing/mask/surgical
	uniform = /obj/item/clothing/under/color/white
	suit = /obj/item/clothing/suit/chaplainsuit/whiterobe
	shoes = /obj/item/clothing/shoes/sandal
	gloves = /obj/item/clothing/gloves/color/white

	belt = /obj/item/storage/belt/military/assault/terrorist_f

	r_pocket = /obj/item/lighter
	l_pocket = /obj/item/grenade/syndieminibomb

	back = /obj/item/storage/backpack/satchel/explorer

	backpack_contents = list(/obj/item/grenade/c4/x4 = 4, /obj/item/sbeacondrop/bomb = 2)

/datum/outfit/terrorist_m/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.client << 'white/valtos/sounds/arab_choir.ogg'
	H.AddSpell(new /obj/effect/proc_holder/spell/self/his_wish(null))
	H.hair_color = "000"
	H.facial_hair_color = "000"
	H.facial_hairstyle = "Beard (Very Long)"
	H.update_hair()
	H.fully_replace_character_name(H.real_name, "[pick("Джохар", "Аслан", "Абу", "Шамиль", "Усама", "Ахтар", "Кари")] Бомбаев")

/datum/outfit/terrorist_f/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.client << 'white/valtos/sounds/arab_choir.ogg'
	H.AddSpell(new /obj/effect/proc_holder/spell/self/his_wish(null))
	H.hair_color = "000"
	H.facial_hair_color = "000"
	H.update_hair()
	H.fully_replace_character_name(H.real_name, "[pick("Адиля", "Гульшат", "Динара", "Ляйсан", "Нарима", "Рахима", "Ширин")] Бомбаева")

/obj/effect/proc_holder/spell/self/his_wish
	name = "Воззвать к Всевышнему"
	desc = "Позволяет забыть о боли на момент."
	human_req = TRUE
	clothes_req = FALSE
	charge_max = 100
	cooldown_min = 100
	invocation = "﷽!"
	invocation_type = INVOCATION_SHOUT
	school = "restoration"
	sound = 'white/valtos/sounds/Alah.ogg'
	action_icon_state = "spacetime"

/obj/effect/proc_holder/spell/self/his_wish/cast(list/targets, mob/living/carbon/human/user)
	user.adjustBruteLoss(-50)
	user.adjustFireLoss(-50)
	user.adjustOxyLoss(-50)
	user.adjustStaminaLoss(-50)
	user.adjustToxLoss(-50)
	user.set_handcuffed(null)
	user.update_handcuffed()

/obj/item/melee/ersh
	name = "ершов"
	desc = "Его величество!"
	icon = 'white/valtos/icons/objects.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "ersh"
	inhand_icon_state = "ersh"
	custom_materials = list(/datum/material/gold = 2000)
	force = 10
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 8
	block_chance = 30
	armour_penetration = 50
	attack_verb_continuous = list("ершует", "ёршит", "чистит", "обогащает")
	attack_verb_simple = list("ершует", "ёршит", "чистит", "обогащает")
