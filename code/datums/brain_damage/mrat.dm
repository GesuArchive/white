/datum/brain_trauma/special/imaginary_friend/mrat
	name = "Эпистемания"
	desc = "Больной страдает от маниакальной погони за знаниями."
	scan_desc = "epistemania"
	gain_text = "<span class='notice'>Запрашиваю знатока...</span>"
	lose_text = ""
	random_gain = FALSE
	resilience = TRAUMA_RESILIENCE_ABSOLUTE

/datum/brain_trauma/special/imaginary_friend/mrat/make_friend()
	friend = new /mob/camera/imaginary_friend/mrat(get_turf(owner), src)

/datum/brain_trauma/special/imaginary_friend/mrat/get_ghost()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = poll_mentor_candidates_for_mob("Хочешь быть помощником [owner]?", ROLE_PAI, null, 75, friend, POLL_IGNORE_IMAGINARYFRIEND)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		friend.key = C.key
		friend.real_name = friend.key
		friend.name = "Знатокрыс ([friend.real_name])"

		var/mob/camera/imaginary_friend/mrat/I = friend
		I.pick_name()
		I.costume()

		friend_initialized = TRUE
		to_chat(owner, "<span class='notice'>Мне будет помогать [friend.key], можно задавать ему любые вопросы. Он уйдёт как только вы закончите.</span>")
	else
		to_chat(owner, "<span class='warning'>Никто не согласился помогать. Попробуем позже.</span>")
		qdel(src)

/datum/mrat_type
	var/name
	var/icon
	var/icon_state
	var/color
	var/sound
	var/list/radial_icon
	var/volume

/datum/mrat_type/New(type_name, type_icon, type_icon_state, type_sound, type_color = null, type_volume = 100)
	name = type_name
	icon = type_icon
	icon_state = type_icon_state
	color = type_color
	sound = type_sound
	volume = type_volume

/mob/camera/imaginary_friend/mrat
	name = "Знатокрыса"
	real_name = "Знатокрыса"
	desc = "МОЙ персональный ассистент."

	var/datum/action/innate/mrat_costume/costume
	var/datum/action/innate/mrat_leave/leave
	var/list/icons_available = list()
	var/datum/mrat_type/current_costume = null
	var/list/mrat_types = list(
		new /datum/mrat_type("Мышь", 'icons/mob/animal.dmi', "mouse_white", "sound/effects/mousesqueek.ogg", "#1ABC9C"),
		new /datum/mrat_type("Корги", 'icons/mob/pets.dmi', "corgi", "sound/machines/uplinkpurchase.ogg"),
		new /datum/mrat_type("Муравей", 'icons/mob/pets.dmi', "ant", "sound/voice/moth/scream_moth.ogg"),
		new /datum/mrat_type("Кись", 'icons/mob/pets.dmi', "kitten", "sound/machines/uplinkpurchase.ogg"),
		new /datum/mrat_type("Краб", 'icons/mob/animal.dmi', "crab", "sound/machines/uplinkpurchase.ogg"),
		new /datum/mrat_type("Уничтожитель", 'icons/mob/pets.dmi', "slime_puppy", "sound/machines/uplinkpurchase.ogg"),
		new /datum/mrat_type("Цыпа", 'icons/mob/animal.dmi', "chick", "sound/effects/mousesqueek.ogg"),
		new /datum/mrat_type("Молетаракан", 'icons/mob/animal.dmi', "mothroach", "sound/voice/moth/scream_moth.ogg", type_volume=50),
		new /datum/mrat_type("Пчёл", 'icons/mob/animal.dmi', "bee_big", "sound/voice/moth/scream_moth.ogg", type_volume=50),
		new /datum/mrat_type("Бабочка", 'icons/mob/animal.dmi', "butterfly", "sound/voice/moth/scream_moth.ogg", type_color="#1ABC9C", type_volume=50),
		new /datum/mrat_type("Голограмма", 'icons/mob/ai.dmi', "default", "sound/machines/ping.ogg", type_volume=50),
		new /datum/mrat_type("МУЖИК", 'icons/mob/animal.dmi', "old", "sound/machines/buzz-sigh.ogg", type_volume=50)
	)

