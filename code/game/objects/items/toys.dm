/* Toys!
 * Contains
 *		Balloons
 *		Fake singularity
 *		Toy gun
 *		Toy crossbow
 *		Toy swords
 *		Crayons
 *		Snap pops
 *		AI core prizes
 *		Toy codex gigas
 * 		Skeleton toys
 *		Cards
 *		Toy nuke
 *		Fake meteor
 *		Foam armblade
 *		Toy big red button
 *		Beach ball
 *		Toy xeno
 *      Kitty toys!
 *		Snowballs
 *		Clockwork Watches
 *		Toy Daggers
 *		Squeaky Brain
 *		Broken Radio
 */

/obj/item/toy
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	force = 0


/*
 * Balloons
 */
/obj/item/toy/waterballoon
	name = "водяной шар"
	desc = "Полупрозрачный воздушный шар. В нем ничего нет."
	icon = 'icons/obj/toy.dmi'
	icon_state = "waterballoon-e"
	inhand_icon_state = "balloon-empty"


/obj/item/toy/waterballoon/Initialize(mapload)
	. = ..()
	create_reagents(10)

/obj/item/toy/waterballoon/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/toy/waterballoon/attack(mob/living/carbon/human/M, mob/user)
	return

/obj/item/toy/waterballoon/afterattack(atom/A as mob|obj, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if (istype(A, /obj/structure/reagent_dispensers))
		var/obj/structure/reagent_dispensers/RD = A
		if(RD.reagents.total_volume <= 0)
			to_chat(user, span_warning("[RD] пуст."))
		else if(reagents.total_volume >= 10)
			to_chat(user, span_warning("[capitalize(src.name)] полон."))
		else
			A.reagents.trans_to(src, 10, transfered_by = user)
			to_chat(user, span_notice("Наполняю шарик [A]."))
			desc = "Полупрозрачный воздушный шар с какой-то жидкостью, плещущейся в нем."
			update_icon()

/obj/item/toy/waterballoon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(I.reagents)
			if(I.reagents.total_volume <= 0)
				to_chat(user, span_warning("[I] пуст."))
			else if(reagents.total_volume >= 10)
				to_chat(user, span_warning("[capitalize(src.name)] полон."))
			else
				desc = "Полупрозрачный воздушный шар с какой-то жидкостью, плещущейся в нем."
				to_chat(user, span_notice("Наполняю шарик [I]."))
				I.reagents.trans_to(src, 10, transfered_by = user)
				update_icon()
	else if(I.get_sharpness())
		balloon_burst()
	else
		return ..()

/obj/item/toy/waterballoon/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..()) //was it caught by a mob?
		balloon_burst(hit_atom)

/obj/item/toy/waterballoon/proc/balloon_burst(atom/AT)
	if(reagents.total_volume >= 1)
		var/turf/T
		if(AT)
			T = get_turf(AT)
		else
			T = get_turf(src)
		T.visible_message(span_danger("[capitalize(src.name)] взрывается!") ,span_hear("Вы слышите хлопок и всплеск."))
		reagents.expose(T)
		for(var/atom/A in T)
			reagents.expose(A)
		icon_state = "burst"
		qdel(src)

/obj/item/toy/waterballoon/update_icon_state()
	. = ..()
	if(src.reagents.total_volume >= 1)
		icon_state = "waterballoon"
		inhand_icon_state = "balloon"
	else
		icon_state = "waterballoon-e"
		inhand_icon_state = "balloon-empty"

#define BALLOON_COLORS list("red", "blue", "green", "yellow")

/obj/item/toy/balloon
	name = "воздушный шарик"
	desc = "Ни один день рождения не обходится без этого."
	icon = 'icons/obj/balloons.dmi'
	icon_state = "balloon"
	inhand_icon_state = "balloon"
	lefthand_file = 'icons/mob/inhands/balloons_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/balloons_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	force = 0
	var/random_color = TRUE

/obj/item/toy/balloon/Initialize(mapload)
	. = ..()
	if(random_color)
		var/chosen_balloon_color = pick(BALLOON_COLORS)
		name = "[chosen_balloon_color] [name]"
		icon_state = "[icon_state]_[chosen_balloon_color]"
		inhand_icon_state = icon_state

/obj/item/toy/balloon/corgi
	name = "шарик-корги"
	desc = "Воздушный шар с мордочкой корги на нем. Для хороших мальчиков."
	icon_state = "corgi"
	inhand_icon_state = "corgi"
	random_color = FALSE

/obj/item/toy/balloon/syndicate
	name = "синдикатский шарик"
	desc = "На задней стороне есть бирка с надписью \"НАХ НТ!11!\"."
	icon_state = "syndballoon"
	inhand_icon_state = "syndballoon"
	random_color = FALSE

/obj/item/toy/balloon/syndicate/pickup(mob/user)
	. = ..()
	if(user && user.mind && user.mind.has_antag_datum(/datum/antagonist, TRUE))
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "badass_antag", /datum/mood_event/badass_antag)

/obj/item/toy/balloon/syndicate/dropped(mob/user)
	if(user)
		SEND_SIGNAL(user, COMSIG_CLEAR_MOOD_EVENT, "badass_antag", /datum/mood_event/badass_antag)
	. = ..()


/obj/item/toy/balloon/syndicate/Destroy()
	if(ismob(loc))
		var/mob/M = loc
		SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "badass_antag", /datum/mood_event/badass_antag)
	. = ..()


