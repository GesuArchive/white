///////////////////////////////////////////////////////////////////// green elephant

/obj/item/clothing/mask/gas/tarelka
	name = "одноразовая тарелка"
	desc = "Просто тарелка с веселой рожицей."
	icon = 'white/baldenysh/icons/obj/masks.dmi'
	worn_icon = 'white/baldenysh/icons/mob/mask.dmi'
	icon_state = "tarelka"
	inhand_icon_state = "tarelka"
	armor = list(MELEE = 10, BULLET = 20, LASER = 0, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 10)
	resistance_flags = INDESTRUCTIBLE
	flags_cover = MASKCOVERSEYES
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
	qdel(GetComponent(/datum/component/soundplayer))

/obj/item/clothing/under/color/green/dreamer/equipped(mob/user, slot)
	. = ..()
	var/datum/component/soundplayer/SP = AddComponent(/datum/component/soundplayer)
	SP.prefs_toggle_flag = null
	SP.set_sound(sound('white/baldenysh/sounds/speedrun_loop.ogg'))
	SP.set_channel(open_sound_channel_for_boombox())
	SP.playing_volume = 100
	SP.active = TRUE

/obj/item/clothing/under/color/green/dreamer/process()
	var/datum/component/soundplayer/SP = GetComponent(/datum/component/soundplayer)
	if(!SP || !ishuman(loc))
		return
	var/mob/living/carbon/human/H = loc
	var/playing_mod = (H.health + H.maxHealth) / (H.maxHealth * 2)
	SP.playing_volume = max(0, round(100*playing_mod))

/obj/item/stack/ore/bluespace_crystal/sixteen
	amount = 16

/obj/item/gun/ballistic/crossbow/quickload
	name = "самозарядный арбалет"
	desc = "Автоматически заряжается при соприкосновении со стержнями."

/obj/item/gun/ballistic/crossbow/quickload/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(!istype(A, /obj/item/stack/rods))
		return
	attackby(A, user)

/datum/id_trim/speedrunner
	assignment = "green"
	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_MAINT_TUNNELS,
				ACCESS_EVA, ACCESS_ENGINE, ACCESS_CONSTRUCTION, ACCESS_CARGO, ACCESS_HYDROPONICS, ACCESS_RESEARCH, ACCESS_AUX_BASE)

/obj/item/card/id/advanced/dreamer_station
	trim = /datum/id_trim/speedrunner

/datum/outfit/dreamer
	name = "Dreamer (Orbital ruins)"
	uniform = /obj/item/clothing/under/color/green/dreamer
	glasses = /obj/item/clothing/glasses/thermal
	mask = /obj/item/clothing/mask/gas/tarelka
	shoes = /obj/item/clothing/shoes/sneakers/green
	gloves = /obj/item/clothing/gloves/color/green
	belt = /obj/item/melee/moonlight_greatsword
	back = /obj/item/gun/ballistic/crossbow/quickload
	l_pocket = /obj/item/stack/rods/twentyfive
	r_pocket = /obj/item/crowbar/abductor
	id = /obj/item/card/id/advanced/chameleon/black
	r_hand = /obj/item/flashlight/flare/torch

/datum/outfit/dreamer/station
	name = "Dreamer (Station)"
	id = /obj/item/card/id/advanced/dreamer_station
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(/obj/item/melee/baton/loaded=1, /obj/item/storage/firstaid/tactical=1)
	l_pocket = /obj/item/grenade/clusterbuster/syndieminibomb

/datum/outfit/dreamer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/flashlight/flare/torch/danetorchya = locate() in H.contents
	danetorchya.attack_self(H)
	var/obj/item/melee/moonlight_greatsword/cumborne = locate() in H.contents
	cumborne.name = "moonlight greatsword +5"
	cumborne.force = 20

///////////////////////////////////////////////////////////////////// gacha drochilnya

/obj/item/firing_pin/catatonic
	name = "ударник для дэбов"
	desc = "Позволяет стрелять только \"гуманоидам\" с айсикью меньше 10."
	fail_message = "<span class='warning'>ОБНАРУЖЕНА МОЗГОВАЯ АКТИВНОСТЬ.</span>"
	pin_removeable = FALSE

/obj/item/firing_pin/catatonic/pin_auth(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.client)
		return FALSE
	return TRUE

/obj/item/gun/ballistic/automatic/pistol/m1911/catatonic
	name = "M1911 RR"
	desc = "Сколько бы ты не старался, привычные мыслительные шаблоны мешают тебе понять как из этого стрелять. Воистину изобретение укропов."
	pin = /obj/item/firing_pin/catatonic

/datum/id_trim/tacticalcatwife
	assignment = "Тактическая Кошкожена"
	access = list(ACCESS_MAINT_TUNNELS)

/obj/item/card/id/advanced/tacticalcatwife
	trim = /datum/id_trim/tacticalcatwife

/datum/outfit/tcatwife
	name = "Тактическая Кошкожена"
	uniform = /obj/item/clothing/under/syndicate/skirt
	head = /obj/item/clothing/head/kitty
	ears = /obj/item/clothing/ears/earmuffs
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/fingerless
	belt = 	/obj/item/gun/ballistic/automatic/pistol/m1911/catatonic
	l_pocket = /obj/item/ammo_box/magazine/m45
	r_pocket = /obj/item/kitchen/knife/combat/survival
	id = /obj/item/card/id/advanced/tacticalcatwife

/mob/living/carbon/human/tdroid
	ai_controller = /datum/ai_controller/tdroid

/mob/living/carbon/human/tdroid/Initialize()
	. = ..()
	var/datum/ai_controller/tdroid/CTRL = ai_controller
	for(var/mob/living/L in range(1))
		if(L.client)
			CTRL.RegisterCommander(L)
			return

/obj/effect/mob_spawn/human/tcatwife
	mob_type = /mob/living/carbon/human/tdroid
	outfit = /datum/outfit/tcatwife
	instant = TRUE
	death = FALSE
	roundstart = FALSE

/obj/effect/mob_spawn/human/tcatwife/create(ckey, newname)
	mob_gender = "female"
	mob_name = random_unique_name("female")
	. = ..()

/obj/effect/mob_spawn/human/tcatwife/equip(mob/living/carbon/human/H)
	. = ..()
	var/list/listIzCoomcamaPrikol = list(
		"#0FFFFF" = "Aqua_hair",
		"#000000" = "Black_hair",
		"#FAF0BE" = "Blonde_hair",
		"#0000FF" = "Blue_hair",
		"#964B00" = "Brown_hair",
		"#B5651D" = "Light_brown_hair",
		"#808080" = "Grey_hair",
		"#FFA500" = "Orange_hair",
		"#FFC0CB" = "Pink_hair",
		"#800080" = "Purple_hair",
		"#E6E6FA" = "Lavender_hair",
		"#FF0000" = "Red_hair",
		"#C0C0C0" = "Silver_hair",
		"#FFFFFF" = "White_hair"
	)
	H.hair_color = pick(listIzCoomcamaPrikol)

/datum/outfit/tcatwife/mosin
	name = "Тактическая Кошкожена Мосина"
	belt = null
	l_pocket = /obj/item/ammo_box/a762
	back = /obj/item/gun/ballistic/rifle/boltaction

/obj/effect/mob_spawn/human/tcatwife/mosin_debug
	outfit = /datum/outfit/tcatwife/mosin
