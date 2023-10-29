/obj/item/retractor
	name = "расширитель"
	desc = "Позволяет получить оперативный простор в зоне проведения операции."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "retractor"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "clamps"
	custom_materials = list(/datum/material/iron=6000, /datum/material/glass=3000)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	tool_behaviour = TOOL_RETRACTOR
	toolspeed = 1

/obj/item/retractor/augment
	name = "кибернетический расширитель"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "retractor"
	desc = "Позволяет получить оперативный простор в зоне проведения операции."
	toolspeed = 0.5


/obj/item/hemostat
	name = "зажим"
	desc = "Используется для манипуляций в рабочей области и остановки внутренних кровотечений."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hemostat"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "clamps"
	custom_materials = list(/datum/material/iron=5000, /datum/material/glass=2500)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("атакует", "прокусывает")
	attack_verb_simple = list("атакует", "прокусывает")
	tool_behaviour = TOOL_HEMOSTAT
	toolspeed = 1

/obj/item/hemostat/augment
	name = "кибернетический зажим"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "hemostat"
	desc = "Крошечные сервоприводы приводят пару зажимов в действие, чтобы остановить кровотечение."
	toolspeed = 0.5


/obj/item/cautery
	name = "прижигатель"
	desc = "Останавливает кровотечения и дезинфецирует рабочую зону после завершения операции."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cautery"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "cautery"
	custom_materials = list(/datum/material/iron=2500, /datum/material/glass=750)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("прожигает")
	attack_verb_simple = list("прожигает")
	tool_behaviour = TOOL_CAUTERY
	toolspeed = 1

/obj/item/cautery/ignition_effect(atom/A, mob/user)
	. = span_notice("[user] притрагивается раскалённым концом [src.name] к [A.name].")

/obj/item/cautery/augment
	name = "кибернетический прижигатель"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "cautery"
	desc = "Нагревательный элемент, который прижигает раны."
	toolspeed = 0.5

/obj/item/cautery/advanced
	name = "лазерный прижигатель"
	desc = "Устройство, используемое для дезинфекции и прижигания раны за счёт излучения низкочастотного лазерного луча. Так же можно сфокусирувать луч до мощности небольшого зубного сверла."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "e_cautery"
	hitsound = 'sound/items/welder.ogg'
	toolspeed = 0.7
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_color = COLOR_SOFT_RED

/obj/item/cautery/advanced/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between drill and cautery and gives feedback to the user.
 */
/obj/item/cautery/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_DRILL : TOOL_CAUTERY)
	balloon_alert(user, "Линза [active ? "сфокусирована" : "расфокусирована"]")
	playsound(user ? user : src, 'sound/weapons/tap.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/cautery/advanced/examine()
	. = ..()
	. += span_notice("Переключатель установлен на режиме [tool_behaviour == TOOL_CAUTERY ? "прижигателя" : "сверла"].")

/obj/item/surgicaldrill
	name = "хирургическая дрель"
	desc = "Можно просверлить с помощью этого что-то. Или пробурить?"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "drill"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	hitsound = 'sound/weapons/circsawhit.ogg'
	custom_materials = list(/datum/material/iron=10000, /datum/material/glass=6000)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	force = 15
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("дырявит")
	attack_verb_simple = list("дырявит")
	tool_behaviour = TOOL_DRILL
	toolspeed = 1
	sharpness = SHARP_POINTY
	wound_bonus = 10
	bare_wound_bonus = 10

/obj/item/surgicaldrill/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/eyestab)

/obj/item/surgicaldrill/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] rams [src] into [user.ru_ego()] chest! It looks like [user.p_theyre()] trying to commit suicide!"))
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon, gib), null, null, TRUE, TRUE), 25)
	user.SpinAnimation(3, 10)
	playsound(user, 'sound/machines/juicer.ogg', 20, TRUE)
	return (MANUAL_SUICIDE)

/obj/item/surgicaldrill/augment
	name = "кибернетическая дрель"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "surgicaldrill"
	desc = "По сути, небольшая электрическая дрель, содержащаяся в руке, края притуплены, чтобы предотвратить повреждение тканей. Может или не может пронзить небеса."
	hitsound = 'sound/weapons/circsawhit.ogg'
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5


