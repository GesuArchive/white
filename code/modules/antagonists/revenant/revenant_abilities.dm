#define REVENANT_DEFILE_MIN_DAMAGE 30
#define REVENANT_DEFILE_MAX_DAMAGE 50


/mob/living/simple_animal/revenant/ClickOn(atom/A, params) //revenants can't interact with the world directly.
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		ShiftClickOn(A)
		return
	if(LAZYACCESS(modifiers, ALT_CLICK))
		AltClickNoInteract(src, A)
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		ranged_secondary_attack(A, modifiers)
		return

	if(ishuman(A))
		//Humans are tagged, so this is fine
		if(REF(A) in drained_mobs)
			to_chat(src, span_revenwarning("Душа [A] мертва и пуста.") )
		else if(in_range(src, A))
			Harvest(A)

/mob/living/simple_animal/revenant/ranged_secondary_attack(atom/target, modifiers)
	if(revealed || notransform || inhibited || !Adjacent(target) || !incorporeal_move_check(target))
		return
	var/icon/I = icon(target.icon,target.icon_state,target.dir)
	var/orbitsize = (I.Width()+I.Height())*0.5
	orbitsize -= (orbitsize/world.icon_size)*(world.icon_size*0.25)
	orbit(target, orbitsize)

//Harvest; activated by clicking the target, will try to drain their essence.
/mob/living/simple_animal/revenant/proc/Harvest(mob/living/carbon/human/target)
	if(!castcheck(0))
		return
	if(draining)
		to_chat(src, span_revenwarning("Уже поглощаю чью-то душу!"))
		return
	if(!target.stat)
		to_chat(src, span_revennotice("Душа [skloname(target.name, RODITELNI, target.gender)] слишком сильна."))
		if(prob(10))
			to_chat(target, span_revennotice("Чувствую, как будто за мной следят."))
		return
	log_combat(src, target, "started to harvest")
	face_atom(target)
	draining = TRUE
	essence_drained += rand(15, 20)
	to_chat(src, span_revennotice("Ищу душу [skloname(target.name, RODITELNI, target.gender)]."))
	if(do_after(src, rand(10, 20), target, timed_action_flags = IGNORE_HELD_ITEM)) //did they get deleted in that second?
		if(target.ckey)
			to_chat(src, span_revennotice("Душа [skloname(target.name, RODITELNI, target.gender)] пропитана разумом."))
			essence_drained += rand(20, 30)
		if(target.stat != DEAD && !HAS_TRAIT(target, TRAIT_WEAK_SOUL))
			to_chat(src, span_revennotice("Душа [skloname(target.name, RODITELNI, target.gender)] пылает жизнью!"))
			essence_drained += rand(40, 50)
		if(HAS_TRAIT(target, TRAIT_WEAK_SOUL) && !target.ckey)
			to_chat(src, span_revennotice("Душа [skloname(target.name, RODITELNI, target.gender)] слаба и недоразвита. Она будет не особо ценна."))
			essence_drained = 5
		else
			to_chat(src, span_revennotice("[target.p_their(TRUE)] душа слаба и неустойчива."))
		if(do_after(src, rand(15, 20), target, timed_action_flags = IGNORE_HELD_ITEM)) //did they get deleted NOW?
			switch(essence_drained)
				if(1 to 30)
					to_chat(src, span_revennotice("[target] даст не так много эссенции. Однако, каждая капля ценна."))
				if(30 to 70)
					to_chat(src, span_revennotice("[target] даст среднее количество эссенции."))
				if(70 to 90)
					to_chat(src, span_revenboldnotice("Какая сила! [target] даст много эссенции."))
				if(90 to INFINITY)
					to_chat(src, span_revenbignotice("Ах, идеальная душа. [target] даст большое количество эссенции."))
			if(do_after(src, rand(15, 25), target, timed_action_flags = IGNORE_HELD_ITEM)) //how about now
				if(!target.stat)
					to_chat(src, span_revenwarning("[target] стал достаточно силен, чтобы противостоять поглощению."))
					to_chat(target, span_boldannounce("Чувствую как странные путы отпускают меня."))
					draining = 0
					essence_drained = 0
					return //hey, wait a minute...
				to_chat(src, span_revenminor("Начинаю поглощать душу [skloname(target.name, RODITELNI, target.gender)]."))
				if(target.stat != DEAD)
					to_chat(target, span_warning("Ощущаю ужасно неприятное чувство истощения, когда моя власть над жизнью ослабевает..."))
				if(target.stat == SOFT_CRIT)
					target.Stun(46)
				reveal(46)
				stun(46)
				target.visible_message(span_warning("[target] внезапно слегка поднимается в воздух, кожа [skloname(target.name, RODITELNI, target.gender)] меняется до пепельно серого."))
				if(target.can_block_magic(MAGIC_RESISTANCE_HOLY))
					to_chat(src, span_revenminor("Что-то пошло не так! Видимо [target] сопротивляется поглощению, оставив меня уязвимым!"))
					target.visible_message(span_warning("[target] падает на землю."), \
					span_revenwarning("Фиолетовые огни, танцующие в моих глазах, отступают--"))
					draining = FALSE
					return
				var/datum/beam/B = Beam(target,icon_state="drain_life")
				if(do_after(src, 46, target, timed_action_flags = IGNORE_HELD_ITEM)) //As one cannot prove the existance of ghosts, ghosts cannot prove the existance of the target they were draining.
					change_essence_amount(essence_drained, FALSE, target)
					if(essence_drained <= 90 && target.stat != DEAD && !HAS_TRAIT(target, TRAIT_WEAK_SOUL))
						essence_regen_cap += 5
						to_chat(src, span_revenboldnotice("Поглощение живой души [skloname(target.name, RODITELNI, target.gender)] увеличило мой максимальный объем эссенции. Мой новый предел [essence_regen_cap]."))
					if(essence_drained > 90)
						essence_regen_cap += 15
						perfectsouls++
						to_chat(src, span_revenboldnotice("Поглощение идеальной души [skloname(target.name, RODITELNI, target.gender)] увеличило мой максимальный объем эссенции. Мой новый предел [essence_regen_cap]."))
					to_chat(src, span_revennotice("Душа [skloname(target.name, RODITELNI, target.gender)] была значительно ослаблена и не будет давать эссенцию ещё какое-то время."))
					target.visible_message(span_warning("[target] падает на землю."), \
										   span_revenwarning("Фиолетовые огни, танцующие в моих глазах, приближа--"))
					drained_mobs += REF(target)
					target.death(0)
				else
					to_chat(src, span_revenwarning("[target ? "[target] был":"[skloname(target.name, RODITELNI, target.gender)]"] вырван из моих рук. Связь была нарушена.")) //незабыть проверить КАК оно работает и выглядит
					if(target) //Wait, target is WHERE NOW?
						target.visible_message(span_warning("[target] падает на землю."), \
											   span_revenwarning("Фиолетовые огни, танцующие в моих глазах, отступают--"))
				qdel(B)
			else
				to_chat(src, span_revenwarning("Я недостаточно близко для поглощения души [skloname(target.name, RODITELNI, target.gender)]. Связь была нарушена.")) //да как это говнище работает
	draining = FALSE
	essence_drained = 0

