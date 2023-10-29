GLOBAL_LIST_EMPTY(monkey_recyclers)

/obj/machinery/monkey_recycler
	name = "переработчик обезьян"
	desc = "Полезная машина, перерабатывающая мертвых обезьян в обезьяньи кубики."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	circuit = /obj/item/circuitboard/machine/monkey_recycler
	var/stored_matter = 0
	var/cube_production = 0.2
	var/list/connected = list()			//Keeps track of connected xenobio consoles, for deletion in /Destroy()

/obj/machinery/monkey_recycler/Initialize(mapload)
	. = ..()
	if (mapload)
		GLOB.monkey_recyclers += src

/obj/machinery/monkey_recycler/Destroy()
	GLOB.monkey_recyclers -= src
	for(var/thing in connected)
		var/obj/machinery/computer/camera_advanced/xenobio/console = thing
		console.connected_recycler = null
	connected.Cut()
	return ..()

/obj/machinery/monkey_recycler/RefreshParts()	//Ranges from 0.2 to 0.8 per monkey recycled
	. = ..()
	cube_production = 0
	for(var/obj/item/stock_parts/manipulator/B in component_parts)
		cube_production += B.rating * 0.1
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		cube_production += M.rating * 0.1

/obj/machinery/monkey_recycler/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<hr><span class='notice'>Дисплей: Производит <b>[cube_production]</b> кубов за каждую мартышку.</span>"

/obj/machinery/monkey_recycler/attackby(obj/item/O, mob/user, params)
	if(default_deconstruction_screwdriver(user, "grinder_open", "grinder", O))
		return

	if(default_pry_open(O))
		return

	if(default_unfasten_wrench(user, O))
		power_change()
		return

	if(default_deconstruction_crowbar(O))
		return

	if(machine_stat) //NOPOWER etc
		return
	else
		return ..()

/obj/machinery/monkey_recycler/MouseDrop_T(mob/living/target, mob/living/user)
	if(!istype(target))
		return
	if(ismonkey(target))
		stuff_monkey_in(target, user)

/obj/machinery/monkey_recycler/proc/stuff_monkey_in(mob/living/carbon/human/target, mob/living/user)
	if(!istype(target))
		return
	if(target.stat == CONSCIOUS)
		to_chat(user, span_warning("Мартышка слишком сильно борется, чтобы положить её в переработчик."))
		return
	if(target.buckled || target.has_buckled_mobs())
		to_chat(user, span_warning("Мартышка прикреплена к чему-то."))
		return
	qdel(target)
	to_chat(user, span_notice("Запихиваю мартышку в переработчик."))
	playsound(src.loc, 'sound/machines/juicer.ogg', 50, TRUE)
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = 200) //start shaking
	use_power(active_power_usage)
	stored_matter += cube_production
	addtimer(VARSET_CALLBACK(src, pixel_x, base_pixel_x))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), user, span_notice("Теперь в переработчике [stored_matter] обезьяньих кубиков.")))

/obj/machinery/monkey_recycler/interact(mob/user)
	if(stored_matter >= 1)
		to_chat(user, span_notice("Машина громко шипит, перерабатывая обезьянье мясо. Через мгновение она выдает новый обезьяний кубик."))
		playsound(src.loc, 'sound/machines/hiss.ogg', 50, TRUE)
		for(var/i in 1 to FLOOR(stored_matter, 1))
			new /obj/item/food/monkeycube(src.loc)
			stored_matter--
		to_chat(user, span_notice("На дисплее мигает сообщение, что в переработчике осталось [stored_matter] обезьяних кубиков."))
	else
		to_chat(user, span_danger("Переработчику необходима хотя бы 1 мартышка, чтобы произвести новый куб. В нем сейчас [stored_matter]."))

/obj/machinery/monkey_recycler/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if(istype(I))
		to_chat(user, span_notice("Записываю [src] в буфер мультитула."))
		I.buffer = src
		return TRUE
