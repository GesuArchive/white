/obj/item/mecha_parts/mecha_equipment/weapon
	name = "mecha weapon"
	range = MECHA_RANGED
	equipment_slot = MECHA_WEAPON
	destroy_sound = 'sound/mecha/weapdestr.ogg'
	var/projectile
	var/fire_sound
	var/projectiles_per_shot = 1
	var/variance = 0
	var/randomspread = FALSE //use random spread for machineguns, instead of shotgun scatter
	var/projectile_delay = 0
	var/firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect	//the visual effect appearing when the weapon is fired.
	var/kickback = TRUE //Will using this weapon in no grav push mecha back.
	mech_flags = EXOSUIT_MODULE_COMBAT

/obj/item/mecha_parts/mecha_equipment/weapon/can_attach(obj/vehicle/sealed/mecha/M, attach_right = FALSE)
	if(!..())
		return FALSE
	if(istype(M, /obj/vehicle/sealed/mecha/combat))
		return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/action(mob/source, atom/target, params)
	if(!action_checks(target))
		return FALSE
	var/newtonian_target = turn(chassis.dir,180)
	. = ..()//start the cooldown early because of sleeps
	for(var/i in 1 to projectiles_per_shot)
		if(energy_drain && !chassis.has_charge(energy_drain))//in case we run out of energy mid-burst, such as emp
			break
		var/spread = 0
		if(variance)
			if(randomspread)
				spread = round((rand() - 0.5) * variance)
			else
				spread = round((i / projectiles_per_shot - 0.5) * variance)

		var/obj/projectile/projectile_obj = new projectile(get_turf(src))
		var/modifiers = params2list(params)
		projectile_obj.preparePixelProjectile(target, source, modifiers, spread)

		if(source.client && isliving(source)) //dont want it to happen from syndie mecha npc mobs, they do direct fire anyways
			var/mob/living/shooter = source
			projectile_obj.hit_prone_targets = shooter.a_intent != INTENT_HELP

		projectile_obj.fire()
		if(!projectile_obj.suppressed && firing_effect_type)
			new firing_effect_type(get_turf(src), chassis.dir)
		playsound(chassis, fire_sound, 50, TRUE)

		sleep(max(0, projectile_delay))

		if(kickback)
			chassis.newtonian_move(newtonian_target)
	chassis.log_message("Fired from [name], targeting [target].", LOG_ATTACK)

//Base energy weapon type
/obj/item/mecha_parts/mecha_equipment/weapon/energy
	name = "general energy weapon"
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/energy

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	equip_cooldown = 8
	name = "Легкий лазер ЭВ-ЛЛ \"Выжигатель\""
	desc = "Оружие для боевых экзокостюмов. Стреляет слабыми лазерами."
	icon_state = "mecha_laser"
	energy_drain = 30
	projectile = /obj/projectile/beam/laser
	fire_sound = 'sound/weapons/laser.ogg'
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/disabler
	equip_cooldown = 8
	name = "Усмиритель ЭВ-УЛ \"Миротворец\""
	desc = "Оружие для боевых экзокостюмов. Стреляет слабыми парализующими лучами."
	icon_state = "mecha_disabler"
	energy_drain = 30
	projectile = /obj/projectile/beam/disabler
	fire_sound = 'sound/weapons/taser2.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
	equip_cooldown = 15
	name = "Тяжелый лазер ЭВ-ТЛ \"Солярис\""
	desc = "Оружие для боевых экзокостюмов. Стреляет мощными лазерами."
	icon_state = "mecha_laser"
	energy_drain = 60
	projectile = /obj/projectile/beam/laser/heavylaser
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/ion
	equip_cooldown = 20
	name = "Тяжелое ионное орудие МК-4"
	desc = "Оружие для боевых экзокостюмов. Стреляет эми импульсами повреждающими технику. Не попадите под собственный выстрел!"
	icon_state = "mecha_ion"
	energy_drain = 120
	projectile = /obj/projectile/ion
	fire_sound = 'sound/weapons/laser.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/tesla
	equip_cooldown = 35
	name = "Орудие Теслы МК-1"
	desc = "Оружие для боевых экзокостюмов. Стреляет разветвленными разрядами электричества, прицельный огонь невозможен."
	icon_state = "mecha_ion"
	energy_drain = 500
	projectile = /obj/projectile/energy/tesla/cannon
	fire_sound = 'sound/magic/lightningbolt.ogg'
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse
	equip_cooldown = 30
	name = "Сверхтяжелый импульсный лазер ГГ-13"
	desc = "Оружие для боевых экзокостюмов. Стреляет мощными разрушительными взрывами, способными разрушать препятствия."
	icon_state = "mecha_pulse"
	energy_drain = 120
	projectile = /obj/projectile/beam/pulse/heavy
	fire_sound = 'sound/weapons/marauder.ogg'
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/plasma
	equip_cooldown = 10
	name = "Тяжелый плазменный резак 217-Д"
	desc = "Устройство, которое стреляет резонансными плазменными вспышками с предельной скоростью. Взрывы способны дробить скалы и разрушать твердые препятствия."
	icon_state = "mecha_plasmacutter"
	inhand_icon_state = "plasmacutter"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	energy_drain = 30
	projectile = /obj/projectile/plasma/adv/mech
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/plasma/can_attach(obj/vehicle/sealed/mecha/M, attach_right = FALSE)
	if(..()) //combat mech
		return TRUE
	else if(default_can_attach(M, attach_right))
		return TRUE
	return FALSE

