////////////////////////////////
///// Construction datums //////
////////////////////////////////
/datum/component/construction/mecha
	var/base_icon

	// Component typepaths.
	// most must be defined unless
	// get_steps is overriden.

	// Circuit board typepaths.
	// circuit_control and circuit_periph must be defined
	// unless get_circuit_steps is overriden.
	var/circuit_control
	var/circuit_periph
	var/circuit_weapon

	// Armor plating typepaths. both must be defined
	// unless relevant step procs are overriden. amounts
	// must be defined if using /obj/item/stack/sheet types
	var/inner_plating
	var/inner_plating_amount

	var/outer_plating
	var/outer_plating_amount

/datum/component/construction/mecha/spawn_result()
	if(!result)
		return
	// Remove default mech power cell, as we replace it with a new one.
	var/obj/vehicle/sealed/mecha/M = new result(drop_location())
	QDEL_NULL(M.cell)
	QDEL_NULL(M.scanmod)
	QDEL_NULL(M.capacitor)

	var/obj/item/mecha_parts/chassis/parent_chassis = parent
	M.CheckParts(parent_chassis.contents)

	SSblackbox.record_feedback("tally", "mechas_created", 1, M.name)
	QDEL_NULL(parent)

// Default proc to generate mech steps.
// Override if the mech needs an entirely custom process (See HONK mech)
// Otherwise override specific steps as needed (Ripley, Clarke, Phazon)
/datum/component/construction/mecha/proc/get_steps()
	return get_frame_steps() + get_circuit_steps() + (circuit_weapon ? get_circuit_weapon_steps() : list()) + get_stockpart_steps() + get_inner_plating_steps() + get_outer_plating_steps()

/datum/component/construction/mecha/update_parent(step_index)
	steps = get_steps()
	..()
	// By default, each step in mech construction has a single icon_state:
	// "[base_icon][index - 1]"
	// For example, Ripley's step 1 icon_state is "ripley0".
	var/atom/parent_atom = parent
	if(!steps[index]["icon_state"] && base_icon)
		parent_atom.icon_state = "[base_icon][index - 1]"

/datum/component/construction/unordered/mecha_chassis/custom_action(obj/item/I, mob/living/user, typepath)
	. = user.transferItemToLoc(I, parent)
	if(.)
		var/atom/parent_atom = parent
		user.visible_message(span_notice("<b>[user]</b> подключает <b>[I]</b> к <b>[parent]</b>.") , span_notice("Подключаю <b>[I.name]</b> к <b>[parent]</b>."))
		parent_atom.add_overlay(I.icon_state+"+o")
		qdel(I)

/datum/component/construction/unordered/mecha_chassis/spawn_result()
	var/atom/parent_atom = parent
	parent_atom.icon = 'icons/mecha/mech_construction.dmi'
	parent_atom.set_density(TRUE)
	parent_atom.cut_overlays()
	..()

// Default proc for the first steps of mech construction.
/datum/component/construction/mecha/proc/get_frame_steps()
	return list(
		list(
			"key" = TOOL_WRENCH,
			"desc" = "Гидравлические системы отключены."
		),
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_WRENCH,
			"desc" = "Гидравлические системы подключены."
		),
		list(
			"key" = /obj/item/stack/cable_coil,
			"amount" = 5,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Гидравлические системы активны."
		),
		list(
			"key" = TOOL_WIRECUTTER,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Проводка добавлена."
		)
	)

// Default proc for the circuit board steps of a mech.
// Second set of steps by default.
/datum/component/construction/mecha/proc/get_circuit_steps()
	return list(
		list(
			"key" = circuit_control,
			"action" = ITEM_DELETE,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Проводка настроена."
		),
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Модуль центрального управления установлен."
		),
		list(
			"key" = circuit_periph,
			"action" = ITEM_DELETE,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Модуль центрального управления закреплён."
		),
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Модуль управления периферией установлен."
		)
	)

// Default proc for weapon circuitboard steps
// Used by combat mechs
/datum/component/construction/mecha/proc/get_circuit_weapon_steps()
	return list(
		list(
			"key" = circuit_weapon,
			"action" = ITEM_DELETE,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Модуль управления периферией закреплён."
		),
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Модуль управления оружием установлен."
		)
	)

// Default proc for stock part installation
// Third set of steps by default
/datum/component/construction/mecha/proc/get_stockpart_steps()
	var/prevstep_text = circuit_weapon ? "Модуль управления оружием закреплён." : "Модуль управления периферией закреплён."
	return list(
		list(
			"key" = /obj/item/stock_parts/scanning_module,
			"action" = ITEM_MOVE_INSIDE,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = prevstep_text
		),
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Модуль сканирования установлен."
		),
		list(
			"key" = /obj/item/stock_parts/capacitor,
			"action" = ITEM_MOVE_INSIDE,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Модуль сканирования закреплён."
		),
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Конденсатор установлен."
		),
		list(
			"key" = /obj/item/stock_parts/cell,
			"action" = ITEM_MOVE_INSIDE,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Конденсатор закреплён."
		),
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Аккумулятор установлен."
		)
	)

// Default proc for inner armor plating
// Fourth set of steps by default
/datum/component/construction/mecha/proc/get_inner_plating_steps()
	var/list/first_step
	if(ispath(inner_plating, /obj/item/stack/sheet))
		first_step = list(
			list(
				"key" = inner_plating,
				"amount" = inner_plating_amount,
				"back_key" = TOOL_SCREWDRIVER,
				"desc" = "Аккумулятор закреплён."
			)
		)
	else
		first_step = list(
			list(
				"key" = inner_plating,
				"action" = ITEM_DELETE,
				"back_key" = TOOL_SCREWDRIVER,
				"desc" = "Аккумулятор закреплён."
			)
		)

	return first_step + list(
		list(
			"key" = TOOL_WRENCH,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Внутренняя обшивка установлена."
		),
		list(
			"key" = TOOL_WELDER,
			"back_key" = TOOL_WRENCH,
			"desc" = "Внутренняя обшивка прикручена."
		)
	)

// Default proc for outer armor plating
// Fifth set of steps by default
/datum/component/construction/mecha/proc/get_outer_plating_steps()
	var/list/first_step
	if(ispath(outer_plating, /obj/item/stack/sheet))
		first_step = list(
			list(
				"key" = outer_plating,
				"amount" = outer_plating_amount,
				"back_key" = TOOL_WELDER,
				"desc" = "Внутренняя обшивка приварена."
			)
		)
	else
		first_step = list(
			list(
				"key" = outer_plating,
				"action" = ITEM_DELETE,
				"back_key" = TOOL_WELDER,
				"desc" = "Внутренняя обшивка приварена."
			)
		)

	return first_step + list(
		list(
			"key" = TOOL_WRENCH,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Внешняя обшивка установлена."
		),
		list(
			"key" = TOOL_WELDER,
			"back_key" = TOOL_WRENCH,
			"desc" = "Внешняя обшивка прикручена."
		)
	)


