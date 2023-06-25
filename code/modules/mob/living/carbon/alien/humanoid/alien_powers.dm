/*NOTES:
These are general powers. Specific powers are stored under the appropriate alien creature type.
*/

/*Alien spit now works like a taser shot. It won't home in on the target but will act the same once it does hit.
Doesn't work on other aliens/AI.*/


/datum/action/cooldown/alien
	name = "Способности Чужих"
	panel = "Alien"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	button_icon = 'icons/mob/actions/actions_xeno.dmi'
	button_icon_state = "spell_default"
	check_flags = AB_CHECK_CONSCIOUS
	/// How much plasma this action uses.
	var/plasma_cost = 0

/datum/action/cooldown/alien/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(!iscarbon(owner))
		return FALSE
	var/mob/living/carbon/carbon_owner = owner
	if(carbon_owner.getPlasma() < plasma_cost)
		return FALSE

	return TRUE

/datum/action/cooldown/alien/PreActivate(atom/target)
	// Parent calls Activate(), so if parent returns TRUE,
	// it means the activation happened successfuly by this point
	. = ..()
	if(!.)
		return FALSE
	// Xeno actions like "evolve" may result in our action (or our alien) being deleted
	// In that case, we can just exit now as a "success"
	if(QDELETED(src) || QDELETED(owner))
		return TRUE

	var/mob/living/carbon/carbon_owner = owner
	carbon_owner.adjustPlasma(-plasma_cost)
	// It'd be really annoying if click-to-fire actions stayed active,
	// even if our plasma amount went under the required amount.
	if(click_to_activate && carbon_owner.getPlasma() < plasma_cost)
		unset_click_ability(owner, refund_cooldown = FALSE)

	return TRUE

/datum/action/cooldown/alien/set_statpanel_format()
	. = ..()
	if(!islist(.))
		return

	.[PANEL_DISPLAY_STATUS] = "ПЛАЗМА - [plasma_cost]"

/datum/action/cooldown/alien/make_structure
	/// The type of structure the action makes on use
	var/obj/structure/made_structure_type

/datum/action/cooldown/alien/make_structure/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(!isturf(owner.loc) || isspaceturf(owner.loc))
		return FALSE

	return TRUE

/datum/action/cooldown/alien/make_structure/PreActivate(atom/target)
	if(!check_for_duplicate())
		return FALSE

	if(!check_for_vents())
		return FALSE

	return ..()

/datum/action/cooldown/alien/make_structure/Activate(atom/target)
	new made_structure_type(owner.loc)
	return TRUE

/// Checks if there's a duplicate structure in the owner's turf
/datum/action/cooldown/alien/make_structure/proc/check_for_duplicate()
	var/obj/structure/existing_thing = locate(made_structure_type) in owner.loc
	if(existing_thing)
		to_chat(owner, span_warning("Здесь уже есть [existing_thing]!"))
		return FALSE

	return TRUE

/// Checks if there's an atmos machine (vent) in the owner's turf
/datum/action/cooldown/alien/make_structure/proc/check_for_vents()
	var/obj/machinery/atmospherics/components/unary/atmos_thing = locate() in owner.loc
	if(atmos_thing)
		var/are_you_sure = tgui_alert(owner, "Расположенная здесь кладка яиц или смола заблокирует [atmos_thing]. Вы уверены что хотите продолжить?", "Заблокировать вентиляцию", list("Да", "Нет"))
		if(are_you_sure != "Да")
			return FALSE
		if(QDELETED(src) || QDELETED(owner) || !check_for_duplicate())
			return FALSE

	return TRUE

/datum/action/cooldown/alien/make_structure/plant_weeds
	name = "Разместить смоляную колонию"
	desc = "Откладывает небольшую колонию-опухоль населенную микроксеноорганизмами, терраформирующими окружающую территорию при помощи биполярной смолы."
	button_icon_state = "alien_plant"
	plasma_cost = 50
	made_structure_type = /obj/structure/alien/weeds/node

/datum/action/cooldown/alien/make_structure/plant_weeds/Activate(atom/target)
	owner.visible_message(span_alertalien("[owner] откладывает смоляную колонию!"))
	return ..()

/datum/action/cooldown/alien/whisper
	name = "Псионическая связь"
	desc = "Телепатическое общение."
	button_icon_state = "alien_whisper"
	plasma_cost = 10

