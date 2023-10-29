/*
 * False Walls
 */
/obj/structure/falsewall
	name = "стена"
	desc = "Здоровенный кусок металла, который служит для разделения помещений."
	gender = FEMALE
	anchored = TRUE
	icon = DEFAULT_WALL_ICON
	icon_state = "wall-0"
	base_icon_state = "wall"
	layer = LOW_OBJ_LAYER
	density = TRUE
	opacity = TRUE
	max_integrity = 100
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WALLS)
	can_be_unanchored = FALSE
	can_atmos_pass = ATMOS_PASS_DENSITY
	flags_1 = RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1
	rad_insulation = RAD_MEDIUM_INSULATION
	var/mineral = /obj/item/stack/sheet/iron
	var/mineral_amount = 2
	var/walltype = /turf/closed/wall
	var/girder_type = /obj/structure/girder/displaced
	var/opening = FALSE


/obj/structure/falsewall/Initialize(mapload)
	. = ..()
	air_update_turf(TRUE)

/obj/structure/falsewall/attack_hand(mob/user)
	if(opening)
		return
	. = ..()
	if(.)
		return

	opening = TRUE
	update_icon()
	if(!density)
		var/srcturf = get_turf(src)
		for(var/mob/living/obstacle in srcturf) //Stop people from using this as a shield
			opening = FALSE
			return
	addtimer(CALLBACK(src, /obj/structure/falsewall/proc/toggle_open), 5)

/obj/structure/falsewall/proc/toggle_open()
	if(!QDELETED(src))
		set_density(!density)
		set_opacity(density)
		opening = FALSE
		update_icon()
		air_update_turf(!density)

/obj/structure/falsewall/update_icon(updates=ALL)//Calling icon_update will refresh the smoothwalls if it's closed, otherwise it will make sure the icon is correct if it's open
	. = ..()
	if(!density || !(updates & UPDATE_SMOOTHING))
		return

	if(opening)
		smoothing_flags = NONE
		clear_smooth_overlays()
	else
		smoothing_flags = SMOOTH_BITMASK
		QUEUE_SMOOTH(src)

/obj/structure/falsewall/update_icon_state()
	if(opening)
		icon_state = "fwall_[density ? "opening" : "closing"]"
		return ..()
	icon_state = density ? "[base_icon_state]-[smoothing_junction]" : "fwall_open"
	return ..()

/obj/structure/falsewall/proc/ChangeToWall(delete = 1)
	var/turf/T = get_turf(src)
	T.PlaceOnTop(walltype)
	if(delete)
		qdel(src)
	return T

/obj/structure/falsewall/attackby(obj/item/W, mob/user, params)
	if(opening)
		to_chat(user, span_warning("НАДО ПОДОЖДАТЬ!"))
		return

	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(density)
			var/turf/T = get_turf(src)
			if(T.density)
				to_chat(user, span_warning("[src.name] заблокирована!"))
				return
			if(!isfloorturf(T))
				to_chat(user, span_warning("Под [src.name] отсутствует пол!"))
				return
			user.visible_message(span_notice("[user] затягивает болты стены.") , span_notice("Затягиваю болты стены."))
			ChangeToWall()
		else
			to_chat(user, span_warning("Не могу достать до болтов! Закрыть бы её!"))

	else if(W.tool_behaviour == TOOL_WELDER)
		if(W.use_tool(src, user, 0, volume=50))
			dismantle(user, TRUE)
	else
		return ..()

/obj/structure/falsewall/proc/dismantle(mob/user, disassembled=TRUE, obj/item/tool = null)
	user.visible_message(span_notice("[user] разбирает фальшстену.") , span_notice("Разбираю фальшстену."))
	if(tool)
		tool.play_tool_sound(src, 100)
	else
		playsound(src, 'sound/items/welder.ogg', 100, TRUE)
	deconstruct(disassembled)

/obj/structure/falsewall/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(disassembled)
			new girder_type(loc)
		if(mineral_amount)
			for(var/i in 1 to mineral_amount)
				new mineral(loc)
	qdel(src)

/obj/structure/falsewall/get_dumping_location(obj/item/storage/source,mob/user)
	return null

/obj/structure/falsewall/examine_status(mob/user) //So you can't detect falsewalls by examine.
	to_chat(user, span_notice("Внешнее покрытие <b>приварено</b> крепко."))
	return null

/*
 * False R-Walls
 */

/obj/structure/falsewall/reinforced
	name = "армированная стена"
	desc = "Здоровенный укреплённый кусок металла, который служит для разделения помещений."
	icon = DEFAULT_RWALL_ICON
	icon_state = "reinforced_wall-0"
	base_icon_state = "reinforced_wall"
	walltype = /turf/closed/wall/r_wall
	mineral = /obj/item/stack/sheet/plasteel
	smoothing_flags = SMOOTH_BITMASK

