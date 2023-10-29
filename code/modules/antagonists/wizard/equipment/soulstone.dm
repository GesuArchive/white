/obj/item/soulstone
	name = "осколок камня душ"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	layer = HIGH_OBJ_LAYER
	desc = "Фрагмент легендарного сокровища, известного как 'Камень душ'. Осолок все ещё мерцает отблеском силы исконного артефакта."
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BELT
	/// if TRUE, we can only be used once.
	var/one_use = FALSE
	/// Only used if one_use is TRUE. Whether it's used.
	var/spent = FALSE
	/// if TRUE, our soulstone will work on mobs which are in crit. if FALSE, the mob must be dead.
	var/grab_sleeping = TRUE
	/// This controls the color of the soulstone as well as restrictions for who can use it.
	/// THEME_CULT is red and is the default of cultist
	/// THEME_WIZARD is purple and is the default of wizard
	/// THEME_HOLY is for purified soul stone
	var/theme = THEME_CULT
	/// Role check, if any needed
	var/required_role = /datum/antagonist/cult

/obj/item/soulstone/Initialize(mapload)
	. = ..()
	if(theme != THEME_HOLY)
		RegisterSignal(src, COMSIG_BIBLE_SMACKED, PROC_REF(on_bible_smacked))

/obj/item/soulstone/update_appearance(updates)
	. = ..()
	for(var/mob/living/simple_animal/shade/sharded_shade in src)
		switch(theme)
			if(THEME_HOLY)
				sharded_shade.name = "Очищенный [sharded_shade.real_name]"
				sharded_shade.icon_state = "shade_holy"
				sharded_shade.loot = list(/obj/item/ectoplasm/angelic)
			if(THEME_CULT)
				sharded_shade.name = sharded_shade.real_name
				sharded_shade.icon_state = "shade_cult"
				sharded_shade.loot = list(/obj/item/ectoplasm)
			if(THEME_WIZARD)
				sharded_shade.name = sharded_shade.real_name
				sharded_shade.icon_state = "shade_wizard"
				sharded_shade.loot = list(/obj/item/ectoplasm/mystic)

/obj/item/soulstone/update_icon_state()
	. = ..()
	switch(theme)
		if(THEME_HOLY)
			icon_state = "purified_soulstone"
		if(THEME_CULT)
			icon_state = "soulstone"
		if(THEME_WIZARD)
			icon_state = "mystic_soulstone"

	if(contents.len)
		icon_state = "[icon_state]2"

/obj/item/soulstone/update_name(updates)
	. = ..()
	if(spent)
		name = "тусклый [name]"
		return

	var/mob/living/simple_animal/shade/shade = locate() in src
	if(shade)
		name = "[name]: [shade.real_name]"
	else
		name = initial(name)

/obj/item/soulstone/update_desc(updates)
	. = ..()
	if(spent)
		desc = "Фрагмент легендарного сокровища, известного \
			как 'Камень душ'. Осколок лежит неподвижно, тусклый и безжизненный; \
			какая бы искра не вспыхнула в нём когда-то, она давно погасла."

///signal called whenever a soulstone is smacked by a bible
/obj/item/soulstone/proc/on_bible_smacked(datum/source, mob/living/user, direction)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(attempt_exorcism), user)

/**
 * attempt_exorcism: called from on_bible_smacked, takes time and if successful
 * resets the item to a pre-possessed state
 *
 * Arguments:
 * * exorcist: user who is attempting to remove the spirit
 */
/obj/item/soulstone/proc/attempt_exorcism(mob/exorcist)
	if(IS_CULTIST(exorcist) || theme == THEME_HOLY)
		return
	balloon_alert(exorcist, span_notice("Изгоняю нечистую силу из [src]..."))
	playsound(src, 'sound/hallucinations/veryfar_noise.ogg', 40, TRUE)
	if(!do_after(exorcist, 4 SECONDS, target = src))
		return
	playsound(src, 'sound/effects/pray_chaplain.ogg', 60, TRUE)
	required_role = null
	theme = THEME_HOLY

	update_appearance()
	for(var/mob/shade_to_deconvert in contents)
		shade_to_deconvert.mind?.remove_antag_datum(/datum/antagonist/cult)

	exorcist.visible_message(span_notice("[exorcist] очищает [src]!"))
	UnregisterSignal(src, COMSIG_BIBLE_SMACKED)

