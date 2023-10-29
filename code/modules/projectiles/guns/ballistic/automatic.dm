/obj/item/gun/ballistic/automatic
	w_class = WEIGHT_CLASS_NORMAL
	can_suppress = TRUE
	burst_size = 3
	fire_delay = 2
	actions_types = list(/datum/action/item_action/toggle_firemode)
	semi_auto = TRUE
	var/auto_fire = TRUE
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	fire_sound_volume = 90
	vary_fire_sound = FALSE
	rack_sound = 'sound/weapons/gun/smg/smgrack.ogg'
	suppressed_sound = 'sound/weapons/gun/smg/shot_suppressed.ogg'
	var/select = 1 ///fire selector position. 1 = semi, 2 = burst. anything past that can vary between guns.
	var/selector_switch_icon = FALSE ///if it has an icon for a selector switch indicating current firemode.

/obj/item/gun/ballistic/automatic/Initialize(mapload)
	. = ..()
	if(auto_fire)
		make_auto() //Один хер эту штуку оверрайдит прок выдачи другой задержки стрельбы


/obj/item/gun/ballistic/automatic/proc/make_auto()
	AddComponent(/datum/component/automatic_fire, (fire_delay * 0.15) SECONDS)

/obj/item/gun/ballistic/automatic/update_overlays()
	. = ..()
	if(!selector_switch_icon)
		return
	if(!select)
		. += "[initial(icon_state)]_semi"
	if(select == 1)
		. += "[initial(icon_state)]_burst"

/obj/item/gun/ballistic/automatic/ui_action_click(mob/user, actiontype)
	if(istype(actiontype, /datum/action/item_action/toggle_firemode))
		burst_select()
	else
		..()

/obj/item/gun/ballistic/automatic/proc/burst_select()
	var/mob/living/carbon/human/user = usr
	select = !select
	if(!select)
		burst_size = 1
		fire_delay = 0
		to_chat(user, span_notice("Переключаюсь на  [auto_fire ? "автоматический" : "полуавтоматический"] режим."))
	else
		burst_size = initial(burst_size)
		fire_delay = initial(fire_delay)
		to_chat(user, span_notice("Переключаюсь на стрельбу очередями по [burst_size] пули за выстрел."))

	playsound(user, 'sound/weapons/empty.ogg', 100, TRUE)
	update_icon()
	update_item_action_buttons()

/obj/item/gun/ballistic/automatic/proto
	name = "пистолет-пулемет Saber"
	desc = "Прототип полноавтоматического 9-мм пистолета-пулемета, получившего обозначение \"Saber\". Имеет резьбу для глушителя."
	icon_state = "saber"
	burst_size = 1
	actions_types = list()
	mag_display = TRUE
	empty_indicator = TRUE
	mag_type = /obj/item/ammo_box/magazine/smgm9mm
	pin = null
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE

/obj/item/gun/ballistic/automatic/proto/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.2 SECONDS)


/obj/item/gun/ballistic/automatic/proto/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/automatic/c20r
	name = "пистолет-пулемет С-20р"
	desc = "Булл-пап пистолет-пулемет .45 калибра, известный как \"C-20р\". На прикладе имеется надпись 'Scarborough Arms - Per falcis, per pravitas'."
	icon_state = "c20r"
	inhand_icon_state = "c20r"
	selector_switch_icon = TRUE
	mag_type = /obj/item/ammo_box/magazine/smgm45
	fire_delay = 2
	burst_size = 3
	pin = /obj/item/firing_pin/implant/pindicate
	can_bayonet = TRUE
	knife_x_offset = 26
	knife_y_offset = 12
	mag_display = TRUE
	mag_display_ammo = TRUE
	empty_indicator = TRUE

/obj/item/gun/ballistic/automatic/c20r/update_overlays()
	. = ..()
	if(!chambered && empty_indicator) //this is duplicated due to a layering issue with the select fire icon.
		. += "[icon_state]_empty"

/obj/item/gun/ballistic/automatic/c20r/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/automatic/c20r/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/gun/ballistic/automatic/wt550
	name = "пистолет-пулемет ВТ-550"
	desc = "Устаревшее оружие личной обороны, именуемое как \"Пистолет-Пулемет ВТ-550\". Использует патроны 4.6x30mm калибра. На данный момент снято с вооружения."
	icon_state = "wt550"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "arg"
	mag_type = /obj/item/ammo_box/magazine/wt550m9
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 1
	actions_types = list()
	can_bayonet = TRUE
	knife_x_offset = 25
	knife_y_offset = 12
	mag_display = TRUE
	mag_display_ammo = TRUE
	empty_indicator = TRUE

