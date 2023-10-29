#define EXECUTE_INFIDEL 300
#define EXECUTE_COOLDOWN 100
#define CHANNEL_NASHEED 1015

GLOBAL_VAR_INIT(nasheed_playing, FALSE)

/obj/item/melee/execution_sword
	name = "Меч палача"
	desc = "Не подходит для боя, но отлично подходит для показухи."
	force = 10
	icon_state = "cutlass"
	inhand_icon_state = "cutlass"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/weapons/rapierhit.ogg'
	var/execution_faction = "Синдикат"
	var/faction_chosen = FALSE
	var/executing = FALSE
	var/can_execute = TRUE
	var/static/earrape_time = 0
	var/nasheed_list = list('sound/misc/nasheed.ogg', 'sound/misc/nasheed2.ogg')

/obj/item/melee/execution_sword/attack_self(mob/living/user)
	if(faction_chosen == TRUE && execution_faction)
		to_chat(user, span_notice("Ты уже поклялся в верности [execution_faction]!"))
		return
	else
		var/custom_faction = alert(user, "Ты хочешь поклясться в верности новой фракции?", "Кастомизировать?", "Yes", "No")

		if(custom_faction == "No")
			to_chat(user, "Ты решаешь отдать верность [execution_faction], слава [execution_faction]!")
			faction_chosen = TRUE
			return

		if(custom_faction == "Yes")
			execution_faction = stripped_input(user, "Вставь свою новую фракцию", "Faction", max_length = MAX_BROADCAST_LEN)
			faction_chosen = TRUE
	..()


/obj/item/melee/execution_sword/attack(mob/living/target, mob/living/user)
	if(user.a_intent != INTENT_HARM || user.zone_selected != "head" || !ishuman(target))
		return ..()
	if(!can_execute)
		to_chat(user, span_notice("Внутренним передатчикам нужно перезарядиться."))
		return
	if(executing)
		to_chat(user, span_notice("Ты уже кого-то казнишь."))
		return
	var/obj/item/bodypart/head/infidel_head = target.get_bodypart("head")
	if(!infidel_head || target.stat == DEAD)
		to_chat(user, "Немного поздно для казни тут...")
	else
		executing = TRUE
		can_execute = FALSE
		var/area/A = get_area(src)
		priority_announce("[user] готовится казнить [target] в [A.name] во имя [execution_faction]!","Сообщение от [execution_faction]!", 'sound/misc/notice1.ogg')
		log_admin("[key_name(user)] попытался казнить [key_name(target)] при помощи [src]")
		message_admins("[key_name(user)] пытается казнить [key_name(target)] при помощи [src]")
		if(!GLOB.nasheed_playing && world.time > earrape_time)
			var/nasheed_chosen = pick(nasheed_list)
			earrape_time = world.time + 250 //25 seconds between each
			var/sound/nasheed = new()
			nasheed.file = nasheed_chosen
			nasheed.channel = CHANNEL_NASHEED
			nasheed.frequency = 1
			nasheed.wait = 1
			nasheed.repeat = 0
			nasheed.status = SOUND_STREAM
			nasheed.volume = 100
			for(var/mob/M in GLOB.player_list)
				if(M.client.prefs.toggles & SOUND_MIDI)
					var/user_vol = 30
					if(user_vol)
						nasheed.volume = 100 * (user_vol / 100)
					SEND_SOUND(M, nasheed)
					nasheed.volume = 100
			GLOB.nasheed_playing = TRUE
			addtimer(CALLBACK(src, PROC_REF(nasheed_end)), EXECUTE_INFIDEL)
		if(do_after(user,EXECUTE_INFIDEL, target = target))
			log_admin("[key_name(user)] казнил [key_name(target)] при помощи [src]")
			message_admins("[key_name(user)] казнил [key_name(target)] при помощи [src]")
			infidel_head.dismember()
			priority_announce("[user] казнил [target] во имя [execution_faction]!","Сообщение от [execution_faction]!", 'sound/misc/notice1.ogg')
			executing = FALSE
			addtimer(CALLBACK(src, PROC_REF(recharge_execute)), EXECUTE_COOLDOWN)
		else
			priority_announce("[user] не смог казнить [target] и принёс позор [execution_faction]!","Сообщение от [execution_faction]!", 'sound/misc/compiler-failure.ogg')
			executing = FALSE
			nasheed_end()
			addtimer(CALLBACK(src, PROC_REF(recharge_execute)), EXECUTE_COOLDOWN)


/obj/item/melee/execution_sword/proc/nasheed_end()
	for(var/mob/M in GLOB.player_list)
		M.stop_sound_channel(CHANNEL_NASHEED)
	if(GLOB.nasheed_playing)
		GLOB.nasheed_playing = FALSE

/obj/item/melee/execution_sword/proc/recharge_execute()
	if(!can_execute)
		can_execute = TRUE

/obj/item/melee/execution_sword/suicide_act(mob/living/user)
	var/obj/item/bodypart/head/the_head = user.get_bodypart("head")
	user.visible_message(span_suicide("[user] подносит [src] к [user.p_their()] шее! Выглядит будто бы [user.p_theyre()] пытается покончить с жизнью!"))
	if(the_head)
		user.say("FOR [execution_faction]!!", forced = "execution sword")
		priority_announce("[user] забрал свою собственную жизнь во имя [execution_faction]!","Сообщение от [execution_faction]!", 'sound/misc/notice1.ogg')
		the_head.dismember()
		return(BRUTELOSS)
	else
		return(BRUTELOSS)


#undef EXECUTE_INFIDEL
#undef EXECUTE_COOLDOWN