/mob/camera/imaginary_friend/mrat/proc/update_available_icons()
	icons_available = list()

	for(var/datum/mrat_type/T in mrat_types)
		icons_available += list("[T.name]" = image(icon = T.icon, icon_state = T.icon_state))

/mob/camera/imaginary_friend/mrat/proc/costume()
	update_available_icons()
	if(icons_available)
		var/selection = show_radial_menu(src, src, icons_available, radius = 38)
		if(!selection)
			return

		for(var/datum/mrat_type/T in mrat_types)
			if(T.name == selection)
				current_costume = T
				human_image = image(icon = T.icon, icon_state = T.icon_state)
				color = T.color
				Show()
				return

/mob/camera/imaginary_friend/mrat/proc/pick_name()
	var/picked_name = sanitize_name(tgui_input_text(src, "Как назовёмся?", "Имя крысы", "Знатокрыс", MAX_NAME_LEN - 3 - length(key)))
	if(!picked_name || picked_name == "")
		picked_name = "Знатокрыс"
	log_game("[key_name(src)] has set \"[picked_name]\" as their mentor rat's name for [key_name(owner)]")
	name = "[picked_name] ([key])"

/mob/camera/imaginary_friend/mrat/friend_talk()
	. = ..()
	if(!current_costume || !istype(current_costume))
		return
	SEND_SOUND(owner, sound(current_costume.sound, volume=current_costume.volume))
	SEND_SOUND(src, sound(current_costume.sound, volume=current_costume.volume))

/mob/camera/imaginary_friend/mrat/greet()
	to_chat(src, "<span class='notice'><b>Срань господня, да я же помогаю [owner]!</b></span>")
	to_chat(src, "<span class='notice'>Не стоит давать [owner] любую OOC информацию. Она ему не нужна.</span>")
	to_chat(src, "<span class='notice'>Моя задача - отвечать на вопросы [owner] и помогать с решением задач.</span>")
	to_chat(src, "<span class='notice'>За мной следят, точно.</span>")

/mob/camera/imaginary_friend/mrat/Initialize(mapload, _trauma)
	. = ..()
	costume = new
	costume.Grant(src)
	leave = new
	leave.Grant(src)
	grant_all_languages()

/mob/camera/imaginary_friend/mrat/setup_friend()
	human_image = null

/datum/action/innate/mrat_costume
	name = "Изменить представление"
	desc = "Превращаемся?."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"
	button_icon_state = "ninja_phase"

/datum/action/innate/mrat_costume/Activate()
	var/mob/camera/imaginary_friend/mrat/I = owner
	I.costume()

/datum/action/innate/mrat_leave
	name = "Покинуть"
	desc = "Покинуть тело и вернуться обратно."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"
	button_icon_state = "beam_up"

/datum/action/innate/mrat_leave/Activate()
	var/mob/camera/imaginary_friend/I = owner
	if(tgui_alert(I, "Уже уходим?", "Обещаем вернуться", list("Да", "Нет")) != "Да")
		return
	to_chat(I, "<span class='warning'>Выхожу из тела [I.owner].</span>")
	to_chat(I.owner, "<span class='warning'>Знаток ушёл.</span>")
	qdel(I.trauma)

/mob/camera/imaginary_friend/mrat/pointed(atom/pointed_atom as mob|obj|turf in view())
	if(!..())
		return FALSE

	var/turf/tile = get_turf(pointed_atom)
	if (!tile)
		return

	var/turf/our_tile = get_turf(src)
	var/image/visual = image('icons/hud/screen_gen.dmi', our_tile, "arrow")

	if(owner?.client)
		owner.client.images |= visual
		client.images |= visual
		animate(visual, pixel_x = (tile.x - our_tile.x) * world.icon_size + pointed_atom.pixel_x, pixel_y = (tile.y - our_tile.y) * world.icon_size + pointed_atom.pixel_y, time = 1.7, easing = EASE_OUT)

		spawn(2.5 SECONDS)
			if(owner?.client)
				owner.client.images.Remove(visual)
			if(client)
				client.images.Remove(visual)
			QDEL_NULL(visual)

	to_chat(owner, "<b>[src]</b> показывает на [pointed_atom].")
	to_chat(src, "<span class='notice'>Показываю на [pointed_atom].</span>")
	return TRUE
