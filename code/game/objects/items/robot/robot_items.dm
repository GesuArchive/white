/**********************************************************************
						Cyborg Spec Items
***********************************************************************/
/obj/item/borg
	icon = 'icons/mob/robot_items.dmi'


/obj/item/borg/stun
	name = "заряженная рука"
	icon_state = "elecarm"
	var/charge_cost = 30

/obj/item/borg/stun/attack(mob/living/M, mob/living/user)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.check_shields(src, 0, "[M] [name]", MELEE_ATTACK))
			playsound(M, 'sound/weapons/genhit.ogg', 50, TRUE)
			return FALSE
	if(iscyborg(user))
		var/mob/living/silicon/robot/R = user
		if(!R.cell.use(charge_cost))
			return

	user.do_attack_animation(M)
	M.Paralyze(100)
	M.apply_effect(EFFECT_STUTTER, 5)

	M.visible_message(span_danger("[user] ударил [M] с помощью [src]!") , \
					span_userdanger("[user] ударил вас [src]!"))

	playsound(loc, 'sound/weapons/egloves.ogg', 50, TRUE, -1)

	log_combat(user, M, "stunned", src, "(INTENT: [uppertext(user.a_intent)])")

/obj/item/borg/cyborghug
	name = "модуль обьятий"
	icon_state = "hugmodule"
	desc = "Когда кому-то действительно нужны обнимашки."
	var/mode = 0 //0 = Hugs 1 = "Hug" 2 = Shock 3 = CRUSH
	var/ccooldown = 0
	var/scooldown = 0
	var/shockallowed = FALSE//Can it be a stunarm when emagged. Only PK borgs get this by default.
	var/boop = FALSE

/obj/item/borg/cyborghug/attack_self(mob/living/user)
	if(iscyborg(user))
		var/mob/living/silicon/robot/P = user
		if(P.emagged&&shockallowed == 1)
			if(mode < 3)
				mode++
			else
				mode = 0
		else if(mode < 1)
			mode++
		else
			mode = 0
	switch(mode)
		if(0)
			to_chat(user, "Перезагрузка. Обнимашки!")
		if(1)
			to_chat(user, "Усиляем обьятия!")
		if(2)
			to_chat(user, "БЗЗЗ. Электризуем руки...")
		if(3)
			to_chat(user, "ОШИБКА: Сервомоторы рук перегружены.")

/obj/item/borg/cyborghug/attack(mob/living/M, mob/living/silicon/robot/user)
	if(M == user)
		return
	switch(mode)
		if(0)
			if(M.health >= 0)
				if(isanimal(M))
					M.attack_hand(user) //This enables borgs to get the floating heart icon and mob emote from simple_animal's that have petbonus == true.
					return
				if(user.zone_selected == BODY_ZONE_HEAD)
					user.visible_message(span_notice("[user] игриво погладил [M] по голове!") , \
									span_notice("Я игриво погладил [M] по голове!"))
					user.do_attack_animation(M, ATTACK_EFFECT_BOOP)
					playsound(loc, 'sound/weapons/tap.ogg', 50, TRUE, -1)
				else if(ishuman(M))
					if(user.body_position == LYING_DOWN)
						user.visible_message(span_notice("[user] трясет [M] в попытке поднять на ноги [M.ru_na()]!") , \
										span_notice("Я трясу [M] в попытке поднять его на ноги [M.ru_na()]!"))
					else
						user.visible_message(span_notice("[user] обнял [M] чтобы [M.ru_na()] почувствовал себя лучше!") , \
								span_notice("Я обнял [M] чтобы [M.ru_na()] почувствовал себя лучше!"))
					if(M.resting)
						M.set_resting(FALSE, TRUE)
				else
					user.visible_message(span_notice("[user] гладит [M]!") , \
							span_notice("Я погладил [M]!"))
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
		if(1)
			if(M.health >= 0)
				if(ishuman(M))
					if(M.body_position == LYING_DOWN)
						user.visible_message(span_notice("[user] трясет [M] в попытке поднять на ноги [M.ru_na()]!") , \
										span_notice("Я трясу [M] в попытке поднять его на ноги [M.ru_na()]!"))
					else if(user.zone_selected == BODY_ZONE_HEAD)
						user.visible_message(span_warning("[user] погладил [M] по голове!") , \
										span_warning("Я погладил [M] по голове!"))
						user.do_attack_animation(M, ATTACK_EFFECT_PUNCH)
					else
						user.visible_message(span_warning("[user] крепко обнял [M]! Кажется [M] некомфортно...") , \
								span_warning("Я решительно обнял [M], чтобы [M.ru_na()] почувствовал себя лучше! Кажется [M]..."))
					if(M.resting)
						M.set_resting(FALSE, TRUE)
				else
					user.visible_message(span_warning("[user] погладил [M] по голове!") , \
							span_warning("Я погладил [M] по голове!"))
				playsound(loc, 'sound/weapons/tap.ogg', 50, TRUE, -1)
		if(2)
			if(scooldown < world.time)
				if(M.health >= 0)
					if(ishuman(M))
						M.electrocute_act(5, "[user]", flags = SHOCK_NOGLOVES)
						user.visible_message(span_userdanger("[user] ударил током [M] при [user.ru_ego()] касании!") , \
							span_danger("Я ударил током [M] при касании!"))
					else
						if(!iscyborg(M))
							M.adjustFireLoss(10)
							user.visible_message(span_userdanger("[user] ударили током [M]!") , \
								span_danger("Я ударил током [M] при касании!"))
						else
							user.visible_message(span_userdanger("[user] ударил током [M]. Кажется это не принесло эффекта.") , \
								span_danger("Я ударил током [M], но это не возымело эффекта."))
					playsound(loc, 'sound/effects/sparks2.ogg', 50, TRUE, -1)
					user.cell.charge -= 500
					scooldown = world.time + 20
		if(3)
			if(ccooldown < world.time)
				if(M.health >= 0)
					if(ishuman(M))
						user.visible_message(span_userdanger("[user] сминает [M] в [user.ru_ego()] обьятиях!") , \
							span_danger("Я сминаю [M] в своих обьятиях!"))
					else
						user.visible_message(span_userdanger("[user] сминает [M]!") , \
								span_danger("Я сминаю [M]!"))
					playsound(loc, 'sound/weapons/smash.ogg', 50, TRUE, -1)
					M.adjustBruteLoss(15)
					user.cell.charge -= 300
					ccooldown = world.time + 10