/**
 * corrupt: turns the soulstone into a cult one and turns the occupant shade, if any, into a cultist
 */
/obj/item/soulstone/proc/corrupt()
	if(theme == THEME_CULT)
		return FALSE

	required_role = /datum/antagonist/cult
	theme = THEME_CULT
	update_appearance()
	for(var/mob/shade_to_convert in contents)
		if(IS_CULTIST(shade_to_convert))
			continue
		shade_to_convert.mind?.add_antag_datum(/datum/antagonist/cult)

	RegisterSignal(src, COMSIG_BIBLE_SMACKED)
	return TRUE

/// Checks if the passed mob has the required antag datum set on the soulstone.
/obj/item/soulstone/proc/role_check(mob/who)
	return required_role ? (who.mind && who.mind.has_antag_datum(required_role, TRUE)) : TRUE

/// Called whenever the soulstone releases a shade from it.
/obj/item/soulstone/proc/on_release_spirits()
	if(!one_use)
		return

	spent = TRUE
	update_appearance()

/obj/item/soulstone/pickup(mob/living/user)
	..()
	if(!role_check(user))
		to_chat(user, span_danger("Непреодолимое чувство страха охватывает меня, когда я беру в руку [src]. Лучше бы это выкинуть и поскорее..."))

/obj/item/soulstone/examine(mob/user)
	. = ..()
	if(role_check(user) || isobserver(user))
		if(!grab_sleeping)
			. += span_cult("Камень души, используемый для захвата души, либо у мёртвых, бессознательных или спящих людей, либо у свободных теней.")
		else
			.  += span_cult("Камень душ, используемый для захвата души либо у бессознательного или спящего человека, либо у свободной тени.")
		.  += span_cult("Захваченная душа может быть помещена в оболочку конструкта для создания конструкта или выпущена из камня в виде тени.")
		if(spent)
			. += span_cult("Последний отблеск мистической силы покинул этот осколок - теперь это просто жуткий камень.")

/obj/item/soulstone/Destroy() //Stops the shade from being qdel'd immediately and their ghost being sent back to the arrival shuttle.
	for(var/mob/living/simple_animal/shade/shade in src)
		INVOKE_ASYNC(shade, /mob/living/proc/death)
	return ..()

/obj/item/soulstone/proc/hot_potato(mob/living/user)
	to_chat(user, span_userdanger("Святая магия, обитающая в [src], обжигает мою руку!"))
	var/obj/item/bodypart/affecting = user.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
	affecting.receive_damage( 0, 10 ) // 10 burn damage
	user.emote("scream")
	user.update_damage_overlays()
	user.dropItemToGround(src)

//////////////////////////////Capturing////////////////////////////////////////////////////////

/obj/item/soulstone/attack(mob/living/carbon/human/M, mob/living/user)
	if(!role_check(user))
		user.Unconscious(10 SECONDS)
		to_chat(user, span_userdanger("Моё тело сотрясается от изнуряющей боли!"))
		return
	if(spent)
		to_chat(user, span_warning("В [src] не осталось энергии."))
		return
	if(!ishuman(M))//If target is not a human.
		return ..()
	if(M == user)
		return
	if(IS_CULTIST(M) && IS_CULTIST(user))
		to_chat(user, span_cultlarge("\"Даже и не думай захватывать душу своего собрата.\""))
		return
	if(theme == THEME_HOLY && IS_CULTIST(user))
		hot_potato(user)
		return
	if(HAS_TRAIT(M, TRAIT_NO_SOUL))
		to_chat(user, span_warning("В этом теле нет души, которую можно было бы захватить."))
		return
	log_combat(user, M, "душа [M.name] захвачена в плен", src)
	capture_soul(M, user)

///////////////////Options for using captured souls///////////////////////////////////////

/obj/item/soulstone/attack_self(mob/living/user)
	if(!in_range(src, user))
		return
	if(!role_check(user))
		user.Unconscious(100)
		to_chat(user, span_userdanger("Моё тело пронзает изнуряющая боль!"))
		return
	if(theme == THEME_HOLY && IS_CULTIST(user))
		hot_potato(user)
		return
	release_shades(user)

