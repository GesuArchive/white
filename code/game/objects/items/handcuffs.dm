/obj/item/restraints
	breakouttime = 60 SECONDS
	dye_color = DYE_PRISONER

/obj/item/restraints/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] is strangling [user.ru_na()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return(OXYLOSS)

/obj/item/restraints/examine(mob/user)
	. = ..()
	if(breakouttime % 600 == 0)
		. += span_notice("<hr>От таких оков можно избавиться примерно за <b>[breakouttime/600]</b> [getnoun(breakouttime/600, "минуту","минуты","минут")].")
	else
		. += span_notice("<hr>От таких оков можно избавиться примерно за <b>[breakouttime/10]</b> [getnoun(breakouttime/10, "секунду","секунды","секунд")].")

/obj/item/restraints/Destroy()
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		if(M.handcuffed == src)
			M.set_handcuffed(null)
			M.update_handcuffed()
			if(M.buckled && M.buckled.buckle_requires_restraints)
				M.buckled.unbuckle_mob(M)
		if(M.legcuffed == src)
			M.legcuffed = null
			M.update_inv_legcuffed()
	return ..()

//Handcuffs

/obj/item/restraints/handcuffs
	name = "наручники"
	desc = "Используются для удержания животных в загоне."
	gender = PLURAL
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "handcuff"
	worn_icon_state = "handcuff"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron=500)
	breakouttime = 30 SECONDS
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	custom_price = PAYCHECK_HARD * 0.35
	var/cuffsound = 'sound/weapons/handcuffs.ogg'
	var/trashtype = null //for disposable cuffs

/obj/item/restraints/handcuffs/attack(mob/living/carbon/C, mob/living/user)
	if(!istype(C))
		return

	SEND_SIGNAL(C, COMSIG_CARBON_CUFF_ATTEMPTED, user)

	if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50)))
		to_chat(user, span_warning("[pick("Хыы", "Эээ", "Ммм", "Аыэ", "Оаэ", "Ааа", "Амм", "Омм")]... как это работает?!"))
		apply_cuffs(user,user)
		return

	if(!C.handcuffed)
		if(C.canBeHandcuffed())
			C.visible_message(span_danger("[user] пытается надеть [src.name] на [C]!") , \
								span_userdanger("[user] пытается надеть [src.name] на меня!"))

			playsound(loc, cuffsound, 30, TRUE, -2)
			log_combat(user, C, "attempted to handcuff")
			if(do_mob(user, C, 30, timed_action_flags = IGNORE_SLOWDOWNS) && C.canBeHandcuffed())
				if(iscyborg(user))
					apply_cuffs(C, user, TRUE)
				else
					apply_cuffs(C, user)
				C.visible_message(span_notice("[user] заковывает [C].") , \
									span_userdanger("[user] заковывает меня."))
				SSblackbox.record_feedback("tally", "handcuffs", 1, type)

				log_combat(user, C, "handcuffed")
			else
				to_chat(user, span_warning("Не выходит заковать [C]!"))
				log_combat(user, C, "failed to handcuff")
		else
			to_chat(user, span_warning("[C] не имеет двух рук..."))

/obj/item/restraints/handcuffs/proc/apply_cuffs(mob/living/carbon/target, mob/user, dispense = 0)
	if(target.handcuffed)
		return

	if(!user.temporarilyRemoveItemFromInventory(src) && !dispense)
		return

	var/obj/item/restraints/handcuffs/cuffs = src
	if(trashtype)
		cuffs = new trashtype()
	else if(dispense)
		cuffs = new type()

	cuffs.forceMove(target)
	target.set_handcuffed(cuffs)

	target.update_handcuffed()
	if(trashtype && !dispense)
		qdel(src)
	return

/obj/item/restraints/handcuffs/cable/sinew
	name = "стяжки из сухожилий"
	desc = "Пара стяжек, сделанных из длинных прядей плоти."
	icon = 'icons/obj/mining.dmi'
	icon_state = "sinewcuff"
	inhand_icon_state = "sinewcuff"
	custom_materials = null
	color = null

