/datum/component/magic
	var/magic_type = "none"
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/magic/Initialize(_magic_type="none")
	magic_type = _magic_type
	return


/obj/item/occult_scanner
	name = "УДВСВПБС"
	desc = "Устройство Для Выявления Следов Влияния ПсведоБожественных Сущностей."
	icon = 'white/shruman/icons/occult_items.dmi'
	icon_state = "scanner"
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/occult_scanner/afterattack(obj/O, mob/living/user)
	if(istype(O, /obj/item))
		if(prob(99))
			O.AddComponent(/datum/component/magic, "none")
		else switch(rand(1,4))
			if(1)
				O.AddComponent(/datum/component/magic, "Narsie")
			if(2)
				O.AddComponent(/datum/component/magic, "Ratvar")
			if(3)
				O.AddComponent(/datum/component/magic, "Devil")
			if(4)
				O.AddComponent(/datum/component/magic, "Jesus")

		var/god = O.GetComponent(/datum/component/magic).magic_type

		switch(god)
			if("Narsie")
				to_chat(user, "<span class='notice'>[O] имеет следы влияния <B><font size =2 font color=#6b0505>Геометра Крови</B>")
			if("Ratvar")
				to_chat(user, "<span class='notice'>[O] имеет следы влияния <B><font size =2 font color=#bf840d>Повелителя Металла</B>")
			if("Devil")
				to_chat(user, "<span class='notice'>[O] имеет следы влияния <B><font size =2 font color=#ff0000>Господина Ада</B>")
			if("Jesus")
				to_chat(user, "<span class='notice'>[O] имеет следы влияния <B><font size =2 font color=#e1f7f2>Космического Мессии</B></span>")
			if("none")
				to_chat(user, "<span class='notice'>[O] чист от влияния псевдобожественных сущностей</span>")
		return
	. = ..()

