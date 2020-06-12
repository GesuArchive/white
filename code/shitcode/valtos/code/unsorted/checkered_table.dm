// Shitcode

/obj/item/checkered_table
	name = "шахматное поле"
	icon = 'code/shitcode/valtos/icons/checkers.dmi'
	icon_state = "table"
	pixel_x = -44
	pixel_y = -32
	var/table_grid[8][8]
	var/list/table_pool_left = list()
	var/list/table_pool_right = list()
	var/table_step = 12
	var/image/piece_active

/obj/item/checkered_table/Initialize()
	..()
	reset_table()
	setup_checkers()

/obj/item/checkered_table/MouseDrop(atom/over_object)
	. = ..()
	var/mob/living/M = usr
	if(!istype(M) || M.incapacitated() || !Adjacent(M))
		return

	if(over_object == M)
		M.put_in_hands(src)

	else if(istype(over_object, /obj/screen/inventory/hand))
		var/obj/screen/inventory/hand/H = over_object
		M.putItemFromInventoryInHandIfPossible(src, H.held_index)

	reset_table()

	add_fingerprint(M)

/obj/item/checkered_table/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/checkered_table/proc/reset_table()
	for(var/_x in 1 to 8)
		for(var/_y in 1 to 8)
			overlays -= table_grid[_x][_y]
			table_grid[_x][_y] = null
			table_pool_left.Cut()
			table_pool_right.Cut()

/obj/item/checkered_table/proc/setup_checkers()
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

/obj/item/checkered_table/proc/set_piece_on_table(_x, _y, piece_type)
	var/image/I = image('code/shitcode/valtos/icons/piece.dmi', piece_type)
	I.pixel_x = (_x * table_step + 12) - table_step
	I.pixel_y = (_y * table_step) - table_step
	I.name = piece_type
	table_grid[_x][_y] = I
	overlays += I

/obj/item/checkered_table/proc/set_piece_on_pool(piece_type)
	var/image/I = image('code/shitcode/valtos/icons/piece.dmi', piece_type)
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

/obj/item/checkered_table/proc/activate_piece_from_pool(piece_type)
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

/obj/item/checkered_table/proc/remove_piece_from_pool(piece_type)
	overlays -= piece_active
	if(piece_type == "white")
		table_pool_left.Cut(table_pool_left.len)
	if(piece_type == "black")
		table_pool_right.Cut(table_pool_right.len)

/obj/item/checkered_table/proc/remove_piece_from_table(image/piece)
	if(piece.pixel_x  == 0 || piece.pixel_x == 108)
		remove_piece_from_pool(piece.name)
		return
	overlays -= piece
	var/_x = FLOOR(((piece.pixel_x / table_step)), 1)
	var/_y = FLOOR(((piece.pixel_y / table_step) + 1), 1)
	table_grid[_x][_y] = null

/obj/item/checkered_table/Click(location, control, params)
	if(!isliving(usr))
		return
	if(!in_range(usr, src)
		return

	var/_x_clicked = text2num(params2list(params)["icon-x"])
	var/_y_clicked = text2num(params2list(params)["icon-y"])

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

	if(!piece_active && clicked_piece != null)
		overlays -= clicked_piece
		clicked_piece.icon_state = "[clicked_piece.icon_state]_picked"
		overlays += clicked_piece
		piece_active = clicked_piece
		playsound(src.loc, 'code/shitcode/valtos/sounds/checkers/capture.wav', 50)
	else if (piece_active && clicked_piece != null)
		overlays -= piece_active
		piece_active.icon_state = "[piece_active.name]"
		overlays += piece_active
		piece_active = null
		playsound(src.loc, 'code/shitcode/valtos/sounds/checkers/capture.wav', 50)
	else if (piece_active && clicked_piece == null)
		remove_piece_from_table(piece_active)
		overlays -= piece_active
		piece_active.icon_state = "[piece_active.name]"
		set_piece_on_table(_x, _y, piece_active.icon_state)
		piece_active = null
		playsound(src.loc, 'code/shitcode/valtos/sounds/checkers/move.wav', 50)
