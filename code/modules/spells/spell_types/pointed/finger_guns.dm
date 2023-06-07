/datum/action/cooldown/spell/pointed/projectile/finger_guns
	name = "Ручные пистолеты"
	desc = "Выпускайте из пальцев до трех имитированных пуль, которые наносят урон целям и заглушают их крики. \
			Нельзя использовать, если ваши руки заняты."
	background_icon_state = "bg_mime"
	overlay_icon_state = "bg_mime_border"
	button_icon = 'icons/mob/actions/actions_mime.dmi'
	button_icon_state = "finger_guns0"
	panel = "Mime"
	sound = null

	school = SCHOOL_MIME
	cooldown_time = 30 SECONDS

	invocation = ""
	invocation_type = INVOCATION_EMOTE
	invocation_self_message = span_danger("Стреляю из своих пальцев-пистолетов!")

	spell_requirements = SPELL_REQUIRES_HUMAN|SPELL_REQUIRES_MIME_VOW
	antimagic_flags = NONE
	spell_max_level = 1

	active_msg = "Представляю что мои пальцы это пистолеты!"
	deactive_msg = "Расслабляю свои пальцы. Пока что."
	cast_range = 20
	projectile_type = /obj/projectile/bullet/mime
	projectile_amount = 3

/datum/action/cooldown/spell/pointed/projectile/finger_guns/can_invoke(feedback = TRUE)
	if(invocation_type == INVOCATION_EMOTE)
		if(!ishuman(owner))
			return FALSE

		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.incapacitated())
			if(feedback)
				to_chat(owner, span_warning("Не могу правильно представить пистолеты, будучи без руки."))
			return FALSE
		if(human_owner.get_active_held_item())
			if(feedback)
				to_chat(owner, span_warning("Не могу правильно стрелять из пальцев-пистолетов, держа что-то в руке."))
			return FALSE

	return ..()

/datum/action/cooldown/spell/pointed/projectile/finger_guns/before_cast(atom/cast_on)
	. = ..()
	invocation = span_notice("<b>[cast_on]</b> fires [cast_on.p_their()] finger gun!")
