/datum/hud/dungeon_keeper/New(mob/owner)
	..()
	var/atom/movable/screen/using

	keeper_magic_display = new /atom/movable/screen()
	keeper_magic_display.name = "Запас маны"
	keeper_magic_display.icon_state = "block"
	keeper_magic_display.screen_loc = ui_health
	keeper_magic_display.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	keeper_magic_display.plane = ABOVE_HUD_PLANE
	keeper_magic_display.hud = src
	infodisplay += keeper_magic_display

	using = new /atom/movable/screen/dungeon_keeper/spawn_imp()
	using.screen_loc = ui_hand_position(2)
	using.hud = src
	static_inventory += using

/atom/movable/screen/dungeon_keeper
	icon = 'white/valtos/icons/dk.dmi'

/atom/movable/screen/dungeon_keeper/MouseEntered(location,control,params)
	. = ..()
	openToolTip(usr,src,params,title = name,content = desc, theme = "blob")

/atom/movable/screen/dungeon_keeper/MouseExited()
	closeToolTip(usr)

/atom/movable/screen/dungeon_keeper/spawn_imp
	icon_state = "ui_node"
	name = "Создать миньона"
	desc = "Прекрасное создание, которое умеет копать и строить. Чудеса."

/atom/movable/screen/dungeon_keeper/spawn_imp/Click()
	if(isovermind(usr))
		var/mob/camera/dungeon_keeper/B = usr
		B.create_special(250 * max(B.our_heart.keeper.controlled_imps.len, 1))
