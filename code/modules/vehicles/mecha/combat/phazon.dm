/obj/vehicle/sealed/mecha/combat/phazon
	desc = "Вершина научных исследований и гордость Нанотрейзен, он использует передовые технологии блюспейс и дорогие материалы."
	name = "Фазон"
	icon_state = "phazon"
	movedelay = 2
	dir_in = 2 //Facing South.
	step_energy_drain = 3
	max_integrity = 200
	armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 30, BOMB = 30, BIO = 0, FIRE = 100, ACID = 100)
	max_temperature = 25000
	wreckage = /obj/structure/mecha_wreckage/phazon
	force = 15
	max_equip_by_category = list(
		MECHA_UTILITY = 1,
		MECHA_POWER = 1,
		MECHA_ARMOR = 2,
	)
	phase_state = "phazon-phase"

/obj/vehicle/sealed/mecha/combat/phazon/generate_actions()
	. = ..()
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_toggle_phasing)
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_switch_damtype)

/datum/action/vehicle/sealed/mecha/mech_switch_damtype
	name = "Перенастроить массив микроинструмента руки"
	button_icon_state = "mech_damtype_brute"

/datum/action/vehicle/sealed/mecha/mech_switch_damtype/Trigger(trigger_flags)
	if(!owner || !chassis || !(owner in chassis.occupants))
		return
	var/new_damtype
	switch(chassis.damtype)
		if(TOX)
			new_damtype = BRUTE
			to_chat(owner, "[icon2html(chassis, owner)]<span class='notice'>Теперь рука будет бить.</span>")
		if(BRUTE)
			new_damtype = FIRE
			to_chat(owner, "[icon2html(chassis, owner)]<span class='notice'>Теперь рука будет жарить.</span>")
		if(FIRE)
			new_damtype = TOX
			to_chat(owner, "[icon2html(chassis, owner)]<span class='notice'>Теперь рука будет вводить токсины.</span>")
	chassis.damtype = new_damtype
	button_icon_state = "mech_damtype_[new_damtype]"
	playsound(chassis, 'sound/mecha/mechmove01.ogg', 50, TRUE)
	build_all_button_icons()

/datum/action/vehicle/sealed/mecha/mech_toggle_phasing
	name = "Переключить фазирование"
	button_icon_state = "mech_phasing_off"

/datum/action/vehicle/sealed/mecha/mech_toggle_phasing/Trigger(trigger_flags)
	if(!owner || !chassis || !(owner in chassis.occupants))
		return
	chassis.phasing = chassis.phasing ? "" : "фазирование"
	button_icon_state = "mech_phasing_[chassis.phasing ? "on" : "off"]"
	to_chat(owner, "[icon2html(chassis, owner)]<font color=\"[chassis.phasing?"#00f\">Включаем":"#f00\">Выключаем"] фазирование.</font>")
	build_all_button_icons()