/obj/item/soulstone/proc/release_shades(mob/user, silent = FALSE)
	for(var/mob/living/simple_animal/shade/captured_shade in src)
		captured_shade.forceMove(get_turf(user))
		captured_shade.cancel_camera()
		update_appearance()
		if(!silent)
			if(IS_CULTIST(user))
				to_chat(captured_shade, span_bold("Я был освобожден из своей тюрьмы, \
					однако я всё так же верен культу! Мы добьёмся успеха в достижении нашей Великой Цели любой ценой!"))

			else if(role_check(user))
				to_chat(captured_shade, span_bold("Я был освобожден из своей тюрьмы, \
					но я по-прежнему связан волей [user.real_name]. Обязан помочь [user.real_name] добиться успеха в его целях \
					любой ценой."))

		on_release_spirits()

/obj/item/soulstone/pre_attack(atom/A, mob/living/user, params)
	var/mob/living/simple_animal/shade/occupant = (locate() in src)
	var/obj/item/storage/toolbox/mechanical/target_toolbox = A
	if(!occupant || !istype(target_toolbox) || target_toolbox.has_soul)
		return ..()

	if(theme == THEME_HOLY && IS_CULTIST(user))
		hot_potato(user)
		return
	if(!role_check(user))
		user.Unconscious(10 SECONDS)
		to_chat(user, span_userdanger("Моё тело сотрясается от изнуряющей боли!"))
		return

	user.visible_message("<span class='notice'>[user] удерживает [src] над своей головой и помещает его в [target_toolbox] со вспышкой света!", \
		span_notice("Я ненадолго удерживаю [src] над головой, затем помещает его в [target_toolbox], перенося душу [occupant]!"), ignored_mobs = occupant)
	to_chat(occupant, span_userdanger("[user] ненадолго задерживает вас, а затем помещает в [target_toolbox]!"))
	to_chat(occupant, span_deadsay("<b>Ваша вечная душа была принесена в жертву, чтобы восстановить душу человека. Это конец!</b>"))

	occupant.client?.give_award(/datum/award/achievement/misc/toolbox_soul, occupant)
	occupant.death_message = "кричит от нечестивой боли, когда душа [occupant] поглощается [target_toolbox]!"
	release_shades(user, TRUE)
	occupant.death()

	target_toolbox.name = "чистилище душ"
	target_toolbox.icon = 'icons/obj/storage.dmi'
	target_toolbox.icon_state = "toolbox_blue_old"
	target_toolbox.has_soul = TRUE
	target_toolbox.has_latches = FALSE

///////////////////////////Transferring to constructs/////////////////////////////////////////////////////
/obj/structure/constructshell
	name = "пустая оболочка"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct_cult"
	desc = "Ужасающий конструкт, используемый теми, кто искусен в магических делах. В данный момент не активен."

/obj/structure/constructshell/examine(mob/user)
	. = ..()
	if(IS_CULTIST(user) || IS_WIZARD(user) || user.stat == DEAD)
		. += {"<span class='cult'>Оболочка конструкта, используемая для размещения пленённых душ из камня души.\n
		Помещение камня души с душой в эту оболочку позволяет вам производить следующее по вашему выбору:\n
		<b>Ремесленник</b>, производящий <b> новые оболочки конструктов и камни душ</b>, а также возводящий укрепления.\n
		<b>Призрак</b>, наносящий высокий урон и способный проходить сквозь стены, однако довольно хрупкий..\n
		<b>Джагернаут</b>, крайне живучий и способный создавать временные стены, однако весьма медлительный.</span>"}

/obj/structure/constructshell/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/soulstone))
		var/obj/item/soulstone/SS = O
		if(!IS_CULTIST(user) && !IS_WIZARD(user) && !SS.theme == THEME_HOLY)
			to_chat(user, span_danger("Ошеломляющее чувство ужаса охватывает меня, когда я пытаюсь поместить [SS] в оболочку. Лучше бы его выкинуть и поскорее."))
			if(isliving(user))
				var/mob/living/living_user = user
				living_user.dizziness = 60
			return
		if(SS.theme == THEME_HOLY && IS_CULTIST(user))
			SS.hot_potato(user)
			return
		SS.transfer_to_construct(src, user)
	else
		return ..()

/// Procs for moving soul in and out off stone