//Exosuit-mounted kinetic accelerator
/obj/item/mecha_parts/mecha_equipment/weapon/energy/mecha_kineticgun
	equip_cooldown = 10
	name = "Тяжелый прото-кинетический аксселератор"
	desc = "Установленный на экзокостюме аксселератор, наносящий повышенный урон при низком давлении. Питание от бортового источника позволяет ему проецироваться дальше, чем ручная версия."
	icon_state = "mecha_kineticgun"
	energy_drain = 30
	projectile = /obj/projectile/kinetic/mech
	fire_sound = 'sound/weapons/kenetic_accel.ogg'
	harmful = TRUE

//attachable to all mechas, like the plasma cutter
/obj/item/mecha_parts/mecha_equipment/weapon/energy/mecha_kineticgun/can_attach(obj/vehicle/sealed/mecha/M, attach_right = FALSE)
	. = ..()
	if(.) //combat mech
		return
	if(default_can_attach(M, attach_right))
		return TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/taser
	name = "Тяжелый парализатор ЭВ-ТП \"Судья\""
	desc = "Оружие для боевых экзокостюмов. Стреляет несмертельными оглушающими электродами."
	icon_state = "mecha_taser"
	energy_drain = 20
	equip_cooldown = 8
	projectile = /obj/projectile/energy/electrode
	fire_sound = 'sound/weapons/taser.ogg'


/obj/item/mecha_parts/mecha_equipment/weapon/honker
	name = "ХоНкЕР БлАсТ 5000"
	desc = "Оборудование для клоунских экзокостюмов. Распространяет веселье и радость среди всех окружающих. Хонк!"
	icon_state = "mecha_honker"
	energy_drain = 200
	equip_cooldown = 150
	range = MECHA_MELEE|MECHA_RANGED
	kickback = FALSE
	mech_flags = EXOSUIT_MODULE_HONK

/obj/item/mecha_parts/mecha_equipment/weapon/honker/can_attach(obj/vehicle/sealed/mecha/mecha, attach_right = FALSE)
	. = ..()
	if(!.)
		return
	if(!istype(mecha, /obj/vehicle/sealed/mecha/combat/honker))
		return FALSE


/obj/item/mecha_parts/mecha_equipment/weapon/honker/action(mob/source, atom/target, params)
	if(!action_checks(target))
		return
	playsound(chassis, 'sound/items/airhorn.ogg', 100, TRUE)
	to_chat(source, "[icon2html(src, source)]<font color='red' size='5'>HONK</font>")
	for(var/mob/living/carbon/M in ohearers(6, chassis))
		if(!M.can_hear())
			continue
		var/turf/turf_check = get_turf(M)
		if(isspaceturf(turf_check) && !turf_check.Adjacent(src)) //in space nobody can hear you honk.
			continue
		to_chat(M, "<font color='red' size='7'>HONK</font>")
		M.SetSleeping(0)
		M.stuttering += 20
		var/obj/item/organ/ears/ears = M.get_organ_slot(ORGAN_SLOT_EARS)
		if(ears)
			ears.adjustEarDamage(0, 30)
		M.Paralyze(60)
		if(prob(30))
			M.Stun(200)
			M.Unconscious(80)
		else
			M.Jitter(500)

	log_message("Honked from [src.name]. HONK!", LOG_MECHA)
	var/turf/T = get_turf(src)
	message_admins("[ADMIN_LOOKUPFLW(source)] used a Mecha Honker in [ADMIN_VERBOSEJMP(T)]")
	log_game("[key_name(source)] used a Mecha Honker in [AREACOORD(T)]")
	return ..()


