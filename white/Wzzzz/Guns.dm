/obj/item/ammo_box/magazine/internal/boltaction98
	name = "bolt action rifle internal magazine"
	desc = "Oh god, this shouldn't be here"
	ammo_type = /obj/item/ammo_casing/a792x57
	caliber = "a792x57"
	max_ammo = 5
	multiload = 1

/obj/item/ammo_box/magazine/internal/boltaction98/empty
	start_empty = TRUE

/obj/item/ammo_box/n792x57
	name = "ammo box (7.92x57)"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/a792x57
	max_ammo = 14

/obj/item/ammo_box/magazine/a792x57
	name = "Clip (7.92x57mm)"
	icon = 'white/Wzzzz/icons/ammo.dmi'
	icon_state = "kclip"
	caliber = "a792x57"
	ammo_type = /obj/item/ammo_casing/a792x57
	max_ammo = 5
	multiple_sprites = TRUE

/obj/item/ammo_box/magazine/a792x57/empty
	start_empty = TRUE

/obj/item/ammo_casing/a792x57
	name = "7.92x57mm bullet casing"
	desc = "A 7.92x57mm bullet casing."
	caliber = "a792x57"
	projectile_type = /obj/projectile/bullet/a792x57
	icon = 'white/Wzzzz/icons/ammo.dmi'
	icon_state = "rifle_casing"
	inhand_icon_state = "rifle_casing"

/obj/projectile/bullet/a792x57
	damage = 45
	stamina = 25
	speed = 0.4
	armour_penetration = 45

/obj/item/gun/ballistic/rifle/boltaction/kar98k
	name = "kar98k"
	desc = "Some kind of bolt action rifle. You get the feeling you shouldn't have this."
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "kar98k"
	inhand_icon_state = "kar98k"
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction98
	bolt_wording = "bolt"
	w_class = WEIGHT_CLASS_BULKY
	bolt_type = BOLT_TYPE_STANDARD
	semi_auto = FALSE
	internal_magazine = TRUE
	fire_sound = 'white/Wzzzz/kar_shot.ogg'
	fire_sound_volume = 80
	vary_fire_sound = FALSE
	tac_reloads = FALSE
	can_be_sawn_off = FALSE
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/back.dmi'
	slot_flags = ITEM_SLOT_BACK
	can_bayonet = TRUE
	knife_x_offset = 27
	slot_flags = 0
	knife_y_offset = 13

/obj/item/gun/ballistic/rifle/boltaction/kar98k/empty
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction98/empty

/obj/item/gun/ballistic/rifle/boltaction/kar98k/can_shoot()
	if (bolt_locked)
		return FALSE
	return ..()

/obj/item/gun/ballistic/rifle/boltaction/kar98k/attackby(obj/item/A, mob/user, params)
	if (!bolt_locked)
		to_chat(user, "<span class='notice'>The bolt is closed!</span>")
		return
	return ..()

/obj/item/gun/ballistic/rifle/boltaction/kar98k/examine(mob/user)
	. = ..()
	. += "<hr>The bolt is [bolt_locked ? "open" : "closed"]."

/obj/item/gun/ballistic/rifle/boltaction/kar98k/update_icon(var/add_scope = FALSE)
	if (bolt_locked == FALSE)
		icon_state = "kar98k_open"
		inhand_icon_state = "kar98k_open"
	else
		icon_state = "kar98k"
		inhand_icon_state = "kar98k"
	if (bolt_locked == FALSE)
		if(!findtext(icon_state, "_open"))
			icon_state = "kar98k_open"
			inhand_icon_state = "kar98k_open"
	else if(icon_state == "kar98k_open") //closed
		icon_state = "kar98k"
	return

/obj/item/gun/ballistic/rifle/boltaction/kar98k/rack(mob/user = null)
	if (bolt_locked == FALSE)
		to_chat(user, "<span class='notice'>You open the bolt of <b>[src.name]</b></span>")
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
		process_chamber(FALSE, FALSE, FALSE)
		bolt_locked = TRUE
		update_icon()
		return
	drop_bolt(user)


