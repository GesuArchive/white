/datum/brain_trauma/special/imaginary_friend
	name = "Воображаемый друг"
	desc = "Пациент может видеть и слышать воображаемого человека."
	scan_desc = "<b>шизофренического расщепления личности</b>"
	gain_text = span_notice("У меня похоже есть друг. Круто!")
	lose_text = span_warning("Мой друг пропал...")
	var/mob/camera/imaginary_friend/friend
	var/friend_initialized = FALSE

/datum/brain_trauma/special/imaginary_friend/on_gain()
	var/mob/living/M = owner
	if(M.stat == DEAD || !M.client)
		qdel(src)
		return
	..()
	make_friend()
	get_ghost()

/datum/brain_trauma/special/imaginary_friend/on_life(delta_time, times_fired)
	if(get_dist(owner, friend) > 9)
		friend.recall()
	if(!friend)
		qdel(src)
		return
	if(!friend.client && friend_initialized)
		addtimer(CALLBACK(src, PROC_REF(reroll_friend)), 600)

/datum/brain_trauma/special/imaginary_friend/on_death()
	..()
	qdel(src) //friend goes down with the ship

/datum/brain_trauma/special/imaginary_friend/on_lose()
	..()
	QDEL_NULL(friend)

//If the friend goes afk, make a brand new friend. Plenty of fish in the sea of imagination.
/datum/brain_trauma/special/imaginary_friend/proc/reroll_friend()
	if(friend.client) //reconnected
		return
	friend_initialized = FALSE
	QDEL_NULL(friend)
	make_friend()
	get_ghost()

/datum/brain_trauma/special/imaginary_friend/proc/make_friend()
	friend = new(get_turf(owner), src)

/datum/brain_trauma/special/imaginary_friend/proc/get_ghost()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = poll_candidates_for_mob("Хочешь быть воображаемым другом [owner.real_name]?", ROLE_PAI, null, 75, friend, POLL_IGNORE_IMAGINARYFRIEND)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		friend.key = C.key
		friend_initialized = TRUE
	else
		qdel(src)

/mob/camera/imaginary_friend
	name = "воображаемый друг"
	real_name = "воображаемый друг"
	move_on_shuttle = TRUE
	desc = "Прекрасный, но ненастоящий друг."
	see_in_dark = 0
	lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	sight = NONE
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	see_invisible = SEE_INVISIBLE_LIVING
	invisibility = INVISIBILITY_OBSERVER
	var/icon/human_image
	var/image/current_image
	var/hidden = FALSE
	var/move_delay = 0
	var/mob/living/carbon/owner
	var/datum/brain_trauma/special/imaginary_friend/trauma

	var/datum/action/innate/imaginary_join/join
	var/datum/action/innate/imaginary_hide/hide

/mob/camera/imaginary_friend/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	greet()
	Show()

/mob/camera/imaginary_friend/proc/greet()
		to_chat(src, span_notice("<b>Воображаемый друг [owner]!</b>"))
		to_chat(src, span_notice("Абсолютно верен своему другу, несмотря ни на что."))
		to_chat(src, span_notice("Не могу напрямую влиять на мир вокруг меня, но можно видеть, чего [owner] не может."))

/mob/camera/imaginary_friend/Initialize(mapload, _trauma)
	if(!_trauma)
		stack_trace("Imaginary friend created without trauma, wtf")
		return INITIALIZE_HINT_QDEL
	. = ..()

	trauma = _trauma
	owner = trauma.owner

	INVOKE_ASYNC(src, PROC_REF(setup_friend))

	join = new
	join.Grant(src)
	hide = new
	hide.Grant(src)

/mob/camera/imaginary_friend/proc/setup_friend()
	var/gender = pick(MALE, FEMALE)
	real_name = random_unique_name(gender)
	name = real_name
	human_image = get_flat_human_icon(null, pick(SSjob.occupations))

/mob/camera/imaginary_friend/proc/Show()
	if(!client) //nobody home
		return

	//Remove old image from owner and friend
	if(owner.client)
		owner.client.images.Remove(current_image)

	client.images.Remove(current_image)

	//Generate image from the static icon and the current dir
	current_image = image(human_image, src, , MOB_LAYER, dir=src.dir)
	current_image.override = TRUE
	current_image.name = name
	if(hidden)
		current_image.alpha = 150

	//Add new image to owner and friend
	if(!hidden && owner.client)
		owner.client.images |= current_image

	client.images |= current_image

/mob/camera/imaginary_friend/Destroy()
	if(owner?.client)
		owner.client.images.Remove(human_image)
	if(client)
		client.images.Remove(human_image)
	return ..()

/mob/camera/imaginary_friend/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if (!message)
		return

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, span_boldwarning("Не могу."))
			return
		if (!(ignore_spam || forced) && src.client.handle_spam_prevention(message,MUTE_IC))
			return

	friend_talk(message)

/mob/camera/imaginary_friend/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	if (client?.prefs.chat_on_map && (client.prefs.see_chat_non_mob || ismob(speaker)))
		create_chat_message(speaker, message_language, raw_message, spans)
	to_chat(src, compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mods))