/datum/component/construction/unordered/mecha_chassis/ripley
	result = /datum/component/construction/mecha/ripley
	steps = list(
		/obj/item/mecha_parts/part/ripley_torso,
		/obj/item/mecha_parts/part/ripley_left_arm,
		/obj/item/mecha_parts/part/ripley_right_arm,
		/obj/item/mecha_parts/part/ripley_left_leg,
		/obj/item/mecha_parts/part/ripley_right_leg
	)

/datum/component/construction/mecha/ripley
	result = /obj/vehicle/sealed/mecha/working/ripley
	base_icon = "ripley"

	circuit_control = /obj/item/circuitboard/mecha/ripley/main
	circuit_periph = /obj/item/circuitboard/mecha/ripley/peripherals

	inner_plating=/obj/item/stack/sheet/iron
	inner_plating_amount = 5

	outer_plating=/obj/item/stack/rods
	outer_plating_amount = 10

/datum/component/construction/mecha/ripley/get_outer_plating_steps()
	return list(
		list(
			"key" = /obj/item/stack/rods,
			"amount" = 10,
			"back_key" = TOOL_WELDER,
			"desc" = "Наружное покрытие приварено."
		),
		list(
			"key" = TOOL_WELDER,
			"back_key" = TOOL_WIRECUTTER,
			"desc" = "Защита кабины установлена."
		),
	)

/datum/component/construction/mecha/ripley/custom_action(obj/item/I, mob/living/user, diff)
	if(!..())
		return FALSE

	switch(index)
		if(1)
			user.visible_message(span_notice("<b>[user]</b> подключает гидравлическую систему <b>[parent]</b>.") , span_notice("Подключаю гидравлическую систему <b>[parent]</b>."))
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> активирует гидравлическую систему <b>[parent]</b>.") , span_notice("Активирую гидравлическую систему <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает гидравлическую систему <b>[parent]</b>.") , span_notice("Отключаю гидравлическую систему <b>[parent]</b>."))
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает проводку в <b>[parent]</b>.") , span_notice("Устанавливаю проводку в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> деактивирует гидравлическую систему <b>[parent]</b>.") , span_notice("Деактивирую гидравлическую систему <b>[parent]</b>."))
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> настраивает проводку в <b>[parent]</b>.") , span_notice("Настраиваю проводку в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет проводку из <b>[parent]</b>.") , span_notice("Удаляю проводку из <b>[parent]</b>."))
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает проводку в <b>[parent]</b>.") , span_notice("Отключаю проводку в <b>[parent]</b>."))
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет основную плату.") , span_notice("Закрепляю основную плату."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль центрального управления из <b>[parent]</b>.") , span_notice("Удаляю модуль центрального управления из <b>[parent]</b>."))
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает основную плату.") , span_notice("Откручиваю основную плату."))
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль управления периферией.") , span_notice("Закрепляю модуль управления периферией."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль управления периферией из <b>[parent]</b>.") , span_notice("Удаляю модуль управления периферией из <b>[parent]</b>."))
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль управления периферией.") , span_notice("Откручиваю модуль управления периферией."))
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль сканирования.") , span_notice("Закрепляю модуль сканирования."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль сканирования из <b>[parent]</b>.") , span_notice("Удаляю модуль сканирования из <b>[parent]</b>."))
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль сканирования.") , span_notice("Откручиваю модуль сканирования."))
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет <b>[I.name]</b>.") , span_notice("<b>[user]</b> закрепляю <b>[I.name]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет конденсатор из <b>[parent]</b>.") , span_notice("Удаляю конденсатор из <b>[parent]</b>."))
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b>.") , span_notice("Устанавливаю <b>[I.name]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает конденсатор в <b>[parent]</b>.") , span_notice("Откручиваю конденсатор в <b>[parent]</b>."))
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет аккумулятор.") , span_notice("Закрепляю аккумулятор."))
			else
				user.visible_message(span_notice("<b>[user]</b> вытаскивает аккумулятор из <b>[parent]</b>.") , span_notice("Вытаскиваю аккумулятор из <b>[parent]</b>."))
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает внутреннюю обшивку <b>[parent]</b>.") , span_notice("Устанавливаю внутреннюю обшивку <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает аккумулятор.") , span_notice("Откручиваю аккумулятор."))
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет внутреннюю обшивку.") , span_notice("Закрепляю внутреннюю обшивку."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает внутреннюю обшивку <b>[parent]</b>.") , span_notice("Снимаю внутреннюю обшивку <b>[parent]</b>."))
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> приваривает внутреннюю обшивку к <b>[parent]</b>.") , span_notice("Привариваю внутреннюю обшивку к <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает внутреннюю обшивку.") , span_notice("Откручиваю внутреннюю обшивку."))
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает внешнюю обшивку <b>[parent]</b>.") , span_notice("Устанавливаю внешнюю обшивку на <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> срезает внутреннюю обшивку с <b>[parent]</b>.") , span_notice("Срезаю внутреннюю обшивку с <b>[parent]</b>."))
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет внешнюю обшивку.") , span_notice("Закрепляю внешнюю обшивку."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает внешнюю обшивку <b>[parent]</b>.") , span_notice("Снимаю внешнюю обшивку <b>[parent]</b>."))
		if(20)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> приваривает внешнюю обшивку к <b>[parent]</b>.") , span_notice("Привариваю внешнюю обшивку к <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает внешнюю обшивку.") , span_notice("Откручиваю внешнюю обшивку."))
	return TRUE

/datum/component/construction/unordered/mecha_chassis/gygax
	result = /datum/component/construction/mecha/gygax
	steps = list(
		/obj/item/mecha_parts/part/gygax_torso,
		/obj/item/mecha_parts/part/gygax_left_arm,
		/obj/item/mecha_parts/part/gygax_right_arm,
		/obj/item/mecha_parts/part/gygax_left_leg,
		/obj/item/mecha_parts/part/gygax_right_leg,
		/obj/item/mecha_parts/part/gygax_head
	)

/datum/component/construction/mecha/gygax
	result = /obj/vehicle/sealed/mecha/combat/gygax
	base_icon = "gygax"

	circuit_control = /obj/item/circuitboard/mecha/gygax/main
	circuit_periph = /obj/item/circuitboard/mecha/gygax/peripherals
	circuit_weapon = /obj/item/circuitboard/mecha/gygax/targeting

	inner_plating = /obj/item/stack/sheet/iron
	inner_plating_amount = 5

	outer_plating=/obj/item/mecha_parts/part/gygax_armor
	outer_plating_amount=1