/obj/item/gun/ballistic/rifle/boltaction/kar98k/scope
	name = "kar98k scope"
	desc = "Some kind of bolt action rifle. You get the feeling you shouldn't have this."
	icon_state = "kar98k_scope"
	inhand_icon_state = "kar98k_scope"
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	actions_types = list()

/obj/item/gun/ballistic/rifle/boltaction/kar98k/scope/can_shoot()
	if (bolt_locked)
		return FALSE
	return ..()

/obj/item/gun/ballistic/rifle/boltaction/kar98k/scope/attackby(obj/item/A, mob/user, params)
	if (!bolt_locked)
		to_chat(user, "<span class='notice'>The bolt is closed!</span>")
		return
	return ..()

/obj/item/gun/ballistic/rifle/boltaction/kar98k/scope/examine(mob/user)
	. = ..()
	. += "<hr>The bolt is [bolt_locked ? "open" : "closed"]."

/obj/item/gun/ballistic/rifle/boltaction/kar98k/scope/update_icon(var/add_scope = FALSE)
	if (bolt_locked == FALSE)
		icon_state = "kar98k_scope_open"
		inhand_icon_state = "kar98k_scope_open"
		icon = 'white/Wzzzz/icons/Weea.dmi'
		slot_flags = ITEM_SLOT_BACK
		lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
		righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'
		worn_icon = 'white/Wzzzz/clothing/mob/back.dmi'
		fire_sound = 'white/Wzzzz/kar_shot.ogg'
	else
		icon_state = "kar98k_scope"
		inhand_icon_state = "kar98k_scope"
		icon = 'white/Wzzzz/icons/Weea.dmi'
		lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
		righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'
		worn_icon = 'white/Wzzzz/clothing/mob/back.dmi'
		fire_sound = 'white/Wzzzz/kar_shot.ogg'
		return

/obj/item/gun/ballistic/rifle/boltaction/kar98k/scope/rack(mob/user = null)
	if (bolt_locked == FALSE)
		to_chat(user, "<span class='notice'>You open the bolt of <b>[src.name]</b></span>")
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
		process_chamber(FALSE, FALSE, FALSE)
		bolt_locked = TRUE
		update_icon()
		return
	drop_bolt(user)

/obj/item/gun/energy/taser/carbine
	name = "taser carbine"
	desc = "The NT Mk44 NL is a high capacity gun used for non-lethal takedowns. It can switch between high and low intensity stun shots."
	icon_state = "tasercarbine"
	inhand_icon_state = "tasercarbine"
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BELT|ITEM_SLOT_BACK
	icon = 'white/Wzzzz/icons/Weea.dmi'
	force = 8
	selfcharge = 1
	ammo_x_offset = 2
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/back.dmi'

/obj/item/ammo_casing/energy/electrode/carb
	e_cost = 150
	projectile_type = /obj/projectile/energy/electrode/carb

/obj/projectile/energy/electrode/carb
	damage = 60
	stutter = 7
	jitter = 27
	range = 10

/obj/item/ammo_box/magazine/wt550m9/mc9mmt
	name = "top mounted magazine (9mm)"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"

/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/projectile/bullet/c9mmt

/obj/projectile/bullet/c9mmt
	damage = 25
	armour_penetration = 13.5

/obj/item/gun/ballistic/automatic/wt550/german
	name = "9mm machine pistol"
	desc = "The W-T 550 Saber is a cheap self-defense weapon, mass-produced by Ward-Takahashi for paramilitary and private use. Uses 9mm rounds."
	icon_state = "wt550"
	burst_size = 3
	inhand_icon_state = "wt550"
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'
	mag_type = /obj/item/ammo_box/magazine/wt550m9/mc9mmt
	actions_types = list(/datum/action/item_action/toggle_firemode)