/obj/item/gun/ballistic/automatic/wt550/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.3 SECONDS)

/obj/item/gun/ballistic/automatic/plastikov
	name = "пистолет-пулемет ПП-95"
	desc = "Древняя модель 9-мм пистолета-пулемета, обновленная и сделанная максимально дешёвой. <b>Слишком</b> дешёвой."
	icon_state = "plastikov"
	inhand_icon_state = "plastikov"
	mag_type = /obj/item/ammo_box/magazine/plastikov9mm
	burst_size = 5
	spread = 25
	can_suppress = FALSE
	actions_types = list()
	mag_display = TRUE
	empty_indicator = TRUE
	fire_sound = 'sound/weapons/gun/smg/shot_alt.ogg'

/obj/item/gun/ballistic/automatic/mini_uzi
	name = "пистолет-пулемет Uzi-U3"
	desc = "Легкий пистолет-пулемёт, обладающий режимом стрельбы очередями, когда вы действительно хотите кого-то убить. Использует патроны калибра 9мм."
	icon_state = "miniuzi"
	mag_type = /obj/item/ammo_box/magazine/uzim9mm
	burst_size = 2
	bolt_type = BOLT_TYPE_OPEN
	show_bolt_icon = FALSE
	mag_display = TRUE
	rack_sound = 'sound/weapons/gun/pistol/slide_lock.ogg'

/obj/item/gun/ballistic/automatic/m90
	name = "пистолет-пулемет М-90гр"
	desc = "Автоматический карабин 5.56 калибра, известный как 'М-90гр'. Имеет встроенный гранатомёт.\"Стрелять на ПКМ\"."
	icon_state = "m90"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "m90"
	selector_switch_icon = TRUE
	mag_type = /obj/item/ammo_box/magazine/m556
	can_suppress = FALSE
	auto_fire =  TRUE
	var/obj/item/gun/ballistic/revolver/grenadelauncher/underbarrel
	burst_size = 3
	fire_delay = 2
	spread = 5
	pin = /obj/item/firing_pin/implant/pindicate
	mag_display = TRUE
	empty_indicator = TRUE
	fire_sound = 'sound/weapons/gun/smg/shot_alt.ogg'

/obj/item/gun/ballistic/automatic/m90/Initialize(mapload)
	. = ..()
	underbarrel = new /obj/item/gun/ballistic/revolver/grenadelauncher(src)
	update_icon()

/obj/item/gun/ballistic/automatic/m90/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/automatic/m90/unrestricted/Initialize(mapload)
	. = ..()
	underbarrel = new /obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted(src)
	update_icon()

/obj/item/gun/ballistic/automatic/m90/afterattack(atom/target, mob/living/user, flag, params)
	if(select == 2)
		underbarrel.afterattack(target, user, flag, params)
	else
		return ..()

/obj/item/gun/ballistic/automatic/m90/afterattack_secondary(atom/target, mob/living/user, flag, params)
	underbarrel.afterattack(target, user, flag, params)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/automatic/m90/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_casing))
		if(istype(A, underbarrel.magazine.ammo_type))
			underbarrel.attack_self(user)
			underbarrel.attackby(A, user, params)
	else
		..()

/obj/item/gun/ballistic/automatic/m90/update_overlays()
	. = ..()
	switch(select)
		if(0)
			. += "[initial(icon_state)]_burst"
		if(1)
			. += "[initial(icon_state)]_gren"



/obj/item/gun/ballistic/automatic/tommygun
	name = "пистолет-пулемёт Томпсона"
	desc = "На основе классической \"Чикагской пишущей машинки\"."
	icon_state = "tommygun"
	inhand_icon_state = "shotgun"
	selector_switch_icon = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/tommygunm45
	can_suppress = FALSE
	burst_size = 1
	actions_types = list()
	fire_delay = 1
	bolt_type = BOLT_TYPE_OPEN
	empty_indicator = TRUE
	show_bolt_icon = FALSE

/obj/item/gun/ballistic/automatic/tommygun/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.1 SECONDS)

/obj/item/gun/ballistic/automatic/ar
	name = "NT-ARG 'Boarder'"
	desc = "Робастная штурмовая винтовка, используемая боевыми силами НТ."
	icon_state = "arg"
	inhand_icon_state = "arg"
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/m556
	can_suppress = FALSE
	burst_size = 3
	fire_delay = 1


// L6 SAW //

