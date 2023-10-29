/obj/item/stack/tile
	name = "сломанная плитка"
	singular_name = "broken tile"
	desc = "Сломанная плитка. Её не должно быть."
	lefthand_file = 'icons/mob/inhands/misc/tiles_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/tiles_righthand.dmi'
	icon = 'icons/obj/tiles.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 1
	throwforce = 1
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	novariants = TRUE
	/// What type of turf does this tile produce.
	var/turf_type = null
	/// Determines certain welder interactions.
	var/mineralType = null
	/// What dir will the turf have?
	var/turf_dir = SOUTH
	/// Cached associative lazy list to hold the radial options for tile reskinning. See tile_reskinning.dm for more information. Pattern: list[type] -> image
	var/list/tile_reskin_types
	/// Cached associative lazy list to hold the radial options for tile dirs. See tile_reskinning.dm for more information.
	var/list/tile_rotate_dirs
	/// Allows us to replace the plating we are attacking if our baseturfs are the same.
	var/replace_plating = FALSE


/obj/item/stack/tile/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = rand(-3, 3)
	pixel_y = rand(-3, 3) //randomize a little
	if(tile_reskin_types)
		tile_reskin_types = tile_reskin_list(tile_reskin_types)
	if(tile_rotate_dirs)
		var/list/values = list()
		for(var/set_dir in tile_rotate_dirs)
			values += dir2text(set_dir)
		tile_rotate_dirs = tile_dir_list(values, turf_type)

/obj/item/stack/tile/examine(mob/user)
	. = ..()
	. += "<hr>"
	if(throwforce && !is_cyborg) //do not want to divide by zero or show the message to borgs who can't throw
		var/verb
		switch(CEILING(MAX_LIVING_HEALTH / throwforce, 1)) //throws to crit a human
			if(1 to 3)
				verb = "идеальное"
			if(4 to 6)
				verb = "великолепное"
			if(7 to 9)
				verb = "крутое"
			if(10 to 12)
				verb = "обычное"
			if(13 to 15)
				verb = "плохое"
		if(!verb)
			return
		. += span_notice("Они могут работать как [verb] метательное оружие.")


/obj/item/stack/tile/attackby(obj/item/W, mob/user, params)

	if (W.tool_behaviour == TOOL_WELDER)
		if(get_amount() < 4)
			to_chat(user, span_warning("Мне нужно минимум четыре плитки для этого!"))
			return

		if(!mineralType)
			to_chat(user, span_warning("Не могу исправить это!"))
			return

		if(W.use_tool(src, user, 0, volume=40))
			if(mineralType == "plasma")
				atmos_spawn_air("plasma=5;TEMP=1000")
				user.visible_message(span_warning("[user.name] поджигает плазменные плитки!") , \
									span_warning("Поджигаю плазменные плитки!"))
				qdel(src)
				return

			if (mineralType == "iron")
				var/obj/item/stack/sheet/iron/new_item = new(user.loc)
				user.visible_message(span_notice("[user.name] переплавляет [src] в железо с помощью сварочного аппарата.") , \
					span_notice("Переплавляю [src] в металл с помощью сварочного аппарата.") , \
					span_hear("Слышу сварку."))
				var/obj/item/stack/rods/R = src
				src = null
				var/replace = (user.get_inactive_held_item()==R)
				R.use(4)
				if (!R && replace)
					user.put_in_hands(new_item)

			else
				var/sheet_type = text2path("/obj/item/stack/sheet/mineral/[mineralType]")
				var/obj/item/stack/sheet/mineral/new_item = new sheet_type(user.loc)
				user.visible_message(span_notice("[user.name] переплавляет [src] в листы метала с помощью сварочного аппарата.") , \
					span_notice("Переплавляю [src] в листы металла с помощью сварочного аппарата.") , \
					span_hear("Слышу сварку."))
				var/obj/item/stack/rods/R = src
				src = null
				var/replace = (user.get_inactive_held_item()==R)
				R.use(4)
				if (!R && replace)
					user.put_in_hands(new_item)
	else
		return ..()

/**
 * Place our tile on a plating, or replace it.
 *
 * Arguments:
 * * target_plating - Instance of the plating we want to place on. Replaced during sucessful executions.
 * * user - The mob doing the placing.
 */
/obj/item/stack/tile/proc/place_tile(turf/open/floor/plating/target_plating, mob/user)
	var/turf/placed_turf_path = turf_type
	if(!ispath(placed_turf_path))
		return
	if(!istype(target_plating))
		return

	if(!replace_plating)
		if(!use(1))
			return
		target_plating = target_plating.PlaceOnTop(placed_turf_path, flags = CHANGETURF_INHERIT_AIR)
		target_plating.setDir(turf_dir)
		playsound(target_plating, 'sound/weapons/genhit.ogg', 50, TRUE)
		return target_plating // Most executions should end here.

	// If we and the target tile share the same initial baseturf and they consent, replace em.
	if(!target_plating.allow_replacement || initial(target_plating.baseturfs) != initial(placed_turf_path.baseturfs))
		to_chat(user, span_notice("You cannot place this tile here directly!"))
		return
	to_chat(user, span_notice("You begin replacing the floor with the tile..."))
	if(!do_after(user, 3 SECONDS, target_plating))
		return
	if(!istype(target_plating))
		return
	if(!use(1))
		return

	target_plating = target_plating.ChangeTurf(placed_turf_path, target_plating.baseturfs, CHANGETURF_INHERIT_AIR)
	target_plating.setDir(turf_dir)
	playsound(target_plating, 'sound/weapons/genhit.ogg', 50, TRUE)
	return target_plating

//Grass
/obj/item/stack/tile/grass
	name = "травяная плитка"
	singular_name = "grass floor tile"
	desc = "Клочок травы, прямо как на полях для космического гольфа.."
	icon_state = "tile_grass"
	inhand_icon_state = "tile-grass"
	turf_type = /turf/open/floor/grass
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/grass