/obj/item/restraints/handcuffs/cable
	name = "кабельные стяжки"
	desc = "Похоже, что какие-то кабели связаны вместе. Может использоваться, чтобы что-то или кого-то связать."
	icon_state = "cuff"
	inhand_icon_state = "coil"
	color = "#ff0000"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	custom_materials = list(/datum/material/iron=150, /datum/material/glass=75)
	breakouttime = 20 SECONDS
	cuffsound = 'sound/weapons/cablecuff.ogg'

/obj/item/restraints/handcuffs/cable/Initialize(mapload)
	. = ..()

	var/static/list/hovering_item_typechecks = list(
		/obj/item/stack/rods = list(
			SCREENTIP_CONTEXT_LMB = "Сделать заготовку",
		),

		/obj/item/stack/sheet/iron = list(
			SCREENTIP_CONTEXT_LMB = "Сделать болу",
		),
	)

	AddElement(/datum/element/contextual_screentip_item_typechecks, hovering_item_typechecks)

/obj/item/restraints/handcuffs/cable/red
	color = "#ff0000"

/obj/item/restraints/handcuffs/cable/yellow
	color = "#ffff00"

/obj/item/restraints/handcuffs/cable/blue
	color = "#1919c8"

/obj/item/restraints/handcuffs/cable/green
	color = "#00aa00"

/obj/item/restraints/handcuffs/cable/pink
	color = "#ff3ccd"

/obj/item/restraints/handcuffs/cable/orange
	color = "#ff8000"

/obj/item/restraints/handcuffs/cable/cyan
	color = "#00ffff"

/obj/item/restraints/handcuffs/cable/white
	color = null

/obj/item/restraints/handcuffs/alien
	icon_state = "handcuffAlien"

/obj/item/restraints/handcuffs/fake
	name = "наручники"
	desc = "Поддельные наручники, предназначенные для ролевых игр."
	breakouttime = 1 SECONDS

/obj/item/restraints/handcuffs/cable/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/wirerod/W = new /obj/item/wirerod
			remove_item_from_storage(user)
			user.put_in_hands(W)
			to_chat(user, span_notice("Оборачиваю [src.name] вокруг верхушки [I.name]."))
			qdel(src)
		else
			to_chat(user, span_warning("Мне потребуется стержень для этого!"))
			return
	else if(istype(I, /obj/item/stack/sheet/iron))
		var/obj/item/stack/sheet/iron/M = I
		if(M.get_amount() < 6)
			to_chat(user, span_warning("Мне потребуется как минимум шесть единиц металла для веса!"))
			return
		to_chat(user, span_notice("Начинаю навешивать [I.name] на [src.name]..."))
		if(do_after(user, 35, target = src))
			if(M.get_amount() < 6 || !M)
				return
			var/obj/item/restraints/legcuffs/bola/S = new /obj/item/restraints/legcuffs/bola
			M.use(6)
			user.put_in_hands(S)
			to_chat(user, span_notice("Делаю грузики используя [I.name] создавая [src.name]."))
			remove_item_from_storage(user)
			qdel(src)
	else
		return ..()

/obj/item/restraints/handcuffs/cable/zipties
	name = "стяжки"
	desc = "Одноразовые пластиковые стяжки, которые можно использовать для временного сдерживания. После снятия разрушаются."
	icon_state = "cuff"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	custom_materials = null
	breakouttime = 10 SECONDS
	trashtype = /obj/item/restraints/handcuffs/cable/zipties/used
	color = null

/obj/item/restraints/handcuffs/cable/zipties/used
	desc = "Пара оборванных стяжек."
	icon_state = "cuff_used"
	inhand_icon_state = "cuff"

/obj/item/restraints/handcuffs/cable/zipties/used/attack()
	return

//Legcuffs

