//These mutations change your overall "form" somehow, like size

//Epilepsy gives a very small chance to have a seizure every life tick, knocking you unconscious.
/datum/mutation/human/epilepsy
	name = "Эпилепсия"
	desc = "Генетический дефект, который время от времени вызывает судороги."
	quality = NEGATIVE
	text_gain_indication = span_danger("У меня болит голова и трясутся руки.")
	synchronizer_coeff = 1
	power_coeff = 1

/datum/mutation/human/epilepsy/on_life(delta_time, times_fired)
	if(DT_PROB(0.5 * GET_MUTATION_SYNCHRONIZER(src), delta_time) && owner.stat == CONSCIOUS)
		owner.visible_message(span_danger("[owner] содрогается в припадке!") , span_userdanger("У меня приступ!"))
		owner.Unconscious(200 * GET_MUTATION_POWER(src))
		owner.Jitter(1000 * GET_MUTATION_POWER(src))
		SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "epilepsy", /datum/mood_event/epilepsy)
		addtimer(CALLBACK(src, PROC_REF(jitter_less)), 90)

/datum/mutation/human/epilepsy/proc/jitter_less()
	if(owner)
		owner.jitteriness = 10


//Unstable DNA induces random mutations!
/datum/mutation/human/bad_dna
	name = "Нестабильная ДНК"
	desc = "Серьезное генетическое отклонение, которое нарушает генетическую стабильность, тем самым вызывая произвольные мутации."
	quality = NEGATIVE
	text_gain_indication = span_danger("Я чувствую себя не таким как вчера...")
	locked = TRUE

/datum/mutation/human/bad_dna/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	to_chat(owner, text_gain_indication)
	var/mob/new_mob
	if(prob(95))
		if(prob(50))
			new_mob = owner.easy_randmut(NEGATIVE + MINOR_NEGATIVE)
		else
			new_mob = owner.randmuti()
	else
		new_mob = owner.easy_randmut(POSITIVE)
	if(new_mob && ismob(new_mob))
		owner = new_mob
	. = owner
	on_losing(owner)


//Cough gives you a chronic cough that causes you to drop items.
/datum/mutation/human/cough
	name = "Кашель"
	desc = "Хронический кашель."
	quality = MINOR_NEGATIVE
	text_gain_indication = span_danger("Кха... Я не могу, кха... перестать кашлять, кха...")
	synchronizer_coeff = 1
	power_coeff = 1

/datum/mutation/human/cough/on_life(delta_time, times_fired)
	if(DT_PROB(2.5 * GET_MUTATION_SYNCHRONIZER(src), delta_time) && owner.stat == CONSCIOUS)
		owner.drop_all_held_items()
		owner.emote("cough")
		if(GET_MUTATION_POWER(src) > 1)
			var/cough_range = GET_MUTATION_POWER(src) * 4
			var/turf/target = get_ranged_target_turf(owner, turn(owner.dir, 180), cough_range)
			owner.throw_at(target, cough_range, GET_MUTATION_POWER(src))

/datum/mutation/human/paranoia
	name = "Паранойя"
	desc = "Субъект легко поддается панике и может страдать от галлюцинаций."
	quality = NEGATIVE
	text_gain_indication = span_danger("Я слышу крики и плач тысяч голосов в своей голове...")
	text_lose_indication = span_notice("Голоса в голове замолкли.")

/datum/mutation/human/paranoia/on_life(delta_time, times_fired)
	if(DT_PROB(2.5, delta_time) && owner.stat == CONSCIOUS)
		owner.emote("agony")
		if(prob(25))
			owner.hallucination += 20

//Dwarfism shrinks your body and lets you pass tables.
/datum/mutation/human/dwarfism
	name = "Дворфизм"
	desc = "Мутация которая увеличивает мир вокруг носителя."
	quality = POSITIVE
	difficulty = 16
	instability = 5
	conflicts = list(GIGANTISM)
	locked = TRUE    // Default intert species for now, so locked from regular pool.

