///Kinesis - Gives you the ability to move and launch objects.
/obj/item/mod/module/anomaly_locked/kinesis
	name = "кинезис модуль"
	desc = "Модуль, подключаемый к предплечью, технология изготовления которого считалась потерянной в течение многих лет, \
		и крайне редко встречаемый за исключением немногочисленных сохранившихся образцов. \
		Эта технология позволяет пользователю создавать точные антигравитационные поля, \
		позволяя им перемещать объекты размером от от небольшого металлического стержня до больших промышленных машин. \
		Как ни странно, это не работает на живых существах."
	icon_state = "kinesis"
	module_type = MODULE_ACTIVE
	complexity = 3
	use_power_cost = DEFAULT_CHARGE_DRAIN*3
	incompatible_modules = list(/obj/item/mod/module/anomaly_locked/kinesis)
	cooldown_time = 0.5 SECONDS
	overlay_state_inactive = "module_kinesis"
	overlay_state_active = "module_kinesis_on"
	accepted_anomalies = list(/obj/item/assembly/signaler/anomaly/grav)
	/// Range of the knesis grab.
	var/grab_range = 5
	/// Time between us hitting objects with kinesis.
	var/hit_cooldown_time = 1 SECONDS
	/// Stat required for us to grab a mob.
	var/stat_required = DEAD
	/// How long we stun a mob for.
	var/mob_stun_time = 5 SECONDS
	/// Atom we grabbed with kinesis.
	var/atom/movable/grabbed_atom
	/// Ref of the beam following the grabbed atom.
	var/datum/beam/kinesis_beam
	/// Overlay we add to each grabbed atom.
	var/mutable_appearance/kinesis_icon
	/// Our mouse movement catcher.
	var/atom/movable/screen/fullscreen/kinesis/kinesis_catcher
	/// The sounds playing while we grabbed an object.
	var/datum/looping_sound/gravgen/kinesis/soundloop
	/// The cooldown between us hitting objects with kinesis.
	COOLDOWN_DECLARE(hit_cooldown)

/obj/item/mod/module/anomaly_locked/kinesis/Initialize(mapload)
	. = ..()
	soundloop = new(src)

/obj/item/mod/module/anomaly_locked/kinesis/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/item/mod/module/anomaly_locked/kinesis/on_select_use(atom/target)
	. = ..()
	if(!.)
		return
	if(!mod.wearer.client)
		return
	if(grabbed_atom)
		launch()
		clear_grab(playsound = FALSE)
		return
	if(!range_check(target))
		balloon_alert(mod.wearer, "Слишком далеко!")
		return
	if(!can_grab(target))
		balloon_alert(mod.wearer, "Не могу схватить!")
		return
	drain_power(use_power_cost)
	grabbed_atom = target
	if(isliving(grabbed_atom))
		var/mob/living/grabbed_mob = grabbed_atom
		grabbed_mob.Stun(mob_stun_time)
	playsound(grabbed_atom, 'sound/effects/contractorbatonhit.ogg', 75, TRUE)
	kinesis_icon = mutable_appearance(icon='icons/effects/effects.dmi', icon_state="kinesis", layer=grabbed_atom.layer-0.1)
	kinesis_icon.appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM
	grabbed_atom.add_overlay(kinesis_icon)
	kinesis_beam = mod.wearer.Beam(grabbed_atom, "kinesis")
	kinesis_catcher = mod.wearer.overlay_fullscreen("kinesis", /atom/movable/screen/fullscreen/kinesis, 0)
	kinesis_catcher.kinesis_user = mod.wearer
	kinesis_catcher.view_list = getviewsize(mod.wearer.client.view)
	kinesis_catcher.RegisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/atom/movable/screen/fullscreen/kinesis, on_move))
	kinesis_catcher.RegisterSignal(mod.wearer, COMSIG_VIEWDATA_UPDATE, TYPE_PROC_REF(/atom/movable/screen/fullscreen/kinesis, on_viewdata_update))
	kinesis_catcher.calculate_params()
	soundloop.start()
	START_PROCESSING(SSfastprocess, src)

/obj/item/mod/module/anomaly_locked/kinesis/on_deactivation(display_message = TRUE, deleting = FALSE)
	. = ..()
	if(!.)
		return
	clear_grab(playsound = !deleting)