/obj/item/restraints/legcuffs
	name = "кандалы"
	desc = "Упрощает надзор за заключёнными."
	gender = PLURAL
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "handcuff"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	flags_1 = CONDUCT_1
	throwforce = 0
	w_class = WEIGHT_CLASS_NORMAL
	slowdown = 7
	breakouttime = 10 SECONDS

/obj/item/restraints/legcuffs/beartrap
	name = "медвежий капкан"
	desc = "Ловушка, используемая для ловли медведей и прочих парнокопытных ассистентов."
	throw_speed = 1
	throw_range = 1
	icon_state = "beartrap"
	breakouttime = 10 SECONDS
	var/armed = 0
	var/trap_damage = 20

/obj/item/restraints/legcuffs/beartrap/prearmed
	armed = TRUE

/obj/item/restraints/legcuffs/beartrap/Initialize(mapload)
	. = ..()
	update_icon()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/spring_trap,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/restraints/legcuffs/beartrap/update_icon_state()
	icon_state = "[initial(icon_state)][armed]"

/obj/item/restraints/legcuffs/beartrap/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is sticking [user.ru_ego()] head in the [src.name]! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/weapons/stab2.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/restraints/legcuffs/beartrap/attack_self(mob/user)
	. = ..()
	if(!ishuman(user) || user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return
	armed = !armed
	update_icon()
	to_chat(user, span_notice("[capitalize(src.name)] теперь [armed ? "заряжена" : "разряжена"]."))

/obj/item/restraints/legcuffs/beartrap/proc/close_trap()
	armed = FALSE
	update_icon()
	playsound(src, 'sound/effects/snap.ogg', 50, TRUE)

/obj/item/restraints/legcuffs/beartrap/proc/spring_trap(datum/source, AM as mob|obj)
	SIGNAL_HANDLER
	if(armed && isturf(loc))
		if(isliving(AM))
			var/mob/living/L = AM
			var/snap = TRUE
			if(istype(L.buckled, /obj/vehicle))
				var/obj/vehicle/ridden_vehicle = L.buckled
				if(!ridden_vehicle.are_legs_exposed) //close the trap without injuring/trapping the rider if their legs are inside the vehicle at all times.
					close_trap()
					ridden_vehicle.visible_message(span_danger("[ridden_vehicle] наезжает на <b>[src.name]</b>."))

			if(L.movement_type & (FLYING|FLOATING)) //don't close the trap if they're flying/floating over it.
				snap = FALSE

			var/def_zone = BODY_ZONE_CHEST
			if(snap && iscarbon(L))
				var/mob/living/carbon/C = L
				if(C.body_position == STANDING_UP)
					def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
					if(!C.legcuffed && C.num_legs >= 2) //beartrap can't cuff your leg if there's already a beartrap or legcuffs, or you don't have two legs.
						C.legcuffed = src
						forceMove(C)
						C.update_equipment_speed_mods()
						C.update_inv_legcuffed()
						SSblackbox.record_feedback("tally", "handcuffs", 1, type)
			else if(snap && isanimal(L))
				var/mob/living/simple_animal/SA = L
				if(SA.mob_size <= MOB_SIZE_TINY) //don't close the trap if they're as small as a mouse.
					snap = FALSE
			if(snap)
				close_trap()
				L.visible_message(span_danger("[L] наступает в <b>[src.name]</b>.") , \
						span_userdanger("Наступаю в <b>[src.name]</b>!"))
				L.apply_damage(trap_damage, BRUTE, def_zone)

/obj/item/restraints/legcuffs/beartrap/energy
	name = "энергосеть"
	armed = 1
	icon_state = "e_snare"
	trap_damage = 0
	breakouttime = 7 SECONDS
	item_flags = DROPDEL
	flags_1 = NONE

/obj/item/restraints/legcuffs/beartrap/energy/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, .proc/dissipate), 100)

/obj/item/restraints/legcuffs/beartrap/energy/proc/dissipate()
	if(!ismob(loc))
		do_sparks(1, TRUE, src)
		qdel(src)

/obj/item/restraints/legcuffs/beartrap/energy/attack_hand(mob/user, list/modifiers)
	spring_trap(null, user)
	return ..()