//Toggle night vision: lets the revenant toggle its night vision
/datum/action/cooldown/spell/night_vision/revenant
	name = "Переключить ночное зрение"
	panel = "Revenant Abilities"
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"
	button_icon = 'icons/mob/actions/actions_revenant.dmi'
	button_icon_state = "r_nightvision"
	toggle_span = "revennotice"

//Transmit: the revemant's only direct way to communicate. Sends a single message silently to a single mob
/datum/action/cooldown/spell/list_target/telepathy/revenant
	name = "Послание Восставшего"
	panel = "Revenant Abilities"
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"

	telepathy_span = "revennotice"
	bold_telepathy_span = "revenboldnotice"

	antimagic_flags = MAGIC_RESISTANCE_HOLY|MAGIC_RESISTANCE_MIND

/datum/action/cooldown/spell/aoe/revenant
	panel = "Способности Восставшего (Заблокировано)"
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"
	button_icon = 'icons/mob/actions/actions_revenant.dmi'

	antimagic_flags = MAGIC_RESISTANCE_HOLY
	spell_requirements = NONE

	/// If it's locked, and needs to be unlocked before use
	var/locked = TRUE
	/// How much essence it costs to unlock
	var/unlock_amount = 100
	/// How much essence it costs to use
	var/cast_amount = 50

	/// How long it reveals the revenant
	var/reveal_duration = 8 SECONDS
	// How long it stuns the revenant
	var/stun_duration = 2 SECONDS

