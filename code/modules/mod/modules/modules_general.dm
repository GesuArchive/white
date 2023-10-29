//General modules for MODsuits

///Storage - Adds a storage component to the suit.
/obj/item/mod/module/storage
	name = "модуль хранилища"
	desc = "Модуль состоит из серии интегрированных отсеков и специализированных карманов по бокам костюма, для хранения ваших вещей."
	icon_state = "storage"
	complexity = 3
	incompatible_modules = list(/obj/item/mod/module/storage, /obj/item/mod/module/plate_compression)
	/// Max weight class of items in the storage.
	var/max_w_class = WEIGHT_CLASS_NORMAL
	/// Max combined weight of all items in the storage.
	var/max_combined_w_class = 15
	/// Max amount of items in the storage.
	var/max_items = 7

/obj/item/mod/module/storage/Initialize(mapload)
	. = ..()
	create_storage(max_specific_storage = max_w_class, max_total_storage = max_combined_w_class, max_slots = max_items)
	atom_storage.allow_big_nesting = TRUE
	atom_storage.locked = TRUE

/obj/item/mod/module/storage/on_install()
	var/datum/storage/modstorage = mod.create_storage(max_specific_storage = max_w_class, max_total_storage = max_combined_w_class, max_slots = max_items)
	modstorage.set_real_location(src)
	atom_storage.locked = FALSE
	RegisterSignal(mod.chestplate, COMSIG_ITEM_PRE_UNEQUIP, PROC_REF(on_chestplate_unequip))

/obj/item/mod/module/storage/on_uninstall(deleting = FALSE)
	var/datum/storage/modstorage = mod.atom_storage
	atom_storage.locked = TRUE
	qdel(modstorage)
	if(!deleting)
		atom_storage.remove_all(get_turf(src))
	UnregisterSignal(mod.chestplate, COMSIG_ITEM_PRE_UNEQUIP)

/obj/item/mod/module/storage/proc/on_chestplate_unequip(obj/item/source, force, atom/newloc, no_move, invdrop, silent)
	if(QDELETED(source) || !mod.wearer || newloc == mod.wearer || !mod.wearer.s_store)
		return
	to_chat(mod.wearer, span_notice("[src] пытается положить [mod.wearer.s_store] внутрь себя."))
	if(atom_storage?.attempt_insert(mod.wearer.s_store, mod.wearer, override = TRUE))
		mod.wearer.temporarilyRemoveItemFromInventory(mod.wearer.s_store)

/obj/item/mod/module/storage/large_capacity
	name = "продвинутый модуль хранилища"
	desc = "Передовая разработка от Накамура Инженеринг - усовершенствованный контейнер для складирования предметов."
	icon_state = "storage_large"
	max_combined_w_class = 21
	max_items = 14

/obj/item/mod/module/storage/syndicate
	name = "модуль хранилища Синдиката"
	desc = "Система хранения с использованием нанотехнологий используемых контрабандистами. Разработка Киберсан Индастри."
	icon_state = "storage_syndi"
	max_combined_w_class = 30
	max_items = 21

/obj/item/mod/module/storage/bluespace
	name = "модуль блюспейс хранилища"
	desc = "Экспериментальная система хранения использующая технологию блюспейс. Разработка НаноТрейзен."
	icon_state = "storage_large"
	max_w_class = WEIGHT_CLASS_GIGANTIC
	max_combined_w_class = 60
	max_items = 21

///Ion Jetpack - Lets the user fly freely through space using battery charge.
/obj/item/mod/module/jetpack
	name = "модуль ионных двигателей"
	desc = "Комплекс из реактивных маневровых двигателей на ионной тяге, стабильно вызывающий стойкую антипатию у всех начинающих инженеров. \
		Вместо использования газов для передвижения, эти ранцы способны ускорять ионы, используя \
		заряд от батареи скафандра. Некоторые говорят, что это не первая попытка Накамура Инжиниринг в разработке реактивных ранцев."
	icon_state = "jetpack"
	module_type = MODULE_TOGGLE
	complexity = 3
	active_power_cost = DEFAULT_CHARGE_DRAIN * 0.5
	use_power_cost = DEFAULT_CHARGE_DRAIN
	incompatible_modules = list(/obj/item/mod/module/jetpack)
	cooldown_time = 0.5 SECONDS
	overlay_state_inactive = "module_jetpack"
	overlay_state_active = "module_jetpack_on"
	/// Do we stop the wearer from gliding in space.
	var/stabilizers = FALSE
	/// Do we give the wearer a speed buff.
	var/full_speed = FALSE
	var/datum/callback/get_mover
	var/datum/callback/check_on_move

