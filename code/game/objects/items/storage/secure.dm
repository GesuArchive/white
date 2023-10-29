/*
 *	Absorbs /obj/item/secstorage.
 *	Reimplements it only slightly to use existing storage functionality.
 *
 *	Contains:
 *		Secure Briefcase
 *		Wall Safe
 */

// -----------------------------
//         Generic Item
// -----------------------------
/obj/item/storage/secure
	name = "secstorage"
	var/icon_locking = "secureb"
	var/icon_sparking = "securespark"
	var/icon_opened = "secure0"
	var/code = ""
	var/l_code = null
	var/l_set = FALSE
	var/l_setshort = FALSE
	var/l_hacking = FALSE
	var/open = FALSE
	var/can_hack_open = TRUE
	w_class = WEIGHT_CLASS_NORMAL
	desc = "This shouldn't exist. If it does, create an issue report."

/obj/item/storage/secure/Initialize()
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.max_total_storage = 14

/obj/item/storage/secure/examine(mob/user)
	. = ..()
	. += "<hr>The service panel is currently <b>[open ? "unscrewed" : "screwed shut"]</b>."

/obj/item/storage/secure/attackby(obj/item/W, mob/user, params)
	if(can_hack_open && atom_storage.locked)
		if (W.tool_behaviour == TOOL_SCREWDRIVER)
			if (W.use_tool(src, user, 20))
				open = !open
				to_chat(user, span_notice("You [open ? "open" : "close"] the service panel."))
			return
		if (W.tool_behaviour == TOOL_WIRECUTTER)
			to_chat(user, span_danger("[src] is protected from this sort of tampering, yet it appears the internal memory wires can still be <b>pulsed</b>."))
			return
		if (W.tool_behaviour == TOOL_MULTITOOL)
			if(l_hacking)
				to_chat(user, span_danger("This safe is already being hacked."))
				return
			if(open == TRUE)
				to_chat(user, span_danger("Now attempting to reset internal memory, please hold."))
				l_hacking = TRUE
				if (W.use_tool(src, user, 400))
					to_chat(user, span_danger("Internal memory reset - lock has been disengaged."))
					l_set = FALSE

				l_hacking = FALSE
				return

			to_chat(user, span_warning("You must <b>unscrew</b> the service panel before you can pulse the wiring!"))
			return

	// -> storage/attackby() what with handle insertion, etc
	return ..()

/obj/item/storage/secure/attack_self(mob/user)
	var/locked = atom_storage.locked
	user.set_machine(src)
	var/dat = text("<TT><B>[]</B><BR>\n\nБлокировка: []",src, (locked ? "ЗАБЛОКИРОВАНО" : "РАЗБЛОКИРОВАНО"))
	var/message = "Code"
	if ((l_set == 0) && (!l_setshort))
		dat += text("<p>\n<b>ПЯТИЗНАЧНЫЙ КОД НЕ УСТАНОВЛЕН.<br>ВВЕДИТЕ НОВЫЙ КОД.</b>")
	if (l_setshort)
		dat += text("<p>\n<font color=red><b>ALERT: MEMORY SYSTEM ERROR - 6040 201</b></font>")
	message = text("[]", code)
	if (!locked)
		message = "*****"
	dat += text("<HR>\n>[]<BR>\n<A href='?src=[REF(src)];type=1'>1</A>-<A href='?src=[REF(src)];type=2'>2</A>-<A href='?src=[REF(src)];type=3'>3</A><BR>\n<A href='?src=[REF(src)];type=4'>4</A>-<A href='?src=[REF(src)];type=5'>5</A>-<A href='?src=[REF(src)];type=6'>6</A><BR>\n<A href='?src=[REF(src)];type=7'>7</A>-<A href='?src=[REF(src)];type=8'>8</A>-<A href='?src=[REF(src)];type=9'>9</A><BR>\n<A href='?src=[REF(src)];type=R'>R</A>-<A href='?src=[REF(src)];type=0'>0</A>-<A href='?src=[REF(src)];type=E'>E</A><BR>\n</TT>", message)

	var/datum/browser/popup = new(user, "caselock-[REF(src)]", "Сейф", 300, 280)
	popup.set_content(dat)
	popup.open()

