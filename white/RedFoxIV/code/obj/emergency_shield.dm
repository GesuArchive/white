	//Keeping the shield up for a second costs 100 energy.
	//Charging the cell in a non-upgraded recharger takes 2 seconds for every second of shield being up.
	//Activating the projector takes 500 energy (and cannot be done if the cell has less than 1500).
	//The point is, using it as a spacesuit replacement is going to be fucking painful.
	//If people still abuse this too much, tune down the cell's chargerate.

/obj/item/emergency_shield
	name = "Аварийный прожектор щита"
	//desc = "Emergency pressure shields you in case of a pressure emergency where an emergency pressure shield is required to save you from a pressure emergency.<br>What was i talking about again?"
	desc = "Создаёт вокруг человека щит, защищающий от низкого давления, но бесполезный против физического урона и высоких/низких температур. Тратит весьма много энергии и работает только пока вы держите его в руках, поэтому лучше оставить его на крайний случай."
	icon = 'white/RedFoxIV/icons/obj/emergency_shield.dmi'
	icon_state = "inactive"
	w_class = WEIGHT_CLASS_SMALL
	var/obj/item/stock_parts/cell/emergency_shield/cell
	var/active = FALSE
	var/charge_use = 60
	var/time_used //stores world.time of last activation for cooldowns.
	var/mob/living/current_user
	var/shield_effect

/obj/item/emergency_shield/Initialize()
	. = ..()
	cell = new(src)
	shield_effect = mutable_appearance('white/RedFoxIV/icons/obj/emergency_shield.dmi', "overlay", MOB_SHIELD_LAYER)

/obj/item/emergency_shield/Destroy()
	qdel(cell)
	if(active)
		deactivate_shield()
		icon_state = "inactive"
		STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/item/emergency_shield/examine(mob/user)
	. = ..()
	. += "<br>"
	if(!cell)
		. += span_alert("There is no cell inside...")
	switch(cell.charge)
		if(3501 to INFINITY)
			. += "It seems to be overcharged, somehow..." //i dunno.
		if(3000 to 3500)
			. += "It seems to be fully charged."
		if(2500 to 2999)
			. += "It seems to be pretty charged."
		if(2000 to 2499)
			. += "It seems to be somewhat charged."
		if (1500 to 1999)
			. += "It seems to be charged just enough to turn it on once."
		if(1000 to 1499)
			. += "It seems to be pretty low on charge."
		if (500 to 999)
			. += "It seems to be very low on charge."
		if (1 to 499)
			. += "It has almost no charge."
		else
			. += "It has no charge at all."

	if(cell.charge < 1500)
		if(active)
			. += span_alert("<br>Turning it off now means you won't be able to turn it back on until recharged!")
		else
			. += span_alert("<br>The charge is too low to turn the shield on! Remove the cell with a screwdriver and recharge it.")

/obj/item/emergency_shield/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(I.tool_behaviour == TOOL_SCREWDRIVER && cell)
		if(active)
			to_chat(user, span_alert("Сначала выключи прожектор!"))
			return
		cell.forceMove(src.drop_location())
		cell.update_icon()
		I.play_tool_sound(src,50)
		visible_message("[user.name] вытаскивает [cell.name] из прожектора щита!", "Вытаскиваю [cell.name] из прожектора щита!")
		icon_state = "nocell"
		cell = null

	if(istype(I, /obj/item/stock_parts/cell) && !cell)
		if(!istype(I, /obj/item/stock_parts/cell/emergency_shield))
			to_chat(user, span_alert("Аварийный прожектор щита можно запитать только специальной батарейкой для прожекторов!.."))
			return
		cell = I
		cell.forceMove(src)
		playsound(src, 'sound/items/crowbar.ogg', 15, TRUE)
		visible_message("[user.name] вставляет батарею в аварийный прожектор щита.", "Вставляю [cell.name] в прожектор щита!")
		icon_state = "inactive"

/obj/item/emergency_shield/attack_self(mob/user)
	. = ..()

	if(world.time - time_used < 20 || !cell)
		return
	time_used = world.time

	if((cell.charge<1500 || HAS_TRAIT_FROM(user, TRAIT_RESISTLOWPRESSURE, "emergency_shield")) && !active) //cell charge too low or the user already has the trait AND it's inactive.
		playsound(src, 'white/RedFoxIV/sounds/mechcomp/generic_energy_dryfire.ogg', 15, FALSE)
		return

	active = !active
	if(active)
		current_user = user
		activate_shield()
		icon_state = "active"
		cell.use(500) // we are not afraid of trying to drain 500 power of an empty cell because we did a check earlier
		START_PROCESSING(SSprocessing, src)
	else
		deactivate_shield()
		icon_state = "inactive"
		STOP_PROCESSING(SSprocessing, src)

