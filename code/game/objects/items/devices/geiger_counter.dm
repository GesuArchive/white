#define RAD_LEVEL_NORMAL 9
#define RAD_LEVEL_MODERATE 100
#define RAD_LEVEL_HIGH 400
#define RAD_LEVEL_VERY_HIGH 800
#define RAD_LEVEL_CRITICAL 1500

/obj/item/geiger_counter //DISCLAIMER: I know nothing about how real-life Geiger counters work. This will not be realistic. ~Xhuis
	name = "счётчик гейгера"
	desc = "Портативное устройство, используемое для регистрации и измерения импульсов излучения."
	icon = 'icons/obj/device.dmi'
	icon_state = "geiger_off"
	inhand_icon_state = "multitool"
	worn_icon_state = "geiger_counter"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	item_flags = NOBLUDGEON
	custom_materials = list(/datum/material/iron = 150, /datum/material/glass = 150)

	var/grace = RAD_GEIGER_GRACE_PERIOD
	var/datum/looping_sound/geiger/soundloop

	var/scanning = FALSE
	var/radiation_count = 0
	var/current_tick_amount = 0
	var/last_tick_amount = 0
	var/fail_to_receive = 0
	var/current_warning = 1

/obj/item/geiger_counter/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

	soundloop = new(src, FALSE)

/obj/item/geiger_counter/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(soundloop)

	return ..()

/obj/item/geiger_counter/process(delta_time)
	if(scanning)
		radiation_count = LPFILTER(radiation_count, current_tick_amount, delta_time, RAD_GEIGER_RC)

		if(current_tick_amount)
			grace = RAD_GEIGER_GRACE_PERIOD
			last_tick_amount = current_tick_amount

		else if(!(obj_flags & EMAGGED))
			grace -= delta_time
			if(grace <= 0)
				radiation_count = 0

	current_tick_amount = 0

	update_icon()
	update_sound()

/obj/item/geiger_counter/examine(mob/user)
	. = ..()
	if(!scanning)
		return
	. += "<hr><span class='info'>ПКМ для очистки показателей.</span>"
	if(obj_flags & EMAGGED)
		. += span_warning("\nДисплей выдаёт ересь.")
		return
	. += "<hr>"
	switch(radiation_count)
		if(-INFINITY to RAD_LEVEL_NORMAL)
			. += span_notice("Подсчет уровня радиации показывает, что все в порядке.")
		if(RAD_LEVEL_NORMAL + 1 to RAD_LEVEL_MODERATE)
			. += span_alert("Уровни внешней радиации немного выше среднего.")
		if(RAD_LEVEL_MODERATE + 1 to RAD_LEVEL_HIGH)
			. += span_warning("Уровень радиации выше среднего.")
		if(RAD_LEVEL_HIGH + 1 to RAD_LEVEL_VERY_HIGH)
			. += span_danger("Уровни внешней радиации значительно выше среднего.")
		if(RAD_LEVEL_VERY_HIGH + 1 to RAD_LEVEL_CRITICAL)
			. += span_suicide("Уровень радиации приближается к критическому уровню.")
		if(RAD_LEVEL_CRITICAL + 1 to INFINITY)
			. += span_boldannounce("Уровни внешней радиации выше критического уровня!")

	. += span_notice("\nПоследнее обнаруженное количество радиации было [last_tick_amount]")

/obj/item/geiger_counter/update_icon_state()
	. = ..()
	if(!scanning)
		icon_state = "geiger_off"
	else if(obj_flags & EMAGGED)
		icon_state = "geiger_on_emag"
	else
		switch(radiation_count)
			if(-INFINITY to RAD_LEVEL_NORMAL)
				icon_state = "geiger_on_1"
			if(RAD_LEVEL_NORMAL + 1 to RAD_LEVEL_MODERATE)
				icon_state = "geiger_on_2"
			if(RAD_LEVEL_MODERATE + 1 to RAD_LEVEL_HIGH)
				icon_state = "geiger_on_3"
			if(RAD_LEVEL_HIGH + 1 to RAD_LEVEL_VERY_HIGH)
				icon_state = "geiger_on_4"
			if(RAD_LEVEL_VERY_HIGH + 1 to RAD_LEVEL_CRITICAL)
				icon_state = "geiger_on_4"
			if(RAD_LEVEL_CRITICAL + 1 to INFINITY)
				icon_state = "geiger_on_5"

/obj/item/geiger_counter/proc/update_sound()
	var/datum/looping_sound/geiger/loop = soundloop
	if(!scanning)
		loop.stop()
		return
	if(!radiation_count)
		loop.stop()
		return
	loop.last_radiation = radiation_count
	loop.start()

