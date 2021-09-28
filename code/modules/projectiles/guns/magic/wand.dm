/obj/item/gun/magic/wand
	name = "палочка"
	desc = "Она не должна была у тебя оказаться."
	ammo_type = /obj/item/ammo_casing/magic
	icon_state = "nothingwand"
	inhand_icon_state = "wand"
	w_class = WEIGHT_CLASS_SMALL
	can_charge = FALSE
	max_charges = 100 //100, 50, 50, 34 (max charge distribution by 25%ths)
	var/variable_charges = TRUE

/obj/item/gun/magic/wand/Initialize()
	if(prob(75) && variable_charges) //25% chance of listed max charges, 50% chance of 1/2 max charges, 25% chance of 1/3 max charges
		if(prob(33))
			max_charges = CEILING(max_charges / 3, 1)
		else
			max_charges = CEILING(max_charges / 2, 1)
	return ..()

/obj/item/gun/magic/wand/examine(mob/user)
	. = ..()
	. += "<hr>Has [charges] charge\s remaining."

/obj/item/gun/magic/wand/update_icon_state()
	icon_state = "[initial(icon_state)][charges ? "" : "-drained"]"

/obj/item/gun/magic/wand/attack(atom/target, mob/living/user)
	if(target == user)
		return
	..()

/obj/item/gun/magic/wand/afterattack(atom/target, mob/living/user)
	if(!charges)
		shoot_with_empty_chamber(user)
		return
	if(target == user)
		if(no_den_usage)
			var/area/A = get_area(user)
			if(istype(A, /area/wizard_station))
				to_chat(user, span_warning("You know better than to violate the security of The Den, best wait until you leave to use [src]."))
				return
			else
				no_den_usage = 0
		zap_self(user)
	else
		. = ..()
	update_icon()


/obj/item/gun/magic/wand/proc/zap_self(mob/living/user)
	user.visible_message(span_danger("[user] zaps [user.ru_na()]self with [src]."))
	playsound(user, fire_sound, 50, TRUE)
	user.log_message("zapped [user.ru_na()]self with a <b>[src]</b>", LOG_ATTACK)


/////////////////////////////////////
//WAND OF DEATH
/////////////////////////////////////

/obj/item/gun/magic/wand/death
	name = "палочка смерти"
	desc = "Эта смертельная палочка наполняеи тело жертвы чистой энергией, гарантированно убивая её."
	school = SCHOOL_NECROMANCY
	fire_sound = 'sound/magic/wandodeath.ogg'
	ammo_type = /obj/item/ammo_casing/magic/death
	icon_state = "deathwand"
	max_charges = 3 //3, 2, 2, 1

/obj/item/gun/magic/wand/death/zap_self(mob/living/user)
	..()
	charges--
	if(user.anti_magic_check())
		user.visible_message(span_warning("[capitalize(src.name)] не подействовала на [user]!"))
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.mob_biotypes & MOB_UNDEAD) //negative energy heals the undead
			user.revive(full_heal = TRUE, admin_revive = TRUE)
			to_chat(user, span_notice("Чувствую себя замечательно!"))
			return
	to_chat(user, "<span class='warning'>Облучаю себя чистой негативной энергией! \
	[pick("Не проходите мимо. Не подбирайте 200 зоркмидов.","Чувствую что мои навыки чтения заклинаний улучшились.","Вы умерли...","Вы хотите чтобы ваше имущество опознали?")]\
	</span>")
	user.death(FALSE)

/obj/item/gun/magic/wand/death/debug
	desc = "В узких кругах он известен как друг «тестировщика клонирования»'."
	max_charges = 500
	variable_charges = FALSE
	can_charge = TRUE
	recharge_rate = 1


/////////////////////////////////////
//WAND OF HEALING
/////////////////////////////////////

/obj/item/gun/magic/wand/resurrection
	name = "палочка исцеления"
	desc = "Эта палочка использует исцеляющую магию для лечения и воскрешения. По какой-то причине их редко используют в Федерации Волшебников."
	school = SCHOOL_RESTORATION
	ammo_type = /obj/item/ammo_casing/magic/heal
	fire_sound = 'sound/magic/staff_healing.ogg'
	icon_state = "revivewand"
	max_charges = 10 //10, 5, 5, 4

/obj/item/gun/magic/wand/resurrection/zap_self(mob/living/user)
	..()
	charges--
	if(user.anti_magic_check())
		user.visible_message(span_warning("[capitalize(src.name)] не подействовала на [user]!"))
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
			to_chat(user, "<span class='warning'>Облучил себя чистой позитивной энергией! \
			[pick("Не проходите мимо. Не подбирайте 200 зоркмидов.","Чувствую что мои навыки чтения заклинаний улучшились.","Вы умерли...","Вы хотите чтобы ваше имущество опознали?")]\
			</span>")
			user.death(0)
			return
	user.revive(full_heal = TRUE, admin_revive = TRUE)
	to_chat(user, span_notice("Чувствую себя замечательно!"))

