#define STASIS_TOGGLE_COOLDOWN 50
/obj/machinery/stasis
	name = "Стазисная кровать"
	desc = "Не очень комфортная кровать, которая постоянно жужжит, однако она помещает пациента в стазис с надеждой, что когда-нибудь он все-таки дождется помощи."
	icon = 'icons/obj/machines/stasis.dmi'
	icon_state = "stasis"
	density = FALSE
	can_buckle = TRUE
	buckle_lying = 90
	circuit = /obj/item/circuitboard/machine/stasis
	fair_market_price = 0
	payment_department = ACCOUNT_MED
	var/stasis_enabled = TRUE
	var/last_stasis_sound = FALSE
	var/stasis_can_toggle = 0
	var/mattress_state = "stasis_on"
	var/obj/effect/overlay/vis/mattress_on
	var/obj/machinery/computer/operating/op_computer

	//	Модификация ремнями
	var/handbeltsmod = FALSE
	var/handbeltsmod_active = FALSE
	var/static/mutable_appearance/handbeltsmod_overlay = mutable_appearance('white/Feline/icons/stasis.dmi', "mark", LYING_MOB_LAYER)
	var/static/mutable_appearance/handbeltsmod_active_overlay = mutable_appearance('white/Feline/icons/stasis.dmi', "belts", LYING_MOB_LAYER)

/obj/machinery/stasis/Initialize()
	. = ..()
	if(handbeltsmod)
		add_overlay(handbeltsmod_overlay)
	for(var/direction in GLOB.alldirs)
		op_computer = locate(/obj/machinery/computer/operating) in get_step(src, direction)
		if(op_computer)
			op_computer.sbed = src
			break

/obj/machinery/stasis/Destroy()
	. = ..()
	if(op_computer && op_computer.sbed == src)
		op_computer.sbed = null

/obj/machinery/stasis/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Alt + Клик для [stasis_enabled ? "<b>выключения</b>" : "<b>включения</b>"] машины.</span>"
	if(handbeltsmod)
		. += "<hr><span class='notice'>ПКМ для активации <b>энергетических ремней</b>, ЛКМ для отстегивания.</span>"
	. += span_notice("\n<b>[src.name]</b> [op_computer ? "синхронизирована" : "<b>НЕ</b> синхронизирована"] с операционным компьютером.")

/obj/machinery/stasis/proc/play_power_sound()
	var/_running = stasis_running()
	if(last_stasis_sound != _running)
		var/sound_freq = rand(5120, 8800)
		if(_running)
			playsound(src, 'sound/machines/synth_yes.ogg', 50, TRUE, frequency = sound_freq)
		else
			playsound(src, 'sound/machines/synth_no.ogg', 50, TRUE, frequency = sound_freq)
		last_stasis_sound = _running

/obj/machinery/stasis/AltClick(mob/user)
	if(world.time >= stasis_can_toggle && user.canUseTopic(src, !issilicon(user)))
		stasis_enabled = !stasis_enabled
		stasis_can_toggle = world.time + STASIS_TOGGLE_COOLDOWN
		playsound(src, 'sound/machines/click.ogg', 60, TRUE)
		user.visible_message(span_notice("<b>[src.name]</b> [stasis_enabled ? "включается" : "выключается"].") , \
					span_notice("[stasis_enabled ? "Включаю" : "Выключаю"] <b>[src.name]</b>.") , \
					span_hear("Слышу звук [stasis_enabled ? "включения" : "выключения"] машины."))
		play_power_sound()
		update_icon()

/obj/machinery/stasis/Exited(atom/movable/AM, atom/newloc)
	if(AM == occupant)
		var/mob/living/L = AM
		if(IS_IN_STASIS(L))
			thaw_them(L)
	. = ..()

/obj/machinery/stasis/proc/stasis_running()
	return stasis_enabled && is_operational

/obj/machinery/stasis/update_icon_state()
	if(machine_stat & BROKEN)
		icon_state = "stasis_broken"
		return
	if(panel_open || machine_stat & MAINT)
		icon_state = "stasis_maintenance"
		return
	icon_state = "stasis"

/obj/machinery/stasis/update_overlays()
	. = ..()
	var/_running = stasis_running()
	var/list/overlays_to_remove = managed_vis_overlays

	if(mattress_state)
		if(!mattress_on || !managed_vis_overlays)
			mattress_on = SSvis_overlays.add_vis_overlay(src, icon, mattress_state, BELOW_OBJ_LAYER, plane, dir, alpha = 0, unique = TRUE)

		if(mattress_on.alpha ? !_running : _running) //check the inverse of _running compared to truthy alpha, to see if they differ
			var/new_alpha = _running ? 255 : 0
			var/easing_direction = _running ? EASE_OUT : EASE_IN
			animate(mattress_on, alpha = new_alpha, time = 50, easing = CUBIC_EASING|easing_direction)

		overlays_to_remove = managed_vis_overlays - mattress_on

	SSvis_overlays.remove_vis_overlay(src, overlays_to_remove)

/obj/machinery/stasis/obj_break(damage_flag)
	. = ..()
	if(.)
		play_power_sound()

/obj/machinery/stasis/power_change()
	. = ..()
	play_power_sound()

/obj/machinery/stasis/proc/chill_out(mob/living/target)
	if(target != occupant)
		return
	var/freq = rand(24750, 26550)
	playsound(src, 'sound/effects/spray.ogg', 5, TRUE, 2, frequency = freq)
	target.apply_status_effect(STATUS_EFFECT_STASIS, STASIS_MACHINE_EFFECT)
	ADD_TRAIT(target, TRAIT_TUMOR_SUPPRESSED, TRAIT_GENERIC)
	target.extinguish_mob()
	update_use_power(ACTIVE_POWER_USE)

/obj/machinery/stasis/proc/thaw_them(mob/living/target)
	target.remove_status_effect(STATUS_EFFECT_STASIS, STASIS_MACHINE_EFFECT)
	REMOVE_TRAIT(target, TRAIT_TUMOR_SUPPRESSED, TRAIT_GENERIC)
	if(target == occupant)
		update_use_power(IDLE_POWER_USE)

/obj/machinery/stasis/post_buckle_mob(mob/living/L)
	if(!can_be_occupant(L))
		return
	set_occupant(L)
	if(stasis_running() && check_nap_violations())
		chill_out(L)
	update_icon()

/obj/machinery/stasis/post_unbuckle_mob(mob/living/L)
	thaw_them(L)
	if(L == occupant)
		set_occupant(null)
	update_icon()

/obj/machinery/stasis/process()
	if(!(occupant && isliving(occupant) && check_nap_violations()))
		update_use_power(IDLE_POWER_USE)
		return
	var/mob/living/L_occupant = occupant
	if(stasis_running())
		if(!IS_IN_STASIS(L_occupant))
			chill_out(L_occupant)
	else if(IS_IN_STASIS(L_occupant))
		thaw_them(L_occupant)

/obj/machinery/stasis/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	. |= default_deconstruction_screwdriver(user, "stasis_maintenance", "stasis", I)
	update_icon()

/obj/machinery/stasis/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	return default_deconstruction_crowbar(I) || .

/obj/machinery/stasis/nap_violation(mob/violator)
	unbuckle_mob(violator, TRUE)

#undef STASIS_TOGGLE_COOLDOWN