/obj/item/geiger_counter/rad_act(amount)
	. = ..()
	if(amount <= RAD_BACKGROUND_RADIATION || !scanning)
		return
	current_tick_amount += amount
	update_icon()

/obj/item/geiger_counter/attack_self(mob/user)
	scanning = !scanning
	update_icon()
	to_chat(user, span_notice("[icon2html(src, user)] Переключаю [src.name] в режим [scanning ? "вкл" : "выкл"]."))

/obj/item/geiger_counter/afterattack(atom/target, mob/user)
	. = ..()
	if(user.a_intent == INTENT_HELP)
		if(!(obj_flags & EMAGGED))
			user.visible_message(span_notice("[user] сканирует [target] используя [src.name].") , span_notice("Сканирую [target] radiation levels with [src.name]..."))
			addtimer(CALLBACK(src, PROC_REF(scan), target, user), 20, TIMER_UNIQUE) // Let's not have spamming get_all_contents
		else
			user.visible_message(span_notice("[user] сканирует [target] используя [src.name].") , span_danger("Вкачиваю радиацию запасённую [src.name] в [target]!"))
			target.rad_act(radiation_count)
			radiation_count = 0
		return TRUE

/obj/item/geiger_counter/proc/scan(atom/A, mob/user)
	var/rad_strength = get_rad_contamination(A)

	if(isliving(A))
		var/mob/living/M = A
		if(!M.radiation)
			to_chat(user, span_notice("[icon2html(src, user)] Уровень радиоактивного излучения в норме."))
		else
			to_chat(user, span_boldannounce("[icon2html(src, user)] Пациент радиоактивен. Уровень излучения: [M.radiation]."))

	if(rad_strength)
		to_chat(user, span_boldannounce("[icon2html(src, user)] Цель содержит радиоактивное загрязнение. Сила излучения: [rad_strength]"))
	else
		to_chat(user, span_notice("[icon2html(src, user)] Цель не имеет радиоактивного загрязнения."))

/obj/item/geiger_counter/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER && (obj_flags & EMAGGED))
		if(scanning)
			to_chat(user, span_warning("Стоит выключить [src.name] перед тем как делать это!"))
			return FALSE
		user.visible_message(span_notice("[user] раскручивает панели обслуживания [src.name] и начинает возиться с его внутренностями...") , span_notice("Начинаю сбрасывать [src.name]..."))
		if(!I.use_tool(src, user, 40, volume=50))
			return FALSE
		user.visible_message(span_notice("[user] закручивает панельку [src.name]!") , span_notice("Успешно сбрасываю [src.name] до заводских настроек!"))
		obj_flags &= ~EMAGGED
		radiation_count = 0
		update_icon()
		return TRUE
	else
		return ..()

/obj/item/geiger_counter/AltClick(mob/living/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return ..()
	if(!scanning)
		to_chat(usr, span_warning("Сначала нужно включить [src.name]!"))
		return
	radiation_count = 0
	to_chat(usr, span_notice("Сбрасываю уровни радиации [src.name]."))
	update_icon()

/obj/item/geiger_counter/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	if(scanning)
		to_chat(user, span_warning("Стоит выключить [src.name] перед этим!"))
		return
	to_chat(user, span_warning("Перезаписываю протоколы хранения радиации [src.name]. Теперь он будет генерировать небольшие дозы радиации, а сохраненные рады теперь проецируются на существ, которых я сканирую."))
	obj_flags |= EMAGGED



/obj/item/geiger_counter/cyborg
	var/mob/listeningTo

/obj/item/geiger_counter/cyborg/cyborg_unequip(mob/user)
	if(!scanning)
		return
	scanning = FALSE
	update_icon()

/obj/item/geiger_counter/cyborg/equipped(mob/user)
	. = ..()
	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_ATOM_RAD_ACT)
	RegisterSignal(user, COMSIG_ATOM_RAD_ACT, PROC_REF(redirect_rad_act))
	listeningTo = user

/obj/item/geiger_counter/cyborg/proc/redirect_rad_act(datum/source, amount)
	rad_act(amount)

/obj/item/geiger_counter/cyborg/dropped()
	. = ..()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_ATOM_RAD_ACT)

#undef RAD_LEVEL_NORMAL
#undef RAD_LEVEL_MODERATE
#undef RAD_LEVEL_HIGH
#undef RAD_LEVEL_VERY_HIGH
#undef RAD_LEVEL_CRITICAL