/obj/item/borg/cyborghug/peacekeeper
	shockallowed = TRUE

/obj/item/borg/cyborghug/medical
	boop = TRUE

/obj/item/borg/charger
	name = "разьем питания"
	icon_state = "charger_draw"
	item_flags = NOBLUDGEON
	var/mode = "draw"
	var/static/list/charge_machines = typecacheof(list(/obj/machinery/cell_charger, /obj/machinery/recharger, /obj/machinery/recharge_station, /obj/machinery/mech_bay_recharge_port))
	var/static/list/charge_items = typecacheof(list(/obj/item/stock_parts/cell, /obj/item/gun/energy))

/obj/item/borg/charger/update_icon_state()
	icon_state = "charger_[mode]"

/obj/item/borg/charger/attack_self(mob/user)
	if(mode == "draw")
		mode = "charge"
	else
		mode = "draw"
	to_chat(user, span_notice("Я переключил [src] в режим \"[mode]\"."))
	update_icon()

/obj/item/borg/charger/afterattack(obj/item/target, mob/living/silicon/robot/user, proximity_flag)
	. = ..()
	if(!proximity_flag || !iscyborg(user))
		return
	if(mode == "draw")
		if(is_type_in_list(target, charge_machines))
			var/obj/machinery/M = target
			if((M.machine_stat & (NOPOWER|BROKEN)) || !M.anchored)
				to_chat(user, span_warning("[M] разряжен!"))
				return

			to_chat(user, span_notice("Я подключил [M] к сети..."))
			while(do_after(user, 15, target = M, progress = 0))
				if(!user || !user.cell || mode != "draw")
					return

				if((M.machine_stat & (NOPOWER|BROKEN)) || !M.anchored)
					break

				if(!user.cell.give(150))
					break

				M.use_power(200)

			to_chat(user, span_notice("Я прекратил заряжать себя."))

		else if(is_type_in_list(target, charge_items))
			var/obj/item/stock_parts/cell/cell = target
			if(!istype(cell))
				cell = locate(/obj/item/stock_parts/cell) in target
			if(!cell)
				to_chat(user, span_warning("[target] не имеет батареи!"))
				return

			if(istype(target, /obj/item/gun/energy))
				var/obj/item/gun/energy/E = target
				if(!E.can_charge)
					to_chat(user, span_warning("[target] не имеет порта питания!"))
					return

			if(!cell.charge)
				to_chat(user, span_warning("[target] разряжена!"))


			to_chat(user, span_notice("Я подключил [target] к порту питания..."))

			while(do_after(user, 15, target = target, progress = 0))
				if(!user || !user.cell || mode != "draw")
					return

				if(!cell || !target)
					return

				if(cell != target && cell.loc != target)
					return

				var/draw = min(cell.charge, cell.chargerate*0.5, user.cell.maxcharge-user.cell.charge)
				if(!cell.use(draw))
					break
				if(!user.cell.give(draw))
					break
				target.update_icon()

			to_chat(user, span_notice("Я прекратил заряжать себя."))

	else if(is_type_in_list(target, charge_items))
		var/obj/item/stock_parts/cell/cell = target
		if(!istype(cell))
			cell = locate(/obj/item/stock_parts/cell) in target
		if(!cell)
			to_chat(user, span_warning("[target] не имеет батареи!"))
			return

		if(istype(target, /obj/item/gun/energy))
			var/obj/item/gun/energy/E = target
			if(!E.can_charge)
				to_chat(user, span_warning("[target] не имеет порта для подключения!"))
				return

		if(cell.charge >= cell.maxcharge)
			to_chat(user, span_warning("[target] полностью заряжен!"))

		to_chat(user, span_notice("Я подключил [target] к порту питания..."))

		while(do_after(user, 15, target = target, progress = 0))
			if(!user || !user.cell || mode != "charge")
				return

			if(!cell || !target)
				return

			if(cell != target && cell.loc != target)
				return

			var/draw = min(user.cell.charge, cell.chargerate*0.5, cell.maxcharge-cell.charge)
			if(!user.cell.use(draw))
				break
			if(!cell.give(draw))
				break
			target.update_icon()

		to_chat(user, span_notice("Я перестал заряжать [target]."))

