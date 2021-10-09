/**
 * # Shell Item
 *
 * Printed out by protolathes. Screwdriver to complete the shell.
 */
/obj/item/shell
	name = "оболочка"
	desc = "Оболочка. Отвёртка для завершения сборки."
	icon = 'icons/obj/wiremod.dmi'
	var/shell_to_spawn
	var/screw_delay = 3 SECONDS

/obj/item/shell/screwdriver_act(mob/living/user, obj/item/tool)
	user.visible_message(span_notice("[user] начинает заканчивать сборку [src.name].") , span_notice("Начинаю заканчивать сборку [src.name]."))
	tool.play_tool_sound(src)
	if(!do_after(user, screw_delay, src))
		return
	user.visible_message(span_notice("[user] завершает сборку [src.name].") , span_notice("Завершаю сборку [src.name]."))

	var/turf/drop_loc = drop_location()

	qdel(src)
	if(drop_loc)
		new shell_to_spawn(drop_loc)

	return TRUE

/obj/item/shell/bot
	name = "сборка бота"
	desc = "Неподвижная оболочка, которая хранит другие компоненты. Имеет USB-порт для подключения к компьютерам и машинам. Срабатывает, когда кто-то взаимодействует с ботом."
	icon_state = "setup_medium_box-open"
	shell_to_spawn = /obj/structure/bot

/obj/item/shell/money_bot
	name = "сборка денежного бота"
	desc = "Неподвижная оболочка, похожая на обычную оболочку бота, но принимающая денежные вводы и также способная выдавать деньги. Деньги берутся из внутреннего хранилища денег."
	icon_state = "setup_large-open"
	shell_to_spawn = /obj/structure/money_bot

/obj/item/shell/drone
	name = "сборка дрона"
	desc = "Оболочка, способная к самостоятельному передвижению. Внутренний контролер используется для отправки выходных сигналов движения на оболочку дрона"
	icon_state = "setup_medium_med-open"
	shell_to_spawn = /mob/living/circuit_drone

/obj/item/shell/server
	name = "сборка сервера"
	desc = "Очень большая оболочка, которую можно перемещать только после откручивания от пола. Совместима сбольшинством компонентов."
	icon_state = "setup_stationary-open"
	shell_to_spawn = /obj/structure/server
	screw_delay = 10 SECONDS

/obj/item/shell/airlock
	name = "сборка шлюза"
	desc = "Оболочка шлюза с схемотехническим интерфейсом, которую нельзя перемещать в собранном виде."
	icon = 'icons/obj/doors/airlocks/station/public.dmi'
	icon_state = "construction"
	shell_to_spawn = /obj/machinery/door/airlock/shell
	screw_delay = 10 SECONDS

/obj/item/shell/dispenser
	name = "circuit dispenser assembly"
	icon_state = "setup_drone_arms-open"
	shell_to_spawn = /obj/structure/dispenser_bot

/obj/item/shell/bci
	name = "сборка интерфейса человек-компьютер (ИЧМ)"
	desc = "Имплантат, который может быть помещен в голову пользователя для отправки управляющих сигналов."
	icon_state = "bci-open"
	shell_to_spawn = /obj/item/organ/cyberimp/bci

/obj/item/shell/scanner_gate
	name = "сборка сканирующей арки"
	desc = "Оболочка арки сканера, которая выполняет сканирование людей, проходящих через нее."
	icon = 'icons/obj/machines/scangate.dmi'
	icon_state = "scangate_black_open"
	shell_to_spawn = /obj/structure/scanner_gate_shell