/obj/item/scalpel
	name = "скальпель"
	desc = "Очень острое лезвие с микронной заточкой."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "scalpel"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "scalpel"
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	force = 10
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron=4000, /datum/material/glass=1000)
	attack_verb_continuous = list("атакует", "рубит", "втыкает", "разрезает", "кромсает", "разрывает", "нарезает", "режет")
	attack_verb_simple = list("атакует", "рубит", "втыкает", "разрезает", "кромсает", "разрывает", "нарезает", "режет")
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SCALPEL
	toolspeed = 1
	wound_bonus = 15
	bare_wound_bonus = 15

/obj/item/scalpel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 80 * toolspeed, 100, 0)
	AddElement(/datum/element/eyestab)

/obj/item/scalpel/augment
	name = "кибернетический скальпель"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "scalpel"
	desc = "Ультра-острое лезвие прикреплено непосредственно к кости для дополнительной точности."
	toolspeed = 0.5

/obj/item/scalpel/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is slitting [user.ru_ego()] [pick("wrists", "throat", "stomach")] with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (BRUTELOSS)


/obj/item/circular_saw
	name = "циркулярная пила"
	desc = "Для работы с костью при полостных операциях."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "saw"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	hitsound = 'sound/weapons/circsawhit.ogg'
	mob_throw_hit_sound =  'sound/weapons/pierce.ogg'
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	force = 15
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 9
	throw_speed = 2
	throw_range = 5
	custom_materials = list(/datum/material/iron=1000)
	attack_verb_continuous = list("атакует", "рубит", "пилит", "режет")
	attack_verb_simple = list("атакует", "рубит", "пилит", "режет")
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SAW
	toolspeed = 1
	wound_bonus = 15
	bare_wound_bonus = 10

/obj/item/circular_saw/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 40 * toolspeed, 100, 5, 'sound/weapons/circsawhit.ogg') //saws are very accurate and fast at butchering

/obj/item/circular_saw/augment
	name = "кибернетическая пила"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "circular_saw"
	desc = "Маленькая, но очень быстро вращающаяся пила."
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5

/obj/item/surgical_drapes
	name = "хирургическая простыня"
	desc = "Хирургические простыни марки NanoTrasen обеспечивают оптимальную безопасность и защиту от инфекций."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "surgical_drapes"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "drapes"
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("шлёпает")
	attack_verb_simple = list("шлёпает")

/obj/item/surgical_drapes/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/surgery_initiator)


/obj/item/organ_storage //allows medical cyborgs to manipulate organs without hands
	name = "сумка для хранения органов"
	desc = "Контейнер для хранения частей тела."
	icon = 'icons/obj/storage.dmi'
	icon_state = "evidenceobj"
	item_flags = SURGICAL_TOOL