/obj/item/harmalarm
	name = "устройство звукового подавления"
	desc = "Позволяет дезориентировать большинство органических существ. Когда насилия СЛИШКОМ много."
	icon = 'icons/obj/device.dmi'
	icon_state = "megaphone"
	var/cooldown = 0

/obj/item/harmalarm/emag_act(mob/user)
	obj_flags ^= EMAGGED
	if(obj_flags & EMAGGED)
		to_chat(user, span_red("Я выключил предохранители на [src]!"))
	else
		to_chat(user, span_red("Я включаю предохранители на [src]!"))

/obj/item/harmalarm/attack_self(mob/user)
	var/safety = !(obj_flags & EMAGGED)
	if(cooldown > world.time)
		to_chat(user, span_red("Устройство всё ещё перезаряжается!"))
		return

	if(iscyborg(user))
		var/mob/living/silicon/robot/R = user
		if(!R.cell || R.cell.charge < 1200)
			to_chat(user, span_warning("Недостаточно заряда для активации устройства!"))
			return
		R.cell.charge -= 1000
		if(R.emagged)
			safety = FALSE

	if(safety == TRUE)
		user.visible_message(span_boldwarning("[user] издает оглушительную сирену из своих динамиков!"), \
			span_userdanger("Сирена оглушает вас и сбивает с толку!") , \
			span_danger("Сирена оглушает вас!"))
		for(var/mob/living/carbon/M in get_hearers_in_view(9, user))
			if(M.get_ear_protection() == FALSE)
				M.add_confusion(6)
		audible_message(span_boldwarning("HUMAN HARM")) //Специально оставил
		playsound(get_turf(src), 'sound/ai/harmalarm.ogg', 70, 3)
		cooldown = world.time + 200
		user.log_message("Использовал устройство звукового подавления в [AREACOORD(user)]", LOG_ATTACK)
		if(iscyborg(user))
			var/mob/living/silicon/robot/R = user
			to_chat(R.connected_ai, "<br><span class='notice'>NOTICE - Peacekeeping 'HARM ALARM' used by: [user]</span><br>")

		return

	if(safety == FALSE)
		user.audible_message(span_boldwarning("БЗЗЗЗЗЗЗЗЗЗЗЗЗЗЗЗЗЗЗЗЗ"))
		for(var/mob/living/carbon/C in get_hearers_in_view(9, user))
			var/bang_effect = C.soundbang_act(2, 0, 0, 5)
			switch(bang_effect)
				if(1)
					C.add_confusion(5)
					C.stuttering += 10
					C.Jitter(10)
				if(2)
					C.Paralyze(40)
					C.add_confusion(10)
					C.stuttering += 15
					C.Jitter(25)
		playsound(get_turf(src), 'sound/machines/warning-buzzer.ogg', 130, 3)
		cooldown = world.time + 600
		user.log_message("использовал взломанное устройство звукового подавления в [AREACOORD(user)]", LOG_ATTACK)

#define DISPENSE_LOLLIPOP_MODE 1
#define THROW_LOLLIPOP_MODE 2
#define THROW_GUMBALL_MODE 3
#define DISPENSE_ICECREAM_MODE 4

/obj/item/borg/lollipop
	name = "фабрикатор сладостей"
	desc = "Вознаграждайте людей сладостями. Модуль позволяет выбирать вид лакомства и скорость выдачи леденцов. "
	icon_state = "lollipop"
	var/candy = 30
	var/candymax = 30
	var/charge_delay = 10
	var/charging = FALSE
	var/mode = DISPENSE_LOLLIPOP_MODE

	var/firedelay = 0
	var/hitspeed = 2

/obj/item/borg/lollipop/clown

/obj/item/borg/lollipop/equipped()
	. = ..()
	check_amount()

/obj/item/borg/lollipop/dropped()
	. = ..()
	check_amount()

