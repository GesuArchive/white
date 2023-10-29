#define BLOB_REROLL_RADIUS 60

/mob/camera/blob/proc/can_buy(cost = 15)
	if(blob_points < cost)
		to_chat(src, span_warning("Не хватает ресурсов, требуется [cost]!"))
		return FALSE
	add_points(-cost)
	return TRUE

/mob/camera/blob/proc/place_blob_core(placement_override, pop_override = FALSE)
	if(placed && placement_override != -1)
		return TRUE
	if(!placement_override)
		if(!pop_override)
			for(var/mob/living/M in range(7, src))
				if(ROLE_BLOB in M.faction)
					continue
				if(M.client)
					to_chat(src, span_warning("Кто-то рядом с моим ядром!"))
					return FALSE
			for(var/mob/living/M in view(13, src))
				if(ROLE_BLOB in M.faction)
					continue
				if(M.client)
					to_chat(src, span_warning("Кто-то сможет увидеть ядро здесь!"))
					return FALSE
		var/turf/T = get_turf(src)
		if(T.density)
			to_chat(src, span_warning("Слишком плотное место для установки!"))
			return FALSE
		var/area/A = get_area(T)
		if(isspaceturf(T) || A && !(A.area_flags & BLOBS_ALLOWED))
			to_chat(src, span_warning("Не выходит установить ядро здесь!"))
			return FALSE
		for(var/obj/O in T)
			if(istype(O, /obj/structure/blob))
				if(istype(O, /obj/structure/blob/normal))
					qdel(O)
				else
					to_chat(src, span_warning("Здесь уже есть масса!"))
					return FALSE
			else if(O.density)
				to_chat(src, span_warning("Слишком плотное место для установки!"))
				return FALSE
		if(!pop_override && world.time <= manualplace_min_time && world.time <= autoplace_max_time)
			to_chat(src, span_warning("Слишком рано для установки ядра!"))
			return FALSE
	else if(placement_override == 1)
		var/turf/T = pick(GLOB.blobstart)
		forceMove(T) //got overrided? you're somewhere random, motherfucker
	if(placed && blob_core)
		blob_core.forceMove(loc)
	else
		var/obj/structure/blob/special/core/core = new(get_turf(src), src, 1)
		core.overmind = src
		blobs_legit += src
		blob_core = core
		core.update_icon()
	update_health_hud()
	placed = TRUE
	announcement_time = world.time + OVERMIND_ANNOUNCEMENT_MAX_TIME
	return TRUE

/mob/camera/blob/proc/transport_core()
	if(blob_core)
		forceMove(blob_core.drop_location())

/mob/camera/blob/proc/jump_to_node()
	if(GLOB.blob_nodes.len)
		var/list/nodes = list()
		for(var/i in 1 to GLOB.blob_nodes.len)
			var/obj/structure/blob/special/node/B = GLOB.blob_nodes[i]
			nodes["Родительская Масса #[i] ([get_area_name(B)])"] = B
		var/node_name = tgui_input_list(src, "Куда прыгнем?", "Прыг-прыг", nodes)
		var/obj/structure/blob/special/node/chosen_node = nodes[node_name]
		if(chosen_node)
			forceMove(chosen_node.loc)

/mob/camera/blob/proc/createSpecial(price, blobstrain, minSeparation, needsNode, turf/T)
	if(!T)
		T = get_turf(src)
	var/obj/structure/blob/B = (locate(/obj/structure/blob) in T)
	if(!B)
		to_chat(src, span_warning("Здесь нет массы!"))
		return
	if(!istype(B, /obj/structure/blob/normal))
		to_chat(src, span_warning("Невозможно установить здесь. Нужна обычная масса."))
		return
	if(needsNode)
		var/area/A = get_area(src)
		if(!(A.area_flags & BLOBS_ALLOWED)) //factory and resource blobs must be legit
			to_chat(src, span_warning("Этот тип массы может быть установлен только на станции!"))
			return
		if(nodes_required && !(locate(/obj/structure/blob/special/node) in orange(BLOB_NODE_PULSE_RANGE, T)) && !(locate(/obj/structure/blob/special/core) in orange(BLOB_CORE_PULSE_RANGE, T)))
			to_chat(src, span_warning("Эту массу необходимо установить рядом с ядром или родительской массой!"))
			return //handholdotron 2000
	if(minSeparation)
		for(var/obj/structure/blob/L in orange(minSeparation, T))
			if(L.type == blobstrain)
				to_chat(src, span_warning("Похожая структура рядом, необходимо установить её на расстоянии [minSeparation] клеток от похожей!"))
				return
	if(!can_buy(price))
		return
	var/obj/structure/blob/N = B.change_to(blobstrain, src)
	return N