/// Transfer the mind of a carbon mob (which is then dusted) into a shade mob inside src.
/// If forced, sacrifical and stat checks are skipped.
/obj/item/soulstone/proc/capture_soul(mob/living/carbon/victim, mob/user, forced = FALSE)
	if(!iscarbon(victim)) //TODO: Add sacrifice stoning for non-organics, just because you have no body doesnt mean you dont have a soul
		return FALSE
	if(contents.len)
		return FALSE

	if(!forced)
		var/datum/antagonist/cult/cultist = IS_CULTIST(user)
		if(cultist)
			var/datum/team/cult/cult_team = cultist.get_team()
			if(victim.mind && cult_team.is_sacrifice_target(victim.mind))
				to_chat(user, span_cult("<b>\"Эта душа принадлежит мне.</b></span> <span class='cultlarge'>ЖЕРТВА!\""))
				return FALSE

		if(grab_sleeping ? victim.stat == CONSCIOUS : victim.stat != DEAD)
			to_chat(user, "[span_userdanger("Захват не удался!")]: Сначало надо убить или сильно покалечить жертву!")
			return FALSE

	victim.grab_ghost()
	if(victim.client)
		init_shade(victim, user)
		return TRUE

	to_chat(user, "[span_userdanger("Захват не удался!")]: Душа уже покинула своё смертное тело. Я пытаюсь вернуть её обратно...")
	INVOKE_ASYNC(src, PROC_REF(get_ghost_to_replace_shade), victim, user)
	return TRUE //it'll probably get someone ;)

///captures a shade that was previously released from a soulstone.
/obj/item/soulstone/proc/capture_shade(mob/living/simple_animal/shade/shade, mob/living/user)
	if(isliving(user) && !role_check(user))
		user.Unconscious(10 SECONDS)
		to_chat(user, span_userdanger("Моё тело пронзает изнуряющая боль!"))
		return
	if(contents.len)
		to_chat(user, "[span_userdanger("Захват не удался!")]: [src] необходимо высвободить заточенную там душу, чтобы освободить место!")
		return FALSE
	shade.AddComponent(/datum/component/soulstoned, src)
	update_appearance()
	if(theme == THEME_HOLY)
		for(var/mob/shade_to_deconvert in contents)
			shade_to_deconvert.mind?.remove_antag_datum(/datum/antagonist/cult)

	to_chat(shade, span_notice("Моя душа была захвачена в [src]. \
		Его тайная энергия вновь вяжет мою эфирную форму."))

	if(user != shade)
		to_chat(user, "[span_info("<b>Захват успешный!</b>:")] Душа [shade.real_name] \
			был захвачена и сохранена в [src].")

	return TRUE

///transfer the mind of the shade to a construct mob selected by the user, then deletes both the shade and src.
/obj/item/soulstone/proc/transfer_to_construct(obj/structure/constructshell/shell, mob/user)
	var/mob/living/simple_animal/shade/shade = locate() in src
	if(!shade)
		to_chat(user, "[span_userdanger("Создание не удалось!")]: [src] пуст! Надо бы найти кого-нибудь и убить...")
		return FALSE
	var/construct_class = show_radial_menu(user, src, GLOB.construct_radial_images, custom_check = CALLBACK(src, PROC_REF(check_menu), user, shell), require_near = TRUE, tooltips = TRUE)
	if(QDELETED(shell) || !construct_class)
		return FALSE
	make_new_construct_from_class(construct_class, theme, shade, user, FALSE, shell.loc)
	shade.mind?.remove_antag_datum(/datum/antagonist/cult)
	qdel(shell)
	qdel(src)
	return TRUE

/obj/item/soulstone/proc/check_menu(mob/user, obj/structure/constructshell/shell)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.is_holding(src) || !user.CanReach(shell, src))
		return FALSE
	return TRUE

/**
 * Creates a new shade mob to inhabit the stone.
 *
 * victim - the body that's being shaded
 * user - the person doing the shading. Optional.
 * message_user - if TRUE, we send the user (if present) a message that a shade has been created / captured.
 * shade_controller - the mob (usually, a ghost) that will take over control of the victim / new shade. Optional, if not passed the victim itself will take control.
 */