//Fairygrass
/obj/item/stack/tile/fairygrass
	name = "Плитка из сказочной травы"
	singular_name = "fairygrass floor tile"
	desc = "Клок странной светящейся голубой травы."
	icon_state = "tile_fairygrass"
	inhand_icon_state = "tile-fairygrass"
	turf_type = /turf/open/floor/grass/fairy
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fairygrass

//Wood
/obj/item/stack/tile/wood
	name = "деревянная напольная плитка"
	singular_name = "wood floor tile"
	desc = "Легко укладываемая деревянная напольная плитка. Используй в руке для изменения шаблона."
	icon_state = "tile-wood"
	inhand_icon_state = "tile-wood"
	turf_type = /turf/open/floor/wood
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/wood
	tile_reskin_types = list(
		/obj/item/stack/tile/wood,
		/obj/item/stack/tile/wood/large,
		/obj/item/stack/tile/wood/tile,
		/obj/item/stack/tile/wood/parquet,
	)

/obj/item/stack/tile/wood/parquet
	name = "parquet wood floor tile"
	singular_name = "parquet wood floor tile"
	icon_state = "tile-wood_parquet"
	turf_type = /turf/open/floor/wood/parquet
	merge_type = /obj/item/stack/tile/wood/parquet

/obj/item/stack/tile/wood/large
	name = "large wood floor tile"
	singular_name = "large wood floor tile"
	icon_state = "tile-wood_large"
	turf_type = /turf/open/floor/wood/large
	merge_type = /obj/item/stack/tile/wood/large

/obj/item/stack/tile/wood/tile
	name = "tiled wood floor tile"
	singular_name = "tiled wood floor tile"
	icon_state = "tile-wood_tile"
	turf_type = /turf/open/floor/wood/tile
	merge_type = /obj/item/stack/tile/wood/tile

//Bamboo
/obj/item/stack/tile/bamboo
	name = "bamboo mat pieces"
	singular_name = "bamboo mat piece"
	desc = "A piece of a bamboo mat with a decorative trim."
	icon_state = "tile_bamboo"
	turf_type = /turf/open/floor/bamboo
	merge_type = /obj/item/stack/tile/bamboo
	resistance_flags = FLAMMABLE

//Basalt
/obj/item/stack/tile/basalt
	name = "базальтовая плитка"
	singular_name = "basalt floor tile"
	desc = "Искусственно созданный пепельный грунт будто из враждебных мест."
	icon_state = "tile_basalt"
	inhand_icon_state = "tile-basalt"
	turf_type = /turf/open/floor/grass/fakebasalt
	merge_type = /obj/item/stack/tile/basalt

//Carpets
/obj/item/stack/tile/carpet
	name = "ковер"
	singular_name = "carpet tile"
	desc = "Кусок ковра. Он такого же размера, как напольная плитка."
	icon_state = "tile-carpet"
	inhand_icon_state = "tile-carpet"
	turf_type = /turf/open/floor/carpet
	resistance_flags = FLAMMABLE
	tableVariant = /obj/structure/table/wood/fancy
	merge_type = /obj/item/stack/tile/carpet

/obj/item/stack/tile/carpet/black
	name = "чёрный carpet"
	icon_state = "tile-carpet-black"
	inhand_icon_state = "tile-carpet-black"
	turf_type = /turf/open/floor/carpet/black
	tableVariant = /obj/structure/table/wood/fancy/black
	merge_type = /obj/item/stack/tile/carpet/black

/obj/item/stack/tile/carpet/blue
	name = "синий carpet"
	icon_state = "tile-carpet-blue"
	inhand_icon_state = "tile-carpet-blue"
	turf_type = /turf/open/floor/carpet/blue
	tableVariant = /obj/structure/table/wood/fancy/blue
	merge_type = /obj/item/stack/tile/carpet/blue

/obj/item/stack/tile/carpet/cyan
	name = "голубой carpet"
	icon_state = "tile-carpet-cyan"
	inhand_icon_state = "tile-carpet-cyan"
	turf_type = /turf/open/floor/carpet/cyan
	tableVariant = /obj/structure/table/wood/fancy/cyan
	merge_type = /obj/item/stack/tile/carpet/cyan

/obj/item/stack/tile/carpet/green
	name = "зелёный carpet"
	icon_state = "tile-carpet-green"
	inhand_icon_state = "tile-carpet-green"
	turf_type = /turf/open/floor/carpet/green
	tableVariant = /obj/structure/table/wood/fancy/green
	merge_type = /obj/item/stack/tile/carpet/green

/obj/item/stack/tile/carpet/orange
	name = "оранжевый  carpet"
	icon_state = "tile-carpet-orange"
	inhand_icon_state = "tile-carpet-orange"
	turf_type = /turf/open/floor/carpet/orange
	tableVariant = /obj/structure/table/wood/fancy/orange
	merge_type = /obj/item/stack/tile/carpet/orange

/obj/item/stack/tile/carpet/purple
	name = "фиолетовый carpet"
	icon_state = "tile-carpet-purple"
	inhand_icon_state = "tile-carpet-purple"
	turf_type = /turf/open/floor/carpet/purple
	tableVariant = /obj/structure/table/wood/fancy/purple
	merge_type = /obj/item/stack/tile/carpet/purple

/obj/item/stack/tile/carpet/red
	name = "красный carpet"
	icon_state = "tile-carpet-red"
	inhand_icon_state = "tile-carpet-red"
	turf_type = /turf/open/floor/carpet/red
	tableVariant = /obj/structure/table/wood/fancy/red
	merge_type = /obj/item/stack/tile/carpet/red