/datum/component/construction/mecha/gygax/action(datum/source, atom/used_atom, mob/user)
	ASYNC //This proc will never actually sleep, it calls do_after with a time of 0.
		. = check_step(used_atom, user)
	return .

/datum/component/construction/mecha/gygax/custom_action(obj/item/I, mob/living/user, diff)
	if(!..())
		return FALSE

	switch(index)
		if(1)
			user.visible_message(span_notice("<b>[user]</b> подключает гидравлическую систему <b>[parent]</b>.") , span_notice("Подключаю гидравлическую систему <b>[parent]</b>."))
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> активирует гидравлическую систему <b>[parent]</b>.") , span_notice("Активирую гидравлическую систему <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает гидравлическую систему <b>[parent]</b>.") , span_notice("Отключаю гидравлическую систему <b>[parent]</b>."))
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает проводку в <b>[parent]</b>.") , span_notice("Устанавливаю проводку в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> деактивирует гидравлическую систему <b>[parent]</b>.") , span_notice("Деактивирую гидравлическую систему <b>[parent]</b>."))
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> настраивает проводку в <b>[parent]</b>.") , span_notice("Настраиваю проводку в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет проводку из <b>[parent]</b>.") , span_notice("Удаляю проводку из <b>[parent]</b>."))
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает проводку в <b>[parent]</b>.") , span_notice("Отключаю проводку в <b>[parent]</b>."))
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет основную плату.") , span_notice("Закрепляю основную плату."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль центрального управления из <b>[parent]</b>.") , span_notice("Удаляю модуль центрального управления из <b>[parent]</b>."))
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает основную плату.") , span_notice("Откручиваю основную плату."))
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль управления периферией.") , span_notice("Закрепляю модуль управления периферией."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль управления периферией из <b>[parent]</b>.") , span_notice("Удаляю модуль управления периферией из <b>[parent]</b>."))
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль управления периферией.") , span_notice("Откручиваю модуль управления периферией."))
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль управления оружием.") , span_notice("Закрепляю модуль управления оружием."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль управления оружием из <b>[parent]</b>.") , span_notice("Удаляю модуль управления оружием из <b>[parent]</b>."))
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль управления оружием.") , span_notice("Откручиваю модуль управления оружием."))
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль сканирования.") , span_notice("Закрепляю модуль сканирования."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль сканирования из <b>[parent]</b>.") , span_notice("Удаляю модуль сканирования из <b>[parent]</b>."))
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль сканирования.") , span_notice("Откручиваю модуль сканирования."))
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет конденсатор.") , span_notice("Закрепляю конденсатор."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет конденсатор из <b>[parent]</b>.") , span_notice("Удаляю конденсатор из <b>[parent]</b>."))
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает конденсатор.") , span_notice("Откручиваю конденсатор."))
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет аккумулятор.") , span_notice("Закрепляю аккумулятор."))
			else
				user.visible_message(span_notice("<b>[user]</b> вытаскивает аккумулятор из <b>[parent]</b>.") , span_notice("Вытаскиваю аккумулятор из <b>[parent]</b>."))
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает внутреннюю обшивку <b>[parent]</b>.") , span_notice("Устанавливаю внутреннюю обшивку <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает аккумулятор.") , span_notice("Откручиваю аккумулятор."))
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет внутреннюю обшивку.") , span_notice("Закрепляю внутреннюю обшивку."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает внутреннюю обшивку <b>[parent]</b>.") , span_notice("Снимаю внутреннюю обшивку <b>[parent]</b>."))
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> приваривает внутреннюю обшивку к <b>[parent]</b>.") , span_notice("Привариваю внутреннюю обшивку к <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает внутреннюю обшивку.") , span_notice("Откручиваю внутреннюю обшивку."))
		if(20)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> срезает внутреннюю обшивку с <b>[parent]</b>.") , span_notice("Срезаю внутреннюю обшивку с <b>[parent]</b>."))
		if(21)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет Gygax Armor Plates.") , span_notice("Закрепляю Gygax Armor Plates."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает Gygax Armor Plates с <b>[parent]</b>.") , span_notice("Снимаю Gygax Armor Plates с <b>[parent]</b>."))
		if(22)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> приваривает Gygax Armor Plates к <b>[parent]</b>.") , span_notice("Привариваю Gygax Armor Plates к <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает Gygax Armor Plates.") , span_notice("Откручиваю Gygax Armor Plates."))
	return TRUE

/datum/component/construction/unordered/mecha_chassis/clarke
	result = /datum/component/construction/mecha/clarke
	steps = list(
		/obj/item/mecha_parts/part/clarke_torso,
		/obj/item/mecha_parts/part/clarke_left_arm,
		/obj/item/mecha_parts/part/clarke_right_arm,
		/obj/item/mecha_parts/part/clarke_head
	)

/datum/component/construction/mecha/clarke
	result = /obj/vehicle/sealed/mecha/working/clarke
	base_icon = "clarke"

	circuit_control = /obj/item/circuitboard/mecha/clarke/main
	circuit_periph = /obj/item/circuitboard/mecha/clarke/peripherals

	inner_plating = /obj/item/stack/sheet/plasteel
	inner_plating_amount = 5

	outer_plating = /obj/item/stack/sheet/mineral/gold
	outer_plating_amount = 5

/datum/component/construction/mecha/clarke/get_frame_steps()
	return list(
		list(
			"key" = /obj/item/stack/conveyor,
			"amount" = 4,
			"desc" = "Гусеницы установлены."
		),
		list(
			"key" = TOOL_WRENCH,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Гидравлические системы отключены."
		),
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_WRENCH,
			"desc" = "Гидравлические системы подключены."
		),
		list(
			"key" = /obj/item/stack/cable_coil,
			"amount" = 5,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Гидравлические системы активны."
		),
		list(
			"key" = TOOL_WIRECUTTER,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Проводка добавлена."
		)
	)



