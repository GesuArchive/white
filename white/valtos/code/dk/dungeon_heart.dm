/obj/dungeon_keeper_heart
	name = "сердце подземелья"
	icon = 'white/valtos/icons/dk.dmi'
	icon_state = "heart"

	obj_integrity = 500
	armor = list(MELEE = 50, BULLET = 50, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100)

	anchored = TRUE
	density = TRUE
	opacity = TRUE

	var/datum/dungeon_keeper_master/keeper

/obj/dungeon_keeper_heart/Initialize(mapload)
	. = ..()
	if(!keeper)
		keeper = new(src)
		keeper.cameramob = new /mob/camera/dungeon_keeper(get_turf(src))
		keeper.cameramob.our_heart = src

/mob/camera/dungeon_keeper
	name = "Хранитель подземелья"
	real_name = "Хранитель подземелья"
	desc = "Мастер этого данжа."
	icon = 'white/valtos/icons/dk.dmi'
	icon_state = "master_eye"
	mouse_opacity = MOUSE_OPACITY_ICON
	see_in_dark = 8
	invisibility = INVISIBILITY_OBSERVER
	layer = FLY_LAYER
	see_invisible = SEE_INVISIBLE_LIVING
	pass_flags = PASSKEEPER
	faction = list(ROLE_DUNGEON_KEEPER)
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	hud_type = /datum/hud/dungeon_keeper

	var/obj/dungeon_keeper_heart/our_heart

/mob/camera/dungeon_keeper/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	update_health_hud()

/mob/camera/dungeon_keeper/update_health_hud()
	if(our_heart)
		if(hud_used && hud_used.keeper_magic_display)
			hud_used.keeper_magic_display.maptext = MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#00eded'>[our_heart.keeper.magic]</font></div>")

/mob/camera/dungeon_keeper/proc/create_special(price)
	return TRUE

/mob/camera/dungeon_keeper/proc/can_buy(cost = 15)
	if(our_heart.keeper.magic < cost)
		to_chat(src, span_warning("Не хватает очков маны!"))
		return FALSE
	our_heart.keeper.magic -= cost
	return TRUE