/datum/action/cooldown/alien/whisper/Activate(atom/target)
	var/list/possible_recipients = list()
	for(var/mob/living/recipient in oview(owner))
		possible_recipients += recipient

	if(!length(possible_recipients))
		to_chat(owner, span_noticealien("Не с кем связываться."))
		return FALSE

	var/mob/living/chosen_recipient = tgui_input_list(owner, "ыберите цель для связи", "Псионическая связь", sort_names(possible_recipients))
	if(!chosen_recipient)
		return FALSE

	var/to_whisper = tgui_input_text(owner, title = "Псионическая связь")
	if(QDELETED(chosen_recipient) || QDELETED(src) || QDELETED(owner) || !IsAvailable() || !to_whisper)
		return FALSE
	if(chosen_recipient.can_block_magic(MAGIC_RESISTANCE_MIND, charge_cost = 0))
		to_chat(owner, span_warning("Пытаюсь настроиться на волну чужих мыслей, однако передо моим ментальным взором встает непреодолимая стена из фольги. Я не смогу ее преодолеть..."))
		return FALSE

	log_directed_talk(owner, chosen_recipient, to_whisper, LOG_SAY, tag = "alien whisper")
	to_chat(chosen_recipient, "[span_noticealien("Слышу странный, чужеродный голос в своей голове...")][to_whisper]")
	to_chat(owner, span_noticealien("Сообщаю: \"[to_whisper]\" -> [chosen_recipient]"))
	for(var/mob/dead_mob as anything in GLOB.dead_mob_list)
		if(!isobserver(dead_mob))
			continue
		var/follow_link_user = FOLLOW_LINK(dead_mob, owner)
		var/follow_link_whispee = FOLLOW_LINK(dead_mob, chosen_recipient)
		to_chat(dead_mob, "[follow_link_user] [span_name("[owner]")] [span_alertalien("Псионическая связь --> ")] [follow_link_whispee] [span_name("[chosen_recipient]")] [span_noticealien("[to_whisper]")]")

	return TRUE

/datum/action/cooldown/alien/transfer
	name = "Передача плазмы"
	desc = "Передает плазму другим чужим."
	plasma_cost = 0
	button_icon_state = "alien_transfer"

/datum/action/cooldown/alien/transfer/Activate(atom/target)
	var/mob/living/carbon/carbon_owner = owner
	var/list/mob/living/carbon/aliens_around = list()
	for(var/mob/living/carbon/alien in view(owner))
		if(alien.getPlasma() == -1 || alien == owner)
			continue
		aliens_around += alien

	if(!length(aliens_around))
		to_chat(owner, span_noticealien("Никого нет в округе."))
		return FALSE

	var/mob/living/carbon/donation_target = tgui_input_list(owner, "Выберите цель для передачи", "Передача плазмы", sort_names(aliens_around))
	if(!donation_target)
		return FALSE

	var/amount = tgui_input_number(owner, "Количество", "Передать плазму [donation_target]", max_value = carbon_owner.getPlasma())
	if(QDELETED(donation_target) || QDELETED(src) || QDELETED(owner) || !IsAvailable() || isnull(amount) || amount <= 0)
		return FALSE

	if(get_dist(owner, donation_target) > 1)
		to_chat(owner, span_noticealien("[donation_target] находится слишком далеко от меня!"))
		return FALSE

	donation_target.adjustPlasma(amount)
	carbon_owner.adjustPlasma(-amount)

	to_chat(donation_target, span_noticealien("[owner] передаёт [amount] единиц плазмы."))
	to_chat(owner, span_noticealien("Передаю [amount] единиц плазмы [donation_target]."))
	return TRUE

/datum/action/cooldown/alien/acid
	click_to_activate = TRUE
	unset_after_click = FALSE

/datum/action/cooldown/alien/acid/corrosion
	name = "Кислотная железа"
	desc = "Выплюнуть сгусток кислоты разъедающий предметы и стены."
	button_icon_state = "alien_acid"
	plasma_cost = 200

/datum/action/cooldown/alien/acid/corrosion/set_click_ability(mob/on_who)
	. = ..()
	if(!.)
		return

	to_chat(on_who, span_noticealien("Подготавливаю кислотную железу. <B>ЛКМ для стрельбы!</B>"))
	on_who.update_icons()

