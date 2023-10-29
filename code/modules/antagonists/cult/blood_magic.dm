/datum/action/innate/cult/blood_magic //Blood magic handles the creation of blood spells (formerly talismans)
	name = "Подготовка Магии Крови"
	button_icon_state = "carve"
	desc = "Подготовьте Магию Крови, вырезав руну у себя на плоти. Осуществить это будет проще возле <b>усиливающей руны</b>."
	default_button_position = DEFAULT_BLOODSPELLS
	var/list/spells = list()
	var/channeling = FALSE

/datum/action/innate/cult/blood_magic/Remove()
	for(var/X in spells)
		qdel(X)
	..()

/datum/action/innate/cult/blood_magic/IsAvailable(feedback = FALSE)
	if(!IS_CULTIST(owner))
		return FALSE
	return ..()

/datum/action/innate/cult/blood_magic/proc/Positioning()
	for(var/datum/hud/hud as anything in viewers)
		var/our_view = hud.mymob?.client?.view || "15x15"
		var/atom/movable/screen/movable/action_button/button = viewers[hud]
		var/position = screen_loc_to_offset(button.screen_loc)
		var/spells_iterated = 0
		for(var/datum/action/innate/cult/blood_spell/blood_spell in spells)
			spells_iterated += 1
			if(blood_spell.positioned)
				continue
			var/atom/movable/screen/movable/action_button/moving_button = blood_spell.viewers[hud]
			if(!moving_button)
				continue
			var/our_x = position[1] + spells_iterated * world.icon_size // Offset any new buttons into our list
			hud.position_action(moving_button, offset_to_screen_loc(our_x, position[2], our_view))
			blood_spell.positioned = TRUE

/datum/action/innate/cult/blood_magic/Activate()
	var/rune = FALSE
	var/limit = RUNELESS_MAX_BLOODCHARGE
	for(var/obj/effect/rune/empower/R in range(1, owner))
		rune = TRUE
		break
	if(rune)
		limit = MAX_BLOODCHARGE
	if(length(spells) >= limit)
		if(rune)
			to_chat(owner, span_cultitalic("У меня не может быть больше [MAX_BLOODCHARGE] заклинаний. <b>Надо выбрать заклинание для замены.</b>"))
		else
			to_chat(owner, span_cultitalic("<b><u>У меня не может быть больше [RUNELESS_MAX_BLOODCHARGE] заклинаний без усиливающей руны! Надо выбрать заклинание для замены.</b></u>"))
		var/nullify_spell = tgui_input_list(owner, "Выберете заклинание для замены.", "Доступные заклинания", spells)
		if(isnull(nullify_spell))
			return
		qdel(nullify_spell)
	var/entered_spell_name
	var/datum/action/innate/cult/blood_spell/BS
	var/list/possible_spells = list()
	for(var/I in subtypesof(/datum/action/innate/cult/blood_spell))
		var/datum/action/innate/cult/blood_spell/J = I
		var/cult_name = initial(J.name)
		possible_spells[cult_name] = J
	possible_spells += "(REMOVE SPELL)"
	entered_spell_name = tgui_input_list(owner, "Подготовка магии крови...", "Список заклинаний", possible_spells)
	if(isnull(entered_spell_name))
		return
	if(entered_spell_name == "(REMOVE SPELL)")
		var/nullify_spell = tgui_input_list(owner, "Выберете заклинание для замены.", "Доступные заклинания", spells)
		if(isnull(nullify_spell))
			return
		qdel(nullify_spell)
	BS = possible_spells[entered_spell_name]
	if(QDELETED(src) || owner.incapacitated() || !BS || (rune && !(locate(/obj/effect/rune/empower) in range(1, owner))) || (length(spells) >= limit))
		return
	to_chat(owner,span_warning("Начинаю вырезать древние символы на своей плоти!"))
	SEND_SOUND(owner, sound('sound/weapons/slice.ogg',0,1,10))
	if(!channeling)
		channeling = TRUE
	else
		to_chat(owner, span_cultitalic("Прямо сейчас я уже вырезаю кровавый узор! Нельзя спешить..."))
		return
	if(do_after(owner, 100 - rune*60, target = owner))
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			H.bleed(40 - rune*32)
		var/datum/action/innate/cult/blood_spell/new_spell = new BS(owner)
		new_spell.Grant(owner, src)
		spells += new_spell
		Positioning()
		to_chat(owner, span_warning("Горячая кровь омывает мои раны, напитывая [new_spell.name] силой!"))
	channeling = FALSE

/datum/action/innate/cult/blood_spell //The next generation of talismans, handles storage/creation of blood magic
	name = "Узор Крови"
	button_icon_state = "telerune"
	desc = "Бойтесь Древней Крови."
	var/charges = 1
	var/magic_path = null
	var/obj/item/melee/blood_magic/hand_magic
	var/datum/action/innate/cult/blood_magic/all_magic
	var/base_desc //To allow for updating tooltips
	var/invocation
	var/health_cost = 0
	/// Have we already been positioned into our starting location?
	var/positioned = FALSE

