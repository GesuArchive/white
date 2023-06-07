// Shitcode

/obj/item/checkers_kit
	name = "шахматное поле"
	desc = "Сделано из блюспейс зубов."
	icon = 'white/valtos/icons/game_kit.dmi'
	icon_state = "chess"
	w_class = WEIGHT_CLASS_BULKY
	force = 7

/obj/item/checkers_kit/attack_self(mob/user)
	visible_message(span_warning("<b>[user]</b> разворачивает огромную доску!"))
	new /obj/checkered_table(get_turf(src))
	qdel(src)

/obj/checkered_table
	name = "шахматное поле"
	desc = "Крутое."
	icon = 'white/valtos/icons/checkers.dmi'
	icon_state = "table"
	anchored = TRUE
	pixel_x = -44
	pixel_y = -32
	appearance_flags = KEEP_TOGETHER
	var/table_grid[8][8]
	var/list/table_pool_left = list()
	var/list/table_pool_right = list()
	var/table_step = 12
	var/image/piece_active

/obj/checkered_table/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += span_notice("ПКМ для сброса поля к изначальному варианту.")
	. += span_notice("\nCtrl-Shift-клик по доске, чтобы её свернуть.")
	. += span_notice("\nСКМ по шашке, чтобы её перевернуть.")

/obj/checkered_table/Initialize(mapload)
	..()
	reset_table()
	setup_checkers()
	RegisterSignal(src, COMSIG_CLICK, PROC_REF(table_click))
	RegisterSignal(src, COMSIG_CLICK_CTRL, PROC_REF(table_click))
	RegisterSignal(src, COMSIG_CLICK_CTRL_SHIFT, PROC_REF(table_click))
	RegisterSignal(src, COMSIG_MOB_MIDDLECLICKON, PROC_REF(table_click))

/obj/checkered_table/attack_paw(mob/user)
	return attack_hand(user)

/obj/checkered_table/proc/reset_table()
	overlays = null
	for(var/_x in 1 to 8)
		for(var/_y in 1 to 8)
			table_grid[_x][_y] = null
			table_pool_left.Cut()
			table_pool_right.Cut()

/obj/checkered_table/proc/setup_checkers()
	set_piece_on_table(1, 1, "white")
	set_piece_on_table(3, 1, "white")
	set_piece_on_table(5, 1, "white")
	set_piece_on_table(7, 1, "white")

	set_piece_on_table(2, 2, "white")
	set_piece_on_table(4, 2, "white")
	set_piece_on_table(6, 2, "white")
	set_piece_on_table(8, 2, "white")

	set_piece_on_table(1, 3, "white")
	set_piece_on_table(3, 3, "white")
	set_piece_on_table(5, 3, "white")
	set_piece_on_table(7, 3, "white")

	set_piece_on_table(2, 6, "black")
	set_piece_on_table(4, 6, "black")
	set_piece_on_table(6, 6, "black")
	set_piece_on_table(8, 6, "black")

	set_piece_on_table(1, 7, "black")
	set_piece_on_table(3, 7, "black")
	set_piece_on_table(5, 7, "black")
	set_piece_on_table(7, 7, "black")

	set_piece_on_table(2, 8, "black")
	set_piece_on_table(4, 8, "black")
	set_piece_on_table(6, 8, "black")
	set_piece_on_table(8, 8, "black")

/obj/checkered_table/proc/set_piece_on_table(_x, _y, piece_type)
	var/image/I = image('white/valtos/icons/piece.dmi', piece_type)
	I.pixel_x = (_x * table_step + 12) - table_step
	I.pixel_y = (_y * table_step) - table_step
	I.name = piece_type
	table_grid[_x][_y] = I
	overlays += I

/obj/checkered_table/proc/set_piece_on_pool(piece_type)
	var/image/I = image('white/valtos/icons/piece.dmi', piece_type)
	I.name = piece_type
	if(piece_type == "white")
		I.pixel_x = 0
		I.pixel_y = table_pool_left.len * 8
		table_pool_left += I
		overlays += I
	if(piece_type == "black")
		I.pixel_x = 108
		I.pixel_y = table_pool_right.len * 8
		table_pool_right += I
		overlays += I