/datum/mutation/human/dwarfism/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_DWARF, GENETIC_MUTATION)
	var/matrix/new_transform = matrix()
	new_transform.Scale(1, 0.8)
	owner.transform = new_transform.Multiply(owner.transform)
	passtable_on(owner, GENETIC_MUTATION)
	owner.visible_message(span_danger("[owner] резко уменьшился!") , span_notice("Кажется, что всё такое большое.."))

/datum/mutation/human/dwarfism/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_DWARF, GENETIC_MUTATION)
	var/matrix/new_transform = matrix()
	new_transform.Scale(1, 1.25)
	owner.transform = new_transform.Multiply(owner.transform)
	passtable_off(owner, GENETIC_MUTATION)
	owner.visible_message(span_danger("[owner] резко увеличился!") , span_notice("Кажется, что всё такое маленькое.."))

//Clumsiness has a very large amount of small drawbacks depending on item.
/datum/mutation/human/clumsy
	name = "Неуклюжесть"
	desc = "Ген нарушающий тонкую моторику и блокирующий некоторые связи в мозге носителя. Хонк!"
	quality = MINOR_NEGATIVE
	text_gain_indication = span_danger("Хееей! Все стало таким прикольным! Хонк!")

/datum/mutation/human/clumsy/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_CLUMSY, GENETIC_MUTATION)

/datum/mutation/human/clumsy/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_CLUMSY, GENETIC_MUTATION)


//Tourettes causes you to randomly stand in place and shout.
/datum/mutation/human/tourettes
	name = "Синдром Туретта"
	desc = "Хроническое генетическое отклонение, вынуждающее носителя непроизвольно выкрикивать слова." //definitely needs rewriting
	quality = NEGATIVE
	text_gain_indication = span_danger("Меня ДЁРГАЕТ.")
	synchronizer_coeff = 1

/datum/mutation/human/tourettes/on_life(delta_time, times_fired)
	if(DT_PROB(5 * GET_MUTATION_SYNCHRONIZER(src), delta_time) && owner.stat == CONSCIOUS && !owner.IsStun())
		owner.Stun(200)
		switch(rand(1, 3))
			if(1)
				owner.emote("twitch")
			if(2 to 3)
				owner.say("[prob(50) ? ";" : ""][pick("ГОВНО", "ЖОПА", "МОЧА", "БЛЯТЬ", "ПИЗДА", "ХУЕСОС", "МАМУ ЕБАЛ", "СИСЬКИ")]!", forced=name)
		var/x_offset_old = owner.pixel_x
		var/y_offset_old = owner.pixel_y
		var/x_offset = owner.pixel_x + rand(-2,2)
		var/y_offset = owner.pixel_y + rand(-1,1)
		animate(owner, pixel_x = x_offset, pixel_y = y_offset, time = 1)
		animate(owner, pixel_x = x_offset_old, pixel_y = y_offset_old, time = 1)


//Deafness makes you deaf.
/datum/mutation/human/deaf
	name = "Глухота"
	desc = "Носитель полностью генетически глух."
	quality = NEGATIVE
	text_gain_indication = span_danger("Я ничего не слышу...")

/datum/mutation/human/deaf/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_DEAF, GENETIC_MUTATION)

/datum/mutation/human/deaf/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_DEAF, GENETIC_MUTATION)


//Monified turns you into a monkey.
/datum/mutation/human/race
	name = "Манкификация"
	desc = "Странный геном, который показывает, что мы не так уж и далеко ушли от обезьян."
	text_gain_indication = "Я чувствую себя более примитивным."
	text_lose_indication = "Я чувствую себя преждним."
	quality = NEGATIVE
	locked = TRUE //Species specific, keep out of actual gene pool
	var/datum/species/original_species = /datum/species/human
	var/original_name

