#define RESONATOR_MODE_AUTO   1
#define RESONATOR_MODE_MANUAL 2
#define RESONATOR_MODE_MATRIX 3

/**********************Resonator**********************/

/obj/item/resonator
	name = "резонатор"
	desc = "Портативное устройство, создающее небольшие нестабильные энергетические поля, что создают резонансный взрыв при активации, нанося урон и дробя породу. Сила взрыва заметно выше при низком давлении. Имеет два режима детонации: двухсекундный таймер и ручной подрыв."
	icon = 'icons/obj/mining.dmi'
	icon_state = "resonator"
	inhand_icon_state = "resonator"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 15
	throwforce = 10

	var/mode = RESONATOR_MODE_AUTO
	/// How efficient it is in manual mode. Yes, we lower the damage cuz it's gonna be used for mobhunt
	var/quick_burst_mod = 0.8
	var/fieldlimit = 4
	var/list/fields = list()

/obj/item/resonator/attack_self(mob/user)
	if(mode == RESONATOR_MODE_AUTO)
		to_chat(user, span_info("Устанавливаю резонатор на ручной подрыв."))
		mode = RESONATOR_MODE_MANUAL
	else
		to_chat(user, span_info("Устанавливаю резонатор на двухсекундный таймер."))
		mode = RESONATOR_MODE_AUTO

/obj/item/resonator/proc/CreateResonance(target, mob/user)
	var/turf/T = get_turf(target)
	var/obj/effect/temp_visual/resonance/R = locate(/obj/effect/temp_visual/resonance) in T
	if(R)
		R.damage_multiplier = quick_burst_mod
		R.burst()
		return
	if(LAZYLEN(fields) < fieldlimit)
		new /obj/effect/temp_visual/resonance(T, user, src, mode)
		user.changeNext_move(CLICK_CD_MELEE)

/obj/item/resonator/pre_attack(atom/target, mob/user, params)
	if(check_allowed_items(target, not_inside = TRUE))
		CreateResonance(target, user)
	return ..()

//resonance field, crushes rock, damages mobs
/obj/effect/temp_visual/resonance
	name = "резонирующее поле"
	desc = "Резонирующее поле, вызывающее серьезные травмы любым объектам оказавшимся внутри него в момент дестабилизации. Эффект значительно разрушительнее в условиях низкого давления."
	icon_state = "shield1"
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	duration = 60 SECONDS
	var/resonance_damage = 20
	var/damage_multiplier = 1
	var/creator
	var/obj/item/resonator/res
	var/rupturing = FALSE //So it won't recurse

/obj/effect/temp_visual/resonance/Initialize(mapload, set_creator, set_resonator, mode)
	if(mode == RESONATOR_MODE_AUTO)
		duration = 2 SECONDS
	if(mode == RESONATOR_MODE_MATRIX)
		icon_state = "shield2"
		name = "резонансная мина"
		RegisterSignal(src, COMSIG_ATOM_ENTERED, .proc/burst)
		var/static/list/loc_connections = list(
			COMSIG_ATOM_ENTERED = .proc/burst,
		)
		AddElement(/datum/element/connect_loc, loc_connections)
	. = ..()
	creator = set_creator
	res = set_resonator
	if(res)
		res.fields += src
	playsound(src,'sound/weapons/resonator_fire.ogg',50,TRUE)
	if(mode == RESONATOR_MODE_AUTO)
		transform = matrix()*0.75
		animate(src, transform = matrix()*1.5, time = duration)
	deltimer(timerid)
	timerid = addtimer(CALLBACK(src, .proc/burst), duration, TIMER_STOPPABLE)

/obj/effect/temp_visual/resonance/Destroy()
	if(res)
		res.fields -= src
		res = null
	creator = null
	. = ..()

/obj/effect/temp_visual/resonance/proc/check_pressure(turf/proj_turf)
	if(!proj_turf)
		proj_turf = get_turf(src)
	resonance_damage = initial(resonance_damage)
	if(lavaland_equipment_pressure_check(proj_turf))
		name = "[initial(name)] низкого давления"
		resonance_damage *= 3
	else
		name = initial(name)
	resonance_damage *= damage_multiplier

/obj/effect/temp_visual/resonance/proc/burst()
	SIGNAL_HANDLER
	rupturing = TRUE
	var/turf/T = get_turf(src)
	new /obj/effect/temp_visual/resonance_crush(T)
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.attempt_drill(creator)
	check_pressure(T)
	playsound(T,'sound/weapons/resonator_blast.ogg',50,TRUE)
	for(var/mob/living/L in T)
		if(creator)
			log_combat(creator, L, "used a resonator field on", "resonator")
		to_chat(L, span_userdanger("[src] схлопывается на мне!"))
		L.apply_damage(resonance_damage, BRUTE)
		L.add_movespeed_modifier(/datum/movespeed_modifier/resonance)
		addtimer(CALLBACK(L, /mob/proc/remove_movespeed_modifier, /datum/movespeed_modifier/resonance), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	for(var/obj/effect/temp_visual/resonance/field in range(1, src))
		if(field != src && !field.rupturing)
			field.burst()
	qdel(src)

/obj/effect/temp_visual/resonance_crush
	icon_state = "shield1"
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	duration = 4

/obj/effect/temp_visual/resonance_crush/Initialize(mapload)
	. = ..()
	transform = matrix()*1.5
	animate(src, transform = matrix()*0.1, alpha = 50, time = 4)

/obj/item/resonator/upgraded
	name = "продвинутый резонатор"
	desc = "Модернизированная версия резонатора, которая может создавать больше полей одновременно, а также не имеет штрафа к урону при раннем разрыве резонансного поля. Продвинутая модель так же может устанавливать \"резонансные мины\", которые взрываются после того, как кто-то (или что-то) наступает на них."
	icon_state = "resonator_u"
	inhand_icon_state = "resonator_u"
	fieldlimit = 6
	quick_burst_mod = 1

/obj/item/resonator/upgraded/attack_self(mob/user)
	if(mode == RESONATOR_MODE_AUTO)
		to_chat(user, span_info("Устанавливаю резонатор на ручной подрыв."))
		mode = RESONATOR_MODE_MANUAL
	else if(mode == RESONATOR_MODE_MANUAL)
		to_chat(user, span_info("Устанавливаю резонатор в режим миноукладчика."))
		mode = RESONATOR_MODE_MATRIX
	else
		to_chat(user, span_info("Устанавливаю резонатор на двухсекундный таймер."))
		mode = RESONATOR_MODE_AUTO

#undef RESONATOR_MODE_AUTO
#undef RESONATOR_MODE_MANUAL
#undef RESONATOR_MODE_MATRIX
