/*
Arrow&bow
*/
/obj/item/reagent_containers/syringe/arrow
	name = "Arrow"
	desc = "A arrow that can hold up to 5 units."
	icon = 'icons/obj/projectiles.dmi'
	inhand_icon_state = "arrow"
	icon_state = "arrow"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list()
	volume = 5
	mode = SYRINGE_DRAW
	busy = FALSE
	proj_piercing = 0
	//materials = list(/datum/material/iron=10, /datum/material/glass=20)
	//container_type = TRANSPARENT

/obj/item/reagent_containers/syringe/arrow/update_icon()
	cut_overlays()

/obj/projectile/bullet/dart/syringe/bow//Arrow
	name = "arrow"
	icon_state = "bolter"
	damage = 10
	piercing = FALSE

/obj/item/ammo_casing/syringegun/bow//Bow chamber
	name = "Arrow"
	desc = "A high-power spring that throws arrows."
	projectile_type = /obj/projectile/bullet/dart/syringe/bow
	firing_effect_type = null

/obj/item/gun/syringe/bow//Bow
	name = "Bow"
	desc = "Bow"
	icon_state = "bow_unloaded"
	inhand_icon_state = "bow_unloaded"
	force = 10

/obj/item/gun/syringe/bow/examine(mob/user)
	..()
	to_chat(user, "Can hold [max_syringes] arrow\s. Has [syringes.len] arrow\s remaining.")

/obj/item/gun/syringe/bow/Initialize()
	. = ..()

	chambered = new /obj/item/ammo_casing/syringegun/bow(src)

/obj/item/gun/syringe/bow/attackby(obj/item/A, mob/user, params, show_msg = TRUE)
	if(istype(A, /obj/item/reagent_containers/syringe/arrow))
		if(syringes.len < max_syringes)
			if(!user.transferItemToLoc(A, src))
				return FALSE
			to_chat(user, span_notice("You load [A] into <b>[src.name]</b>."))
			syringes += A
			recharge_newshot()
			return TRUE
		else
			to_chat(user, span_warning("[capitalize(src.name)] cannot hold more syringes!"))
	return FALSE

/datum/crafting_recipe/bow_h
	name = "Bow"
	result = /obj/item/gun/syringe/bow
	reqs = list(/obj/item/stack/cable_coil = 5,/obj/item/stack/sheet/mineral/wood = 10)
	time = 100
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/arrow_h
	name = "Arrow"
	result = /obj/item/reagent_containers/syringe/arrow
	reqs = list(/obj/item/stack/rods = 1)
	tool_behaviors = list(TOOL_WIRECUTTER)
	time = 25
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON

//M41A

/obj/item/gun/ballistic/automatic/M41A
	name = "M41A rifle"
	desc = "Rifle."
	icon = 'white/qwaszx000/sprites/M41A.dmi'
	icon_state = "M41A"
	inhand_icon_state = "M41A"
	mag_type = /obj/item/ammo_box/magazine/m41a
	pin = /obj/item/firing_pin
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 5
	actions_types = list(/datum/action/item_action/toggle_firemode)
	can_bayonet = FALSE
	lefthand_file = 'white/qwaszx000/sprites/left_hand.dmi'
	righthand_file = 'white/qwaszx000/sprites/right_hand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	fire_sound = 'white/qwaszx000/sounds/pulse_rifle_01.ogg'

/obj/item/gun/ballistic/automatic/M41A/update_icon()
	..()
	if(magazine)
		icon_state = "M41A"
		if(magazine.ammo_count() <= 0)
			icon_state = "M41A_noammo"
	else
		icon_state = "M41A_withoutmag"

/obj/item/ammo_box/magazine/m41a
	name = "m41a magazine"
	icon = 'white/qwaszx000/sprites/M41A.dmi'
	icon_state = "ammo"
	ammo_type = /obj/item/ammo_casing/c46x30mm
	caliber = "4.6x30mm"
	max_ammo = 30