/datum/mutation/human/race/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	if(!ismonkey(owner))
		original_species = owner.dna.species.type
		original_name = owner.real_name
		owner.fully_replace_character_name(null, "мартышка ([rand(1,999)])")
	. = owner.monkeyize()

/datum/mutation/human/race/on_losing(mob/living/carbon/human/owner)
	if(owner && owner.stat != DEAD && (owner.dna.mutations.Remove(src)) && ismonkey(owner))
		owner.fully_replace_character_name(null, original_name)
		. = owner.humanize(original_species)
/datum/mutation/human/glow
	name = "Свечение"
	desc = "Трансмутирует кожный покров носителя, тем самым вынуждая его постоянно излучать свет случайного цвета и интенсивностью."
	quality = POSITIVE
	text_gain_indication = span_notice("Моя кожа светится...")
	instability = 5
	var/obj/effect/dummy/luminescent_glow/glowth //shamelessly copied from luminescents
	var/glow = 2.5
	var/range = 2.5
	var/glow_color
	power_coeff = 1
	conflicts = list(/datum/mutation/human/glow/anti)

/datum/mutation/human/glow/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	glow_color = glow_color()
	glowth = new(owner)
	modify()

/datum/mutation/human/glow/modify()
	if(!glowth)
		return
	var/power = GET_MUTATION_POWER(src)

	glowth.set_light_range_power_color(range * power, glow, glow_color)


/// Returns the color for the glow effect
/datum/mutation/human/glow/proc/glow_color()
	return pick(COLOR_RED, COLOR_BLUE, COLOR_YELLOW, COLOR_GREEN, COLOR_PURPLE, COLOR_ORANGE)

/datum/mutation/human/glow/on_losing(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	QDEL_NULL(glowth)

/datum/mutation/human/glow/anti
	name = "Светопоглощение"
	desc = "Кожа носителя поглощает частицы света и препятствует его отражению, образно говоря создавая вокруг носителя тьму."
	text_gain_indication = span_notice("Свет вокруг меня становится тусклее...")
	glow = -1.5
	conflicts = list(/datum/mutation/human/glow)
	locked = TRUE

/datum/mutation/human/glow/anti/glow_color()
	return COLOR_VERY_LIGHT_GRAY

/datum/mutation/human/strong
	name = "Сила"
	desc = "Приводит мышцы носителя в тонус."
	quality = POSITIVE
	text_gain_indication = span_notice("Чувствую себя сильнее...")
	difficulty = 16

/datum/mutation/human/stimmed
	name = "Биохимический баланс"
	desc = "Приводит в порядок внутреннюю биофлору носителя."
	quality = POSITIVE
	text_gain_indication = span_notice("Чувствую себя здоровее...")
	difficulty = 16

/datum/mutation/human/insulated
	name = "Электроизоляция"
	desc = "Делает организм носителя невосприимчивым к ударам электрическим током."
	quality = POSITIVE
	text_gain_indication = span_notice("Кончики пальцев немеют...")
	text_lose_indication = span_notice("Чувствительность пальцев восстанавливается.")
	difficulty = 16
	instability = 25

/datum/mutation/human/insulated/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_SHOCKIMMUNE, "genetics")

/datum/mutation/human/insulated/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_SHOCKIMMUNE, "genetics")

/datum/mutation/human/fire
	name = "Огненный пот"
	desc = "Изменяет потовые железы носителя, провоцируя их выделять самовоспламеняющийся пот. Однако это также делает носителя более устойчивым к воздействию пламени."
	quality = NEGATIVE
	text_gain_indication = span_warning("Моя кожа горит!")
	text_lose_indication = span_notice("Прохлада вернулась...")
	difficulty = 14
	synchronizer_coeff = 1
	power_coeff = 1

/datum/mutation/human/fire/on_life(delta_time, times_fired)
	if(DT_PROB((0.05+(100-dna.stability)/19.5) * GET_MUTATION_SYNCHRONIZER(src), delta_time))
		owner.adjust_fire_stacks(2 * GET_MUTATION_POWER(src))
		owner.ignite_mob()