/obj/item/toy/balloon/arrest
	name = "арестский шар"
	desc = "Наполовину надутый шар о бойзбенде под названием Арест, который был популярен лет десять назад и прославился тем, что высмеивал красные комбинезоны как немодные."
	icon_state = "arrestballoon"
	inhand_icon_state = "arrestballoon"
	random_color = FALSE

/*
 * Fake singularity
 */
/obj/item/toy/spinningtoy
	name = "гравитационная сингулярность"
	desc = "Вращающаяся игрушка бренда \"Сингуло\"."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s11"

/obj/item/toy/spinningtoy/suicide_act(mob/living/carbon/human/user)
	var/obj/item/bodypart/head/myhead = user.get_bodypart(BODY_ZONE_HEAD)
	if(!myhead)
		user.visible_message(span_suicide("[user] tries consuming [src]... but [user.ru_who()] [user.p_have()] no mouth!")) // and i must scream
		return SHAME
	user.visible_message(span_suicide("[user] consumes [src]! It looks like [user.p_theyre()] trying to commit suicicide!"))
	playsound(user, 'sound/items/eatfood.ogg', 50, TRUE)
	user.adjust_nutrition(50) // mmmm delicious
	addtimer(CALLBACK(src, PROC_REF(manual_suicide), user), (3SECONDS))
	return MANUAL_SUICIDE

/**
 * Internal function used in the toy singularity suicide
 *
 * Cavity implants the toy singularity into the body of the user (arg1), and kills the user.
 * Makes the user vomit and receive 120 suffocation damage if there already is a cavity implant in the user.
 * Throwing the singularity away will cause the user to start choking themself to death.
 * Arguments:
 * * user - Whoever is doing the suiciding
 */
/obj/item/toy/spinningtoy/proc/manual_suicide(mob/living/carbon/human/user)
	if(!user)
		return
	if(!user.is_holding(src)) // Half digestion? Start choking to death
		user.visible_message(span_suicide("[user] panics and starts choking [user.ru_na()]self to death!"))
		user.adjustOxyLoss(200)
		user.death(FALSE) // unfortunately you have to handle the suiciding yourself with a manual suicide
		user.ghostize(FALSE) // get the fuck out of our body
		return
	var/obj/item/bodypart/chest/CH = user.get_bodypart(BODY_ZONE_CHEST)
	if(CH.cavity_item) // if he's (un)bright enough to have a round and full belly...
		user.visible_message(span_danger("[user] regurgitates [src]!")) // I swear i dont have a fetish
		user.vomit(100, TRUE, distance = 0)
		user.adjustOxyLoss(120)
		user.dropItemToGround(src) // incase the crit state doesn't drop the singulo to the floor
		user.set_suicide(FALSE)
		return
	user.transferItemToLoc(src, user, TRUE)
	CH.cavity_item = src // The mother came inside and found Andy, dead with a HUGE belly full of toys
	user.adjustOxyLoss(200) // You know how most small toys in the EU have that 3+ onion head icon and a warning that says "Unsuitable for children under 3 years of age due to small parts - choking hazard"? This is why.
	user.death(FALSE)
	user.ghostize(FALSE)



/*
 * Toy gun: Why isn't this an /obj/item/gun?
 */
/obj/item/toy/gun
	name = "игрушечный пистолет"
	desc = "Почти как настоящий! Для детей от 8 лет и старше."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "revolver"
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=10)
	attack_verb_continuous = list("атакует", "пистолетирует", "бьёт", "колотит")
	attack_verb_simple = list("атакует", "пистолетирует", "бьёт", "колотит")
	var/bullets = 7

/obj/item/toy/gun/examine(mob/user)
	. = ..()
	. += "<hr>There [bullets == 1 ? "is" : "are"] [bullets] cap\s left."

/obj/item/toy/gun/attackby(obj/item/toy/ammo/gun/A, mob/user, params)

	if(istype(A, /obj/item/toy/ammo/gun))
		if (src.bullets >= 7)
			to_chat(user, span_warning("It's already fully loaded!"))
			return 1
		if (A.amount_left <= 0)
			to_chat(user, span_warning("There are no more caps!"))
			return 1
		if (A.amount_left < (7 - src.bullets))
			src.bullets += A.amount_left
			to_chat(user, text("<span class='notice'>You reload [] cap\s.</span>", A.amount_left))
			A.amount_left = 0
		else
			to_chat(user, text("<span class='notice'>You reload [] cap\s.</span>", 7 - src.bullets))
			A.amount_left -= 7 - src.bullets
			src.bullets = 7
		A.update_icon()
		return 1
	else
		return ..()

/obj/item/toy/gun/afterattack(atom/target as mob|obj|turf|area, mob/user, flag)
	. = ..()
	if (flag)
		return
	if (!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("У меня не хватает ловкости для этого!"))
		return
	src.add_fingerprint(user)
	if (src.bullets < 1)
		user.balloon_alert_to_viewers("*щёлк*")
		user.show_message(span_warning("*щёлк*") , MSG_AUDIBLE)
		playsound(src, 'sound/weapons/gun/revolver/dry_fire.ogg', 30, TRUE)
		return
	playsound(user, 'sound/weapons/gun/revolver/shot.ogg', 100, TRUE)
	src.bullets--
	user.visible_message(span_danger("<b>[user]</b> стреляет из <b>[src.name]</b> в <b>[target]</b>!") , \
		span_danger("Стреляю из <b>[src.name]</b> в <b>[target]</b>!") , \
		span_italics("Слышу выстрел!"))

/obj/item/toy/ammo/gun
	name = "Пистоны"
	desc = "Make sure to recyle the box in an autolathe when it gets empty."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "357OLD-7"
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=10)
	var/amount_left = 7