/obj/item/borg/lollipop/proc/check_amount()	//Doesn't even use processing ticks.
	if(charging)
		return
	if(candy < candymax)
		addtimer(CALLBACK(src, .proc/charge_lollipops), charge_delay)
		charging = TRUE

/obj/item/borg/lollipop/proc/charge_lollipops()
	candy++
	charging = FALSE
	check_amount()

/obj/item/borg/lollipop/proc/dispense(atom/A, mob/user)
	if(candy <= 0)
		to_chat(user, span_warning("Сладости закончились!"))
		return FALSE
	var/turf/T = get_turf(A)
	if(!T || !istype(T) || !isopenturf(T))
		return FALSE
	if(isobj(A))
		var/obj/O = A
		if(O.density)
			return FALSE

	var/obj/item/food_item
	switch(mode)
		if(DISPENSE_LOLLIPOP_MODE)
			food_item = new /obj/item/food/chewable/lollipop(T)
		if(DISPENSE_ICECREAM_MODE)
			food_item = new /obj/item/food/icecream(T)
			var/obj/item/food/icecream/I = food_item
			I.add_ice_cream("vanilla")
			I.desc = "Eat the ice cream."

	var/into_hands = FALSE
	if(ismob(A))
		var/mob/M = A
		into_hands = M.put_in_hands(food_item)

	candy--
	check_amount()

	if(into_hands)
		user.visible_message(span_notice("[user] дал леденец прямо в руку [A].") , span_notice("Я получил леденец от [A].") , span_hear("Я услышал щелчок."))
	else
		user.visible_message(span_notice("[user] произвел леденец.") , span_notice("Я сделал леденец.") , span_hear("Я услышал щелчок."))

	playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
	return TRUE

/obj/item/borg/lollipop/proc/shootL(atom/target, mob/living/user, params)
	if(candy <= 0)
		to_chat(user, span_warning("Недостаточно леденцов!"))
		return FALSE
	candy--

	var/obj/item/ammo_casing/caseless/lollipop/A
	var/mob/living/silicon/robot/R = user
	if(istype(R) && R.emagged)
		A = new /obj/item/ammo_casing/caseless/lollipop/harmful(src)
	else
		A = new /obj/item/ammo_casing/caseless/lollipop(src)

	playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
	A.fire_casing(target, user, params, 0, 0, null, 0, 0, 0, src)
	user.visible_message(span_warning("[user] выстрелил леденцом в [target]!"))
	check_amount()

/obj/item/borg/lollipop/proc/shootG(atom/target, mob/living/user, params)	//Most certainly a good idea.
	if(candy <= 0)
		to_chat(user, span_warning("Недостаточно жвачки!"))
		return FALSE
	candy--
	var/obj/item/ammo_casing/caseless/gumball/A
	var/mob/living/silicon/robot/R = user
	if(istype(R) && R.emagged)
		A = new /obj/item/ammo_casing/caseless/gumball/harmful(src)
	else
		A = new /obj/item/ammo_casing/caseless/gumball(src)

	A.loaded_projectile.color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	playsound(src.loc, 'sound/weapons/bulletflyby3.ogg', 50, TRUE)
	A.fire_casing(target, user, params, 0, 0, null, 0, 0, 0, src)
	user.visible_message(span_warning("[user] выстрелил в [target] жвачкой!"))
	check_amount()

/obj/item/borg/lollipop/afterattack(atom/target, mob/living/user, proximity, click_params)
	. = ..()
	check_amount()
	if(iscyborg(user))
		var/mob/living/silicon/robot/R = user
		if(!R.cell.use(12))
			to_chat(user, span_warning("Недостаточно энергии."))
			return FALSE
	switch(mode)
		if(DISPENSE_LOLLIPOP_MODE, DISPENSE_ICECREAM_MODE)
			if(!proximity)
				return FALSE
			dispense(target, user)
		if(THROW_LOLLIPOP_MODE)
			shootL(target, user, click_params)
		if(THROW_GUMBALL_MODE)
			shootG(target, user, click_params)

/obj/item/borg/lollipop/attack_self(mob/living/user)
	switch(mode)
		if(DISPENSE_LOLLIPOP_MODE)
			mode = THROW_LOLLIPOP_MODE
			to_chat(user, span_notice("Модуль переключен на стрельбу леденцами."))
		if(THROW_LOLLIPOP_MODE)
			mode = THROW_GUMBALL_MODE
			to_chat(user, span_notice("Модуль переключен на жвачку."))
		if(THROW_GUMBALL_MODE)
			mode = DISPENSE_ICECREAM_MODE
			to_chat(user, span_notice("Модуль переключён на мороженное."))
		if(DISPENSE_ICECREAM_MODE)
			mode = DISPENSE_LOLLIPOP_MODE
			to_chat(user, span_notice("Модуль теперь выдает леденцы."))
	..()