/obj/item/mod/module/jetpack/Initialize(mapload)
	. = ..()
	get_mover = CALLBACK(src, PROC_REF(get_user))
	check_on_move = CALLBACK(src, PROC_REF(allow_thrust))
	refresh_jetpack()

/obj/item/mod/module/jetpack/Destroy()
	get_mover = null
	check_on_move = null
	return ..()

/obj/item/mod/module/jetpack/proc/refresh_jetpack()
	AddComponent(/datum/component/jetpack, stabilizers, COMSIG_MODULE_TRIGGERED, COMSIG_MODULE_DEACTIVATED, MOD_ABORT_USE, get_mover, check_on_move, /datum/effect_system/trail_follow/ion/grav_allowed)

/obj/item/mod/module/jetpack/proc/set_stabilizers(new_stabilizers)
	if(stabilizers == new_stabilizers)
		return
	stabilizers = new_stabilizers
	refresh_jetpack()

/obj/item/mod/module/jetpack/on_activation()
	. = ..()
	if(!.)
		return
	if(full_speed)
		mod.wearer.add_movespeed_modifier(/datum/movespeed_modifier/jetpack/fullspeed)

/obj/item/mod/module/jetpack/on_deactivation(display_message = TRUE, deleting = FALSE)
	. = ..()
	if(full_speed)
		mod.wearer.remove_movespeed_modifier(/datum/movespeed_modifier/jetpack/fullspeed)

/obj/item/mod/module/jetpack/get_configuration()
	. = ..()
	.["stabilizers"] = add_ui_configuration("Стабилизатор", "bool", stabilizers)

/obj/item/mod/module/jetpack/configure_edit(key, value)
	switch(key)
		if("stabilizers")
			set_stabilizers(text2num(value))

/obj/item/mod/module/jetpack/proc/allow_thrust(use_fuel = TRUE)
	if(!use_fuel)
		return check_power(use_power_cost)
	if(!drain_power(use_power_cost))
		return FALSE
	return TRUE

/obj/item/mod/module/jetpack/proc/get_user()
	return mod.wearer

/obj/item/mod/module/jetpack/advanced
	name = "модуль продвинутых ионных двигателей"
	desc = "Данная модель обладает выдающимися скоростными характеристиками по сравнению с базовой линейкой. Это стало возможно благодаря модернизации системы ионных двигателей \
		значительно большим числом форсунок, так же несомненно немаловажную роль сыграла покраска в ярко-красный цвет."
	icon_state = "jetpack_advanced"
	overlay_state_inactive = "module_jetpackadv"
	overlay_state_active = "module_jetpackadv_on"
	full_speed = TRUE

///Eating Apparatus - Lets the user eat/drink with the suit on.
/obj/item/mod/module/mouthhole
	name = "модуль для приёма пищи"
	desc = "Лучший выбор для любого шахтера! Позволяет принимать пищу и пить не снимая шлема, \
		благодаря нанотехнологическому барьер перед ртом, без разгерметизации скафандра! Однако вам все еще придется носить кислородную маску, а барьер не защитит \
		от перцовых аэрозолей, и главное он не способен хотя бы на сотую долю улучшить вкусовые качества стейка из Голиафа."
	icon_state = "apparatus"
	complexity = 1
	incompatible_modules = list(/obj/item/mod/module/mouthhole)
	overlay_state_inactive = "module_apparatus"
	/// Former flags of the helmet.
	var/former_flags = NONE
	/// Former visor flags of the helmet.
	var/former_visor_flags = NONE