/datum/mutation/human/fire/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.physiology.burn_mod *= 0.5

/datum/mutation/human/fire/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.physiology.burn_mod *= 2

/datum/mutation/human/badblink
	name = "Пространственная нестабильность"
	desc = "Жертва теряет связь с пространственно-временным континуумом и совершает неконтролируемые прыжки. Также вызывает сильную тошноту."
	quality = NEGATIVE
	text_gain_indication = span_warning("Пространство вокруг меня тошнотворно искривляется.")
	text_lose_indication = span_notice("Пространство вокруг меня приходит в норму.")
	difficulty = 18//high so it's hard to unlock and abuse
	instability = 10
	synchronizer_coeff = 1
	energy_coeff = 1
	power_coeff = 1
	var/warpchance = 0

/datum/mutation/human/badblink/on_life(delta_time, times_fired)
	if(DT_PROB(warpchance, delta_time))
		var/warpmessage = pick(
		span_warning("С отвратительным поворотом на 720 градусов, [owner] растворяется в воздухе.") ,
		span_warning("[owner] складывается несколько раз пополам в неестественных позах пока не уменьшается до размера пылинки. Это выглядело довольно болезненным...") ,
		span_warning("[owner] внезапно сдвигается чуть правее, через мгновение он оказывается левее, а затем бесследно исчезает.") ,
		span_warning("[owner] засасывает внутрь самого себя и он испаряется.") ,
		span_warning("Только что [owner] находился прямо перед вами, но стоило вам моргнуть как его уже нет."))
		owner.visible_message(warpmessage, span_userdanger("Пространство вокруг меня тошнотворно искривляется!"))
		var/warpdistance = rand(10, 15) * GET_MUTATION_POWER(src)
		do_teleport(owner, get_turf(owner), warpdistance, channel = TELEPORT_CHANNEL_FREE)
		owner.adjust_disgust(GET_MUTATION_SYNCHRONIZER(src) * (warpchance * warpdistance))
		warpchance = 0
		owner.visible_message(span_danger("[owner] появляется из ниоткуда!"))
	else
		warpchance += 0.0625 * GET_MUTATION_ENERGY(src) * delta_time

/datum/mutation/human/acidflesh
	name = "Кислотная плоть"
	desc = "Под кожей жертвы образуются нарывы с едкой кислотой. Летально!"
	quality = NEGATIVE
	text_gain_indication = span_userdanger("Мне очень больно! Такое ощущение что в моих венах серная кислота!")
	text_lose_indication = span_notice("Моя кожа перестала отслаиваться отвратительными едкими пластами...")
	difficulty = 18//high so it's hard to unlock and use on others
	/// The cooldown for the warning message
	COOLDOWN_DECLARE(msgcooldown)

/datum/mutation/human/acidflesh/on_life(delta_time, times_fired)
	if(DT_PROB(13, delta_time))
		if(COOLDOWN_FINISHED(src, msgcooldown))
			to_chat(owner, span_danger("Кожа на моей руке пузырится..."))
			COOLDOWN_START(src, msgcooldown, 20 SECONDS)
		if(prob(15))
			owner.acid_act(rand(30, 50), 10)
			owner.visible_message(span_warning("Кожа на теле [owner] пузырится и лопается в кислотных брызгах.") , span_userdanger("Кислотный нарыв лопнул! Жгется!"))
			playsound(owner,'sound/weapons/sear.ogg', 50, TRUE)

/datum/mutation/human/gigantism
	name = "Гигантизм"//negative version of dwarfism
	desc = "Увеличивает межклеточное пространство в организме носителя, тем самым увеличивая его физический размер."
	quality = MINOR_NEGATIVE
	difficulty = 12
	conflicts = list(DWARFISM)