/datum/action/innate/cult/blood_spell/Grant(mob/living/owner, datum/action/innate/cult/blood_magic/BM)
	if(health_cost)
		desc += "<br>Наносит <u>[health_cost] урона</u> вашей руке за использование."
	base_desc = desc
	desc += "<br><b><u>Осталось [charges] [charges > 1 ? "использования" : "использование"]</u></b>."
	all_magic = BM
	return ..()

/datum/action/innate/cult/blood_spell/Remove()
	if(all_magic)
		all_magic.spells -= src
	if(hand_magic)
		qdel(hand_magic)
		hand_magic = null
	..()

/datum/action/innate/cult/blood_spell/IsAvailable(feedback = FALSE)
	if(!IS_CULTIST(owner) || owner.incapacitated() || !charges)
		return FALSE
	return ..()

/datum/action/innate/cult/blood_spell/Activate()
	if(magic_path) //If this spell flows from the hand
		if(!hand_magic)
			hand_magic = new magic_path(owner, src)
			if(!owner.put_in_hands(hand_magic))
				qdel(hand_magic)
				hand_magic = null
				to_chat(owner, span_warning("Невозможно напитать кровавый узор силой, когда мои руки заняты!"))
				return
			to_chat(owner, span_notice("Кровавый [name] на моем теле пульсирует алым цветом!"))
			return
		if(hand_magic)
			qdel(hand_magic)
			hand_magic = null
			to_chat(owner, span_warning("Прерываю поток силы, древние символы неохотно отступают и гаснут, на время..."))


//Cult Blood Spells
/datum/action/innate/cult/blood_spell/stun
	name = "Узор оглушения"
	desc = "Оглушает и накладывает немоту на жертву при прикосновении."
	button_icon_state = "hand"
	magic_path = "/obj/item/melee/blood_magic/stun"
	health_cost = 10

/datum/action/innate/cult/blood_spell/teleport
	name = "Узор телепорта"
	desc = "Телепортирует вас или другого культиста к выбранной руне."
	button_icon_state = "tele"
	magic_path = "/obj/item/melee/blood_magic/teleport"
	health_cost = 7

/datum/action/innate/cult/blood_spell/emp
	name = "Узор электромагнитного импульса"
	desc = "Выпускакт большой электромагнитный импульс."
	button_icon_state = "emp"
	health_cost = 10
	invocation = "Ta'gh fara'qha fel d'amar det!"

/datum/action/innate/cult/blood_spell/emp/Activate()
	owner.whisper(invocation, language = /datum/language/common)
	owner.visible_message(span_warning("Рука [owner] пульсирует синим цветом!"), \
		span_cultitalic("Я произношу проклятые слова, выпуская ЭМИ импульс из своей руки."))
	empulse(owner, 2, 5)
	charges--
	if(charges<=0)
		qdel(src)

/datum/action/innate/cult/blood_spell/shackles
	name = "Узор теневых оков"
	desc = "Сковывает и накладывает на жертву немоту, в случае успеха."
	button_icon_state = "cuff"
	charges = 4
	magic_path = "/obj/item/melee/blood_magic/shackles"

/datum/action/innate/cult/blood_spell/construction
	name = "Узор трансмутации"
	desc = "Ваша рука получает возможность трансмутировать металлические предметы.<br><u>Преобразует:</u><br>Пласталь в рунический металл<br>50 листов железа в оболочку конструкта<br>Живых киборгов в конструктов, с небольшой задержкой<br>Оболочку киборга в оболочку конструкта<br>Шлюз в хрупкий рунический шлюз (намерение навредить)"
	button_icon_state = "transmute"
	magic_path = "/obj/item/melee/blood_magic/construction"
	health_cost = 12

/datum/action/innate/cult/blood_spell/equipment
	name = "Узор битвы"
	desc = "Позволяет призвать амуницию культиста при прикосновении. Включает в себя броню, болу и меч. Не рекомендует использовать до раскрытия существования культа на станции."
	button_icon_state = "equip"
	magic_path = "/obj/item/melee/blood_magic/armor"

/datum/action/innate/cult/blood_spell/dagger
	name = "Узор ритуалиста"
	desc = "Позволяет призвать ритуальный кинжал, если вы утратили полученный ранее."
	invocation = "Wur d'dai leev'mai k'sagan!" //where did I leave my keys, again?
	button_icon_state = "equip" //this is the same icon that summon equipment uses, but eh, I'm not a spriter
	/// The item given to the cultist when the spell is invoked. Typepath.
	var/obj/item/summoned_type = /obj/item/melee/cultblade/dagger

/datum/action/innate/cult/blood_spell/dagger/Activate()
	var/turf/owner_turf = get_turf(owner)
	owner.whisper(invocation, language = /datum/language/common)
	owner.visible_message(span_warning("Рука [owner] наполнилась красным светом на мгновение."), \
		span_cultitalic("Мои мольбы были услышаны, кровь в моей руке начинает преобретать форму!"))
	var/obj/item/summoned_blade = new summoned_type(owner_turf)
	if(owner.put_in_hands(summoned_blade))
		to_chat(owner, span_warning("В моей руке появился ритуальный кинжал!"))
	else
		owner.visible_message(span_warning("Тени клубятся пред ногами [owner], оставляя после себя Ритуальный кинжал!"), \
			span_cultitalic("Ритуальный кинжал появляется у моих ног."))
	SEND_SOUND(owner, sound('sound/effects/magic.ogg', FALSE, 0, 25))
	charges--
	if(charges <= 0)
		qdel(src)