/obj/item/mod/module/mouthhole/on_install()
	former_flags = mod.helmet.flags_cover
	former_visor_flags = mod.helmet.visor_flags_cover
	mod.helmet.flags_cover &= ~HEADCOVERSMOUTH|PEPPERPROOF
	mod.helmet.visor_flags_cover &= ~HEADCOVERSMOUTH|PEPPERPROOF

/obj/item/mod/module/mouthhole/on_uninstall(deleting = FALSE)
	if(deleting)
		return
	mod.helmet.flags_cover |= former_flags
	mod.helmet.visor_flags_cover |= former_visor_flags

///EMP Shield - Protects the suit from EMPs.
/obj/item/mod/module/emp_shield
	name = "модуль защиты от ЭМИ"
	desc = "В скафандре установлен ингибитор поля, защищающий его от внешнего воздействия, такого как \
		электромагнитные импульсы, которые иначе повредили бы электронные системы скафандра или модулей. \
		Однако, энергопотребление скафандра немного увеличится."
	icon_state = "empshield"
	complexity = 1
	idle_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	incompatible_modules = list(/obj/item/mod/module/emp_shield)

/obj/item/mod/module/emp_shield/on_install()
	mod.AddElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_WIRES|EMP_PROTECT_CONTENTS)

/obj/item/mod/module/emp_shield/on_uninstall(deleting = FALSE)
	mod.RemoveElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_WIRES|EMP_PROTECT_CONTENTS)

/obj/item/mod/module/emp_shield/advanced
	name = "продвинутый модуль ЭМИ-защиты"
	desc = "Усовершенствованный ингибитор поля, установленный в скафандр, защищающий его внешнего воздействия, такого как \
		электромагнитные импульсы, которые в противном случае повредили бы электронные системы костюма или электронные устройства на носителе, \
		включая аугментации. Однако для этого потребуется дополнительный заряд скафандра."
	complexity = 2

/obj/item/mod/module/emp_shield/advanced/on_suit_activation()
	mod.wearer.AddElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_CONTENTS)

/obj/item/mod/module/emp_shield/advanced/on_suit_deactivation(deleting)
	mod.wearer.RemoveElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_CONTENTS)

///Flashlight - Gives the suit a customizable flashlight.
/obj/item/mod/module/flashlight
	name = "модуль фонарика"
	desc = "Простая пара настраиваемых фонариков, установленных на левой и правой сторонах шлема, \
		полезно для обеспечения света в различных мощностях и цветах. \
		Некоторые выживальщики предпочитают зеленый цвет для своего освещения, по неизвестным причинам."
	icon_state = "flashlight"
	module_type = MODULE_TOGGLE
	complexity = 1
	active_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	incompatible_modules = list(/obj/item/mod/module/flashlight)
	cooldown_time = 0.5 SECONDS
	overlay_state_inactive = "module_light"
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_color = COLOR_WHITE
	light_range = 4
	light_power = 1
	light_on = FALSE
	/// Charge drain per range amount.
	var/base_power = DEFAULT_CHARGE_DRAIN * 0.1
	/// Minimum range we can set.
	var/min_range = 2
	/// Maximum range we can set.
	var/max_range = 5

/obj/item/mod/module/flashlight/on_activation()
	. = ..()
	if(!.)
		return
	set_light_flags(light_flags | LIGHT_ATTACHED)
	set_light_on(active)
	active_power_cost = base_power * light_range

/obj/item/mod/module/flashlight/on_deactivation(display_message = TRUE, deleting = FALSE)
	. = ..()
	if(!.)
		return
	set_light_flags(light_flags & ~LIGHT_ATTACHED)
	set_light_on(active)

/obj/item/mod/module/flashlight/on_process(delta_time)
	active_power_cost = base_power * light_range
	return ..()

/obj/item/mod/module/flashlight/generate_worn_overlay(mutable_appearance/standing)
	. = ..()
	if(!active)
		return
	var/mutable_appearance/light_icon = mutable_appearance(overlay_icon_file, "module_light_on", layer = standing.layer + 0.2)
	light_icon.appearance_flags = RESET_COLOR
	light_icon.color = light_color
	. += light_icon