/obj/item/toy/ammo/gun/update_icon_state()
	. = ..()
	icon_state = "357OLD-[amount_left]"

/obj/item/toy/ammo/gun/examine(mob/user)
	. = ..()
	. += "<hr>There [amount_left == 1 ? "is" : "are"] [amount_left] cap\s left."

/*
 * Toy swords
 */
/obj/item/toy/sword
	name = "энергетический меч"
	desc = "Дешевая, пластиковая копия энергетического меча. Реалистичные звуки! Для детей от 8 лет и старше."
	icon_state = "e_sword"
	icon = 'icons/obj/transforming_energy.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("атакует", "вмазывает", "бьёт")
	attack_verb_simple = list("атакует", "вмазывает", "бьёт")
	var/hacked = FALSE
	/// The color of our fake energy sword
	var/saber_color = "blue"

/obj/item/toy/sword/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		throw_speed_on = throw_speed, \
		hitsound_on = 'sound/weapons/blade1.ogg', \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))


/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Updates our icon to have the correct color, and give some feedback.
 */
/obj/item/toy/sword/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(active)
		icon_state = "[icon_state]_[saber_color]"

	balloon_alert(user, "[active ? "выскакивает":"задвигает"] [src]")
	playsound(user ? user : src, active ? 'sound/weapons/saberon.ogg' : 'sound/weapons/saberoff.ogg', 20, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

// Copied from /obj/item/melee/energy/sword/attackby
/obj/item/toy/sword/attackby(obj/item/weapon, mob/living/user, params)
	if(istype(weapon, /obj/item/toy/sword))
		var/obj/item/toy/sword/attatched_sword = weapon
		if(HAS_TRAIT(weapon, TRAIT_NODROP))
			to_chat(user, span_warning("[weapon] прилип к руке, вы не можете прикрепить его к [src]!"))
			return
		else if(HAS_TRAIT(src, TRAIT_NODROP))
			to_chat(user, span_warning("[src] прилип к руке, вы не можете прикрепить его к [weapon]!"))
			return
		else
			to_chat(user, span_notice("Прикрепляю два пластиковых меча, чтобы получилась двойной игрушечный меч! Я фальшиво крут!"))
			var/obj/item/dualsaber/toy/new_saber = new /obj/item/dualsaber/toy(user.loc)
			if(attatched_sword.hacked || hacked)
				new_saber.hacked = TRUE
				new_saber.saber_color = "rainbow"
			qdel(weapon)
			qdel(src)
			user.put_in_hands(new_saber)
	else if(weapon.tool_behaviour == TOOL_MULTITOOL)
		if(hacked)
			to_chat(user, span_warning("Это и так прекрасно!"))
		else
			hacked = TRUE
			saber_color = "rainbow"
			to_chat(user, span_warning("RNBW_ENGAGE"))
	else
		return ..()

/*
 * Foam armblade
 */
/obj/item/toy/foamblade
	name = "пенопластовая рука-лезвие"
	desc = "На ней написано \"Sternside Changs #1 fan\"."
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamblade"
	inhand_icon_state = "arm_blade"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	attack_verb_continuous = list("протыкает", "пожирает", "унижает")
	attack_verb_simple = list("протыкает", "пожирает", "унижает")
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE


/obj/item/toy/windup_toolbox
	name = "заводной ящик с инструментами"
	desc = "Игрушечный ящик для инструментов, который издает звук при повороте ключа."
	icon_state = "his_grace"
	inhand_icon_state = "artistic_toolbox"
	lefthand_file = 'icons/mob/inhands/equipment/toolbox_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/toolbox_righthand.dmi'
	var/active = FALSE
	icon = 'icons/obj/items_and_weapons.dmi'
	hitsound = 'sound/weapons/smash.ogg'
	attack_verb_continuous = list("робастит")
	attack_verb_simple = list("робастит")

/obj/item/toy/windup_toolbox/attack_self(mob/user)
	if(!active)
		icon_state = "his_grace_awakened"
		to_chat(user, span_notice("Поворачиваю ключ у [src], он начинает грохотать."))
		active = TRUE
		playsound(src, 'sound/effects/pope_entry.ogg', 100)
		Rumble()
		addtimer(CALLBACK(src, PROC_REF(stopRumble)), 600)
	else
		to_chat(user, span_warning("[capitalize(src.name)] уже активен!"))

/obj/item/toy/windup_toolbox/proc/Rumble()
	var/static/list/transforms
	if(!transforms)
		var/matrix/M1 = matrix()
		var/matrix/M2 = matrix()
		var/matrix/M3 = matrix()
		var/matrix/M4 = matrix()
		M1.Translate(-1, 0)
		M2.Translate(0, 1)
		M3.Translate(1, 0)
		M4.Translate(0, -1)
		transforms = list(M1, M2, M3, M4)
	animate(src, transform=transforms[1], time=0.2, loop=-1)
	animate(transform=transforms[2], time=0.1)
	animate(transform=transforms[3], time=0.2)
	animate(transform=transforms[4], time=0.3)

/obj/item/toy/windup_toolbox/proc/stopRumble()
	icon_state = initial(icon_state)
	active = FALSE
	animate(src, transform=matrix())

/*
 * Subtype of Double-Bladed Energy Swords
 */
/obj/item/dualsaber/toy
	name = "двойной энергетический меч"
	desc = "Дешевая пластиковая копия ДВУХ энергетических мечей. Двойное удовольствие!"
	force = 0
	throwforce = 0
	throw_speed = 3
	throw_range = 5
	two_hand_force = 0
	attack_verb_continuous = list("атакует", "struck", "бьёт")
	attack_verb_simple = list("атакует", "struck", "бьёт")

/obj/item/dualsaber/toy/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "атаку", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	return 0

/obj/item/dualsaber/toy/IsReflect() //Stops Toy Dualsabers from reflecting energy projectiles
	return 0

/obj/item/dualsaber/toy/impale(mob/living/user)//Stops Toy Dualsabers from injuring clowns
	to_chat(user, span_warning("You twirl around a bit before losing your balance and impaling yourself on [src]."))
	user.adjustStaminaLoss(25)

/obj/item/toy/katana
	name = "игрушечная катана"
	desc = "Удручающе маломощный в D20."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "katana"
	inhand_icon_state = "katana"
	worn_icon_state = "katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("атакует", "режет", "втыкает", "рубит")
	attack_verb_simple = list("атакует", "режет", "втыкает", "рубит")
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'

/*
 * Snap pops
 */

/obj/item/toy/snappop
	name = "хлопочек"
	desc = "Вау!"
	icon = 'icons/obj/toy.dmi'
	icon_state = "snappop"
	w_class = WEIGHT_CLASS_TINY
	var/ash_type = /obj/effect/decal/cleanable/ash

/obj/item/toy/snappop/proc/pop_burst(n=3, c=1)
	var/datum/effect_system/spark_spread/s = new()
	s.set_up(n, c, src)
	s.start()
	new ash_type(loc)
	visible_message(span_warning("[capitalize(src.name)] хлопает!") ,
		span_hear("Слышу хлопок!"))
	playsound(src, 'sound/effects/snap.ogg', 50, TRUE)
	qdel(src)

/obj/item/toy/snappop/fire_act(exposed_temperature, exposed_volume)
	pop_burst()

/obj/item/toy/snappop/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		pop_burst()

/obj/item/toy/snappop/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/toy/snappop/proc/on_entered(datum/source, H as mob|obj)
	SIGNAL_HANDLER
	if(ishuman(H) || issilicon(H)) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		if(issilicon(H) || M.m_intent == MOVE_INTENT_RUN)
			to_chat(M, span_danger("You step on the snap pop!"))
			pop_burst(2, 0)

/obj/item/toy/snappop/phoenix
	name = "фениксовый хлопочек"
	desc = "Вау! И вау! И вау! И вау!"
	ash_type = /obj/effect/decal/cleanable/ash/snappop_phoenix

/obj/effect/decal/cleanable/ash/snappop_phoenix
	var/respawn_time = 300

/obj/effect/decal/cleanable/ash/snappop_phoenix/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(respawn)), respawn_time)

