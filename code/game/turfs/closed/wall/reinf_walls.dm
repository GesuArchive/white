/turf/closed/wall/r_wall
	name = "армированная стена"
	desc = "Здоровенный укреплённый кусок металла, который служит для разделения помещений."
	icon = DEFAULT_RWALL_ICON
	icon_state = "reinforced_wall-0"
	base_icon_state = "reinforced_wall"
	opacity = TRUE
	density = TRUE
	smoothing_flags = SMOOTH_BITMASK
	hardness = 5
	sheet_type = /obj/item/stack/sheet/plasteel
	sheet_amount = 1
	girder_type = /obj/structure/girder/reinforced
	explosion_block = 2
	rad_insulation = RAD_HEAVY_INSULATION
	///Dismantled state, related to deconstruction.
	var/d_state = INTACT
	var/d_time = 40


/turf/closed/wall/r_wall/deconstruction_hints(mob/user)
	switch(d_state)
		if(INTACT)
			return span_notice("Внешняя <b>решетка</b> цела.")
		if(SUPPORT_LINES)
			return span_notice("Внешняя <i>решетка</i> надкусана, теперь её можно <b>открутить</b>.")
		if(COVER)
			return span_notice("Поддерживающие линии <i>откручены</i>, металлическое покрытие <b>приварено</b> крепко.")
		if(CUT_COVER)
			return span_notice("Металлическое покрытие <i>проварено насквозь</i> и <b>болтается</b> на основании.")
		if(ANCHOR_BOLTS)
			return span_notice("Металлическое покрытие <i>снято</i>, а также болты всё ещё <b>прикручены</b> на месте.")
		if(SUPPORT_RODS)
			return span_notice("Болты удерживающие каркас <i>откручены</i>, но всё ещё <b>приварены</b> крепко к основанию.")
		if(SHEATH)
			return span_notice("Поддерживающие каркас болты <i>срезаны</i>, внутреннее покрытие <b>едва держится</b> на основании.")

/turf/closed/wall/r_wall/devastate_wall()
	new sheet_type(src, sheet_amount)
	new /obj/item/stack/sheet/iron(src, 2)