/obj/item/ammo_box/magazine/m41a/update_icon()
	..()
	if(ammo_count() <= 0)
		icon_state = "ammo_e"
	else
		icon_state = "ammo"

/*
 * New taser


//old definition, keeping it here for whatever
see 'white/RedFoxIV/code/obj/weapons/misc.dm'

/obj/item/gun/ballistic/stabba_taser
	name = "Стабба тазер"
	desc = "Двухзарядный тазер, стреляющий застревающими в теле электродами."
	icon = 'white/qwaszx000/sprites/stabba_taser.dmi'
	icon_state = "taser_gun"
	inhand_icon_state = "stabba_taser"
	lefthand_file = 'white/qwaszx000/sprites/stabba_taser_left.dmi'
	righthand_file = 'white/qwaszx000/sprites/stabba_taser_right.dmi'
	pin = /obj/item/firing_pin
	bolt_type = BOLT_TYPE_NO_BOLT
	mag_type = /obj/item/ammo_box/magazine/internal/stabba_taser_magazine
	fire_delay = 5
	internal_magazine = TRUE

/obj/item/ammo_box/magazine/internal/stabba_taser_magazine
	name = "Магазин стабба тазера. Если вы видите это, сообщите администратору."
	icon = null
	icon_state = null
	ammo_type = /obj/item/ammo_casing/caseless/stabba_taser_projectile_casing
	caliber = "taser"
	max_ammo = 2
	start_empty = FALSE

/obj/item/ammo_box/magazine/internal/stabba_taser_magazine/give_round(obj/item/ammo_casing/R, replace_spent = 1)
	return ..(R,1)

/obj/item/ammo_casing/caseless/stabba_taser_projectile_casing
	name = "картридж стабба тазера"
	desc = "Одноразовый картридж"
	icon = 'white/qwaszx000/sprites/stabba_taser.dmi'
	icon_state = "taser_projectile"
	throwforce = 1
	projectile_type = /obj/projectile/bullet/stabba_taser_projectile
	firing_effect_type = null
	caliber = "taser"
	heavy_metal = FALSE

/obj/projectile/bullet/stabba_taser_projectile
	name = "Электродик Стаббы"
	desc = "Выглядит остро"
	icon = 'white/qwaszx000/sprites/stabba_taser.dmi'
	icon_state = "taser_projectile"
	damage = 0
	nodamage = TRUE
	stamina = 8
	speed = 2 // Летит в 2 раза быстрее чем другие прожектайлы
	range = 12
	embedding = list(embed_chance=95, fall_chance=10, pain_stam_pct=8, pain_mult=1, pain_chance=75)

 * XVII-XVIII rifle
 */

/obj/item/gun/ballistic/xviii_rifle
	name = "Винтовка 18 века"
	desc = "Vive la france"
	icon = 'white/qwaszx000/sprites/xvii_xviii_weapons.dmi'
	icon_state = "rifle_france"
	spread = 25
	recoil = 1
	fire_sound = 'white/qwaszx000/sounds/xviii_rifle_fire.ogg'
	/*inhand_icon_state = "stabba_taser"
	lefthand_file = 'white/qwaszx000/sprites/stabba_taser_left.dmi'
	righthand_file = 'white/qwaszx000/sprites/stabba_taser_right.dmi'*/
	//pin = /obj/item/firing_pin
	mag_type = null
	internal_magazine = TRUE
	can_bayonet = TRUE

	var/is_ready_to_fire = FALSE
	var/is_cartrige_prepared = FALSE
	var/is_preparing_action = FALSE
	var/cartrige_type = /obj/item/ammo_casing/caseless/xviii_rifle_cartrige



/obj/item/gun/ballistic/xviii_rifle/Initialize()
	..()
	magazine = null
	chambered = new cartrige_type


/obj/item/gun/ballistic/xviii_rifle/examine(mob/user)
	. = ..()
	. += "<hr>"
	if(chambered)
		. += "Бумажный патрон заряжен " + (is_cartrige_prepared ? "<b>и протолкнут</b>" : "<b>но не протолкнут</b></br>")
	if(is_ready_to_fire)
		. += "Курок взведен"