//the following 2 procs is a load of shitcode just to get the projector to turn off when dropped/put into inventory WHILE also staying on if you move it from hand to hand.
//i want to die btw
//handling dropping from hands, this includes placing on the table/floor, in a crate, in a storage, in a pocket or in another hand.
/obj/item/emergency_shield/dropped(mob/user, silent)
	. = ..()
	if(active)
		//first of all check if the item is still in the user. If not, it means the item has been dropped on the floor/table/crate/inventory outside the player.
		if(!(src.loc == current_user))
			deactivate_shield()
			icon_state = "inactive"
			STOP_PROCESSING(SSprocessing, src)
			return

		//if the previous check did not return, it means we have put the item in a backpack or something.
		spawn(0.1) //костыль уровня ктулху, по какой-то неведомой причине при перекладывании из руки в руку вызывается прок dropped и предмет оказывается НЕ В РУКАХ на момент вызова. Я ебал.
			if(!(src in current_user.held_items))
				deactivate_shield()
				icon_state = "inactive"
				STOP_PROCESSING(SSprocessing, src)


//handles placing into pockets, because the checks in dropped() can't catch if the item has been "dropped" into a pocket
/obj/item/emergency_shield/equipped(mob/user, slot, initial)
	. = ..()
	if(active && (slot != ITEM_SLOT_HANDS))
		deactivate_shield()
		icon_state = "inactive"
		STOP_PROCESSING(SSprocessing, src)

/obj/item/emergency_shield/process(delta_time)
	if(!cell.use(min(cell.charge, charge_use)))
		return

	if(!cell.charge)
		deactivate_shield()
		icon_state = "inactive"
		playsound(src, 'white/RedFoxIV/sounds/mechcomp/generic_energy_dryfire.ogg', 20, FALSE)
		return PROCESS_KILL

	//прожектор каким-то образом выпал из рук, не триггеря dropped()
	if(!(src in current_user.held_items))
		deactivate_shield()
		icon_state = "inactive"
		return PROCESS_KILL

/obj/item/stock_parts/cell/emergency_shield
	name = "Батарея аварийного прожектора щита"
	desc = "Специальная батарея, разработанная специально для прожектора щита. Из-за сложностей конструкции энергоёмкость оставляет желать лучшего."
	icon = 'white/RedFoxIV/icons/obj/emergency_shield.dmi'
	icon_state = "cell"
	maxcharge = 3500 //500 for initial activation and 3000 for the runtime of (3000/charge_use) seconds
	chargerate = 100


/obj/item/stock_parts/cell/emergency_shield/update_overlays()
	. = ..()
	. = list() // FUCK YOU
	if(charge < 0.01)
		return
	else if(charge/maxcharge >=0.995)
		. += mutable_appearance(icon, "cell-o2")
	else
		. += mutable_appearance(icon, "cell-o1")


/obj/item/emergency_shield/proc/activate_shield()
	active = TRUE
	ADD_TRAIT(current_user, TRAIT_RESISTLOWPRESSURE, "emergency_shield")
	ADD_TRAIT(current_user, TRAIT_RESISTHIGHPRESSURE, "emergency_shield")

	current_user.add_movespeed_modifier(/datum/movespeed_modifier/emergency_shield)
	current_user.add_overlay(shield_effect)
	playsound(src,'sound/weapons/saberon.ogg', 15, TRUE)

/obj/item/emergency_shield/proc/deactivate_shield()
	active = FALSE
	REMOVE_TRAIT(current_user, TRAIT_RESISTLOWPRESSURE, "emergency_shield")
	ADD_TRAIT(current_user, TRAIT_RESISTHIGHPRESSURE, "emergency_shield")

	current_user.remove_movespeed_modifier(/datum/movespeed_modifier/emergency_shield)
	current_user.cut_overlay(shield_effect)
	current_user = null
	playsound(src,'sound/weapons/saberoff.ogg', 15, TRUE)

/datum/movespeed_modifier/emergency_shield
	multiplicative_slowdown = 1.075
