/datum/element/art
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/impressiveness = 0

/datum/element/art/Attach(datum/target, impress)
	. = ..()
	if(!isatom(target) || isarea(target))
		return ELEMENT_INCOMPATIBLE
	impressiveness = impress
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/on_examine)

/datum/element/art/Detach(datum/target)
	UnregisterSignal(target, COMSIG_PARENT_EXAMINE)
	return ..()

/datum/element/art/proc/apply_moodlet(atom/source, mob/user, impress)
	SIGNAL_HANDLER

	var/msg
	switch(impress)
		if(GREAT_ART to INFINITY)
			SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "artgreat", /datum/mood_event/artgreat)
			msg = "Что за [pick("шедевральное", "гениальное")] произведение искусства. Какой [pick("непревзойденный", "внушающий благоговение", "завораживающий", "безупречный")] стиль!"
		if (GOOD_ART to GREAT_ART)
			SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "artgood", /datum/mood_event/artgood)
			msg = "Это [pick("уважаемое", "похвальное", "качественное")] произведение искусства, которое можно только увидеть."
		if (BAD_ART to GOOD_ART)
			SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "artok", /datum/mood_event/artok)
			msg = "Это выглядит на среднем уровне, достаточно, чтобы называться \"ИСКУССТВОМ\"."
		if (0 to BAD_ART)
			SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "artbad", /datum/mood_event/artbad)
			msg = "Вау, [source.ru_who()] выглядит ущербно."

	user.visible_message(span_notice("[user] останавливается и пристально смотрит на [source].") , \
		span_notice("Оцениваю [source]... [msg]"))

/datum/element/art/proc/on_examine(atom/source, mob/user, list/examine_texts)
	SIGNAL_HANDLER

	if(!DOING_INTERACTION_WITH_TARGET(user, source))
		INVOKE_ASYNC(src, .proc/appraise, source, user) //Do not sleep the proc.

/datum/element/art/proc/appraise(atom/source, mob/user)
	to_chat(user, span_notice("Любуюсь [source]..."))
	if(!do_after(user, 2 SECONDS, target = source))
		return
	var/mult = 1
	if(isobj(source))
		var/obj/art_piece = source
		mult = art_piece.get_integrity() / art_piece.max_integrity

	apply_moodlet(source, user, impressiveness * mult)

/datum/element/art/rev

/datum/element/art/rev/apply_moodlet(atom/source, mob/user, impress)
	var/msg
	if(user.mind?.has_antag_datum(/datum/antagonist/rev))
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "artgreat", /datum/mood_event/artgreat)
		msg = "Какое [pick("шедевральное", "гениальное")] произведение искусства. Какой [pick("разрушительный", "революционный", "объединяющий", "эгалитарный")] стиль!"
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "artbad", /datum/mood_event/artbad)
		msg = "Вау, [source.ru_who()] выглядит ущербно."

	user.visible_message(span_notice("[user] прекращает изучать [source].") , \
		span_notice("Оцениваю [source], осмотрев искусное мастерство пролетариата... [msg]"))