/obj/item/chainsaw/circular
	name = "circular saw"
	desc = "Good against wood or flesh, bad against steel."
	icon_state = "saw"
	icon = 'white/Wzzzz/icons/Weea.dmi'
	inhand_icon_state = "saw"
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	throwforce = 12
	force = 13
	force_on = 27
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	armour_penetration = 0
	sharpness = 5

/obj/item/shovel/serrated/bone
	name = "bone shovel"
	desc = "Weapon and tool together."
	icon = 'white/Wzzzz/icons/Weea.dmi'
	throwforce = 10
	force = 12

/obj/item/shovel/spade/german
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "german_shovel2"
	inhand_icon_state = "german_shovel2"
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	throwforce = 11
	force = 12

/obj/item/pickaxe/silver/bone
	name = "костяная кирка"
	desc = "Импровизируйте свою жизнь с помощью костей и дерева."
	toolspeed = 0.2
	force = 12
	throwforce = 8
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "pickaxe_bone"
	inhand_icon_state = "pickaxe_bone"

/obj/item/clothing/mask/cigarette/pipe/cobpipe/glass
	icon = 'white/Wzzzz/icons/Weea.dmi'
	name = "pipe"

/obj/item/gun/ballistic/automatic/assault_rifle
	name = "assault rifle"
	desc = "Standart assault rifle."
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "arifle"
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'
	burst_size = 3
	inhand_icon_state = "arifle"
	w_class = 4
	force = 10
	fire_delay = 2
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/assault_rifle
	can_suppress = FALSE
	can_bayonet = FALSE
	fire_sound = 'white/Wzzzz/gunshot3z.ogg'

/obj/item/ammo_box/magazine/assault_rifle
	name = "assault rifle magazine"
	icon_state = "assault_rifle"
	caliber = "asr"
	ammo_type = /obj/item/ammo_casing/assault_rifle
	icon = 'white/Wzzzz/icons/ammo.dmi'
	max_ammo = 25
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_casing/assault_rifle
	desc = "Assault rifle bullet casing."
	caliber = "asr"
	projectile_type = /obj/projectile/bullet/assault_rifle

/obj/projectile/bullet/assault_rifle
	damage = 30
	armour_penetration = 25

/obj/item/gun/energy/decloner
	burst_size = 3
	pin = /obj/item/firing_pin/dna
	cell = /obj/item/stock_parts/cell/high/plus
	selfcharge = 10

/obj/item/gun/ballistic/automatic/stg
	name = "STG-44"
	desc = "German submachinegun chambered in 9x19 Parabellum, with a 32 magazine magazine layout. Standard issue amongst most troops."
	icon = 'white/Wzzzz/icons/Weea.dmi'
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'
	icon_state = "stg"
	inhand_icon_state = "stg"
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	fire_sound = 'white/Wzzzz/stg.ogg'
	mag_type = /obj/item/ammo_box/magazine/stg
	w_class = WEIGHT_CLASS_HUGE
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 3
	can_bayonet = FALSE

/obj/item/ammo_box/magazine/stg
	name = "stg-44 (7.92x33mm) magazine"
	desc = "A Stg-44 magazine."
	icon = 'white/Wzzzz/icons/ammo.dmi'
	icon_state = "stgmag"
	inhand_icon_state = "stgmag"
	caliber = "a792x33"
	ammo_type = /obj/item/ammo_casing/a792x33
	max_ammo = 30
	multiple_sprites = FALSE



/obj/projectile/bullet/stg
	name = "a792x33 bullet"
	damage = 35
	armour_penetration = 30

/obj/item/ammo_casing/a792x33
	name = "a792x33 bullet casing"
	desc = "A a792x33 bullet casing."
	caliber = "a792x33"
	projectile_type = /obj/projectile/bullet/stg

/obj/item/gun/ballistic/automatic/ar/fg42
	name = "FG-42"
	desc = "Automatic sniper weapon."
	icon_state = "fg42"
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'
	inhand_icon_state = "fg42"
	mag_type = /obj/item/ammo_box/magazine/fg42
	fire_sound = 'white/Wzzzz/sfrifle_fire.ogg'
	can_suppress = FALSE
	icon = 'white/Wzzzz/icons/Weea.dmi'
	burst_size = 3
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 10
	fire_delay = 1.75