/obj/item/gun/ballistic/xviii_rifle/attack_self(mob/living/user)
	if(is_preparing_action)
		return

	//cartrige is loaded, but not pushed down
	if(!is_cartrige_prepared && chambered)
		is_preparing_action = TRUE
		if (do_after(user, 3 SECONDS, 0) && is_preparing_action)
			is_preparing_action = FALSE
			to_chat(user, "Вы проталкиваете бумажный патрон с помощью шомпола")
			is_cartrige_prepared = TRUE
		return

	if(!is_ready_to_fire)
		to_chat(user, "Вы взводите курок винтовки 18 века")
		icon_state = "rifle_france_ready"
		is_ready_to_fire = TRUE
		update_icon()
		return
	..()

/obj/item/gun/ballistic/xviii_rifle/attackby(obj/item/A, mob/user, params)
	//Loading from ammo box is forbidden
	if(istype(A, /obj/item/ammo_box))
		return FALSE

	if (istype(A, /obj/item/ammo_casing))
		//only paper cartriges is allowed
		if(istype(A, /obj/item/ammo_casing/caseless/xviii_rifle_cartrige) && !chambered)
			A.forceMove(src)
			user.transferItemToLoc(A, src, TRUE)
			chambered = A
			return
		return FALSE

	if(istype(A, /obj/item/kitchen/knife) && !istype(A, /obj/item/kitchen/knife/xviii_rifle_bayonet))
		return FALSE

	..()

/obj/item/gun/ballistic/xviii_rifle/can_shoot()
	return is_cartrige_prepared && is_ready_to_fire && chambered

/obj/item/gun/ballistic/xviii_rifle/shoot_live_shot(mob/living/user, pointblank = 0, atom/pbtarget = null, message = 1)
	..()
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(0, loc)
	smoke.start()
	is_cartrige_prepared = FALSE
	is_ready_to_fire = FALSE
	icon_state = "rifle_france"

/obj/item/gun/ballistic/xviii_rifle/shoot_with_empty_chamber(mob/living/user as mob|obj)
	if(!is_ready_to_fire)
		return
	. = ..()
	is_ready_to_fire = FALSE
	icon_state = "rifle_france"

/obj/item/ammo_casing/caseless/xviii_rifle_cartrige
	name = "Бумажный патрон винтовки 18 века"
	desc = "Будет больно"
	icon = 'white/qwaszx000/sprites/xvii_xviii_weapons.dmi'
	icon_state = "paper_cartrige"
	throwforce = 1
	projectile_type = /obj/projectile/bullet/xviii_rifle_bullet
	firing_effect_type = null
	caliber = "taser"
	heavy_metal = FALSE

/obj/projectile/bullet/xviii_rifle_bullet
	name = "Пуля 18 века"
	desc = "Обычный стальной шар... До тех пор, пока он не летит в тебя"
	icon = 'white/qwaszx000/sprites/xvii_xviii_weapons.dmi'
	icon_state = "bullet"
	damage = 70
	stamina = 10
	speed = 1
	range = 40
	embedding = list(embed_chance=50, fall_chance=25, pain_mult=1, pain_chance=30)


/obj/projectile/bullet/xviii_rifle_bullet/on_hit(atom/target, blocked = FALSE, pierce_hit)
	if(istype(target, /mob/living/carbon/))
		var/mob/living/carbon/C = target
		var/obj/item/bodypart/hit_limb
		hit_limb = C.get_bodypart(C.check_limb_hit(def_zone))
		hit_limb.force_wound_upwards(/datum/wound/blunt/critical)
	..()


/*
 * Bayonet for XVIII rifle
 */
/obj/item/kitchen/knife/xviii_rifle_bayonet
	name = "XVIII rifle bayonet"
	desc = "Штык для винтовки 18 века"
	icon = 'white/qwaszx000/sprites/xvii_xviii_weapons.dmi'
	icon_state = "rifle_france_bayonet"
	bayonet = TRUE
	force = 20