/obj/item/storage/secure/Topic(href, href_list)
	..()
	if (usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED) || (get_dist(src, usr) > 1))
		return
	if (href_list["type"])	// Ввод
		if (href_list["type"] == "E")	// Перехват Е
			if (!l_set && (length(code) == 5) && (!l_setshort) && (code != "ERROR"))	// Задание нового кода если его не было
				l_code = code
				l_set = TRUE
			else if ((code == l_code) && l_set)	//
				atom_storage.locked = FALSE
				cut_overlays()
				add_overlay(icon_opened)
				code = null
			else
				code = "ERROR"
		else
			if ((href_list["type"] == "R") && (!l_setshort))
				atom_storage.locked = TRUE
				cut_overlays()
				code = null
				atom_storage.hide_contents(usr)
			else
				code += text("[]", sanitize_text(href_list["type"]))
				if (length(code) > 5)
					code = "ERROR"
		add_fingerprint(usr)
		for(var/mob/M in viewers(1, loc))
			if ((M.client && M.machine == src))
				attack_self(M)
			return
	return


// -----------------------------
//        Secure Briefcase
// -----------------------------
/obj/item/storage/secure/briefcase
	name = "secure briefcase"
	icon_state = "secure"
	inhand_icon_state = "sec-case"
	lefthand_file = 'icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/briefcase_righthand.dmi'
	desc = "A large briefcase with a digital locking system."
	force = 8
	hitsound = "swing_hit"
	throw_speed = 2
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("стукает", "бьёт", "разбивает", "атакует", "лупит")
	attack_verb_simple = list("стукает", "бьёт", "разбивает", "атакует", "лупит")

/obj/item/storage/secure/briefcase/PopulateContents()
	new /obj/item/paper(src)
	new /obj/item/pen(src)

/obj/item/storage/secure/briefcase/Initialize()
	. = ..()
	atom_storage.max_total_storage = 21
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL

//Syndie variant of Secure Briefcase. Contains space cash, slightly more robust.
/obj/item/storage/secure/briefcase/syndie
	force = 15

/obj/item/storage/secure/briefcase/syndie/PopulateContents()
	..()
	var/obj/item/stack/C = new /obj/item/stack/spacecash/c10000(src)
	C.amount = 50


// -----------------------------
//        Secure Safe
// -----------------------------

/obj/item/storage/secure/safe
	name = "secure safe"
	icon = 'icons/obj/storage.dmi'
	icon_state = "safe"
	icon_opened = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	desc = "Excellent for securing things away from grubby hands."
	force = 8
	w_class = WEIGHT_CLASS_GIGANTIC
	anchored = TRUE
	density = FALSE

/obj/item/storage/secure/safe/directional/north
	dir = SOUTH
	pixel_y = 32

/obj/item/storage/secure/safe/directional/south
	dir = NORTH
	pixel_y = -32

/obj/item/storage/secure/safe/directional/east
	dir = WEST
	pixel_x = 32

/obj/item/storage/secure/safe/directional/west
	dir = EAST
	pixel_x = -32

/obj/item/storage/secure/safe/Initialize()
	. = ..()
	atom_storage.set_holdable(cant_hold_list = list(/obj/item/storage/secure/briefcase))
	atom_storage.max_specific_storage = WEIGHT_CLASS_GIGANTIC				//??

/obj/item/storage/secure/safe/PopulateContents()
	new /obj/item/paper(src)
	new /obj/item/pen(src)

/obj/item/storage/secure/safe/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	return attack_self(user)

/obj/item/storage/secure/safe/hos
	name = "head of security's safe"

/**
 * This safe is meant to be damn robust. To break in, you're supposed to get creative, or use acid or an explosion.
 *
 * This makes the safe still possible to break in for someone who is prepared and capable enough, either through
 * chemistry, botany or whatever else.
 *
 * The safe is also weak to explosions, so spending some early TC could allow an antag to blow it upen if they can
 * get access to it.
 */
/obj/item/storage/secure/safe/caps_spare
	name = "сейф с запасной ID-картой Капитана"
	desc = "Хранит в себе запасную ID-карту самого верховного лорда. Коды доступа автоматически сообщаются ИО Капитана при прибытии на станцию. Не смотря на расхваливаемую прочность, на корпусе заметны легкие следы ржавчины."
	can_hack_open = FALSE
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 70, BIO = 100, RAD = 100, FIRE = 80, ACID = 70)
	max_integrity = 300
	color = "#ffdd33"

/obj/item/storage/secure/safe/caps_spare/Initialize(mapload)
	. = ..()

	l_code = SSid_access.spare_id_safe_code
	l_set = TRUE
	atom_storage.locked = TRUE

/obj/item/storage/secure/safe/caps_spare/PopulateContents()
	new /obj/item/card/id/advanced/gold/captains_spare(src)
	new /obj/item/card/id/departmental_budget/sta(src)

/obj/item/storage/secure/safe/caps_spare/rust_heretic_act()
	take_damage(damage_amount = 100, damage_type = BRUTE, damage_flag = MELEE, armour_penetration = 100)
