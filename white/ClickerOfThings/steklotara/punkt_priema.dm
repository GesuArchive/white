/obj/machinery/priem_steklotara
	name = "пункт приёма стеклотары"
	desc = "Пункт приёма стеклотары позволяет за пустые алкобутылки получать деньги. Как кэшбек, только лучше!"
	icon = 'white/ClickerOfThings/steklotara/punkt_priema.dmi'
	icon_state = "open"
	density = TRUE
	anchored = TRUE
	var/processing = FALSE
	var/bottle_process_time = 30

/obj/machinery/priem_steklotara/attackby(obj/item/I, mob/living/user, params)
	if (istype(I, /obj/item/reagent_containers/food/drinks/bottle))
		if (processing)
			to_chat(user, span_warning("Пункт приёма стеклотары обрабатывает бутылку, подождите!"))
			return
		var/obj/item/reagent_containers/food/drinks/bottle/btl = I
		if (btl.reagents.reagent_list.len != 0)
			to_chat(user, span_warning("Бутылка должна быть пуста!"))
			return
		qdel(I)
		flick("closing", src)
		spawn(4)
			icon_state = "closed"
		to_chat(user, span_info("Пункт приёма захавал бутылку."))
		playsound(src, 'sound/machines/chime.ogg', 100, 0)
		say("Бутылка обнаружена! Подождите...")
		processing = TRUE
		addtimer(CALLBACK(src, .proc/drop_money, btl), bottle_process_time)
	else
		return ..()


/obj/machinery/priem_steklotara/proc/drop_money(obj/item/reagent_containers/food/drinks/bottle/btl)
	var/cost = 0
	if (btl.custom_price != null)
		cost += btl.custom_price / 2
	if (btl.custom_premium_price != null)
		cost += btl.custom_premium_price / 4
	if (cost == 0)
		cost = 15
	while (cost > 0)
		if (cost >= 10)
			new /obj/item/coin/silver(src.loc)
			cost -= 10
		else if (cost < 10)
			new /obj/item/coin/iron(src.loc)
			cost -= 1
	flick("opening", src)
	spawn(4)
		icon_state = "open"
	playsound(src, 'sound/machines/ping.ogg', 100, 0)
	processing = FALSE
