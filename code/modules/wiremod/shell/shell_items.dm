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
	user.visible_message("<span class='notice'>[user] начинает заканчивать сборку [src.name].</span>", "<span class='notice'>Начинаю заканчивать сборку [src.name].</span>")
	tool.play_tool_sound(src)
	if(!do_after(user, screw_delay, src))
		return
	user.visible_message("<span class='notice'>[user] завершает сборку [src.name].</span>", "<span class='notice'>Завершаю сборку [src.name].</span>")

	var/turf/drop_loc = drop_location()

	qdel(src)
	if(drop_loc)
		new shell_to_spawn(drop_loc)

	return TRUE

/obj/item/shell/bot
	name = "сборка бота"
	icon_state = "setup_medium_box-open"
	shell_to_spawn = /obj/structure/bot

/obj/item/shell/money_bot
	name = "money bot assembly"
	icon_state = "setup_large-open"
	shell_to_spawn = /obj/structure/money_bot

/obj/item/shell/drone
	name = "сборка дрона"
	icon_state = "setup_medium_med-open"
	shell_to_spawn = /mob/living/circuit_drone

/obj/item/shell/server
	name = "сборка сервера"
	icon_state = "setup_stationary-open"
	shell_to_spawn = /obj/structure/server
	screw_delay = 10 SECONDS