/datum/action/innate/cult/blood_spell/horror
	name = "Узор галлюцинаций"
	desc = "Позволяет удаленно наложить галлюцинации на цель. Использование бесшумно и незаметно."
	button_icon_state = "horror"
	charges = 4
	click_action = TRUE
	enable_text = span_cult("Они познают ужас...")
	disable_text = span_cult("Рассеиваю заклинание...")

/datum/action/innate/cult/blood_spell/horror/InterceptClickOn(mob/living/caller, params, atom/clicked_on)
	var/turf/caller_turf = get_turf(caller)
	if(!isturf(caller_turf))
		return FALSE

	if(!ishuman(clicked_on) || get_dist(caller, clicked_on) > 7)
		return FALSE

	var/mob/living/carbon/human/human_clicked = clicked_on
	if(IS_CULTIST(human_clicked))
		return FALSE

	return ..()

/datum/action/innate/cult/blood_spell/horror/do_ability(mob/living/caller, params, mob/living/carbon/human/clicked_on)

	clicked_on.hallucination = max(clicked_on.hallucination, 120)
	SEND_SOUND(caller, sound('sound/effects/ghost.ogg', FALSE, TRUE, 50))

	var/image/sparkle_image = image('icons/effects/cult/effects.dmi', clicked_on, "bloodsparkles", ABOVE_MOB_LAYER)
	clicked_on.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/cult, "cult_apoc", sparkle_image, NONE)

	addtimer(CALLBACK(clicked_on, TYPE_PROC_REF(/atom, remove_alt_appearance), "cult_apoc", TRUE), 4 MINUTES, TIMER_OVERRIDE|TIMER_UNIQUE)
	to_chat(caller, span_cultbold("[clicked_on] <b>был проклят видениями кошмаров!</b>"))

	charges--
	desc = base_desc
	desc += "<br><b><u>Осталось [charges] [charges > 1 ? "использования" : "использование"]</u></b>."
	build_all_button_icons()
	if(charges <= 0)
		to_chat(caller, span_cult("Узор истощен!"))
		qdel(src)

	return TRUE

/datum/action/innate/cult/blood_spell/veiling
	name = "Узор сокрытия"
	desc = "Позволяет скрывать или раскрывать сооружения и руны культа."
	invocation = "Kla'atu barada nikt'o!"
	button_icon_state = "gone"
	charges = 10
	var/revealing = FALSE //if it reveals or not

/datum/action/innate/cult/blood_spell/veiling/Activate()
	if(!revealing)
		owner.visible_message(span_warning("С рук [owner] сыпется пепел..."), \
			span_cultitalic("Напитываю узор сокрытия силой, закрыв вуалью близлежащие руны."))
		charges--
		SEND_SOUND(owner, sound('sound/magic/smoke.ogg',0,1,25))
		owner.whisper(invocation, language = /datum/language/common)
		for(var/obj/effect/rune/R in range(5,owner))
			R.conceal()
		for(var/obj/structure/destructible/cult/S in range(5,owner))
			S.conceal()
		for(var/turf/open/floor/engine/cult/T  in range(5,owner))
			if(!T.realappearance)
				continue
			T.realappearance.alpha = 0
		for(var/obj/machinery/door/airlock/cult/AL in range(5, owner))
			AL.conceal()
		revealing = TRUE
		name = "Снять вуаль сокрытия"
		button_icon_state = "back"
	else
		owner.visible_message(span_warning("Из рук [owner] вырвалась яркая вспышка!"), \
			span_cultitalic("Развеиваю вуаль сокрытия, открывая взору руны."))
		charges--
		owner.whisper(invocation, language = /datum/language/common)
		SEND_SOUND(owner, sound('sound/magic/enter_blood.ogg',0,1,25))
		for(var/obj/effect/rune/R in range(7,owner)) //More range in case you weren't standing in exactly the same spot
			R.reveal()
		for(var/obj/structure/destructible/cult/S in range(6,owner))
			S.reveal()
		for(var/turf/open/floor/engine/cult/T  in range(6,owner))
			if(!T.realappearance)
				continue
			T.realappearance.alpha = initial(T.realappearance.alpha)
		for(var/obj/machinery/door/airlock/cult/AL in range(6, owner))
			AL.reveal()
		revealing = FALSE
		name = "Наложить вуаль сокрытия"
		button_icon_state = "gone"
	if(charges<= 0)
		qdel(src)
	desc = base_desc
	desc += "<br><b><u>Осталось [charges] [charges > 1 ? "использования" : "использование"]</u></b>."
	build_all_button_icons()