#undef DISPENSE_LOLLIPOP_MODE
#undef THROW_LOLLIPOP_MODE
#undef THROW_GUMBALL_MODE
#undef DISPENSE_ICECREAM_MODE

/obj/item/ammo_casing/caseless/gumball
	name = "жвачка"
	desc = "Почему вы смотрите на неё?!"
	projectile_type = /obj/projectile/bullet/reusable/gumball
	click_cooldown_override = 2

/obj/item/ammo_casing/caseless/gumball/harmful
	projectile_type = /obj/projectile/bullet/reusable/gumball/harmful

/obj/projectile/bullet/reusable/gumball
	name = "жвачка"
	desc = "О нет! Быстро летящая жвачка!"
	icon_state = "gumball"
	ammo_type = /obj/item/food/chewable/gumball/cyborg
	nodamage = TRUE
	damage = 0
	speed = 0.5

/obj/projectile/bullet/reusable/gumball/harmful
	ammo_type = /obj/item/food/chewable/gumball/cyborg
	nodamage = FALSE
	damage = 3

/obj/projectile/bullet/reusable/gumball/handle_drop()
	if(!dropped)
		var/turf/T = get_turf(src)
		var/obj/item/food/chewable/gumball/S = new ammo_type(T)
		S.color = color
		dropped = TRUE

/obj/item/ammo_casing/caseless/lollipop	//NEEDS RANDOMIZED COLOR LOGIC.
	name = "леденец"
	desc = "Почему вы смотрите на это?!"
	projectile_type = /obj/projectile/bullet/reusable/lollipop
	click_cooldown_override = 2

// rejected name: DumDum lollipop (get it, cause it embeds?)
/obj/item/ammo_casing/caseless/lollipop/harmful
	projectile_type = /obj/projectile/bullet/reusable/lollipop/harmful

/obj/projectile/bullet/reusable/lollipop
	name = "леденец"
	desc = "О нет, быстро летящий леденец!"
	icon_state = "lollipop_1"
	ammo_type = /obj/item/food/chewable/lollipop/cyborg
	nodamage = TRUE
	damage = 0
	speed = 0.5
	var/color2 = rgb(0, 0, 0)

/obj/projectile/bullet/reusable/lollipop/harmful
	embedding = list(embed_chance=35, fall_chance=2, jostle_chance=0, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.5, pain_mult=3, rip_time=10)
	damage = 3
	nodamage = FALSE
	embed_falloff_tile = 0

/obj/projectile/bullet/reusable/lollipop/Initialize(mapload)
	. = ..()
	var/obj/item/food/chewable/lollipop/S = new ammo_type(src)
	color2 = S.headcolor
	var/mutable_appearance/head = mutable_appearance('icons/obj/projectiles.dmi', "lollipop_2")
	head.color = color2
	add_overlay(head)

/obj/projectile/bullet/reusable/lollipop/handle_drop()
	if(!dropped)
		var/turf/T = get_turf(src)
		var/obj/item/food/chewable/lollipop/S = new ammo_type(T)
		S.change_head_color(color2)
		dropped = TRUE

/obj/item/cautery/prt //it's a subtype of cauteries so that it inherits the cautery sprites and behavior and stuff, because I'm too lazy to make sprites for this thing
	name = "инструмент для ремонта корпуса"
	desc = "Маленький инструмент, работающий от избыточного тепла киборга. Может быть использован как для ремонта, так и как зажигалка."
	toolspeed = 1.5 //it's not designed to be used as a cautery (although it's close enough to one to be considered to be a proper cautery instead of just a hot object for the purposes of surgery)
	heat = 3800 //this thing is intended for metal-shaping, so it's the same temperature as a lit welder
	resistance_flags = FIRE_PROOF //if it's channeling a cyborg's excess heat, it's probably fireproof
	force = 5
	damtype = BURN
	usesound = list('sound/items/welder.ogg', 'sound/items/welder2.ogg') //the usesounds of a lit welder
	hitsound = 'sound/items/welder.ogg' //the hitsound of a lit welder


#define PKBORG_DAMPEN_CYCLE_DELAY 20