/obj/structure/falsewall/reinforced/examine_status(mob/user)
	to_chat(user, span_notice("Внешняя <b>решетка</b> цела."))
	return null

/obj/structure/falsewall/reinforced/attackby(obj/item/tool, mob/user)
	..()
	if(tool.tool_behaviour == TOOL_WIRECUTTER)
		dismantle(user, TRUE, tool)

/*
 * Фальшивая пластитановая стена
 */

/obj/structure/falsewall/plastitanium
	name = "пластитановая стена"
	desc = "Зловещая стена с пластитановым покрытием."
	icon = DEFAULT_PLASTITANUM_ICON
	icon_state = "plastitanium_wall-0"
	base_icon_state = "plastitanium_wall"
	mineral = /obj/item/stack/sheet/mineral/plastitanium
	walltype = /turf/closed/wall/r_wall/syndicate
	smoothing_flags = SMOOTH_BITMASK
//	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_PLASTITANIUM_WALLS)
//	canSmoothWith = list(SMOOTH_GROUP_PLASTITANIUM_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTLE_PARTS)
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SYNDICATE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SYNDICATE_WALLS, SMOOTH_GROUP_PLASTITANIUM_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTLE_PARTS)


/obj/structure/falsewall/plastitanium/examine_status(mob/user)
	to_chat(user, span_notice("Внешняя <b>решетка</b> цела."))
	return null

/obj/structure/falsewall/plastitanium/attackby(obj/item/tool, mob/user)
	..()
	if(tool.tool_behaviour == TOOL_WIRECUTTER)
		dismantle(user, TRUE, tool)

/*
 * Фальшивая клепаная стена
 */

/obj/structure/falsewall/riveted_wall
	name = "армированная стена"
	desc = "Здоровенный укреплённый кусок металла, который служит для разделения помещений."
	icon = DEFAULT_RIVWALL_ICON
	icon_state = "riveted_wall-0"
	base_icon_state = "riveted_wall"
	walltype = /turf/closed/wall/riveted_wall
	mineral = /obj/item/stack/sheet/riveted_metal
	smoothing_flags = SMOOTH_BITMASK

/*
 * Uranium Falsewalls
 */

/obj/structure/falsewall/uranium
	name = "урановая стена"
	desc = "Стена с урановым покрытием. Это плохая идея."
	icon = 'icons/turf/walls/uranium_wall.dmi'
	icon_state = "uranium_wall-0"
	base_icon_state = "uranium_wall"
	mineral = /obj/item/stack/sheet/mineral/uranium
	walltype = /turf/closed/wall/mineral/uranium
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_URANIUM_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_URANIUM_WALLS)
	var/active = null
	var/last_event = 0

/obj/structure/falsewall/uranium/attackby(obj/item/W, mob/user, params)
	radiate()
	return ..()

/obj/structure/falsewall/uranium/attack_hand(mob/user)
	radiate()
	. = ..()

/obj/structure/falsewall/uranium/proc/radiate()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			radiation_pulse(src, 150)
			for(var/turf/closed/wall/mineral/uranium/T in orange(1,src))
				T.radiate()
			last_event = world.time
			active = null
			return
	return
/*
 * Other misc falsewall types
 */

/obj/structure/falsewall/gold
	name = "золотая стена"
	desc = "Стена с золотым покрытием. Чётко!"
	icon = 'icons/turf/walls/gold_wall.dmi'
	icon_state = "gold_wall-0"
	base_icon_state = "gold_wall"
	mineral = /obj/item/stack/sheet/mineral/gold
	walltype = /turf/closed/wall/mineral/gold
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_GOLD_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_GOLD_WALLS)

/obj/structure/falsewall/silver
	name = "серебряная стена"
	desc = "Стена с серебряным покрытием. Сияет."
	icon = 'icons/turf/walls/silver_wall.dmi'
	icon_state = "silver_wall-0"
	base_icon_state = "silver_wall"
	mineral = /obj/item/stack/sheet/mineral/silver
	walltype = /turf/closed/wall/mineral/silver
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SILVER_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SILVER_WALLS)

/obj/structure/falsewall/diamond
	name = "алмазная стена"
	desc = "Стена с алмазным покрытием. Построено идиотом."
	icon = 'icons/turf/walls/diamond_wall.dmi'
	icon_state = "diamond_wall-0"
	base_icon_state = "diamond_wall"
	mineral = /obj/item/stack/sheet/mineral/diamond
	walltype = /turf/closed/wall/mineral/diamond
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_DIAMOND_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_DIAMOND_WALLS)
	max_integrity = 800

/obj/structure/falsewall/plasma
	name = "стена из плазмы"
	desc = "Стена с покрытием из плазмы. Это плохая идея."
	icon = 'icons/turf/walls/plasma_wall.dmi'
	icon_state = "plasma_wall-0"
	base_icon_state = "plasma_wall"
	mineral = /obj/item/stack/sheet/mineral/plasma
	walltype = /turf/closed/wall/mineral/plasma
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_PLASMA_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_PLASMA_WALLS)