/datum/component/construction/mecha/clarke/custom_action(obj/item/I, mob/living/user, diff)
	if(!..())
		return FALSE

	//TODO: better messages.
	switch(index)
		if(1)
			user.visible_message(span_notice("<b>[user]</b> устанавливает гусеницы.") , span_notice("Устанавливаю гусеницы."))
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> подключает гидравлическую систему <b>[parent]</b>.") , span_notice("Подключаю гидравлическую систему <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает гусеницы.") , span_notice("Снимаю гусеницы."))

		if(3)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> активирует гидравлическую систему <b>[parent]</b>.") , span_notice("Активирую гидравлическую систему <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает гидравлическую систему <b>[parent]</b>.") , span_notice("Отключаю гидравлическую систему <b>[parent]</b>."))
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает проводку в <b>[parent]</b>.") , span_notice("Устанавливаю проводку в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> деактивирует гидравлическую систему <b>[parent]</b>.") , span_notice("Деактивирую гидравлическую систему <b>[parent]</b>."))
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> настраивает проводку в <b>[parent]</b>.") , span_notice("Настраиваю проводку в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет проводку из <b>[parent]</b>.") , span_notice("Удаляю проводку из <b>[parent]</b>."))
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает проводку в <b>[parent]</b>.") , span_notice("Отключаю проводку в <b>[parent]</b>."))
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет основную плату.") , span_notice("Закрепляю основную плату."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль центрального управления из <b>[parent]</b>.") , span_notice("Удаляю модуль центрального управления из <b>[parent]</b>."))
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает основную плату.") , span_notice("Откручиваю основную плату."))
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль управления периферией.") , span_notice("Закрепляю модуль управления периферией."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль управления периферией из <b>[parent]</b>.") , span_notice("Удаляю модуль управления периферией из <b>[parent]</b>."))
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль управления периферией.") , span_notice("Откручиваю модуль управления периферией."))
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль сканирования.") , span_notice("Закрепляю модуль сканирования."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль сканирования из <b>[parent]</b>.") , span_notice("Удаляю модуль сканирования из <b>[parent]</b>."))
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль сканирования.") , span_notice("Откручиваю модуль сканирования."))
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет конденсатор.") , span_notice("Закрепляю конденсатор."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет конденсатор из <b>[parent]</b>.") , span_notice("Удаляю конденсатор из <b>[parent]</b>."))
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает конденсатор.") , span_notice("Откручиваю конденсатор."))
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет аккумулятор.") , span_notice("Закрепляю аккумулятор."))
			else
				user.visible_message(span_notice("<b>[user]</b> вытаскивает аккумулятор из <b>[parent]</b>.") , span_notice("Вытаскиваю аккумулятор из <b>[parent]</b>."))
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает внутреннюю обшивку <b>[parent]</b>.") , span_notice("Устанавливаю внутреннюю обшивку <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает аккумулятор.") , span_notice("Откручиваю аккумулятор."))
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет внутреннюю обшивку.") , span_notice("Закрепляю внутреннюю обшивку."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает внутреннюю обшивку <b>[parent]</b>.") , span_notice("Снимаю внутреннюю обшивку <b>[parent]</b>."))
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> приваривает внутреннюю обшивку к <b>[parent]</b>.") , span_notice("Привариваю внутреннюю обшивку к <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает внутреннюю обшивку.") , span_notice("Откручиваю внутреннюю обшивку."))
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает внешнюю обшивку на <b>[parent]</b>.") , span_notice("Устанавливаю внешнюю обшивку на <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> срезает внутреннюю обшивку с <b>[parent]</b>.") , span_notice("Срезаю внутреннюю обшивку с <b>[parent]</b>."))
		if(20)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет внешнюю обшивку.") , span_notice("Закрепляю внешнюю обшивку."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает внешнюю обшивку с <b>[parent]</b>.") , span_notice("Снимаю внешнюю обшивку с <b>[parent]</b>."))
		if(21)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> приваривает внешнюю обшивку к <b>[parent]</b>.") , span_notice("Привариваю внешнюю обшивку к <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает внешнюю обшивку.") , span_notice("Откручиваю внешнюю обшивку."))
	return TRUE


/datum/component/construction/unordered/mecha_chassis/honker
	result = /datum/component/construction/mecha/honker
	steps = list(
		/obj/item/mecha_parts/part/honker_torso,
		/obj/item/mecha_parts/part/honker_left_arm,
		/obj/item/mecha_parts/part/honker_right_arm,
		/obj/item/mecha_parts/part/honker_left_leg,
		/obj/item/mecha_parts/part/honker_right_leg,
		/obj/item/mecha_parts/part/honker_head
	)

/datum/component/construction/mecha/honker
	result = /obj/vehicle/sealed/mecha/combat/honker
	steps = list(
		list(
			"key" = /obj/item/bikehorn
		),
		list(
			"key" = /obj/item/circuitboard/mecha/honker/main,
			"action" = ITEM_DELETE
		),
		list(
			"key" = /obj/item/bikehorn
		),
		list(
			"key" = /obj/item/circuitboard/mecha/honker/peripherals,
			"action" = ITEM_DELETE
		),
		list(
			"key" = /obj/item/bikehorn
		),
		list(
			"key" = /obj/item/circuitboard/mecha/honker/targeting,
			"action" = ITEM_DELETE
		),
		list(
			"key" = /obj/item/bikehorn
		),
		list(
			"key" = /obj/item/stock_parts/scanning_module,
			"action" = ITEM_MOVE_INSIDE
		),
		list(
			"key" = /obj/item/bikehorn
		),
		list(
			"key" = /obj/item/stock_parts/capacitor,
			"action" = ITEM_MOVE_INSIDE
		),
		list(
			"key" = /obj/item/bikehorn
		),
		list(
			"key" = /obj/item/stock_parts/cell,
			"action" = ITEM_MOVE_INSIDE
		),
		list(
			"key" = /obj/item/bikehorn
		),
		list(
			"key" = /obj/item/clothing/mask/gas/clown_hat,
			"action" = ITEM_DELETE
		),
		list(
			"key" = /obj/item/bikehorn
		),
		list(
			"key" = /obj/item/clothing/shoes/clown_shoes,
			"action" = ITEM_DELETE
		),
		list(
			"key" = /obj/item/bikehorn
		),
	)

/datum/component/construction/mecha/honker/get_steps()
	return steps

// HONK doesn't have any construction step icons, so we just set an icon once.
/datum/component/construction/mecha/honker/update_parent(step_index)
	if(step_index == 1)
		var/atom/parent_atom = parent
		parent_atom.icon = 'icons/mecha/mech_construct.dmi'
		parent_atom.icon_state = "honker_chassis"
	..()

/datum/component/construction/mecha/honker/custom_action(obj/item/I, mob/living/user, diff)
	if(!..())
		return FALSE

	if(istype(I, /obj/item/bikehorn))
		playsound(parent, 'sound/items/bikehorn.ogg', 50, TRUE)
		user.visible_message(span_danger("ХОНК!"))

	//TODO: better messages.
	switch(index)
		if(2)
			user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
		if(4)
			user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
		if(6)
			user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
		if(8)
			user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
		if(10)
			user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
		if(12)
			user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
		if(14)
			user.visible_message(span_notice("<b>[user]</b> гениально устанавливает <b>[I.name]</b> на <b>[parent]</b>.") , span_notice("Гениально устанавливаю <b>[I.name]</b> на <b>[parent]</b>."))
		if(16)
			user.visible_message(span_notice("<b>[user]</b> гениально устанавливает <b>[I.name]</b> на <b>[parent]</b>.") , span_notice("Гениально устанавливаю <b>[I.name]</b> на <b>[parent]</b>."))
	return TRUE