//Base ballistic weapon type
/obj/item/mecha_parts/mecha_equipment/weapon/ballistic
	name = "general ballistic weapon"
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	var/projectiles
	var/projectiles_cache //ammo to be loaded in, if possible.
	var/projectiles_cache_max
	var/disabledreload //For weapons with no cache (like the rockets) which are reloaded by hand
	var/ammo_type

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/action_checks(target)
	if(!..())
		return FALSE
	if(projectiles <= 0)
		return FALSE
	return TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(action == "reload")
		rearm()
		return TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/rearm()
	if(projectiles < initial(projectiles))
		var/projectiles_to_add = initial(projectiles) - projectiles
		if(!projectiles_cache)
			return FALSE
		if(projectiles_to_add <= projectiles_cache)
			projectiles = projectiles + projectiles_to_add
			projectiles_cache = projectiles_cache - projectiles_to_add
		else
			projectiles = projectiles + projectiles_cache
			projectiles_cache = 0
		log_message("Rearmed [src].", LOG_MECHA)
		return TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/needs_rearm()
	. = !(projectiles > 0)


/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/action(mob/source, atom/target, list/modifiers)
	. = ..()
	if(!.)
		return
	projectiles -= projectiles_per_shot

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/carbine
	name = "Легкий зажигательный карабин БК-БЗ \"Аид\""
	desc = "Оружие для боевых экзокостюмов. Стреляет зажигательными пулями."
	icon_state = "mecha_carbine"
	equip_cooldown = 10
	projectile = /obj/projectile/bullet/incendiary/fnx99
	projectiles = 24
	projectiles_cache = 24
	projectiles_cache_max = 96
	harmful = TRUE
	ammo_type = "incendiary"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/bfg
	name = "Радиоактивная пушка \"Грейз\""
	desc = "Оружие для боевых экзокостюмов. Стреляет невероятно горячим лучом, окруженным полем плазмы."
	icon_state = "mecha_laser"
	equip_cooldown = 2 SECONDS
	projectile = /obj/projectile/beam/bfg
	projectiles = 5
	projectiles_cache = 0
	projectiles_cache_max = 10
	harmful = TRUE
	ammo_type = "bfg"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/silenced
	name = "Тяжелый бесшумный карабин \"Тишина\""
	desc = "Оружие для боевых экзокостюмов. Изобретение мимов, полевые испытания показали, что цели не успеют даже закричать, прежде чем упасть мертвыми наземь."
	fire_sound = 'sound/weapons/gun/general/heavy_shot_suppressed.ogg'
	icon_state = "mecha_mime"
	equip_cooldown = 30
	projectile = /obj/projectile/bullet/mime
	projectiles = 6
	projectiles_cache = 999
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	name = "Тяжелая картечница \"Дуплет\""
	desc = "Оружие для боевых экзокостюмов. Стреляет шквалом крупной картечи."
	icon_state = "mecha_scatter"
	equip_cooldown = 20
	projectile = /obj/projectile/bullet/scattershot
	projectiles = 40
	projectiles_cache = 40
	projectiles_cache_max = 160
	projectiles_per_shot = 4
	variance = 25
	harmful = TRUE
	ammo_type = "scattershot"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	name = "Легкий пулемет Ультра АК-2"
	desc = "Оружие для боевых экзокостюмов. Стреляет короткой очередью из трех выстрелов."
	icon_state = "mecha_uac2"
	equip_cooldown = 10
	projectile = /obj/projectile/bullet/lmg
	projectiles = 300
	projectiles_cache = 300
	projectiles_cache_max = 1200
	projectiles_per_shot = 3
	variance = 6
	randomspread = 1
	projectile_delay = 2
	harmful = TRUE
	ammo_type = "lmg"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack
	name = "Ракетная установка РСЗО \"Шторм-8\""
	desc = "Оружие для боевых экзокостюмов. Запускает легкие фугасные ракеты."
	icon_state = "mecha_missilerack"
	projectile = /obj/projectile/bullet/a84mm_he
	fire_sound = 'sound/weapons/gun/general/rocket_launch.ogg'
	projectiles = 8
	projectiles_cache = 0
	projectiles_cache_max = 0
	disabledreload = TRUE
	equip_cooldown = 60
	harmful = TRUE
	ammo_type = "missiles_he"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/breaching
	name = "Легкая ракетная установка РСЗО \"Пробой-6\""
	desc = "Оружие для боевых экзокостюмов. Запускает маловзрывоопасные разрывные ракеты, предназначенные для взрыва только при попадании в прочную цель."
	icon_state = "mecha_missilerack_six"
	projectile = /obj/projectile/bullet/a84mm_br
	fire_sound = 'sound/weapons/gun/general/rocket_launch.ogg'
	projectiles = 6
	projectiles_cache = 0
	projectiles_cache_max = 0
	disabledreload = TRUE
	equip_cooldown = 60
	harmful = TRUE
	ammo_type = "missiles_br"