/obj/item/ammo_box/magazine/fg42
	name = "fg42 magazine (5.56mm)"
	ammo_type = /obj/item/ammo_casing/a762/fg42
	caliber = "7.92"
	max_ammo = 20
	icon_state = "5.56"
	icon = 'white/Wzzzz/icons/ammo.dmi'
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_casing/a762/fg42
	name = "7.92mm bullet casing"
	desc = "A 7.92mm bullet casing."
	caliber = "7.92"
	projectile_type = /obj/projectile/bullet/fg42

/obj/projectile/bullet/fg42
	damage = 35
	armour_penetration = 20
	speed = 0.35

/obj/item/gun/ballistic/automatic/m90/unrestricted/z8
	name = "bullpup assault rifle"
	desc = "The Z8 Bulldog is an older model bullpup carbine, made by the now defunct Zendai Foundries. Uses armor piercing 5.56mm rounds. Makes you feel like a space marine when you hold it."
	icon_state = "carbine"
	inhand_icon_state = "carbine"
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	fire_sound = 'white/Wzzzz/gunshot3.ogg'
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/a556carbine
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 3
	can_bayonet = FALSE
	icon = 'white/Wzzzz/icons/Weea.dmi'
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'

/obj/item/ammo_box/magazine/a556carbine
	name = "magazine (6.8mm)"
	icon_state = "5.56"
	caliber = "229"
	ammo_type = /obj/item/ammo_casing/a556carbine
	max_ammo = 15
	icon = 'white/Wzzzz/icons/ammo.dmi'
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_casing/a556carbine
	desc = "A 6.8mm bullet casing."
	caliber = "229"
	projectile_type = /obj/projectile/bullet/a556

/obj/projectile/bullet/a556
	damage = 50
	armour_penetration = 25

/obj/item/gun/ballistic/automatic/carbine
	name = "assault carbine"
	desc = "The assault rifle is new standart automatic weapon"
	icon_state = "carbinex"
	inhand_icon_state = "carbinex"
	w_class = 4
	force = 10
	fire_sound = 'white/Wzzzz/batrifle_fire.ogg'
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/carbine
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 3
	can_bayonet = FALSE
	icon = 'white/Wzzzz/icons/Weea.dmi'
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'

/obj/item/ammo_box/magazine/carbine
	name = "magazine (5.56mm)"
	icon_state = "carb"
	caliber = "carab"
	ammo_type = /obj/item/ammo_casing/carbine
	max_ammo = 30
	icon = 'white/Wzzzz/icons/ammo.dmi'
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_casing/carbine
	desc = "A 5.56mm bullet casing."
	caliber = "carab"
	projectile_type = /obj/projectile/bullet/carab

/obj/projectile/bullet/carab
	damage = 30
	armour_penetration = 7.5

/obj/item/gun/ballistic/automatic/pistol/luger
	name = "Luger P08"
	desc = "German 9mm pistol."
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "luger"
	w_class = WEIGHT_CLASS_SMALL
	fire_sound = 'white/Wzzzz/Gunshot_light.ogg'
	mag_type = /obj/item/ammo_box/magazine/luger/battle
	can_suppress = FALSE
	slot_flags = ITEM_SLOT_BELT


/obj/item/ammo_box/magazine/luger
	name = "Luger magazine"
	desc = "A luger magazine."
	icon = 'white/Wzzzz/icons/ammo.dmi'
	icon_state = "lugermag"
	inhand_icon_state = "lugermag"
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/luger
	max_ammo = 8
	multiple_sprites = TRUE

/obj/item/ammo_box/magazine/luger/battle
	name = "Luger magazine (9mm battle)"
	ammo_type = /obj/item/ammo_casing/lugerb

/obj/item/ammo_box/magazine/luger/rubber
	name = "Luger magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/luger