/datum/component/construction/unordered/mecha_chassis/durand
	result = /datum/component/construction/mecha/durand
	steps = list(
		/obj/item/mecha_parts/part/durand_torso,
		/obj/item/mecha_parts/part/durand_left_arm,
		/obj/item/mecha_parts/part/durand_right_arm,
		/obj/item/mecha_parts/part/durand_left_leg,
		/obj/item/mecha_parts/part/durand_right_leg,
		/obj/item/mecha_parts/part/durand_head
	)

/datum/component/construction/mecha/durand
	result = /obj/vehicle/sealed/mecha/combat/durand
	base_icon = "durand"

	circuit_control = /obj/item/circuitboard/mecha/durand/main
	circuit_periph = /obj/item/circuitboard/mecha/durand/peripherals
	circuit_weapon = /obj/item/circuitboard/mecha/durand/targeting

	inner_plating = /obj/item/stack/sheet/iron
	inner_plating_amount = 5

	outer_plating = /obj/item/mecha_parts/part/durand_armor
	outer_plating_amount = 1

/datum/component/construction/mecha/durand/custom_action(obj/item/I, mob/living/user, diff)
	if(!..())
		return FALSE

	//TODO: better messages.
	switch(index)
		if(1)
			user.visible_message(span_notice("<b>[user]</b> подключает гидравлическую систему <b>[parent]</b>.") , span_notice("Подключаю гидравлическую систему <b>[parent]</b>."))
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> активирует гидравлическую систему <b>[parent]</b>.") , span_notice("Активирую гидравлическую систему <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает гидравлическую систему <b>[parent]</b>.") , span_notice("Отключаю гидравлическую систему <b>[parent]</b>."))
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает проводку в <b>[parent]</b>.") , span_notice("Устанавливаю проводку в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> деактивирует гидравлическую систему <b>[parent]</b>.") , span_notice("Деактивирую гидравлическую систему <b>[parent]</b>."))
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> настраивает проводку в <b>[parent]</b>.") , span_notice("Настраиваю проводку в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет проводку из <b>[parent]</b>.") , span_notice("Удаляю проводку из <b>[parent]</b>."))
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает проводку в <b>[parent]</b>.") , span_notice("Отключаю проводку в <b>[parent]</b>."))
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет основную плату.") , span_notice("Закрепляю основную плату."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль центрального управления из <b>[parent]</b>.") , span_notice("Удаляю модуль центрального управления из <b>[parent]</b>."))
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает основную плату.") , span_notice("Откручиваю основную плату."))
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль управления периферией.") , span_notice("Закрепляю модуль управления периферией."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль управления периферией из <b>[parent]</b>.") , span_notice("Удаляю модуль управления периферией из <b>[parent]</b>."))
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль управления периферией.") , span_notice("Откручиваю модуль управления периферией."))
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль управления оружием.") , span_notice("Закрепляю модуль управления оружием."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль управления оружием из <b>[parent]</b>.") , span_notice("Удаляю модуль управления оружием из <b>[parent]</b>."))
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль управления оружием.") , span_notice("Откручиваю модуль управления оружием."))
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль сканирования.") , span_notice("Закрепляю модуль сканирования."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль сканирования из <b>[parent]</b>.") , span_notice("Удаляю модуль сканирования из <b>[parent]</b>."))
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль сканирования.") , span_notice("Откручиваю модуль сканирования."))
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет конденсатор.") , span_notice("Закрепляю конденсатор."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет конденсатор из <b>[parent]</b>.") , span_notice("Удаляю конденсатор из <b>[parent]</b>."))
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает конденсатор.") , span_notice("Откручиваю конденсатор."))
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет аккумулятор.") , span_notice("Закрепляю аккумулятор."))
			else
				user.visible_message(span_notice("<b>[user]</b> вытаскивает аккумулятор из <b>[parent]</b>.") , span_notice("Вытаскиваю аккумулятор из <b>[parent]</b>."))
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает внутреннюю обшивку <b>[parent]</b>.") , span_notice("Устанавливаю внутреннюю обшивку <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает аккумулятор.") , span_notice("Откручиваю аккумулятор."))
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет внутреннюю обшивку.") , span_notice("Закрепляю внутреннюю обшивку."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает внутреннюю обшивку <b>[parent]</b>.") , span_notice("Снимаю внутреннюю обшивку <b>[parent]</b>."))
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> приваривает внутреннюю обшивку к <b>[parent]</b>.") , span_notice("Привариваю внутреннюю обшивку к <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает внутреннюю обшивку.") , span_notice("Откручиваю внутреннюю обшивку."))
		if(20)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> срезает внутреннюю обшивку с <b>[parent]</b>.") , span_notice("Срезаю внутреннюю обшивку с <b>[parent]</b>."))
		if(21)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет Durand Armor Plates.") , span_notice("Закрепляю Durand Armor Plates."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает Durand Armor Plates с <b>[parent]</b>.") , span_notice("Снимаю Durand Armor Plates с <b>[parent]</b>."))
		if(22)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> приваривает Durand Armor Plates к <b>[parent]</b>.") , span_notice("Привариваю Durand Armor Plates к <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает Durand Armor Plates.") , span_notice("Откручиваю Durand Armor Plates."))
	return TRUE

//PHAZON

/datum/component/construction/unordered/mecha_chassis/phazon
	result = /datum/component/construction/mecha/phazon
	steps = list(
		/obj/item/mecha_parts/part/phazon_torso,
		/obj/item/mecha_parts/part/phazon_left_arm,
		/obj/item/mecha_parts/part/phazon_right_arm,
		/obj/item/mecha_parts/part/phazon_left_leg,
		/obj/item/mecha_parts/part/phazon_right_leg,
		/obj/item/mecha_parts/part/phazon_head
	)

/datum/component/construction/mecha/phazon
	result = /obj/vehicle/sealed/mecha/combat/phazon
	base_icon = "phazon"

	circuit_control = /obj/item/circuitboard/mecha/phazon/main
	circuit_periph = /obj/item/circuitboard/mecha/phazon/peripherals
	circuit_weapon = /obj/item/circuitboard/mecha/phazon/targeting

	inner_plating = /obj/item/stack/sheet/plasteel
	inner_plating_amount = 5

	outer_plating = /obj/item/mecha_parts/part/phazon_armor
	outer_plating_amount = 1