/obj/effect/decal/cleanable/ash/snappop_phoenix/proc/respawn()
	new /obj/item/toy/snappop/phoenix(get_turf(src))
	qdel(src)

/obj/item/toy/talking
	name = "говорящая фигурка"
	desc = "Обычная фигурка, созданная по образцу ничего конкретного."
	icon = 'icons/obj/toy.dmi'
	icon_state = "owlprize"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = FALSE
	var/messages = list("I'm super generic!", "Mathematics class is of variable difficulty!")
	var/span = "danger"
	var/recharge_time = 30

	var/chattering = FALSE
	var/phomeme

// Talking toys are language universal, and thus all species can use them
/obj/item/toy/talking/attack_alien(mob/user)
	return attack_hand(user)

/obj/item/toy/talking/attack_self(mob/user)
	if(!cooldown)
		activation_message(user)
		playsound(loc, 'sound/machines/click.ogg', 20, TRUE)

		INVOKE_ASYNC(src, PROC_REF(do_toy_talk), user)

		cooldown = TRUE
		addtimer(VARSET_CALLBACK(src, cooldown, FALSE), recharge_time)
		return
	..()

/obj/item/toy/talking/proc/activation_message(mob/user)
	user.visible_message(
		span_notice("[user] pulls the string on <b>[src.name]</b>.") ,
		span_notice("You pull the string on <b>[src.name]</b>.") ,
		span_notice("You hear a string being pulled."))

/obj/item/toy/talking/proc/generate_messages()
	return list(pick(messages))

/obj/item/toy/talking/proc/do_toy_talk(mob/user)
	for(var/message in generate_messages())
		toy_talk(user, message)
		sleep(10)

/obj/item/toy/talking/proc/toy_talk(mob/user, message)
	user.loc.visible_message("<span class='[span]'>[icon2html(src, viewers(user.loc))] [message]</span>")
	if(chattering)
		chatter(message, phomeme, user)

/*
 * AI core prizes
 */
/obj/item/toy/talking/ai
	name = "игрушечный ИИ"
	desc = "Маленькая игрушечная модель ядра ИИ с законами!"
	icon_state = JOB_AI
	w_class = WEIGHT_CLASS_SMALL

/obj/item/toy/talking/ai/generate_messages()
	return list(generate_ion_law())

/obj/item/toy/talking/codex_gigas
	name = "Игрушечный Кодекс Гигаса"
	desc = "Инструмент, который поможет вам выявить вымышленных дьяволов!"
	icon = 'icons/obj/library.dmi'
	icon_state = "demonomicon"
	lefthand_file = 'icons/mob/inhands/misc/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/books_righthand.dmi'
	messages = list("You must challenge the devil to a dance-off!", "The devils true name is Ian", "The devil hates salt!", "Would you like infinite power?", "Would you like infinite  wisdom?", " Would you like infinite healing?")
	w_class = WEIGHT_CLASS_SMALL
	recharge_time = 60

