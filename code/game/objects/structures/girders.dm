/obj/structure/girder
	name = "балка"
	icon_state = "girder"
	desc = "Большая металлическая структурная сборка. Требуется слой железа, прежде чем он может рассматриваться как стена."
	anchored = TRUE
	density = TRUE
	var/state = GIRDER_NORMAL
	var/girderpasschance = 20 // percentage chance that a projectile passes through the girder.
	var/can_displace = TRUE //If the girder can be moved around by wrenching it
	var/next_beep = 0 //Prevents spamming of the construction sound
	max_integrity = 200
	flags_1 = RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1
	rad_insulation = RAD_VERY_LIGHT_INSULATION

/obj/structure/girder/examine(mob/user)
	. = ..()
	. += "<hr>"
	switch(state)
		if(GIRDER_REINF, GIRDER_PLAST)
			. += span_notice("Ребра жесткости <b>закреплены</b> винтами на своем месте.")
		if(GIRDER_REINF_STRUTS, GIRDER_PLAST_STRUTS)
			. += span_notice("Ребра жесткости <i>откручены</i> и могут быть <b>перекушены</b> для демонтажа.")
		if(GIRDER_NORMAL)
			if(can_displace)
				. += span_notice("Анкерные <b>болты прикручены</b> к полу.")
		if(GIRDER_DISPLACED)
			. += span_notice("Анкерные <i>болты откручены</i> от пола, вся конструкция удерживается вместе парой <b>винтов</b>.")
		if(GIRDER_DISASSEMBLED)
			. += span_notice("[capitalize(src.name)] Ошибка! Сообщите о ней разработчикам!")
		if(GIRDER_TRAM)
			. += span_notice("[capitalize(src.name)] используется для трамвая. Можно разобрать отвёрткой!")

