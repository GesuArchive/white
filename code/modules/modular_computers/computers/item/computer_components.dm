/obj/item/modular_computer/proc/can_install_component(obj/item/computer_hardware/try_install, mob/living/user = null)
	if(!try_install.can_install(src, user))
		return FALSE

	if(try_install.w_class > max_hardware_size)
		to_chat(user, span_warning("Этот компонент слишком велик для <b>[src.name]</b>!"))
		return FALSE

	if(try_install.expansion_hw)
		if(LAZYLEN(expansion_bays) >= max_bays)
			to_chat(user, span_warning("Все отсеки расширения компьютера заполнены."))
			return FALSE
		if(LAZYACCESS(expansion_bays, try_install.device_type))
			to_chat(user, span_warning("Компьютер сразу отторгает [try_install] и отображает ошибку: \"Конфликт адресов оборудования\"."))
			return FALSE

	if(all_components[try_install.device_type])
		to_chat(user, span_warning("Слот оборудования этого компьютера уже занят [all_components[try_install.device_type]]."))
		return FALSE
	return TRUE


/// Installs component.
/obj/item/modular_computer/proc/install_component(obj/item/computer_hardware/install, mob/living/user = null)
	if(!can_install_component(install, user))
		return FALSE

	if(user && !user.transferItemToLoc(install, src))
		return FALSE

	if(install.expansion_hw)
		LAZYSET(expansion_bays, install.device_type, install)
	all_components[install.device_type] = install

	to_chat(user, span_notice("Устанавливаю [install] в <b>[src.name]</b>."))
	install.holder = src
	install.forceMove(src)
	install.on_install(src, user)


/// Uninstalls component.
/obj/item/modular_computer/proc/uninstall_component(obj/item/computer_hardware/yeet, mob/living/user = null)
	if(yeet.holder != src) // Not our component at all.
		return FALSE

	to_chat(user, span_notice("Извлекаю [yeet] из <b>[src.name]</b>."))

	yeet.forceMove(get_turf(src))
	forget_component(yeet)
	yeet.on_remove(src, user)
	if(enabled && !use_power())
		shutdown_computer()
	update_appearance()
	return TRUE

/// This isn't the "uninstall fully" proc, it just makes the computer lose all its references to the component
/obj/item/modular_computer/proc/forget_component(obj/item/computer_hardware/wipe_memory)
	if(wipe_memory.holder != src)
		return FALSE
	if(wipe_memory.expansion_hw)
		LAZYREMOVE(expansion_bays, wipe_memory.device_type)
	all_components.Remove(wipe_memory.device_type)
	wipe_memory.holder = null

/// Checks all hardware pieces to determine if name matches, if yes, returns the hardware piece, otherwise returns null
/obj/item/modular_computer/proc/find_hardware_by_name(name)
	for(var/i in all_components)
		var/obj/component = all_components[i]
		if(component.name == name)
			return component
	return null