/obj/item/toy/talking/codex_gigas/activation_message(mob/user)
	user.visible_message(
		span_notice("[user] нажимает кнопку на <b>[src.name]</b>.") ,
		span_notice("Нажимаю кнопочку на <b>[src.name]</b>.") ,
		span_notice("Слышу мягкий щелчок."))

/obj/item/toy/talking/owl
	name = "фигурка совы"
	desc = "Фигурка в виде совы, защитницы правосудия."
	icon_state = "owlprize"
	messages = list("На этот раз тебе не удастся уйти, Гриффин!", "Стоять на месте, преступник!", "У-у! У-у!", "Я сама ночь!")
	chattering = TRUE
	phomeme = "owl"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/toy/talking/griffin
	name = "фигурка грифона"
	desc = "Фигурка, созданная по образу и подобию 'Грифона', криминального авторитета."
	icon_state = "griffinprize"
	messages = list("Ты не сможешь остановить меня, Сова!", "Мой план безупречен! Хранилище - мое!", "Ка-а-а-ау-у-у-у-у!", "Ты никогда не поймаешь меня!")
	chattering = TRUE
	phomeme = "griffin"
	w_class = WEIGHT_CLASS_SMALL

/*
 * Fake nuke
 */

/obj/item/toy/nuke
	name = "игрушечная ядерная бомба"
	desc = "Пластиковая модель ядерной бомбы."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nuketoyidle"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0

/obj/item/toy/nuke/attack_self(mob/user)
	if (obj_flags & EMAGGED && cooldown < world.time)
		cooldown = world.time + 600
		user.visible_message(span_hear("Слышу щелчок кнопки.") , span_notice("Активирую [src], и оно воспроизводит громкий звук!"))
		sleep(5)
		playsound(src, 'sound/machines/alarm.ogg', 20, FALSE)
		sleep(140)
		user.visible_message(span_alert("[capitalize(src.name)] мощно взрывается!"))
		explosion(src, light_impact_range = 1)
		qdel(src)
	else if (cooldown < world.time)
		cooldown = world.time + 600 //1 minute
		user.visible_message(span_warning("[user] нажимает кнопку на [src].") , span_notice("Активирую [src], и оно воспроизводит громкий звук!") , span_hear("Вы слышите щелчок кнопки."))
		sleep(5)
		icon_state = "nuketoy"
		playsound(src, 'sound/machines/alarm.ogg', 20, FALSE)
		sleep(135)
		icon_state = "nuketoycool"
		sleep(cooldown - world.time)
		icon_state = "nuketoyidle"
	else
		var/timeleft = (cooldown - world.time)
		to_chat(user, span_alert("Ничего не происходит, и появляется таймер '</span>[round(timeleft/10)]<span class='alert'>' на маленьком дисплее."))
		sleep(5)


/obj/item/toy/nuke/emag_act(mob/user)
	if (obj_flags & EMAGGED)
		return
	to_chat(user, "<span class = 'notice'> Замыкаю <b>[src.name]</b>.</span>")
	obj_flags |= EMAGGED
/*
 * Fake meteor
 */

/obj/item/toy/minimeteor
	name = "Мини-метеор"
	desc = "Переживите метеоритный дождь! Корпорация SweetMeat-eor не несет ответственности за любые травмы, головные боли или потерю слуха, вызванные Мини-Метеором."
	icon = 'icons/obj/toy.dmi'
	icon_state = "minimeteor"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/toy/minimeteor/emag_act(mob/user)
	if (obj_flags & EMAGGED)
		return
	to_chat(user, "<span class = 'notice'> Вы замыкаете всю электронику внутри <b>[src.name]</b>, если они там вообще были.</span>")
	obj_flags |= EMAGGED

/obj/item/toy/minimeteor/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if (obj_flags & EMAGGED)
		playsound(src, 'sound/effects/meteorimpact.ogg', 40, TRUE)
		explosion(src, devastation_range = -1, heavy_impact_range = -1, light_impact_range = 1)
		for(var/mob/M in urange(10, src))
			if(!M.stat && !isAI(M))
				shake_camera(M, 3, 1)
	else
		playsound(src, 'sound/effects/meteorimpact.ogg', 40, TRUE)
		for(var/mob/M in urange(10, src))
			if(!M.stat && !isAI(M))
				shake_camera(M, 3, 1)

/*
 * Toy big red button
 */
/obj/item/toy/redbutton
	name = "большая красная кнопка"
	desc = "Большая пластиковая красная кнопка. На обратной стороне написано 'От HonkCo Pranks!'."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "bigred"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0

/obj/item/toy/redbutton/attack_self(mob/user)
	if (cooldown < world.time)
		cooldown = (world.time + 300) // Sets cooldown at 30 seconds
		user.visible_message(span_warning("[user] нажимает на большую красную кнопку.") , span_notice("Вы нажимаете на кнопку, и она воспроизводит громкий звук!") , span_hear("Кнопка громко щелкает."))
		playsound(src, pick(FAR_EXPLOSION_SOUNDS), 50, FALSE)
		for(var/mob/M in urange(10, src)) // Checks range
			if(!M.stat && !isAI(M)) // Checks to make sure whoever's getting shaken is alive/not the AI
				// Short delay to match up with the explosion sound
				// Shakes player camera 2 squares for 1 second.
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shake_camera), M, 2, 1), 0.8 SECONDS)

	else
		to_chat(user, span_alert("Ничего не происходит."))

/*
 * Snowballs
 */

/obj/item/toy/snowball
	name = "снежный шар"
	desc = "Шар из снега. Хорошо подходит для бросания в людей."
	icon = 'icons/obj/toy.dmi'
	icon_state = "snowball"
	throwforce = 20 //the same damage as a disabler shot
	damtype = STAMINA //maybe someday we can add stuffing rocks (or perhaps ore?) into snowballs to make them deal brute damage

