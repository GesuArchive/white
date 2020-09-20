GLOBAL_VAR(posibrain_notify_cooldown)

/obj/item/mmi/posibrain
	name = "Позитронный мозг"
	desc = "Сияющий куб из металла, размером он четыре дюйма и весь в красивых впалых узорах. Чудо."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = WEIGHT_CLASS_NORMAL
	var/ask_role = "" ///Can be set to tell ghosts what the brain will be used for
	var/next_ask ///World time tick when ghost polling will be available again
	var/askDelay = 600 ///Delay after polling ghosts
	var/searching = FALSE
	brainmob = null
	req_access = list(ACCESS_ROBOTICS)
	mecha = null//This does not appear to be used outside of reference in mecha.dm.
	braintype = "Android"
	var/autoping = TRUE ///If it pings on creation immediately
	///Message sent to the user when polling ghosts
	var/begin_activation_message = "<span class='notice'>Аккуратно нащупываю кнопку активации, осталось подождать когда эта штука заработает.</span>"
	///Message sent as a visible message on success
	var/success_message = "<span class='notice'>Позитронный мозг издаёт приятный звук и начинает светиться. Это успех!</span>"
	///Message sent as a visible message on failure
	var/fail_message = "<span class='notice'>Позитронный мозг жужит недовольно и перестаёт светиться. Стоит попробовать ещё?</span>"
	///Role assigned to the newly created mind
	var/new_role = "Позитронный мозг"
	///Visible message sent when a player possesses the brain
	var/new_mob_message = "<span class='notice'>Позитронный мозг начинает тихо пищать.</span>"
	///Examine message when the posibrain has no mob
	var/dead_message = "<span class='deadsay'>Он полностью отключен. Кнопка сброса активна.</span>"
	///Examine message when the posibrain cannot poll ghosts due to cooldown
	var/recharge_message = "<span class='warning'>Позитронный мозг не готов к повторной активации! Стоит подождать ещё немного.</span>"
	var/list/possible_names ///One of these names is randomly picked as the posibrain's name on possession. If left blank, it will use the global posibrain names
	var/picked_name ///Picked posibrain name

