#define PA_CONSTRUCTION_UNSECURED  0
#define PA_CONSTRUCTION_UNWIRED    1
#define PA_CONSTRUCTION_PANEL_OPEN 2
#define PA_CONSTRUCTION_COMPLETE   3

/obj/structure/particle_accelerator
	name = "ускоритель частиц"
	desc = "Часть ускорителя частиц."
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	icon_state = "none"
	anchored = FALSE
	density = TRUE
	max_integrity = 500
	armor = list("melee" = 30, "bullet" = 20, "laser" = 20, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 90, "acid" = 80)

	var/obj/machinery/particle_accelerator/control_box/master = null
	var/construction_state = PA_CONSTRUCTION_UNSECURED
	var/reference = null
	var/powered = 0
	var/strength = null

/obj/structure/particle_accelerator/examine(mob/user)
	. = ..()

	switch(construction_state)
		if(PA_CONSTRUCTION_UNSECURED)
			. += "<hr>Похоже, он не прикреплен к полу."
		if(PA_CONSTRUCTION_UNWIRED)
			. += "<hr>Не хватает некоторых кабелей."
		if(PA_CONSTRUCTION_PANEL_OPEN)
			. += "<hr>Панель открыта."

/obj/structure/particle_accelerator/Destroy()
	construction_state = PA_CONSTRUCTION_UNSECURED
	if(master)
		master.connected_parts -= src
		master.assembled = 0
		master = null
	return ..()

/obj/structure/particle_accelerator/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS )


/obj/structure/particle_accelerator/set_anchored(anchorvalue)
	. = ..()
	if(isnull(.))
		return
	construction_state = anchorvalue ? PA_CONSTRUCTION_UNWIRED : PA_CONSTRUCTION_UNSECURED
	update_state()
	update_icon()

/obj/structure/particle_accelerator/attackby(obj/item/W, mob/user, params)
	var/did_something = FALSE

	switch(construction_state)
		if(PA_CONSTRUCTION_UNSECURED)
			if(W.tool_behaviour == TOOL_WRENCH && !isinspace())
				W.play_tool_sound(src, 75)
				set_anchored(TRUE)
				user.visible_message(span_notice("<b>[user.name]</b> прикручивает <b>[name]</b> к полу.") , \
					span_notice("Прикручиваю к полу."))
				user.changeNext_move(CLICK_CD_MELEE)
				return //set_anchored handles the rest of the stuff we need to do.
		if(PA_CONSTRUCTION_UNWIRED)
			if(W.tool_behaviour == TOOL_WRENCH)
				W.play_tool_sound(src, 75)
				set_anchored(FALSE)
				user.visible_message(span_notice("<b>[user.name]</b> откручивает <b>[name]</b> от пола.") , \
					span_notice("Откручиваю от пола."))
				user.changeNext_move(CLICK_CD_MELEE)
				return //set_anchored handles the rest of the stuff we need to do.
			else if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/CC = W
				if(CC.use(1))
					user.visible_message(span_notice("<b>[user.name]</b> добавляет кабели в <b>[name]</b>.") , \
						span_notice("Добавляю кабели."))
					construction_state = PA_CONSTRUCTION_PANEL_OPEN
					did_something = TRUE
		if(PA_CONSTRUCTION_PANEL_OPEN)
			if(W.tool_behaviour == TOOL_WIRECUTTER)//TODO:Shock user if its on?
				user.visible_message(span_notice("<b>[user.name]</b> удаляет кабели из <b>[name]</b>.") , \
					span_notice("Убираю кабели."))
				construction_state = PA_CONSTRUCTION_UNWIRED
				did_something = TRUE
			else if(W.tool_behaviour == TOOL_SCREWDRIVER)
				user.visible_message(span_notice("<b>[user.name]</b> закрывает крышку <b>[name]</b>.") , \
					span_notice("Закрываю панель."))
				construction_state = PA_CONSTRUCTION_COMPLETE
				did_something = TRUE
		if(PA_CONSTRUCTION_COMPLETE)
			if(W.tool_behaviour == TOOL_SCREWDRIVER)
				user.visible_message(span_notice("<b>[user.name]</b> открывает крышку <b>[name]</b>.") , \
					span_notice("Открываю панель."))
				construction_state = PA_CONSTRUCTION_PANEL_OPEN
				did_something = TRUE

	if(did_something)
		user.changeNext_move(CLICK_CD_MELEE)
		update_state()
		update_icon()
		return

	return ..()


/obj/structure/particle_accelerator/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/iron (loc, 5)
	qdel(src)

/obj/structure/particle_accelerator/Move()
	. = ..()
	if(master && master.active)
		master.toggle_power()
		investigate_log("was moved whilst active; it <font color='red'>powered down</font>.", INVESTIGATE_SINGULO)


/obj/structure/particle_accelerator/update_icon_state()
	switch(construction_state)
		if(PA_CONSTRUCTION_UNSECURED,PA_CONSTRUCTION_UNWIRED)
			icon_state="[reference]"
		if(PA_CONSTRUCTION_PANEL_OPEN)
			icon_state="[reference]w"
		if(PA_CONSTRUCTION_COMPLETE)
			if(powered)
				icon_state="[reference]p[strength]"
			else
				icon_state="[reference]c"

/obj/structure/particle_accelerator/proc/update_state()
	if(master)
		master.update_state()

/obj/structure/particle_accelerator/proc/connect_master(obj/O)
	if(O.dir == dir)
		master = O
		return 1
	return 0

///////////
// PARTS //
///////////


/obj/structure/particle_accelerator/end_cap
	name = "массив генерации альфа-частиц"
	desc = "Это где альфа-частицы генерируются из \[REDACTED\]."
	icon_state = "end_cap"
	reference = "end_cap"

/obj/structure/particle_accelerator/power_box
	name = "ЭМ объектив с фокусировкой частиц"
	desc = "Это использует электромагнитные волны, чтобы сфокусировать альфа-частицы."
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	icon_state = "power_box"
	reference = "power_box"

/obj/structure/particle_accelerator/fuel_chamber
	name = "ЭМ ускоряющая камера"
	desc = "Это где альфа-частицы ускоряются до <b><i>радикальных скоростей</i></b>."
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	icon_state = "fuel_chamber"
	reference = "fuel_chamber"