/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher
	var/missile_speed = 2
	var/missile_range = 30
	var/diags_first = FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/action(mob/source, atom/target, params)
	if(!action_checks(target))
		return
	var/obj/O = new projectile(chassis.loc)
	playsound(chassis, fire_sound, 50, TRUE)
	log_message("Launched a [O.name] from [name], targeting [target].", LOG_MECHA)
	projectiles--
	proj_init(O, source)
	O.throw_at(target, missile_range, missile_speed, source, FALSE, diagonals_first = diags_first)
	return TRUE

//used for projectile initilisation (priming flashbang) and additional logging
/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/proc/proj_init(obj/O, mob/user)
	return


/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang
	name = "Автоматический гранатомет АГС \"Заря\""
	desc = "Оружие для боевых экзокостюмов. Автоматическая гранатометная система запускающая светошумовые гранаты."
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/grenade/flashbang
	fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	projectiles = 6
	projectiles_cache = 6
	projectiles_cache_max = 24
	missile_speed = 1.5
	equip_cooldown = 60
	var/det_time = 20
	ammo_type = "flashbang"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang/proj_init(obj/item/grenade/flashbang/F, mob/user)
	var/turf/T = get_turf(src)
	message_admins("[ADMIN_LOOKUPFLW(user)] fired a [F] in [ADMIN_VERBOSEJMP(T)]")
	log_game("[key_name(user)] fired a [F] in [AREACOORD(T)]")
	addtimer(CALLBACK(F, TYPE_PROC_REF(/obj/item/grenade/flashbang, detonate)), det_time)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang/clusterbang //Because I am a heartless bastard -Sieve //Heartless? for making the poor man's honkblast? - Kaze
	name = "Касетный гранатомет АГС \"Матрёшка\""
	desc = "Оружие для боевых экзокостюмов. Запускает кластерные гранаты. Ты чудовище."
	projectiles = 3
	projectiles_cache = 0
	projectiles_cache_max = 0
	disabledreload = TRUE
	projectile = /obj/item/grenade/clusterbuster
	equip_cooldown = 90
	ammo_type = "clusterbang"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar
	name = "Бананомет"
	desc = "Оборудование для клоунских экзокостюмов. Запускает банановую кожуру."
	icon_state = "mecha_bananamrtr"
	projectile = /obj/item/grown/bananapeel
	fire_sound = 'sound/items/bikehorn.ogg'
	projectiles = 15
	missile_speed = 1.5
	projectiles_cache = 999
	equip_cooldown = 20
	mech_flags = EXOSUIT_MODULE_HONK

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar/can_attach(obj/vehicle/sealed/mecha/combat/honker/M, attach_right = FALSE)
	if(..())
		if(istype(M))
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/mousetrap_mortar
	name = "Мышеловкометатель"
	desc = "Оборудование для клоунских экзокостюмов. Запускает заряженные мышеловки."
	icon_state = "mecha_mousetrapmrtr"
	projectile = /obj/item/assembly/mousetrap/armed
	fire_sound = 'sound/items/bikehorn.ogg'
	projectiles = 15
	missile_speed = 1.5
	projectiles_cache = 999
	equip_cooldown = 10
	mech_flags = EXOSUIT_MODULE_HONK

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/mousetrap_mortar/can_attach(obj/vehicle/sealed/mecha/combat/honker/M, attach_right = FALSE)
	if(..())
		if(istype(M))
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/mousetrap_mortar/proj_init(obj/item/assembly/mousetrap/armed/M)
	M.secured = 1