/obj/item/stack/tile/carpet/royalblack
	name = "чёрный королевский ковер"
	icon_state = "tile-carpet-royalblack"
	inhand_icon_state = "tile-carpet-royalblack"
	turf_type = /turf/open/floor/carpet/royalblack
	tableVariant = /obj/structure/table/wood/fancy/royalblack
	merge_type = /obj/item/stack/tile/carpet/royalblack

/obj/item/stack/tile/carpet/royalblue
	name = "синий королевский ковер"
	icon_state = "tile-carpet-royalblue"
	inhand_icon_state = "tile-carpet-royalblue"
	turf_type = /turf/open/floor/carpet/royalblue
	tableVariant = /obj/structure/table/wood/fancy/royalblue
	merge_type = /obj/item/stack/tile/carpet/royalblue

/obj/item/stack/tile/carpet/executive
	name = "ковер администрации"
	icon_state = "tile_carpet_executive"
	inhand_icon_state = "tile-carpet-royalblue"
	turf_type = /turf/open/floor/carpet/executive
	merge_type = /obj/item/stack/tile/carpet/executive

/obj/item/stack/tile/carpet/stellar
	name = "звездный ковер"
	icon_state = "tile_carpet_stellar"
	inhand_icon_state = "tile-carpet-royalblue"
	turf_type = /turf/open/floor/carpet/stellar
	merge_type = /obj/item/stack/tile/carpet/stellar

/obj/item/stack/tile/carpet/donk
	name = "рекламный ковер donk co"
	icon_state = "tile_carpet_donk"
	inhand_icon_state = "tile-carpet-orange"
	turf_type = /turf/open/floor/carpet/donk
	merge_type = /obj/item/stack/tile/carpet/donk

/obj/item/stack/tile/carpet/fifty
	amount = 50

/obj/item/stack/tile/carpet/black/fifty
	amount = 50

/obj/item/stack/tile/carpet/blue/fifty
	amount = 50

/obj/item/stack/tile/carpet/cyan/fifty
	amount = 50

/obj/item/stack/tile/carpet/green/fifty
	amount = 50

/obj/item/stack/tile/carpet/orange/fifty
	amount = 50

/obj/item/stack/tile/carpet/purple/fifty
	amount = 50

/obj/item/stack/tile/carpet/red/fifty
	amount = 50

/obj/item/stack/tile/carpet/royalblack/fifty
	amount = 50

/obj/item/stack/tile/carpet/royalblue/fifty
	amount = 50

/obj/item/stack/tile/carpet/executive/thirty
	amount = 30

/obj/item/stack/tile/carpet/stellar/thirty
	amount = 30

/obj/item/stack/tile/carpet/donk/thirty
	amount = 30

/obj/item/stack/tile/fakespace
	name = "астральный ковер"
	singular_name = "astral carpet tile"
	desc = "Кусок ковра с звездным узором."
	icon_state = "tile_space"
	inhand_icon_state = "tile-space"
	turf_type = /turf/open/floor/fakespace
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fakespace

/obj/item/stack/tile/fakespace/loaded
	amount = 30

/obj/item/stack/tile/fakepit
	name = "поддельные ямы"
	singular_name = "fake pit"
	desc = "Кусок ковра с нарисованной ямой. Этим никого не обмануть!"
	icon_state = "tile_pit"
	inhand_icon_state = "tile-basalt"
	turf_type = /turf/open/floor/fakepit
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fakepit

/obj/item/stack/tile/fakepit/loaded
	amount = 30

//High-traction
/obj/item/stack/tile/noslip
	name = "противоскользящая напольная плитка"
	desc = "Благодаря хорошему сцеплению с поверхностью на этой плитке невозможно подскользнуться. Так же незначительно повышает скорость перемещения. На ощупь кажется немного резиновой."
	singular_name = "high-traction floor tile"
	icon_state = "tile_noslip"
	inhand_icon_state = "tile-noslip"
	turf_type = /turf/open/floor/noslip
	merge_type = /obj/item/stack/tile/noslip

/obj/item/stack/tile/noslip/thirty
	amount = 30
/obj/item/stack/tile/noslip/fifty
	amount = 50

//Circuit
/obj/item/stack/tile/circuit
	name = "синяя электронная плитка"
	singular_name = "синий circuit tile"
	desc = "A blue circuit tile."
	icon_state = "tile_bcircuit"
	inhand_icon_state = "tile-bcircuit"
	turf_type = /turf/open/floor/circuit
	merge_type = /obj/item/stack/tile/circuit

/obj/item/stack/tile/circuit/green
	name = "зелёная электронная плитка"
	singular_name = "зелёный circuit tile"
	desc = "A green circuit tile."
	icon_state = "tile_gcircuit"
	inhand_icon_state = "tile-gcircuit"
	turf_type = /turf/open/floor/circuit/green
	merge_type = /obj/item/stack/tile/circuit/green

/obj/item/stack/tile/circuit/green/anim
	turf_type = /turf/open/floor/circuit/green/anim
	merge_type = /obj/item/stack/tile/circuit/green/anim

/obj/item/stack/tile/circuit/red
	name = "красная электронная плитка"
	singular_name = "красная электронная плитка"
	desc = "Красная плитка схем."
	icon_state = "tile_rcircuit"
	inhand_icon_state = "tile-rcircuit"
	turf_type = /turf/open/floor/circuit/red
	merge_type = /obj/item/stack/tile/circuit/red

/obj/item/stack/tile/circuit/red/anim
	turf_type = /turf/open/floor/circuit/red/anim
	merge_type = /obj/item/stack/tile/circuit/red/anim

//Pod floor
/obj/item/stack/tile/pod
	name = "плитка капсулы"
	singular_name = "pod floor tile"
	desc = "Рифленая напольная плитка."
	icon_state = "tile_pod"
	inhand_icon_state = "tile-pod"
	turf_type = /turf/open/floor/pod
	merge_type = /obj/item/stack/tile/pod