/datum/component/construction/mecha/phazon/get_stockpart_steps()
	return list(
		list(
			"key" = /obj/item/stock_parts/scanning_module,
			"action" = ITEM_MOVE_INSIDE,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Модуль управления оружием."
		),
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Модуль сканирования установлен."
		),
		list(
			"key" = /obj/item/stock_parts/capacitor,
			"action" = ITEM_MOVE_INSIDE,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Модуль сканирования закреплён."
		),
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Конденсатор установлен."
		),
		list(
			"key" = /obj/item/stack/ore/bluespace_crystal,
			"amount" = 1,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Конденсатор закреплён."
		),
		list(
			"key" = /obj/item/stack/cable_coil,
			"amount" = 5,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Блюспейс кристалл установлен."
		),
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_WIRECUTTER,
			"desc" = "Блюспейс кристалл подключен."
		),
		list(
			"key" = /obj/item/stock_parts/cell,
			"action" = ITEM_MOVE_INSIDE,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "Блюспейс кристалл активен."
		),
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Аккумулятор установлен.",
			"icon_state" = "phazon17"
			// This is the point where a step icon is skipped, so "icon_state" had to be set manually starting from here.
		)
	)

/datum/component/construction/mecha/phazon/get_outer_plating_steps()
	return list(
		list(
			"key" = outer_plating,
			"amount" = 1,
			"action" = ITEM_DELETE,
			"back_key" = TOOL_WELDER,
			"desc" = "Внутренняя обшивка приварена."
		),
		list(
			"key" = TOOL_WRENCH,
			"back_key" = TOOL_CROWBAR,
			"desc" = "Внешняя обшивка установлена."
		),
		list(
			"key" = TOOL_WELDER,
			"back_key" = TOOL_WRENCH,
			"desc" = "Внешняя обшивка прикручена."
		),
		list(
			"key" = /obj/item/assembly/signaler/anomaly/bluespace,
			"action" = ITEM_DELETE,
			"back_key" = TOOL_WELDER,
			"desc" = "Отсек для ядра блюспейс-аномалии свободен.",
			"icon_state" = "phazon24"
		)
	)

/datum/component/construction/mecha/phazon/custom_action(obj/item/I, mob/living/user, diff)
	if(!..())
		return FALSE

	//TODO: better messages.
	switch(index)
		if(1)
			user.visible_message(span_notice("<b>[user]</b> подключает гидравлическую систему <b>[parent]</b>.") , span_notice("Подключаю гидравлическую систему <b>[parent]</b>."))
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> активирует гидравлическую систему <b>[parent]</b>.") , span_notice("Активирую гидравлическую систему <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает гидравлическую систему <b>[parent]</b>.") , span_notice("Отключаю гидравлическую систему <b>[parent]</b>."))
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает проводку в <b>[parent]</b>.") , span_notice("Устанавливаю проводку в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> деактивирует гидравлическую систему <b>[parent]</b>.") , span_notice("Деактивирую гидравлическую систему <b>[parent]</b>."))
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> настраивает проводку в <b>[parent]</b>.") , span_notice("Настраиваю проводку в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет проводку из <b>[parent]</b>.") , span_notice("Удаляю проводку из <b>[parent]</b>."))
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает проводку в <b>[parent]</b>.") , span_notice("Отключаю проводку в <b>[parent]</b>."))
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет основную плату.") , span_notice("Закрепляю основную плату."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль центрального управления из <b>[parent]</b>.") , span_notice("Удаляю модуль центрального управления из <b>[parent]</b>."))
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает основную плату.") , span_notice("Откручиваю основную плату."))
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль управления периферией.") , span_notice("Закрепляю модуль управления периферией."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль управления периферией из <b>[parent]</b>.") , span_notice("Удаляю модуль управления периферией из <b>[parent]</b>."))
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль управления периферией.") , span_notice("Откручиваю модуль управления периферией."))
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль управления оружием.") , span_notice("Закрепляю модуль управления оружием."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль управления оружием из <b>[parent]</b>.") , span_notice("Удаляю модуль управления оружием из <b>[parent]</b>."))
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль управления оружием.") , span_notice("Откручиваю модуль управления оружием."))
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль сканирования.") , span_notice("Закрепляю модуль сканирования."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль сканирования из <b>[parent]</b>.") , span_notice("Удаляю модуль сканирования из <b>[parent]</b>."))
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль сканирования.") , span_notice("Откручиваю модуль сканирования."))
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет конденсатор.") , span_notice("Закрепляю конденсатор."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет конденсатор из <b>[parent]</b>.") , span_notice("Удаляю конденсатор из <b>[parent]</b>."))
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b>.") , span_notice("Устанавливаю <b>[I.name]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает конденсатор в <b>[parent]</b>.") , span_notice("Откручиваю конденсатор в <b>[parent]</b>."))
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> подключает блюспейс кристалл.") , span_notice("Подключаю блюспейс кристалл."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет блюспейс кристалл из <b>[parent]</b>.") , span_notice("Удаляю блюспейс кристалл из <b>[parent]</b>."))
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> активирует блюспейс кристалл.") , span_notice("Активирую блюспейс кристалл."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает блюспейс кристалл от <b>[parent]</b>.") , span_notice("Отключаю блюспейс кристалл от <b>[parent]</b>."))
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("Деактивирует блюспейс кристалл.") , span_notice("Деактивирую блюспейс кристалл."))
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет аккумулятор.") , span_notice("Закрепляю аккумулятор."))
			else
				user.visible_message(span_notice("<b>[user]</b> вытаскивает аккумулятор из <b>[parent]</b>.") , span_notice("Вытаскиваю аккумулятор из <b>[parent]</b>."))
		if(20)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает фазовую броню на <b>[parent]</b>.") , span_notice("Устанавливаю фазовую броню на <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает аккумулятор.") , span_notice("Откручиваю аккумулятор."))
		if(21)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет фазовую броню.") , span_notice("Закрепляю фазовую броню."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает фазовую броню с <b>[parent]</b>.") , span_notice("Снимаю фазовую броню с <b>[parent]</b>."))
		if(22)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> приваривает фазовую броню к <b>[parent]</b>.") , span_notice("Привариваю фазовую броню к <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает фазовую броню.") , span_notice("Откручиваю фазовую броню."))
		if(23)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> срезает фазовую броню с <b>[parent]</b>.") , span_notice("Срезаю фазовую броню с <b>[parent]</b>."))
		if(24)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет Phazon Armor Plates.") , span_notice("Закрепляю Phazon Armor Plates."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает Phazon Armor Plates с <b>[parent]</b>.") , span_notice("Снимаю Phazon Armor Plates с <b>[parent]</b>."))
		if(25)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> приваривает Phazon Armor Plates к <b>[parent]</b>.") , span_notice("Привариваю Phazon Armor Plates к <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает Phazon Armor Plates.") , span_notice("Откручиваю Phazon Armor Plates."))
		if(26)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> аккуратно вставляет ядро блюспейс аномалии в <b>[parent]</b> и закрепляет его.") ,
					span_notice("Аккуратно вставляю ядро блюспейс аномалии в специальный отсек и закрепляю его."))
	return TRUE

