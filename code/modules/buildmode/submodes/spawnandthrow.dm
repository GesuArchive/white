/datum/buildmode_mode/spawnandthrow
	key = "spawn&throw"
	var/atom/objholder = null
	var/mob/mobcrutch = null
	var/force = MOVE_FORCE_NORMAL
	var/speed = 1
	var/spin = TRUE
	var/range = 7
// FIXME: add logic which adds a button displaying the icon
// of the currently selected path

/datum/buildmode_mode/spawnandthrow/New(datum/buildmode/BM)
	. = ..()
	mobcrutch = new /mob

/datum/buildmode_mode/spawnandthrow/Destroy()
	. = ..()
	qdel(mobcrutch)

/datum/buildmode_mode/spawnandthrow/show_help(client/c)
	to_chat(c, span_notice("***********************************************************"))
	to_chat(c, span_notice("Middle Mouse Button - Copy object."))
	to_chat(c, span_notice("Left Mouse Button - Throw selected object."))
	to_chat(c, span_notice("Right Mouse Button - Call attack_self() and throw object. (similiar to using item in hand, uses a stub mob for this, may be buggy with items that are more complex than regular grenades.)"))
	to_chat(c, span_notice("Alt click - Instead of throwing uses newtonian_move() to nudge object in selected direction. Only works with no gravity."))
	to_chat(c, span_notice("Use the button in the upper left corner to"))
	to_chat(c, span_notice("configure throwing. If range is 0, it will spawn and throw the object on the same tile you clicked on."))
	to_chat(c, span_notice("***********************************************************"))

/datum/buildmode_mode/spawnandthrow/change_settings(client/c)
	while(TRUE) // i am so glad we don't have qc
		var/list/options = list("typepath \[[!isnull(objholder) ? objholder : "null"]]",\
		"force \[[force]]",\
		"speed \[[speed]]",\
		"range \[[range]]",\
		"spin \[[spin ? "✓" : "x"]]",\
		"--close--"		)
		var/selection = input("Please make extra sure you know what you're doing.", "Configure") as null|anything in options
		if(isnull(selection))
			return
		selection = copytext(selection, 1, 5)

		switch(selection)
			if("type")
				var/target_path = input(c, "Enter typepath:", "Typepath", "[objholder]")
				objholder = text2path(target_path)
				if(!ispath(objholder))
					objholder = pick_closest_path(target_path)
					if(!objholder)
						alert("No path was selected")
					else if(ispath(objholder, /area))
						objholder = null
						alert("That path is not allowed.")

			if("forc")
				var/input = input("\
				overpowering force = [MOVE_FORCE_OVERPOWERING]\
				extremely strong force = [MOVE_FORCE_EXTREMELY_STRONG]\
				very strong force = [MOVE_FORCE_VERY_STRONG]\
				strong force = [MOVE_FORCE_STRONG]\
				normal force = [MOVE_FORCE_NORMAL]\
				weak force = [MOVE_FORCE_WEAK]\
				very weak force = [MOVE_FORCE_VERY_WEAK]\
				extremely weak force = [MOVE_FORCE_EXTREMELY_WEAK]", "Force", force)
				if(input>0)
					force = input
			if("spee")
				var/input = input("", "Speed", speed)
				if(input>0)
					speed = input
			if("rang")
				var/input = input("", "Range", range)
				input = round(input)
				if(input>=0)
					range = input
			if("spin")
				spin = !spin
			if("--cl")
				return

/datum/buildmode_mode/spawnandthrow/handle_click(client/c, params, obj/object)
	var/list/pa = params2list(params)
	//var/left_click = pa.Find("left")
	var/middle_click = pa.Find("middle")
	var/right_click = pa.Find("right")
	var/alt_click = pa.Find("alt")

	mobcrutch.name = "\[[c.ckey] spawn&throw buildmode]"

	if(middle_click)
		if(ispath(objholder, /area))
			to_chat(c, span_notice("[initial(object.name)] is not a valid atom for this mode! Please try again."))
		else
			objholder = object.type
			to_chat(c, span_notice("[initial(object.name)] ([object.type]) selected."))
			return

	if(isnull(objholder))
		return

	var/throwtarget
	if(range)
		throwtarget = get_edge_target_turf(get_turf(object), BM.build_dir)
	else
		throwtarget = get_turf(object)

	var/obj/A = new objholder (get_turf(object))
	if(right_click && istype(A, /obj/item))
		var/obj/item/temp = A
		temp.attack_self(c.mob)

	if(alt_click)
		A.newtonian_move(BM.build_dir)
		log_admin("Build Mode: [key_name(c)] spawned [A] in [AREACOORD(object)][right_click ? ", activated it and" : " and"] nudged it in space. (dir=[dir2ru_text(BM.build_dir)])")
	else
		if(istype(A, /obj/projectile))
			var/obj/projectile/proj = A
			proj.fire(dir2angle(BM.build_dir))
			log_admin("Build Mode: [key_name(c)] fired [A] in [AREACOORD(object)] (dir=[dir2ru_text(BM.build_dir)]).")
			return
		A.safe_throw_at(throwtarget, range, speed, force = src.force, spin = src.spin)
		log_admin("Build Mode: [key_name(c)] spawned [A] in [AREACOORD(object)][right_click ? ", activated it and" : " and"] thrown it (range = [range], speed = [speed], force = [force], dir=[dir2ru_text(BM.build_dir)]).")
