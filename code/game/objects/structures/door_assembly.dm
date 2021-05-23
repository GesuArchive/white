/obj/structure/door_assembly
	name = "каркас шлюза"
	icon = 'icons/obj/doors/airlocks/station/public.dmi'
	icon_state = "construction"
	var/overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
	anchored = FALSE
	density = TRUE
	max_integrity = 200
	var/state = AIRLOCK_ASSEMBLY_NEEDS_WIRES
	var/base_name = "airlock"
	var/mineral = null
	var/obj/item/electronics/airlock/electronics = null
	var/airlock_type = /obj/machinery/door/airlock //the type path of the airlock once completed
	var/glass_type = /obj/machinery/door/airlock/glass
	var/glass = 0 // 0 = glass can be installed. 1 = glass is already installed.
	var/created_name = null
	var/heat_proof_finished = 0 //whether to heat-proof the finished airlock
	var/previous_assembly = /obj/structure/door_assembly
	var/noglass = FALSE //airlocks with no glass version, also cannot be modified with sheets
	var/material_type = /obj/item/stack/sheet/metal
	var/material_amt = 4

/obj/structure/door_assembly/Initialize()
	. = ..()
	update_icon()
	update_name()

/obj/structure/door_assembly/examine(mob/user)
	. = ..()
	. += "<hr>"
	var/doorname = ""
	if(created_name)
		doorname = ", written on it is '[created_name]'"
	switch(state)
		if(AIRLOCK_ASSEMBLY_NEEDS_WIRES)
			if(anchored)
				. += "<span class='notice'>Анкерные болты <b>закручены</b>, но на панели технического обслуживания нету <i>проводки</i>.</span>"
			else
				. += "<span class='notice'>Каркас <b>сварен</b>, но анкерные болты <i>не закручены</i>.</span>"
		if(AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
			. += "<span class='notice'>Панель технического обслуживания <b>подключена</b>, но слот схемы <i>пуст</i>.</span>"
		if(AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
			. += "<span class='notice'>Схема <b>не плотно подключена</b>в слот, панель технического обслуживания <i>откручена и открыта</i>.</span>"
	. += "<hr>"
	if(!mineral && !glass && !noglass)
		. += "<span class='notice'>Маленькая <i>бумажная</i> табличка на каркасе [doorname]. Есть <i>свободные</i> места для установки стеклянных окон и место для покрытия конструкции материалами.</span>"
	else if(!mineral && glass && !noglass)
		. += "<span class='notice'>Маленькая <i>бумажная</i> табличка на каркасе [doorname]. Есть <i>свободное</i>место для обшивки материалами.</span>"
	else if(mineral && !glass && !noglass)
		. += "<span class='notice'>Маленькая <i>бумажная</i> табличка на каркасе [doorname]. Есть <i>свободные</i> места для установки стеклянных окон.</span>"
	else
		. += "<span class='notice'>Маленькая <i>бумажная</i> табличка на каркасе [doorname].</span>"

/obj/structure/door_assembly/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pen))
		var/t = stripped_input(user, "Enter the name for the door.", name, created_name,MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t

	else if((W.tool_behaviour == TOOL_WELDER) && (mineral || glass || !anchored ))
		if(!W.tool_start_check(user, amount=0))
			return

		if(mineral)
			var/obj/item/stack/sheet/mineral/mineral_path = text2path("/obj/item/stack/sheet/mineral/[mineral]")
			user.visible_message("<span class='notice'>[user] приваривает [mineral] покрытие к каркасу шлюза.</span>", "<span class='notice'>Я начинаю приваривать [mineral] покрытие к каркасу шлюза...</span>")
			if(W.use_tool(src, user, 40, volume=50))
				to_chat(user, "<span class='notice'>Я привариваю [mineral] покрытие.</span>")
				new mineral_path(loc, 2)
				var/obj/structure/door_assembly/PA = new previous_assembly(loc)
				transfer_assembly_vars(src, PA)

		else if(glass)
			user.visible_message("<span class='notice'>[user] отваривает стеклянную панель от каркаса шлюза.</span>", "<span class='notice'>Я начинаю отваривать стеклянную панель от каркаса шлюза...</span>")
			if(W.use_tool(src, user, 40, volume=50))
				to_chat(user, "<span class='notice'>Я отвариваю стеклянную панель.</span>")
				if(heat_proof_finished)
					new /obj/item/stack/sheet/rglass(get_turf(src))
					heat_proof_finished = 0
				else
					new /obj/item/stack/sheet/glass(get_turf(src))
				glass = 0
		else if(!anchored)
			user.visible_message("<span class='warning'>[user] разбирает каркас шлюза.</span>", \
								"<span class='notice'>Я начинаю разбирать каркас шлюза...</span>")
			if(W.use_tool(src, user, 40, volume=50))
				to_chat(user, "<span class='notice'>Я разобрал каркас шлюза.</span>")
				deconstruct(TRUE)

	else if(W.tool_behaviour == TOOL_WRENCH)
		if(!anchored )
			var/door_check = 1
			for(var/obj/machinery/door/D in loc)
				if(!D.sub_door)
					door_check = 0
					break

			if(door_check)
				user.visible_message("<span class='notice'>[user] прикручивать каркас шлюза к полу.</span>", \
					"<span class='notice'>Я начинаю прикручивать каркас шлюза к полу...</span>", \
					"<span class='hear'>Я слышу звук закручивания гаек.</span>")

				if(W.use_tool(src, user, 40, volume=100))
					if(anchored)
						return
					to_chat(user, "<span class='notice'>Я прикручиваю каркас шлюза к полу.</span>")
					name = "закрепленный каркас шлюза"
					set_anchored(TRUE)
			else
				to_chat(user, "Здесь есть другая дверь!")

		else
			user.visible_message("<span class='notice'>[user] откручивает каркас шлюза от пола.</span>", \
				"<span class='notice'>Я начинаю откручивать каркас шлюза от пола...</span>", \
				"<span class='hear'>Я слышу звук вращения гаек. </span>")
			if(W.use_tool(src, user, 40, volume=100))
				if(!anchored)
					return
				to_chat(user, "<span class='notice'>Я открутил каркас шлюза от пола.</span>")
				name = "каркас шлюза"
				set_anchored(FALSE)

	else if(istype(W, /obj/item/stack/cable_coil) && state == AIRLOCK_ASSEMBLY_NEEDS_WIRES && anchored )
		if(!W.tool_start_check(user, amount=1))
			return

		user.visible_message("<span class='notice'>[user] монтирует проводку в каркас шлюза.</span>", \
							"<span class='notice'>Я начинаю монтировать проводку в каркас шлюза...</span>")
		if(W.use_tool(src, user, 40, amount=1))
			if(state != AIRLOCK_ASSEMBLY_NEEDS_WIRES)
				return
			state = AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS
			to_chat(user, "<span class='notice'>Я смонтировал проводку в каркасе шлюза.</span>")
			name = "каркас шлюза с электропроводкой"

	else if((W.tool_behaviour == TOOL_WIRECUTTER) && state == AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS )
		user.visible_message("<span class='notice'>[user] демонтирует проводку в каркасе шлюза.</span>", \
							"<span class='notice'>Я начинаю демонтаж проводки в каркасе шлюза...</span>")

		if(W.use_tool(src, user, 40, volume=100))
			if(state != AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
				return
			to_chat(user, "<span class='notice'>Я демонтировал проводку в каркасе шлюза.</span>")
			new/obj/item/stack/cable_coil(get_turf(user), 1)
			state = AIRLOCK_ASSEMBLY_NEEDS_WIRES
			name = "закрепленный каркас шлюза"

	else if(istype(W, /obj/item/electronics/airlock) && state == AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS )
		W.play_tool_sound(src, 100)
		user.visible_message("<span class='notice'>[user] устанавливает электронную начинку в каркас шлюза.</span>", \
							"<span class='notice'>Я начинаю устанавливать электронную начинку в каркас шлюза...</span>")
		if(do_after(user, 40, target = src))
			if( state != AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS )
				return
			if(!user.transferItemToLoc(W, src))
				return

			to_chat(user, "<span class='notice'>Я установил электронную начинку в каркас шлюза.</span>")
			state = AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER
			name = "каркас шлюза на финальной стадии сборки"
			electronics = W


	else if((W.tool_behaviour == TOOL_CROWBAR) && state == AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER )
		user.visible_message("<span class='notice'>[user] удаляет электронную начинку из каркаса шлюза.</span>", \
								"<span class='notice'>Я начинаю удалять электронную начинку из каркаса шлюза...</span>")

		if(W.use_tool(src, user, 40, volume=100))
			if(state != AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
				return
			to_chat(user, "<span class='notice'>Я удалил электронную начинку из шлюза.</span>")
			state = AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS
			name = "подключенный к сети каркас шлюза"
			var/obj/item/electronics/airlock/ae
			if (!electronics)
				ae = new/obj/item/electronics/airlock( loc )
			else
				ae = electronics
				electronics = null
				ae.forceMove(src.loc)

	else if(istype(W, /obj/item/stack/sheet) && (!glass || !mineral))
		var/obj/item/stack/sheet/G = W
		if(G)
			if(G.get_amount() >= 1)
				if(!noglass)
					if(!glass)
						if(istype(G, /obj/item/stack/sheet/rglass) || istype(G, /obj/item/stack/sheet/glass))
							playsound(src, 'sound/items/crowbar.ogg', 100, TRUE)
							user.visible_message("<span class='notice'>[user] добавляет [G.name] к каркасу шлюза.</span>", \
												"<span class='notice'>Я устанавливаю [G.name] в каркас шлюза...</span>")
							if(do_after(user, 40, target = src))
								if(G.get_amount() < 1 || glass)
									return
								if(G.type == /obj/item/stack/sheet/rglass)
									to_chat(user, "<span class='notice'>Я устанавливаю [G.name] окно в каркас шлюза.</span>")
									heat_proof_finished = 1 //reinforced glass makes the airlock heat-proof
									name = "почти готовое термозащитное окно каркаса шлюза"
								else
									to_chat(user, "<span class='notice'>Я устанавливаю обычное окно в каркас шлюза.</span>")
									name = "почти готовое окно каркаса шлюза"
								G.use(1)
								glass = TRUE
					if(!mineral)
						if(istype(G, /obj/item/stack/sheet/mineral) && G.sheettype)
							var/M = G.sheettype
							if(G.get_amount() >= 2)
								playsound(src, 'sound/items/crowbar.ogg', 100, TRUE)
								user.visible_message("<span class='notice'>[user] добавляет [G.name] в каркас шлюза.</span>", \
									"<span class='notice'>Я начинаю устанавливать [G.name] в каркас шлюза...</span>")
								if(do_after(user, 40, target = src))
									if(G.get_amount() < 2 || mineral)
										return
									to_chat(user, "<span class='notice'>Я устанавливаю плату из [M] в каркас шлюза.</span>")
									G.use(2)
									var/mineralassembly = text2path("/obj/structure/door_assembly/door_assembly_[M]")
									var/obj/structure/door_assembly/MA = new mineralassembly(loc)

									if(MA.noglass && glass) //in case the new door doesn't support glass. prevents the new one from reverting to a normal airlock after being constructed.
										var/obj/item/stack/sheet/dropped_glass
										if(heat_proof_finished)
											dropped_glass = new /obj/item/stack/sheet/rglass(drop_location())
											heat_proof_finished = FALSE
										else
											dropped_glass = new /obj/item/stack/sheet/glass(drop_location())
										glass = FALSE
										to_chat(user, "<span class='notice'>Когда я заканчиваю, [dropped_glass.singular_name] выпадает из рамки [MA].</span>")

									transfer_assembly_vars(src, MA, TRUE)
							else
								to_chat(user, "<span class='warning'>Вам нужно как минимум два листа материала чтобы добавить минеральное покрытие!</span>")
					else
						to_chat(user, "<span class='warning'>Я не могу добавить [G] к [src]!</span>")
				else
					to_chat(user, "<span class='warning'>Я не могу добавить [G] к [src]!</span>")

	else if((W.tool_behaviour == TOOL_SCREWDRIVER) && state == AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER )
		user.visible_message("<span class='notice'>[user] заканчивает делать шлюз.</span>", \
			"<span class='notice'>Я почти закончил делать шлюз...</span>")

		if(W.use_tool(src, user, 40, volume=100))
			if(loc && state == AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
				to_chat(user, "<span class='notice'>Я доделал шлюз.</span>")
				var/obj/machinery/door/airlock/door
				if(glass)
					door = new glass_type( loc )
				else
					door = new airlock_type( loc )
				door.setDir(dir)
				door.unres_sides = electronics.unres_sides
				//door.req_access = req_access
				door.electronics = electronics
				door.heat_proof = heat_proof_finished
				door.security_level = 0
				if(electronics.one_access)
					door.req_one_access = electronics.accesses
				else
					door.req_access = electronics.accesses
				if(created_name)
					door.name = created_name
				else
					door.name = base_name
				door.previous_airlock = previous_assembly
				electronics.forceMove(door)
				door.update_icon()
				qdel(src)
	else
		return ..()
	update_name()
	update_icon()

/obj/structure/door_assembly/update_overlays()
	. = ..()
	if(!glass)
		. += get_airlock_overlay("fill_construction", icon)
	else
		. += get_airlock_overlay("glass_construction", overlays_file)
	. += get_airlock_overlay("panel_c[state+1]", overlays_file)

/obj/structure/door_assembly/proc/update_name()
	name = ""
	switch(state)
		if(AIRLOCK_ASSEMBLY_NEEDS_WIRES)
			if(anchored)
				name = "закрепленная "
		if(AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
			name += "со смонтированной проводкой "		
		if(AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
			name = "почти законченная "
	name += "[heat_proof_finished ? "heat-proofed " : ""][glass ? "window " : ""][base_name] assembly"
		

/obj/structure/door_assembly/proc/transfer_assembly_vars(obj/structure/door_assembly/source, obj/structure/door_assembly/target, previous = FALSE)
	target.glass = source.glass
	target.heat_proof_finished = source.heat_proof_finished
	target.created_name = source.created_name
	target.state = source.state
	target.set_anchored(source.anchored)
	if(previous)
		target.previous_assembly = source.type
	if(electronics)
		target.electronics = source.electronics
		source.electronics.forceMove(target)
	target.update_icon()
	target.update_name()
	qdel(source)

/obj/structure/door_assembly/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/turf/T = get_turf(src)
		if(!disassembled)
			material_amt = rand(2,4)
		new material_type(T, material_amt)
		if(glass)
			if(disassembled)
				if(heat_proof_finished)
					new /obj/item/stack/sheet/rglass(T)
				else
					new /obj/item/stack/sheet/glass(T)
			else
				new /obj/item/shard(T)
		if(mineral)
			var/obj/item/stack/sheet/mineral/mineral_path = text2path("/obj/item/stack/sheet/mineral/[mineral]")
			new mineral_path(T, 2)
	qdel(src)


/obj/structure/door_assembly/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_DECONSTRUCT)
		return list("mode" = RCD_DECONSTRUCT, "delay" = 50, "cost" = 16)
	return FALSE

/obj/structure/door_assembly/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, "<span class='notice'>Я разбираю [src].</span>")
			qdel(src)
			return TRUE
	return FALSE