/obj/structure/falsewall/plasma/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/atmos_sensitive)

/obj/structure/falsewall/plasma/attackby(obj/item/W, mob/user, params)
	if(W.get_temperature() > 300)
		var/turf/T = get_turf(src)
		message_admins("Plasma falsewall ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("Plasma falsewall ignited by [key_name(user)] in [AREACOORD(T)]")
		burnbabyburn()
	else
		return ..()

/obj/structure/falsewall/plasma/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > 300

/obj/structure/falsewall/plasma/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	burnbabyburn()

/obj/structure/falsewall/plasma/proc/burnbabyburn(user)
	playsound(src, 'sound/items/welder.ogg', 100, TRUE)
	atmos_spawn_air("plasma=400;TEMP=1000")
	new /obj/structure/girder/displaced(loc)
	qdel(src)

/obj/structure/falsewall/bananium
	name = "бананиумная стена"
	desc = "Стена с бананиевым покрытием. Хонк!"
	icon = 'icons/turf/walls/bananium_wall.dmi'
	icon_state = "bananium_wall-0"
	base_icon_state = "bananium_wall"
	mineral = /obj/item/stack/sheet/mineral/bananium
	walltype = /turf/closed/wall/mineral/bananium
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_BANANIUM_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_BANANIUM_WALLS)


/obj/structure/falsewall/sandstone
	name = "песчаниковая стена"
	desc = "Стена с песчанниковым покрытием. Грубая."
	icon = 'icons/turf/walls/sandstone_wall.dmi'
	icon_state = "sandstone_wall-0"
	base_icon_state = "sandstone_wall"
	mineral = /obj/item/stack/sheet/mineral/sandstone
	walltype = /turf/closed/wall/mineral/sandstone
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SANDSTONE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SANDSTONE_WALLS)

/obj/structure/falsewall/wood
	name = "деревянная стена"
	desc = "Стена с деревянным покрытием. Занозы торчат."
	icon = 'icons/turf/walls/wood_wall.dmi'
	icon_state = "wood_wall-0"
	base_icon_state = "wood_wall"
	mineral = /obj/item/stack/sheet/mineral/wood
	walltype = /turf/closed/wall/mineral/wood
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WOOD_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WOOD_WALLS)

/obj/structure/falsewall/bamboo
	name = "бамбуковая стена"
	desc = "Стена с бамбуковой отделкой. Дзен."
	icon = 'icons/turf/walls/bamboo_wall.dmi'
	icon_state = "bamboo"
	mineral = /obj/item/stack/sheet/mineral/bamboo
	walltype = /turf/closed/wall/mineral/bamboo
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_BAMBOO_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_BAMBOO_WALLS)

/obj/structure/falsewall/iron
	name = "грубая металлическая стена"
	desc = "Стена с металлическим покрытием"
	icon = 'icons/turf/walls/iron_wall.dmi'
	icon_state = "iron_wall-0"
	base_icon_state = "iron_wall"
	mineral = /obj/item/stack/rods
	mineral_amount = 5
	walltype = /turf/closed/wall/mineral/iron
	base_icon_state = "iron_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_IRON_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_IRON_WALLS)

/obj/structure/falsewall/abductor
	name = "чужеродная стена"
	desc = "Стена с инопланетным покрытием."
	icon = 'icons/turf/walls/abductor_wall.dmi'
	icon_state = "abductor_wall-0"
	base_icon_state = "abductor_wall"
	mineral = /obj/item/stack/sheet/mineral/abductor
	walltype = /turf/closed/wall/mineral/abductor
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_ABDUCTOR_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ABDUCTOR_WALLS)

/obj/structure/falsewall/titanium
	name = "титановая стена"
	desc = "Стена с легковесным титановым покрытием."
	icon = 'icons/turf/walls/shuttle_wall.dmi'
	icon_state = "shuttle_wall-0"
	base_icon_state = "shuttle_wall"
	mineral = /obj/item/stack/sheet/mineral/titanium
	walltype = /turf/closed/wall/mineral/titanium
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_TITANIUM_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_TITANIUM_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTLE_PARTS)

/obj/structure/falsewall/bronze
	name = "латунная стена"
	desc = "Крупная латунная стена. Её украшивают также и латунные шестерни."
	icon = 'icons/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall"
	base_icon_state = "clockwork_wall-0"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	mineral_amount = 1
	smoothing_flags = SMOOTH_CORNERS
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SILVER_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SILVER_WALLS)
	girder_type = /obj/structure/girder/bronze
	walltype = /turf/closed/wall/clockwork
	mineral = /obj/item/stack/tile/bronze

/obj/structure/falsewall/bronze/Destroy()
	return ..()