//Classic extending punching glove, but weaponised!
/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/punching_glove
	name = "Оинго-Боинго-Лице-Ломатель"
	desc = "Оборудование для клоунских экзокостюмов. Доставляет удовольствие прямо вам в лицо!"
	icon_state = "mecha_punching_glove"
	energy_drain = 250
	equip_cooldown = 20
	range = MECHA_MELEE|MECHA_RANGED
	missile_range = 5
	projectile = /obj/item/punching_glove
	fire_sound = 'sound/items/bikehorn.ogg'
	projectiles = 10
	projectiles_cache = 999
	harmful = TRUE
	diags_first = TRUE
	/// Damage done by the glove on contact. Also used to determine throw distance (damage / 5)
	var/punch_damage = 35
	mech_flags = EXOSUIT_MODULE_HONK

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/punching_glove/can_attach(obj/vehicle/sealed/mecha/combat/honker/M, attach_right = FALSE)
	if(..())
		if(istype(M))
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/punching_glove/get_snowflake_data()
	return list(
		"snowflake_id" = MECHA_SNOWFLAKE_ID_MODE,
		"mode" = harmful ? "LETHAL FISTING" : "Cuddles",
	)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/punching_glove/ui_act(action, list/params)
	. = ..()
	if(action == "toggle")
		harmful = !harmful
		if(harmful)
			to_chat(usr, "[icon2html(src, usr)]<span class='warning'>Lethal Fisting Enabled.</span>")
		else
			to_chat(usr, "[icon2html(src, usr)][span_warning("Lethal Fisting Disabled.")]")
		return TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/punching_glove/action(mob/source, atom/target, params)
	. = ..()
	if(.)
		to_chat(usr, "[icon2html(src, usr)]<font color='red' size='5'>HONK</font>")

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/punching_glove/proj_init(obj/item/punching_glove/PG)
	if(!istype(PG))
		return

	if(harmful)
		PG.throwforce = punch_damage
	else
		PG.throwforce = 0

	chassis.Beam(PG, icon_state = "chain", time = missile_range * 20, maxdistance = missile_range + 2)

/obj/item/punching_glove
	name = "punching glove"
	desc = "INCOMING HONKS"
	throwforce = 35
	icon_state = "punching_glove"

/obj/item/punching_glove/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		if(ismovable(hit_atom))
			var/atom/movable/AM = hit_atom
			AM.safe_throw_at(get_edge_target_turf(AM,get_dir(src, AM)), clamp(round(throwforce/5), 2, 20), 2) //Throws them equal to damage/5, with a min range of 2 and max range of 20
		qdel(src)

///dark honk weapons

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar/bombanana
	name = "Банановзрыв"
	desc = "Оборудование для клоунских экзокостюмов. Запускает взрывающиеся банановые кожуры."
	icon_state = "mecha_bananamrtr"
	projectile = /obj/item/grown/bananapeel/bombanana
	projectiles = 8
	projectiles_cache = 999

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar/bombanana/can_attach(obj/vehicle/sealed/mecha/combat/honker/M, attach_right = FALSE)
	if(..())
		if(istype(M))
			return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang/tearstache
	name = "Автоматический гранатомет АГС \"ХОНКеР-6\""
	desc = "Оружие для боевых экзокостюмов. Запускает заряженные гранаты со слезоточивым газом."
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/grenade/chem_grenade/teargas/moustache
	fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	projectiles = 6
	missile_speed = 1.5
	projectiles_cache = 999
	equip_cooldown = 60
	det_time = 20

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang/tearstache/can_attach(obj/vehicle/sealed/mecha/combat/honker/M, attach_right = FALSE)
	if(..())
		if(istype(M))
			return TRUE
	return FALSE