/obj/item/mod/module/flashlight/get_configuration()
	. = ..()
	.["light_color"] = add_ui_configuration("Цвет освещения", "color", light_color)
	.["light_range"] = add_ui_configuration("Мощность освещения", "number", light_range)

/obj/item/mod/module/flashlight/configure_edit(key, value)
	switch(key)
		if("light_color")
			value = input(usr, "Выберите новый цвет", "Цвет фонарика") as color|null
			if(!value)
				return
			if(is_color_dark(value, 50))
				balloon_alert(mod.wearer, "Слишком тёмный!")
				return
			set_light_color(value)
			mod.wearer.update_clothing(mod.slot_flags)
		if("light_range")
			set_light_range(clamp(value, min_range, max_range))

///Dispenser - Dispenses an item after a time passes.
/obj/item/mod/module/dispenser
	name = "модуль раздачи бургеров"
	desc = "Редкая технология, разработанная на основе прототипа, найденного на судне Донк ко. \
		Модуль может использовать невероятное количество энергии от батареи скафандра, для синтеза съедобное органического вещества на \
		ладонях перчаток владельца, однако, разработки полностью остановились на бургерах. \
		Примечательно, что все попытки получения чая Эрл Грей потерпели неудачу."
	icon_state = "dispenser"
	module_type = MODULE_USABLE
	complexity = 3
	use_power_cost = DEFAULT_CHARGE_DRAIN * 2
	incompatible_modules = list(/obj/item/mod/module/dispenser)
	cooldown_time = 5 SECONDS
	/// Path we dispense.
	var/dispense_type = /obj/item/food/burger/plain
	/// Time it takes for us to dispense.
	var/dispense_time = 0 SECONDS

/obj/item/mod/module/dispenser/on_use()
	. = ..()
	if(!.)
		return
	if(dispense_time && !do_after(mod.wearer, dispense_time, target = mod))
		balloon_alert(mod.wearer, "Прервано!")
		return FALSE
	var/obj/item/dispensed = new dispense_type(mod.wearer.loc)
	mod.wearer.put_in_hands(dispensed)
	balloon_alert(mod.wearer, "[dispensed] создан")
	playsound(src, 'sound/machines/click.ogg', 100, TRUE)
	drain_power(use_power_cost)
	return dispensed

///Longfall - Nullifies fall damage, removing charge instead.
/obj/item/mod/module/longfall
	name = "модуль защиты от падения"
	desc = "Модуль защищающий носителя от повреждений в случае падения с большой высоты. \
		Часть кинетической энергии полученной в результате падения будет конвертирована в энергию, направленную \
		на стабилизацию пользователя. \
		Полезно для добычи полезных ископаемых, монорельсовых поездок, или даже прыжков с парашютом!"
	icon_state = "longfall"
	complexity = 1
	use_power_cost = DEFAULT_CHARGE_DRAIN * 5
	incompatible_modules = list(/obj/item/mod/module/longfall)

/obj/item/mod/module/longfall/on_suit_activation()
	RegisterSignal(mod.wearer, COMSIG_LIVING_Z_IMPACT, PROC_REF(z_impact_react))

/obj/item/mod/module/longfall/on_suit_deactivation(deleting = FALSE)
	UnregisterSignal(mod.wearer, COMSIG_LIVING_Z_IMPACT)

/obj/item/mod/module/longfall/proc/z_impact_react(datum/source, levels, turf/fell_on)
	if(!drain_power(use_power_cost*levels))
		return
	new /obj/effect/temp_visual/mook_dust(fell_on)
	mod.wearer.Stun(levels * 1 SECONDS)
	to_chat(mod.wearer, span_notice("Сработала система защиты от падений!"))
	return NO_Z_IMPACT_DAMAGE