/obj/structure/girder/attackby(obj/item/W, mob/user, params)
	var/platingmodifier = 1
	if(HAS_TRAIT(user, TRAIT_QUICK_BUILD))
		platingmodifier = 0.7
		if(next_beep <= world.time)
			next_beep = world.time + 10
			playsound(src, 'sound/machines/clockcult/integration_cog_install.ogg', 50, TRUE)
	add_fingerprint(user)

	if(istype(W, /obj/item/gun/energy/plasmacutter))
		to_chat(user, span_notice("Начинаю перерезать раму..."))
		if(W.use_tool(src, user, 40, volume=100))
			to_chat(user, span_notice("Разрезаю раму на листы металла."))
			var/obj/item/stack/sheet/iron/M = new (loc, 2)
			if (!QDELETED(M))
				M.add_fingerprint(user)
			qdel(src)
			return

	else if(istype(W, /obj/item/stack))
		if(iswallturf(loc))
			to_chat(user, span_warning("Тут уже есть стена!"))
			return
		if(!isfloorturf(src.loc) && state != GIRDER_TRAM)
			to_chat(user, span_warning("Для возведения фальшстены необходимо наличие пола!"))
			return
		if (locate(/obj/structure/falsewall) in src.loc.contents)
			to_chat(user, span_warning("Тут уже есть фальшстена!"))
			return
		if(state == GIRDER_TRAM)
			if(!locate(/obj/structure/industrial_lift/tram) in src.loc.contents)
				balloon_alert(user, "нужен трамвайный пол!")
				return

		if(istype(W, /obj/item/stack/rods))
			var/obj/item/stack/rods/S = W
			if(state == GIRDER_DISPLACED)
				if(S.get_amount() < 2)
					to_chat(user, span_warning("Для создания фальшивой укрепленной стены мне понадобится как минимум два металлических стержня!"))
					return
				to_chat(user, span_notice("Начинаю строить фальшивую укрепленную стену..."))
				if(do_after(user, 20, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					to_chat(user, span_notice("Готово. Для открытия или закрытия прохода необходимо надавить на стену."))
					var/obj/structure/falsewall/iron/FW = new (loc)
					transfer_fingerprints_to(FW)
					qdel(src)
					return
			else
				if(S.get_amount() < 5)
					to_chat(user, span_warning("Для добавления обшивки мне понадобится не менее пяти металлических стержней!"))
					return
				to_chat(user, span_notice("Начинаю закреплять обшивку..."))
				if(do_after(user, 40, target = src))
					if(S.get_amount() < 5)
						return
					S.use(5)
					to_chat(user, span_notice("Закрепляю обшивку."))
					var/turf/T = get_turf(src)
					T.PlaceOnTop(/turf/closed/wall/mineral/iron)
					transfer_fingerprints_to(T)
					qdel(src)
				return

		if(!istype(W, /obj/item/stack/sheet))
			return

		var/obj/item/stack/sheet/S = W
		if(istype(S, /obj/item/stack/sheet/iron))
			if(state == GIRDER_DISPLACED)
				if(S.get_amount() < 2)
					to_chat(user, span_warning("Для создания фальшивой стены мне понадобится как минимум два листа железа!"))
					return
				to_chat(user, span_notice("Начинаю строить фальшивую стену..."))
				if(do_after(user, 20*platingmodifier, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					to_chat(user, span_notice("Готово. Для открытия или закрытия прохода необходимо надавить на стену."))
					var/obj/structure/falsewall/F = new (loc)
					transfer_fingerprints_to(F)
					qdel(src)
					return
			else if(state == GIRDER_REINF)
				to_chat(user, span_warning("Для завершения строительства укрепленной стены мне необходим лист пластали, обычное железо тут не подойдет."))
				return
			else if(state == GIRDER_TRAM)
				if(S.get_amount() < 2)
					balloon_alert(user, "требуется [2] листов!")
					return
				balloon_alert(user, "добавляем покрытие...")
				if (do_after(user, 4 SECONDS, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					var/obj/structure/tramwall/tram_wall = new(loc)
					transfer_fingerprints_to(tram_wall)
					qdel(src)
				return
			else
				if(S.get_amount() < 2)
					to_chat(user, span_warning("Для завершения строительства стены мне понадобится как минимум два листа железа!"))
					return
				to_chat(user, span_notice("Начинаю закреплять обшивку..."))
				if (do_after(user, 40*platingmodifier, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					to_chat(user, span_notice("Закрепляю обшивку."))
					var/turf/T = get_turf(src)
					T.PlaceOnTop(/turf/closed/wall)
					transfer_fingerprints_to(T)
					qdel(src)
				return

// 	Проклепанная стена

		if(istype(S, /obj/item/stack/sheet/riveted_metal))
			if(state == GIRDER_DISPLACED)
				if(S.get_amount() < 2)
					to_chat(user, span_warning("Для создания фальшивой проклепанной стены мне понадобится как минимум два листа проклепанного железа!"))
					return
				to_chat(user, span_notice("Начинаю строить фальшивую проклепанную стену..."))
				if(do_after(user, 20*platingmodifier, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					to_chat(user, span_notice("Готово. Для открытия или закрытия прохода необходимо надавить на стену."))
					var/obj/structure/falsewall/riveted_wall/F = new (loc)
					transfer_fingerprints_to(F)
					qdel(src)
					return
			else if(state == GIRDER_REINF)
				to_chat(user, span_warning("Для завершения строительства укрепленной стены мне необходим лист пластали, обычное железо тут не подойдет."))
				return
			else
				if(S.get_amount() < 2)
					to_chat(user, span_warning("Для завершения строительства проклепанной стены мне понадобится как минимум два листа проклепанного железа!"))
					return
				to_chat(user, span_notice("Начинаю закреплять обшивку..."))
				if (do_after(user, 40*platingmodifier, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					to_chat(user, span_notice("Закрепляю обшивку."))
					var/turf/T = get_turf(src)
					T.PlaceOnTop(/turf/closed/wall/riveted_wall)
					transfer_fingerprints_to(T)
					qdel(src)
				return

//	Пласталевая стена

		if(istype(S, /obj/item/stack/sheet/plasteel))
			if(state == GIRDER_DISPLACED)
				if(S.get_amount() < 2)
					to_chat(user, span_warning("Для создания фальшстены мне понадобится как минимум два листа пластали!"))
					return
				to_chat(user, span_notice("Начинаю строить фальшивую укрепленную стену..."))
				if(do_after(user, 40, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					to_chat(user, span_notice("Готово. Для открытия или закрытия прохода необходимо надавить на стену."))
					var/obj/structure/falsewall/reinforced/FW = new (loc)
					transfer_fingerprints_to(FW)
					qdel(src)
					return
			else if(state == GIRDER_REINF)
				if(S.get_amount() < 1)
					return
				to_chat(user, span_notice("Начинаю закреплять бронелисты..."))
				if(do_after(user, 50*platingmodifier, target = src))
					if(S.get_amount() < 1)
						return
					S.use(1)
					to_chat(user, span_notice("Закрепляю бронелисты."))
					var/turf/T = get_turf(src)
					T.PlaceOnTop(/turf/closed/wall/r_wall)
					transfer_fingerprints_to(T)
					qdel(src)
				return
			else
				if(S.get_amount() < 1)
					return
				if(state == GIRDER_PLAST)
					to_chat(user, span_warning("Невозможно закрепить пласталевую обшивку на пластитановых ребрах жесткости!"))
					return
				to_chat(user, span_notice("Начинаю устанавливать ребра жесткости..."))
				if(do_after(user, 60*platingmodifier, target = src))
					if(S.get_amount() < 1)
						return
					S.use(1)
					to_chat(user, span_notice("Устанавливаю ребра жесткости."))
					var/obj/structure/girder/reinforced/R = new (loc)
					transfer_fingerprints_to(R)
					qdel(src)
				return

//	Пластитановая стена

		if(istype(S, /obj/item/stack/sheet/mineral/plastitanium))
			if(state == GIRDER_DISPLACED)
				if(S.get_amount() < 2)
					to_chat(user, span_warning("Для создания фальшстены мне понадобится как минимум два листа пластали!"))
					return
				to_chat(user, span_notice("Начинаю строить фальшивую укрепленную стену..."))
				if(do_after(user, 60, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					to_chat(user, span_notice("Готово. Для открытия или закрытия прохода необходимо надавить на стену."))
					var/obj/structure/falsewall/plastitanium/FW = new (loc)
					transfer_fingerprints_to(FW)
					qdel(src)
					return
			else if(state == GIRDER_PLAST)
				if(S.get_amount() < 1)
					return
				to_chat(user, span_notice("Начинаю закреплять бронелисты..."))
				if(do_after(user, 60*platingmodifier, target = src))
					if(S.get_amount() < 1)
						return
					S.use(1)
					to_chat(user, span_notice("Закрепляю бронелисты."))
					var/turf/T = get_turf(src)
					T.PlaceOnTop(/turf/closed/wall/r_wall/syndicate)
					transfer_fingerprints_to(T)
					qdel(src)
				return
			else
				if(S.get_amount() < 1)
					return
				if(state == GIRDER_REINF)
					to_chat(user, span_warning("Невозможно закрепить пластитановую обшивку на пласталевых ребрах жесткости!"))
					return
				to_chat(user, span_notice("Начинаю устанавливать ребра жесткости..."))
				if(do_after(user, 60*platingmodifier, target = src))
					if(S.get_amount() < 1)
						return
					S.use(1)
					to_chat(user, span_notice("Устанавливаю ребра жесткости."))
					var/obj/structure/girder/plastitanium/R = new (loc)
					transfer_fingerprints_to(R)
					qdel(src)
				return

		if(S.sheettype != "runed")
			var/M = S.sheettype
			if(state == GIRDER_DISPLACED)
				var/falsewall_type = text2path("/obj/structure/falsewall/[M]")
				if(!falsewall_type)
					to_chat(user, span_warning("Кажется [S] не подходит в качестве материала для строительства фальшивой стены!"))
					return
				if(S.get_amount() < 2)
					to_chat(user, span_warning("Для создания фальшстены мне понадобится как минимум два листа [S]!"))
					return
				if(do_after(user, 20, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					to_chat(user, span_notice("Готово. Для открытия или закрытия прохода необходимо надавить на стену."))
					var/obj/structure/falsewall/FW = new falsewall_type (loc)
					transfer_fingerprints_to(FW)
					qdel(src)
					return
			else
				if(S.get_amount() < 2)
					to_chat(user, span_warning("Для завершения строительства стены мне понадобится как минимум два листа [S]!"))
					return
				to_chat(user, span_notice("Начинаю закреплять обшивку..."))
				if (do_after(user, 40, target = src))
					if(S.get_amount() < 2)
						return
					S.use(2)
					to_chat(user, span_notice("Закрепляю обшивку."))
					var/turf/T = get_turf(src)
					if(S.walltype)
						T.PlaceOnTop(S.walltype)
					else
						var/turf/newturf = T.PlaceOnTop(/turf/closed/wall/material)
						var/list/material_list = list()
						if(S.material_type)
							material_list[GET_MATERIAL_REF(S.material_type)] = MINERAL_MATERIAL_AMOUNT * 2
						if(material_list)
							newturf.set_custom_materials(material_list)

					transfer_fingerprints_to(T)
					qdel(src)
				return

		add_hiddenprint(user)

	else if(istype(W, /obj/item/pipe))
		var/obj/item/pipe/P = W
		if (P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
			if(!user.transferItemToLoc(P, drop_location()))
				return
			to_chat(user, span_notice("Пропускаю трубу под стеной."))
	else
		return ..()

// Screwdriver behavior for girders
/obj/structure/girder/screwdriver_act(mob/user, obj/item/tool)
	if(..())
		return TRUE

	. = FALSE
	if(state == GIRDER_TRAM)
		balloon_alert(user, "разбираем балку...")
		if(tool.use_tool(src, user, 4 SECONDS, volume=100))
			if(state != GIRDER_TRAM)
				return
			state = GIRDER_DISASSEMBLED
			var/obj/item/stack/sheet/iron/M = new (loc, 2)
			if (!QDELETED(M))
				M.add_fingerprint(user)
			qdel(src)
		return TRUE

	if(state == GIRDER_DISPLACED)
		user.visible_message(span_warning("[user] разбирает балку.") ,
			span_notice("Начинаю разбирать балку...") ,
			span_hear("Слышу металлический шелест."))
		if(tool.use_tool(src, user, 40, volume=100))
			if(state != GIRDER_DISPLACED)
				return
			state = GIRDER_DISASSEMBLED
			to_chat(user, span_notice("Разбираю балку."))
			var/obj/item/stack/sheet/iron/M = new (loc, 2)
			if (!QDELETED(M))
				M.add_fingerprint(user)
			qdel(src)
		return TRUE

	else if(state == GIRDER_REINF)
		to_chat(user, span_notice("Начинаю откручивать ребра жесткости..."))
		if(tool.use_tool(src, user, 40, volume=100))
			if(state != GIRDER_REINF)
				return
			to_chat(user, span_notice("Откручиваю ребра жесткости."))
			state = GIRDER_REINF_STRUTS
		return TRUE

	else if(state == GIRDER_REINF_STRUTS)
		to_chat(user, span_notice("Начинаю прикручивать ребра жесткости..."))
		if(tool.use_tool(src, user, 40, volume=100))
			if(state != GIRDER_REINF_STRUTS)
				return
			to_chat(user, span_notice("Прикручиваю ребра жесткости."))
			state = GIRDER_REINF
		return TRUE

	else if(state == GIRDER_PLAST)
		to_chat(user, span_notice("Начинаю откручивать ребра жесткости..."))
		if(tool.use_tool(src, user, 60, volume=100))
			if(state != GIRDER_PLAST)
				return
			to_chat(user, span_notice("Откручиваю ребра жесткости."))
			state = GIRDER_PLAST_STRUTS
		return TRUE

	else if(state == GIRDER_PLAST_STRUTS)
		to_chat(user, span_notice("Начинаю прикручивать ребра жесткости..."))
		if(tool.use_tool(src, user, 60, volume=100))
			if(state != GIRDER_PLAST_STRUTS)
				return
			to_chat(user, span_notice("Прикручиваю ребра жесткости."))
			state = GIRDER_PLAST
		return TRUE

// Wirecutter behavior for girders
/obj/structure/girder/wirecutter_act(mob/user, obj/item/tool)
	. = ..()
	if(state == GIRDER_REINF_STRUTS)
		to_chat(user, span_notice("Начинаю демонтировать ребра жесткости..."))
		if(tool.use_tool(src, user, 40, volume=100))
			to_chat(user, span_notice("Перекусываю ребра жесткости."))
			new /obj/item/stack/sheet/plasteel(get_turf(src))
			var/obj/structure/girder/G = new (loc)
			transfer_fingerprints_to(G)
			qdel(src)
		return TRUE
	if(state == GIRDER_PLAST_STRUTS)
		to_chat(user, span_notice("Начинаю демонтировать ребра жесткости..."))
		if(tool.use_tool(src, user, 60, volume=100))
			to_chat(user, span_notice("Перекусываю ребра жесткости."))
			new /obj/item/stack/sheet/mineral/plastitanium(get_turf(src))
			var/obj/structure/girder/G = new (loc)
			transfer_fingerprints_to(G)
			qdel(src)
		return TRUE

/obj/structure/girder/wrench_act(mob/user, obj/item/tool)
	. = ..()
	if(state == GIRDER_DISPLACED)
		if(!isfloorturf(loc))
			to_chat(user, span_warning("Для закручивания анкерных болтов необходимо наличие пола!"))

		to_chat(user, span_notice("Начинаю закручивать анкерные болты..."))
		if(tool.use_tool(src, user, 40, volume=100))
			to_chat(user, span_notice("Закручиваю анкерные болты."))
			var/obj/structure/girder/G = new (loc)
			transfer_fingerprints_to(G)
			qdel(src)
		return TRUE
	else if(state == GIRDER_NORMAL && can_displace)
		to_chat(user, span_notice("Начинаю откручивать анкерные болты..."))
		if(tool.use_tool(src, user, 40, volume=100))
			to_chat(user, span_notice("Откручиваю анкерные болты."))
			var/obj/structure/girder/displaced/D = new (loc)
			transfer_fingerprints_to(D)
			qdel(src)
		return TRUE

/obj/structure/girder/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if((mover.pass_flags & PASSGRILLE) || istype(mover, /obj/projectile))
		return prob(girderpasschance)

/obj/structure/girder/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller, no_id)
	. = !density
	if(istype(caller))
		. = . || (caller.pass_flags & PASSGRILLE)

/obj/structure/girder/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/remains = pick(/obj/item/stack/rods, /obj/item/stack/sheet/iron)
		new remains(loc)
	qdel(src)

/obj/structure/girder/narsie_act()
	new /obj/structure/girder/cult(loc)
	qdel(src)

/obj/structure/girder/displaced
	name = "открученная балка"
	icon_state = "displaced"
	anchored = FALSE
	state = GIRDER_DISPLACED
	girderpasschance = 25
	max_integrity = 120

/obj/structure/girder/reinforced
	name = "укрепленная балка"
	icon_state = "reinforced"
	state = GIRDER_REINF
	girderpasschance = 0
	max_integrity = 350

/obj/structure/girder/plastitanium
	name = "пластитановая балка"
	icon_state = "plastitanium"
	state = GIRDER_PLAST
	girderpasschance = 0
	max_integrity = 900


/obj/structure/girder/tram
	name = "трамвайная балка"
	state = GIRDER_TRAM

//////////////////////////////////////////// cult girder //////////////////////////////////////////////

/obj/structure/girder/cult
	name = "руническая балка"
	desc = "Каркас сделан из странного, леденяще-холодного металла. Поверхность полностью монолитна и на ней незаметно никаких болтов."
	icon = 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	can_displace = FALSE

/obj/structure/girder/cult/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(istype(W, /obj/item/melee/cultblade/dagger) && iscultist(user)) //Cultists can demolish cult girders instantly with their tomes
		user.visible_message(span_warning("[user] бьет руническую балку используя [W]!") , span_notice("Уничтожаю руническую балку."))
		new /obj/item/stack/sheet/runed_metal(drop_location(), 1)
		qdel(src)

	else if(W.tool_behaviour == TOOL_WELDER)
		if(!W.tool_start_check(user, amount=0))
			return

		to_chat(user, span_notice("Начинаю разрезать балку..."))
		if(W.use_tool(src, user, 40, volume=50))
			to_chat(user, span_notice("Разрезаю балку на части."))
			var/obj/item/stack/sheet/runed_metal/R = new(drop_location(), 1)
			transfer_fingerprints_to(R)
			qdel(src)

	else if(istype(W, /obj/item/stack/sheet/runed_metal))
		var/obj/item/stack/sheet/runed_metal/R = W
		if(R.get_amount() < 1)
			to_chat(user, span_warning("Мне нужен хотя бы один лист рунического металла, чтобы построить руническую стену!"))
			return
		user.visible_message(span_notice("[user] начинает закреплять рунический металл на балке...") , span_notice("Начинаю сооружать руническую стену..."))
		if(do_after(user, 50, target = src))
			if(R.get_amount() < 1)
				return
			user.visible_message(span_notice("[user] закрепляет рунический металл на балке.") , span_notice("Сооружаю руническую стену."))
			R.use(1)
			var/turf/T = get_turf(src)
			T.PlaceOnTop(/turf/closed/wall/mineral/cult)
			qdel(src)

	else
		return ..()

/obj/structure/girder/cult/narsie_act()
	return

/obj/structure/girder/cult/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/runed_metal(drop_location(), 1)
	qdel(src)

/obj/structure/girder/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_FLOORWALL)
			return rcd_result_with_memory(
				list("mode" = RCD_FLOORWALL, "delay" = 2 SECONDS, "cost" = 8),
				get_turf(src), RCD_MEMORY_WALL,
			)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 20, "cost" = 13)
	return FALSE

/obj/structure/girder/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	var/turf/T = get_turf(src)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, span_notice("Ремонтирую стену."))
			T.PlaceOnTop(/turf/closed/wall)
			qdel(src)
			return TRUE
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("Деконструирую балку."))
			qdel(src)
			return TRUE
	return FALSE

/obj/structure/girder/bronze
	name = "огромная шестерня"
	desc = "Балка, сделанная из прочной бронзы и напоминающая гигантскую шестеренку."
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "wall_gear"
	can_displace = FALSE

/obj/structure/girder/bronze/attackby(obj/item/W, mob/living/user, params)
	add_fingerprint(user)
	if(W.tool_behaviour == TOOL_WELDER)
		if(!W.tool_start_check(user, amount = 0))
			return
		to_chat(user, span_notice("Начинаю разрезать огромную шестерню..."))
		if(W.use_tool(src, user, 40, volume=50))
			to_chat(user, span_notice("Разрезаю огромную шестерню на части."))
			var/obj/item/stack/tile/bronze/B = new(drop_location(), 2)
			transfer_fingerprints_to(B)
			qdel(src)

	else if(istype(W, /obj/item/stack/tile/bronze))
		var/obj/item/stack/tile/bronze/B = W
		if(B.get_amount() < 2)
			to_chat(user, span_warning("Мне нужно по крайней мере два бронзовых листа, чтобы построить бронзовую стену!"))
			return
		user.visible_message(span_notice("[user] начинает закреплять бронзу на огромной шестерне...") , span_notice("Начинаю конструировать бронзовую стену..."))
		if(do_after(user, 50, target = src))
			if(B.get_amount() < 2)
				return
			user.visible_message(span_notice("[user] закрепляет бронзу на огромной шестерне!") , span_notice("Конструирую бронзовую стену."))
			B.use(2)
			var/turf/T = get_turf(src)
			T.PlaceOnTop(/turf/closed/wall/mineral/bronze)
			qdel(src)

	else
		return ..()