/obj/item/toy/snowball/afterattack(atom/target as mob|obj|turf|area, mob/user)
	. = ..()
	if(user.dropItemToGround(src))
		throw_at(target, throw_range, throw_speed)

/obj/item/toy/snowball/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		playsound(src, 'sound/effects/pop.ogg', 20, TRUE)
		qdel(src)

/*
 * Beach ball
 */
/obj/item/toy/beach_ball
	name = "пляжный мячик"
	desc = "Господа... позвольте прописать с ноги!"
	icon = 'icons/misc/beach.dmi'
	icon_state = "ball"
	inhand_icon_state = "beachball"
	w_class = WEIGHT_CLASS_BULKY //Stops people from hiding it in their bags/pockets

/*
 * Clockwork Watch
 */

/obj/item/toy/clockwork_watch
	name = "стимпанковые часы"
	desc = "Стильные часы в стиле стимпанк, сделанные из тысяч крошечных зубчатых колес."
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "dread_ipad"
	worn_icon_state = "dread_ipad"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0

/obj/item/toy/clockwork_watch/attack_self(mob/user)
	if (cooldown < world.time)
		cooldown = world.time + 1800 //3 minutes
		user.visible_message(span_warning("[user] вращает зубчатое колесо на [src].") , span_notice("Вращаю зубчатое колесо в [src], и оно издает громкий звук!") , span_hear("Слышу, как вращаются зубчатые колеса."))
		playsound(src, 'sound/magic/clockwork/ark_activation.ogg', 50, FALSE)
	else
		to_chat(user, span_alert("Шестеренки уже вращаются!"))

/obj/item/toy/clockwork_watch/examine(mob/user)
	. = ..()
	. += "<hr><span class='info'>Станционное время: [station_time_timestamp()]</span>"

/*
 * Toy Dagger
 */

/obj/item/toy/toy_dagger
	name = "игрушечный кинжал"
	desc = "Дешевая пластиковая копия кинжала. Произведено компанией THE ARM Toys, Inc."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	inhand_icon_state = "cultdagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL

/*
 * Xenomorph action figure
 */

/obj/item/toy/toy_xeno
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_xeno"
	name = "игрушечная фигурка ксеноморфа"
	desc = "MEGA представляет новую фигурку Xenos Isolated! Поставляется в комплекте с реалистичными звуками! Оттяните шнурок, чтобы использовать."
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0

/obj/item/toy/toy_xeno/attack_self(mob/user)
	if(cooldown <= world.time)
		cooldown = (world.time + 50) //5 second cooldown
		user.visible_message(span_notice("[user] оттягивает шнурок на  [src]."))
		icon_state = "[initial(icon_state)]_used"
		sleep(5)
		audible_message(span_danger("[icon2html(src, viewers(src))] Ш-ш-ш!"))
		var/list/possible_sounds = list('sound/voice/hiss1.ogg', 'sound/voice/hiss2.ogg', 'sound/voice/hiss3.ogg', 'sound/voice/hiss4.ogg')
		var/chosen_sound = pick(possible_sounds)
		playsound(get_turf(src), chosen_sound, 50, TRUE)
		addtimer(VARSET_CALLBACK(src, icon_state, "[initial(icon_state)]"), 4.5 SECONDS)
	else
		to_chat(user, span_warning("Шнурок на  [src] ещё не перемотался до конца!"))
		return

// TOY MOUSEYS :3 :3 :3

/obj/item/toy/cattoy
	name = "игрушечная мышь"
	desc = "Яркая игрушечная мышка!"
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_mouse"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0
	resistance_flags = FLAMMABLE


/*
 * Action Figures
 */

/obj/item/toy/figure
	name = "Какая-то хуйня. Сообщите кодерам."
	desc = null
	icon = 'icons/obj/toy.dmi'
	icon_state = "nuketoy"
	var/cooldown = 0
	var/toysay = "What the fuck did you do?"
	var/toysound = 'sound/machines/click.ogg'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/toy/figure/Initialize(mapload)
	. = ..()
	desc = "Бренд \"Космическая Жизнь\" [src]."

/obj/item/toy/figure/attack_self(mob/user as mob)
	if(cooldown <= world.time)
		cooldown = world.time + 50
		to_chat(user, span_notice("[capitalize(src.name)] говорит \"[toysay]\""))
		playsound(user, toysound, 20, TRUE)

/obj/item/toy/figure/cmo
	name = "фигурка СМО"
	icon_state = "cmo"
	toysay = "Сенсоры в третий режим!"

/obj/item/toy/figure/assistant
	name = "фигурка ассистента"
	icon_state = "assistant"
	inhand_icon_state = "assistant"
	toysay = "Вперёд на бриг!"

/obj/item/toy/figure/atmos
	name = "фигурка атмостеха"
	icon_state = "atmos"
	toysay = "За Атмосию!"

/obj/item/toy/figure/bartender
	name = "фигурка бармена"
	icon_state = "bartender"
	toysay = "Где Пун-Пун?"

/obj/item/toy/figure/borg
	name = "фигурка киборга"
	icon_state = "borg"
	toysay = "I. LIVE. AGAIN."
	toysound = 'sound/voice/liveagain.ogg'

/obj/item/toy/figure/botanist
	name = "фигурка ботаниста"
	icon_state = "botanist"
	toysay = "Сжечь его!"

/obj/item/toy/figure/captain
	name = "фигурка капитана"
	icon_state = "captain"
	toysay = "Есть главы?"