/obj/item/mmi/posibrain/Topic(href, href_list)
	if(href_list["activate"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			activate(ghost)

///Notify ghosts that the posibrain is up for grabs
/obj/item/mmi/posibrain/proc/ping_ghosts(msg, newlymade)
	if(newlymade || GLOB.posibrain_notify_cooldown <= world.time)
		notify_ghosts("[name] [msg] в [get_area(src)]! [ask_role ? "Требуемая роль: \[[ask_role]\]" : ""]", ghost_sound = !newlymade ? 'sound/effects/ghost2.ogg':null, notify_volume = 75, enter_link = "<a href=?src=[REF(src)];activate=1>(Click to enter)</a>", source = src, action = NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_POSIBRAIN, notify_suiciders = FALSE)
		if(!newlymade)
			GLOB.posibrain_notify_cooldown = world.time + askDelay

/obj/item/mmi/posibrain/attack_self(mob/user)
	if(!brainmob)
		brainmob = new(src)
	if(!(GLOB.ghost_role_flags & GHOSTROLE_SILICONS))
		to_chat(user, "<span class='warning'>Центральное Командование запретило использование синтетиков в этом регионе...</span>")
	if(is_occupied())
		to_chat(user, "<span class='warning'>[capitalize(name)] уже активен!</span>")
		return
	if(next_ask > world.time)
		to_chat(user, recharge_message)
		return
	//Start the process of requesting a new ghost.
	to_chat(user, begin_activation_message)
	ping_ghosts("requested", FALSE)
	next_ask = world.time + askDelay
	searching = TRUE
	update_icon()
	addtimer(CALLBACK(src, .proc/check_success), askDelay)

/obj/item/mmi/posibrain/AltClick(mob/living/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	var/input_seed = stripped_input(user, "Выбрать бы число", "Выбираем число", ask_role, MAX_NAME_LEN)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	if(input_seed)
		to_chat(user, "<span class='notice'>Выставляю случайное число личности \"[input_seed]\".</span>")
		ask_role = input_seed
		update_icon()

/obj/item/mmi/posibrain/proc/check_success()
	searching = FALSE
	update_icon()
	if(QDELETED(brainmob))
		return
	if(brainmob.client)
		visible_message(success_message)
		playsound(src, 'sound/machines/ping.ogg', 15, TRUE)
	else
		visible_message(fail_message)

///ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/item/mmi/posibrain/attack_ghost(mob/user)
	activate(user)

/obj/item/mmi/posibrain/proc/is_occupied()
	if(brainmob.key)
		return TRUE
	if(iscyborg(loc))
		var/mob/living/silicon/robot/R = loc
		if(R.mmi == src)
			return TRUE
	return FALSE

///Two ways to activate a positronic brain. A clickable link in the ghost notif, or simply clicking the object itself.
/obj/item/mmi/posibrain/proc/activate(mob/user)
	if(QDELETED(brainmob))
		return
	if(is_occupied() || is_banned_from(user.ckey, ROLE_POSIBRAIN) || QDELETED(brainmob) || QDELETED(src) || QDELETED(user))
		return
	if(user.suiciding) //if they suicided, they're out forever.
		to_chat(user, "<span class='warning'>[capitalize(src)] тихо шипит. Жалко, что суицидники не принимаются!</span>")
		return
	var/posi_ask = alert("Быть [name]? (Внимание! Прошлого тебя не смогут воскресить, придётся забыть старые обиды)","Готов?","Да","Нет")
	if(posi_ask == "Нет" || QDELETED(src))
		return
	if(brainmob.suiciding) //clear suicide status if the old occupant suicided.
		brainmob.set_suicide(FALSE)
	transfer_personality(user)

/obj/item/mmi/posibrain/transfer_identity(mob/living/carbon/C)
	name = "[initial(name)] ([C])"
	brainmob.name = C.real_name
	brainmob.real_name = C.real_name
	if(C.has_dna())
		if(!brainmob.stored_dna)
			brainmob.stored_dna = new /datum/dna/stored(brainmob)
		C.dna.copy_dna(brainmob.stored_dna)
	brainmob.timeofhostdeath = C.timeofdeath
	brainmob.set_stat(CONSCIOUS)
	if(brainmob.mind)
		brainmob.mind.assigned_role = new_role
	if(C.mind)
		C.mind.transfer_to(brainmob)

	brainmob.mind.remove_all_antag()
	brainmob.mind.wipe_memory()
	update_icon()

///Moves the candidate from the ghost to the posibrain
/obj/item/mmi/posibrain/proc/transfer_personality(mob/candidate)
	if(QDELETED(brainmob))
		return
	if(is_occupied()) //Prevents hostile takeover if two ghosts get the prompt or link for the same brain.
		to_chat(candidate, "<span class='warning'>Этот [name] уже был выбран до того как была возможности войти! Возможно оно будет доступно позже?</span>")
		return FALSE
	if(candidate.mind && !isobserver(candidate))
		candidate.mind.transfer_to(brainmob)
	else
		brainmob.ckey = candidate.ckey
	name = "[initial(name)] ([brainmob.name])"
	var/policy = get_policy(ROLE_POSIBRAIN)
	if(policy)
		to_chat(brainmob, policy)
	brainmob.mind.assigned_role = new_role
	brainmob.set_stat(CONSCIOUS)
	brainmob.remove_from_dead_mob_list()
	brainmob.add_to_alive_mob_list()

	visible_message(new_mob_message)
	check_success()
	return TRUE


/obj/item/mmi/posibrain/examine(mob/user)
	. = ..()
	if(brainmob && brainmob.key)
		switch(brainmob.stat)
			if(CONSCIOUS)
				if(!brainmob.client)
					. += "<hr>Он в режиме ожидания." //afk
			if(DEAD)
				. += "<hr><span class='deadsay'>Он полностью отключен.</span>"
	else
		. += "<hr>[dead_message]"
		if(ask_role)
			. += "<hr><span class='notice'>Текущее случайное число сознания: \"[ask_role]\"</span>"
		. += "\n<span class='boldnotice'>Alt-клик для установки случайного числа. Оно укажет позитронику кему ему быть. Это поможет заинтересовать кого-нибудь.</span>"

/obj/item/mmi/posibrain/Initialize()
	. = ..()
	brainmob = new(src)
	var/new_name
	if(!LAZYLEN(possible_names))
		new_name = pick(GLOB.posibrain_names)
	else
		new_name = pick(possible_names)
	brainmob.name = "[new_name]-[rand(100, 999)]"
	brainmob.real_name = brainmob.name
	brainmob.forceMove(src)
	brainmob.container = src
	if(autoping)
		ping_ghosts("создан", TRUE)

/obj/item/mmi/posibrain/attackby(obj/item/O, mob/user)
	return


/obj/item/mmi/posibrain/update_icon_state()
	if(searching)
		icon_state = "[initial(icon_state)]-searching"
	else if(brainmob && brainmob.key)
		icon_state = "[initial(icon_state)]-occupied"
	else
		icon_state = initial(icon_state)

/obj/item/mmi/posibrain/add_mmi_overlay()
	return
