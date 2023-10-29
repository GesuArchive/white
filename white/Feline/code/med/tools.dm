/obj/item/bonesetter/advanced
	name = "биокорректор"
	desc = "Новейший медицинский прототип с синтезатором костного геля. Вправляет кости, чистит кровь и лимфу. Нанесение костного геля возможно только при инвазивном вмешательстве."
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

/obj/item/storage/box/beakers/large_beakers
	name = "коробка больших химических стаканов"
	illustration = "large_beaker"

/obj/item/storage/box/beakers/large_beakers/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/glass/beaker/large( src )

/obj/item/storage/box/meta_beakers
	name = "коробка метаматериальных химических стаканов"
	illustration = "meta_beaker"

/obj/item/storage/box/meta_beakers/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/glass/beaker/meta( src )

// 	Дыхательная груша
/obj/item/breathing_bag
	name = "дыхательная груша"
	desc = "Она же мешок Амбу — механическое ручное устройство для выполнения искусственной вентиляции лёгких."
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "breathing_bag"
	lefthand_file = 'icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing_righthand.dmi'
	inhand_icon_state = "m_mask"
	custom_materials = list(/datum/material/iron=5000, /datum/material/glass=2500)
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 1

/obj/item/breathing_bag/attack(mob/living/M, mob/user)
	if(M == user)
		return
	if (M.is_mouth_covered())
		to_chat(user, span_warning("Для произведения ИВЛ с пациента надо снять маску!"))
		return
	to_chat(user, span_notice("Прикладываю дыхательную маску к лицу [skloname(M.name, RODITELNI, M.gender)]."))
	if(!do_after(user, 30, user))
		to_chat(user, span_warning("Не получается!"))
		return
	. = ..()
	playsound(user,'white/Feline/sounds/breathing_bag.ogg', 100, TRUE)
	for(var/ivl in 1 to 15)
		if(!do_after(user, 10, user))
			return
		to_chat(user, span_notice("Произвожу искуственную вентиляцию легких!"))
		M.adjustOxyLoss(-15)
