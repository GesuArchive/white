/obj/item/multitool/circuit
	name = "схемотул"
	desc = "Мультитул для схем. Используется для отметки объектов, которые затем могут быть загружены в компоненты, нажав кнопку загрузки на порту. \
	В остальном действует как обычный мультитул. Используйте в руке, чтобы очистить отмеченный объект, чтобы вы могли отметить другой объект."

	/// The marked atom of this multitool
	var/atom/marked_atom

/obj/item/multitool/circuit/Destroy()
	marked_atom = null
	return ..()

/obj/item/multitool/circuit/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Он [marked_atom? "имеет" : "не имеет"] отмеченную цель.</span>"

/obj/item/multitool/circuit/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return
	if(!marked_atom)
		return

	say("Очищаем метки.")
	clear_marked_atom()
	return TRUE

/obj/item/multitool/circuit/melee_attack_chain(mob/user, atom/target, params)
	if(marked_atom || !user.Adjacent(target))
		return ..()

	say("Отмечено [target].")
	marked_atom = target
	RegisterSignal(marked_atom, COMSIG_PARENT_QDELETING, .proc/cleanup_marked_atom)
	return TRUE

/// Clears the current marked atom
/obj/item/multitool/circuit/proc/clear_marked_atom()
	if(!marked_atom)
		return
	UnregisterSignal(marked_atom, COMSIG_PARENT_QDELETING)
	marked_atom = null

/obj/item/multitool/circuit/proc/cleanup_marked_atom(datum/source)
	SIGNAL_HANDLER
	if(source == marked_atom)
		clear_marked_atom()