/obj/checkered_table/proc/activate_piece_from_pool(piece_type)
	if(piece_type == "white")
		piece_active = table_pool_left[table_pool_left.len]
		overlays -= piece_active
		piece_active.icon_state = "[piece_active.icon_state]_picked"
		overlays += piece_active
	if(piece_type == "black")
		piece_active = table_pool_right[table_pool_right.len]
		overlays -= piece_active
		piece_active.icon_state = "[piece_active.icon_state]_picked"
		overlays += piece_active

/obj/checkered_table/proc/remove_piece_from_pool(piece_type)
	overlays -= piece_active
	if(piece_type == "white")
		table_pool_left.Cut(table_pool_left.len)
	if(piece_type == "black")
		table_pool_right.Cut(table_pool_right.len)

/obj/checkered_table/proc/remove_piece_from_table(image/piece)
	if(piece.pixel_x  == 0 || piece.pixel_x == 108)
		remove_piece_from_pool(piece.name)
		return
	overlays -= piece
	var/_x = FLOOR(((piece.pixel_x / table_step)), 1)
	var/_y = FLOOR(((piece.pixel_y / table_step) + 1), 1)
	table_grid[_x][_y] = null

/obj/checkered_table/proc/get_letter(n)
	var/list/nwords = list("A", "B", "C", "D", "E", "F", "G", "H")
	return nwords[n]

/obj/checkered_table/proc/table_click(datum/source, location, control, params, mob/user)
	SIGNAL_HANDLER
	if(!isliving(user))
		return

	var/list/PR = params2list(params)

	if(PR["alt"])
		reset_table()
		setup_checkers()
		visible_message(span_warning("<b>[user]</b> сбрасывает доску к началу."))
		return

	if(PR["ctrl"] && PR["shift"])
		reset_table()
		visible_message(span_warning("<b>[user]</b> сворачивает доску."))
		new /obj/item/checkers_kit(get_turf(src))
		qdel(src)
		return

	var/_x_clicked = text2num(PR["icon-x"])
	var/_y_clicked = text2num(PR["icon-y"])

	if(_x_clicked < 12 || _x_clicked > 108)
		if(piece_active)
			remove_piece_from_table(piece_active)
			set_piece_on_pool(piece_active.name)
			piece_active = null
		else
			if(_x_clicked < 12)
				activate_piece_from_pool("white")

			else if (_x_clicked > 108)
				activate_piece_from_pool("black")

		return

	var/_x = FLOOR(_x_clicked/table_step, 1)
	var/_y = FLOOR((_y_clicked + 12)/table_step, 1)

	var/image/clicked_piece = table_grid[_x][_y]

	if(!piece_active && clicked_piece)
		overlays -= clicked_piece
		clicked_piece.icon_state = "[clicked_piece.icon_state]_picked"
		overlays += clicked_piece
		piece_active = clicked_piece
		playsound(src.loc, 'white/valtos/sounds/checkers/capture.wav', 50)
		visible_message(span_notice("<b>[user]</b> поднимает шашку в квадрате <b>[get_letter(_y)][_x]</b>."))
	else if (clicked_piece && PR["middle"])
		overlays -= clicked_piece
		clicked_piece.icon_state = "[piece_active.name]"
		if(clicked_piece.icon == 'white/valtos/icons/piece.dmi')
			clicked_piece.icon = 'white/valtos/icons/masterpiece.dmi'
		else
			clicked_piece.icon = 'white/valtos/icons/piece.dmi'
		overlays += clicked_piece
		playsound(src.loc, 'white/valtos/sounds/checkers/capture.wav', 50)
		visible_message(span_notice("<b>[user]</b> переворачивает шашку в квадрате <b>[get_letter(_y)][_x]</b>."))
	else if (piece_active && clicked_piece)
		overlays -= piece_active
		piece_active.icon_state = "[piece_active.name]"
		overlays += piece_active
		piece_active = null
		playsound(src.loc, 'white/valtos/sounds/checkers/capture.wav', 50)
		visible_message(span_notice("<b>[user]</b> ставит шашку на место."))
	else if (piece_active && !clicked_piece)
		remove_piece_from_table(piece_active)
		overlays -= piece_active
		piece_active.icon_state = "[piece_active.name]"
		set_piece_on_table(_x, _y, piece_active.icon_state)
		piece_active = null
		playsound(src.loc, 'white/valtos/sounds/checkers/move.wav', 50)
		visible_message(span_notice("<b>[user]</b> переносит шашку в квадрат <b>[get_letter(_y)][_x]</b>."))

