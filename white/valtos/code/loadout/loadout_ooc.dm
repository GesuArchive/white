/datum/gear/ooc/char_slot
	display_name = "Ещё один слот персонажа"
	sort_category = "OOC"
	description = "Дополнительный слот. Что тут ещё сказать, а? Максимум 20 слотов."
	cost = 50

/datum/gear/ooc/char_slot/purchase(var/client/C)
	C?.prefs?.max_slots += 1
	C?.prefs?.save_preferences()

/datum/gear/ooc/force_aspect
	display_name = "Выбрать аспект"
	sort_category = "OOC"
	description = "Форсит любой аспект на ваш выбор. Доступно только перед началом раунда (когда игра прогрузилась, но ещё в лобби)."
	cost = 25

/datum/gear/ooc/force_aspect/purchase(var/client/C)
	if (SSticker.current_state == GAME_STATE_SETTING_UP || SSticker.current_state == GAME_STATE_PLAYING || SSticker.current_state == GAME_STATE_FINISHED)
		to_chat(C, "<span class='rose bold'>Невозможно! Доступно только перед началом раунда (когда игра прогрузилась, но ещё в лобби).</span>")
		return
	var/datum/round_aspect/sel_aspect = input("Аспекты:", "Выбирайте!", null, null) as null|anything in SSaspects.aspects
	if(!sel_aspect)
		to_chat(C, "<span class='notice'>Не выбран аспект.</span>")
		return
	else
		if(..())
			to_chat(C, "<span class='notice'>Выбрано <b>[sel_aspect]</b>! Другие игроки могут добавить ещё аспекты.</span>")
			SSaspects.forced_aspects[sel_aspect] = sel_aspect.weight

/datum/gear/ooc/purge_this_shit
	display_name = "Фатальный сброс"
	sort_category = "OOC"
	description = "Сбрасывает метакэш до нуля. Всем."
	cost = 2500

/datum/gear/ooc/purge_this_shit/purchase(var/client/C)
	var/fuck_everyone = alert(src,"Это действие приведёт обнулению ВСЕГО метакэша. Ты уверен?","Очищение","Да","Нет")
	if (fuck_everyone == "Да")
		var/datum/db_query/purge_shit = SSdbcore.NewQuery("UPDATE [format_table_name("player")] SET metacoins = '0'")
		purge_shit.warn_execute()
		for(var/client/AAA in GLOB.clients)
			AAA.update_metabalance_cache()

		if(isliving(C.mob) && C.mob.stat == CONSCIOUS)
			explosion(get_turf(C.mob), 14, 28, 56)

		to_chat(world, "<BR><BR><BR><center><span class='big bold'>[C.ckey] уничтожает банк метакэша.</span></center><BR><BR><BR>")

