/datum/element/impaling
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	var/throw_range
	var/throw_force
	var/obj/impaler
	var/crit_only

/datum/element/impaling/Attach(datum/target, range = 2, force = MOVE_FORCE_STRONG, critonly = FALSE)
	. = ..()
	if(!isitem(target) && !isprojectile(target))
		return ELEMENT_INCOMPATIBLE
	if(isitem(target))
		RegisterSignal(target, COMSIG_MOVABLE_IMPACT_ZONE, PROC_REF(onHit))
	else
		RegisterSignal(target, COMSIG_PROJECTILE_SELF_ON_HIT, PROC_REF(onHitProj))
	throw_range = range
	throw_force = force
	crit_only = critonly

/datum/element/impaling/Detach(datum/source, force)
	if(isitem(source))
		UnregisterSignal(source, COMSIG_MOVABLE_IMPACT_ZONE)
	else
		UnregisterSignal(source, COMSIG_PROJECTILE_SELF_ON_HIT)
	. = ..()

/datum/element/impaling/proc/onHit(obj/item/weapon, mob/living/carbon/victim, hit_zone, datum/thrownthing/throwingdatum, forced=FALSE)
	SIGNAL_HANDLER
	if(!iscarbon(victim))
		return
	impaler = weapon
	throw_thing(victim, throwingdatum.init_dir, weapon.throwforce)

/datum/element/impaling/proc/onHitProj(obj/projectile/P, atom/movable/firer, atom/hit, angle, hit_zone)
	SIGNAL_HANDLER
	if(!iscarbon(hit))
		return
	impaler = P
	throw_thing(hit, angle2dir(angle), P.damage)

/datum/element/impaling/proc/throw_thing(mob/living/carbon/C, dir, additional_dmg)
	//message_admins("[C.health - additional_dmg]")
	if(crit_only && !C.stat && !(C.health - additional_dmg*2 <= 0)) //эта хуйня с допдамагом ни в какую не хочет работать, криво считает почему-то
		return
	var/move_target = get_ranged_target_turf(C, dir, 5)
	RegisterSignal(C, COMSIG_MOVABLE_IMPACT, PROC_REF(impale))
	C.throw_at(move_target, throw_range, 5, spin=FALSE, force = throw_force)
	addtimer(CALLBACK(src, PROC_REF(unreg_throw), C), 3 SECONDS) //ну а хули, такие же смешные костыли и в генетических мутациях есть

/datum/element/impaling/proc/unreg_throw(atom/thrown)
	UnregisterSignal(thrown, COMSIG_MOVABLE_IMPACT)

/datum/element/impaling/proc/impale(mob/living/carbon/source, atom/hit_atom, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	if(!isclosedturf(hit_atom))
		if(istype(hit_atom, /obj/structure/window))
			var/obj/structure/window/W = hit_atom
			if(!W.fulltile)
				return
		else
			return
	source.AddComponent(/datum/component/impaled, impaler, hit_atom)