//Peacekeeper Cyborg Projectile Dampenening Field
/obj/item/borg/projectile_dampen
	name = "кинетический демпфер"
	desc = "Устройство, излучающее поле для подавления различных предметов, движущихся с помощью кинетической энергии. <span class='boldnotice'> Расходует энергию, будучи включенным. </span> Является прототипом, поэтому имеет тенденцию наэлектризовывать незаземленные металлические поверхности."
	icon = 'icons/obj/device.dmi'
	icon_state = "shield"
	var/maxenergy = 1500
	var/energy = 1500
	/// Recharging rate in energy per second
	var/energy_recharge = 37.5
	var/energy_recharge_cyborg_drain_coefficient = 0.4
	var/cyborg_cell_critical_percentage = 0.05
	var/mob/living/silicon/robot/host = null
	var/datum/proximity_monitor/advanced/dampening_field
	var/projectile_damage_coefficient = 0.5
	/// Energy cost per tracked projectile damage amount per second
	var/projectile_damage_tick_ecost_coefficient = 10
	var/projectile_speed_coefficient = 1.5		//Higher the coefficient slower the projectile.
	/// Energy cost per tracked projectile per second
	var/projectile_tick_speed_ecost = 75
	var/list/obj/projectile/tracked
	var/image/projectile_effect
	var/field_radius = 3
	var/active = FALSE
	var/cycle_delay = 0

/obj/item/borg/projectile_dampen/debug
	maxenergy = 50000
	energy = 50000
	energy_recharge = 5000

/obj/item/borg/projectile_dampen/Initialize(mapload)
	. = ..()
	projectile_effect = image('icons/effects/fields.dmi', "projectile_dampen_effect")
	tracked = list()
	icon_state = "shield0"
	START_PROCESSING(SSfastprocess, src)
	host = loc
	RegisterSignal(host, COMSIG_LIVING_DEATH, .proc/on_death)

/obj/item/borg/projectile_dampen/proc/on_death(datum/source, gibbed)
	SIGNAL_HANDLER

	deactivate_field()

/obj/item/borg/projectile_dampen/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/item/borg/projectile_dampen/attack_self(mob/user)
	if(cycle_delay > world.time)
		to_chat(user, span_boldwarning("[capitalize(src.name)] всё ещё перезаряжает кинетический подавитель!"))
		return
	cycle_delay = world.time + PKBORG_DAMPEN_CYCLE_DELAY
	if(!active)
		if(!user.has_buckled_mobs())
			activate_field()
		else
			to_chat(user, span_warning("[capitalize(src.name)] защитные протоколы не позволяют мне включить кинетический подавитель из-за присутствия живых существ рядом!"))
	else
		deactivate_field()
	update_icon()
	to_chat(user, span_boldnotice("Я [active? "активирую":"деактивирую"] [src]."))

/obj/item/borg/projectile_dampen/update_icon_state()
	icon_state = "[initial(icon_state)][active]"

/obj/item/borg/projectile_dampen/proc/activate_field()
	if(istype(dampening_field))
		QDEL_NULL(dampening_field)
	dampening_field = make_field(/datum/proximity_monitor/advanced/peaceborg_dampener, list("current_range" = field_radius, "host" = src, "projector" = src))
	var/mob/living/silicon/robot/owner = get_host()
	if(owner)
		owner.module.allow_riding = FALSE
	active = TRUE

/obj/item/borg/projectile_dampen/proc/deactivate_field()
	QDEL_NULL(dampening_field)
	visible_message(span_warning("<b>[src.name]</b> shuts off!"))
	for(var/P in tracked)
		restore_projectile(P)
	active = FALSE

	var/mob/living/silicon/robot/owner = get_host()
	if(owner)
		owner.module.allow_riding = TRUE

/obj/item/borg/projectile_dampen/proc/get_host()
	if(istype(host))
		return host
	else
		if(iscyborg(host.loc))
			return host.loc
	return null

/obj/item/borg/projectile_dampen/dropped()
	. = ..()
	host = loc

/obj/item/borg/projectile_dampen/equipped()
	. = ..()
	host = loc

/obj/item/borg/projectile_dampen/cyborg_unequip(mob/user)
	deactivate_field()
	. = ..()

/obj/item/borg/projectile_dampen/process(delta_time)
	process_recharge(delta_time)
	process_usage(delta_time)
	update_location()

/obj/item/borg/projectile_dampen/proc/update_location()
	if(dampening_field)
		dampening_field.HandleMove()

/obj/item/borg/projectile_dampen/proc/process_usage(delta_time)
	var/usage = 0
	for(var/I in tracked)
		var/obj/projectile/P = I
		if(!P.stun && P.nodamage)	//No damage
			continue
		usage += projectile_tick_speed_ecost * delta_time
		usage += tracked[I] * projectile_damage_tick_ecost_coefficient * delta_time
	energy = clamp(energy - usage, 0, maxenergy)
	if(energy <= 0)
		deactivate_field()
		visible_message(span_warning("[capitalize(src.name)] blinks \"ENERGY DEPLETED\"."))

/obj/item/borg/projectile_dampen/proc/process_recharge(delta_time)
	if(!istype(host))
		if(iscyborg(host.loc))
			host = host.loc
		else
			energy = clamp(energy + energy_recharge * delta_time, 0, maxenergy)
			return
	if(host.cell && (host.cell.charge >= (host.cell.maxcharge * cyborg_cell_critical_percentage)) && (energy < maxenergy))
		host.cell.use(energy_recharge * delta_time * energy_recharge_cyborg_drain_coefficient)
		energy += energy_recharge * delta_time