/obj/item/stack/tile/pod/light
	name = "светлая плитка капсулы"
	singular_name = "light pod floor tile"
	desc = "Рифленая напольная плитка светлого цвета."
	icon_state = "tile_podlight"
	turf_type = /turf/open/floor/pod/light
	merge_type = /obj/item/stack/tile/pod/light

/obj/item/stack/tile/pod/dark
	name = "тёмная плитка капсулы"
	singular_name = "dark pod floor tile"
	desc = "Рифленая напольная плитка темного цвета."
	icon_state = "tile_poddark"
	turf_type = /turf/open/floor/pod/dark
	merge_type = /obj/item/stack/tile/pod/dark

//Plasteel (normal)
/obj/item/stack/tile/plasteel
	name = "плитка пола"
	singular_name = "floor tile"
	desc = "Поверхность по которой ты ходишь."
	icon_state = "tile"
	inhand_icon_state = "tile"
	force = 6
	mats_per_unit = list(/datum/material/iron=500)
	throwforce = 10
	flags_1 = CONDUCT_1
	turf_type = /turf/open/floor/plasteel
	mineralType = "iron"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 70)
	resistance_flags = FIRE_PROOF
	matter_amount = 1
	cost = 125
	source = /datum/robot_energy_storage/iron
	merge_type = /obj/item/stack/tile/plasteel
	tile_reskin_types = list(
		/obj/item/stack/tile/plasteel,
		/obj/item/stack/tile/plasteel/edge,
		/obj/item/stack/tile/plasteel/half,
		/obj/item/stack/tile/plasteel/corner,
		/obj/item/stack/tile/plasteel/large,
		/obj/item/stack/tile/plasteel/small,
		/obj/item/stack/tile/plasteel/diagonal,
		/obj/item/stack/tile/plasteel/herringbone,
		/obj/item/stack/tile/plasteel/textured,
		/obj/item/stack/tile/plasteel/textured_edge,
		/obj/item/stack/tile/plasteel/textured_half,
		/obj/item/stack/tile/plasteel/textured_corner,
		/obj/item/stack/tile/plasteel/textured_large,
		/obj/item/stack/tile/plasteel/dark,
		/obj/item/stack/tile/plasteel/dark/smooth_edge,
		/obj/item/stack/tile/plasteel/dark/smooth_half,
		/obj/item/stack/tile/plasteel/dark/smooth_corner,
		/obj/item/stack/tile/plasteel/dark/smooth_large,
		/obj/item/stack/tile/plasteel/dark/small,
		/obj/item/stack/tile/plasteel/dark/diagonal,
		/obj/item/stack/tile/plasteel/dark/herringbone,
		/obj/item/stack/tile/plasteel/dark_side,
		/obj/item/stack/tile/plasteel/dark_corner,
		/obj/item/stack/tile/plasteel/checker,
		/obj/item/stack/tile/plasteel/dark/textured,
		/obj/item/stack/tile/plasteel/dark/textured_edge,
		/obj/item/stack/tile/plasteel/dark/textured_half,
		/obj/item/stack/tile/plasteel/dark/textured_corner,
		/obj/item/stack/tile/plasteel/dark/textured_large,
		/obj/item/stack/tile/plasteel/white,
		/obj/item/stack/tile/plasteel/white/smooth_edge,
		/obj/item/stack/tile/plasteel/white/smooth_half,
		/obj/item/stack/tile/plasteel/white/smooth_corner,
		/obj/item/stack/tile/plasteel/white/smooth_large,
		/obj/item/stack/tile/plasteel/white/small,
		/obj/item/stack/tile/plasteel/white/diagonal,
		/obj/item/stack/tile/plasteel/white/herringbone,
		/obj/item/stack/tile/plasteel/white_side,
		/obj/item/stack/tile/plasteel/white_corner,
		/obj/item/stack/tile/plasteel/cafeteria,
		/obj/item/stack/tile/plasteel/white/textured,
		/obj/item/stack/tile/plasteel/white/textured_edge,
		/obj/item/stack/tile/plasteel/white/textured_half,
		/obj/item/stack/tile/plasteel/white/textured_corner,
		/obj/item/stack/tile/plasteel/white/textured_large,
		/obj/item/stack/tile/plasteel/smooth,
		/obj/item/stack/tile/plasteel/smooth_edge,
		/obj/item/stack/tile/plasteel/smooth_half,
		/obj/item/stack/tile/plasteel/smooth_corner,
		/obj/item/stack/tile/plasteel/smooth_large,
		/obj/item/stack/tile/plasteel/terracotta,
		/obj/item/stack/tile/plasteel/terracotta/small,
		/obj/item/stack/tile/plasteel/terracotta/diagonal,
		/obj/item/stack/tile/plasteel/terracotta/herringbone,
		/obj/item/stack/tile/plasteel/kitchen,
		/obj/item/stack/tile/plasteel/kitchen/small,
		/obj/item/stack/tile/plasteel/kitchen/diagonal,
		/obj/item/stack/tile/plasteel/kitchen/herringbone,
		/obj/item/stack/tile/plasteel/chapel,
		/obj/item/stack/tile/plasteel/showroomfloor,
		/obj/item/stack/tile/plasteel/freezer,
		/obj/item/stack/tile/plasteel/sepia,
	)

/obj/item/stack/tile/plastic
	name = "пластиковая плитка"
	singular_name = "plastic floor tile"
	desc = "Плитка из дешевого хлипкого пластика."
	icon_state = "tile_plastic"
	mats_per_unit = list(/datum/material/plastic=500)
	turf_type = /turf/open/floor/plastic
	merge_type = /obj/item/stack/tile/plastic

