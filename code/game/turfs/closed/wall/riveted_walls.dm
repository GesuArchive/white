/turf/closed/wall/riveted_wall
	name = "проклепанная стена"
	desc = "Здоровенный укреплённый кусок металла со множеством заклепок, они придают поверхности дополнительную прочность и износостойкость."
	icon = DEFAULT_RIVWALL_ICON
	icon_state = "riveted_wall-0"
	base_icon_state = "riveted_wall"
	opacity = TRUE
	density = TRUE
	smoothing_flags = SMOOTH_BITMASK
	hardness = 10
	sheet_type = /obj/item/stack/sheet/riveted_metal
	sheet_amount = 1
	girder_type = /obj/structure/girder
	explosion_block = 2
	rad_insulation = RAD_HEAVY_INSULATION
	///Dismantled state, related to deconstruction.
	var/d_state = RIVET_FULL


/turf/closed/wall/riveted_wall/deconstruction_hints(mob/user)
	switch(d_state)
		if(RIVET_FULL)
			return span_notice("Заклепки <b>холодные</b> и надежно удерживают листы металла.")
		if(RIVET_HEAT)
			return span_notice("Заклепки <i>раскалены</i> и теперь их можно попытаться <b>вытащить</b>.")
		if(RIVET_BAR)
			return span_notice("Все заклепки <i>извлечены</i>, но металлическое покрытие все еще <b>приварено</b> накрепко.")

/turf/closed/wall/riveted_wall/devastate_wall()
	new sheet_type(src, sheet_amount)
	new /obj/item/stack/sheet/iron(src, 2)

/turf/closed/wall/riveted_wall/attack_animal(mob/living/simple_animal/M)
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

/turf/closed/wall/riveted_wall/hulk_recoil(obj/item/bodypart/arm, mob/living/carbon/human/hulkman, damage = 41)
	return ..()


/turf/closed/wall/riveted_wall/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/gun/energy/plasmacutter/adv/rangers))
		to_chat(user, span_notice("Начинаю прорезаться сквозь проклепанный металл..."))
		if(W.use_tool(src, user, 40, volume=100))
			to_chat(user, span_notice("Верхняя обшивка снята."))
			new /obj/item/stack/sheet/riveted_metal(user.drop_location())
			dismantle_wall()
			return
	else
		return ..()

/turf/closed/wall/riveted_wall/try_decon(obj/item/W, mob/user, turf/T)
	//DECONSTRUCTION
	switch(d_state)

		if(RIVET_FULL)
			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=0))
					return
				to_chat(user, span_notice("Начинаю раскалять заклепки..."))
				if(W.use_tool(src, user, 60, volume=100))
					if(!istype(src, /turf/closed/wall/riveted_wall) || d_state != RIVET_FULL)
						return TRUE
					d_state = RIVET_HEAT
					update_icon()
					to_chat(user, span_notice("Заклепки раскалены докрасна."))
				return TRUE

		if(RIVET_HEAT)
			if(W.tool_behaviour == TOOL_CROWBAR)
				to_chat(user, span_notice("Начинаю извлекать заклепки..."))
				if(W.use_tool(src, user, 100, volume=100))
					if(!istype(src, /turf/closed/wall/riveted_wall) || d_state != RIVET_HEAT)
						return TRUE
					d_state = RIVET_BAR
					update_icon()
					to_chat(user, span_notice("Заклепки выпадают на пол с легким звоном."))
					playsound(user, 'white/Feline/sounds/nail_drop.ogg', 100, TRUE)
				return TRUE

		if(RIVET_BAR)
			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=0))
					return
				to_chat(user, span_notice("Начинаю прорезать металическую обшивку..."))
				if(W.use_tool(src, user, 100, volume=100))
					if(!istype(src, /turf/closed/wall/riveted_wall) || d_state != RIVET_BAR)
						return TRUE
					dismantle_wall()
					to_chat(user, span_notice("Лист металла отходит от стены."))
				return TRUE
	return FALSE

/turf/closed/wall/riveted_wall/update_icon()
	. = ..()
	if(d_state != RIVET_FULL)
		smoothing_flags = NONE
	else
		smoothing_flags = SMOOTH_BITMASK
		QUEUE_SMOOTH_NEIGHBORS(src)
		QUEUE_SMOOTH(src)

/turf/closed/wall/riveted_wall/update_icon_state()
	. = ..()
	if(d_state != RIVET_FULL)
		icon_state = "riv_wall-[d_state]"
	else
		icon_state = "[base_icon_state]-[smoothing_junction]"

/turf/closed/wall/riveted_wall/wall_singularity_pull(current_size)
	if(current_size >= STAGE_FIVE)
		if(prob(30))
			dismantle_wall()

/turf/closed/wall/riveted_wall/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.canRturf)
		return ..()


/turf/closed/wall/riveted_wall/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	if(the_rcd.canRturf)
		return ..()

/turf/closed/wall/riveted_wall/rust_heretic_act()
	if(prob(50))
		return
	if(prob(70))
		new /obj/effect/temp_visual/glowing_rune(src)
	ChangeTurf(/turf/closed/wall/riveted_wall/rust)

/turf/closed/wall/riveted_wall/rust
	color = COLOR_ORANGE_BROWN
