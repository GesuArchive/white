#define RAD_LEVEL_NORMAL 9
#define RAD_LEVEL_MODERATE 100
#define RAD_LEVEL_HIGH 400
#define RAD_LEVEL_VERY_HIGH 800
#define RAD_LEVEL_CRITICAL 1500

/obj/item/geiger_counter //DISCLAIMER: I know nothing about how real-life Geiger counters work. This will not be realistic. ~Xhuis
	name = "счётчик гейгера"
	desc = "Портативное устройство, используемое для регистрации и измерения импульсов излучения."
	icon = 'white/valtos/icons/items.dmi'
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

/obj/item/geiger_counter/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

	soundloop = new(list(src), FALSE)

/obj/item/geiger_counter/Destroy()
	STOP_PROCESSING(SSobj, src)
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
	. += "<hr><span class='info'>Alt-клик для очистки показателей.</span>"
	if(obj_flags & EMAGGED)
		. += "\n<span class='warning'>Дисплей выдаёт ересь.</span>"
		return
	. += "<hr>"
	switch(radiation_count)
		if(-INFINITY to RAD_LEVEL_NORMAL)
			. += "<span class='notice'>Подсчет уровня радиации показывает, что все в порядке.</span>"
		if(RAD_LEVEL_NORMAL + 1 to RAD_LEVEL_MODERATE)
			. += "<span class='alert'>Уровни внешней радиации немного выше среднего.</span>"
		if(RAD_LEVEL_MODERATE + 1 to RAD_LEVEL_HIGH)
			. += "<span class='warning'>Уровень радиации выше среднего.</span>"
		if(RAD_LEVEL_HIGH + 1 to RAD_LEVEL_VERY_HIGH)
			. += "<span class='danger'>Уровни внешней радиации значительно выше среднего.</span>"
		if(RAD_LEVEL_VERY_HIGH + 1 to RAD_LEVEL_CRITICAL)
			. += "<span class='suicide'>Уровень радиации приближается к критическому уровню.</span>"
		if(RAD_LEVEL_CRITICAL + 1 to INFINITY)
			. += "<span class='boldannounce'>Уровни внешней радиации выше критического уровня!</span>"

	. += "\n<span class='notice'>Последнее обнаруженное количество радиации было [last_tick_amount]</span>"

/obj/item/geiger_counter/update_icon_state()
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
	to_chat(user, "<span class='notice'>[icon2html(src, user)] Переключаю [src.name] в режим [scanning ? "вкл" : "выкл"].</span>")

/obj/item/geiger_counter/afterattack(atom/target, mob/user)
	. = ..()
	if(user.a_intent == INTENT_HELP)
		if(!(obj_flags & EMAGGED))
			user.visible_message("<span class='notice'>[user] сканирует [target] используя [src.name].</span>", "<span class='notice'>Сканирую [target]'s radiation levels with [src.name]...</span>")
			addtimer(CALLBACK(src, .proc/scan, target, user), 20, TIMER_UNIQUE) // Let's not have spamming GetAllContents
		else
			user.visible_message("<span class='notice'>[user] сканирует [target] используя [src.name].</span>", "<span class='danger'>Вкачиваю радиацию запасённую [src.name] в [target]!</span>")
			target.rad_act(radiation_count)
			radiation_count = 0
		return TRUE

/obj/item/geiger_counter/proc/scan(atom/A, mob/user)
	var/rad_strength = get_rad_contamination(A)

	if(isliving(A))
		var/mob/living/M = A
		if(!M.radiation)
			to_chat(user, "<span class='notice'>[icon2html(src, user)] Уровень радиоактивного излучения в норме.</span>")
		else
			to_chat(user, "<span class='boldannounce'>[icon2html(src, user)] Пациент радиоактивен. Уровень излучения: [M.radiation].</span>")

	if(rad_strength)
		to_chat(user, "<span class='boldannounce'>[icon2html(src, user)] Цель содержит радиоактивное загрязнение. Сила излучения: [rad_strength]</span>")
	else
		to_chat(user, "<span class='notice'>[icon2html(src, user)] Цель не имеет радиоактивного загрязнения.</span>")

/obj/item/geiger_counter/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER && (obj_flags & EMAGGED))
		if(scanning)
			to_chat(user, "<span class='warning'>Стоит выключить [src.name] перед тем как делать это!</span>")
			return FALSE
		user.visible_message("<span class='notice'>[user] раскручивает панели обслуживания [src.name] и начинает возиться с его внутренностями...</span>", "<span class='notice'>Начинаю сбрасывать [src.name]...</span>")
		if(!I.use_tool(src, user, 40, volume=50))
			return FALSE
		user.visible_message("<span class='notice'>[user] закручивает панельку [src.name]!</span>", "<span class='notice'>Успешно сбрасываю [src.name] до заводских настроек!</span>")
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
		to_chat(usr, "<span class='warning'>Сначала нужно включить [src.name]!</span>")
		return
	radiation_count = 0
	to_chat(usr, "<span class='notice'>Сбрасываю уровни радиации [src.name].</span>")
	update_icon()

/obj/item/geiger_counter/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	if(scanning)
		to_chat(user, "<span class='warning'>Стоит выключить [src.name] перед этим!</span>")
		return
	to_chat(user, "<span class='warning'>Перезаписываю протоколы хранения радиации [src.name]. Теперь он будет генерировать небольшие дозы радиации, а сохраненные рады теперь проецируются на существ, которых я сканирую.</span>")
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
	RegisterSignal(user, COMSIG_ATOM_RAD_ACT, .proc/redirect_rad_act)
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
