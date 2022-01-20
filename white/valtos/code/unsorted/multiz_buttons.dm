/datum/hud/proc/add_multiz_buttons(mob/owner)
	var/atom/movable/screen/using

	using = new /atom/movable/screen/multiz_up_button()
	using.screen_loc = ui_multiz_up
	using.hud = src
	infodisplay += using

	using = new /atom/movable/screen/multiz_down_button()
	using.screen_loc = ui_multiz_down
	using.hud = src
	infodisplay += using

/atom/movable/screen/multiz_up_button
	name = "Вверх"
	icon = 'white/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "multiz_up"

/atom/movable/screen/multiz_down_button
	name = "Вниз"
	icon = 'white/baldenysh/icons/ui/midnight_extended.dmi'
	icon_state = "multiz_down"

/atom/movable/screen/multiz_up_button/Click()
	usr.up()

/atom/movable/screen/multiz_down_button/Click()
	usr.down()
