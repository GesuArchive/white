/obj/item/bonesetter/advanced
	name = "экспериментальный биокорректор"
	desc = "Новейший медицинский прототип с генератором костного геля. Вправляет кости, чистит кровь. Генерируемый гель НЕ ПОДДЕРЖИВАЕТ возможности экстренного лечения переломов с помощью хирургической ленты. "
	icon = 'white/Feline/icons/biocorrector.dmi'
	icon_state = "bonesetter_a"
	toolspeed = 0.7

/obj/item/bonesetter/advanced/attack_self(mob/user)
	playsound(get_turf(user), 'sound/items/change_drill.ogg', 50, TRUE)
	if(tool_behaviour == TOOL_BLOODFILTER)
		tool_behaviour = TOOL_BONESET
		to_chat(user, span_notice("При нажатии кнопки [src] перестраивается, теперь он готов к манипуляции с костями."))
		icon_state = "bonesetter_a"
	else
		tool_behaviour = TOOL_BLOODFILTER
		to_chat(user, span_notice("При нажатии кнопки [src] перестраивается, теперь он готов подключится к кровеносной системе."))
		icon_state = "bloodfilter_a"

/obj/item/bonesetter/advanced/examine()
	. = ..()
	. += "<hr>Устройство готово к [tool_behaviour == TOOL_BLOODFILTER ? "фильтрации крови" : "манипуляции с костями"]."