/mob/camera/blob/proc/toggle_node_req()
	nodes_required = !nodes_required
	if(nodes_required)
		to_chat(src, span_warning("Теперь родительская масса и ядро будут устанавливать прозводящие и ресурсные структуры."))
	else
		to_chat(src, span_warning("Теперь родительская масса и ядро не будут устанавливать прозводящие и ресурсные структуры."))

/mob/camera/blob/proc/create_shield(turf/T)
	var/obj/structure/blob/shield/S = locate(/obj/structure/blob/shield) in T
	if(S)
		if(!can_buy(BLOB_UPGRADE_REFLECTOR_COST))
			return
		if(S.obj_integrity < S.max_integrity * 0.5)
			add_points(BLOB_UPGRADE_REFLECTOR_COST)
			to_chat(src, span_warning("Крепкая масса слишком повреждена для модификации!"))
			return
		to_chat(src, span_warning("Добавляю возможность отражать снаряды, однако структура немного ослаблена."))
		S.change_to(/obj/structure/blob/shield/reflective, src)
	else
		createSpecial(BLOB_UPGRADE_STRONG_COST, /obj/structure/blob/shield, 0, FALSE, T)

/mob/camera/blob/proc/create_blobbernaut()
	var/turf/T = get_turf(src)
	var/obj/structure/blob/special/factory/B = locate(/obj/structure/blob/special/factory) in T
	if(!B)
		to_chat(src, span_warning("Нужно находиться прямо на производящей структуре!"))
		return
	if(B.naut) //if it already made a blobbernaut, it can't do it again
		to_chat(src, span_warning("Эта производящая структура уже поддерживает массанаута."))
		return
	if(B.obj_integrity < B.max_integrity * 0.5)
		to_chat(src, span_warning("Эта производящая структура слишком повреждена для массанаута."))
		return
	if(!can_buy(BLOBMOB_BLOBBERNAUT_RESOURCE_COST))
		return

	B.naut = TRUE //temporary placeholder to prevent creation of more than one per factory.
	to_chat(src, span_notice("Пытаюсь произвести массанаута."))
	var/list/mob/dead/observer/candidates = poll_ghost_candidates("Хочешь быть массанаутом [blobstrain.name]?", ROLE_BLOB, null, 50) //players must answer rapidly
	if(LAZYLEN(candidates)) //if we got at least one candidate, they're a blobbernaut now.
		B.max_integrity = initial(B.max_integrity) * 0.25 //factories that produced a blobbernaut have much lower health
		B.obj_integrity = min(B.obj_integrity, B.max_integrity)
		B.update_icon()
		B.visible_message(span_warning("<b>Массанаут [pick("вырывает", "прорезает", "разрубает")] себе путь из производящей массы!</b>"))
		playsound(B.loc, 'sound/effects/splat.ogg', 50, TRUE)
		var/mob/living/simple_animal/hostile/blob/blobbernaut/blobber = new /mob/living/simple_animal/hostile/blob/blobbernaut(get_turf(B))
		flick("blobbernaut_produce", blobber)
		B.naut = blobber
		blobber.factory = B
		blobber.overmind = src
		blobber.update_icons()
		blobber.adjustHealth(blobber.maxHealth * 0.5)
		blob_mobs += blobber
		var/mob/dead/observer/C = pick(candidates)
		blobber.key = C.key
		SEND_SOUND(blobber, sound('sound/effects/blobattack.ogg'))
		SEND_SOUND(blobber, sound('sound/effects/attackblob.ogg'))
		to_chat(blobber, "<b>Да я же массанаут!</b>")
		to_chat(blobber, "Я силён, меня трудно убить и я медленно восстанавливаюсь рядом с узлами и ядрами, <span class='cultlarge'>но медленно умираю, если рядом нет массы</span> или мой завод уничтожен.")
		to_chat(blobber, "Можно общаться с другими массанаутами и надмозгом через <b>:b</b>")
		to_chat(blobber, "Структура моего надмозга: <b><font color=\"[blobstrain.color]\">[blobstrain.name]</b></font>!")
		to_chat(blobber, "<b><font color=\"[blobstrain.color]\">[blobstrain.name]</b></font> [blobstrain.shortdesc ? "[blobstrain.shortdesc]" : "[blobstrain.description]"]")
	else
		to_chat(src, span_warning("Не вышло создать разум для массанаута. Энергия была возвращена. Попробуем позже."))
		add_points(BLOBMOB_BLOBBERNAUT_RESOURCE_COST)
		B.naut = null