/obj/item/gun/ballistic/automatic/l6_saw
	name = "L6 SAW"
	desc = "Сильно модифицированный ручной пулемет, так же известен как \"L6 SAW\". На ресивере можно увидеть надпись \"Aussec Armoury - 2531\". Использует патроны 7.12x82мм калибра."
	icon_state = "l6"
	inhand_icon_state = "l6"
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/mm712x82
	weapon_weight = WEAPON_HEAVY
	burst_size = 1
	actions_types = list()
	can_suppress = FALSE
	spread = 7
	pin = /obj/item/firing_pin/implant/pindicate
	bolt_type = BOLT_TYPE_OPEN
	show_bolt_icon = FALSE
	mag_display = TRUE
	mag_display_ammo = TRUE
	tac_reloads = FALSE
	fire_sound = 'sound/weapons/gun/l6/shot.ogg'
	rack_sound = 'sound/weapons/gun/l6/l6_rack.ogg'
	suppressed_sound = 'sound/weapons/gun/general/heavy_shot_suppressed.ogg'
	var/cover_open = FALSE

/obj/item/gun/ballistic/automatic/l6_saw/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/automatic/l6_saw/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(/datum/component/automatic_fire, 0.2 SECONDS)

/obj/item/gun/ballistic/automatic/l6_saw/examine(mob/user)
	. = ..()
	. += "<hr><b>ALT + клик</b>, чтобы [cover_open ? "открыть" : "закрыть"] противопылевой чехол."
	if(cover_open && magazine)
		. += span_notice("\nМожно использовать <b>пустую руку</b> для извлечения магазина.")


/obj/item/gun/ballistic/automatic/l6_saw/AltClick(mob/user)
	if(!user.canUseTopic(src))
		return
	cover_open = !cover_open
	to_chat(user, span_notice("[cover_open ? "Открываю" : "Закрываю"] покрытие [src]."))
	playsound(src, 'sound/weapons/gun/l6/l6_door.ogg', 60, TRUE)
	update_icon()

/obj/item/gun/ballistic/automatic/l6_saw/update_icon_state()
	. = ..()
	inhand_icon_state = "[initial(icon_state)][cover_open ? "open" : "closed"][magazine ? "mag":"nomag"]"

/obj/item/gun/ballistic/automatic/l6_saw/update_overlays()
	. = ..()
	. += "l6_door_[cover_open ? "open" : "closed"]"


/obj/item/gun/ballistic/automatic/l6_saw/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params)
	if(cover_open)
		to_chat(user, span_warning("У [src.name] не закрыта крышка! Надо бы закрыть перед стрельбой!"))
		return
	else
		. = ..()
		update_icon()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/gun/ballistic/automatic/l6_saw/attack_hand(mob/user)
	if (loc != user)
		..()
		return
	if (!cover_open)
		to_chat(user, span_warning("У [src.name] крышка закрыта! Перед выемкой магазина стоит открыть!"))
		return
	..()

/obj/item/gun/ballistic/automatic/l6_saw/attackby(obj/item/A, mob/user, params)
	if(!cover_open && istype(A, mag_type))
		to_chat(user, span_warning("У [src.name] пылезащитный чехол предотвращает подгонку магазина."))
		return
	..()



// SNIPER //

/obj/item/gun/ballistic/automatic/sniper_rifle
	name = "снайперская винтовка"
	desc = "Дальнобойное оружие, наносящее значительный урон. Нет, вы не можете делать квикскоп."
	icon_state = "sniper"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "sniper"
	worn_icon_state = null
	auto_fire = FALSE
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	fire_sound_volume = 90
	vary_fire_sound = FALSE
	load_sound = 'sound/weapons/gun/sniper/mag_insert.ogg'
	rack_sound = 'sound/weapons/gun/sniper/rack.ogg'
	suppressed_sound = 'sound/weapons/gun/general/heavy_shot_suppressed.ogg'
	recoil = 2
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/sniper_rounds
	fire_delay = 4 SECONDS
	burst_size = 1
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BACK
	actions_types = list()
	mag_display = TRUE
	suppressor_x_offset = 3
	suppressor_y_offset = 3

/obj/item/gun/ballistic/automatic/sniper_rifle/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2)

/obj/item/gun/ballistic/automatic/sniper_rifle/reset_semicd()
	. = ..()
	if(suppressed)
		playsound(src, 'sound/machines/eject.ogg', 25, TRUE, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)
	else
		playsound(src, 'sound/machines/eject.ogg', 50, TRUE)

/obj/item/gun/ballistic/automatic/sniper_rifle/syndicate
	name = "снайперская винтовка синдиката"
	desc = "Незаконно модифицированная снайперская винтовка .50-го калибра, с возможностью установки глушителя. «Ноускоп» всё еще не работает."
	can_suppress = TRUE
	can_unsuppress = TRUE
	pin = /obj/item/firing_pin/implant/pindicate