//ODYSSEUS

/datum/component/construction/unordered/mecha_chassis/odysseus
	result = /datum/component/construction/mecha/odysseus
	steps = list(
		/obj/item/mecha_parts/part/odysseus_torso,
		/obj/item/mecha_parts/part/odysseus_head,
		/obj/item/mecha_parts/part/odysseus_left_arm,
		/obj/item/mecha_parts/part/odysseus_right_arm,
		/obj/item/mecha_parts/part/odysseus_left_leg,
		/obj/item/mecha_parts/part/odysseus_right_leg
	)

/datum/component/construction/mecha/odysseus
	result = /obj/vehicle/sealed/mecha/medical/odysseus
	base_icon = "odysseus"

	circuit_control = /obj/item/circuitboard/mecha/odysseus/main
	circuit_periph = /obj/item/circuitboard/mecha/odysseus/peripherals

	inner_plating = /obj/item/stack/sheet/iron
	inner_plating_amount = 5

	outer_plating = /obj/item/stack/sheet/plasteel
	outer_plating_amount = 5

/datum/component/construction/mecha/odysseus/custom_action(obj/item/I, mob/living/user, diff)
	if(!..())
		return FALSE

	//TODO: better messages.
	switch(index)
		if(1)
			user.visible_message(span_notice("<b>[user]</b> подключает гидравлическую систему <b>[parent]</b>.") , span_notice("Подключаю гидравлическую систему <b>[parent]</b>."))
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> активирует гидравлическую систему <b>[parent]</b>.") , span_notice("Активирую гидравлическую систему <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает гидравлическую систему <b>[parent]</b>.") , span_notice("Отключаю гидравлическую систему <b>[parent]</b>."))
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает проводку в <b>[parent]</b>.") , span_notice("Устанавливаю проводку в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> деактивирует гидравлическую систему <b>[parent]</b>.") , span_notice("Деактивирую гидравлическую систему <b>[parent]</b>."))
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> настраивает проводку в <b>[parent]</b>.") , span_notice("Настраиваю проводку в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет проводку из <b>[parent]</b>.") , span_notice("Удаляю проводку из <b>[parent]</b>."))
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> отключает проводку в <b>[parent]</b>.") , span_notice("Отключаю проводку в <b>[parent]</b>."))
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет основную плату.") , span_notice("Закрепляю основную плату."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль центрального управления из <b>[parent]</b>.") , span_notice("Удаляю модуль центрального управления из <b>[parent]</b>."))
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает основную плату.") , span_notice("Откручиваю основную плату."))
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль управления периферией.") , span_notice("Закрепляю модуль управления периферией."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль управления периферией из <b>[parent]</b>.") , span_notice("Удаляю модуль управления периферией из <b>[parent]</b>."))
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль управления периферией.") , span_notice("Откручиваю модуль управления периферией."))
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет модуль сканирования.") , span_notice("Закрепляю модуль сканирования."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет модуль сканирования из <b>[parent]</b>.") , span_notice("Удаляю модуль сканирования из <b>[parent]</b>."))
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает модуль сканирования.") , span_notice("Откручиваю модуль сканирования."))
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет конденсатор.") , span_notice("Закрепляю конденсатор."))
			else
				user.visible_message(span_notice("<b>[user]</b> удаляет конденсатор из <b>[parent]</b>.") , span_notice("Удаляю конденсатор из <b>[parent]</b>."))
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает <b>[I.name]</b> в <b>[parent]</b>.") , span_notice("Устанавливаю <b>[I.name]</b> в <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает конденсатор.") , span_notice("Откручиваю конденсатор."))
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет аккумулятор.") , span_notice("Закрепляю аккумулятор."))
			else
				user.visible_message(span_notice("<b>[user]</b> вытаскивает аккумулятор из <b>[parent]</b>.") , span_notice("Вытаскиваю аккумулятор из <b>[parent]</b>."))
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает внутреннюю обшивку <b>[parent]</b>.") , span_notice("Устанавливаю внутреннюю обшивку <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает аккумулятор.") , span_notice("Откручиваю аккумулятор."))
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет внутреннюю обшивку.") , span_notice("Закрепляю внутреннюю обшивку."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает внутреннюю обшивку <b>[parent]</b>.") , span_notice("Снимаю внутреннюю обшивку <b>[parent]</b>."))
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> приваривает внутреннюю обшивку к <b>[parent]</b>.") , span_notice("Привариваю внутреннюю обшивку к <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает внутреннюю обшивку.") , span_notice("Откручиваю внутреннюю обшивку."))
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> устанавливает внешнюю обшивку на <b>[parent]</b>.") , span_notice("Устанавливаю внешнюю обшивку на <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> срезает внутреннюю обшивку с <b>[parent]</b>.") , span_notice("Срезаю внутреннюю обшивку с <b>[parent]</b>."))
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> закрепляет внешнюю обшивку.") , span_notice("Закрепляю внешнюю обшивку."))
			else
				user.visible_message(span_notice("<b>[user]</b> снимает внешнюю обшивку с <b>[parent]</b>.") , span_notice("Снимаю внешнюю обшивку с <b>[parent]</b>."))
		if(20)
			if(diff==FORWARD)
				user.visible_message(span_notice("<b>[user]</b> приваривает внешнюю обшивку к <b>[parent]</b>.") , span_notice("Привариваю внешнюю обшивку к <b>[parent]</b>."))
			else
				user.visible_message(span_notice("<b>[user]</b> откручивает внешнюю обшивку.") , span_notice("Откручиваю внешнюю обшивку."))
	return TRUE

//savannah_ivanov

/datum/component/construction/unordered/mecha_chassis/savannah_ivanov
	result = /datum/component/construction/mecha/savannah_ivanov
	steps = list(
		/obj/item/mecha_parts/part/savannah_ivanov_torso,
		/obj/item/mecha_parts/part/savannah_ivanov_head,
		/obj/item/mecha_parts/part/savannah_ivanov_left_arm,
		/obj/item/mecha_parts/part/savannah_ivanov_right_arm,
		/obj/item/mecha_parts/part/savannah_ivanov_left_leg,
		/obj/item/mecha_parts/part/savannah_ivanov_right_leg
	)