/obj/item/mod/module/anomaly_locked/kinesis/process(delta_time)
	if(!mod.wearer.client || mod.wearer.incapacitated(IGNORE_GRAB))
		clear_grab()
		return
	if(!range_check(grabbed_atom))
		balloon_alert(mod.wearer, "Вне радиуса!")
		clear_grab()
		return
	kinesis_catcher.calculate_params()
	if(!kinesis_catcher.given_turf)
		clear_grab()
		return
	drain_power(use_power_cost/10)
	mod.wearer.setDir(get_dir(mod.wearer, grabbed_atom))
	grabbed_atom.set_glide_size()
	if(grabbed_atom.loc == kinesis_catcher.given_turf)
		if(grabbed_atom.pixel_x == kinesis_catcher.given_x - world.icon_size/2 && grabbed_atom.pixel_y == kinesis_catcher.given_y - world.icon_size/2)
			return //spare us redrawing if we are standing still
		animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x + kinesis_catcher.given_x - world.icon_size/2, pixel_y = grabbed_atom.base_pixel_y + kinesis_catcher.given_y - world.icon_size/2)
		kinesis_beam.redrawing()
		return
	animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x + kinesis_catcher.given_x - world.icon_size/2, pixel_y = grabbed_atom.base_pixel_y + kinesis_catcher.given_y - world.icon_size/2)
	kinesis_beam.redrawing()
	var/turf/next_turf = get_step_towards(grabbed_atom, kinesis_catcher.given_turf)
	if(grabbed_atom.Move(next_turf))
		if(isitem(grabbed_atom) && (mod.wearer in next_turf))
			var/obj/item/grabbed_item = grabbed_atom
			clear_grab()
			grabbed_item.pickup(mod.wearer)
			mod.wearer.put_in_hands(grabbed_item)
		return
	var/pixel_x_change = 0
	var/pixel_y_change = 0
	var/direction = get_dir(grabbed_atom, next_turf)
	if(direction & NORTH)
		pixel_y_change = world.icon_size/2
	else if(direction & SOUTH)
		pixel_y_change = -world.icon_size/2
	if(direction & EAST)
		pixel_x_change = world.icon_size/2
	else if(direction & WEST)
		pixel_x_change = -world.icon_size/2
	animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x + pixel_x_change, pixel_y = grabbed_atom.base_pixel_y + pixel_y_change)
	kinesis_beam.redrawing()
	if(!isitem(grabbed_atom) || !COOLDOWN_FINISHED(src, hit_cooldown))
		return
	var/atom/hitting_atom
	if(next_turf.density)
		hitting_atom = next_turf
	for(var/atom/movable/movable_content as anything in next_turf.contents)
		if(ismob(movable_content))
			continue
		if(movable_content.density)
			hitting_atom = movable_content
			break
	var/obj/item/grabbed_item = grabbed_atom
	grabbed_item.melee_attack_chain(mod.wearer, hitting_atom)
	COOLDOWN_START(src, hit_cooldown, hit_cooldown_time)

/obj/item/mod/module/anomaly_locked/kinesis/proc/can_grab(atom/target)
	if(mod.wearer == target)
		return FALSE
	if(!ismovable(target))
		return FALSE
	if(iseffect(target))
		return FALSE
	var/atom/movable/movable_target = target
	if(movable_target.anchored)
		return FALSE
	if(movable_target.throwing)
		return FALSE
	if(movable_target.move_resist >= MOVE_FORCE_OVERPOWERING)
		return FALSE
	if(ismob(movable_target))
		if(!isliving(movable_target))
			return FALSE
		var/mob/living/living_target = movable_target
		if(living_target.stat < stat_required)
			return FALSE
	else if(isitem(movable_target))
		var/obj/item/item_target = movable_target
		if(item_target.w_class >= WEIGHT_CLASS_GIGANTIC)
			return FALSE
		if(item_target.item_flags & ABSTRACT)
			return FALSE
	return TRUE

/obj/item/mod/module/anomaly_locked/kinesis/proc/clear_grab(playsound = TRUE)
	if(!grabbed_atom)
		return
	if(playsound)
		playsound(grabbed_atom, 'sound/effects/empulse.ogg', 75, TRUE)
	STOP_PROCESSING(SSfastprocess, src)
	kinesis_catcher = null
	mod.wearer.clear_fullscreen("kinesis")
	grabbed_atom.cut_overlay(kinesis_icon)
	QDEL_NULL(kinesis_beam)
	if(!isitem(grabbed_atom))
		animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x, pixel_y = grabbed_atom.base_pixel_y)
	grabbed_atom = null
	soundloop.stop()

