/datum/component/mecha_weapon_shooter //позволяет стрелять из пушек мехов
	var/shooting_delay = 0
	var/energy_drain_mod = 1
	var/aiming = FALSE

/datum/component/mecha_weapon_shooter/Initialize()
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
		to_chat(shooter, "<span class='warning'>[W]: ОШИБКА: Цель не обнаружена!</span>")
		return
	if(!W.equip_ready)
		to_chat(shooter, "<span class='warning'>[W]: ОШИБКА: Оборудование не готово!</span>")
		return

	if(istype(W, /obj/item/mecha_parts/mecha_equipment/weapon/honker)) //впадлу для этой хуйни отдельный прок пилить
		to_chat(shooter, "<span class='warning'>[parent]: ОШИБКА: Стрельба из этого оружия приведет к крайне плачевным последствиям для стрелка. Отмена.</span>")
		return

	var/obj/item/stock_parts/cell/charge_source
	if(W.energy_drain)
		charge_source = locate(/obj/item/stock_parts/cell) in shooter.held_items
		if(!charge_source || charge_source.charge < W.energy_drain*energy_drain_mod)
			to_chat(shooter, "<span class='warning'>[W]: ОШИБКА: Не найден подходящий источник питания!</span>")
			return

	if(istype(W, /obj/item/mecha_parts/mecha_equipment/weapon/ballistic))
		var/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/B = W
		if(B.projectiles <= 0)
			to_chat(shooter, "<span class='warning'>[W]: ОШИБКА: Боезапас израсходован!</span>")
			return

	if(shooting_delay > 0)
		shooter.visible_message("<span class='danger'>[shooter] целится из [W] в [target]!</span>", \
			 "<span class='danger'>Начинаю целиться в [target]!</span>")
		aiming = TRUE
		if(!do_after(shooter, shooting_delay, null, timed_action_flags = IGNORE_USER_LOC_CHANGE))
			aiming = FALSE
			to_chat(shooter, "<span class='warning'>Что-то помешало мне прицелиться!</span>")
			return
		aiming = FALSE

	var/newtonian_target = turn(shooter.dir,180)
	if(TIMER_COOLDOWN_CHECK(shooter, COOLDOWN_MECHA_EQUIPMENT))
		to_chat(shooter, "<span class='warning'>[W]: ОШИБКА: Оборудование не готово после прошлого использования!</span>")
		return
	TIMER_COOLDOWN_START(shooter, COOLDOWN_MECHA_EQUIPMENT, W.equip_cooldown)

	if(charge_source)
		charge_source.use(W.energy_drain*energy_drain_mod)

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
