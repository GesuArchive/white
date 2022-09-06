#define BRASS_POWER_COST 10

/obj/item/clockwork/replica_fabricator
	name = "производитель реплик"
	icon = 'icons/obj/clockwork_objects.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	icon_state = "replica_fabricator"
	desc = "Странное латунное устройство с множеством вращающихся зубцов и вентиляционных отверстий."
	clockwork_desc = "Устройство, используемое для быстрого изготовления чего-то из латуни."

/obj/item/clockwork/replica_fabricator/examine(mob/user)
	. = ..()
	if(is_servant_of_ratvar(user))
		. += "<hr>"
		. += "Используй на латуни, чтобы преобразовать ее в энергию."
		. += "\nИспользуй на других материалах, чтобы превратить их в латунь."
		. += "\nИспользуй на пустом полу для изготовления латуни по 10Вт/лист."
		. += "\nИспользуй для ремонта поврежденных механизмов."

/obj/item/clockwork/replica_fabricator/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag || !is_servant_of_ratvar(user))
		return
	if(istype(target, /obj/item/stack/tile/bronze/cyborg))	//nooooO!!!! you can't just suck up your cyborg brass!!! nooooo!!!!!!
		return
	if(istype(target, /obj/item/stack/tile/bronze))
		var/obj/item/stack/tile/bronze/B = target
		qdel(B)
		GLOB.clockcult_power += B.amount * BRASS_POWER_COST
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='nzcrentr'>Превращаю [B.amount] латуни в [B.amount * BRASS_POWER_COST] ватт энергии.</span>")
	else if(istype(target, /obj/item/stack/sheet))
		var/obj/item/stack/S = target
		var/obj/item/stack/tile/bronze/B = new(get_turf(S))
		B.amount = FLOOR(S.amount * 0.5, 1)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='nzcrentr'>Превращаю [S.amount] [S] в [S.amount] латуни.</span>")
		qdel(target)
	else if(isopenturf(target))
		fabricate_sheets(target, user)
	else if(istype(target, /obj/structure/destructible/clockwork))
		var/obj/structure/destructible/clockwork/C = target
		if(!C.can_be_repaired)
			to_chat(user, "<span class='nzcrentr'>Не могу починить [C]!</span>")
			return
		if(GLOB.clockcult_power < 200)
			to_chat(user, "<span class='nzcrentr'>Требуется [200 - GLOB.clockcult_power]W для починки [C]...</span>")
			return
		if(C.max_integrity == C.obj_integrity)
			to_chat(user, "<span class='nzcrentr'>[C] уже в порядке!</span>")
			return
		to_chat(user, "<span class='nzcrentr'>Начинаю ремонтировать [C]...</span>")
		if(do_after(user, 60, target=target))
			if(C.max_integrity == C.obj_integrity)
				to_chat(user, "<span class='nzcrentr'>[C] уже в порядке!</span>")
				return
			if(GLOB.clockcult_power < 200)
				to_chat(user, "<span class='nzcrentr'>Требуется [200 - GLOB.clockcult_power]W для починки [C]...</span>")
				return
			GLOB.clockcult_power -= 200
			to_chat(user, "<span class='nzcrentr'>Чиню некоторый урон на [C].</span>")
			C.obj_integrity = clamp(C.obj_integrity + 15, 0, C.max_integrity)
		else
			to_chat(user, "<span class='nzcrentr'>Не вышло починить [C]...</span>")

/obj/item/clockwork/replica_fabricator/proc/fabricate_sheets(turf/target, mob/user)
	var/sheets = FLOOR(clamp(GLOB.clockcult_power / BRASS_POWER_COST, 0, 50), 1)
	if(sheets == 0)
		return
	GLOB.clockcult_power -= sheets * BRASS_POWER_COST
	new /obj/item/stack/tile/bronze(target, sheets)
	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
	to_chat(user, span_brass("Создаю [sheets] листов латуни."))