/obj/item/borg/projectile_dampen/proc/dampen_projectile(obj/projectile/P, track_projectile = TRUE)
	if(tracked[P])
		return
	if(track_projectile)
		tracked[P] = P.damage
	P.damage *= projectile_damage_coefficient
	P.speed *= projectile_speed_coefficient
	P.add_overlay(projectile_effect)

/obj/item/borg/projectile_dampen/proc/restore_projectile(obj/projectile/P)
	tracked -= P
	P.damage *= (1/projectile_damage_coefficient)
	P.speed *= (1/projectile_speed_coefficient)
	P.cut_overlay(projectile_effect)

/**********************************************************************
						HUD/SIGHT things
***********************************************************************/
/obj/item/borg/sight
	var/sight_mode = null


/obj/item/borg/sight/xray
	name = "режим рентгеновского зрения"
	icon = 'icons/obj/decals.dmi'
	icon_state = "securearea"
	sight_mode = BORGXRAY

/obj/item/borg/sight/thermal
	name = "режим термального зрения"
	sight_mode = BORGTHERM
	icon_state = "thermal"


/obj/item/borg/sight/meson
	name = "режим мезонного зрения"
	sight_mode = BORGMESON
	icon_state = "meson"

/obj/item/borg/sight/material
	name = "режим для просмотра материалов"
	sight_mode = BORGMATERIAL
	icon_state = "material"

/obj/item/borg/sight/hud
	name = "худ"
	var/obj/item/clothing/glasses/hud/hud = null


/obj/item/borg/sight/hud/med
	name = "медицинский худ"
	icon_state = "healthhud"

/obj/item/borg/sight/hud/med/Initialize(mapload)
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/health(src)


/obj/item/borg/sight/hud/sec
	name = "худ безопастности"
	icon_state = "securityhud"

/obj/item/borg/sight/hud/sec/Initialize(mapload)
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/security(src)


/**********************************************************************
						Borg apparatus
***********************************************************************/
//These are tools that can hold only specific items. For example, the mediborg gets one that can only hold beakers and bottles.

/obj/item/borg/apparatus/
	name = "неизвестное устройство хранения"
	desc = "Этот модуль не выглядит рабочим."
	icon = 'icons/mob/robot_items.dmi'
	icon_state = "hugmodule"
	var/obj/item/stored
	var/list/storable = list()

/obj/item/borg/apparatus/Initialize(mapload)
	. = ..()
	RegisterSignal(loc.loc, COMSIG_BORG_SAFE_DECONSTRUCT, .proc/safedecon)

/obj/item/borg/apparatus/Destroy()
	if(stored)
		QDEL_NULL(stored)
	. = ..()

///If we're safely deconstructed, we put the item neatly onto the ground, rather than deleting it.
/obj/item/borg/apparatus/proc/safedecon()
	if(stored)
		stored.forceMove(get_turf(src))
		stored = null

/obj/item/borg/apparatus/Exited(atom/A)
	if(A == stored) //sanity check
		UnregisterSignal(stored, COMSIG_ATOM_UPDATE_ICON)
		stored = null
	update_icon()
	. = ..()

///A right-click verb, for those not using hotkey mode.
/obj/item/borg/apparatus/verb/verb_dropHeld()
	set category = "Объект"
	set name = "Drop"

	if(usr != loc || !stored)
		return
	stored.forceMove(get_turf(usr))
	return

/obj/item/borg/apparatus/attack_self(mob/living/silicon/robot/user)
	if(!stored)
		return ..()
	if(user.client?.keys_held["Alt"])
		stored.forceMove(get_turf(user))
		return
	stored.attack_self(user)

/obj/item/borg/apparatus/pre_attack(atom/A, mob/living/user, params)
	if(!stored)
		var/itemcheck = FALSE
		for(var/i in storable)
			if(istype(A, i))
				itemcheck = TRUE
				break
		if(itemcheck)
			var/obj/item/O = A
			O.forceMove(src)
			stored = O
			RegisterSignal(stored, COMSIG_ATOM_UPDATE_ICON, /atom/.proc/update_icon)
			update_icon()
			return
	else
		stored.melee_attack_chain(user, A, params)
		return
	. = ..()

/obj/item/borg/apparatus/attackby(obj/item/W, mob/user, params)
	if(stored)
		W.melee_attack_chain(user, stored, params)
		return
	. = ..()

/////////////////
//beaker holder//
/////////////////

/obj/item/borg/apparatus/beaker
	name = "манипулятор хим посуды"
	desc = "Специальное устройство для переноса хим посуды и пакетов с кровью без проливания. Нажмите Alt-z или щелкните правой кнопкой мыши, чтобы поставить посуду."
	icon_state = "borg_beaker_apparatus"
	storable = list(/obj/item/reagent_containers/glass/beaker,
				/obj/item/reagent_containers/glass/bottle,
				/obj/item/reagent_containers/blood,
				/obj/item/reagent_containers/chem_pack)

