/obj/structure/closet/infinite
	name = "бесконечный шкаф"
	desc = "Это шкафы, вплоть до самого низа."
	var/replicating_type
	var/stop_replicating_at = 4
	var/auto_close_time = 15 SECONDS // Set to 0 to disable auto-closing.

/obj/structure/closet/infinite/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/closet/infinite/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/closet/infinite/process()
	if(!replicating_type)
		if(!length(contents))
			return
		else
			replicating_type = contents[1].type

	if(replicating_type && !opened && (length(contents) < stop_replicating_at))
		new replicating_type(src)

/obj/structure/closet/infinite/open(mob/living/user, force = FALSE)
	. = ..()
	if(. && auto_close_time)
		addtimer(CALLBACK(src, .proc/close_on_my_own), auto_close_time, TIMER_OVERRIDE|TIMER_UNIQUE)

/obj/structure/closet/infinite/proc/close_on_my_own()
	if(close())
		visible_message(span_notice("<b>[src.name]</b> закрывается сам."))
