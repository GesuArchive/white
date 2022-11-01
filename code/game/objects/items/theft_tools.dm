//Items for nuke theft, supermatter theft traitor objective


// STEALING THE NUKE

//the nuke core - objective item
/obj/item/nuke_core
	name = "плутониевое ядро"
	desc = "<i><b>Крайне</b></i> радиоактивен. Не забудьте надеть защитные очки."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "plutonium_core"
	inhand_icon_state = "plutoniumcore"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/pulse = 0
	var/cooldown = 0
	var/pulseicon = "plutonium_core_pulse"

/obj/item/nuke_core/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/nuke_core/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/nuke_core/attackby(obj/item/nuke_core_container/container, mob/user)
	if(istype(container))
		container.load(src, user)
	else
		return ..()

/obj/item/nuke_core/process()
	if(cooldown < world.time - 60)
		cooldown = world.time
		flick(pulseicon, src)
		radiation_pulse(src, 400, 2)

/obj/item/nuke_core/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] трёт [src] об себя! Похоже, [user.ru_who()] пытается совершить суицид!"))
	user.AddComponent(/datum/component/radioactive, 15, src)
	return (TOXLOSS)

//nuke core box, for carrying the core
/obj/item/nuke_core_container
	name = "контейнер для плутониевого ядра"
	desc = "Тяжёлый контейнер для безопасного хранения радиоактивных объектов. Безопасность 1945-го уровня!"
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "core_container_empty"
	inhand_icon_state = "tile"
	lefthand_file = 'icons/mob/inhands/misc/tiles_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/tiles_righthand.dmi'
	var/obj/item/nuke_core/core

/obj/item/nuke_core_container/Destroy()
	QDEL_NULL(core)
	return ..()

/obj/item/nuke_core_container/proc/load(obj/item/nuke_core/ncore, mob/user)
	if(core || !istype(ncore))
		return FALSE
	ncore.forceMove(src)
	core = ncore
	icon_state = "core_container_loaded"
	to_chat(user, span_warning("Контейнер закрывается..."))
	addtimer(CALLBACK(src, .proc/seal), 50)
	return TRUE

/obj/item/nuke_core_container/proc/seal()
	if(istype(core))
		STOP_PROCESSING(SSobj, core)
		icon_state = "core_container_sealed"
		playsound(src, 'sound/items/deconstruct.ogg', 60, TRUE)
		if(ismob(loc))
			to_chat(loc, span_warning("[capitalize(src.name)] закрыт, радиация ядра больше не помеха. Извлечь ядро вне специализированной лаборатории невозможно."))

/obj/item/nuke_core_container/attackby(obj/item/nuke_core/core, mob/user)
	if(istype(core))
		if(!user.temporarilyRemoveItemFromInventory(core))
			to_chat(user, span_warning("[core] прилипло к моей руке! Блять!"))
			return
		else
			load(core, user)
	else
		return ..()

//snowflake screwdriver, works as a key to start nuke theft, traitor only
/obj/item/screwdriver/nuke
	desc = "Отвёртка, созданная с использование технологии Ultra-Thin™, обеспечивающая большую скорость откручивания-закручивания, по сравнению со стандартной. Среди нешарящих олухов распространено мнение, что это всего-лишь маркетинговый ход и Ultra-Thin™ отвёртка ничем не лучше обычной."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "screwdriver_nuke"
	inhand_icon_state = "screwdriver_nuke"
	toolspeed = 0.5
	random_color = FALSE

/obj/item/paper/guides/antag/nuke_instructions
	info = "<center>Как вломиться в терминал самоуничтожения станции и украсть плутониевое ядро: Мануал для чайников.</center><br><br>\
	<ul>\
	<li>1. Воспользуйтесь отвёрткой, построенной по технологии Ultra-Thin™ (в комплекте), чтобы открутить переднюю панель техобслуживания терминала.</li>\
	<li>2. Отсоедините переднюю панель терминала при помощи монтировки.</li>\
	<li>3. Разрежьте внутреннюю защитную панель сварочным аппаратом.</li>\
	<li>4. Оголите плутониевое ядро, осторожно выломав внутреннюю защитную панель.</li>\
	<li>5. Воспользуйтесь контейнером для плутониевого ядра (в комплекте), чтобы вытащить ядро; На закрытие контейнера уйдёт некоторое время.</li>\
	<li>6. ???</li>\
	<li>7. <i>Вы восхитительны!</i></li>\
	</ul>"

// STEALING SUPERMATTER