/datum/component/construction/mecha/savannah_ivanov
	result = /obj/vehicle/sealed/mecha/combat/savannah_ivanov
	base_icon = "savannah_ivanov"

	circuit_control = /obj/item/circuitboard/mecha/savannah_ivanov/main
	circuit_periph = /obj/item/circuitboard/mecha/savannah_ivanov/peripherals
	circuit_weapon = /obj/item/circuitboard/mecha/savannah_ivanov/targeting

	inner_plating = /obj/item/stack/sheet/plasteel
	inner_plating_amount = 10

	outer_plating = /obj/item/mecha_parts/part/savannah_ivanov_armor
	outer_plating_amount = 1

/datum/component/construction/mecha/savannah_ivanov/custom_action(obj/item/I, mob/living/user, diff)
	. = ..()
	if(!.)
		return FALSE

	switch(index)
		if(1)
			user.visible_message(span_notice("[user] присоединяет гидравлическую систему [parent]."), span_notice("Подключаю гидравлическую систему [parent]."))
		if(2)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] активирует гидравлическую систему [parent]."), span_notice("Активирую гидравлическую систему [parent]."))
			else
				user.visible_message(span_notice("[user] отключает гидравлическую систему [parent]."), span_notice("Отключаю гидравлическую систему [parent]."))
		if(3)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] добавляет проводку в [parent]."), span_notice("Добавляю проводку в [parent]."))
			else
				user.visible_message(span_notice("[user] дeактивирует гидравлическую систему [parent]."), span_notice("Деактивирую гидравлическую систему [parent]."))
		if(4)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] настраивает проводку [parent]."), span_notice("Настраиваю проводку [parent]."))
			else
				user.visible_message(span_notice("[user] удаляет проводку из [parent]."), span_notice("Удаляю проводку из [parent]."))
		if(5)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] устанавливает [I] в [parent]."), span_notice("Устанавливаю [I] в [parent]."))
			else
				user.visible_message(span_notice("[user] отключает проводку [parent]."), span_notice("Отключаю проводку [parent]."))
		if(6)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] прикручивает основную плату."), span_notice("Прикручиваю основную плату."))
			else
				user.visible_message(span_notice("[user] удаляет основную плату из [parent]."), span_notice("Удаляю основную плату из [parent]."))
		if(7)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] устанавливает [I] в [parent]."), span_notice("Устанавливаю [I] в [parent]."))
			else
				user.visible_message(span_notice("[user] Откручивает основную плату."), span_notice("Откручиваю основную плату."))
		if(8)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] прикручивает периферийный модуль Иванова."), span_notice("Прикручиваю периферийный модуль Иванова."))
			else
				user.visible_message(span_notice("[user] удаляет периферийный модуль Иванова из [parent]."), span_notice("Удаляю периферийный модуль Иванова из [parent]."))
		if(9)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] устанавливает [I] в [parent]."), span_notice("Устанавливаю [I] в [parent]."))
			else
				user.visible_message(span_notice("[user] откручивает периферийный модуль Иванова."), span_notice("Откручиваю периферийный модуль Иванова."))
		if(10)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] прикручивает модуль управления оружием."), span_notice("Прикручиваю модуль управления оружием."))
			else
				user.visible_message(span_notice("[user] удаляет модуль управления оружием из [parent]."), span_notice("Удаляю модуль управления оружием из [parent]."))
		if(11)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] устанавливает [I] в [parent]."), span_notice("Устанавливаю [I] в [parent]."))
			else
				user.visible_message(span_notice("[user] откручивает модуль управления оружием."), span_notice("Откручиваю модуль управления оружием."))
		if(12)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] прикручивает модуль сканера."), span_notice("Прикручиваю модуль сканера."))
			else
				user.visible_message(span_notice("[user] удаляет модуль сканера из [parent]."), span_notice("Удаляю модуль сканера из [parent]."))
		if(13)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] устанавливает [I] в [parent]."), span_notice("Устанавливаю [I] в [parent]."))
			else
				user.visible_message(span_notice("[user] откручивает модуль сканера."), span_notice("Откручиваю модуль сканера."))
		if(14)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] прикручивает конденсатор."), span_notice("Прикручиваю конденсатор."))
			else
				user.visible_message(span_notice("[user] удаляет конденсатор из [parent]."), span_notice("Удаляю конденсатор из [parent]."))
		if(15)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] устанавливает [I] в [parent]."), span_notice("Устанавливаю [I] в [parent]."))
			else
				user.visible_message(span_notice("[user] откручивает конденсатор."), span_notice("Откручиваю конденсатор."))
		if(16)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] прикручивает аккумулятор."), span_notice("Прикручиваю аккумулятор."))
			else
				user.visible_message(span_notice("[user] вытаскивает аккумулятор из [parent]."), span_notice("Вытаскиваю аккумулятор из [parent]."))
		if(17)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] устанавливает внутреннюю обшивку в [parent]."), span_notice("Устанавливаю внутреннюю обшивку в [parent]."))
			else
				user.visible_message(span_notice("[user] откручивает аккумулятор."), span_notice("Откручиваю аккумулятор."))
		if(18)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] прикручивает внутреннюю обшивку."), span_notice("Прикручиваю внутреннюю обшивку."))
			else
				user.visible_message(span_notice("[user] срывает внутреннюю обшивку с [parent]."), span_notice("Срываю внутреннюю обшивку с [parent]."))
		if(19)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] приваривает внутреннюю обшивку к [parent]."), span_notice("Привариваю внутреннюю обшивку к [parent]."))
			else
				user.visible_message(span_notice("[user] откручивает внутреннюю обшивку."), span_notice("Откручиваю внутреннюю обшивку."))
		if(20)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] устанавливает [I] в [parent]."), span_notice("Устанавливаю [I] в [parent]."))
			else
				user.visible_message(span_notice("[user] срезает внутреннюю обшивку с [parent]."), span_notice("Срезаю внутреннюю обшивку с [parent]."))
		if(21)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] устанавливает бронепластины Саванны-Иванова."), span_notice("Устанавливаю бронепластины Саванны-Иванова."))
			else
				user.visible_message(span_notice("[user] срывает бронепластины Саванны-Иванова с [parent]."), span_notice("Срываю бронепластины Саванны-Иванова с [parent]."))
		if(22)
			if(diff==FORWARD)
				user.visible_message(span_notice("[user] приваривает бронепластины Саванны-Иванова к [parent]."), span_notice("Привариваю бронепластины Саванны-Иванова к [parent]."))
			else
				user.visible_message(span_notice("[user] откручивает бронепластины Саванны-Иванова."), span_notice("Откручиваю бронепластины Саванны-Иванова."))
	return TRUE