///Thermal Regulator - Regulates the wearer's core temperature.
/obj/item/mod/module/thermal_regulator
	name = "модуль регулятора температуры"
	desc = "Продвинутая система климат-контроля, встроенная в подкладку и использующая тысячи гибких трубочек водяного охлаждения, \
		с выводом температуры на наружные радиаторы. \
		Способна поддерживать заданную температуру даже если снаружи бушует плазменный пожар."
	icon_state = "regulator"
	module_type = MODULE_TOGGLE
	complexity = 2
	active_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	incompatible_modules = list(/obj/item/mod/module/thermal_regulator)
	cooldown_time = 0.5 SECONDS
	/// The temperature we are regulating to.
	var/temperature_setting = BODYTEMP_NORMAL
	/// Minimum temperature we can set.
	var/min_temp = T20C
	/// Maximum temperature we can set.
	var/max_temp = 318.15

/obj/item/mod/module/thermal_regulator/get_configuration()
	. = ..()
	.["temperature_setting"] = add_ui_configuration("Температура", "number", temperature_setting - T0C)

/obj/item/mod/module/thermal_regulator/configure_edit(key, value)
	switch(key)
		if("temperature_setting")
			temperature_setting = clamp(value + T0C, min_temp, max_temp)

/obj/item/mod/module/thermal_regulator/on_active_process(delta_time)
	mod.wearer.adjust_bodytemperature(get_temp_change_amount((temperature_setting - mod.wearer.bodytemperature), 0.08 * delta_time))

///DNA Lock - Prevents people without the set DNA from activating the suit.
/obj/item/mod/module/dna_lock
	name = "модуль ДНК блокировки"
	desc = "Модуль блокировки центрального ядра костюма, \
		не позволяющий не авторизованному лицу получить доступ без проверки ДНК. \
		Однако, этот невероятно модуль невероятно чувствителен к ЭМИ. К счастью, клонирование было запрещено законом."
	icon_state = "dnalock"
	module_type = MODULE_USABLE
	complexity = 2
	use_power_cost = DEFAULT_CHARGE_DRAIN * 3
	incompatible_modules = list(/obj/item/mod/module/dna_lock, /obj/item/mod/module/eradication_lock)
	cooldown_time = 0.5 SECONDS
	/// The DNA we lock with.
	var/dna = null

/obj/item/mod/module/dna_lock/on_install()
	RegisterSignal(mod, COMSIG_MOD_ACTIVATE, PROC_REF(on_mod_activation))
	RegisterSignal(mod, COMSIG_MOD_MODULE_REMOVAL, PROC_REF(on_mod_removal))
	RegisterSignal(mod, COMSIG_ATOM_EMP_ACT, PROC_REF(on_emp))
	RegisterSignal(mod, COMSIG_ATOM_EMAG_ACT, PROC_REF(on_emag))

/obj/item/mod/module/dna_lock/on_uninstall(deleting = FALSE)
	UnregisterSignal(mod, COMSIG_MOD_ACTIVATE)
	UnregisterSignal(mod, COMSIG_MOD_MODULE_REMOVAL)
	UnregisterSignal(mod, COMSIG_ATOM_EMP_ACT)
	UnregisterSignal(mod, COMSIG_ATOM_EMAG_ACT)

/obj/item/mod/module/dna_lock/on_use()
	. = ..()
	if(!.)
		return
	dna = mod.wearer.dna.unique_enzymes
	balloon_alert(mod.wearer, "ДНК обновлено")
	drain_power(use_power_cost)

/obj/item/mod/module/dna_lock/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	on_emp(src, severity)

/obj/item/mod/module/dna_lock/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	on_emag(src, user, emag_card)

/obj/item/mod/module/dna_lock/proc/dna_check(mob/user)
	if(!iscarbon(user))
		return FALSE
	var/mob/living/carbon/carbon_user = user
	if(!dna  || (carbon_user.has_dna() && carbon_user.dna.unique_enzymes == dna))
		return TRUE
	balloon_alert(user, "ДНК блокирован")
	return FALSE

/obj/item/mod/module/dna_lock/proc/on_emp(datum/source, severity)
	SIGNAL_HANDLER

	dna = null

