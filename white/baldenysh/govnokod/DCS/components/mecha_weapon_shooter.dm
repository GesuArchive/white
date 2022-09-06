/datum/component/mecha_weapon_shooter //позволяет стрелять из пушек мехов
	var/shooting_delay = 0
	var/energy_drain_mod = 1
	var/aiming = FALSE

/datum/component/mecha_weapon_shooter/Initialize(mapload)
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/mecha_weapon_shooter/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_CLICKON, .proc/checkShoot)

/datum/component/mecha_weapon_shooter/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_CLICKON)

/datum/component/mecha_weapon_shooter/proc/checkShoot(mob/living/user, atom/A, params)
	SIGNAL_HANDLER
	if(user.incapacitated())
		return
	if(!istype(user.get_active_held_item(), /obj/item/mecha_parts/mecha_equipment/weapon))
		return
	if(!A)
		return
	if(HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return

	user.face_atom(A)

	var/list/modifiers = params2list(params)
	if(modifiers["alt"] || modifiers["shift"] || modifiers["ctrl"] || modifiers["middle"])
		return

	if(aiming)
		return

	INVOKE_ASYNC(src, .proc/doShoot, user, A, user.get_active_held_item())

	return (COMSIG_MOB_CANCEL_CLICKON)

/datum/component/mecha_weapon_shooter/proc/doShoot(mob/living/carbon/shooter, atom/target, obj/item/mecha_parts/mecha_equipment/weapon/W)
	if(!target)
		to_chat(shooter, span_warning("[W]: ОШИБКА: Цель не обнаружена!"))
		return
	if(!W.equip_ready)
		to_chat(shooter, span_warning("[W]: ОШИБКА: Оборудование не готово!"))
		return

	if(istype(W, /obj/item/mecha_parts/mecha_equipment/weapon/honker)) //впадлу для этой хуйни отдельный прок пилить
		to_chat(shooter, span_warning("Стрельба из этого оружия приведет к крайне плачевным последствиям для стрелка. Отмена."))
		return

	var/obj/item/stock_parts/cell/charge_source
	if(W.energy_drain)
		charge_source = locate(/obj/item/stock_parts/cell) in shooter.held_items
		if(!charge_source || charge_source.charge < W.energy_drain*energy_drain_mod)
			to_chat(shooter, span_warning("[W]: ОШИБКА: Не найден подходящий источник питания!"))
			return

	if(istype(W, /obj/item/mecha_parts/mecha_equipment/weapon/ballistic))
		var/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/B = W
		if(B.projectiles <= 0)
			to_chat(shooter, span_warning("[W]: ОШИБКА: Боезапас израсходован!"))
			return

	if(shooting_delay > 0)
		shooter.visible_message(span_danger("[shooter] целится из [W] в [target]!") , \
			 span_danger("Начинаю целиться в [target]!"))
		aiming = TRUE
		if(!do_after(shooter, shooting_delay, W, timed_action_flags = IGNORE_USER_LOC_CHANGE))
			aiming = FALSE
			to_chat(shooter, span_warning("Что-то помешало мне прицелиться!"))
			return
		aiming = FALSE

	var/newtonian_target = turn(shooter.dir,180)
	if(TIMER_COOLDOWN_CHECK(shooter, COOLDOWN_MECHA_EQUIPMENT))
		to_chat(shooter, span_warning("[W]: ОШИБКА: Оборудование не готово после прошлого использования!"))
		return
	TIMER_COOLDOWN_START(shooter, COOLDOWN_MECHA_EQUIPMENT, W.equip_cooldown)

	if(charge_source)
		charge_source.use(W.energy_drain*energy_drain_mod)

	shooter.visible_message(span_danger("[shooter] стреляет из [W] в [target]!") , \
			 span_danger("Стреляю из [W] в [target]!"))

	if(istype(W, /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher))
		var/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/L = W
		var/obj/O = new L.projectile(shooter.loc)
		playsound(shooter, L.fire_sound, 50, TRUE)
		L.log_message("Launched a [O.name] from [L.name], targeting [target].", LOG_MECHA)
		L.projectiles--
		L.proj_init(O, shooter)
		O.throw_at(target, L.missile_range, L.missile_speed, shooter, FALSE, diagonals_first = L.diags_first)
		return

	for(var/i in 1 to W.projectiles_per_shot)
		if(W.energy_drain && charge_source.charge < W.energy_drain*energy_drain_mod)
			break
		var/spread = 0
		if(W.variance)
			if(W.randomspread)
				spread = round((rand() - 0.5) * W.variance)
			else
				spread = round((i / W.projectiles_per_shot - 0.5) * W.variance)

		var/obj/projectile/A = new W.projectile(get_turf(shooter))
		A.preparePixelProjectile(target, shooter, 0, spread)

		A.fire()
		if(!A.suppressed && W.firing_effect_type)
			new W.firing_effect_type(get_turf(src), shooter.dir)
		playsound(shooter, W.fire_sound, 50, TRUE)

		sleep(max(0, W.projectile_delay))

		if(W.kickback)
			shooter.newtonian_move(newtonian_target)

	shooter.log_message("Mechlink gloves: Fired from [W], targeting [target].", LOG_ATTACK)

	if(istype(W, /obj/item/mecha_parts/mecha_equipment/weapon/ballistic))
		var/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/B = W
		B.projectiles -= B.projectiles_per_shot