/*
CONTAINS:
THAT STUPID GAME KIT

*/
/obj/item/game_kit
	name = "Игровой набор"
	icon = 'white/valtos/icons/game_kit.dmi'
	icon_state = "chess"
	var/selected = null
	var/board_stat = null
	var/data = ""
	//var/base_url = "http://svn.slurm.us/public/spacestation13/misc/game_kit"
	inhand_icon_state = "chess"
	w_class = WEIGHT_CLASS_NORMAL
	desc = "Шашки или шахматы? Да какая разница, всё равно в это никто не будет играть."

/obj/item/game_kit/Initialize(mapload)
	. = ..()
	board_stat = "CRBBCRBBCRBBCRBBBBCRBBCRBBCRBBCRCRBBCRBBCRBBCRBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBCBBBCBBBCBBBCBCBBBCBBBCBBBCBBBBBCBBBCBBBCBBBCB"
	selected = "CR"
	interaction_flags_item &= ~INTERACT_ITEM_ATTACK_HAND_PICKUP

/obj/item/game_kit/proc/update()
	var/dat = text("<meta http-equiv='Content-Type' content='text/html; charset=utf-8'><CENTER><B>Игровое поле</B></CENTER><BR><a href='?src=\ref[];mode=hia'>[]</a> <a href='?src=\ref[];mode=remove'>Х</a><HR><table width= 256  border= 0  height= 256  cellspacing= 0  cellpadding= 0 >", src, (src.selected ? text("Выбрано: []", src.selected) : "Ничего не выбрано"), src)
	for (var/y = 1 to 8)
		dat += "<tr>"

		for (var/x = 1 to 8)
			var/tilecolor = (y + x) % 2 ? "#999999" : "#ffffff"
			var/piece = copytext(src.board_stat, ((y - 1) * 8 + x) * 2 - 1, ((y - 1) * 8 + x) * 2 + 1)

			dat += "<td>"
			dat += "<td style='background-color:[tilecolor]' width=32 height=32>"
			if (piece != "BB")
				dat += "<a href='?src=[text_ref(src)];s_board=[x] [y]'><img src='[SSassets.transport.get_asset_url("board_[piece].png")]' width=32 height=32 border=0>"
			else
				dat += "<a href='?src=[text_ref(src)];s_board=[x] [y]'><img src='[SSassets.transport.get_asset_url("board_none.png")]' width=32 height=32 border=0>"
			dat += "</td>"

		dat += "</tr>"

	dat += "</table><HR><B>Шашки:</B><BR>"
	for (var/piece in list("CB", "CR"))
		dat += "<a href='?src=[text_ref(src)];s_piece=[piece]'><img src='[SSassets.transport.get_asset_url("board_[piece].png")]' width=32 height=32 border=0></a>"

	dat += "<HR><B>Фигуры:</B><BR>"
	for (var/piece in list("WP", "WK", "WQ", "WI", "WN", "WR"))
		dat += "<a href='?src=[text_ref(src)];s_piece=[piece]'><img src='[SSassets.transport.get_asset_url("board_[piece].png")]' width=32 height=32 border=0></a>"
	dat += "<br>"
	for (var/piece in list("BP", "BK", "BQ", "BI", "BN", "BR"))
		dat += "<a href='?src=[text_ref(src)];s_piece=[piece]'><img src='[SSassets.transport.get_asset_url("board_[piece].png")]' width=32 height=32 border=0></a>"
	src.data = dat