/datum/action/cooldown/spell/aoe/revenant/New(Target)
	. = ..()
	if(!istype(target, /mob/living/simple_animal/revenant))
		stack_trace("[type] was given to a non-revenant mob, please don't.")
		qdel(src)
		return

	if(locked)
		name = "[initial(name)] ([unlock_amount]SE)"
	else
		name = "[initial(name)] ([cast_amount]E)"

/datum/action/cooldown/spell/aoe/revenant/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/revenant))
		stack_trace("[type] was owned by a non-revenant mob, please don't.")
		return FALSE

	var/mob/living/simple_animal/revenant/ghost = owner
	if(ghost.inhibited)
		return FALSE
	if(locked && ghost.essence_excess <= unlock_amount)
		return FALSE
	if(ghost.essence <= cast_amount)
		return FALSE

	return TRUE

/datum/action/cooldown/spell/aoe/revenant/get_things_to_cast_on(atom/center)
	var/list/things = list()
	for(var/turf/nearby_turf in range(aoe_radius, center))
		things += nearby_turf

	return things

/datum/action/cooldown/spell/aoe/revenant/before_cast(mob/living/simple_animal/revenant/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return FALSE

	if(locked)
		if(!cast_on.unlock(unlock_amount))
			to_chat(cast_on, span_revenwarning("Недостаточно эссенции для разблокировки [initial(name)]!"))
			reset_spell_cooldown()
			return . | SPELL_CANCEL_CAST

		name = "[initial(name)] ([cast_amount]E)"
		to_chat(cast_on, span_revennotice("Разблокирую [initial(name)]!"))
		panel = "Revenant Abilities"
		locked = FALSE
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	if(!cast_on.castcheck(-cast_amount))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/aoe/revenant/after_cast(mob/living/simple_animal/revenant/cast_on)
	. = ..()
	if(reveal_duration > 0 SECONDS)
		cast_on.reveal(reveal_duration)
	if(stun_duration > 0 SECONDS)
		cast_on.stun(stun_duration)

//Overload Light: Breaks a light that's online and sends out lightning bolts to all nearby people.
/datum/action/cooldown/spell/aoe/revenant/overload
	name = "Перегрузка освещение"
	desc = "Направь большое количество эссенции в близлежащие электрические лампы, заставляя их ударить электрической дугой тех, кто рядом."
	button_icon_state = "overload_lights"
	cooldown_time = 20 SECONDS

	aoe_radius = 5
	unlock_amount = 25
	cast_amount = 40
	stun_duration = 3 SECONDS

	/// The range the shocks from the lights go
	var/shock_range = 2
	/// The damage the shcoskf rom the lgihts do
	var/shock_damage = 15

/datum/action/cooldown/spell/aoe/revenant/overload/cast_on_thing_in_aoe(turf/victim, mob/living/simple_animal/revenant/caster)
	for(var/obj/machinery/light/light in victim)
		if(!light.on)
			continue

		light.visible_message(span_boldwarning("[light] внезапно вспыхивает ярко и начинает искриться!"))
		var/datum/effect_system/spark_spread/light_sparks = new /datum/effect_system/spark_spread()
		light_sparks.set_up(4, 0, light)
		light_sparks.start()
		new /obj/effect/temp_visual/revenant(get_turf(light))
		addtimer(CALLBACK(src, PROC_REF(overload_shock), light, caster), 20)

/datum/action/cooldown/spell/aoe/revenant/overload/proc/overload_shock(obj/machinery/light/to_shock, mob/living/simple_animal/revenant/caster)
	flick("[to_shock.base_state]2", to_shock)
	for(var/mob/living/carbon/human/human_mob in view(shock_range, to_shock))
		if(human_mob == caster)
			continue
		to_shock.Beam(human_mob, icon_state = "purple_lightning", time = 0.5 SECONDS)
		if(!human_mob.can_block_magic(antimagic_flags))
			human_mob.electrocute_act(shock_damage, to_shock, flags = SHOCK_NOGLOVES)

		do_sparks(4, FALSE, human_mob)
		playsound(human_mob, 'sound/machines/defib_zap.ogg', 50, TRUE, -1)

//Defile: Corrupts nearby stuff, unblesses floor tiles.
/datum/action/cooldown/spell/aoe/revenant/defile
	name = "Осквернение"
	desc = "Разрушает и искажает ближайшую область, а также рассеивает святую ауру на поверхностях."
	button_icon_state = "defile"
	cooldown_time = 15 SECONDS

	aoe_radius = 4
	unlock_amount = 10
	cast_amount = 30
	reveal_duration = 4 SECONDS
	stun_duration = 2 SECONDS

/datum/action/cooldown/spell/aoe/revenant/defile/cast_on_thing_in_aoe(turf/victim, mob/living/simple_animal/revenant/caster)
	for(var/obj/effect/blessing/blessing in victim)
		qdel(blessing)
		new /obj/effect/temp_visual/revenant(victim)

	if(!isplatingturf(victim) && !istype(victim, /turf/open/floor/engine/cult) && isfloorturf(victim) && prob(15))
		var/turf/open/floor/floor = victim
		if(floor.intact && floor.floor_tile)
			new floor.floor_tile(floor)
		floor.broken = 0
		floor.burnt = 0
		floor.make_plating(TRUE)

	if(victim.type == /turf/closed/wall && prob(15) && !HAS_TRAIT(victim, TRAIT_RUSTY))
		new /obj/effect/temp_visual/revenant(victim)
		victim.AddElement(/datum/element/rust)
	if(victim.type == /turf/closed/wall/r_wall && prob(10) && !HAS_TRAIT(victim, TRAIT_RUSTY))
		new /obj/effect/temp_visual/revenant(victim)
		victim.AddElement(/datum/element/rust)
	for(var/obj/effect/decal/cleanable/food/salt/salt in victim)
		new /obj/effect/temp_visual/revenant(victim)
		qdel(salt)
	for(var/obj/structure/closet/closet in victim.contents)
		closet.open()
	for(var/obj/structure/bodycontainer/corpseholder in victim)
		if(corpseholder.connected.loc == corpseholder)
			corpseholder.open()
	for(var/obj/machinery/dna_scannernew/dna in victim)
		dna.open_machine()
	for(var/obj/structure/window/window in victim)
		if(window.get_integrity() > REVENANT_DEFILE_MAX_DAMAGE)
			window.take_damage(rand(REVENANT_DEFILE_MIN_DAMAGE, REVENANT_DEFILE_MAX_DAMAGE))
		if(window.fulltile)
			new /obj/effect/temp_visual/revenant/cracks(window.loc)
	for(var/obj/machinery/light/light in victim)
		light.flicker(20) //spooky

//Malfunction: Makes bad stuff happen to robots and machines.
/datum/action/cooldown/spell/aoe/revenant/malfunction
	name = "Сбой техники"
	desc = "Повреждает и искажает работу близлежащих машин и механических объектов."
	button_icon_state = "malfunction"
	cooldown_time = 20 SECONDS

	aoe_radius = 4
	cast_amount = 60
	unlock_amount = 125

// A note to future coders: do not replace this with an EMP because it will wreck malf AIs and everyone will hate you.
/datum/action/cooldown/spell/aoe/revenant/malfunction/cast_on_thing_in_aoe(turf/victim, mob/living/simple_animal/revenant/caster)
	for(var/mob/living/simple_animal/bot/bot in victim)
		if(!bot.emagged)
			new /obj/effect/temp_visual/revenant(bot.loc)
			bot.locked = FALSE
			bot.open = TRUE
			bot.emag_act()
	for(var/mob/living/carbon/human/human in victim)
		if(human == caster)
			continue
		if(human.can_block_magic(antimagic_flags))
			continue
		to_chat(human, span_revenwarning("[pick("Ощущаю как будто разряд тока проходит через мозг", "Ощущаю потерю ориентации", "Мои волосы наполнились статическим разрядом")]."))
		new /obj/effect/temp_visual/revenant(human.loc)
		human.emp_act(EMP_HEAVY)
	for(var/obj/thing in victim)
		//Doesn't work on SMES and APCs, to prevent kekkery.
		if(istype(thing, /obj/machinery/power/apc) || istype(thing, /obj/machinery/power/smes))
			continue
		if(prob(20))
			if(prob(50))
				new /obj/effect/temp_visual/revenant(thing.loc)
			thing.emag_act(caster)
	// Only works on cyborgs, not AI!
	for(var/mob/living/silicon/robot/cyborg in victim)
		playsound(cyborg, 'sound/machines/warning-buzzer.ogg', 50, TRUE)
		new /obj/effect/temp_visual/revenant(cyborg.loc)
		cyborg.spark_system.start()
		cyborg.emp_act(EMP_HEAVY)

//Blight: Infects nearby humans and in general messes living stuff up.
/datum/action/cooldown/spell/aoe/revenant/blight
	name = "Упадок жизни"
	desc = "Пробуждает упадок жизненных сил в живых существах."
	button_icon_state = "blight"
	cooldown_time = 20 SECONDS

	aoe_radius = 3
	cast_amount = 50
	unlock_amount = 75

/datum/action/cooldown/spell/aoe/revenant/blight/cast_on_thing_in_aoe(turf/victim, mob/living/simple_animal/revenant/caster)
	for(var/mob/living/mob in victim)
		if(mob == caster)
			continue
		if(mob.can_block_magic(antimagic_flags))
			to_chat(caster, span_warning("Моя способность не повлияла на [skloname(mob.name, RODITELNI, mob.gender)]!"))
			continue
		new /obj/effect/temp_visual/revenant(mob.loc)
		if(iscarbon(mob))
			if(ishuman(mob))
				var/mob/living/carbon/human/H = mob
				if(H.dna && H.dna.species)
					H.dna.species.handle_hair(H,"#1d2953") //will be reset when blight is cured
				var/blightfound = FALSE
				for(var/datum/disease/revblight/blight in H.diseases)
					blightfound = TRUE
					if(blight.stage < 5)
						blight.stage++
				if(!blightfound)
					H.ForceContractDisease(new /datum/disease/revblight(), FALSE, TRUE)
					to_chat(H, span_revenminor("Чувствую [pick("неожиданное недомогание", "прилив тошноты", "как моя кожа стала <i>неправильной</i>")]."))
			else
				if(mob.reagents)
					mob.reagents.add_reagent(/datum/reagent/toxin/plasma, 5)
		else
			mob.adjustToxLoss(5)
	for(var/obj/structure/spacevine/vine in victim) //Fucking with botanists, the ability.
		vine.add_atom_colour("#823abb", TEMPORARY_COLOUR_PRIORITY)
		new /obj/effect/temp_visual/revenant(vine.loc)
		QDEL_IN(vine, 10)
	for(var/obj/structure/glowshroom/shroom in victim)
		shroom.add_atom_colour("#823abb", TEMPORARY_COLOUR_PRIORITY)
		new /obj/effect/temp_visual/revenant(shroom.loc)
		QDEL_IN(shroom, 10)
	for(var/obj/machinery/hydroponics/tray in victim)
		new /obj/effect/temp_visual/revenant(tray.loc)
		tray.pestlevel = rand(8, 10)
		tray.weedlevel = rand(8, 10)
		tray.toxic = rand(45, 55)

#undef REVENANT_DEFILE_MIN_DAMAGE
#undef REVENANT_DEFILE_MAX_DAMAGE
