//  Граната с колючей проволокой
/obj/structure/barbed_wire
	name = "колючая проволока"
	desc = "Очень колючая и постоянно цепляется."
	icon = 'white/Feline/icons/barb_wire.dmi'
	icon_state = "barb_wire_1"
	anchored = TRUE
	density = FALSE
	max_integrity = 200
	force = 8
	var/destroy_stacks = 4

//  Размещение и колючесть
/obj/structure/barbed_wire/Initialize(mapload)
	AddComponent(/datum/component/caltrop, min_damage = force)
	icon_state = pick("barb_wire_1", "barb_wire_2", "barb_wire_3", "barb_wire_4")

	var/turf/open/T = get_turf(src)
	T.slowdown = 2
	. = ..()

/obj/structure/barbed_wire/attack_hand(mob/user)
	var/mob/living/carbon/human/H = user
	if(istype(H))
		var/obj/item/bodypart/affecting = H.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
		if(affecting?.receive_damage(5,0,15))
			user.do_attack_animation(src)
			H.update_damage_overlays()
	. = ..()

/obj/structure/barbed_wire/attack_animal(mob/living/user)
	var/mob/living/simple_animal/H = user
	if(istype(H))
		user.adjustBruteLoss(15)
		return ..()

/obj/structure/barbed_wire/attack_paw(mob/living/user)
	user.adjustBruteLoss(15)
	return ..()

/obj/structure/barbed_wire/attack_alien(mob/living/user)
	var/mob/living/carbon/alien/H = user
	if(istype(H))
		user.adjustBruteLoss(10)
		return ..()

/obj/structure/barbed_wire/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WIRECUTTER)
		to_chat(user, span_notice("Перекусываю колючую проволоку."))
		if(!do_after(user, 1 SECONDS, src))
			return TRUE
		playsound(user, 'sound/items/wirecutter.ogg', 100, TRUE)
		Destroy()
	else
		if(destroy_stacks <= 0)
			..()
			Destroy()
		else
			destroy_stacks = destroy_stacks - 1
			return ..()

/obj/structure/barbed_wire/Destroy()
	var/turf/open/T = get_turf(src)
	T.slowdown = initial(T.slowdown)

	return ..()

/obj/structure/barbed_wire/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(isliving(mover))
		if(prob(20))
			to_chat(mover, span_danger("Застреваю в колючей проволоке!"))
			return FALSE
	playsound(src, pick('white/Feline/sounds/barb_wire/barb_wire_1.ogg', 'white/Feline/sounds/barb_wire/barb_wire_2.ogg', \
						'white/Feline/sounds/barb_wire/barb_wire_3.ogg', 'white/Feline/sounds/barb_wire/barb_wire_4.ogg', \
						'white/Feline/sounds/barb_wire/barb_wire_5.ogg', 'white/Feline/sounds/barb_wire/barb_wire_6.ogg', \
						'white/Feline/sounds/barb_wire/barb_wire_7.ogg', 'white/Feline/sounds/barb_wire/barb_wire_8.ogg', \
						'white/Feline/sounds/barb_wire/barb_wire_9.ogg', 'white/Feline/sounds/barb_wire/barb_wire_10.ogg'), 60, TRUE)

//  Предмет
/obj/item/grenade/barbed_wire
	name = "заградительная граната"
	desc = "При активации раскручивает колючую проволоку, что значительно замедляет наступающего противника."
	icon = 'white/Feline/icons/barb_wire.dmi'
	icon_state = "barb_wire_grenade"
	inhand_icon_state = "flashbang"
	var/wire_radius = 1.5

/obj/item/grenade/barbed_wire/arm_grenade(mob/user, delayoverride, msg = TRUE, volume = 80)
	var/turf/T = get_turf(src)
	log_grenade(user, T)
	if(user)
		add_fingerprint(user)
		if(msg)
			to_chat(user, span_warning("Активирую заградительную гранату! Детонация через: <b>[capitalize(DisplayTimeText(det_time))]</b>!"))
	playsound(src, 'white/Feline/sounds/barb_wire/barb_wire_deploy_1.ogg', volume, FALSE)
	icon_state = "barb_wire_grenade_active"
	active = TRUE
	SEND_SIGNAL(src, COMSIG_GRENADE_ARMED, det_time, delayoverride)
	addtimer(CALLBACK(src, PROC_REF(detonate)), isnull(delayoverride)? det_time : delayoverride)

/obj/item/grenade/barbed_wire/detonate(mob/living/lanced_by)
	. = ..()
	playsound(src, 'white/Feline/sounds/barb_wire/barb_wire_deploy_2.ogg', 80, FALSE)

	for(var/turf/T in circle_view_turfs(src, wire_radius))
		if(!isclosedturf(T) && (!locate(/obj/structure/barbed_wire) in T.contents))
			new /obj/structure/barbed_wire(T)
	qdel(src)

/obj/item/storage/box/barbed_wire
	name = "коробка с заградительными гранатами"
	desc = "Содержит гранаты которые при активации раскручивает колючую проволоку, что значительно замедляет наступающего противника."
	icon_state = "secbox"
	illustration = "barbed_wire"

/obj/item/storage/box/barbed_wire/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/barbed_wire(src)

/obj/item/storage/box/barrier
	name = "коробка с барьерными гранатами"
	desc = "Содержит гранаты которые при активации раскладываются в полевое укрытие."
	icon_state = "secbox"
	illustration = "barrier"

/obj/item/storage/box/barrier/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/barrier(src)


//  Пневматический замок СБ
/obj/item/door_seal/sb
	name = "пневматический замок СБ"
	desc = "Модернизированная скоба, используемая для блокировки шлюза. В отличии от стандартной модели оснащен сканером карт доступа. Офицеры СБ и командный состав могут заблокировать замок своей ID-картой."
	icon = 'white/Feline/icons/door_seal.dmi'
	icon_state = "door_seal_sb"
	custom_materials = list(/datum/material/iron=5000,/datum/material/plasma=500)

//  Переносной стробоскоп
/obj/item/flasher_portable_item
	name = "стробоскоп"
	desc = "Мобильная установка с яркой лампой внутри. Автоматически срабатывает при детекции движения. Плохо реагирует на медленно двигающиеся объекты. Для корректной работы необходимо разложить. Если не прикручен к полу, то его можно сложить для переноски."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pflash_item"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	inhand_icon_state = "buildpipe"
	custom_materials = list(/datum/material/iron=5000,/datum/material/plasma=500)

//	Разворачивание стробоскопа
/obj/item/flasher_portable_item/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(user.a_intent == INTENT_HELP)
		if(isopenturf(target))
			playsound(src, 'sound/items/ratchet.ogg', 80, FALSE)
			if(!do_after(user, 3 SECONDS, user))
				return TRUE
			var/obj/machinery/flasher/portable/R = new /obj/machinery/flasher/portable(target)
			R.add_fingerprint(user)
			user.visible_message(span_notice("[user] устанавливает стробоскоп.") , span_notice("Устанавливаю стробоскоп."))
			R.add_overlay("pflash-s")
			R.set_anchored(TRUE)
			R.power_change()
			R.proximity_monitor.set_range(2)
			qdel(src)
