/obj/structure/tripwire
	name = "растяжка"
	desc = "Не подходи - убьет!"
	icon_state = "tripwire"
	icon = 'white/hule/icons/obj/weapons.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 25
	integrity_failure = 0.5
	var/obj/item/grenade/prikl
	var/mob/owner

/obj/structure/tripwire/Initialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/check_cbt,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/tripwire/proc/activate()
	if(prikl)
		prikl.detonate(owner)
		qdel(src)

/obj/structure/tripwire/proc/check_cbt(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(ismob(AM))
		var/mob/MM = AM
		if(MM.movement_type & FLYING)
			return
		if(ismouse(MM))
			return
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(H.m_intent == MOVE_INTENT_WALK)
				return
	activate()

/obj/structure/tripwire/attack_hand(mob/user)
	activate()

/obj/structure/tripwire/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/wirecutters) && !(flags_1 & NODECONSTRUCT_1))
		if(do_after(user, 30, target = src))
			W.play_tool_sound(src)
			if(prob(80) && user.mind.antag_datums == null && user != owner)
				to_chat(user, span_userdanger("ОШИБОЧКА ВЫШЛА!"))
				activate()
				return
			if(prikl)
				prikl.forceMove(get_turf(prikl))
			qdel(src)
	..()

/obj/structure/tripwire/CheckParts(list/parts_list)
	prikl = locate() in parts_list
	if(!prikl)
		qdel(src)
		return
	return ..()

/datum/crafting_recipe/tripwire
	name = "Растяжка"
	time = 5 SECONDS
	result = /obj/structure/tripwire
	reqs = list(/obj/item/stack/cable_coil = 3,
				/obj/item/grenade = 1)
	parts = list(/obj/item/grenade = 1)
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/tripwire/on_craft_completion(mob/user, atom/result)
	. = ..()
	var/obj/structure/tripwire/TW = result
	TW.owner = user
	message_admins("[ADMIN_LOOKUPFLW(user)] поставил растяжку[ADMIN_COORDJMP(result)]")
	log_game("[key_name(user)] поставил растяжку[COORD(result)]")