/datum/mutation/human/gigantism/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_GIANT, GENETIC_MUTATION)
	owner.resize = 1.25
	owner.update_transform()
	owner.visible_message(span_danger("[owner] резко увеличился!") , span_notice("Кажется, что всё такое маленькое.."))

/datum/mutation/human/gigantism/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_GIANT, GENETIC_MUTATION)
	owner.resize = 0.8
	owner.update_transform()
	owner.visible_message(span_danger("[owner] резко уменьшился!") , span_notice("Кажется, что всё такое большое.."))

/datum/mutation/human/spastic
	name = "Мышечные спазмы"
	desc = "Субъект страдает от мышечных спазмов."
	quality = NEGATIVE
	text_gain_indication = span_warning("Мои конечности самопроизвольно сокращаются!")
	text_lose_indication = span_notice("Вновь контролирую свое тело...")
	difficulty = 16

/datum/mutation/human/spastic/on_acquiring()
	if(..())
		return
	owner.apply_status_effect(STATUS_EFFECT_SPASMS)

/datum/mutation/human/spastic/on_losing()
	if(..())
		return
	owner.remove_status_effect(STATUS_EFFECT_SPASMS)

/datum/mutation/human/extrastun
	name = "Две левых ноги"
	desc = "Мутация, которая заменяет вашу правую ногу еще одной левой ногой. Будьте готовы к постоянным встречам вашего лица с полом."
	quality = NEGATIVE
	text_gain_indication = span_warning("Левой, Правой! Левой, левой, левой? левой?! Ай!")
	text_lose_indication = span_notice("Левой, Правой! Левой, Правой!")
	difficulty = 16

/datum/mutation/human/extrastun/on_acquiring()
	. = ..()
	if(.)
		return
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))

/datum/mutation/human/extrastun/on_losing()
	. = ..()
	if(.)
		return
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

///Triggers on moved(). Randomly makes the owner trip
/datum/mutation/human/extrastun/proc/on_move()
	SIGNAL_HANDLER

	if(prob(99.5)) //The brawl mutation
		return
	if(owner.buckled || owner.body_position == LYING_DOWN || HAS_TRAIT(owner, TRAIT_IMMOBILIZED) || owner.throwing || owner.movement_type & (VENTCRAWLING | FLYING | FLOATING))
		return //remove the 'edge' cases
	to_chat(owner, span_danger("Спотыкаюсь, запутавшись в своих же ногах."))
	owner.Knockdown(30)

/datum/mutation/human/martyrdom
	name = "Кровавый мученик"
	desc = "Мутация которая вызывает коллапсирующую клеточную дестабилизацию если организм носителя близок к смерти. Взрыв наносит небольшой урон, а так же очень, ОЧЕНЬ сильно дезориентирует!"
	locked = TRUE
	quality = POSITIVE //not that cloning will be an option a lot but generally lets keep this around i guess?
	text_gain_indication = span_warning("Я чувствую внутри себя странную вибрацию.")
	text_lose_indication = span_notice("Вибрация успокоилась.")

/datum/mutation/human/martyrdom/on_acquiring()
	. = ..()
	if(.)
		return TRUE
	RegisterSignal(owner, COMSIG_MOB_STATCHANGE, PROC_REF(bloody_shower))

/datum/mutation/human/martyrdom/on_losing()
	. = ..()
	if(.)
		return TRUE
	UnregisterSignal(owner, COMSIG_MOB_STATCHANGE)