/obj/item/paper/guides/antag/supermatter_sliver
	info = "<center>Как безопасно получить осколок суперматерии: Мануал для чайников.</center>:<br><br>\
	<ul>\
	<li>1. Подойдите к кристаллу суперматерии в защитном противорадиационном костюме. <i>НЕ ПРИКАСАЙТЕСЬ К КРИСТАЛЛУ СВОИМ ТЕЛОМ ИЛИ ОДЕЖДОЙ.</i></li>\
	<li>3. Воспользуйтесь специальным скальпелем (в комплекте), чтобы отделить осколок суперматерии от основного кристалла. <i>НЕ ПРИКАСАЙТЕСЬ К КРИСТАЛЛУ СВОИМ ТЕЛОМ ИЛИ ОДЕЖДОЙ.</i></li>\
	<li>4. Воспользуйтесь специальными щипцами (в комплекте), чтобы безопасно подобрать осколок. <i>НЕ ПРИКАСАЙТЕСЬ К КРИСТАЛЛУ СВОИМ ТЕЛОМ ИЛИ ОДЕЖДОЙ.</i></li>\
	<li>5. <i><b><font size=+1>НЕ ПРИКАСАЙТЕСЬ К КРИСТАЛЛУ СВОИМ ТЕЛОМ ИЛИ ОДЕЖДОЙ.</font></b></i></li>\
	<li>6. Щипцами аккуратно уложите осколок суперматерии в защитный контейнер; На закрытие контейнера уйдёт некоторое время. <i>НЕ ПРИКАСАЙТЕСЬ К КРИСТАЛЛУ СВОИМ ТЕЛОМ ИЛИ ОДЕЖДОЙ.</i></li>\
	<li>7. Ретируйтесь как можно скорее, пока основной кристалл суперматерии не взорвался. <i>НЕ ПРИКАСАЙТЕСЬ К КРИСТАЛЛУ СВОИМ ТЕЛОМ ИЛИ ОДЕЖДОЙ.</i></li>\
	<li>8. ???</li>\
	<li>9. <i>Вы восхитительны!</i> <font size=-2>Всё ещё не прикасайтесь к кристаллу своим телом или одеждой.</font></li>\
	</ul>"

/obj/item/nuke_core/supermatter_sliver
	name = "осколок суперматерии"
	desc = "Мелкий, но крайне опасный кристалл суперматерии. Без радиационной защиты не подходить!"
	icon_state = "supermatter_sliver"
	inhand_icon_state = "supermattersliver"
	pulseicon = "supermatter_sliver_pulse"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER


/obj/item/nuke_core/supermatter_sliver/attack_tk(mob/user) // no TK dusting memes
	return


/obj/item/nuke_core/supermatter_sliver/can_be_pulled(user) // no drag memes
	return FALSE

/obj/item/nuke_core/supermatter_sliver/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/hemostat/supermatter))
		var/obj/item/hemostat/supermatter/tongs = W
		if (tongs.sliver)
			to_chat(user, span_warning("Уже держу в своих щипцах осколок суперматерии!"))
			return FALSE
		forceMove(tongs)
		tongs.sliver = src
		tongs.update_icon()
		to_chat(user, span_notice("Осторожно подбираю [src] щипцами."))
	else if(istype(W, /obj/item/scalpel/supermatter) || istype(W, /obj/item/nuke_core_container/supermatter/)) // we don't want it to dust
		return
	else
		to_chat(user, span_notice("Как только кристалл касается [W], они оба обращаются в пыль!"))
		radiation_pulse(user, 100)
		playsound(src, 'sound/effects/supermatter.ogg', 50, TRUE)
		qdel(W)
		qdel(src)

/obj/item/nuke_core/supermatter_sliver/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!isliving(hit_atom))
		return ..()
	var/mob/living/victim = hit_atom
	if(victim.incorporeal_move || victim.status_flags & GODMODE) //try to keep this in sync with supermatter's consume fail conditions
		return ..()
	if(throwingdatum?.thrower)
		var/mob/user = throwingdatum.thrower
		log_combat(throwingdatum?.thrower, hit_atom, "consumed", src)
		message_admins("[src] has consumed [key_name_admin(victim)] [ADMIN_JMP(src)], thrown by [key_name_admin(user)].")
		investigate_log("has consumed [key_name(victim)], thrown by [key_name(user)]", INVESTIGATE_SUPERMATTER)
	else
		message_admins("[src] has consumed [key_name_admin(victim)] [ADMIN_JMP(src)] via throw impact.")
		investigate_log("has consumed [key_name(victim)] via throw impact.", INVESTIGATE_SUPERMATTER)
	victim.visible_message(span_danger("As [victim] is hit by [src], both flash into dust and silence fills the room...") ,\
		span_userdanger("You're hit by [src] and everything suddenly goes silent.\n[src] flashes into dust, and soon as you can register this, you do as well.") ,\
		span_hear("Everything suddenly goes silent."))
	victim.dust()
	radiation_pulse(src, 500, 2)
	playsound(src, 'sound/effects/supermatter.ogg', 50, TRUE)
	qdel(src)

/obj/item/nuke_core/supermatter_sliver/pickup(mob/living/user)
	..()
	if(!isliving(user) || user.status_flags & GODMODE) //try to keep this in sync with supermatter's consume fail conditions
		return FALSE
	user.visible_message(span_danger("[user] пытается подобрать кристалл своими руками, как вдруг [user.ru_ego()] тело начинает светиться, прежде чем обратиться в облако пыли") ,\
			span_userdanger("Попытался подобрать осколок кристалла своими руками. Это был интересный опыт.") ,\
			span_hear("Вас внезапно окутывает абсолютная тишина."))
	radiation_pulse(user, 500, 2)
	playsound(src, 'sound/effects/supermatter.ogg', 50, TRUE)
	user.dust()