/datum/action/cooldown/alien/acid/corrosion/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(!.)
		return

	if(refund_cooldown)
		to_chat(on_who, span_noticealien("Железа опустошена."))
	on_who.update_icons()

/datum/action/cooldown/alien/acid/corrosion/PreActivate(atom/target)
	if(get_dist(owner, target) > 1)
		return FALSE
	if(ismob(target)) //If it could corrode mobs, it would one-shot them.
		owner.balloon_alert(owner, "не работает на существах!")
		return FALSE

	return ..()

/datum/action/cooldown/alien/acid/corrosion/Activate(atom/target)
	if(!target.acid_act(200, 1000))
		to_chat(owner, span_noticealien("Этот объект слишком стойкий."))
		return FALSE

	owner.visible_message(
		span_alertalien("[owner] изрыгает кислотную слизь на [target]. Материал начинает шипеть и плавиться, стекая вниз дымящимися струйками!"),
		span_noticealien("Изрыгаю кислотную слизь на [target]. Материал начинает шипеть и плавиться, стекая вниз дымящимися струйками!"),
	)
	return TRUE

/datum/action/cooldown/alien/acid/neurotoxin
	name = "Плевок нейротоксином"
	desc = "Выстреливает сгустком слизи, парализующим нервную систему жертвы на короткий промежуток времени."
	button_icon_state = "alien_neurotoxin_0"
	plasma_cost = 50

/datum/action/cooldown/alien/acid/neurotoxin/IsAvailable(feedback = FALSE)
	return ..() && isturf(owner.loc)

/datum/action/cooldown/alien/acid/neurotoxin/set_click_ability(mob/on_who)
	. = ..()
	if(!.)
		return

	to_chat(on_who, span_notice("Подготавливаю нейротоксичную железу. <B>ЛКМ для стрельбы!</B>"))

	button_icon_state = "alien_neurotoxin_1"
	build_all_button_icons()
	on_who.update_icons()

/datum/action/cooldown/alien/acid/neurotoxin/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(!.)
		return

	if(refund_cooldown)
		to_chat(on_who, span_notice("Скрываю нейротоксичную железу во рту."))

	button_icon_state = "alien_neurotoxin_0"
	build_all_button_icons()
	on_who.update_icons()

/datum/action/cooldown/alien/acid/neurotoxin/InterceptClickOn(mob/living/caller, params, atom/target)
	. = ..()
	if(!.)
		unset_click_ability(caller, refund_cooldown = FALSE)
		return FALSE

	// We do this in InterceptClickOn() instead of Activate()
	// because we use the click parameters for aiming the projectile
	// (or something like that)
	var/turf/user_turf = caller.loc
	var/turf/target_turf = get_step(caller, target.dir) // Get the tile infront of the move, based on their direction
	if(!isturf(target_turf))
		return FALSE

	var/modifiers = params2list(params)
	caller.visible_message(
		span_danger("[caller] плюется нейротоксином!"),
		span_alertalien("Плююсь нейротоксином."),
	)
	var/obj/projectile/neurotoxin/neurotoxin = new /obj/projectile/neurotoxin(caller.loc)
	neurotoxin.preparePixelProjectile(target, caller, modifiers)
	neurotoxin.firer = caller
	neurotoxin.fire()
	caller.newtonian_move(get_dir(target_turf, user_turf))
	return TRUE

// Has to return TRUE, otherwise is skipped.
/datum/action/cooldown/alien/acid/neurotoxin/Activate(atom/target)
	return TRUE

/datum/action/cooldown/alien/make_structure/resin
	name = "Смоляная железа"
	desc = "Выделяет специальную биополимерную смолу для строительства гнезда."
	button_icon_state = "alien_resin"
	plasma_cost = 55
	/// A list of all structures we can make.
	var/static/list/structures = list(
		"resin wall" = /obj/structure/alien/resin/wall,
		"resin membrane" = /obj/structure/alien/resin/membrane,
		"resin nest" = /obj/structure/bed/nest,
	)

// Snowflake to check for multiple types of alien resin structures
/datum/action/cooldown/alien/make_structure/resin/check_for_duplicate()
	for(var/blocker_name in structures)
		var/obj/structure/blocker_type = structures[blocker_name]
		if(locate(blocker_type) in owner.loc)
			to_chat(owner, span_warning("Это место уже занято!"))
			return FALSE

	return TRUE