/obj/item/soulstone/proc/init_shade(mob/living/carbon/human/victim, mob/user, message_user = FALSE, mob/shade_controller)
	if(!shade_controller)
		shade_controller = victim
	victim.stop_sound_channel(CHANNEL_HEARTBEAT)
	var/mob/living/simple_animal/shade/soulstone_spirit = new /mob/living/simple_animal/shade(src)
	soulstone_spirit.AddComponent(/datum/component/soulstoned, src)
	soulstone_spirit.name = "Тень [victim.real_name]"
	soulstone_spirit.real_name = "Тень [victim.real_name]"
	soulstone_spirit.key = shade_controller.key
	soulstone_spirit.copy_languages(victim, LANGUAGE_MIND)//Copies the old mobs languages into the new mob holder.
	if(user)
		soulstone_spirit.copy_languages(user, LANGUAGE_MASTER)
	soulstone_spirit.update_atom_languages()
	soulstone_spirit.grant_all_languages(FALSE, FALSE, TRUE) //Grants omnitongue
	if(user)
		soulstone_spirit.faction |= "[REF(user)]" //Add the master as a faction, allowing inter-mob cooperation
		if(IS_CULTIST(user))
			soulstone_spirit.mind.add_antag_datum(/datum/antagonist/cult)

	soulstone_spirit.cancel_camera()
	update_appearance()
	if(user)
		if(IS_CULTIST(user))
			to_chat(soulstone_spirit, span_bold("Твоя душа была захвачена в плен! \
				Теперь вы связаны волей культа. Помогите им добиться успеха в достижении своих целей любой ценой."))
		else if(role_check(user))
			to_chat(soulstone_spirit, span_bold("Твоя душа была захвачена в плен! Вы привязаны к воле [user.real_name]. \
				Помогите [user.real_name] добится успеха в достижении его целей, любой ценой."))
		if(message_user)
			to_chat(user, "[span_info("<b>Захват успешен!</b>:")] Душа была вырвана \
из тела [victim.p_their()] и теперь хранится в [src].")

	victim.dust(drop_items = TRUE)

/**
 * Gets a ghost from dead chat to replace a missing player when a shade is created.
 *
 * Gets ran if a soulstone is used on a body that has no client to take over the shade.
 *
 * victim - the body that's being shaded
 * user - the mob shading the body
 *
 * Returns FALSE if no ghosts are available or the replacement fails.
 * Returns TRUE otherwise.
 */
/obj/item/soulstone/proc/get_ghost_to_replace_shade(mob/living/carbon/victim, mob/user)
	var/mob/dead/observer/chosen_ghost
	var/list/consenting_candidates = poll_ghost_candidates("Хотели бы вы сыграть в роли Тени?", "Культист", ROLE_CULTIST, 5 SECONDS, POLL_IGNORE_SHADE)
	if(length(consenting_candidates))
		chosen_ghost = pick(consenting_candidates)

	if(!victim || user.incapacitated() || !user.is_holding(src) || !user.CanReach(victim, src))
		return FALSE
	if(!chosen_ghost || !chosen_ghost.client)
		to_chat(user, span_danger("Нет духов, желающих стать тенью."))
		return FALSE
	if(contents.len) //If they used the soulstone on someone else in the meantime
		return FALSE
	to_chat(user, "[span_info("<b>Захват успешен!</b>:")] Дух вошел в [src], \
		принимая на себя личность [victim].")
	init_shade(victim, user, shade_controller = chosen_ghost)
	return TRUE

/proc/make_new_construct_from_class(construct_class, theme, mob/target, mob/creator, cultoverride, loc_override)
	switch(construct_class)
		if(CONSTRUCT_JUGGERNAUT)
			if(IS_CULTIST(creator))
				makeNewConstruct(/mob/living/simple_animal/hostile/construct/juggernaut, target, creator, cultoverride, loc_override) // ignore themes, the actual giving of cult info is in the makeNewConstruct proc
				return
			switch(theme)
				if(THEME_WIZARD)
					makeNewConstruct(/mob/living/simple_animal/hostile/construct/juggernaut/mystic, target, creator, cultoverride, loc_override)
				if(THEME_HOLY)
					makeNewConstruct(/mob/living/simple_animal/hostile/construct/juggernaut/angelic, target, creator, cultoverride, loc_override)
				if(THEME_CULT)
					makeNewConstruct(/mob/living/simple_animal/hostile/construct/juggernaut/noncult, target, creator, cultoverride, loc_override)
		if(CONSTRUCT_WRAITH)
			if(IS_CULTIST(creator))
				makeNewConstruct(/mob/living/simple_animal/hostile/construct/wraith, target, creator, cultoverride, loc_override) // ignore themes, the actual giving of cult info is in the makeNewConstruct proc
				return
			switch(theme)
				if(THEME_WIZARD)
					makeNewConstruct(/mob/living/simple_animal/hostile/construct/wraith/mystic, target, creator, cultoverride, loc_override)
				if(THEME_HOLY)
					makeNewConstruct(/mob/living/simple_animal/hostile/construct/wraith/angelic, target, creator, cultoverride, loc_override)
				if(THEME_CULT)
					makeNewConstruct(/mob/living/simple_animal/hostile/construct/wraith/noncult, target, creator, cultoverride, loc_override)
		if(CONSTRUCT_ARTIFICER)
			if(IS_CULTIST(creator))
				makeNewConstruct(/mob/living/simple_animal/hostile/construct/artificer, target, creator, cultoverride, loc_override) // ignore themes, the actual giving of cult info is in the makeNewConstruct proc
				return
			switch(theme)
				if(THEME_WIZARD)
					makeNewConstruct(/mob/living/simple_animal/hostile/construct/artificer/mystic, target, creator, cultoverride, loc_override)
				if(THEME_HOLY)
					makeNewConstruct(/mob/living/simple_animal/hostile/construct/artificer/angelic, target, creator, cultoverride, loc_override)
				if(THEME_CULT)
					makeNewConstruct(/mob/living/simple_animal/hostile/construct/artificer/noncult, target, creator, cultoverride, loc_override)

