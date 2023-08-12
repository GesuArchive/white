/obj/item/flashlight
	name = "фонарик"
	desc = "Источник света в полной тьме."
	custom_price = PAYCHECK_EASY
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	inhand_icon_state = "flashlight"
	worn_icon_state = "flashlight"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=20)
	actions_types = list(/datum/action/item_action/toggle_light)
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_range = 4
	light_power = 1
	light_on = FALSE
	var/on = FALSE
	light_color = "#ffeac1"


/obj/item/flashlight/Initialize(mapload)
	. = ..()
	if(icon_state == "[initial(icon_state)]-on")
		on = TRUE
	update_brightness()

/obj/item/flashlight/proc/update_brightness(mob/user)
	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = initial(icon_state)
	set_light_on(on)
	if(light_system == STATIC_LIGHT)
		update_light()


/obj/item/flashlight/attack_self(mob/user)
	on = !on
	playsound(user, on ? 'sound/weapons/magin.ogg' : 'sound/weapons/magout.ogg', 40, TRUE)
	update_brightness(user)
	update_item_action_buttons()
	return 1

/obj/item/flashlight/suicide_act(mob/living/carbon/human/user)
	if (user.is_blind())
		user.visible_message(span_suicide("[user] is putting [src] close to [user.ru_ego()] eyes and turning it on... but [user.p_theyre()] blind!"))
		return SHAME
	user.visible_message(span_suicide("[user] is putting [src] close to [user.ru_ego()] eyes and turning it on! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (FIRELOSS)

/obj/item/flashlight/attack(mob/living/carbon/M, mob/living/carbon/human/user)
	add_fingerprint(user)
	if(istype(M) && on && (user.zone_selected in list(BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH)))

		if((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		if(!ISADVANCEDTOOLUSER(user))
			to_chat(user, span_warning("У меня не хватает ловкости для этого!"))
			return

		if(!M.get_bodypart(BODY_ZONE_HEAD))
			to_chat(user, span_warning("[M] не имеет головы!"))
			return

		if(light_power < 1)
			to_chat(user, "<span class='warning'>[capitalize(src.name)] недостаточно яркий для этого!</span> ")
			return

		switch(user.zone_selected)
			if(BODY_ZONE_PRECISE_EYES)
				if((M.head && M.head.flags_cover & HEADCOVERSEYES) || (M.wear_mask && M.wear_mask.flags_cover & MASKCOVERSEYES) || (M.glasses && M.glasses.flags_cover & GLASSESCOVERSEYES))
					to_chat(user, span_warning("Мне потребуется снять [(M.head && M.head.flags_cover & HEADCOVERSEYES) ? "этот шлем" : (M.wear_mask && M.wear_mask.flags_cover & MASKCOVERSEYES) ? "эту маску": "эти очки"] сначала!"))
					return

				var/obj/item/organ/eyes/E = M.get_organ_slot(ORGAN_SLOT_EYES)
				if(!E)
					to_chat(user, span_warning("[M] не имеет глаз!"))
					return

				if(M == user)	//they're using it on themselves
					if(M.flash_act(visual = 1))
						M.visible_message(span_notice("[M] светит фонариком себе в глаза.") , span_notice("Свечу фонариком себе в глаза. Ммм..."))
					else
						M.visible_message(span_notice("[M] светит фонариком себе в глаза.") , span_notice("Свечу фонариком себе в глаза."))
				else
					user.visible_message(span_warning("[user] светит фонариком прямо в глаза [M].") , \
						span_danger("Свечу фонариком прямо в глаза [M]."))
					if(M.stat == DEAD || (M.is_blind()) || !M.flash_act(visual = 1)) //mob is dead or fully blind
						to_chat(user, span_warning("Зрачки [M] не реагируют на свет!"))
					else if(M.dna && M.dna.check_mutation(XRAY))	//mob has X-ray vision
						to_chat(user, span_danger("Зрачки [M] сверкают!"))
					else //they're okay!
						to_chat(user, span_notice("Зрачки [M] сужаются."))

			if(BODY_ZONE_PRECISE_MOUTH)

				if(M.is_mouth_covered())
					to_chat(user, span_warning("Мне потребуется снять [(M.head && M.head.flags_cover & HEADCOVERSMOUTH) ? "этот шлем" : "эту маску"] сначала!"))
					return

				var/their = M.ru_ego()

				var/list/mouth_organs = new
				for(var/obj/item/organ/O in M.internal_organs)
					if(O.zone == BODY_ZONE_PRECISE_MOUTH)
						mouth_organs.Add(O)
				var/organ_list = ""
				var/organ_count = LAZYLEN(mouth_organs)
				if(organ_count)
					for(var/I in 1 to organ_count)
						if(I > 1)
							if(I == mouth_organs.len)
								organ_list += ", и "
							else
								organ_list += ", "
						var/obj/item/organ/O = mouth_organs[I]
						organ_list += (O.gender == "plural" ? O.name : " [O.name]")

				var/pill_count = 0
				for(var/datum/action/item_action/hands_free/activate_pill/AP in M.actions)
					pill_count++

				if(M == user)
					var/can_use_mirror = FALSE
					if(isturf(user.loc))
						var/obj/structure/mirror/mirror = locate(/obj/structure/mirror, user.loc)
						if(mirror)
							switch(user.dir)
								if(NORTH)
									can_use_mirror = mirror.pixel_y > 0
								if(SOUTH)
									can_use_mirror = mirror.pixel_y < 0
								if(EAST)
									can_use_mirror = mirror.pixel_x > 0
								if(WEST)
									can_use_mirror = mirror.pixel_x < 0

					M.visible_message(span_notice("[M] светит фонариком себе в рот.") , \
					span_notice("Свечу фонариком себе в рот."))
					if(!can_use_mirror)
						to_chat(user, span_notice("Без зеркала ничего не разглядеть."))
						return
					if(organ_count)
						to_chat(user, span_notice("Внутри моего рта [organ_count > 1 ? "находятся" : "находится"] [organ_list]."))
					else
						to_chat(user, span_notice("У меня во рту нет ничего интересного."))
					if(pill_count)
						to_chat(user, span_notice("У меня во рту есть [pill_count] имплантированн[pill_count > 1 ? "ые таблетки" : "ая таблетка"]."))

				else
					user.visible_message(span_notice("[user] светит фонариком в рот [M].") ,\
						span_notice("Свечу фонариком в рот [M]."))
					if(organ_count)
						to_chat(user, span_notice("Внутри [their] рта [organ_count > 1 ? "находятся" : "находится"] [organ_list]."))
					else
						to_chat(user, span_notice("[M] не имеет ничего необычного в [their] рте."))
					if(pill_count)
						to_chat(user, span_notice("[M] имеет [pill_count] имплантированн[pill_count > 1 ? "ые таблетки" : "ая таблетка"] в [their] зубах."))

	else
		return ..()

/obj/item/flashlight/pen
	name = "светоручка"
	desc = "Фонарик размером с ручку, используется докторами. Также может быть использована для создания голограм больным, чтобы предупредить их о том, что сейчас им окажут помощь."
	icon_state = "penlight"
	inhand_icon_state = ""
	worn_icon_state = "pen"
	flags_1 = CONDUCT_1
	light_range = 2
	var/holo_cooldown = 0

/obj/item/flashlight/pen/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!proximity_flag)
		if(holo_cooldown > world.time)
			to_chat(user, span_warning("[capitalize(src.name)] ещё не готова!"))
			return
		var/T = get_turf(target)
		if(locate(/mob/living) in T)
			new /obj/effect/temp_visual/medical_holosign(T,user) //produce a holographic glow
			holo_cooldown = world.time + 10 SECONDS
			return

// see: [/datum/wound/burn/proc/uv()]
/obj/item/flashlight/pen/paramedic
	name = "светоручка парамедика"
	desc = "Высокомощная УФ светоручка, которая используется для устранения инфекций после сильных ожогов. Не самый лучший вариант для попытки посветить в глаза."
	icon_state = "penlight_surgical"
	/// Our current UV cooldown
	COOLDOWN_DECLARE(uv_cooldown)
	/// How long between UV fryings
	var/uv_cooldown_length = 30 SECONDS
	/// How much sanitization to apply to the burn wound
	var/uv_power = 1

/obj/effect/temp_visual/medical_holosign
	name = "медицинская голотабличка"
	desc = "Небольшая медицинская голотабличка, которая сообщает о том, что сейчас пациенту окажут помощь."
	icon_state = "medi_holo"
	duration = 30

/obj/effect/temp_visual/medical_holosign/Initialize(mapload, creator)
	. = ..()
	playsound(loc, 'sound/machines/ping.ogg', 50, FALSE) //make some noise!
	if(creator)
		visible_message(span_danger("[creator] создаёт голограмму!"))


/obj/item/flashlight/seclite
	name = "крепкий фонарик"
	desc = "Надежный фонарик, используемый службой безопасности."
	icon_state = "seclite"
	inhand_icon_state = "seclite"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	force = 9 // Not as good as a stun baton.
	light_range = 5 // A little better than the standard flashlight.
	hitsound = 'sound/weapons/genhit1.wav'
	light_color = "#ffffff"

// the desk lamps are a bit special
/obj/item/flashlight/lamp
	name = "настольная лампа"
	desc = "Настольная лампа с регулируемым креплением."
	icon_state = "lamp"
	inhand_icon_state = "lamp"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	force = 10
	light_range = 5
	light_system = MOVABLE_LIGHT
	w_class = WEIGHT_CLASS_BULKY
	flags_1 = CONDUCT_1
	custom_materials = null
	on = TRUE
	light_color = "#ffffff"


// green-shaded desk lamp
/obj/item/flashlight/lamp/green
	desc = "Классическая настольная лампа с зелёным абажуром."
	icon_state = "lampgreen"
	inhand_icon_state = "lampgreen"
	light_color = "#f1dcac"


/obj/item/flashlight/lamp/verb/toggle_light()
	set name = "Переключить свет"
	set category = "Объект"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

//Bananalamp
/obj/item/flashlight/lamp/bananalamp
	name = "банановая лампа"
	desc = "Сделать лампу в форме банана может только клоун. Здесь даже есть тупой шнурок."
	icon_state = "bananalamp"
	inhand_icon_state = "bananalamp"
	light_color = "#f1dcac"

// FLARES

/obj/item/flashlight/flare
	name = "сигнальная шашка"
	desc = "Собственность NanoTrasen. Сбоку есть инструкция: \"потяни за шнур, зажги\"."
	w_class = WEIGHT_CLASS_SMALL
	light_range = 7 // Pretty bright.
	icon_state = "flare"
	inhand_icon_state = "flare"
	worn_icon_state = "flare"
	actions_types = list()
	/// How many seconds of fuel we have left
	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500
	heat = 1000
	light_color = LIGHT_COLOR_FLARE
	light_system = MOVABLE_LIGHT
	grind_results = list(/datum/reagent/sulfur = 15)

/obj/item/flashlight/flare/Initialize(mapload)
	. = ..()
	fuel = rand(1600, 2000)

/obj/item/flashlight/flare/process(delta_time)
	open_flame(heat)
	fuel = max(fuel -= delta_time, 0)
	if(fuel <= 0 || !on)
		turn_off()
		if(!fuel)
			icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/ignition_effect(atom/A, mob/user)
	. = fuel && on ? span_notice("[user] поджигает [A.name] используя [src.name] как настоящий засранец.")  : ""

/obj/item/flashlight/flare/proc/turn_off()
	on = FALSE
	force = initial(src.force)
	damtype = initial(src.damtype)
	if(ismob(loc))
		var/mob/U = loc
		update_brightness(U)
	else
		update_brightness(null)

	remove_emitter("spark")
	remove_emitter("smoke")

/obj/item/flashlight/flare/attack_self(mob/user)

	// Usual checks
	if(fuel <= 0)
		to_chat(user, span_warning("[capitalize(src.name)] сгорела!"))
		return
	if(on)
		to_chat(user, span_warning("[capitalize(src.name)] уже горит!"))
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message(span_notice("[user] зажигает [src.name].") , span_notice("Зажигаю [src.name]!"))
		force = on_damage
		damtype = BURN
		if(!istype(src, /obj/item/flashlight/flare/torch))
			add_emitter(/obj/emitter/sparks/flare, "spark", 10)
			add_emitter(/obj/emitter/flare_smoke, "smoke", 9)
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/get_temperature()
	return on * heat

/obj/item/flashlight/flare/torch
	name = "факел"
	desc = "Не дуть!"
	w_class = WEIGHT_CLASS_BULKY
	light_range = 5
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "torch"
	inhand_icon_state = "torch"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	light_color = LIGHT_COLOR_ORANGE
	on_damage = 10
	slot_flags = null

/obj/item/flashlight/flare/torch/Initialize(mapload)
	. = ..()
	fuel = rand(8000, 9000)

/obj/item/flashlight/lantern
	name = "фонарь"
	icon_state = "lantern"
	inhand_icon_state = "lantern"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	desc = "Шахтёрский."
	light_range = 6			// luminosity when on
	light_system = MOVABLE_LIGHT
	light_color = "#e7c16d"

/obj/item/flashlight/lantern/heirloom_moth
	name = "потёртый фонарь"
	desc = "Старый фонарь, который повидал много раз."
	light_range = 4

/obj/item/flashlight/lantern/syndicate
	name = "подозрительный фонарь"
	desc = "ПОДОЗРИТЕЛЬНО..."
	icon_state = "syndilantern"
	inhand_icon_state = "syndilantern"
	light_range = 10

/obj/item/flashlight/lantern/jade
	name = "нефритовый фонарь"
	desc = "Изысканный зеленый фонарь."
	color = LIGHT_COLOR_GREEN
	light_color = LIGHT_COLOR_GREEN

/obj/item/flashlight/slime
	gender = PLURAL
	name = "светящийся экстракт слайма"
	desc = "Экстракт из жёлтого слайма. Излучает невероятно мощный поток света, если сжать его в руке."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "slime"
	inhand_icon_state = "slime"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	custom_materials = null
	light_range = 7 //luminosity when on
	light_system = MOVABLE_LIGHT

/obj/item/flashlight/emp
	var/emp_max_charges = 4
	var/emp_cur_charges = 4
	var/charge_timer = 0
	/// How many seconds between each recharge
	var/charge_delay = 20

/obj/item/flashlight/emp/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/flashlight/emp/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/flashlight/emp/process(delta_time)
	charge_timer += delta_time
	if(charge_timer < charge_delay)
		return FALSE
	charge_timer -= charge_delay
	emp_cur_charges = min(emp_cur_charges+1, emp_max_charges)
	return TRUE

/obj/item/flashlight/emp/attack(mob/living/M, mob/living/user)
	if(on && (user.zone_selected in list(BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH))) // call original attack when examining organs
		..()
	return

/obj/item/flashlight/emp/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(emp_cur_charges > 0)
		emp_cur_charges -= 1

		if(ismob(A))
			var/mob/M = A
			log_combat(user, M, "атакует", "EMP-light")
			M.visible_message(span_danger("[user] щёлкает фонариком в сторону [A.name].") , \
								span_userdanger("[user] щёлкает фонариком в меня."))
		else
			A.visible_message(span_danger("[user] щёлкает фонариком в сторону [A]."))
		to_chat(user, span_notice("О, да! [capitalize(src.name)] теперь имеет [emp_cur_charges] зарядов."))
		A.emp_act(EMP_HEAVY)
	else
		to_chat(user, span_warning("[capitalize(src.name)] скоро перезарядится!"))
	return

/obj/item/flashlight/emp/debug //for testing emp_act()
	name = "debug EMP flashlight"
	emp_max_charges = 100
	emp_cur_charges = 100

// Glowsticks, in the uncomfortable range of similar to flares,
// but not similar enough to make it worth a refactor
/obj/item/flashlight/glowstick
	name = "светящаяся палочка"
	desc = "Военного образца."
	custom_price = PAYCHECK_PRISONER
	w_class = WEIGHT_CLASS_SMALL
	light_range = 4
	light_system = MOVABLE_LIGHT
	color = LIGHT_COLOR_GREEN
	icon_state = "glowstick"
	inhand_icon_state = "glowstick"
	worn_icon_state = "lightstick"
	grind_results = list(/datum/reagent/phenol = 15, /datum/reagent/hydrogen = 10, /datum/reagent/oxygen = 5) //Meth-in-a-stick
	/// How many seconds of fuel we have left
	var/fuel = 0


/obj/item/flashlight/glowstick/Initialize(mapload)
	if(!fuel)
		fuel = rand(3200, 4000)
	set_light_color(color)
	return ..()


/obj/item/flashlight/glowstick/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()


/obj/item/flashlight/glowstick/process(delta_time)
	fuel = max(fuel - delta_time, 0)
	if(fuel <= 0)
		turn_off()
		STOP_PROCESSING(SSobj, src)
		update_icon()

/obj/item/flashlight/glowstick/proc/turn_off()
	on = FALSE
	update_icon()

/obj/item/flashlight/glowstick/update_icon()
	. = ..()
	inhand_icon_state = "glowstick"
	cut_overlays()
	if(fuel <= 0)
		icon_state = "glowstick-empty"
		cut_overlays()
		set_light_on(FALSE)
	else if(on)
		var/mutable_appearance/glowstick_overlay = mutable_appearance(icon, "glowstick-glow")
		glowstick_overlay.color = color
		add_overlay(glowstick_overlay)
		inhand_icon_state = "glowstick-on"
		set_light_on(TRUE)
	else
		icon_state = "glowstick"
		cut_overlays()

/obj/item/flashlight/glowstick/attack_self(mob/user)
	if(fuel <= 0)
		to_chat(user, span_notice("[capitalize(src.name)] кончилась."))
		return
	if(on)
		to_chat(user, span_warning("[capitalize(src.name)] уже горит!"))
		return

	. = ..()
	if(.)
		user.visible_message(span_notice("[user] ломает и трясёт [src.name].") , span_notice("Ломаю и трясу [src.name], включая её!"))
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/glowstick/suicide_act(mob/living/carbon/human/user)
	if(!fuel)
		user.visible_message(span_suicide("[user] пытается squirt [src] fluids into [user.ru_ego()] eyes... but it's empty!"))
		return SHAME
	var/obj/item/organ/eyes/eyes = user.get_organ_slot(ORGAN_SLOT_EYES)
	if(!eyes)
		user.visible_message(span_suicide("[user] пытается squirt [src] fluids into [user.ru_ego()] eyes... but [user.ru_who()] don't have any!"))
		return SHAME
	user.visible_message(span_suicide("[user] is squirting [src] fluids into [user.ru_ego()] eyes! It looks like [user.p_theyre()] trying to commit suicide!"))
	fuel = 0
	return (FIRELOSS)

/obj/item/flashlight/glowstick/red
	name = "красная светящаяся палочка"
	color = COLOR_SOFT_RED

/obj/item/flashlight/glowstick/blue
	name = "синяя светящаяся палочка"
	color = LIGHT_COLOR_BLUE

/obj/item/flashlight/glowstick/cyan
	name = "голубая светящаяся палочка"
	color = LIGHT_COLOR_CYAN

/obj/item/flashlight/glowstick/orange
	name = "оранжевая светящаяся палочка"
	color = LIGHT_COLOR_ORANGE

/obj/item/flashlight/glowstick/yellow
	name = "жёлтая светящаяся палочка"
	color = LIGHT_COLOR_YELLOW

/obj/item/flashlight/glowstick/pink
	name = "розовая светящаяся палочка"
	color = LIGHT_COLOR_PINK

/obj/item/flashlight/glowstick/on
	name = "зеленая светящаяся палочка"
	color = LIGHT_COLOR_BLUE
	on = TRUE
	fuel = 10000

/obj/item/flashlight/glowstick/red/on
	name = "красная светящаяся палочка"
	color = COLOR_SOFT_RED
	on = TRUE
	fuel = 10000

/obj/item/flashlight/glowstick/blue/on
	name = "синяя светящаяся палочка"
	color = LIGHT_COLOR_BLUE
	on = TRUE
	fuel = 10000

/obj/item/flashlight/glowstick/cyan/on
	name = "голубая светящаяся палочка"
	color = LIGHT_COLOR_CYAN
	on = TRUE
	fuel = 10000

/obj/item/flashlight/glowstick/orange/on
	name = "оранжевая светящаяся палочка"
	color = LIGHT_COLOR_ORANGE
	on = TRUE
	fuel = 10000

/obj/item/flashlight/glowstick/yellow/on
	name = "жёлтая светящаяся палочка"
	color = LIGHT_COLOR_YELLOW
	on = TRUE
	fuel = 10000

/obj/item/flashlight/glowstick/pink/on
	name = "розовая светящаяся палочка"
	color = LIGHT_COLOR_PINK
	on = TRUE
	fuel = 10000

/obj/effect/spawner/lootdrop/glowstick
	name = "случайная светящаяся палочка"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "random_glowstick"

/obj/effect/spawner/lootdrop/glowstick/Initialize(mapload)
	loot = typesof(/obj/item/flashlight/glowstick)
	. = ..()

/obj/item/flashlight/spotlight //invisible lighting source
	name = "дискотека"
	desc = "Groovy..."
	icon_state = null
	light_system = MOVABLE_LIGHT
	light_range = 4
	light_power = 10
	alpha = 0
	plane = FLOOR_PLANE
	on = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	///Boolean that switches when a full color flip ends, so the light can appear in all colors.
	var/even_cycle = FALSE
	///Base light_range that can be set on Initialize to use in smooth light range expansions and contractions.
	var/base_light_range = 4


/obj/item/flashlight/spotlight/Initialize(mapload, _light_range, _light_power, _light_color)
	. = ..()
	if(!isnull(_light_range))
		base_light_range = _light_range
		set_light_range(_light_range)
	if(!isnull(_light_power))
		set_light_power(_light_power)
	if(!isnull(_light_color))
		set_light_color(_light_color)


/obj/item/flashlight/flashdark
	name = "темнильник"
	desc = "Странное устройство, изготовленное из загадочных элементов, которое каким-то образом излучает тьму. А может просто засасывает свет? Точно никто не знает."
	icon_state = "flashdark"
	inhand_icon_state = "flashdark"
	light_system = STATIC_LIGHT //The overlay light component is not yet ready to produce darkness.
	light_range = 0
	///Variable to preserve old lighting behavior in flashlights, to handle darkness.
	var/dark_light_range = 2.5
	///Variable to preserve old lighting behavior in flashlights, to handle darkness.
	var/dark_light_power = -3


/obj/item/flashlight/flashdark/update_brightness(mob/user)
	. = ..()
	if(on)
		set_light(dark_light_range, dark_light_power)
	else
		set_light(0)

//type and subtypes spawned and used to give some eyes lights,
/obj/item/flashlight/eyelight
	name = "светоглаза"
	desc = "Это не должно существовать вне чьей-то головы, как вы это видите?"
	light_system = MOVABLE_LIGHT
	light_range = 15
	light_power = 1
	flags_1 = CONDUCT_1
	item_flags = DROPDEL
	actions_types = list()

/obj/item/flashlight/eyelight/adapted
	name = "adaptedlight"
	desc = "There is no possible way for a player to see this, so I can safely talk at length about why this exists. Adapted eyes come \
	with icons that go above the lighting layer so to make sure the red eyes that pierce the darkness are always visible we make the \
	human emit the smallest amount of light possible. Thanks for reading :)"
	light_range = 1
	light_power = 0.07