/mob/camera/blob/proc/relocate_core()
	var/turf/T = get_turf(src)
	var/obj/structure/blob/special/node/B = locate(/obj/structure/blob/special/node) in T
	if(!B)
		to_chat(src, span_warning("Надо быть на массе!"))
		return
	if(!blob_core)
		to_chat(src, span_userdanger("У меня нет ядра и я скоро умру! Пиздец."))
		return
	var/area/A = get_area(T)
	if(isspaceturf(T) || A && !(A.area_flags & BLOBS_ALLOWED))
		to_chat(src, span_warning("Не могу переместить сюда свое ядро!"))
		return
	if(!can_buy(BLOB_POWER_RELOCATE_COST))
		return
	var/turf/old_turf = get_turf(blob_core)
	var/olddir = blob_core.dir
	blob_core.forceMove(T)
	blob_core.setDir(B.dir)
	B.forceMove(old_turf)
	B.setDir(olddir)

/mob/camera/blob/proc/remove_blob(turf/T)
	var/obj/structure/blob/B = locate() in T
	if(!B)
		to_chat(src, span_warning("Здесь нет массы!"))
		return
	if(B.point_return < 0)
		to_chat(src, span_warning("Невозможно удалить эту массу."))
		return
	if(max_blob_points < B.point_return + blob_points)
		to_chat(src, span_warning("Ресурсов слишком много!"))
		return
	if(B.point_return)
		add_points(B.point_return)
		to_chat(src, span_notice("Получили [B.point_return] ресурсов благодаря удалению [B]."))
	qdel(B)

/mob/camera/blob/proc/expand_blob(turf/T)
	if(world.time < last_attack)
		return
	var/list/possibleblobs = list()
	for(var/obj/structure/blob/AB in range(T, 1))
		possibleblobs += AB
	if(!possibleblobs.len)
		to_chat(src, span_warning("Здесь нет массы рядом!"))
		return
	if(can_buy(BLOB_EXPAND_COST))
		var/attacksuccess = FALSE
		for(var/mob/living/L in T)
			if(ROLE_BLOB in L.faction) //no friendly/dead fire
				continue
			if(L.stat != DEAD)
				attacksuccess = TRUE
			blobstrain.attack_living(L, possibleblobs)
		var/obj/structure/blob/B = locate() in T
		if(B)
			if(attacksuccess) //if we successfully attacked a turf with a blob on it, only give an attack refund
				B.blob_attack_animation(T, src)
				add_points(BLOB_ATTACK_REFUND)
			else
				to_chat(src, span_warning("Здесь уже есть масса!"))
				add_points(BLOB_EXPAND_COST) //otherwise, refund all of the cost
		else
			var/list/cardinalblobs = list()
			var/list/diagonalblobs = list()
			for(var/I in possibleblobs)
				var/obj/structure/blob/IB = I
				if(get_dir(IB, T) in GLOB.cardinals)
					cardinalblobs += IB
				else
					diagonalblobs += IB
			var/obj/structure/blob/OB
			if(cardinalblobs.len)
				OB = pick(cardinalblobs)
				if(!OB.expand(T, src))
					add_points(BLOB_ATTACK_REFUND) //assume it's attacked SOMETHING, possibly a structure
			else
				OB = pick(diagonalblobs)
				if(attacksuccess)
					OB.blob_attack_animation(T, src)
					playsound(OB, 'sound/effects/splat.ogg', 50, TRUE)
					add_points(BLOB_ATTACK_REFUND)
				else
					add_points(BLOB_EXPAND_COST) //if we're attacking diagonally and didn't hit anything, refund
		if(attacksuccess)
			last_attack = world.time + CLICK_CD_MELEE
		else
			last_attack = world.time + CLICK_CD_RAPID

/mob/camera/blob/proc/rally_spores(turf/T)
	to_chat(src, "Направляю споры.")
	var/list/surrounding_turfs = block(locate(T.x - 1, T.y - 1, T.z), locate(T.x + 1, T.y + 1, T.z))
	if(!surrounding_turfs.len)
		return
	for(var/mob/living/simple_animal/hostile/blob/blobspore/BS in blob_mobs)
		if(isturf(BS.loc) && get_dist(BS, T) <= 35 && !BS.key)
			BS.LoseTarget()
			BS.Goto(pick(surrounding_turfs), BS.move_to_delay)

/mob/camera/blob/proc/strain_reroll()
	if (!free_strain_rerolls && blob_points < BLOB_POWER_REROLL_COST)
		to_chat(src, span_warning("Требуется [BLOB_POWER_REROLL_COST] ресурсов для перестроения структуры!"))
		return

	open_reroll_menu()