/obj/projectile/bullet/pistol/rubber
	name = "rubber bullet"
	damage = 5
	stamina = 25

/obj/projectile/bullet/pistol/battle
	name = "9mm bullet"
	damage = 20

/obj/item/ammo_casing/luger
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/lugerb
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/projectile/bullet/pistol/battle

/obj/item/gun/ballistic/automatic/mp40
	name = "MP40"
	desc = "German submachinegun chambered in 9x19 Parabellum, with a 32 magazine magazine layout. Standard issue amongst most troops."
	icon = 'white/Wzzzz/icons/Weea.dmi'
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'
	icon_state = "mp40"
	inhand_icon_state = "mp40"
	slot_flags = ITEM_SLOT_BELT
	resistance_flags = FIRE_PROOF
	fire_sound = 'white/Wzzzz/Gunshot_light.ogg'
	mag_type = /obj/item/ammo_box/magazine/mp40
	w_class = 4
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 3
	can_bayonet = FALSE
	fire_sound = 'white/Wzzzz/smg_fire.ogg'

/obj/item/ammo_box/magazine/mp40
	name = "MP-40 magazine (c9mm)"
	desc = "A mp40 magazine."
	icon = 'white/Wzzzz/ne_sharu_v_etom.dmi'
	icon_state = "mp40mag"
	inhand_icon_state = "mp40mag"
	caliber = "crgmm"
	ammo_type = /obj/item/ammo_casing/crgmm
	max_ammo = 32
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/projectile/bullet/mp40
	name = "9mm bullet"
	damage = 25
	armour_penetration = 13.5

/obj/item/ammo_casing/crgmm
	name = "9mm bullet casing"
	desc = "A 9mm bullet casing."
	caliber = "crgmm"
	projectile_type = /obj/projectile/bullet/mp40

/obj/item/gun/ballistic/automatic/l6_saw/unrestricted/mg34
	name = "MG-34"
	desc = "German machinegun chambered in 7.92x57mm Mauser ammunition. An utterly devastating support weapon."
	icon = 'white/Wzzzz/icons/Weea.dmi'
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'
	icon_state = "mg34"
	inhand_icon_state = "mg34"
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	fire_sound = 'white/Wzzzz/lmg_fire.ogg'
	mag_type = /obj/item/ammo_box/magazine/a762d
	w_class = WEIGHT_CLASS_HUGE
	fire_delay = 1
	spread = 9
	can_suppress = FALSE
	burst_size = 5
	can_bayonet = FALSE
	force = 10

/obj/item/ammo_box/magazine/a762d
	name = "Mg34 drum magazine (7.92x57mm)"
	desc = "A MG-34 magazine."
	icon = 'white/Wzzzz/icons/mgammo.dmi'
	icon_state = "mg34_drum"
	inhand_icon_state = "mg34_drum"
	caliber = "a792x33"
	ammo_type = /obj/item/ammo_casing/a792x33
	max_ammo = 100
	multiple_sprites = TRUE


/obj/projectile/bullet/a792x33
	name = "a792x33 bullet"
	damage = 25
	armour_penetration = 5

/obj/item/ammo_casing/a792x33
	name = "a792x33 bullet casing"
	desc = "A a792x33 bullet casing."
	caliber = "a792x33"
	projectile_type = /obj/projectile/bullet/a792x33

/obj/item/gun/ballistic/automatic/pistol/mauser
	name = "Mauser C96"
	desc = "German 10mm pistol. Still da, ihr Redner! Du hast das Wort, rede, Genosse Mauser!"
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "mauser"
	w_class = WEIGHT_CLASS_SMALL
	fire_sound = 'white/Wzzzz/Gunshot_light.ogg'
	mag_type = /obj/item/ammo_box/magazine/mauser/battle
	can_suppress = FALSE
	slot_flags = ITEM_SLOT_BELT


