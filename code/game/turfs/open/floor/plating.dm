/* In this file:
 *
 * Plating
 * Airless
 * Airless plating
 * Engine floor
 * Foam plating
 */

/turf/open/floor/plating
	name = "обшивка"
	icon_state = "plating"
	base_icon_state = "plating"
	intact = FALSE
	baseturfs = /turf/baseturf_bottom
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

	var/attachment_holes = TRUE

	/// If true, will allow tiles to replace us if the tile [wants to] [/obj/item/stack/tile/var/replace_plating].
	/// And if our baseturfs are compatible.
	/// See [/obj/item/stack/tile/proc/place_tile].
	var/allow_replacement = TRUE

/turf/open/floor/plating/Initialize(mapload)
	. = ..()
	if(mapload && icon_state == "plating")
		dir = pick(GLOB.alldirs)

/turf/open/floor/plating/setup_broken_states()
	return list("damaged1", "damaged2", "damaged4")

/turf/open/floor/plating/setup_burnt_states()
	return list("floorscorched1", "floorscorched2")

/turf/open/floor/plating/examine(mob/user)
	. = ..()
	. += "<hr>"
	if(broken || burnt)
		. += span_notice("Похоже, вмятины могут быть исправлены <i>сваркой</i>.")
		return
	if(attachment_holes)
		. += span_notice("Есть несколько отверстий для новых креплений <i>плитки</i> или <i>прутьев</i>.")
	else
		. += span_notice("Возможно, я смогу постелить на это <i>плитку</i>...")


/turf/open/floor/plating/attackby(obj/item/C, mob/user, params)
	if(..())
		return
	if(istype(C, /obj/item/stack/rods) && attachment_holes)
		if(broken || burnt)
			if(!iscyborg(user))
				to_chat(user, span_warning("Сначала отремонтировать покрытие бы! Тут хватит и сварки."))
			else
				to_chat(user, span_warning("Сначала отремонтировать покрытие бы! Тут хватит сварки или инструмента для ремонта покрытий.")) //we don't need to confuse humans by giving them a message about plating repair tools, since only janiborgs should have access to them outside of Christmas presents or admin intervention
			return
		var/obj/item/stack/rods/R = C
		if (R.get_amount() < 2)
			to_chat(user, span_warning("Нужно два стержня, чтобы сделать усиленную обшивку!"))
			return
		else
			to_chat(user, span_notice("Начинаю усиливать обшивку..."))
			if(do_after(user, 30, target = src))
				if (R.get_amount() >= 2 && !istype(src, /turf/open/floor/engine))
					PlaceOnTop(/turf/open/floor/engine, flags = CHANGETURF_INHERIT_AIR)
					playsound(src, 'sound/items/deconstruct.ogg', 80, TRUE)
					R.use(2)
					to_chat(user, span_notice("Усиливаю обшивку прутьями."))
				return
	else if(istype(C, /obj/item/stack/tile))
		if(!broken && !burnt)
			for(var/obj/O in src)
				for(var/M in O.buckled_mobs)
					to_chat(user, span_warning("Кто-то пристёгнут к <b>[O]</b>! Надо бы убрать [M]."))
					return
			var/obj/item/stack/tile/tile = C
			tile.place_tile(src, user)
			playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
		else
			if(!iscyborg(user))
				to_chat(user, span_warning("Эта секция слишком повреждена, чтобы выдержать плитку! Для устранения повреждений надо бы воспользоваться сварочным аппаратом."))
			else
				to_chat(user, span_warning("Эта секция слишком повреждена, чтобы выдержать плитку! Для устранения повреждений надо бы воспользоваться сварочным аппаратом или инструментом для ремонта покрытий."))
	else if(istype(C, /obj/item/cautery/prt)) //plating repair tool
		if((broken || burnt) && C.use_tool(src, user, 0, volume=80))
			to_chat(user, span_danger("Чиню покрытие."))
			icon_state = base_icon_state
			burnt = FALSE
			broken = FALSE


/turf/open/floor/plating/welder_act(mob/living/user, obj/item/I)
	..()
	if((broken || burnt) && I.use_tool(src, user, 0, volume=80))
		to_chat(user, span_danger("Исправляю вмятины на сломанном покрытии.."))
		icon_state = base_icon_state
		burnt = FALSE
		broken = FALSE

	return TRUE

/turf/open/floor/plating/rust_heretic_act()
	if(prob(70))
		new /obj/effect/temp_visual/glowing_rune(src)
	ChangeTurf(/turf/open/floor/plating/rust)

/turf/open/floor/plating/make_plating(force = FALSE)
	return

/turf/open/floor/plating/foam
	name = "металлопеническое покрытие"
	desc = "Тонкий, хрупкий пол, изготовленный из металлической пены."
	icon_state = "foam_plating"

/turf/open/floor/plating/foam/burn_tile()
	return //jetfuel can't melt steel foam

/turf/open/floor/plating/foam/break_tile()
	return //jetfuel can't break steel foam...

/turf/open/floor/plating/foam/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/tile/plasteel))
		var/obj/item/stack/tile/plasteel/P = I
		if(P.use(1))
			var/obj/L = locate(/obj/structure/lattice) in src
			if(L)
				qdel(L)
			to_chat(user, span_notice("Усиливаю вспененное покрытие плиткой."))
			playsound(src, 'sound/weapons/Genhit.ogg', 50, TRUE)
			ChangeTurf(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
	else
		playsound(src, 'sound/weapons/tap.ogg', 100, TRUE) //The attack sound is muffled by the foam itself
		user.changeNext_move(CLICK_CD_MELEE)
		user.do_attack_animation(src)
		if(prob(I.force * 20 - 25))
			user.visible_message(span_danger("[user] пробивается сквозь [src]!") , \
							span_danger("Пробиваюсь сквозь [src] используя [I]!"))
			ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		else
			to_chat(user, span_danger("Бью [src] и ничего не происходит!"))

/turf/open/floor/plating/foam/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_FLOORWALL)
		return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 1)

/turf/open/floor/plating/foam/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	if(passed_mode == RCD_FLOORWALL)
		to_chat(user, span_notice("Строю пол."))
		ChangeTurf(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
		return TRUE
	return FALSE

/turf/open/floor/plating/foam/ex_act()
	..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/plating/foam/tool_act(mob/living/user, obj/item/I, tool_type)
	return