/// Open the menu to reroll strains
/mob/camera/blob/proc/open_reroll_menu()
	if (!strain_choices)
		strain_choices = list()

		var/list/new_strains = GLOB.valid_blobstrains.Copy() - blobstrain.type
		for (var/_ in 1 to BLOB_POWER_REROLL_CHOICES)
			var/datum/blobstrain/strain = pick_n_take(new_strains)

			var/image/strain_icon = image('icons/mob/blob.dmi', "blob_core")
			strain_icon.color = initial(strain.color)

			var/info_text = span_boldnotice("[initial(strain.name)]")
			info_text += "<br><span class='notice'>[initial(strain.analyzerdescdamage)]</span>"
			if (!isnull(initial(strain.analyzerdesceffect)))
				info_text += "<br><span class='notice'>[initial(strain.analyzerdesceffect)]</span>"

			var/datum/radial_menu_choice/choice = new
			choice.image = strain_icon
			choice.info = info_text

			strain_choices[initial(strain.name)] = choice

	var/strain_result = show_radial_menu(src, src, strain_choices, radius = BLOB_REROLL_RADIUS, tooltips = TRUE)
	if (isnull(strain_result))
		return

	if (!free_strain_rerolls && !can_buy(BLOB_POWER_REROLL_COST))
		return

	for (var/_other_strain in GLOB.valid_blobstrains)
		var/datum/blobstrain/other_strain = _other_strain
		if (initial(other_strain.name) == strain_result)
			set_strain(other_strain)

			if (free_strain_rerolls)
				free_strain_rerolls -= 1

			last_reroll_time = world.time
			strain_choices = null

			return

/mob/camera/blob/proc/blob_help()
	to_chat(src, "<b>Высший разум, который управляет массой!</b>")
	to_chat(src, "Структура: <b><font color=\"[blobstrain.color]\">[blobstrain.name]</b></font>!")
	to_chat(src, "<b><font color=\"[blobstrain.color]\">[blobstrain.name]</b></font> [blobstrain.description]")
	if(blobstrain.effectdesc)
		to_chat(src, "<b><font color=\"[blobstrain.color]\">[blobstrain.name]</b></font> [blobstrain.effectdesc]")
	to_chat(src, "<b>Можно расширяться, что будет атаковать людей, повреждать объекты или размещать обычную массу, если клетка пуста.</b>")
	to_chat(src, "<b>Обычная масса</b> расширит мой охват и может быть преобразована в специальные структуры, которые выполняют определенные функции.")
	to_chat(src, "<b>Можно улучшить обычную массу до следующих типов структур:</b>")
	to_chat(src, "<b>Крепкая масса</b> сильная и дорогая, которая поглощает больше урона. Кроме того, она пожаробезопасна и может блокировать воздух. Стоит использовать её, чтобы защитить себя от пожаров на станции. Её повторное улучшение приведет к появлению отражающей массы, способной отражать большинство снарядов за счет дополнительного здоровья сильной массы.")
	to_chat(src, "<b>Ресурсная масса</b>, которая производит для меня больше ресурсов, нужно построить её как можно больше, чтобы поглотить станцию. Этот тип массы должен быть размещен рядом с родительской массой или рядом с ядром для работы.")
	to_chat(src, "<b>Производящая масса</b>, которая порождает споры, которые атакуют ближайших врагов. Этот тип массы должен быть размещен рядом с родительской массой или рядом с ядром для работы.")
	to_chat(src, "<b>Массанауты</b> могут быть произведены на производящей массе за определенную плату, их трудно убить, они мощные и умеренно умные. Производящая масса, использованная для ее создания, станет хрупкой и не сможет производить споры.")
	to_chat(src, "<b>Родительская масса</b>, которая растёт, как ядро. Как и ядро, он может активировать ресурсы и прозводящую массу.")
	to_chat(src, "<b>В дополнение к кнопкам на HUD есть несколько ярлыков для ускорения расширения и защиты.</b>")
	to_chat(src, "<b>Хоткеи:</b> Клик = Расширение <b>|</b> СКМ = Направить споры <b>|</b> CTRL+Клик = Создать крепкую массу <b>|</b> ALT+Клик = Удалить массу")
	to_chat(src, "Попытка заговорить отправит сообщение всем остальным высшим разумам, позволяя координировать свои действия с ними.")
	if(!placed && autoplace_max_time <= world.time)
		to_chat(src, span_big("<font color=\"#EE4000\">Ядро будет размещено автоматически через [DisplayTimeText(autoplace_max_time - world.time)].</font>"))
		to_chat(src, span_big("<font color=\"#EE4000\">[manualplace_min_time ? "Я скоро смогу":"Можно"] установить ядро нажатием кнопки Установить Ядро.</font>"))

#undef BLOB_REROLL_RADIUS