/datum/action/innate/cult/blood_spell/manipulation
	name = "Узор сердца крови"
	desc = "Позволяет при прикосновении исцелять культистов или поглощать кровь у непосвященных. При использовании в руке позволяет вам произвести великий ритуал крови. При исцелении самого себя эффект заметно снижен."
	invocation = "Fel'th Dol Ab'orod!"
	button_icon_state = "manip"
	charges = 5
	magic_path = "/obj/item/melee/blood_magic/manipulator"


// The "magic hand" items
/obj/item/melee/blood_magic
	name = "Магическая аура"
	desc = "Зловещая аура, искажающая реальность вокруг себя."
	icon = 'icons/obj/items_and_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/misc/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/touchspell_righthand.dmi'
	icon_state = "disintegrate"
	inhand_icon_state = "disintegrate"
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL

	w_class = WEIGHT_CLASS_HUGE
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	var/invocation
	var/uses = 1
	var/health_cost = 0 //The amount of health taken from the user when invoking the spell
	var/datum/action/innate/cult/blood_spell/source

/obj/item/melee/blood_magic/Initialize(mapload, spell)
	. = ..()
	if(spell)
		source = spell
		uses = source.charges
		health_cost = source.health_cost

/obj/item/melee/blood_magic/Destroy()
	if(!QDELETED(source))
		if(uses <= 0)
			source.hand_magic = null
			qdel(source)
			source = null
		else
			source.hand_magic = null
			source.charges = uses
			source.desc = source.base_desc
			source.desc += "<br><b><u>Осталось [uses] [uses > 1 ? "использования" : "использование"]</u></b>."
			source.build_all_button_icons()
	return ..()

/obj/item/melee/blood_magic/attack_self(mob/living/user)
	afterattack(user, user, TRUE)

/obj/item/melee/blood_magic/attack(mob/living/M, mob/living/carbon/user)
	if(!iscarbon(user) || !IS_CULTIST(user))
		uses = 0
		qdel(src)
		return
	log_combat(user, M, "used a cult spell on", source.name, "")

/obj/item/melee/blood_magic/afterattack(atom/target, mob/living/carbon/user, proximity)
	. = ..()
	if(invocation)
		user.whisper(invocation, language = /datum/language/common)
	if(health_cost)
		if(user.active_hand_index == 1)
			user.apply_damage(health_cost, BRUTE, BODY_ZONE_L_ARM)
		else
			user.apply_damage(health_cost, BRUTE, BODY_ZONE_R_ARM)
	if(uses <= 0)
		qdel(src)
	else if(source)
		source.desc = source.base_desc
		source.desc += "<br><b><u>Осталось [uses] [uses > 1 ? "использования" : "использование"]</u></b>."
		source.build_all_button_icons()

//Stun
/obj/item/melee/blood_magic/stun
	name = "Узор оглушения"
	desc = "Оглушает и накладывает немоту на жертву при прикосновении."
	color = RUNE_COLOR_RED
	invocation = "Fuu ma'jin!"

/obj/item/melee/blood_magic/stun/afterattack(mob/living/target, mob/living/carbon/user, proximity)
	if(!isliving(target) || !proximity)
		return
	if(IS_CULTIST(target))
		return
	if(IS_CULTIST(user))
		user.visible_message(span_warning("Из руки [user] вырываются вспышки кроваво-красного цвета!"), \
							span_cultitalic("Я оглушил цель своим заклинанием!"))

		user.mob_light(_range = 3, _color = LIGHT_COLOR_BLOOD_MAGIC, _duration = 0.2 SECONDS)

		if(target.can_block_magic())
			to_chat(user, span_warning("Узор не подействовал!"))
		else
			to_chat(user, span_cultitalic("После ослепительной вспышки моя цель падает на землю!"))
			target.Paralyze(16 SECONDS)
			target.flash_act(1, TRUE)
			if(issilicon(target))
				var/mob/living/silicon/silicon_target = target
				silicon_target.emp_act(EMP_HEAVY)
			else if(iscarbon(target))
				var/mob/living/carbon/carbon_target = target
				carbon_target.silent += 6
				carbon_target.stuttering += 30
				carbon_target.cultslurring += 30
				carbon_target.jitteriness = 30
		uses--
	..()

//Teleportation
/obj/item/melee/blood_magic/teleport
	name = "Узор телепорта"
	color = RUNE_COLOR_TELEPORT
	desc = "Телепортирует вас или другого культиста к выбранной руне."
	invocation = "Sas'so c'arta forbici!"