/proc/makeNewConstruct(mob/living/simple_animal/hostile/construct/ctype, mob/target, mob/stoner = null, cultoverride = FALSE, loc_override = null)
	if(QDELETED(target))
		return
	var/mob/living/simple_animal/hostile/construct/newstruct = new ctype((loc_override) ? (loc_override) : (get_turf(target)))
	var/makeicon = newstruct.icon_state
	var/theme = newstruct.theme
	flick("make_[makeicon][theme]", newstruct)
	playsound(newstruct, 'sound/effects/constructform.ogg', 50)
	if(stoner)
		newstruct.faction |= "[REF(stoner)]"
		newstruct.master = stoner
		var/datum/action/innate/seek_master/SM = new()
		SM.Grant(newstruct)
	newstruct.key = target.key
	var/atom/movable/screen/alert/bloodsense/BS
	if(newstruct.mind && ((stoner && IS_CULTIST(stoner)) || cultoverride) && SSticker?.mode)
		newstruct.mind.add_antag_datum(/datum/antagonist/cult)
	if(IS_CULTIST(stoner) || cultoverride)
		to_chat(newstruct, "<b>Вы все еще обязаны служить культу[stoner ? " и [stoner]":""] следовать [stoner ? stoner.p_their() : "их"] приказам и помогать [stoner ? stoner.p_them() : "им"] выполнить [stoner ? stoner.p_their() : "их"] цели любой ценой.</b>")
	else if(stoner)
		to_chat(newstruct, "<b>Вы все еще обязаны служить своему создателю, [stoner], следовать приказам [stoner.p_their()] и помогать [stoner.p_them()] выполнить [stoner.p_their()] цели любой ценой.</b>")
	newstruct.clear_alert("bloodsense")
	BS = newstruct.throw_alert("bloodsense", /atom/movable/screen/alert/bloodsense)
	if(BS)
		BS.Cviewer = newstruct
	newstruct.cancel_camera()

/obj/item/soulstone/anybody
	required_role = null

/obj/item/soulstone/mystic
	icon_state = "mystic_soulstone"
	theme = THEME_WIZARD
	required_role = /datum/antagonist/wizard

/obj/item/soulstone/anybody/revolver
	one_use = TRUE
	grab_sleeping = FALSE

/obj/item/soulstone/anybody/purified
	icon_state = "purified_soulstone"
	theme = THEME_HOLY

/obj/item/soulstone/anybody/chaplain
	name = "таинственный старый осколок"
	one_use = TRUE
	grab_sleeping = FALSE

/obj/item/soulstone/anybody/chaplain/sparring
	name = "божественное наказание"
	desc = "Тюрьма для тех, кто проиграл божественную игру."
	icon_state = "purified_soulstone"
	theme = THEME_HOLY

/obj/item/soulstone/anybody/chaplain/sparring/Initialize(mapload)
	. = ..()
	name = "Наказание [GLOB.deity]"
	desc = "Тюрьма для тех, кто проиграл игру [GLOB.deity]."

/obj/item/soulstone/anybody/mining
	grab_sleeping = FALSE