/obj/item/nuke_core_container/supermatter
	name = "контейнер для осколка суперматерии"
	desc = "Крошечный стабилизационный контейнер, использующий инертную смесь хайпер-ноблиума для безопасного хранения суперматерии."
	var/obj/item/nuke_core/supermatter_sliver/sliver

/obj/item/nuke_core_container/supermatter/Destroy()
	QDEL_NULL(sliver)
	return ..()

/obj/item/nuke_core_container/supermatter/load(obj/item/hemostat/supermatter/T, mob/user)
	if(!istype(T) || !T.sliver)
		return FALSE
	T.sliver.forceMove(src)
	sliver = T.sliver
	T.sliver = null
	T.icon_state = "supermatter_tongs"
	icon_state = "core_container_loaded"
	to_chat(user, span_warning("Контейнер закрывается..."))
	addtimer(CALLBACK(src, .proc/seal), 50)
	return TRUE

/obj/item/nuke_core_container/supermatter/seal()
	if(istype(sliver))
		STOP_PROCESSING(SSobj, sliver)
		icon_state = "core_container_sealed"
		playsound(src, 'sound/items/Deconstruct.ogg', 60, TRUE)
		if(ismob(loc))
			to_chat(loc, span_warning("[capitalize(src.name)] закрыт, вам больше не грозит опасность \"интересного опыта\". Извлечь осколок вне специализированной лаборатории невозможно."))

/obj/item/nuke_core_container/supermatter/attackby(obj/item/hemostat/supermatter/tongs, mob/user)
	if(istype(tongs))
		//try to load shard into core
		load(tongs, user)
	else
		return ..()

/obj/item/scalpel/supermatter
	name = "supermatter scalpel"
	desc = "A scalpel with a fragile tip of condensed hyper-noblium gas, searingly cold to the touch, that can safely shave a sliver off a supermatter crystal."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "supermatter_scalpel"
	toolspeed = 0.5
	damtype = BURN
	usesound = 'sound/weapons/stab2.ogg'
	var/usesLeft

/obj/item/scalpel/supermatter/Initialize(mapload)
	. = ..()
	usesLeft = rand(2, 4)

/obj/item/hemostat/supermatter
	name = "supermatter extraction tongs"
	desc = "A pair of tongs made from condensed hyper-noblium gas, searingly cold to the touch, that can safely grip a supermatter sliver."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "supermatter_tongs"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	inhand_icon_state = "supermatter_tongs"
	toolspeed = 0.75
	damtype = BURN
	var/obj/item/nuke_core/supermatter_sliver/sliver

/obj/item/hemostat/supermatter/Destroy()
	QDEL_NULL(sliver)
	return ..()

/obj/item/hemostat/supermatter/update_icon_state()
	icon_state = "supermatter_tongs[sliver ? "_loaded" : null]"
	inhand_icon_state = "supermatter_tongs[sliver ? "_loaded" : null]"

/obj/item/hemostat/supermatter/afterattack(atom/O, mob/user, proximity)
	. = ..()
	if(!sliver)
		return
	if(proximity && ismovable(O) && O != sliver)
		Consume(O, user)

/obj/item/hemostat/supermatter/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum) // no instakill supermatter javelins
	if(sliver)
		sliver.forceMove(loc)
		visible_message(span_notice("<b>[capitalize(sliver)]</b> falls out of <b>[src.name]</b> as it hits the ground."))
		sliver = null
		update_icon()
	return ..()

/obj/item/hemostat/supermatter/proc/Consume(atom/movable/AM, mob/living/user)
	if(ismob(AM))
		if(!isliving(AM))
			return
		var/mob/living/victim = AM
		if(victim.incorporeal_move || victim.status_flags & GODMODE) //try to keep this in sync with supermatter's consume fail conditions
			return
		victim.dust()
		message_admins("[src] has consumed [key_name_admin(victim)] [ADMIN_JMP(src)].")
		investigate_log("has consumed [key_name(victim)].", INVESTIGATE_SUPERMATTER)
	else if(istype(AM, /obj/singularity))
		return
	else
		investigate_log("has consumed [AM].", INVESTIGATE_SUPERMATTER)
		qdel(AM)
	if (user)
		log_combat(user, AM, "consumed", sliver, "via [src]")
		user.visible_message(span_danger("As [user] touches [AM] with <b>[src.name]</b>, both flash into dust and silence fills the room...") ,\
			span_userdanger("You touch [AM] with [src], and everything suddenly goes silent.\n[AM] and [sliver] flash into dust, and soon as you can register this, you do as well.") ,\
			span_hear("Everything suddenly goes silent."))
		user.dust()
	radiation_pulse(src, 500, 2)
	playsound(src, 'sound/effects/supermatter.ogg', 50, TRUE)
	QDEL_NULL(sliver)
	update_icon()