/mob/camera/imaginary_friend/proc/friend_talk(message)
	message = capitalize(trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN)))

	if(!message)
		return

	src.log_talk(message, LOG_SAY, tag="воображаемый друг")

	var/rendered = "<span class='game say'><span class='name'>[capitalize(name)]</span> <span class='message'>[say_quote(capitalize(message))]</span></span>"
	var/dead_rendered = "<span class='game say'><span class='name'>[capitalize(name)] (Воображаемый друг [owner])</span> <span class='message'>[say_quote(capitalize(message))]</span></span>"

	to_chat(owner, "[rendered]")
	to_chat(src, "[rendered]")

	//speech bubble
	if(owner.client)
		var/image/bubble = mutable_appearance('icons/mob/talk.dmi', "default[say_test(message)]", FLY_LAYER, src)
		SET_PLANE_EXPLICIT(bubble, ABOVE_GAME_PLANE, src)
		bubble.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay), bubble, list(owner.client), 30)
		LAZYADD(update_on_z, bubble)
		addtimer(CALLBACK(src, PROC_REF(clear_saypopup), bubble), 3.5 SECONDS)

		if(owner?.client?.prefs.chat_on_map)
			owner.create_chat_message(src, raw_message = message)

		if(client?.prefs.chat_on_map)
			create_chat_message(src, raw_message = message)

	for(var/mob/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, owner)
		to_chat(M, "[link] [dead_rendered]")

/mob/camera/imaginary_friend/proc/clear_saypopup(image/say_popup)
	LAZYREMOVE(update_on_z, say_popup)

/mob/camera/imaginary_friend/Move(NewLoc, Dir = 0)
	if(world.time < move_delay)
		return FALSE
	if(get_dist(src, owner) > 9)
		recall()
		move_delay = world.time + 10
		return FALSE
	abstract_move(NewLoc)
	move_delay = world.time + 1

/mob/camera/imaginary_friend/abstract_move(atom/destination)
	. = ..()
	Show()

/mob/camera/imaginary_friend/proc/recall()
	if(!owner || loc == owner)
		return FALSE
	abstract_move(owner)

/datum/action/innate/imaginary_join
	name = "Войти"
	desc = "Войти в своего хозяина и следить за миром его глазами."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"
	button_icon_state = "join"

/datum/action/innate/imaginary_join/Activate()
	var/mob/camera/imaginary_friend/I = owner
	I.recall()

/datum/action/innate/imaginary_hide
	name = "Спрятаться"
	desc = "Спрятать себя от глаз своего хозяина."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"
	button_icon_state = "hide"

/datum/action/innate/imaginary_hide/proc/update_status()
	var/mob/camera/imaginary_friend/I = owner
	if(I.hidden)
		name = "Показаться"
		desc = "Стать видимым для своего хозяина."
		button_icon_state = "unhide"
	else
		name = "Спрятаться"
		desc = "Спрятать себя от глаз своего хозяина."
		button_icon_state = "hide"
	build_all_button_icons()

/datum/action/innate/imaginary_hide/Activate()
	var/mob/camera/imaginary_friend/fake_friend = owner
	fake_friend.hidden = !fake_friend.hidden
	fake_friend.Show()
	build_all_button_icons(UPDATE_BUTTON_NAME|UPDATE_BUTTON_ICON)

/datum/action/innate/imaginary_hide/update_button_name(atom/movable/screen/movable/action_button/button, force)
	var/mob/camera/imaginary_friend/fake_friend = owner
	if(fake_friend.hidden)
		name = "Show"
		desc = "Become visible to your owner."
	else
		name = "Hide"
		desc = "Hide yourself from your owner's sight."
	return ..()

/datum/action/innate/imaginary_hide/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	var/mob/camera/imaginary_friend/fake_friend = owner
	if(fake_friend.hidden)
		button_icon_state = "unhide"
	else
		button_icon_state = "hide"

	return ..()

//down here is the trapped mind
//like imaginary friend but a lot less imagination and more like mind prison//

/datum/brain_trauma/special/imaginary_friend/trapped_owner
	name = "Пойманная жертва"
	desc = "Кажется, что пациент является целью невидимой сущности."
	gain_text = ""
	lose_text = ""
	random_gain = FALSE

/datum/brain_trauma/special/imaginary_friend/trapped_owner/make_friend()
	friend = new /mob/camera/imaginary_friend/trapped(get_turf(owner), src)

/datum/brain_trauma/special/imaginary_friend/trapped_owner/reroll_friend() //no rerolling- it's just the last owner's hell
	if(friend.client) //reconnected
		return
	friend_initialized = FALSE
	QDEL_NULL(friend)
	qdel(src)

/datum/brain_trauma/special/imaginary_friend/trapped_owner/get_ghost() //no randoms
	return

/mob/camera/imaginary_friend/trapped
	name = "плод воображения?"
	real_name = "плод воображения?"
	desc = "Предыдущий хозяин этого тела."

/mob/camera/imaginary_friend/trapped/greet()
	to_chat(src, span_notice("<b>Мне удалось удержаться как плод воображения нового хозяина!</b>"))
	to_chat(src, span_notice("Вся надежда потеряна для меня, но, по крайней мере, можно взаимодействовать с хозяином. Можно быть не верен ему."))
	to_chat(src, span_notice("Не могу напрямую влиять на мир вокруг меня, но вы могу видеть то, что хозяин не может."))

/mob/camera/imaginary_friend/trapped/setup_friend()
	real_name = "[owner.real_name]?"
	name = real_name
	human_image = icon('icons/mob/lavaland/lavaland_monsters.dmi', icon_state = "curseblob")