/obj/item/mod/module/anomaly_locked/kinesis/proc/range_check(atom/target)
	if(!isturf(mod.wearer.loc))
		return FALSE
	if(ismovable(target) && !isturf(target.loc))
		return FALSE
	if(!can_see(mod.wearer, target, grab_range))
		return FALSE
	return TRUE

/obj/item/mod/module/anomaly_locked/kinesis/proc/launch()
	playsound(grabbed_atom, 'sound/magic/repulse.ogg', 100, TRUE)
	RegisterSignal(grabbed_atom, COMSIG_MOVABLE_IMPACT, PROC_REF(launch_impact))
	var/turf/target_turf = get_turf_in_angle(get_angle(mod.wearer, grabbed_atom), get_turf(src), 10)
	grabbed_atom.throw_at(target_turf, range = grab_range, speed = grabbed_atom.density ? 3 : 4, thrower = mod.wearer, spin = isitem(grabbed_atom))

/obj/item/mod/module/anomaly_locked/kinesis/proc/launch_impact(obj/source, obj/hit_obj, datum/thrownthing/thrownthing)
	UnregisterSignal(source, COMSIG_MOVABLE_IMPACT)
	if(!(isstructure(source) || ismachinery(source) || isvehicle(source)))
		return
	var/damage_self = TRUE
	var/damage = 8
	if(source.density)
		damage_self = FALSE
		damage = 15
	if(isliving(hit_obj))
		var/mob/living/living_atom = hit_obj
		living_atom.apply_damage(damage, BRUTE)
	else if(hit_obj.obj_integrity)
		hit_obj.take_damage(damage, BRUTE, MELEE)
	if(damage_self && source.obj_integrity)
		source.take_damage(source.max_integrity/5, BRUTE, MELEE)

/obj/item/mod/module/anomaly_locked/kinesis/prebuilt
	prebuilt = TRUE

/obj/item/mod/module/anomaly_locked/kinesis/prebuilt/prototype
	name = "MOD прототип кинезис модуля"
	complexity = 0
	use_power_cost = DEFAULT_CHARGE_DRAIN * 5
	removable = FALSE

/atom/movable/screen/fullscreen/kinesis
	icon_state = "kinesis"
	plane = HUD_PLANE
	mouse_opacity = MOUSE_OPACITY_ICON
	var/mob/kinesis_user
	var/list/view_list
	var/given_x
	var/given_y
	var/turf/given_turf
	var/mouse_params

/atom/movable/screen/fullscreen/kinesis/proc/on_move(atom/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER

	if(given_turf)
		var/x_offset = source.loc.x - oldloc.x
		var/y_offset = source.loc.y - oldloc.y
		given_turf = locate(given_turf.x+x_offset, given_turf.y+y_offset, given_turf.z)

/atom/movable/screen/fullscreen/kinesis/proc/on_viewdata_update(datum/source, view)
	SIGNAL_HANDLER

	view_list = getviewsize(view)

/atom/movable/screen/fullscreen/kinesis/MouseEntered(location, control, params)
	. = ..()
	MouseMove(location, control, params)
	if(usr == kinesis_user)
		calculate_params()

/atom/movable/screen/fullscreen/kinesis/MouseMove(location, control, params)
	if(usr != kinesis_user)
		return
	mouse_params = params

/atom/movable/screen/fullscreen/kinesis/proc/calculate_params()
	var/list/modifiers = params2list(mouse_params)
	var/icon_x = text2num(LAZYACCESS(modifiers, VIS_X)) || view_list[1]*world.icon_size/2
	var/icon_y = text2num(LAZYACCESS(modifiers, VIS_Y)) || view_list[2]*world.icon_size/2
	var/our_x = round(icon_x / world.icon_size)
	var/our_y = round(icon_y / world.icon_size)
	given_turf = locate(kinesis_user.x+our_x-round(view_list[1]/2),kinesis_user.y+our_y-round(view_list[2]/2),kinesis_user.z)
	given_x = round(icon_x - world.icon_size * our_x, 1)
	given_y = round(icon_y - world.icon_size * our_y, 1)

/obj/item/mod/module/anomaly_locked/kinesis/plus
	name = "продвинутый кинезис модуль"
	desc = "Секретная военная разработка безымянного правительственного оружейного концерна. \
		Продвинутый кинезис модуль - это мощный тактический инструмент, позволяющий пользователю воздействовать на физическую природу гравитации. \
		В отличии от своего раннего прототипа эта модель так же способна воздействовать на живые объекты. \
		Однако, они все еще могут бороться с гравитационным захватом."
	complexity = 0
	prebuilt = TRUE
	stat_required = CONSCIOUS