/obj/item/organ_storage/afterattack(obj/item/I, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(contents.len)
		to_chat(user, span_warning("[capitalize(src.name)] уже что-то хранит!"))
		return
	if(!isorgan(I) && !isbodypart(I))
		to_chat(user, span_warning("[capitalize(src.name)] может содержать только части тела!"))
		return

	user.visible_message(span_notice("[user] кладёт [I] внутрь [src].") , span_notice("Кладу [I] внутрь [src]."))
	icon_state = "evidence"
	var/xx = I.pixel_x
	var/yy = I.pixel_y
	I.pixel_x = 0
	I.pixel_y = 0
	var/image/img = image("icon"=I, "layer"=FLOAT_LAYER)
	SET_PLANE(img, FLOAT_PLANE, img)
	I.pixel_x = xx
	I.pixel_y = yy
	add_overlay(img)
	add_overlay("evidence")
	desc = "Контейнер содержит [I]."
	I.forceMove(src)
	w_class = I.w_class

/obj/item/organ_storage/attack_self(mob/user)
	if(contents.len)
		var/obj/item/I = contents[1]
		user.visible_message(span_notice("[user] вытряхивает [I] из [src].") , span_notice("Вытряхиваю [I] из [src]."))
		cut_overlays()
		I.forceMove(get_turf(src))
		icon_state = "evidenceobj"
		desc = "Контейнер для хранения частей тела."
	else
		to_chat(user, span_notice("[capitalize(src.name)] пуст."))
	return

/obj/item/surgical_processor //allows medical cyborgs to scan and initiate advanced surgeries
	name = "хирургический процессор"
	desc = "Устройство для сканирования и запуска операций с диска или операционного компьютера."
	icon = 'icons/obj/device.dmi'
	icon_state = "spectrometer"
	item_flags = NOBLUDGEON
	var/list/advanced_surgeries = list()

/obj/item/surgical_processor/afterattack(obj/item/O, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(istype(O, /obj/item/disk/surgery))
		to_chat(user, span_notice("Загружаю хирургический протокол из [O] в [src]."))
		var/obj/item/disk/surgery/D = O
		if(do_after(user, 10, target = O))
			advanced_surgeries |= D.surgeries
		return TRUE
	if(istype(O, /obj/machinery/computer/operating))
		to_chat(user, span_notice("Копирую хирургический протокол из [O] в [src]."))
		var/obj/machinery/computer/operating/OC = O
		if(do_after(user, 10, target = O))
			advanced_surgeries |= OC.advanced_surgeries
		return TRUE
	return

/obj/item/scalpel/advanced
	name = "лазерный скальпель"
	desc = "Усовершенствованный скальпель, который использует лазерную технологию для резки. Переключателем можно увеличить мощность излучателя для работы с костью."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "e_scalpel"
	hitsound = 'sound/weapons/blade1.ogg'
	force = 16
	toolspeed = 0.7
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_color = LIGHT_COLOR_GREEN
	sharpness = SHARP_EDGED

/obj/item/scalpel/advanced/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = force + 2, \
		throwforce_on = throwforce, \
		throw_speed_on = throw_speed, \
		sharpness_on = sharpness, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between saw and scalpel and updates the light / gives feedback to the user.
 */
/obj/item/scalpel/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(active)
		tool_behaviour = TOOL_SAW
		set_light_range(2)
	else
		tool_behaviour = TOOL_SCALPEL
		set_light_range(1)

	balloon_alert(user, "[active ? "Увеличиваю" : "Уменьшаю"] мощность")
	playsound(user ? user : src, 'sound/machines/click.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/scalpel/advanced/examine()
	. = ..()
	. += span_notice("Переключатель мощности установлен на режиме [tool_behaviour == TOOL_SCALPEL ? "скальпеля" : "пилы"].")

/obj/item/retractor/advanced
	name = "механический зажим"
	desc = "Сложный инструмент состоящий из шестеренок и манипуляторов."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "adv_retractor"
	toolspeed = 0.7

/obj/item/retractor/advanced/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between retractor and hemostat and gives feedback to the user.
 */
/obj/item/retractor/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_HEMOSTAT : TOOL_RETRACTOR)
	balloon_alert(user, "Шестерни установлены в положении [active ? "зажима" : "расширителя"]")
	playsound(user ? user : src, 'sound/items/change_drill.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/retractor/advanced/examine()
	. = ..()
	. += span_notice("Шестерни установлены в положении  [tool_behaviour == TOOL_RETRACTOR ? "расширителя" : "зажима"].")

/obj/item/shears
	name = "ножницы для ампутации"
	desc = "Тип тяжелых хирургических ножниц, используемых для достижения чистого разделения между конечностью и пациентом. Держать пациента по-прежнему необходимо, чтобы иметь возможность закрепить и выровнять ножницы."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "shears"
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	toolspeed  = 1
	force = 12
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 6
	throw_speed = 2
	throw_range = 5
	custom_materials = list(/datum/material/iron=8000, /datum/material/titanium=6000)
	attack_verb_continuous = list("стрижёт", "режет")
	attack_verb_simple = list("стрижёт", "режет")
	sharpness = SHARP_EDGED
	custom_premium_price = PAYCHECK_MEDIUM * 14

/obj/item/shears/attack(mob/living/M, mob/user)
	if(!iscarbon(M) || user.a_intent != INTENT_HELP)
		return ..()

	if(user.zone_selected == BODY_ZONE_CHEST)
		return ..()

	var/mob/living/carbon/patient = M

	if(HAS_TRAIT(patient, TRAIT_NODISMEMBER))
		to_chat(user, span_warning("Конечности пациента выглядят слишком крепкими для ампутации."))
		return

	var/candidate_name
	var/obj/item/organ/tail_snip_candidate
	var/obj/item/bodypart/limb_snip_candidate

	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN)
		tail_snip_candidate = patient.get_organ_slot(ORGAN_SLOT_TAIL)
		if(!tail_snip_candidate)
			to_chat(user, span_warning("[patient] не имеет хвоста."))
			return
		candidate_name = tail_snip_candidate.name

	else
		limb_snip_candidate = patient.get_bodypart(check_zone(user.zone_selected))
		if(!limb_snip_candidate)
			to_chat(user, span_warning("[patient] не имеет здесь конечности."))
			return
		candidate_name = limb_snip_candidate.name

	var/amputation_speed_mod

	patient.visible_message(span_danger("[user] начинает устанавливать [src] вокруг [candidate_name] [patient].") , span_userdanger("[user] начинает закреплять [src] вокруг моей [candidate_name]!"))
	playsound(get_turf(patient), 'sound/items/ratchet.ogg', 20, TRUE)
	if(patient.stat >= UNCONSCIOUS || patient.IsStun()) //Stun is used by paralytics like curare it should not be confused with the more common paralyze.
		amputation_speed_mod = 0.5
	else if(patient.jitteriness >= 1)
		amputation_speed_mod = 1.5
	else
		amputation_speed_mod = 1

	if(do_after(user,  toolspeed * 150 * amputation_speed_mod, target = patient))
		playsound(get_turf(patient), 'sound/weapons/sword_kill_slash_02.ogg', 250, TRUE)
		if(user.zone_selected == BODY_ZONE_PRECISE_GROIN) //OwO
			tail_snip_candidate.Remove(patient)
			tail_snip_candidate.forceMove(get_turf(patient))
		else
			limb_snip_candidate.dismember()
		user.visible_message(span_danger("[capitalize(src.name)] яростно захлопывается, ампутируя [candidate_name] [patient].") , span_notice("Ампутирую [candidate_name] [patient] используя [src]."))

/obj/item/shears/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] is pinching [user.p_them()]self with <b>[src.name]</b>! It looks like [user.p_theyre()] trying to commit suicide!"))
	var/timer = 1 SECONDS
	for(var/obj/item/bodypart/thing in user.bodyparts)
		if(thing.body_part == CHEST)
			continue
		addtimer(CALLBACK(thing, TYPE_PROC_REF(/obj/item/bodypart, dismember)), timer)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), user, 'sound/weapons/sword_kill_slash_02.ogg', 70), timer)
		timer += 1 SECONDS
	sleep(timer)
	return BRUTELOSS

/obj/item/bonesetter
	name = "костоправ"
	desc = "Для правильной ориентации костей при вывихах и переломах."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone setter"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron=5000, /datum/material/glass=2500)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("корректирует", "правильно устанавливает")
	attack_verb_simple = list("корректирует", "правильно устанавливает")
	tool_behaviour = TOOL_BONESET
	toolspeed = 1

/obj/item/bonesetter/augment
	name = "кибернетический костоправ"
	icon = 'white/Feline/icons/cyber_arm_surgery.dmi'
	icon_state = "bone_setter"
	desc = "Для правильной ориентации костей при вывихах и переломах."
	toolspeed = 0.5

/obj/item/blood_filter
	name = "фильтр крови"
	desc = "Для фильтрации крови и лимфы."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bloodfilter"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron=2000, /datum/material/glass=1500, /datum/material/silver=500)
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("pumps", "siphons")
	attack_verb_simple = list("pumps", "siphons")
	tool_behaviour = TOOL_BLOODFILTER
	toolspeed = 1

/obj/item/blood_filter/augment
	toolspeed = 0.5