/obj/item/melee/blood_magic/teleport/afterattack(atom/target, mob/living/carbon/user, proximity)
	var/mob/mob_target = target
	if(istype(mob_target) && !IS_CULTIST(mob_target) || !proximity)
		to_chat(user, span_warning("С помощью этого заклинания можно телепортировать лишь находящихся рядом культистов!"))
		return
	if(IS_CULTIST(user))
		var/list/potential_runes = list()
		var/list/teleportnames = list()
		for(var/obj/effect/rune/teleport/teleport_rune as anything in GLOB.teleport_runes)
			potential_runes[avoid_assoc_duplicate_keys(teleport_rune.listkey, teleportnames)] = teleport_rune

		if(!length(potential_runes))
			to_chat(user, span_warning("Нет подходящей руны для телепортации!"))
			return

		var/turf/T = get_turf(src)
		if(is_away_level(T.z))
			to_chat(user, span_cultitalic("Я не могу телепортироваться, находясь в данном измерении!"))
			return

		var/input_rune_key = tgui_input_list(user, "Выберете руну для телепорта.", "Телепортация к", potential_runes) //we know what key they picked
		if(isnull(input_rune_key))
			return
		if(isnull(potential_runes[input_rune_key]))
			to_chat(user, span_warning("Вам нужно выбрать доступную руну!"))
			return
		var/obj/effect/rune/teleport/actual_selected_rune = potential_runes[input_rune_key] //what rune does that key correspond to?
		if(QDELETED(src) || !user || !user.is_holding(src) || user.incapacitated() || !actual_selected_rune || !proximity)
			return
		var/turf/dest = get_turf(actual_selected_rune)
		if(dest.is_blocked_turf(TRUE))
			to_chat(user, span_warning("Выбранная руна заблокирована. Я не смогу телепортироваться туда."))
			return
		uses--
		var/turf/origin = get_turf(user)
		var/mob/living/L = target
		if(do_teleport(L, dest, channel = TELEPORT_CHANNEL_CULT))
			origin.visible_message(span_warning("С рук [user] осыпается пепел, после чего [user.ru_who()] исчезает с громким треском!"), \
				span_cultitalic("Наполняю силой узор телепортации... реальность размывается...") , "<i>Где-то рядом раздался громкий треск.</i>")
			dest.visible_message(span_warning("Воздух над руной сгустился и схлопнулся с резким звуком, в облаке пепла проступают очертания загадочной фигуры...") , null, "<i>Где-то рядом послышался воздушный хлопок.</i>")
		..()

//Shackles
/obj/item/melee/blood_magic/shackles
	name = "Узор цепей"
	desc = "Сковывает и накладывает на жертву немоту, в случае успеха."
	invocation = "In'totum Lig'abis!"
	color = "#000000" // black

/obj/item/melee/blood_magic/shackles/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(IS_CULTIST(user) && iscarbon(target) && proximity)
		var/mob/living/carbon/C = target
		if(C.canBeHandcuffed())
			CuffAttack(C, user)
		else
			user.visible_message(span_cultitalic("Невозможно связать жертву у которой всего лишь одна рука!"))
			return
		..()

/obj/item/melee/blood_magic/shackles/proc/CuffAttack(mob/living/carbon/C, mob/living/user)
	if(!C.handcuffed)
		playsound(loc, 'sound/weapons/cablecuff.ogg', 30, TRUE, -2)
		C.visible_message(span_danger("[user] сковывает [C] при помощи темной магии!"), \
								span_userdanger("[user] сковывает меня при помощи зловещих оков, состоящих из черного дыма!"))
		if(do_mob(user, C, 30))
			if(!C.handcuffed)
				C.set_handcuffed(new /obj/item/restraints/handcuffs/energy/cult/used(C))
				C.update_handcuffed()
				C.silent += 5
				to_chat(user, span_notice("Связываю [C]."))
				log_combat(user, C, "shackled")
				uses--
			else
				to_chat(user, span_warning("[C] уже связан."))
		else
			to_chat(user, span_warning("Мне не удалось связать [C]."))
	else
		to_chat(user, span_warning("[C] уже связан."))


/obj/item/restraints/handcuffs/energy/cult //For the shackling spell
	name = "теневые оковы"
	desc = "Оковы, связывающие жертву с помощью темной магии."
	trashtype = /obj/item/restraints/handcuffs/energy/used
	item_flags = DROPDEL

/obj/item/restraints/handcuffs/energy/cult/used/dropped(mob/user)
	user.visible_message(span_danger("[user] вырвался из оков темной магии!"), \
							span_userdanger("Оковы, связывающие [src], разрушены!"))
	. = ..()


//Construction: Converts 50 iron to a construct shell, plasteel to runed metal, airlock to brittle runed airlock, a borg to a construct, or borg shell to a construct shell
/obj/item/melee/blood_magic/construction
	name = "Узор трансмутации"
	desc = "Ваша рука получает возможность трансмутировать металлические предметы."
	invocation = "Ethra p'ni dedol!"
	color = "#000000" // black
	var/channeling = FALSE