/obj/item/restraints/legcuffs/beartrap/energy/cyborg
	breakouttime = 7 SECONDS // Cyborgs shouldn't have a strong restraint

/obj/item/restraints/legcuffs/bola
	name = "бола"
	desc = "Удерживающее устройство, предназначенное для метания в цель. При соединении с указанной целью он обхватит их ноги, затрудняя их быстрое перемещение."
	icon_state = "bola"
	inhand_icon_state = "bola"
	lefthand_file = 'icons/mob/inhands/weapons/thrown_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/thrown_righthand.dmi'
	breakouttime = 4 SECONDS
	gender = NEUTER
	var/knockdown = 0

/obj/item/restraints/legcuffs/bola/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, gentle = FALSE, quickstart = TRUE, params)
	if(!..())
		return
	playsound(src.loc,'sound/weapons/bolathrow.ogg', 75, TRUE)

/obj/item/restraints/legcuffs/bola/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(..() || !iscarbon(hit_atom))//if it gets caught or the target can't be cuffed,
		return//abort
	ensnare(hit_atom)

/**
 * Attempts to legcuff someone with the bola
 *
 * Arguments:
 * * C - the carbon that we will try to ensnare
 */
/obj/item/restraints/legcuffs/bola/proc/ensnare(mob/living/carbon/C)
	if(!C.legcuffed && C.num_legs >= 2)
		visible_message(span_danger("<b>[capitalize(src)]</b> ловит ножки [C]!"))
		C.legcuffed = src
		forceMove(C)
		C.update_equipment_speed_mods()
		C.update_inv_legcuffed()
		SSblackbox.record_feedback("tally", "handcuffs", 1, type)
		to_chat(C, span_userdanger("<b>[capitalize(src)]</b> ловит мои ножки!"))
		C.Knockdown(knockdown)
		playsound(src, 'sound/effects/snap.ogg', 50, TRUE)

/obj/item/restraints/legcuffs/bola/tactical //traitor variant
	name = "крепкая бола"
	desc = "Прочная бола, сделанная из длинной стальной цепи. Он выглядит тяжелым, достаточно, чтобы кого-нибудь споткнуть."
	icon_state = "bola_r"
	inhand_icon_state = "bola_r"
	breakouttime = 8 SECONDS
	knockdown = 35

/obj/item/restraints/legcuffs/bola/energy //For Security
	name = "энергобола"
	desc = "Специализированная бола сплетенная из волокон жесткого света, предназначенная для ловли убегающих преступников и помощи в арестах."
	icon_state = "ebola"
	inhand_icon_state = "ebola"
	hitsound = 'sound/weapons/taserhit.ogg'
	w_class = WEIGHT_CLASS_SMALL
	breakouttime = 4 SECONDS
	custom_price = PAYCHECK_HARD * 0.35

/obj/item/restraints/legcuffs/bola/energy/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(iscarbon(hit_atom))
		var/obj/item/restraints/legcuffs/beartrap/B = new /obj/item/restraints/legcuffs/beartrap/energy/cyborg(get_turf(hit_atom))
		B.spring_trap(null, hit_atom)
		qdel(src)
		return
	. = ..()

/obj/item/restraints/legcuffs/bola/gonbola
	name = "гонбола"
	desc = "Эй, если тебя что-то обнимает за ноги, то с таким же успехом это может быть этот маленький парень."
	icon_state = "gonbola"
	inhand_icon_state = "bola_r"
	slowdown = 0
	var/datum/status_effect/gonbola_pacify/effectReference

/obj/item/restraints/legcuffs/bola/gonbola/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(iscarbon(hit_atom))
		var/mob/living/carbon/C = hit_atom
		effectReference = C.apply_status_effect(STATUS_EFFECT_GONBOLAPACIFY)

/obj/item/restraints/legcuffs/bola/gonbola/dropped(mob/user)
	. = ..()
	if(effectReference)
		QDEL_NULL(effectReference)