/turf/closed/wall/r_wall/attack_animal(mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	if(!M.environment_smash)
		return
	if(M.environment_smash & ENVIRONMENT_SMASH_RWALLS)
		dismantle_wall(1)
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
	else
		playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
		to_chat(M, span_warning("Эта стена слишком крепка для меня."))

/turf/closed/wall/r_wall/hulk_recoil(obj/item/bodypart/arm, mob/living/carbon/human/hulkman, damage = 41)
	return ..()

/turf/closed/wall/r_wall/try_decon(obj/item/W, mob/user, turf/T)
	//DECONSTRUCTION
	switch(d_state)
		if(INTACT)
			if(W.tool_behaviour == TOOL_WIRECUTTER)
				W.play_tool_sound(src, 100)
				d_state = SUPPORT_LINES
				update_icon()
				to_chat(user, span_notice("Откусываю внешнюю решетку."))
				return TRUE

		if(SUPPORT_LINES)
			if(W.tool_behaviour == TOOL_SCREWDRIVER)
				to_chat(user, span_notice("Начинаю откручивать поддерживающие линии..."))
				if(W.use_tool(src, user, d_time, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != SUPPORT_LINES)
						return TRUE
					d_state = COVER
					update_icon()
					to_chat(user, span_notice("Откручиваю поддерживающие линии."))
				return TRUE

			else if(W.tool_behaviour == TOOL_WIRECUTTER)
				W.play_tool_sound(src, 100)
				d_state = INTACT
				update_icon()
				to_chat(user, span_notice("Чиню внешнюю решетку."))
				return TRUE

		if(COVER)
			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=0))
					return
				to_chat(user, span_notice("Начинаю разваривать металлическое покрытие..."))
				if(W.use_tool(src, user, d_time * 1.5, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != COVER)
						return TRUE
					d_state = CUT_COVER
					update_icon()
					to_chat(user, span_notice("Слегка давлю на него и оно немного отходит от стены."))
				return TRUE

			if(W.tool_behaviour == TOOL_SCREWDRIVER)
				to_chat(user, span_notice("Начинаю прикручивать поддерживающие линии обратно..."))
				if(W.use_tool(src, user, d_time, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != COVER)
						return TRUE
					d_state = SUPPORT_LINES
					update_icon()
					to_chat(user, span_notice("Прикручиваю поддерживающие линии."))
				return TRUE

		if(CUT_COVER)
			if(W.tool_behaviour == TOOL_CROWBAR)
				to_chat(user, span_notice("Начинаю выдавливать покрытие..."))
				if(W.use_tool(src, user, d_time * 2.5, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != CUT_COVER)
						return TRUE
					d_state = ANCHOR_BOLTS
					update_icon()
					to_chat(user, span_notice("Выдавливаю покрытие."))
				return TRUE

			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=0))
					return
				to_chat(user, span_notice("Начинаю приваривать покрытие обратно на место..."))
				if(W.use_tool(src, user, d_time * 1.5, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != CUT_COVER)
						return TRUE
					d_state = COVER
					update_icon()
					to_chat(user, span_notice("Привариваю металлическое покрытие обратно на место."))
				return TRUE

		if(ANCHOR_BOLTS)
			if(W.tool_behaviour == TOOL_WRENCH)
				to_chat(user, span_notice("Начинаю откручивать болты удерживающие каркас..."))
				if(W.use_tool(src, user, d_time, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != ANCHOR_BOLTS)
						return TRUE
					d_state = SUPPORT_RODS
					update_icon()
					to_chat(user, span_notice("Откручиваю болты удерживающие каркас."))
				return TRUE

			if(W.tool_behaviour == TOOL_CROWBAR)
				to_chat(user, span_notice("Начинаю ставить покрытие обратно на место..."))
				if(W.use_tool(src, user, d_time * 0.5, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != ANCHOR_BOLTS)
						return TRUE
					d_state = CUT_COVER
					update_icon()
					to_chat(user, span_notice("Ставлю покрытие обратно на место."))
				return TRUE

		if(SUPPORT_RODS)
			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=0))
					return
				to_chat(user, span_notice("Начинаю разрезать поддерживающий каркас..."))
				if(W.use_tool(src, user, d_time * 2.5, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != SUPPORT_RODS)
						return TRUE
					d_state = SHEATH
					update_icon()
					to_chat(user, span_notice("Прорезаюсь через поддерживающий каркас."))
				return TRUE

			if(W.tool_behaviour == TOOL_WRENCH)
				to_chat(user, span_notice("Начинаю затягивать болты поддерживающие каркас..."))
				W.play_tool_sound(src, 100)
				if(W.use_tool(src, user, d_time))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != SUPPORT_RODS)
						return TRUE
					d_state = ANCHOR_BOLTS
					update_icon()
					to_chat(user, span_notice("Затягиваю болты поддерживающие каркас."))
				return TRUE

		if(SHEATH)
			if(W.tool_behaviour == TOOL_CROWBAR)
				to_chat(user, span_notice("Начинаю выдавливать каркас..."))
				if(W.use_tool(src, user, d_time * 2.5, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != SHEATH)
						return TRUE
					to_chat(user, span_notice("Выдавливаю каркас."))
					dismantle_wall()
				return TRUE

			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=0))
					return
				to_chat(user, span_notice("Начинаю сваривать поддерживающий каркас обратно..."))
				if(W.use_tool(src, user, d_time * 2.5, volume=100))
					if(!istype(src, /turf/closed/wall/r_wall) || d_state != SHEATH)
						return TRUE
					d_state = SUPPORT_RODS
					update_icon()
					to_chat(user, span_notice("Привариваю всё как было."))
				return TRUE
	return FALSE

/turf/closed/wall/r_wall/update_icon(updates=ALL)
	. = ..()
	if(d_state != INTACT)
		smoothing_flags = NONE
		return
	if (!(updates & UPDATE_SMOOTHING))
		return
	smoothing_flags = SMOOTH_BITMASK
	QUEUE_SMOOTH_NEIGHBORS(src)
	QUEUE_SMOOTH(src)

// We don't react to smoothing changing here because this else exists only to "revert" intact changes
/turf/closed/wall/r_wall/update_icon_state()
	if(d_state != INTACT)
		icon_state = "r_wall-[d_state]"
	else
		icon_state = "[base_icon_state]-[smoothing_junction]"
	return ..()

/turf/closed/wall/r_wall/wall_singularity_pull(current_size)
	if(current_size >= STAGE_FIVE)
		if(prob(30))
			dismantle_wall()

/turf/closed/wall/r_wall/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.canRturf)
		return ..()


/turf/closed/wall/r_wall/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	if(the_rcd.canRturf)
		return ..()

/turf/closed/wall/r_wall/rust_heretic_act()
	if(prob(50))
		return
	if(prob(70))
		new /obj/effect/temp_visual/glowing_rune(src)
	ChangeTurf(/turf/closed/wall/r_wall/rust)

// Пластитановая стена - стыкуемая + сглаживающаяся
/turf/closed/wall/r_wall/syndicate
	name = "пластитановая стена"
	desc = "Зловещая стена со пластитановым покрытием."
	icon = DEFAULT_PLASTITANUM_ICON
	icon_state = "plastitanium_wall-0"
	base_icon_state = "plastitanium_wall"
	explosion_block = 20
	sheet_type = /obj/item/stack/sheet/mineral/plastitanium
	girder_type = /obj/structure/girder/plastitanium
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SYNDICATE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SYNDICATE_WALLS, SMOOTH_GROUP_PLASTITANIUM_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTLE_PARTS, SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM)
	d_time = 60

/turf/closed/wall/r_wall/syndicate/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	return FALSE

/turf/closed/wall/r_wall/syndicate/rust_heretic_act()
	return // plastitanium does not rust

// Пластитановая стена - не сглаживающаяся
/turf/closed/wall/r_wall/syndicate/nodiagonal
	icon = DEFAULT_PLASTITANUM_ICON
	icon_state = "map-shuttle_nd"
	base_icon_state = "plastitanium_wall"
	smoothing_flags = SMOOTH_BITMASK

// Пластитановая стена - не стыкуемая
/turf/closed/wall/r_wall/syndicate/nosmooth
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall"
	smoothing_flags = NONE

/turf/closed/wall/r_wall/syndicate/overspace
	icon_state = "map-overspace"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
	fixed_underlay = list("space" = TRUE)