// Old Semi-Auto Rifle //

/obj/item/gun/ballistic/automatic/surplus
	name = "самозарядная винтовка"
	desc = "Одна из бесчисленных устаревших винтовок, которая до сих пор используется в качестве дешевого средства устрашения. Использует патроны калибра 10мм, а её громоздкая рама не позволяет стрелять лишь одной рукой."
	icon_state = "surplus"
	inhand_icon_state = "moistnugget"
	worn_icon_state = null
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/m10mm/rifle
	auto_fire = FALSE
	fire_delay = 30
	burst_size = 1
	can_unsuppress = TRUE
	can_suppress = TRUE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK
	actions_types = list()
	mag_display = TRUE

// Laser rifle (rechargeable magazine) //

/obj/item/gun/ballistic/automatic/laser
	name = "лазерная винтовка"
	desc = "Несмотря на ее слабость в огне, её достоинство - самоперезаряжающийся магазин. Это оружие сделало немало побед НТ."
	icon_state = "oldrifle"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "arg"
	mag_type = /obj/item/ammo_box/magazine/recharge
	mag_display_ammo = FALSE
	mag_display = TRUE
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 0
	actions_types = list()
	fire_sound = 'sound/weapons/laser.ogg'
	casing_ejector = FALSE

/obj/item/gun/ballistic/automatic/evgenii
	name = "автоматический дробовик \"Евгений\""
	desc = "Простая винтовка, которая разорвёт твоего противника нахуй."
	icon = 'white/valtos/icons/gun.dmi'
	lefthand_file = 'white/valtos/icons/lefthand_big.dmi'
	righthand_file = 'white/valtos/icons/righthand_big.dmi'
	icon_state = "evgenii"
	inhand_icon_state = "evgenii"
	fire_sound = 'white/valtos/sounds/fallout/gunsounds/assault/graar.ogg'
	rack_sound = 'sound/weapons/gun/shotgun/rack.ogg'
	load_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_OCLOTHING
	mag_type = /obj/item/ammo_box/magazine/evgenii
	can_suppress = FALSE
	burst_size = 1
	fire_delay = 0
	mag_display = TRUE
	internal_magazine = FALSE
	tac_reloads = TRUE
	actions_types = list()

/obj/item/gun/ballistic/automatic/evgenii/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(/datum/component/automatic_fire, 0.1 SECONDS)

/obj/item/gun/ballistic/automatic/evgenii/update_icon_state()
	. = ..()
	inhand_icon_state = "[initial(icon_state)][magazine ? "_mag":""]"

/obj/item/ammo_box/magazine/evgenii
	name = "странный магазин"
	icon = 'white/valtos/icons/mags.dmi'
	icon_state = "hornet"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	caliber = "shotgun"
	max_ammo = 3

/obj/item/ammo_box/magazine/evgenii/fuckyou
	max_ammo = 500

/obj/item/gun/ballistic/automatic/evgenii/fuckyou
	mag_type = /obj/item/ammo_box/magazine/evgenii/fuckyou

/obj/item/gun/ballistic/automatic/carbine
	name = "assault carbine"
	desc = "The assault rifle is new standart automatic weapon"
	icon_state = "carbinex"
	inhand_icon_state = "carbinex"
	w_class = 4
	force = 10
	fire_sound = 'sound/weapons/gun/rifle/batrifle_fire.ogg'
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/carbine
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 3
	can_bayonet = FALSE

/obj/item/gun/ballistic/automatic/assault_rifle
	name = "assault rifle"
	desc = "Standart assault rifle."
	icon_state = "arifle"
	burst_size = 3
	inhand_icon_state = "arifle"
	w_class = 4
	force = 10
	fire_delay = 2
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/assault_rifle
	can_suppress = FALSE
	can_bayonet = FALSE
	fire_sound = 'sound/weapons/gun/rifle/gunshot3z.ogg'

/obj/item/gun/ballistic/automatic/m90/unrestricted/z8
	name = "bullpup assault rifle"
	desc = "The Z8 Bulldog is an older model bullpup carbine, made by the now defunct Zendai Foundries. Uses armor piercing 5.56mm rounds. Makes you feel like a space marine when you hold it."
	icon_state = "carbine"
	inhand_icon_state = "carbine"
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	fire_sound = 'sound/weapons/gun/rifle/gunshot3.ogg'
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/a556carbine
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 3
	can_bayonet = FALSE