/obj/item/toy/figure/cargotech
	name = "фигурка карготехника"
	icon_state = "cargotech"
	toysay = "За Каргонию!"

/obj/item/toy/figure/ce
	name = "фигурка СЕ"
	icon_state = "ce"
	toysay = "Настройте соляры!"

/obj/item/toy/figure/chaplain
	name = "фигурка священника"
	icon_state = "chaplain"
	toysay = "Слава Космическому Иисусу!"

/obj/item/toy/figure/chef
	name = "фигурка повара"
	icon_state = "chef"
	toysay = "Я сделаю из тебя бургер!"

/obj/item/toy/figure/chemist
	name = "фигурка химика"
	icon_state = "chemist"
	toysay = "Прими таблетки!"

/obj/item/toy/figure/clown
	name = "фигурка клоуна"
	icon_state = "clown"
	toysay = "Хонк!"
	toysound = 'sound/items/bikehorn.ogg'

/obj/item/toy/figure/ian
	name = "фигурка Иана"
	icon_state = "ian"
	toysay = "Гав!"

/obj/item/toy/figure/detective
	name = "фигурка детектива"
	icon_state = "detective"
	toysay = "На этом шлюзе серый комбинезон и волокна  изоляционных перчаток."

/obj/item/toy/figure/dsquad
	name = "фигурка члена отряда смерти"
	icon_state = "dsquad"
	toysay = "Не оставляйте свидетелей!"

/obj/item/toy/figure/engineer
	name = "фигурка инженера"
	icon_state = "engineer"
	toysay = "Сингулярность сбежала!"

/obj/item/toy/figure/geneticist
	name = "фигурка генетика"
	icon_state = "geneticist"
	toysay = "Халк крушить!"

/obj/item/toy/figure/hop
	name = "фигурка главы персонала"
	icon_state = "hop"
	toysay = "Раздача доступа!"

/obj/item/toy/figure/hos
	name = "фигурка главы охраны"
	icon_state = "hos"
	toysay = "Давай, сделай мне приятно."

/obj/item/toy/figure/qm
	name = "фигурка квартирмейстера"
	icon_state = "qm"
	toysay = "Пожалуйста, подпишите эту форму в трех экземплярах, и мы позаботимся о предоставлении вам сварочной маски в течение 3 рабочих дней."

/obj/item/toy/figure/janitor
	name = "фигурка уборщика"
	icon_state = "janitor"
	toysay = "Смотри на знаки, идиот."

/obj/item/toy/figure/lawyer
	name = "фигурка адвоката"
	icon_state = "lawyer"
	toysay = "Мой клиент - грязный агент!"

/obj/item/toy/figure/curator
	name = "фигурка куратора"
	icon_state = "curator"
	toysay = "Однажды, когда..."

/obj/item/toy/figure/md
	name = "фигурка медицинского доктора"
	icon_state = "md"
	toysay = "Пациент уже мертв!"

/obj/item/toy/figure/paramedic
	name = "фигурка парамедика"
	icon_state = "paramedic"
	toysay = "И что самое интересное? Я даже не настоящий врач!"

/obj/item/toy/figure/mime
	name = "фигурка мима"
	icon_state = "mime"
	toysay = "..."
	toysound = null

/obj/item/toy/figure/miner
	name = "фигурка шахтёра"
	icon_state = "miner"
	toysay = "КОЛОСС ПРЯМО СПРАВА ОТ БАЗЫ!"

/obj/item/toy/figure/ninja
	name = "фигурка ниндзи"
	icon_state = "ninja"
	toysay = "О боже! Прекратите стрелять, я мирный!"

/obj/item/toy/figure/wizard
	name = "фигурка волшебника"
	icon_state = "wizard"
	toysay = "Ei Nath!"
	toysound = 'sound/magic/disintegrate.ogg'

/obj/item/toy/figure/rd
	name = "фигурка руководителя исследований"
	icon_state = "rd"
	toysay = "Взрываю всех боргов!"

/obj/item/toy/figure/roboticist
	name = "фигурка робототехника"
	icon_state = "roboticist"
	toysay = "Большие топчущие мехи!"
	toysound = 'sound/mecha/mechstep.ogg'

/obj/item/toy/figure/scientist
	name = "фигурка ученого"
	icon_state = "scientist"
	toysay = "БУМ."
	toysound = 'sound/effects/explosionfar.ogg'

/obj/item/toy/figure/syndie
	name = "фигурка оперативника синдиката"
	icon_state = "syndie"
	toysay = "Достаньте этот ёбаный диск!"

/obj/item/toy/figure/secofficer
	name = "фигурка офицера СБ"
	icon_state = "secofficer"
	toysay = "Я закон!"
	toysound = 'sound/runtime/complionator/dredd.ogg'

/obj/item/toy/figure/virologist
	name = "фигурка вирусолога"
	icon_state = "virologist"
	toysay = "Лекарство - калий!"

/obj/item/toy/figure/warden
	name = "фигурка надзирателя"
	icon_state = "warden"
	toysay = "Семнадцать минут за кашель на офицера!"


/obj/item/toy/dummy
	name = "кукла чревовещателя"
	desc = "It's a dummy, dummy."
	icon = 'icons/obj/toy.dmi'
	icon_state = "puppet"
	inhand_icon_state = "puppet"
	var/doll_name = "Dummy"

//Add changing looks when i feel suicidal about making 20 inhands for these.
/obj/item/toy/dummy/attack_self(mob/user)
	var/new_name = stripped_input(usr,"Как назовем куклу?","Введите имя",doll_name,MAX_NAME_LEN)
	if(!new_name)
		return
	doll_name = new_name
	to_chat(user, span_notice("Называю куклу \"[doll_name]\"."))
	name = "[initial(name)] - [doll_name]"