/obj/item/mod/module/dna_lock/proc/on_emag(datum/source, mob/user, obj/item/card/emag/emag_card)
	SIGNAL_HANDLER

	dna = null

/obj/item/mod/module/dna_lock/proc/on_mod_activation(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!dna_check(user))
		return MOD_CANCEL_ACTIVATE

/obj/item/mod/module/dna_lock/proc/on_mod_removal(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!dna_check(user))
		return MOD_CANCEL_REMOVAL

///Plasma Stabilizer - Prevents plasmamen from igniting in the suit
/obj/item/mod/module/plasma_stabilizer
	name = "модуль стабилизации плазмы"
	desc = "Система атмоформации, преобразующая внутреннюю среду внутри костюма из кислорода в плазму,\
		предотвращающая возгорание носителя. \
		Плазмастекло предотвращает ионизацию плазмы "
	icon_state = "plasma_stabilizer"
	complexity = 1
	idle_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	incompatible_modules = list(/obj/item/mod/module/plasma_stabilizer)
	overlay_state_inactive = "module_plasma"

/obj/item/mod/module/plasma_stabilizer/on_equip()
	ADD_TRAIT(mod.wearer, TRAIT_NOSELFIGNITION_HEAD_ONLY, MOD_TRAIT)

/obj/item/mod/module/plasma_stabilizer/on_unequip()
	REMOVE_TRAIT(mod.wearer, TRAIT_NOSELFIGNITION_HEAD_ONLY, MOD_TRAIT)


//Finally, https://pipe.miroware.io/5b52ba1d94357d5d623f74aa/mspfa/Nuke%20Ops/Panels/0648.gif can be real:
///Hat Stabilizer - Allows displaying a hat over the MOD-helmet, à la plasmamen helmets.
/obj/item/mod/module/hat_stabilizer
	name = "модуль стабилитора шляпы"
	desc = "Просто набор выдвижных фиксаторов прямо на голове, они будут выдвигатся под выбранной шляпой для \
		предотвращения падения, позволяя быть одетой даже на зафиксированном шлеме; \
		Вам всё ещё нужно снимать шляпу на время фиксации шлема скафандра, пока что. \
		Этот модуль является обязательным для Капитанов НаноТрейзен, позволяя им показывать свою авторитетную шляпу даже в их MODе."
	icon_state = "hat_holder"
	incompatible_modules = list(/obj/item/mod/module/hat_stabilizer)
	/*Intentionally left inheriting 0 complexity and removable = TRUE;
	even though it comes inbuilt into the Magnate/Corporate MODS and spawns in maints, I like the idea of stealing them*/
	/// Currently "stored" hat. No armor or function will be inherited, ONLY the icon.
	var/obj/item/clothing/head/attached_hat
	/// Whitelist of attachable hats, read note in Initialize() below this line
	var/static/list/attachable_hats_list

/obj/item/mod/module/hat_stabilizer/Initialize(mapload)
	. = ..()
	attachable_hats_list = typecacheof(
	//List of attachable hats. Make sure these and their subtypes are all tested, so they dont appear janky.
	//This list should also be gimmicky, so captains can have fun. I.E. the Santahat, Pirate hat, Tophat, Chefhat...
	//Yes, I said it, the captain should have fun.
		list(
			/obj/item/clothing/head/caphat,
			/obj/item/clothing/head/crown,
			/obj/item/clothing/head/centhat,
			/obj/item/clothing/head/centcom_cap,
			/obj/item/clothing/head/pirate,
			/obj/item/clothing/head/santa,
			/obj/item/clothing/head/hardhat/reindeer,
			/obj/item/clothing/head/sombrero,
			/obj/item/clothing/head/kitty,
			/obj/item/clothing/head/rabbitears,
			/obj/item/clothing/head/festive,
			/obj/item/clothing/head/powdered_wig,
			/obj/item/clothing/head/weddingveil,
			/obj/item/clothing/head/that,
			/obj/item/clothing/head/nursehat,
			/obj/item/clothing/head/chefhat,
			/obj/item/clothing/head/papersack,
			/obj/item/clothing/head/caphat/beret,
			))

