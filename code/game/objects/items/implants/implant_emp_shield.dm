/obj/item/implant/empshield
	name = "Имплант ЭМИ щита"
	desc = "Имплантат, полностью защищающий от электромагнитных импульсов. При слишком частом срабатывании он кратковременно отключается."
	actions_types = null
	activated = TRUE
	var/lastemp = 0
	var/numrecent = 0
	var/warning = TRUE
	var/overloadtimer = 10 SECONDS

/obj/item/implant/empshield/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	if(..())
		if(!. || !ismob(target))
			target.AddComponent(/datum/component/empprotection, EMP_PROTECT_SELF)
			RegisterSignal(target, COMSIG_ATOM_EMP_ACT, PROC_REF(overloaded), target)
		return TRUE

/obj/item/implant/empshield/removed(mob/target, silent = FALSE, special = 0)
	if(..())
		if(!. || !ismob(target))
			var/datum/component/empprotection/empshield = target.GetExactComponent(/datum/component/empprotection)
			if(empshield)
				empshield.Destroy()
			UnregisterSignal(target, COMSIG_ATOM_EMP_ACT)
		return TRUE

/obj/item/implant/empshield/proc/overloaded(mob/living/target)
	if(world.time - lastemp > overloadtimer)
		numrecent = 0
	numrecent ++
	lastemp = world.time

	if(numrecent >= 5 && ishuman(target))
		if(warning)
			to_chat(imp_in, span_hear("Вы чувствуете, как что-то внутри [src] перестало работать. Возникает ощущение, что он уже не защитит вас."))
			warning = FALSE
		var/datum/component/empprotection/empshield = target.GetExactComponent(/datum/component/empprotection)
		if(empshield)
			empshield.Destroy()
		addtimer(CALLBACK(src, PROC_REF(refreshed), target), overloadtimer, TIMER_OVERRIDE | TIMER_UNIQUE)

/obj/item/implant/empshield/proc/refreshed(mob/living/target)
	to_chat(imp_in, span_hear("Вы ощущаете знакомое покалывание в [src], кажется, что он снова работает."))
	warning = TRUE
	if(!. || !ismob(target))
		target.AddComponent(/datum/component/empprotection, EMP_PROTECT_SELF)

/obj/item/implanter/empshield
	name = "implanter (EMP shield)"
	imp_type = /obj/item/implant/empshield