/obj/item/toy/dummy/talk_into(atom/movable/A, message, channel, list/spans, datum/language/language, list/message_mods)
	var/mob/M = A
	if (istype(M))
		M.log_talk(message, LOG_SAY, tag="кукла")

	say(message, language)
	return NOPASS

/obj/item/toy/dummy/GetVoice()
	return doll_name

/obj/item/toy/seashell
	name = "ракушка"
	desc = "Пусть у вас всегда будет ракушка в кармане и песок в ботинках. Что бы это ни означало."
	icon = 'icons/misc/beach.dmi'
	icon_state = "shell1"
	var/static/list/possible_colors = list("" =  2, COLOR_PURPLE_GRAY = 1, COLOR_OLIVE = 1, COLOR_PALE_BLUE_GRAY = 1, COLOR_RED_GRAY = 1)

/obj/item/toy/seashell/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	icon_state = "shell[rand(1,3)]"
	color = pick_weight(possible_colors)
	setDir(pick(GLOB.cardinals))

/obj/item/toy/brokenradio
	name = "сломанное радио"
	desc = "Старый радиоприемник, который при включении не производит ничего, кроме помех."
	icon = 'icons/obj/toy.dmi'
	icon_state = "broken_radio"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0

/obj/item/toy/brokenradio/attack_self(mob/user)
	if(cooldown <= world.time)
		cooldown = (world.time + 300)
		user.visible_message(span_notice("[user] настраивает циферблат на [src]."))
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), src, 'sound/items/radiostatic.ogg', 50, FALSE), 0.5 SECONDS)
	else
		to_chat(user, span_warning("Циферблат на [src] застревает."))
		return

/obj/item/toy/braintoy
	name = "игрушечный мозг"
	desc = "Игрушка марки Mr. Monstrous, сделанная для имитации человеческого мозга по запаху и текстуре."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain-old"
	var/cooldown = 0

/obj/item/toy/braintoy/attack_self(mob/user)
	if(cooldown <= world.time)
		cooldown = (world.time + 10)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), src, 'sound/effects/blobattack.ogg', 50, FALSE), 0.5 SECONDS)

/*
 * Eldritch Toys
 */

/obj/item/toy/eldritch_book
	name = "Codex Cicatrix"
	desc = "A toy book that closely resembles the Codex Cicatrix. Covered in fake polyester human flesh and has a huge goggly eye attached to the cover. The runes are gibberish and cannot be used to summon demons... Hopefully?"
	icon = 'icons/obj/eldritch.dmi'
	icon_state = "book"
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("sacrifices", "transmutes", "graspes", "curses")
	attack_verb_simple = list("sacrifice", "transmute", "grasp", "curse")
	/// Helps determine the icon state of this item when it's used on self.
	var/book_open = FALSE

/obj/item/toy/eldritch_book/attack_self(mob/user)
	book_open = !book_open
	update_appearance()

/obj/item/toy/eldritch_book/update_icon_state()
	. = ..()
	icon_state = book_open ? "book_open" : "book"
	return ..()

/*
 * Fake tear
 */

/obj/item/toy/reality_pierce
	name = "Pierced reality"
	desc = "Hah. You thought it was the real deal!"
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "pierced_illusion"
	item_flags = NO_PIXEL_RANDOM_DROP

/obj/item/storage/box/heretic_box
	name = "box of pierced realities"
	desc = "A box containing toys resembling pierced realities."

/obj/item/storage/box/heretic_box/PopulateContents()
	for(var/i in 1 to rand(1,4))
		new /obj/item/toy/reality_pierce(src)

/obj/item/toy/foamfinger
	name = "foam finger"
	desc = "root for the home team! wait, does this station even have a sports team?"
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "foamfinger"
	inhand_icon_state = "foamfinger_inhand"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	COOLDOWN_DECLARE(foamfinger_cooldown)

/obj/item/toy/foamfinger/attack_self(mob/living/carbon/human/user)
	if(!COOLDOWN_FINISHED(src, foamfinger_cooldown))
		return
	COOLDOWN_START(src, foamfinger_cooldown, 5 SECONDS)
	user.manual_emote("waves around the foam finger.")
	var/direction = prob(50) ? -1 : 1
	if(NSCOMPONENT(user.dir)) //So signs are waved horizontally relative to what way the player waving it is facing.
		animate(user, pixel_x = user.pixel_x + (1 * direction), time = 1, easing = SINE_EASING)
		animate(pixel_x = user.pixel_x - (2 * direction), time = 1, easing = SINE_EASING)
		animate(pixel_x = user.pixel_x + (2 * direction), time = 1, easing = SINE_EASING)
		animate(pixel_x = user.pixel_x - (2 * direction), time = 1, easing = SINE_EASING)
		animate(pixel_x = user.pixel_x + (1 * direction), time = 1, easing = SINE_EASING)
	else
		animate(user, pixel_y = user.pixel_y + (1 * direction), time = 1, easing = SINE_EASING)
		animate(pixel_y = user.pixel_y - (2 * direction), time = 1, easing = SINE_EASING)
		animate(pixel_y = user.pixel_y + (2 * direction), time = 1, easing = SINE_EASING)
		animate(pixel_y = user.pixel_y - (2 * direction), time = 1, easing = SINE_EASING)
		animate(pixel_y = user.pixel_y + (1 * direction), time = 1, easing = SINE_EASING)
	user.changeNext_move(CLICK_CD_MELEE)