/datum/mutation/human/martyrdom/proc/bloody_shower(datum/source, new_stat)
	SIGNAL_HANDLER

	if(new_stat != HARD_CRIT)
		return
	var/list/organs = owner.getorganszone(BODY_ZONE_HEAD, 1)

	for(var/obj/item/organ/I in organs)
		qdel(I)

	explosion(owner, light_impact_range = 2, adminlog = TRUE, explosion_cause = src)
	for(var/mob/living/carbon/human/H in view(2,owner))
		var/obj/item/organ/eyes/eyes = H.get_organ_slot(ORGAN_SLOT_EYES)
		if(eyes)
			to_chat(H, span_userdanger("Я был ослеплен и дезориентирован чудовищным кровавым взрывом! Это было ужасно!"))
		else
			to_chat(H, span_userdanger("Я был сбит с ног волной чего-то жидкого, теплого и отдающего железом... погодите... это что? КРОВЬ?!"))
		H.Stun(100)
		H.blur_eyes(200)
		eyes?.applyOrganDamage(25)
		H.add_confusion(30)
	for(var/mob/living/silicon/S in view(2,owner))
		to_chat(S, span_userdanger("Сенсоры были замкнуты волной крови! Критическая ошибка! Перезагрузка..."))
		S.Paralyze(600)
	owner.gib()

/datum/mutation/human/headless
	name = "Х.А.Р.С."
	desc = "Мутация вызывающее аутоиммунное отторжение головы. Мозг при этом переносится в тело. Название состоит из первых букв фамилий ученых-первооткрывателей, они же первые жертвы... "
	difficulty = 12 //pretty good for traitors
	quality = NEGATIVE //holy shit no eyes or tongue or ears
	text_gain_indication = span_warning("Кажется я что-то потерял, только не могу понять что...")

/datum/mutation/human/headless/on_acquiring(user)
	. = ..()
	if(.)//cant add
		return TRUE

	var/mob/living/carbon/C = user
	C.dismember_bleed_block = TRUE

	var/obj/item/organ/brain/brain = owner.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.zone = BODY_ZONE_CHEST

	var/obj/item/bodypart/head/head = owner.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		owner.visible_message(span_warning("Голова [owner] взрывается в брызгах костей и крови!") , ignored_mobs = list(owner))
		new /obj/effect/gibspawner/generic(get_turf(owner), owner)
		head.dismember(BRUTE)
		head.drop_organs()
		qdel(head)
		owner.regenerate_icons()
	RegisterSignal(owner, COMSIG_CARBON_ATTACH_LIMB, PROC_REF(abortattachment))

/datum/mutation/human/headless/on_losing(user)
	. = ..()
	if(.)
		return TRUE

	var/mob/living/carbon/C = user
	C.dismember_bleed_block = FALSE

	var/obj/item/organ/brain/brain = owner.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain) //so this doesn't instantly kill you. we could delete the brain, but it lets people cure brain issues they /really/ shouldn't be
		brain.zone = BODY_ZONE_HEAD
	UnregisterSignal(owner, COMSIG_CARBON_ATTACH_LIMB)
	var/successful = owner.regenerate_limb(BODY_ZONE_HEAD, noheal = TRUE) //noheal needs to be TRUE to prevent weird adding and removing mutation healing
	if(!successful)
		stack_trace("ТЕХНИЧЕСКАЯ ОШИБКА, сообщите вкодербас! Голова не может быть восстановлена так как она уже на своем месте.")
		return TRUE
	owner.dna.species.regenerate_organs(owner, replace_current = FALSE, excluded_zones = list(BODY_ZONE_CHEST)) //replace_current needs to be FALSE to prevent weird adding and removing mutation healing
	owner.apply_damage(damage = 50, damagetype = BRUTE, def_zone = BODY_ZONE_HEAD) //and this to DISCOURAGE organ farming, or at least not make it free.
	owner.visible_message(span_warning("Голова [owner] с отвратительным хрустом вырывается прямо из тела! Это выглядело ужасно!") , span_warning("Моя голова как будто выныривает прямо из моего туловища. Это было бы очень странно, если бы не было так больно..."))
	new /obj/effect/gibspawner/generic(get_turf(owner), owner)


/datum/mutation/human/headless/proc/abortattachment(datum/source, obj/item/bodypart/new_limb, special) //you aren't getting your head back
	SIGNAL_HANDLER

	if(istype(new_limb, /obj/item/bodypart/head))
		return COMPONENT_NO_ATTACH
