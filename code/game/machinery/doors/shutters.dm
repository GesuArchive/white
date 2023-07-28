/obj/machinery/door/poddoor/shutters
	gender = PLURAL
	name = "жалюзи"
	desc = "Механические заслонки для тяжелых условий эксплуатации с атмосферным уплотнением, обеспечивающим их герметичность после закрытия."
	icon = 'white/valtos/icons/shutters.dmi'
	layer = SHUTTER_LAYER
	closingLayer = SHUTTER_LAYER
	damage_deflection = 20
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 75, "bomb" = 25, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 70)
	max_integrity = 100
	recipe_type = /datum/crafting_recipe/shutters

/obj/machinery/door/poddoor/shutters/assembly
	icon_state = "bilding"
	density = FALSE
	opacity = FALSE
	deconstruction = BLASTDOOR_NEEDS_WIRES
	encrypted = FALSE
	panel_open = TRUE

/obj/machinery/door/poddoor/shutters/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE

/obj/machinery/door/poddoor/shutters/indestructible
	name = "сверхкрепкие жалюзи"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/door/poddoor/shutters/radiation
	name = "свинцовые жалюзи"
	desc = "Свинцовые ставни с символом радиационной опасности. Хотя это не помешает вам получить облучение, особенно кристаллом суперматерии, оно остановит распространение излучения так далеко."
	icon = 'icons/obj/doors/shutters_radiation.dmi'
	icon_state = "closed"
	rad_insulation = RAD_EXTREME_INSULATION

/obj/machinery/door/poddoor/shutters/radiation/indestructible
	name = "сверхкрепкие свинцовые жалюзи"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/door/poddoor/shutters/radiation/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE
	rad_insulation = RAD_NO_INSULATION

/obj/machinery/door/poddoor/shutters/radiation/open()
	. = ..()
	rad_insulation = RAD_NO_INSULATION

/obj/machinery/door/poddoor/shutters/radiation/close()
	. = ..()
	rad_insulation = RAD_EXTREME_INSULATION

/obj/machinery/door/poddoor/shutters/window
	name = "прозрачные жалюзи"
	desc = "Ставни с толстым прозрачным окном из поликарбоната."
	icon = 'icons/obj/doors/shutters_window.dmi'
	icon_state = "closed"
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/poddoor/shutters/window/indestructible
	name = "сверхкрепкие прозрачные жалюзи"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/door/poddoor/shutters/window/preopen
	icon_state = "open"
	density = FALSE

/obj/machinery/door/poddoor/shutters/bumpopen()
	return
