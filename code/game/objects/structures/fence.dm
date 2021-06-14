//Chain link fences
//Sprites ported from /VG/


#define CUT_TIME 100
#define CLIMB_TIME 150

#define NO_HOLE 0 //section is intact
#define MEDIUM_HOLE 1 //medium hole in the section - can climb through
#define LARGE_HOLE 2 //large hole in the section - can walk through
#define MAX_HOLE_SIZE LARGE_HOLE

/obj/structure/fence
	name = "заборчик"
	desc = "Забор из сетки рабицы. Не так эффективно, как стена, но людей не пропускает."
	density = TRUE
	anchored = TRUE

	icon = 'icons/obj/fence.dmi'
	icon_state = "straight"

	var/cuttable = TRUE
	var/hole_size= NO_HOLE
	var/invulnerable = FALSE

/obj/structure/fence/Initialize()
	. = ..()

	update_cut_status()

/obj/structure/fence/examine(mob/user)
	. = ..()

	. += "<hr>"

	switch(hole_size)
		if(MEDIUM_HOLE)
			. += "There is a large hole in <b>[src.name]</b>."
		if(LARGE_HOLE)
			. += "<b>[src.name]</b> has been completely cut through."

/obj/structure/fence/end
	icon_state = "end"
	cuttable = FALSE

/obj/structure/fence/corner
	icon_state = "corner"
	cuttable = FALSE

/obj/structure/fence/post
	icon_state = "post"
	cuttable = FALSE

/obj/structure/fence/cut/medium
	icon_state = "straight_cut2"
	hole_size = MEDIUM_HOLE

/obj/structure/fence/cut/large
	icon_state = "straight_cut3"
	hole_size = LARGE_HOLE

/obj/structure/fence/attackby(obj/item/W, mob/user)
	if(W.tool_behaviour == TOOL_WIRECUTTER)
		if(!cuttable)
			to_chat(user, "<span class='warning'>Эту секцию забора нельзя прорезать!</span>")
			return
		if(invulnerable)
			to_chat(user, "<span class='warning'>Этот забор слишком прочный, чтобы прорезать его!</span>")
			return
		var/current_stage = hole_size
		if(current_stage >= MAX_HOLE_SIZE)
			to_chat(user, "<span class='warning'>В этом заборе уже прорезали слишком много дыр!</span>")
			return

		user.visible_message("<span class='danger'> [user] начинает прорезать <b>[src.name]</b> с помощью [W].</span>",\
		"<span class='danger'>Начинаю прорезать <b>[src.name]</b> используя [W].</span>")

		if(do_after(user, CUT_TIME*W.toolspeed, target = src))
			if(current_stage == hole_size)
				switch(++hole_size)
					if(MEDIUM_HOLE)
						visible_message("<span class='notice'>[user] врезается <b>[src.name]</b> еще немного.</span>")
						to_chat(user, "<span class='info'>Можно пролезть в дыру уже сейчас. Но я пролезу быстрее если сделать дыру побольше.</span>")
						climbable = TRUE
					if(LARGE_HOLE)
						visible_message("<span class='notice'> [user] полностью разрезает <b>[src.name]</b>.</span>")
						to_chat(user, "<span class='info'>Дыра в <b>[src.name]</b> достаточно большая чтобы пройти в нее не пригибаясь.</span>")
						climbable = FALSE

				update_cut_status()

	return TRUE

/obj/structure/fence/proc/update_cut_status()
	if(!cuttable)
		return
	density = TRUE
	switch(hole_size)
		if(NO_HOLE)
			icon_state = initial(icon_state)
		if(MEDIUM_HOLE)
			icon_state = "straight_cut2"
		if(LARGE_HOLE)
			icon_state = "straight_cut3"
			density = FALSE

//FENCE DOORS

/obj/structure/fence/door
	name = "калитка"
	desc = "Сомнительная польза без замка. В виду активизации деятельности международной террористической организации «ИГИЛ» убедительно просим вас закрывать калитку на крючок."
	icon_state = "door_closed"
	cuttable = FALSE
	var/open = FALSE

/obj/structure/fence/door/Initialize()
	. = ..()

	update_door_status()

/obj/structure/fence/door/opened
	icon_state = "door_opened"
	open = TRUE
	density = TRUE

/obj/structure/fence/door/attack_hand(mob/user)
	if(can_open(user))
		toggle(user)

	return TRUE

/obj/structure/fence/door/proc/toggle(mob/user)
	open = !open
	visible_message("<span class='notice'> [user] [open ? "открывает" : "закрывает"] <b>[src.name]</b>.</span>")
	update_door_status()
	playsound(src, 'sound/machines/click.ogg', 100, TRUE)

/obj/structure/fence/door/proc/update_door_status()
	density = !density
	icon_state = density ? "door_closed" : "door_opened"

/obj/structure/fence/door/proc/can_open(mob/user)
	return TRUE

#undef CUT_TIME
#undef CLIMB_TIME

#undef NO_HOLE
#undef MEDIUM_HOLE
#undef LARGE_HOLE
#undef MAX_HOLE_SIZE