/obj/item/ammo_box/magazine/mauser
	name = "Mauser magazine"
	desc = "A mauser magazine."
	icon = 'white/Wzzzz/icons/ammo.dmi'
	icon_state = "meow"
	inhand_icon_state = "meow"
	caliber = "10mm"
	ammo_type = /obj/item/ammo_casing/mauser
	max_ammo = 10

/obj/item/ammo_box/magazine/mauser/battle
	name = "Mauser magazine (10mm battle)"
	ammo_type = /obj/item/ammo_casing/mauserb


/obj/item/ammo_box/magazine/mauser/rubber
	name = "Mauser magazine (10mm rubber)"
	ammo_type = /obj/item/ammo_casing/mauser

/obj/projectile/bullet/pistol/rubberma
	name = "rubber bullet"
	damage = 7
	stamina = 30

/obj/projectile/bullet/pistol/battle
	name = "10mm bullet"
	damage = 23
	armour_penetration = 15

/obj/item/ammo_casing/mauser
	name = "10mm bullet casing."
	desc = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/projectile/bullet/pistol/rubberma

/obj/item/ammo_casing/mauserb
	name = "10mm bullet casing."
	desc = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/projectile/bullet/pistol/battle

/obj/projectile/bullet/rifle/a556
	damage = 50
	armour_penetration = 25

/obj/item/ammo_casing/a556
	desc = "A 5.56mm bullet casing."
	caliber = "a556"
	projectile_type = /obj/projectile/bullet/rifle/a556
	icon = 'white/Wzzzz/icons/ammo.dmi'
	icon_state = "rifle_casing"
	inhand_icon_state = "rifle_casing"

/obj/item/ammo_box/magazine/g43
	name = "magazine (5.56mm)"
	icon_state = "5.56"
	caliber = "a556"
	ammo_type = /obj/item/ammo_casing/a556
	icon = 'white/Wzzzz/icons/ammo.dmi'
	max_ammo = 15
	multiple_sprites = 1

/obj/item/gun/ballistic/automatic/g43
	name = "G-43"
	desc = "Semi-automatic german rifle."
	icon_state = "g43"
	inhand_icon_state = "g43"
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/g43
	fire_sound = 'white/Wzzzz/gunshot3.ogg'
	icon = 'white/Wzzzz/icons/Weea.dmi'
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/back.dmi'
	fire_delay = 10
	burst_size = 1
	actions_types = list()
	mag_display = TRUE
	can_suppress = FALSE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK

/obj/item/gun/ballistic/automatic/ar
	name = "\improper NT-ARG 'Boarder'"
	desc = "Assault rile with special amp."
	icon_state = "arg"
	inhand_icon_state = "arg"
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/m556/arg
	fire_sound = 'white/Wzzzz/gunshot_smg.ogg'
	can_suppress = FALSE
	icon = 'white/Wzzzz/icons/Weea.dmi'
	burst_size = 3
	zoomable = TRUE
	zoom_amt = 8
	zoom_out_amt = 8
	fire_delay = 2

/obj/item/ammo_box/magazine/m556/arg
	name = "arg magazine (5.56mm)"
	icon_state = "arg"
	ammo_type = /obj/item/ammo_casing/m556
	caliber = "m556"
	max_ammo = 30
	icon = 'white/Wzzzz/icons/Ora/ne_sharu_v_etom_vse_eshe.dmi'
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_casing/m556
	name = "5.56mm bullet casing"
	desc = "A 5.56mm bullet casing."
	caliber = "m556"
	projectile_type = /obj/projectile/bullet/m556

/obj/projectile/bullet/m556
	damage = 35
	armour_penetration = 10
	speed = 0.25
	stamina = 15

/obj/item/storage/box/lethalshot/small
	name = "box of lethal shotgun shots"
	desc = "A box full of lethal shots, designed for riot shotguns."
	icon_state = "lethalshot_box"
	illustration = null
	w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/box/rubbershot/small
	name = "box of rubber shots"
	desc = "A box full of rubber shots, designed for riot shotguns."
	icon_state = "rubbershot_box"
	illustration = null
	w_class = WEIGHT_CLASS_SMALL
