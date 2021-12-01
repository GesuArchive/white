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
	name = "ящик с патронами (7.92x57)"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/a792x57
	max_ammo = 14

/obj/item/ammo_box/magazine/a792x57
	name = "зарядник (7.92x57mm)"
	icon = 'white/Wzzzz/icons/ammo.dmi'
	icon_state = "kclip"
	caliber = "a792x57"
	ammo_type = /obj/item/ammo_casing/a792x57
	max_ammo = 5
	multiple_sprites = TRUE

/obj/item/ammo_box/magazine/a792x57/empty
	start_empty = TRUE

/obj/item/ammo_casing/a792x57
	name = "гильза 7.92x57mm"
	caliber = "a792x57"
	projectile_type = /obj/projectile/bullet/a792x57
	icon = 'white/Wzzzz/icons/ammo.dmi'
	icon_state = "rifle_casing"
	inhand_icon_state = "rifle_casing"

/obj/projectile/bullet/a792x57
	damage = 3
	stamina = 5
	speed = 0.4
	armour_penetration = 0

/obj/item/gun/ballistic/rifle/boltaction/kar98k
	name = "болтовка"
	desc = "Настолько старая, что даже порох в патронах успевает быстро устаревать, пока находится в ней."
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "kar98k"
	inhand_icon_state = "kar98k"
	worn_icon_state = "kar98k"
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
	knife_y_offset = 13

/obj/item/gun/ballistic/rifle/boltaction/kar98k/makeJamming() //прикручиваеца в инишалайзе
	return

/obj/item/gun/ballistic/rifle/boltaction/kar98k/Initialize()
	. = ..()
	switch(rand(1, 3))
		if(1)
			name = "старая [name]"
			AddElement(/datum/element/jamming, 10)
			extra_damage = 90
		if(2)
			name = "старая ржавая [name]"
			AddElement(/datum/element/jamming, 15)
			extra_damage = 85
		if(3)
			name = "старая ржавая погнутая [name]"
			AddElement(/datum/element/jamming, 25)
			extra_damage = 80

/obj/item/gun/ballistic/rifle/boltaction/kar98k/empty
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction98/empty

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
		to_chat(user, span_notice("Открываю затвор <b>[src.name]</b>"))
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
		process_chamber(FALSE, FALSE, FALSE)
		bolt_locked = TRUE
		update_icon()
		return
	drop_bolt(user)

/obj/item/gun/ballistic/rifle/boltaction/kar98k/scope
	name = "болтовка с оптикой"
	desc = "Настолько старая, что даже порох в патронах успевает быстро устаревать, пока находится в ней. Эта имеет оптический прицел."
	icon_state = "kar98k_scope"
	inhand_icon_state = "kar98k_scope"
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	actions_types = list()

/obj/item/gun/ballistic/rifle/boltaction/kar98k/scope/update_icon(var/add_scope = FALSE)
	if (bolt_locked == FALSE)
		icon_state = "kar98k_scope_open"
		inhand_icon_state = "kar98k_scope_open"
	else
		icon_state = "kar98k_scope"
		inhand_icon_state = "kar98k_scope"

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
	name = "циркулярная пила"
	desc = "Режет неплохо всё, кроме стали."
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

/obj/item/shovel/spade/wzzz
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "german_shovel2"
	inhand_icon_state = "german_shovel2"
	righthand_file = 'white/Wzzzz/icons/Weear.dmi'
	lefthand_file = 'white/Wzzzz/icons/Weeal.dmi'
	throwforce = 11
	force = 12

/obj/item/pickaxe/silver
	name = "костяная кирка"
	desc = "Импровизируйте свою жизнь с помощью костей и дерева."
	toolspeed = 0.2
	force = 12
	throwforce = 8
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "pickaxe_bone"
	inhand_icon_state = "pickaxe_bone"

/obj/item/clothing/mask/cigarette/pipe/cobpipe
	icon = 'white/Wzzzz/icons/Weea.dmi'
	name = "pipe"