/obj/item/melee/blood_magic/construction/examine(mob/user)
	. = ..()
	. += {"<u>Преобразует:</u>\n
	Пласталь в рунический металл\n
	[IRON_TO_CONSTRUCT_SHELL_CONVERSION] железа в оболочку конструкта\n
	Живых киборгов в конструктов, с небольшой задержкой\n
	Оболочку киборга в оболочку конструкта\n
	Шлюз в хрупкий рунический шлюз (намерение навредить)"}

/obj/item/melee/blood_magic/construction/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag && IS_CULTIST(user))
		if(channeling)
			to_chat(user, span_cultitalic("Я уже произвожу трансмутацию!"))
			return
		var/turf/T = get_turf(target)
		if(istype(target, /obj/item/stack/sheet/iron))
			var/obj/item/stack/sheet/candidate = target
			if(candidate.use(IRON_TO_CONSTRUCT_SHELL_CONVERSION))
				uses--
				to_chat(user, span_warning("Из моей руки вырывается волна энергии, превращающая листы железа в оболочку конструкта!"))
				new /obj/structure/constructshell(T)
				SEND_SOUND(user, sound('sound/effects/magic.ogg',0,1,25))
			else
				to_chat(user, span_warning("Вам требуется [IRON_TO_CONSTRUCT_SHELL_CONVERSION] железа для создания оболочки конструкта!"))
				return
		else if(istype(target, /obj/item/stack/sheet/plasteel))
			var/obj/item/stack/sheet/plasteel/candidate = target
			var/quantity = candidate.amount
			if(candidate.use(quantity))
				uses --
				new /obj/item/stack/sheet/runed_metal(T,quantity)
				to_chat(user, span_warning("Из моей руки вырывается волна энергии, превращающая листы пласстали в рунический металл"))
				SEND_SOUND(user, sound('sound/effects/magic.ogg',0,1,25))
		else if(istype(target,/mob/living/silicon/robot))
			var/mob/living/silicon/robot/candidate = target
			if(candidate.mmi || candidate.shell)
				channeling = TRUE
				user.visible_message(span_danger("Темная энергия вырывается из руки [user] и окружает [candidate]!"))
				playsound(T, 'sound/machines/airlock_alien_prying.ogg', 80, TRUE)
				var/prev_color = candidate.color
				candidate.color = "black"
				if(do_after(user, 90, target = candidate))
					candidate.undeploy()
					candidate.emp_act(EMP_HEAVY)
					var/construct_class = show_radial_menu(user, src, GLOB.construct_radial_images, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE, tooltips = TRUE)
					if(!check_menu(user))
						return
					if(QDELETED(candidate))
						channeling = FALSE
						return
					candidate.grab_ghost()
					user.visible_message(span_danger("Темная энергия отступает от того, что было раньше [candidate], являя на свет\n [construct_class]!"))
					make_new_construct_from_class(construct_class, THEME_CULT, candidate, user, FALSE, T)
					uses--
					candidate.mmi = null
					qdel(candidate)
					channeling = FALSE
				else
					channeling = FALSE
					candidate.color = prev_color
					return
			else
				uses--
				to_chat(user, span_warning("Темная энергия отступает от того, что было раньше [candidate], превращая его в оболочку конструкта!"))
				new /obj/structure/constructshell(T)
				SEND_SOUND(user, sound('sound/effects/magic.ogg',0,1,25))
				qdel(candidate)
		else if(istype(target,/obj/machinery/door/airlock))
			channeling = TRUE
			playsound(T, 'sound/machines/airlockforced.ogg', 50, TRUE)
			do_sparks(5, TRUE, target)
			if(do_after(user, 50, target = user))
				if(QDELETED(target))
					channeling = FALSE
					return
				target.narsie_act()
				uses--
				user.visible_message(span_warning("Темная энергия вырывается из руки [user] и бросается на воздушный шлюз, изменяя его!"))
				SEND_SOUND(user, sound('sound/effects/magic.ogg',0,1,25))
				channeling = FALSE
			else
				channeling = FALSE
				return
		else if(istype(target,/obj/item/soulstone))
			var/obj/item/soulstone/candidate = target
			if(candidate.corrupt())
				uses--
				to_chat(user, span_warning("Я трансмутировал [candidate]!"))
				SEND_SOUND(user, sound('sound/effects/magic.ogg',0,1,25))
		else
			to_chat(user, span_warning("Это заклинание не работает на [target]!"))
			return
		..()

/obj/item/melee/blood_magic/construction/proc/check_menu(mob/user)
	if(!istype(user))
		CRASH("The cult construct selection radial menu was accessed by something other than a valid user.")
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE


//Armor: Gives the target (cultist) a basic cultist combat loadout
/obj/item/melee/blood_magic/armor
	name = "Узор битвы"
	desc = "Позволяет призвать амуницию культиста при прикосновении. Включает в себя броню, болу и меч. Не рекомендует использовать до раскрытия существования культа на станции."
	color = "#33cc33" // green

/obj/item/melee/blood_magic/armor/afterattack(atom/target, mob/living/carbon/user, proximity)
	var/mob/living/carbon/carbon_target = target
	if(istype(carbon_target) && IS_CULTIST(carbon_target) && proximity)
		uses--
		var/mob/living/carbon/C = target
		C.visible_message(span_warning("Нечистивые доспехи материализуются на [C]!"))
		C.equip_to_slot_or_del(new /obj/item/clothing/under/color/black,ITEM_SLOT_ICLOTHING)
		C.equip_to_slot_or_del(new /obj/item/clothing/suit/hooded/cultrobes/alt(user), ITEM_SLOT_OCLOTHING)
		C.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult/alt(user), ITEM_SLOT_FEET)
		C.equip_to_slot_or_del(new /obj/item/storage/backpack/cultpack(user), ITEM_SLOT_BACK)
		if(C == user)
			qdel(src) //Clears the hands
		C.put_in_hands(new /obj/item/melee/cultblade/dagger(user))
		C.put_in_hands(new /obj/item/restraints/legcuffs/bola/cult(user))
		..()