/obj/item/borg/apparatus/beaker/Initialize(mapload)
	. = ..()
	stored = new /obj/item/reagent_containers/glass/beaker/large(src)
	RegisterSignal(stored, COMSIG_ATOM_UPDATE_ICON, /atom/.proc/update_icon)
	update_icon()

/obj/item/borg/apparatus/beaker/Destroy()
	if(stored)
		var/obj/item/reagent_containers/C = stored
		C.SplashReagents(get_turf(src))
		QDEL_NULL(stored)
	. = ..()

/obj/item/borg/apparatus/beaker/examine()
	. = ..()
	if(stored)
		var/obj/item/reagent_containers/C = stored
		. += "<hr>The apparatus currently has [C] secured, which contains:"
		if(length(C.reagents.reagent_list))
			for(var/datum/reagent/R in C.reagents.reagent_list)
				. += "\n[R.volume] units of [R.name]"
		else
			. += "\nNothing."

/obj/item/borg/apparatus/beaker/update_overlays()
	. = ..()
	var/mutable_appearance/arm = mutable_appearance(icon = icon, icon_state = "borg_beaker_apparatus_arm")
	if(stored)
		COMPILE_OVERLAYS(stored)
		stored.pixel_x = 0
		stored.pixel_y = 0
		var/mutable_appearance/stored_copy = new /mutable_appearance(stored)
		if(istype(stored, /obj/item/reagent_containers/glass/beaker))
			arm.pixel_y = arm.pixel_y - 3
		stored_copy.layer = FLOAT_LAYER
		stored_copy.plane = FLOAT_PLANE
		. += stored_copy
	else
		arm.pixel_y = arm.pixel_y - 5
	. += arm

/obj/item/borg/apparatus/beaker/attack_self(mob/living/silicon/robot/user)
	if(stored && !user.client?.keys_held["Alt"] && user.a_intent != INTENT_HELP)
		var/obj/item/reagent_containers/C = stored
		C.SplashReagents(get_turf(user))
		loc.visible_message(span_notice("[user] разливает содержимое [C] на пол."))
		return
	. = ..()

/obj/item/borg/apparatus/beaker/extra
	name = "дополнительный манипулятор хим посуды"
	desc = "Дополнительное устройство хранения для хим посуды."

/obj/item/borg/apparatus/beaker/service
	name = "устройство для хранения напитков"
	desc = "Специальное устройство для переноса стаканов с напитками без проливания. Нажмите Alt-z или щелкните правой кнопкой мыши, чтобы поставить стакан."
	icon_state = "borg_beaker_apparatus"
	storable = list(/obj/item/reagent_containers/food/drinks/,
				/obj/item/reagent_containers/food/condiment)

/obj/item/borg/apparatus/beaker/service/Initialize(mapload)
	. = ..()
	stored = new /obj/item/reagent_containers/food/drinks/drinkingglass(src)
	RegisterSignal(stored, COMSIG_ATOM_UPDATE_ICON, /atom/.proc/update_icon)
	update_icon()

////////////////////
//engi part holder//
////////////////////

/obj/item/borg/apparatus/circuit
	name = "манипулятор плат"
	desc = "Специальное устройство, позволяющее работать с различными платами. Нажмите Alt-z или щелкните правой кнопкой мыши, чтобы положить плату."
	icon_state = "borg_hardware_apparatus"
	storable = list(/obj/item/circuitboard,
				/obj/item/electronics)

/obj/item/borg/apparatus/circuit/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/borg/apparatus/circuit/update_overlays()
	. = ..()
	var/mutable_appearance/arm = mutable_appearance(icon, "borg_hardware_apparatus_arm1")
	if(stored)
		COMPILE_OVERLAYS(stored)
		stored.pixel_x = -3
		stored.pixel_y = 0
		if(!istype(stored, /obj/item/circuitboard))
			arm.icon_state = "borg_hardware_apparatus_arm2"
		var/mutable_appearance/stored_copy = new /mutable_appearance(stored)
		stored_copy.layer = FLOAT_LAYER
		stored_copy.plane = FLOAT_PLANE
		. += stored_copy
	. += arm

/obj/item/borg/apparatus/circuit/examine()
	. = ..()
	if(stored)
		. += "<hr>В настоящее время в устройстве находится [stored]."

/obj/item/borg/apparatus/circuit/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(istype(A, /obj/item/ai_module) && !stored) //If an admin wants a borg to upload laws, who am I to stop them? Otherwise, we can hint that it fails
		to_chat(user, span_warning("This circuit board doesn't seem to have standard robot apparatus pin holes. You're unable to pick it up."))