/obj/item/game_kit/MouseDrop(atom/over_object)
	. = ..()
	var/mob/living/M = usr
	if(!istype(M) || M.incapacitated() || !Adjacent(M))
		return

	if(over_object == M)
		M.put_in_hands(src)

	else if(istype(over_object, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/H = over_object
		M.putItemFromInventoryInHandIfPossible(src, H.held_index)

	add_fingerprint(M)

/obj/item/game_kit/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/game_kit/attack_hand(mob/user)
	if(!isliving(user))
		return
	if (!(src.data))
		update()
	user.machine = src
	var/datum/asset/stuff = get_asset_datum(/datum/asset/simple/game_kit)
	stuff.send(user)
	user << browse(src.data, "window=game_kit;size=300x550")
	onclose(user, "game_kit")
	add_fingerprint(user)
	return ..()

/obj/item/game_kit/Topic(href, href_list)
	..()
	if ((usr.stat || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED)))
		return

	if (usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf)))
		if (href_list["s_piece"])
			src.selected = href_list["s_piece"]
		else if (href_list["mode"])
			if (href_list["mode"] == "remove")
				src.selected = "удаление"
			else
				src.selected = null
		else if (href_list["s_board"])
			if (!( src.selected ))
				src.selected = href_list["s_board"]
			else
				var/tx = text2num(copytext(href_list["s_board"], 1, 2))
				var/ty = text2num(copytext(href_list["s_board"], 3, 4))
				if ((copytext(src.selected, 2, 3) == " " && length(src.selected) == 3))
					var/sx = text2num(copytext(src.selected, 1, 2))
					var/sy = text2num(copytext(src.selected, 3, 4))
					var/place = ((sy - 1) * 8 + sx) * 2 - 1
					src.selected = copytext(src.board_stat, place, place + 2)
					if (place == 1)
						src.board_stat = text("BB[]", copytext(src.board_stat, 3, 129))
					else
						if (place == 127)
							src.board_stat = text("[]BB", copytext(src.board_stat, 1, 127))
						else
							if (place)
								src.board_stat = text("[]BB[]", copytext(src.board_stat, 1, place), copytext(src.board_stat, place + 2, 129))
					place = ((ty - 1) * 8 + tx) * 2 - 1
					if (place == 1)
						src.board_stat = text("[][]", src.selected, copytext(src.board_stat, 3, 129))
					else
						if (place == 127)
							src.board_stat = text("[][]", copytext(src.board_stat, 1, 127), src.selected)
						else
							if (place)
								src.board_stat = text("[][][]", copytext(src.board_stat, 1, place), src.selected, copytext(src.board_stat, place + 2, 129))
					src.selected = null
				else
					if (src.selected == "удаление")
						var/place = ((ty - 1) * 8 + tx) * 2 - 1
						if (place == 1)
							src.board_stat = text("BB[]", copytext(src.board_stat, 3, 129))
						else
							if (place == 127)
								src.board_stat = text("[]BB", copytext(src.board_stat, 1, 127))
							else
								if (place)
									src.board_stat = text("[]BB[]", copytext(src.board_stat, 1, place), copytext(src.board_stat, place + 2, 129))
					else
						if (length(src.selected) == 2)
							var/place = ((ty - 1) * 8 + tx) * 2 - 1
							if (place == 1)
								src.board_stat = text("[][]", src.selected, copytext(src.board_stat, 3, 129))
							else
								if (place == 127)
									src.board_stat = text("[][]", copytext(src.board_stat, 1, 127), src.selected)
								else
									if (place)
										src.board_stat = text("[][][]", copytext(src.board_stat, 1, place), src.selected, copytext(src.board_stat, place + 2, 129))
		update()
		for(var/mob/M in viewers(1, src))
			if ((M.client && M.machine == src))
				src.attack_hand(M)