/datum/action/cooldown/alien/make_structure/resin/Activate(atom/target)
	var/choice = tgui_input_list(owner, "Выберите что вы хотите создать", "Строительство гнезда", structures)
	if(isnull(choice) || QDELETED(src) || QDELETED(owner) || !check_for_duplicate() || !IsAvailable())
		return FALSE

	var/obj/structure/choice_path = structures[choice]
	if(!ispath(choice_path))
		return FALSE

	owner.visible_message(
		span_notice("[owner] выделяет густую фиолетовую субстанцию и начинает придавать ей форму."),
		span_notice("Начинаю формировать [choice]."),
	)

	new choice_path(owner.loc)
	return TRUE

/datum/action/cooldown/alien/sneak
	name = "Скрыться"
	desc = "Blend into the shadows to stalk your prey."
	button_icon_state = "alien_sneak"
	/// The alpha we go to when sneaking.
	var/sneak_alpha = 75

/datum/action/cooldown/alien/sneak/Remove(mob/living/remove_from)
	if(HAS_TRAIT(remove_from, TRAIT_ALIEN_SNEAK))
		remove_from.alpha = initial(remove_from.alpha)
		REMOVE_TRAIT(remove_from, TRAIT_ALIEN_SNEAK, name)

	return ..()

/datum/action/cooldown/alien/sneak/Activate(atom/target)
	if(HAS_TRAIT(owner, TRAIT_ALIEN_SNEAK))
		// It's safest to go to the initial alpha of the mob.
		// Otherwise we get permanent invisbility exploits.
		owner.alpha = initial(owner.alpha)
		to_chat(owner, span_noticealien("Выхожу из теней!"))
		REMOVE_TRAIT(owner, TRAIT_ALIEN_SNEAK, name)

	else
		owner.alpha = sneak_alpha
		to_chat(owner, span_noticealien("Сливаюсь с тенями..."))
		ADD_TRAIT(owner, TRAIT_ALIEN_SNEAK, name)

	return TRUE

/datum/action/cooldown/alien/regurgitate
	name = "Regurgitate"
	desc = "Empties the contents of your stomach."
	button_icon_state = "alien_barf"
	var/angle_delta = 45
	var/mob_speed = 1.5
	var/spit_speed = 1

/datum/action/cooldown/alien/regurgitate/Activate(atom/target)
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/alien/humanoid/alieninated_owner = owner
	var/obj/item/organ/stomach/alien/melting_pot = alieninated_owner.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(!melting_pot)
		owner.visible_message(span_clown("[src] gags, and spits up a bit of purple liquid. Ewwww."), \
			span_alien("You feel a pain in your... chest? There's nothing there there's nothing there no no n-"))
		return

	if(!length(melting_pot.stomach_contents))
		to_chat(owner, span_alien("There's nothing in your stomach, what exactly do you plan on spitting up?"))
		return
	owner.visible_message(span_danger("[owner] hurls out the contents of their stomach!"))
	var/dir_angle = dir2angle(owner.dir)

	playsound(owner, 'sound/creatures/alien_york.ogg', 100)
	melting_pot.eject_stomach(slice_off_turfs(owner, border_diamond_range_turfs(owner, 9), dir_angle - angle_delta, dir_angle + angle_delta), 4, mob_speed, spit_speed)

/// Gets the plasma level of this carbon's plasma vessel, or -1 if they don't have one
/mob/living/carbon/proc/getPlasma()
	var/obj/item/organ/alien/plasmavessel/vessel = getorgan(/obj/item/organ/alien/plasmavessel)
	if(!vessel)
		return -1
	return vessel.stored_plasma

/// Adjusts the plasma level of the carbon's plasma vessel if they have one
/mob/living/carbon/proc/adjustPlasma(amount)
	var/obj/item/organ/alien/plasmavessel/vessel = getorgan(/obj/item/organ/alien/plasmavessel)
	if(!vessel)
		return FALSE
	vessel.stored_plasma = max(vessel.stored_plasma + amount,0)
	vessel.stored_plasma = min(vessel.stored_plasma, vessel.max_plasma) //upper limit of max_plasma, lower limit of 0
	for(var/datum/action/cooldown/alien/ability in actions)
		ability.build_all_button_icons()
	return TRUE

/mob/living/carbon/alien/adjustPlasma(amount)
	. = ..()
	updatePlasmaDisplay()