/obj/item/stack/tile/material
	name = "плитка пола"
	singular_name = "floor tile"
	desc = "Поверхность по которой ты ходишь."
	throwforce = 10
	icon_state = "material_tile"
	turf_type = /turf/open/floor/material
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	merge_type = /obj/item/stack/tile/material

/obj/item/stack/tile/material/place_tile(turf/open/T)
	. = ..()
	var/turf/open/floor/material/F = .
	F?.set_custom_materials(mats_per_unit)

/obj/item/stack/tile/eighties
	name = "ретро-плитка"
	singular_name = "ретро-плитка"
	desc = "Стопка напольной плитки, напоминающая эпоху фанка. Используй в руке для изменения шаблона."
	icon_state = "tile_eighties"
	turf_type = /turf/open/floor/eighties
	merge_type = /obj/item/stack/tile/eighties
	tile_reskin_types = list(
		/obj/item/stack/tile/eighties,
		/obj/item/stack/tile/eighties/red,
	)

/obj/item/stack/tile/eighties/loaded
	amount = 15

/obj/item/stack/tile/eighties/red
	name = "красная ретро-плитка"
	singular_name = "красная ретро-плитка"
	desc = "A stack of REDICAL floor tiles! Use in your hand to pick between a black or red pattern!" //i am so sorry
	icon_state = "tile_eightiesred"
	turf_type = /turf/open/floor/eighties/red
	merge_type = /obj/item/stack/tile/eighties/red

/obj/item/stack/tile/catwalk_tile
	name = "помостовый пол"
	singular_name = "помостовый пол"
	desc = "Сквозь него можно смотреть на другой пол. Чудесно."
	icon_state = "catwalk_floor"
	inhand_icon_state = "tile-catwalk"
	turf_type = /turf/open/floor/plasteel/catwalk_floor
	merge_type = /obj/item/stack/tile/catwalk_tile

/obj/item/stack/tile/catwalk_tile/fifty
	amount = 50

// Glass floors
/obj/item/stack/tile/glass
	name = "стеклянный пол"
	singular_name = "стеклянный пол"
	desc = "Какой мудак это придумал?"
	icon_state = "tile_glass"
	turf_type = /turf/open/floor/glass
	inhand_icon_state = "tile-glass"
	merge_type = /obj/item/stack/tile/glass
	mats_per_unit = list(/datum/material/glass = MINERAL_MATERIAL_AMOUNT * 0.25) // 4 tiles per sheet

/obj/item/stack/tile/glass/fifty
	amount = 50

/obj/item/stack/tile/rglass
	name = "армированный стеклянный пол"
	singular_name = "армированный стеклянный пол"
	desc = "Вот это уже другое дело!"
	icon_state = "tile_rglass"
	inhand_icon_state = "tile-rglass"
	turf_type = /turf/open/floor/glass/reinforced
	merge_type = /obj/item/stack/tile/rglass
	mats_per_unit = list(/datum/material/iron = MINERAL_MATERIAL_AMOUNT * 0.125, /datum/material/glass = MINERAL_MATERIAL_AMOUNT * 0.25) // 4 tiles per sheet

/obj/item/stack/tile/rglass/fifty
	amount = 50

/obj/item/stack/tile/plasteel/base //this subtype should be used for most stuff
	merge_type = /obj/item/stack/tile/plasteel/base

/obj/item/stack/tile/plasteel/base/cyborg //cant reskin these, fucks with borg code
	merge_type = /obj/item/stack/tile/plasteel/base/cyborg
	tile_reskin_types = null

/obj/item/stack/tile/plasteel/edge
	name = "edge tile"
	singular_name = "edge floor tile"
	icon_state = "tile_edge"
	turf_type = /turf/open/floor/plasteel/tg/edge
	merge_type = /obj/item/stack/tile/plasteel/edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/half
	name = "half tile"
	singular_name = "half floor tile"
	icon_state = "tile_half"
	turf_type = /turf/open/floor/plasteel/tg/half
	merge_type = /obj/item/stack/tile/plasteel/half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/plasteel/corner
	name = "corner tile"
	singular_name = "corner floor tile"
	icon_state = "tile_corner"
	turf_type = /turf/open/floor/plasteel/tg/corner
	merge_type = /obj/item/stack/tile/plasteel/corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/large
	name = "large tile"
	singular_name = "large floor tile"
	icon_state = "tile_large"
	turf_type = /turf/open/floor/plasteel/tg/large
	merge_type = /obj/item/stack/tile/plasteel/large

/obj/item/stack/tile/plasteel/textured
	name = "textured tile"
	singular_name = "textured floor tile"
	icon_state = "tile_textured"
	turf_type = /turf/open/floor/plasteel/tg/textured
	merge_type = /obj/item/stack/tile/plasteel/textured

/obj/item/stack/tile/plasteel/textured_edge
	name = "textured edge tile"
	singular_name = "edged textured floor tile"
	icon_state = "tile_textured_edge"
	turf_type = /turf/open/floor/plasteel/tg/textured_edge
	merge_type = /obj/item/stack/tile/plasteel/textured_edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/textured_half
	name = "textured half tile"
	singular_name = "halved textured floor tile"
	icon_state = "tile_textured_half"
	turf_type = /turf/open/floor/plasteel/tg/textured_half
	merge_type = /obj/item/stack/tile/plasteel/textured_half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/plasteel/textured_corner
	name = "textured corner tile"
	singular_name = "cornered textured floor tile"
	icon_state = "tile_textured_corner"
	turf_type = /turf/open/floor/plasteel/tg/textured_corner
	merge_type = /obj/item/stack/tile/plasteel/textured_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/textured_large
	name = "textured large tile"
	singular_name = "large textured floor tile"
	icon_state = "tile_textured_large"
	turf_type = /turf/open/floor/plasteel/tg/textured_large
	merge_type = /obj/item/stack/tile/plasteel/textured_large