/obj/item/gun/magic/wand/resurrection/debug //for testing
	desc = "Существует ли что-то мощнее обычной магии? Да, эта палочка."
	max_charges = 500
	variable_charges = FALSE
	can_charge = TRUE
	recharge_rate = 1

/////////////////////////////////////
//WAND OF POLYMORPH
/////////////////////////////////////

/obj/item/gun/magic/wand/polymorph
	name = "палочка полиморфа"
	desc = "Эта палочка заточена под хаос и радикально изменит форму жертвы."
	school = SCHOOL_TRANSMUTATION
	ammo_type = /obj/item/ammo_casing/magic/change
	icon_state = "polywand"
	fire_sound = 'sound/magic/staff_change.ogg'
	max_charges = 10 //10, 5, 5, 4

/obj/item/gun/magic/wand/polymorph/zap_self(mob/living/user)
	..() //because the user mob ceases to exists by the time wabbajack fully resolves

	wabbajack(user)
	charges--

/////////////////////////////////////
//WAND OF TELEPORTATION
/////////////////////////////////////

/obj/item/gun/magic/wand/teleport
	name = "палочка телепортации"
	desc = "Эта палочка переместит цели через пространство и время, отправив их куда-то."
	school = SCHOOL_TRANSLOCATION
	ammo_type = /obj/item/ammo_casing/magic/teleport
	fire_sound = 'sound/magic/wand_teleport.ogg'
	icon_state = "telewand"
	max_charges = 10 //10, 5, 5, 4
	no_den_usage = TRUE

/obj/item/gun/magic/wand/teleport/zap_self(mob/living/user)
	if(do_teleport(user, user, 10, channel = TELEPORT_CHANNEL_MAGIC))
		var/datum/effect_system/smoke_spread/smoke = new
		smoke.set_up(3, user.loc)
		smoke.start()
		charges--
	..()

/obj/item/gun/magic/wand/safety
	name = "палочка безопасности"
	desc = "This wand will use the lightest of bluespace currents to gently place the target somewhere safe."
	school = SCHOOL_TRANSLOCATION
	ammo_type = /obj/item/ammo_casing/magic/safety
	fire_sound = 'sound/magic/wand_teleport.ogg'
	icon_state = "telewand"
	max_charges = 10 //10, 5, 5, 4
	no_den_usage = FALSE

/obj/item/gun/magic/wand/safety/zap_self(mob/living/user)
	var/turf/origin = get_turf(user)
	var/turf/destination = find_safe_turf()

	if(do_teleport(user, destination, channel=TELEPORT_CHANNEL_MAGIC))
		for(var/t in list(origin, destination))
			var/datum/effect_system/smoke_spread/smoke = new
			smoke.set_up(0, t)
			smoke.start()
	..()

/obj/item/gun/magic/wand/safety/debug
	desc = "На синем древе этой палочке вырезано 'find_safe_turf()'. Может это тайное послание?"
	max_charges = 500
	variable_charges = FALSE
	can_charge = TRUE
	recharge_rate = 1


/////////////////////////////////////
//WAND OF DOOR CREATION
/////////////////////////////////////

/obj/item/gun/magic/wand/door
	name = "палочка создания дверей"
	desc = "Эта палочка может создавать двери на любых стенах. Полезно для недобросовестных волшебников, избегающих магии телепортации."
	school = SCHOOL_TRANSMUTATION
	ammo_type = /obj/item/ammo_casing/magic/door
	icon_state = "doorwand"
	fire_sound = 'sound/magic/staff_door.ogg'
	max_charges = 20 //20, 10, 10, 7
	no_den_usage = 1

/obj/item/gun/magic/wand/door/zap_self(mob/living/user)
	to_chat(user, span_notice("Чувствую что стал более открытым человеком."))
	charges--
	..()

/////////////////////////////////////
//WAND OF FIREBALL
/////////////////////////////////////

/obj/item/gun/magic/wand/fireball
	name = "палочка огненного шара"
	desc = "Эта палочка запускает раскаленные огненные шары, взрывающиеся разрушительным пламенем."
	school = SCHOOL_EVOCATION
	fire_sound = 'sound/magic/fireball.ogg'
	ammo_type = /obj/item/ammo_casing/magic/fireball
	icon_state = "firewand"
	max_charges = 8 //8, 4, 4, 3

/obj/item/gun/magic/wand/fireball/zap_self(mob/living/user)
	..()
	explosion(user.loc, -1, 0, 2, 3, 0, flame_range = 2)
	charges--

/////////////////////////////////////
//WAND OF NOTHING
/////////////////////////////////////

/obj/item/gun/magic/wand/nothing
	name = "палочка ничего"
	desc = "Это не просто палочка, это ВОЛШЕБНАЯ палочка?"
	ammo_type = /obj/item/ammo_casing/magic/nothing