/obj/item/melee/blood_magic/manipulator
	name = "Узор сердца крови"
	desc = "Позволяет при прикосновении исцелять культистов или поглощать кровь у непосвященных. При использовании в руке позволяет вам произвести великий ритуал крови. При исцелении самого себя эффект заметно снижен."
	color = "#7D1717"

/obj/item/melee/blood_magic/manipulator/examine(mob/user)
	. = ..()
	. += "Кровавая алебарда, шквал кровавых болтов и кровавый луч стоят [BLOOD_HALBERD_COST], [BLOOD_BARRAGE_COST] и [BLOOD_BEAM_COST] зарядов соответственно."

/obj/item/melee/blood_magic/manipulator/afterattack(atom/target, mob/living/carbon/human/user, proximity)
	if(proximity)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(NOBLOOD in H.dna.species.species_traits)
				to_chat(user,span_warning("Аура иссушения не работает на целях без крови!"))
				return
			if(IS_CULTIST(H))
				if(H.stat == DEAD)
					to_chat(user,span_warning("Только руна воскрешения может вернуть мертвеца к жизни!"))
					return
				if(H.blood_volume < BLOOD_VOLUME_SAFE)
					var/restore_blood = BLOOD_VOLUME_SAFE - H.blood_volume
					if(uses*2 < restore_blood)
						H.blood_volume += uses*2
						to_chat(user,span_danger("Я потратил последний заряд, чтобы восстановить ту кровь, которую смог!"))
						uses = 0
						return ..()
					else
						H.blood_volume = BLOOD_VOLUME_SAFE
						uses -= round(restore_blood/2)
						to_chat(user,span_warning("С помощью заклинания я восстановил [H == user ? "свою" : "[H.ru_ego()]"] кровь до безопасного уровня!"))
				var/overall_damage = H.getBruteLoss() + H.getFireLoss() + H.getToxLoss() + H.getOxyLoss()
				if(overall_damage == 0)
					to_chat(user,span_cult("Этот культист не нуждается в лечении!"))
				else
					var/ratio = uses/overall_damage
					if(H == user)
						to_chat(user,span_cult("<b>Исцеление менее эффективно, когда я использую его на себе!</b>"))
						ratio *= 0.35 // Healing is half as effective if you can't perform a full heal
						uses -= round(overall_damage) // Healing is 65% more "expensive" even if you can still perform the full heal
					if(ratio>1)
						ratio = 1
						uses -= round(overall_damage)
						H.visible_message(span_warning("[H] полностью вылечен благодаря заклинанию [H==user ? "[H.ru_ego()]":"[H]"]!"))
					else
						H.visible_message(span_warning("[H] частично исцелился благодаря заклинанию [H==user ? "[H.ru_ego()]":"[H]"]."))
						uses = 0
					ratio *= -1
					H.adjustOxyLoss((overall_damage*ratio) * (H.getOxyLoss() / overall_damage), 0)
					H.adjustToxLoss((overall_damage*ratio) * (H.getToxLoss() / overall_damage), 0)
					H.adjustFireLoss((overall_damage*ratio) * (H.getFireLoss() / overall_damage), 0)
					H.adjustBruteLoss((overall_damage*ratio) * (H.getBruteLoss() / overall_damage), 0)
					H.updatehealth()
					playsound(get_turf(H), 'sound/magic/staff_healing.ogg', 25)
					new /obj/effect/temp_visual/cult/sparks(get_turf(H))
					user.Beam(H, icon_state="sendbeam", time = 15)
			else
				if(H.stat == DEAD)
					to_chat(user,span_warning("[H.ru_ego(TRUE)] перестал истекать кровью. Придется искать другой способ для её извлечения."))
					return
				if(H.cultslurring)
					to_chat(user,span_danger("[H.ru_ego(TRUE)] был испорчен более сильной магией. Кровь в таком виде вам не пригодится!"))
					return
				if(H.blood_volume > BLOOD_VOLUME_SAFE)
					H.blood_volume -= 100
					uses += 50
					user.Beam(H, icon_state="drainbeam", time = 1 SECONDS)
					playsound(get_turf(H), 'sound/magic/enter_blood.ogg', 50)
					H.visible_message(span_danger("[user] высасывает немного крови из [H]!"))
					to_chat(user,span_cultitalic("Ваше заклинание получает 50 зарядов от осушения [H]."))
					new /obj/effect/temp_visual/cult/sparks(get_turf(H))
				else
					to_chat(user,span_warning("[H.p_theyre(TRUE)] потерял слишком много крови - вы не можете больше ее [H.ru_na()] забрать!"))
					return
		if(isconstruct(target))
			var/mob/living/simple_animal/M = target
			var/missing = M.maxHealth - M.health
			if(missing)
				if(uses > missing)
					M.adjustHealth(-missing)
					M.visible_message(span_warning("[M] полностью вылечен благодаря заклинанию [user]!"))
					uses -= missing
				else
					M.adjustHealth(-uses)
					M.visible_message(span_warning("[M] частично вылечен благодаря заклинанию [user]!"))
					uses = 0
				playsound(get_turf(M), 'sound/magic/staff_healing.ogg', 25)
				user.Beam(M, icon_state="sendbeam", time = 1 SECONDS)
		if(istype(target, /obj/effect/decal/cleanable/blood))
			blood_draw(target, user)
		..()