/obj/item/stack/tile/plasteel/small
	name = "small tile"
	singular_name = "small floor tile"
	icon_state = "tile_small"
	turf_type = /turf/open/floor/plasteel/tg/small
	merge_type = /obj/item/stack/tile/plasteel/small

/obj/item/stack/tile/plasteel/diagonal
	name = "diagonal tile"
	singular_name = "diagonal floor tile"
	icon_state = "tile_diagonal"
	turf_type = /turf/open/floor/plasteel/tg/diagonal
	merge_type = /obj/item/stack/tile/plasteel/diagonal

/obj/item/stack/tile/plasteel/herringbone
	name = "herringbone tile"
	singular_name = "herringbone floor tile"
	icon_state = "tile_herringbone"
	turf_type = /turf/open/floor/plasteel/tg/herringbone
	merge_type = /obj/item/stack/tile/plasteel/herringbone

/obj/item/stack/tile/plasteel/dark
	name = "dark tile"
	singular_name = "dark floor tile"
	icon_state = "tile_dark"
	turf_type = /turf/open/floor/plasteel/tg/dark
	merge_type = /obj/item/stack/tile/plasteel/dark

/obj/item/stack/tile/plasteel/dark/smooth_edge
	name = "dark edge tile"
	singular_name = "edged dark floor tile"
	icon_state = "tile_dark_edge"
	turf_type = /turf/open/floor/plasteel/tg/dark/smooth_edge
	merge_type = /obj/item/stack/tile/plasteel/dark/smooth_edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/dark/smooth_half
	name = "dark half tile"
	singular_name = "halved dark floor tile"
	icon_state = "tile_dark_half"
	turf_type = /turf/open/floor/plasteel/tg/dark/smooth_half
	merge_type = /obj/item/stack/tile/plasteel/dark/smooth_half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/plasteel/dark/smooth_corner
	name = "dark corner tile"
	singular_name = "cornered dark floor tile"
	icon_state = "tile_dark_corner"
	turf_type = /turf/open/floor/plasteel/tg/dark/smooth_corner
	merge_type = /obj/item/stack/tile/plasteel/dark/smooth_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/dark/smooth_large
	name = "dark large tile"
	singular_name = "large dark floor tile"
	icon_state = "tile_dark_large"
	turf_type = /turf/open/floor/plasteel/tg/dark/smooth_large
	merge_type = /obj/item/stack/tile/plasteel/dark/smooth_large

/obj/item/stack/tile/plasteel/dark_side
	name = "half dark tile"
	singular_name = "half dark floor tile"
	icon_state = "tile_darkside"
	turf_type = /turf/open/floor/plasteel/tg/dark/side
	merge_type = /obj/item/stack/tile/plasteel/dark_side
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)

/obj/item/stack/tile/plasteel/dark_corner
	name = "quarter dark tile"
	singular_name = "quarter dark floor tile"
	icon_state = "tile_darkcorner"
	turf_type = /turf/open/floor/plasteel/tg/dark/corner
	merge_type = /obj/item/stack/tile/plasteel/dark_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/checker
	name = "checker tile"
	singular_name = "checker floor tile"
	icon_state = "tile_checker"
	turf_type = /turf/open/floor/plasteel/tg/checker
	merge_type = /obj/item/stack/tile/plasteel/checker
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/plasteel/dark/textured
	name = "dark textured tile"
	singular_name = "dark textured floor tile"
	icon_state = "tile_textured_dark"
	turf_type = /turf/open/floor/plasteel/tg/dark/textured
	merge_type = /obj/item/stack/tile/plasteel/dark/textured

/obj/item/stack/tile/plasteel/dark/textured_edge
	name = "dark textured edge tile"
	singular_name = "edged dark textured floor tile"
	icon_state = "tile_textured_dark_edge"
	turf_type = /turf/open/floor/plasteel/tg/dark/textured_edge
	merge_type = /obj/item/stack/tile/plasteel/dark/textured_edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/dark/textured_half
	name = "dark textured half tile"
	singular_name = "halved dark textured floor tile"
	icon_state = "tile_textured_dark_half"
	turf_type = /turf/open/floor/plasteel/tg/dark/textured_half
	merge_type = /obj/item/stack/tile/plasteel/dark/textured_half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/plasteel/dark/textured_corner
	name = "dark textured corner tile"
	singular_name = "cornered dark textured floor tile"
	icon_state = "tile_textured_dark_corner"
	turf_type = /turf/open/floor/plasteel/tg/dark/textured_corner
	merge_type = /obj/item/stack/tile/plasteel/dark/textured_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/dark/textured_large
	name = "dark textured large tile"
	singular_name = "large dark textured floor tile"
	icon_state = "tile_textured_dark_large"
	turf_type = /turf/open/floor/plasteel/tg/dark/textured_large
	merge_type = /obj/item/stack/tile/plasteel/dark/textured_large

/obj/item/stack/tile/plasteel/dark/small
	name = "dark small tile"
	singular_name = "dark small floor tile"
	icon_state = "tile_dark_small"
	turf_type = /turf/open/floor/plasteel/tg/dark/small
	merge_type = /obj/item/stack/tile/plasteel/dark/small

/obj/item/stack/tile/plasteel/dark/diagonal
	name = "dark diagonal tile"
	singular_name = "dark diagonal floor tile"
	icon_state = "tile_dark_diagonal"
	turf_type = /turf/open/floor/plasteel/tg/dark/diagonal
	merge_type = /obj/item/stack/tile/plasteel/dark/diagonal

/obj/item/stack/tile/plasteel/dark/herringbone
	name = "dark herringbone tile"
	singular_name = "dark herringbone floor tile"
	icon_state = "tile_dark_herringbone"
	turf_type = /turf/open/floor/plasteel/tg/dark/herringbone
	merge_type = /obj/item/stack/tile/plasteel/dark/herringbone

/obj/item/stack/tile/plasteel/white
	name = "white tile"
	singular_name = "white floor tile"
	icon_state = "tile_white"
	turf_type = /turf/open/floor/plasteel/tg/white
	merge_type = /obj/item/stack/tile/plasteel/white

/obj/item/stack/tile/plasteel/white/smooth_edge
	name = "white edge tile"
	singular_name = "edged white floor tile"
	icon_state = "tile_white_edge"
	turf_type = /turf/open/floor/plasteel/tg/white/smooth_edge
	merge_type = /obj/item/stack/tile/plasteel/white/smooth_edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/white/smooth_half
	name = "white half tile"
	singular_name = "halved white floor tile"
	icon_state = "tile_white_half"
	turf_type = /turf/open/floor/plasteel/tg/white/smooth_half
	merge_type = /obj/item/stack/tile/plasteel/white/smooth_half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/plasteel/white/smooth_corner
	name = "white corner tile"
	singular_name = "cornered white floor tile"
	icon_state = "tile_white_corner"
	turf_type = /turf/open/floor/plasteel/tg/white/smooth_corner
	merge_type = /obj/item/stack/tile/plasteel/white/smooth_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/white/smooth_large
	name = "white large tile"
	singular_name = "large white floor tile"
	icon_state = "tile_white_large"
	turf_type = /turf/open/floor/plasteel/tg/white/smooth_large
	merge_type = /obj/item/stack/tile/plasteel/white/smooth_large

/obj/item/stack/tile/plasteel/white_side
	name = "half white tile"
	singular_name = "half white floor tile"
	icon_state = "tile_whiteside"
	turf_type = /turf/open/floor/plasteel/tg/white/side
	merge_type = /obj/item/stack/tile/plasteel/white_side
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)

/obj/item/stack/tile/plasteel/white_corner
	name = "quarter white tile"
	singular_name = "quarter white floor tile"
	icon_state = "tile_whitecorner"
	turf_type = /turf/open/floor/plasteel/tg/white/corner
	merge_type = /obj/item/stack/tile/plasteel/white_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/cafeteria
	name = "cafeteria tile"
	singular_name = "cafeteria floor tile"
	icon_state = "tile_cafeteria"
	turf_type = /turf/open/floor/plasteel/tg/cafeteria
	merge_type = /obj/item/stack/tile/plasteel/cafeteria
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/plasteel/white/textured
	name = "white textured tile"
	singular_name = "white textured floor tile"
	icon_state = "tile_textured_white"
	turf_type = /turf/open/floor/plasteel/tg/white/textured
	merge_type = /obj/item/stack/tile/plasteel/white/textured

/obj/item/stack/tile/plasteel/white/textured_edge
	name = "white textured edge tile"
	singular_name = "edged white textured floor tile"
	icon_state = "tile_textured_white_edge"
	turf_type = /turf/open/floor/plasteel/tg/white/textured_edge
	merge_type = /obj/item/stack/tile/plasteel/white/textured_edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/white/textured_half
	name = "white textured half tile"
	singular_name = "halved white textured floor tile"
	icon_state = "tile_textured_white_half"
	turf_type = /turf/open/floor/plasteel/tg/white/textured_half
	merge_type = /obj/item/stack/tile/plasteel/white/textured_half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/plasteel/white/textured_corner
	name = "white textured corner tile"
	singular_name = "cornered white textured floor tile"
	icon_state = "tile_textured_white_corner"
	turf_type = /turf/open/floor/plasteel/tg/white/textured_corner
	merge_type = /obj/item/stack/tile/plasteel/white/textured_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/white/textured_large
	name = "white textured large tile"
	singular_name = "large white textured floor tile"
	icon_state = "tile_textured_white_large"
	turf_type = /turf/open/floor/plasteel/tg/white/textured_large
	merge_type = /obj/item/stack/tile/plasteel/white/textured_large

/obj/item/stack/tile/plasteel/white/small
	name = "white small tile"
	singular_name = "white small floor tile"
	icon_state = "tile_white_small"
	turf_type = /turf/open/floor/plasteel/tg/white/small
	merge_type = /obj/item/stack/tile/plasteel/white/small

/obj/item/stack/tile/plasteel/white/diagonal
	name = "white diagonal tile"
	singular_name = "white diagonal floor tile"
	icon_state = "tile_white_diagonal"
	turf_type = /turf/open/floor/plasteel/tg/white/diagonal
	merge_type = /obj/item/stack/tile/plasteel/white/diagonal

/obj/item/stack/tile/plasteel/white/herringbone
	name = "white herringbone tile"
	singular_name = "white herringbone floor tile"
	icon_state = "tile_white_herringbone"
	turf_type = /turf/open/floor/plasteel/tg/white/herringbone
	merge_type = /obj/item/stack/tile/plasteel/white/herringbone

/obj/item/stack/tile/plasteel/smooth
	name = "smooth tile"
	singular_name = "smooth floor tile"
	icon_state = "tile_smooth"
	turf_type = /turf/open/floor/plasteel/tg/smooth
	merge_type = /obj/item/stack/tile/plasteel/smooth

/obj/item/stack/tile/plasteel/smooth_edge
	name = "smooth edge tile"
	singular_name = "edged smooth floor tile"
	icon_state = "tile_smooth_edge"
	turf_type = /turf/open/floor/plasteel/tg/smooth_edge
	merge_type = /obj/item/stack/tile/plasteel/smooth_edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/smooth_half
	name = "smooth half tile"
	singular_name = "halved smooth floor tile"
	icon_state = "tile_smooth_half"
	turf_type = /turf/open/floor/plasteel/tg/smooth_half
	merge_type = /obj/item/stack/tile/plasteel/smooth_half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/plasteel/smooth_corner
	name = "smooth corner tile"
	singular_name = "cornered smooth floor tile"
	icon_state = "tile_smooth_corner"
	turf_type = /turf/open/floor/plasteel/tg/smooth_corner
	merge_type = /obj/item/stack/tile/plasteel/smooth_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/plasteel/smooth_large
	name = "smooth large tile"
	singular_name = "large smooth floor tile"
	icon_state = "tile_smooth_large"
	turf_type = /turf/open/floor/plasteel/tg/smooth_large
	merge_type = /obj/item/stack/tile/plasteel/smooth_large

/obj/item/stack/tile/plasteel/terracotta
	name = "terracotta floor tile"
	singular_name = "terracotta floor tile"
	icon_state = "tile_terracotta"
	turf_type = /turf/open/floor/plasteel/tg/terracotta
	merge_type = /obj/item/stack/tile/plasteel/terracotta

/obj/item/stack/tile/plasteel/terracotta/small
	name = "terracotta small tile"
	singular_name = "terracotta small floor tile"
	icon_state = "tile_terracotta_small"
	turf_type = /turf/open/floor/plasteel/tg/terracotta/small
	merge_type = /obj/item/stack/tile/plasteel/terracotta/small

/obj/item/stack/tile/plasteel/terracotta/diagonal
	name = "terracotta diagonal tile"
	singular_name = "terracotta diagonal floor tile"
	icon_state = "tile_terracotta_diagonal"
	turf_type = /turf/open/floor/plasteel/tg/terracotta/diagonal
	merge_type = /obj/item/stack/tile/plasteel/terracotta/diagonal

/obj/item/stack/tile/plasteel/terracotta/herringbone
	name = "terracotta herringbone tile"
	singular_name = "terracotta herringbone floor tile"
	icon_state = "tile_terracotta_herringbone"
	turf_type = /turf/open/floor/plasteel/tg/terracotta/herringbone
	merge_type = /obj/item/stack/tile/plasteel/terracotta/herringbone

/obj/item/stack/tile/plasteel/kitchen
	name = "kitchen tile"
	singular_name = "kitchen tile"
	icon_state = "tile_kitchen"
	turf_type = /turf/open/floor/plasteel/tg/kitchen
	merge_type = /obj/item/stack/tile/plasteel/kitchen

/obj/item/stack/tile/plasteel/kitchen/small
	name = "small kitchen tile"
	singular_name = "small kitchen floor tile"
	icon_state = "tile_kitchen_small"
	turf_type = /turf/open/floor/plasteel/tg/kitchen/small
	merge_type = /obj/item/stack/tile/plasteel/kitchen/small

/obj/item/stack/tile/plasteel/kitchen/diagonal
	name = "diagonal kitchen tile"
	singular_name = "diagonal kitchen floor tile"
	icon_state = "tile_kitchen_diagonal"
	turf_type = /turf/open/floor/plasteel/tg/kitchen/diagonal
	merge_type = /obj/item/stack/tile/plasteel/kitchen/diagonal

/obj/item/stack/tile/plasteel/kitchen/herringbone
	name = "herringbone kitchen tile"
	singular_name = "herringbone kitchen floor tile"
	icon_state = "tile_kitchen_herringbone"
	turf_type = /turf/open/floor/plasteel/tg/kitchen/herringbone
	merge_type = /obj/item/stack/tile/plasteel/kitchen/herringbone

/obj/item/stack/tile/plasteel/chapel
	name = "chapel floor tile"
	singular_name = "chapel floor tile"
	icon_state = "tile_chapel"
	turf_type = /turf/open/floor/plasteel/tg/chapel
	merge_type = /obj/item/stack/tile/plasteel/chapel
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)

/obj/item/stack/tile/plasteel/showroomfloor
	name = "showroom floor tile"
	singular_name = "showroom floor tile"
	icon_state = "tile_showroom"
	turf_type = /turf/open/floor/plasteel/tg/showroomfloor
	merge_type = /obj/item/stack/tile/plasteel/showroomfloor

/obj/item/stack/tile/plasteel/freezer
	name = "freezer floor tile"
	singular_name = "freezer floor tile"
	icon_state = "tile_freezer"
	turf_type = /turf/open/floor/plasteel/tg/freezer
	merge_type = /obj/item/stack/tile/plasteel/freezer

/obj/item/stack/tile/plasteel/sepia
	name = "sepia floor tile"
	singular_name = "sepia floor tile"
	desc = "Well, the flow of time is normal on these tiles, weird."
	icon_state = "tile_sepia"
	turf_type = /turf/open/floor/plasteel/tg/sepia
	merge_type = /obj/item/stack/tile/plasteel/sepia

/obj/item/stack/tile/plasteel/vaporwave
	name = "vaporwave floor tile"
	singular_name = "vaporwave floor tile"
	icon_state = "tile_vaporwave"
	turf_type = /turf/open/floor/plasteel/tg/vaporwave
	merge_type = /obj/item/stack/tile/plasteel/vaporwave
	tile_reskin_types = null

/obj/item/stack/tile/dock
	name = "dock tile"
	singular_name = "dock tile"
	desc = "A bulky chunk of flooring capable of holding the weight of a shuttle."
	icon_state = "tile_dock"
	mats_per_unit = list(/datum/material/iron = 500, /datum/material/plasma = 500)
	turf_type = /turf/open/floor/dock
	merge_type = /obj/item/stack/tile/dock

/obj/item/stack/tile/drydock
	name = "dry dock tile"
	singular_name = "dry dock tile"
	desc = "An extra-bulky chunk of flooring capable of supporting shuttle construction."
	icon_state = "tile_drydock"
	mats_per_unit = list(/datum/material/iron = 1000, /datum/material/plasma = 1000)
	turf_type = /turf/open/floor/dock/drydock
	merge_type = /obj/item/stack/tile/drydock
