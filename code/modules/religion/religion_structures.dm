/obj/structure/altar_of_gods
	name = "алтарь богов"
	desc = "Алтарь, который позволяет главе церкви выбирать секту религиозных учений, а также приносить жертвы, чтобы заслужить благосклонность."
	icon = 'icons/obj/hand_of_god_structures.dmi'
	icon_state = "convertaltar"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	pass_flags_self = LETPASSTHROW
	can_buckle = TRUE
	buckle_lying = 90 //we turn to you!
	///Avoids having to check global everytime by referencing it locally.
	var/datum/religion_sect/sect_to_altar

/obj/structure/altar_of_gods/Initialize(mapload)
	. = ..()
	reflect_sect_in_icons()
	AddElement(/datum/element/climbable)

/obj/structure/altar_of_gods/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/religious_tool, ALL, FALSE, CALLBACK(src, .proc/reflect_sect_in_icons))

/obj/structure/altar_of_gods/update_overlays()
	var/list/new_overlays = ..()
	if(GLOB.religious_sect)
		return new_overlays
	new_overlays += "convertaltarcandle"
	return new_overlays

/obj/structure/altar_of_gods/attack_hand(mob/living/user, list/modifiers)
	if(!Adjacent(user) || !user.pulling)
		return ..()
	if(!isliving(user.pulling))
		return ..()
	var/mob/living/pushed_mob = user.pulling
	if(pushed_mob.buckled)
		to_chat(user, span_warning("[pushed_mob] пристегнут к [pushed_mob.buckled]!"))
		return ..()
	to_chat(user,"<span class='notice>Пытаюсь coax [pushed_mob] onto [src]...</span>")
	if(!do_after(user,(5 SECONDS),target = pushed_mob))
		return ..()
	pushed_mob.forceMove(loc)
	return ..()

/obj/structure/altar_of_gods/proc/reflect_sect_in_icons()
	if(GLOB.religious_sect)
		sect_to_altar = GLOB.religious_sect
		if(sect_to_altar.altar_icon)
			icon = sect_to_altar.altar_icon
		if(sect_to_altar.altar_icon_state)
			icon_state = sect_to_altar.altar_icon_state
	add_overlay("convertaltarcandle")

/obj/item/ritual_totem
	name = "ритуальный тотем"
	desc = "Деревянный тотем со странной резьбой на нем."
	icon_state = "ritual_totem"
	inhand_icon_state = "sheet-wood"
	lefthand_file = 'icons/mob/inhands/misc/sheets_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/sheets_righthand.dmi'
	//made out of a single sheet of wood
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT)
	item_flags = NO_PIXEL_RANDOM_DROP

/obj/item/ritual_totem/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, FALSE, null, 1, FALSE, CALLBACK(src, .proc/block_magic), CALLBACK(src, .proc/expire))//one charge of anti_magic
	AddComponent(/datum/component/religious_tool, RELIGION_TOOL_INVOKE, FALSE)

/obj/item/ritual_totem/proc/block_magic(mob/user, major)
	if(major)
		to_chat(user, span_warning("[src] поглощает магию!"))

/obj/item/ritual_totem/proc/expire(mob/user)
	to_chat(user, span_warning("[src] быстро сгнивает!"))
	qdel(src)
	new /obj/effect/decal/cleanable/ash(drop_location())

/obj/item/ritual_totem/can_be_pulled(user, grab_state, force)
	. = ..()
	return FALSE //no

/obj/item/ritual_totem/examine(mob/user)
	. = ..()
	var/is_holy = user.mind?.holy_role
	if(is_holy)
		. += span_notice("[src] может быть перемещен только последователем [GLOB.deity] с высоким саном.")

/obj/item/ritual_totem/pickup(mob/taker)
	var/initial_loc = loc
	var/holiness = taker.mind?.holy_role
	var/no_take = FALSE
	if(holiness == NONE)
		to_chat(taker, span_warning("Как бы я ни старался, у меня не получается поднять [src]!"))
		no_take = TRUE
	else if(holiness == HOLY_ROLE_DEACON) //deacons cannot pick them up either
		no_take = TRUE
		to_chat(taker, span_warning("Не могу поднять [src]. Мой сан [GLOB.deity] слишком низок чтобы сделать это."))
	..()
	if(no_take)
		taker.dropItemToGround(src)
		forceMove(initial_loc)