/obj/item/melee/blood_magic/manipulator/proc/blood_draw(atom/target, mob/living/carbon/human/user)
	var/temp = 0
	var/turf/T = get_turf(target)
	if(T)
		for(var/obj/effect/decal/cleanable/blood/B in view(T, 2))
			if(B.blood_state == BLOOD_STATE_HUMAN)
				if(B.bloodiness == 100) //Bonus for "pristine" bloodpools, also to prevent cheese with footprint spam
					temp += 30
				else
					temp += max((B.bloodiness**2)/800,1)
				new /obj/effect/temp_visual/cult/turf/floor(get_turf(B))
				qdel(B)
		for(var/obj/effect/decal/cleanable/trail_holder/TH in view(T, 2))
			qdel(TH)
		if(temp)
			user.Beam(T,icon_state="drainbeam", time = 15)
			new /obj/effect/temp_visual/cult/sparks(get_turf(user))
			playsound(T, 'sound/magic/enter_blood.ogg', 50)
			to_chat(user, span_cultitalic("Узор получил [round(temp)] зарядов от источников крови вокруг меня!"))
			uses += max(1, round(temp))

/obj/item/melee/blood_magic/manipulator/attack_self(mob/living/user)
	if(IS_CULTIST(user))
		var/static/list/spells = list(
			"Bloody Halberd (150)" = image(icon = 'icons/obj/cult/items_and_weapons.dmi', icon_state = "occultpoleaxe0"),
			"Blood Bolt Barrage (300)" = image(icon = 'icons/obj/guns/projectile.dmi', icon_state = "arcane_barrage"),
			"Blood Beam (500)" = image(icon = 'icons/obj/items_and_weapons.dmi', icon_state = "disintegrate")
			)
		var/choice = show_radial_menu(user, src, spells, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE)
		if(!check_menu(user))
			to_chat(user, span_cultitalic("Сейчас не время для Великого ритуала крови."))
			return
		switch(choice)
			if("Bloody Halberd (150)")
				if(uses < BLOOD_HALBERD_COST)
					to_chat(user, span_cultitalic("Мне потребуется как минимум [BLOOD_HALBERD_COST] зарядов для проведения этого ритуала."))
				else
					uses -= BLOOD_HALBERD_COST
					var/turf/current_position = get_turf(user)
					qdel(src)
					var/datum/action/innate/cult/halberd/halberd_act_granted = new(user)
					var/obj/item/melee/cultblade/halberd/rite = new(current_position)
					halberd_act_granted.Grant(user, rite)
					rite.halberd_act = halberd_act_granted
					if(user.put_in_hands(rite))
						to_chat(user, span_cultitalic("[rite.name] появляется на моей руке!"))
					else
						user.visible_message(span_warning("[rite.name] появляется у ног [user]!"), \
							span_cultitalic("A [rite.name] материализуется у моих ног."))
			if("Blood Bolt Barrage (300)")
				if(uses < BLOOD_BARRAGE_COST)
					to_chat(user, span_cultitalic("Мне нужно [BLOOD_BARRAGE_COST] зарядов для этого обряда."))
				else
					var/obj/rite = new /obj/item/gun/ballistic/rifle/boltaction/enchanted/arcane_barrage/blood()
					uses -= BLOOD_BARRAGE_COST
					qdel(src)
					if(user.put_in_hands(rite))
						to_chat(user, span_cult("<b>Мои руки наполняются силой!</b>"))
					else
						to_chat(user, span_cultitalic("Мне нужна свободная рука для этого обряда!"))
						qdel(rite)
			if("Blood Beam (500)")
				if(uses < BLOOD_BEAM_COST)
					to_chat(user, span_cultitalic("Мне нужно [BLOOD_BEAM_COST] зарядов для этого обряда."))
				else
					var/obj/rite = new /obj/item/blood_beam()
					uses -= BLOOD_BEAM_COST
					qdel(src)
					if(user.put_in_hands(rite))
						to_chat(user, span_cultlarge("<b>Мои руки наполняются НЕВЕРОЯТНОЙ МОЩЬЮ!!!</b>"))
					else
						to_chat(user, span_cultitalic("Мне нужна свободная рука для этого обряда!"))
						qdel(rite)

/obj/item/melee/blood_magic/manipulator/proc/check_menu(mob/living/user)
	if(!istype(user))
		CRASH("The Blood Rites manipulator radial menu was accessed by something other than a valid user.")
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE
