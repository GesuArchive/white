/datum/element/impaling
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2
	var/throw_range
	var/throw_force
	var/obj/impaler

/datum/element/impaling/Attach(datum/target, trange = 2, tforce = MOVE_FORCE_STRONG)
	. = ..()
	if(!isitem(target) && !isprojectile(target))
		return ELEMENT_INCOMPATIBLE
	if(isitem(target))
		RegisterSignal(target, COMSIG_MOVABLE_IMPACT_ZONE, .proc/onHit)
	else
		RegisterSignal(target, COMSIG_PROJECTILE_SELF_ON_HIT, .proc/onHitProj)
	throw_range = trange
	throw_force = tforce

/datum/element/impaling/Detach(datum/source, force)
	if(isitem(source))
		UnregisterSignal(source, COMSIG_MOVABLE_IMPACT_ZONE)
	else
		UnregisterSignal(source, COMSIG_PROJECTILE_SELF_ON_HIT)
	. = ..()

/datum/element/impaling/proc/onHit(obj/item/weapon, mob/living/carbon/victim, hit_zone, datum/thrownthing/throwingdatum, forced=FALSE)
	if(!iscarbon(victim))
		return
	throw_thing(victim, throwingdatum.init_dir)
	impaler = weapon

/datum/element/impaling/proc/onHitProj(obj/projectile/P, atom/movable/firer, atom/hit, angle, hit_zone)
	if(!iscarbon(hit))
		return
	impaler = P
	throw_thing(hit, angle2dir(angle))

/datum/element/impaling/proc/throw_thing(mob/living/carbon/C, dir)
	var/move_target = get_ranged_target_turf(C, dir, 5)
	RegisterSignal(C, COMSIG_MOVABLE_IMPACT, .proc/impale)
	C.throw_at(move_target, throw_range, 5, force = throw_force)
	addtimer(CALLBACK(src, .proc/unreg_throw, C), 3 SECONDS)

/datum/element/impaling/proc/unreg_throw(atom/thrown)
	UnregisterSignal(thrown, COMSIG_MOVABLE_IMPACT)

/datum/element/impaling/proc/impale(mob/living/carbon/source, atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!isclosedturf(hit_atom))
		return
	source.AddComponent(/datum/component/impaled, impaler, hit_atom)