/obj/item/mod/module/hat_stabilizer/on_suit_activation()
	RegisterSignal(mod.helmet, COMSIG_PARENT_EXAMINE, PROC_REF(add_examine))
	RegisterSignal(mod.helmet, COMSIG_PARENT_ATTACKBY, PROC_REF(place_hat))
	RegisterSignal(mod.helmet, COMSIG_ATOM_ATTACK_HAND_SECONDARY, PROC_REF(remove_hat))

/obj/item/mod/module/hat_stabilizer/on_suit_deactivation(deleting = FALSE)
	if(deleting)
		return
	if(attached_hat)	//knock off the helmet if its on their head. Or, technically, auto-rightclick it for them; that way it saves us code, AND gives them the bubble
		remove_hat(src, mod.wearer)
	UnregisterSignal(mod.helmet, COMSIG_PARENT_EXAMINE)
	UnregisterSignal(mod.helmet, COMSIG_PARENT_ATTACKBY)
	UnregisterSignal(mod.helmet, COMSIG_ATOM_ATTACK_HAND_SECONDARY)

/obj/item/mod/module/hat_stabilizer/proc/add_examine(datum/source, mob/user, list/base_examine)
	SIGNAL_HANDLER
	if(attached_hat)
		base_examine += span_notice("На шлеме закреплена[attached_hat]. Правый-клик для снятия.")
	else
		base_examine += span_notice("Ничего не закреплено. Пока-что.")

/obj/item/mod/module/hat_stabilizer/proc/place_hat(datum/source, obj/item/hitting_item, mob/user)
	SIGNAL_HANDLER
	if(!istype(hitting_item, /obj/item/clothing/head))
		return
	if(!mod.active)
		balloon_alert(user, "Скафандр должен быть активен!")
		return
	if(!is_type_in_typecache(hitting_item, attachable_hats_list))
		balloon_alert(user, "Это шляпа не подходит!")
		return
	if(attached_hat)
		balloon_alert(user, "Шляпа уже закреплена!")
		return
	if(mod.wearer.transferItemToLoc(hitting_item, src, force = FALSE, silent = TRUE))
		attached_hat = hitting_item
		balloon_alert(user, "Шляпа закреплена. Правый-клик для снятия")
		mod.wearer.update_clothing(mod.slot_flags)

/obj/item/mod/module/hat_stabilizer/generate_worn_overlay()
	. = ..()
	if(attached_hat)
		. += attached_hat.build_worn_icon(default_layer = VEHICLE_LAYER, default_icon_file = 'icons/mob/clothing/head.dmi')

/obj/item/mod/module/hat_stabilizer/proc/remove_hat(datum/source, mob/user)
	SIGNAL_HANDLER
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!attached_hat)
		return
	attached_hat.forceMove(drop_location())
	if(user.put_in_active_hand(attached_hat))
		balloon_alert(user, "Шляпа снята")
	else
		balloon_alert_to_viewers("Шляпа падает на пол!")
	attached_hat = null
	mod.wearer.update_clothing(mod.slot_flags)

///Sign Language Translator - allows people to sign over comms using the modsuit's gloves.
/obj/item/mod/module/signlang_radio
	name = "модуль перевода языка жестов"
	desc = "Модуль добавляет датчики движения в перчатки скафандра, \
		которые работают с низко-волновыми суб-световыми передатчиками, \
		конвертируя жесты в голос по аудисвязи."
	icon_state = "signlang_radio"
	complexity = 1
	idle_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	incompatible_modules = list(/obj/item/mod/module/signlang_radio)

/obj/item/mod/module/signlang_radio/on_suit_activation()
	ADD_TRAIT(mod.wearer, TRAIT_CAN_SIGN_ON_COMMS, MOD_TRAIT)

/obj/item/mod/module/signlang_radio/on_suit_deactivation(deleting = FALSE)
	REMOVE_TRAIT(mod.wearer, TRAIT_CAN_SIGN_ON_COMMS, MOD_TRAIT)
