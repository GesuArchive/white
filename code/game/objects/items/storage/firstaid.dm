/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 *		Dice Pack (in a pill bottle)
 */

/*
 * First Aid Kits
 */
/obj/item/storage/firstaid
	name = "аптечка первой помощи"
	desc = "Содержит шовный и перевязочный материал для лечения легких травм."
	icon_state = "firstaid"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 7
	var/empty = FALSE
	var/damagetype_healed //defines damage type of the medkit. General ones stay null. Used for medibot healing bonuses

/obj/item/storage/firstaid/regular
	icon_state = "firstaid"
	desc = "Содержит шовный и перевязочный материал для лечения легких травм."

/obj/item/storage/firstaid/regular/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins giving [user.ru_na()]self aids with <b>[src.name]</b>! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS

/obj/item/storage/firstaid/regular/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/stack/medical/gauze = 1,
		/obj/item/stack/medical/suture = 2,
		/obj/item/stack/medical/mesh = 2,
		/obj/item/reagent_containers/hypospray/medipen = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/firstaid/emergency
	icon_state = "medbriefcase"
	name = "аварийная аптечка первой помощи"
	desc = "Максимально простой набор медикаментов для стабилизации пациента и последующей транспортировки в мед блок."

/obj/item/storage/firstaid/emergency/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/healthanalyzer/wound = 1,
		/obj/item/stack/medical/gauze = 1,
		/obj/item/stack/medical/suture/emergency = 1,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/reagent_containers/hypospray/medipen/ekit = 2,
		/obj/item/storage/pill_bottle/iron = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/firstaid/medical
	name = "аптечка хирурга"
	icon_state = "firstaid_surgery"
	inhand_icon_state = "firstaid"
	custom_premium_price = PAYCHECK_HARD * 2
	desc = "Укладка с малым хирургическим набором и шовным материалом. Обладает гораздо большей вместительностью по сравнению с стандартной аптечкой."

/obj/item/storage/firstaid/medical/Initialize()
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL //holds the same equipment as a medibelt
	atom_storage.max_slots = 14
	atom_storage.max_total_storage = 24
	atom_storage.set_holdable(list(
		/obj/item/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/medigel,
		/obj/item/reagent_containers/spray,
		/obj/item/lighter,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/flashlight/pen,
		/obj/item/extinguisher/mini,
		/obj/item/reagent_containers/hypospray,
		/obj/item/sensor_device,
		/obj/item/radio,
		/obj/item/clothing/gloves/,
		/obj/item/lazarus_injector,
		/obj/item/bikehorn/rubberducky,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/surgical_drapes, //for true paramedics
		/obj/item/breathing_bag,
		/obj/item/scalpel,
		/obj/item/circular_saw,
		/obj/item/bonesetter,
		/obj/item/surgicaldrill,
		/obj/item/retractor,
		/obj/item/cautery,
		/obj/item/hemostat,
		/obj/item/blood_filter,
		/obj/item/shears,
		/obj/item/geiger_counter,
		/obj/item/clothing/neck/stethoscope,
		/obj/item/stamp,
		/obj/item/clothing/glasses,
		/obj/item/wrench/medical,
		/obj/item/clothing/mask/muzzle,
		/obj/item/reagent_containers/blood,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/gun/syringe/syndicate,
		/obj/item/implantcase,
		/obj/item/implant,
		/obj/item/implanter,
		/obj/item/pinpointer/crew,
		/obj/item/holosign_creator/medical,
		/obj/item/stack/sticky_tape,
		/obj/item/pamk,
		/obj/item/storage/belt/medipenal
		))

/obj/item/storage/firstaid/medical/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/healthanalyzer = 1,
		/obj/item/stack/medical/gauze/twelve = 1,
		/obj/item/stack/medical/suture = 2,
		/obj/item/stack/medical/mesh = 2,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/surgical_drapes = 1,
		/obj/item/scalpel = 1,
		/obj/item/hemostat = 1,
		/obj/item/cautery = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/firstaid/medical/surg
	name = "укладка хирурга"
	desc = "Компактный набор самых необходимых медицинских инструментов для неотложного хирургического вмешательства в полевых условиях."

/obj/item/storage/firstaid/medical/surg/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/stack/medical/gauze/twelve = 1,
		/obj/item/stack/medical/suture/medicated = 2,
		/obj/item/stack/medical/mesh/advanced = 1,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/surgical_drapes = 1,
		/obj/item/scalpel = 1,
		/obj/item/hemostat = 1,
		/obj/item/retractor = 1,
		/obj/item/circular_saw = 1,
		/obj/item/bonesetter = 1,
		/obj/item/blood_filter = 1,
		/obj/item/cautery = 1,
		/obj/item/healthanalyzer/range = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/firstaid/ancient
	icon_state = "oldfirstaid"
	desc = "Содержит медикаменты для лечения достаточно серьезных ран."

/obj/item/storage/firstaid/ancient/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/stack/medical/gauze = 1,
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment= 3)
	generate_items_inside(items_inside,src)

/obj/item/storage/firstaid/ancient/heirloom
	desc = "Глядя на нее вы с ностальгией вспоминаете старые-добрые времена. И свет был ярче, и снабжение лучше ..."
	empty = TRUE // long since been ransacked by hungry powergaming assistants breaking into med storage

/obj/item/storage/firstaid/fire
	name = "аптечка противоожоговая"
	desc = "Пригодится в тех случаях когда лаборатория взрывотехники <i>-случайно-</i> сгорела."
	icon_state = "ointment"
	inhand_icon_state = "firstaid-ointment"
	damagetype_healed = BURN

/obj/item/storage/firstaid/fire/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins rubbing <b>[src.name]</b> against [user.ru_na()]self! It looks like [user.p_theyre()] trying to start a fire!"))
	return FIRELOSS
/*
/obj/item/storage/firstaid/fire/Initialize(mapload)
	. = ..()
	icon_state = pick("ointment","firefirstaid")
*/
/obj/item/storage/firstaid/fire/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/pill/patch/aiuri = 2,
		/obj/item/reagent_containers/pill/patch/lenturi = 2,
		/obj/item/reagent_containers/spray/hercuri = 1,
		/obj/item/reagent_containers/hypospray/medipen/oxandrolone = 1,
		/obj/item/reagent_containers/hypospray/medipen = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/firstaid/toxin
	name = "аптечка для вывода токсинов"
	desc = "Используется для очищения организма от токсичного и радиоактивного загрязнения, а так же промывки кровотока от химических соединений."
	icon_state = "antitoxin"
	inhand_icon_state = "firstaid-toxin"
	damagetype_healed = TOX

/obj/item/storage/firstaid/toxin/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins licking the lead paint off <b>[src.name]</b>! It looks like [user.p_theyre()] trying to commit suicide!"))
	return TOXLOSS
/*
/obj/item/storage/firstaid/toxin/Initialize(mapload)
	. = ..()
	icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2")
*/
/obj/item/storage/firstaid/toxin/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/storage/pill_bottle/multiver/less = 1,
		/obj/item/reagent_containers/syringe/syriniver = 3,
		/obj/item/storage/pill_bottle/potassiodide = 1,
		/obj/item/reagent_containers/hypospray/medipen/penacid = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/firstaid/o2
	name = "аптечка стабилизационная"
	desc = "Содержит препараты для предотвращения асфиксии и регенерации крови."
	icon_state = "o2"
	inhand_icon_state = "firstaid-o2"
	damagetype_healed = OXY

/obj/item/storage/firstaid/o2/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins hitting [user.ru_ego()] neck with <b>[src.name]</b>! It looks like [user.p_theyre()] trying to commit suicide!"))
	return OXYLOSS
/*
/obj/item/storage/firstaid/o2/Initialize(mapload)
	. = ..()
	icon_state = pick("o2","o2second")
*/
/obj/item/storage/firstaid/o2/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/syringe/convermol = 3,
		/obj/item/reagent_containers/hypospray/medipen/salbutamol = 1,
		/obj/item/reagent_containers/hypospray/medipen/blood_loss = 2,
		/obj/item/storage/pill_bottle/iron = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/firstaid/brute
	name = "аптечка травматологическая"
	desc = "Содержит медикаменты для излечения резаных, колотых ран и травм вызванных ударами тупым предметом различной степени тяжести."
	icon_state = "brute"
	inhand_icon_state = "firstaid-brute"
	damagetype_healed = BRUTE

/obj/item/storage/firstaid/brute/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins beating [user.ru_na()]self over the head with <b>[src.name]</b>! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS
/*
/obj/item/storage/firstaid/brute/Initialize(mapload)
	. = ..()
	icon_state = pick("brute","brute2")
*/
/obj/item/storage/firstaid/brute/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/pill/patch/libital = 3,
		/obj/item/stack/medical/gauze = 1,
		/obj/item/storage/pill_bottle/probital = 1,
		/obj/item/reagent_containers/hypospray/medipen/salacid = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/firstaid/advanced
	name = "универсальная аптечка"
	desc = "Продвинутая аптечка первой помощи, содержащая препараты для лечения большинства повреждений."
	icon_state = "firstaid_advanced"
	inhand_icon_state = "firstaid-rad"
	custom_premium_price = PAYCHECK_HARD * 6
	damagetype_healed = "all"

/obj/item/storage/firstaid/advanced/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/pill/patch/synthflesh = 3,
		/obj/item/reagent_containers/hypospray/medipen/atropine = 2,
		/obj/item/stack/medical/gauze = 1,
		/obj/item/storage/pill_bottle/penacid = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/firstaid/tactical
	name = "боевая аптечка"
	desc = "Набор снаряжения и медикаментов первой помощи для полевых агентов."
	icon_state = "bezerk"
	damagetype_healed = "all"

/obj/item/storage/firstaid/tactical/Initialize()
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL

/obj/item/storage/firstaid/tactical/PopulateContents()
	if(empty)
		return
	new /obj/item/stack/medical/gauze(src)
	new /obj/item/defibrillator/compact/combat/loaded(src)
	new /obj/item/reagent_containers/hypospray/combat(src)
	new /obj/item/reagent_containers/pill/patch/libital(src)
	new /obj/item/reagent_containers/pill/patch/libital(src)
	new /obj/item/reagent_containers/pill/patch/lenturi(src)
	new /obj/item/reagent_containers/pill/patch/lenturi(src)
	new /obj/item/clothing/glasses/hud/health/night(src)

//medibot assembly
/obj/item/storage/firstaid/attackby(obj/item/bodypart/S, mob/user, params)
	if((!istype(S, /obj/item/bodypart/l_arm/robot)) && (!istype(S, /obj/item/bodypart/r_arm/robot)))
		return ..()

	//Making a medibot!
	if(contents.len >= 1)
		to_chat(user, span_warning("Перед сборкой сначала необходимо опорожнить [src]!"))
		return

	var/obj/item/bot_assembly/medbot/A = new
	if (istype(src, /obj/item/storage/firstaid))
		A.set_skin("brute")
	if (istype(src, /obj/item/storage/firstaid/fire))
		A.set_skin("ointment")
	else if (istype(src, /obj/item/storage/firstaid/toxin))
		A.set_skin("tox")
	else if (istype(src, /obj/item/storage/firstaid/o2))
		A.set_skin("o2")
	else if (istype(src, /obj/item/storage/firstaid/brute))
		A.set_skin("brute")
	else if (istype(src, /obj/item/storage/firstaid/regular))
		A.set_skin("brute")
	else if (istype(src, /obj/item/storage/firstaid/advanced))
		A.set_skin("advanced")
	else if (istype(src, /obj/item/storage/firstaid/tactical))
		A.set_skin("advanced")
	user.put_in_hands(A)
	to_chat(user, span_notice("You add [S] to [src]."))
	A.robot_arm = S.type
	A.firstaid = type
	qdel(S)
	qdel(src)

/*
 * Pill Bottles
 */

/obj/item/storage/pill_bottle
	name = "баночка для таблеток"
	desc = "Хранит в себе разноцветные пилюльки и таблетки."
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "pill_bottle"
	inhand_icon_state = "contsolid"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/pill_bottle/Initialize()
	. = ..()
	atom_storage.allow_quick_gather = TRUE
	atom_storage.numerical_stacking = TRUE
	atom_storage.screen_max_columns = 8
	atom_storage.max_slots = 10
	atom_storage.max_total_storage = 20
	atom_storage.set_holdable(list(/obj/item/reagent_containers/pill))

/obj/item/storage/pill_bottle/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] пытается get the cap off [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (TOXLOSS)

/obj/item/storage/pill_bottle/multiver
	name = "баночка с таблетками мультивера"
	desc = "Выводит из крови химические вещества и нейтрализует токсины. Эффективность растет по мере того, как увеличвается количество нейтрализуемых вещество. Вызывает средние повреждения легких."
	icon_state = "pill_bottle_multiver"

/obj/item/storage/pill_bottle/multiver/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/pill/multiver(src)

/obj/item/storage/pill_bottle/multiver/less

/obj/item/storage/pill_bottle/multiver/less/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/multiver(src)

/obj/item/storage/pill_bottle/epinephrine
	name = "баночка с таблетками адреналина"
	desc = "Стабилизирует пациентов находящихся в критическом состоянии, нейтрализует удушье и мобилизует организм к восстановлению при тяжелых повреждениях. Очень незначительно повышает скорость и стойкость к оглушению. Передозировка вызывает слабость и повреждение токсинами."

/obj/item/storage/pill_bottle/epinephrine/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/pill/epinephrine(src)

/obj/item/storage/pill_bottle/mutadone
	name = "баночка с таблетками мутадона"
	desc = "Устраняет генетические мутации и стабилизирует структуру ДНК."
	icon_state = "pill_bottle_mutadone"

/obj/item/storage/pill_bottle/mutadone/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/pill/mutadone(src)

/obj/item/storage/pill_bottle/potassiodide
	name = "баночка с таблетками йодида калия"
	desc = "Нейтрализует воздействие радиации на организм."
	icon_state = "pill_bottle_potassiodide"

/obj/item/storage/pill_bottle/potassiodide/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/potassiodide(src)

/obj/item/storage/pill_bottle/probital
	name = "баночка с таблетками пробитала"
	desc = "Используется для лечения физических повреждений средней степени тяжести. Рекомендуется принимать с едой. Может вызывать утомление. Разбавлен гранибиталури."
	icon_state = "pill_bottle_probital"

/obj/item/storage/pill_bottle/probital/PopulateContents()
	for(var/i in 1 to 8)
		new /obj/item/reagent_containers/pill/probital(src)

/obj/item/storage/pill_bottle/iron
	name = "баночка с таблетками крововосстанавливающего"
	desc = "Содержит железо для стимуляции восстановления уровня крови в организме."
	icon_state = "pill_bottle_iron"

/obj/item/storage/pill_bottle/iron/PopulateContents()
	for(var/i in 1 to 8)
		new /obj/item/reagent_containers/pill/hematogen(src)

/obj/item/storage/pill_bottle/mannitol
	name = "баночка с таблетками маннитола"
	desc = "Витаминный комплекс для правильной работы мозга. Помогает справится с головными болями и исправления легких повреждений мозга."
	icon_state = "pill_bottle_mannitol"

/obj/item/storage/pill_bottle/mannitol/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/pill/mannitol(src)

//Contains 4 pills instead of 7, and 5u pills instead of 50u (50u pills heal 250 brain damage, 5u pills heal 25)
/obj/item/storage/pill_bottle/mannitol/braintumor
	desc = "Используется для лечения симптомов при опухолях головного мозга. Тут весьма низкая дозировка и надолго этих таблеток не хватит."

/obj/item/storage/pill_bottle/mannitol/braintumor/PopulateContents()
	for(var/i in 1 to 8)
		new /obj/item/reagent_containers/pill/mannitol/braintumor(src)

/obj/item/storage/pill_bottle/stimulant
	name = "баночка с таблетками стимулятора"
	desc = "Часто принимается перегруженными работой трудоголиками, спортсменами и алкоголиками. Мало чем поможет, однако внимание к себе вы точно привлечете!"

/obj/item/storage/pill_bottle/stimulant/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/pill/stimulant(src)

/obj/item/storage/pill_bottle/mining
	name = "баночка с пластырями"
	desc = "Содержит в себе лекарства для лечения ран и ожогов."

/obj/item/storage/pill_bottle/mining/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/patch/lenturi(src)
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/patch/libital(src)

/obj/item/storage/pill_bottle/zoom
	name = "подозрительная баночка с таблетками"
	desc = "Этикетка довольно старая и почти нечитаемая, но вам знакомы некоторые химические соединения которые вы совершенно точно не принимали в молодости."

/obj/item/storage/pill_bottle/zoom/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/pill/zoom(src)

/obj/item/storage/pill_bottle/happy
	name = "подозрительная баночка с таблетками"
	desc = "На крышечке нарисован забавный смайлик."

/obj/item/storage/pill_bottle/happy/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/pill/happy(src)

/obj/item/storage/pill_bottle/lsd
	name = "подозрительная баночка с таблетками"
	desc = "Тут есть нарисованный от руки рисунок, изображающий толи гриб, толи танцующую луну."

/obj/item/storage/pill_bottle/lsd/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/pill/lsd(src)

/obj/item/storage/pill_bottle/aranesp
	name = "подозрительная баночка с таблетками"
	desc = "На этикетке черным маркером наспех нацарапано \"СБ пидоры\"."

/obj/item/storage/pill_bottle/aranesp/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/pill/aranesp(src)

/obj/item/storage/pill_bottle/psicodine
	name = "баночка с таблетками псикодина"
	desc = "Содержит таблетки которые восстанавливают ясность сознания, подавляют фобии и панические атаки."
	icon_state = "pill_bottle_psicodine"

/obj/item/storage/pill_bottle/psicodine/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/pill/psicodine(src)

/obj/item/storage/pill_bottle/penacid
	name = "баночка с таблетками пентетовой кислоты"
	desc = "ДТПА, она же диэтилентриаминпентауксусная кислота. Вещество выводящее из тела токсины, радиацию и химикаты."
	icon_state = "pill_bottle_penacid"

/obj/item/storage/pill_bottle/penacid/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/penacid(src)


/obj/item/storage/pill_bottle/neurine
	name = "баночка с таблетками нейрина"
	desc = "Помогает при лечении легких церебральных травм."
	icon_state = "pill_bottle_mannitol"

/obj/item/storage/pill_bottle/neurine/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/pill/neurine(src)

/obj/item/storage/pill_bottle/maintenance_pill
	name = "баночка с подозрительным таблетками"
	desc = "Странная таблетка без маркировки, найденная в весьма сомнительном месте."

/obj/item/storage/pill_bottle/maintenance_pill/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/pill/P = locate() in src
	name = "баночка с [P.name]s"

/obj/item/storage/pill_bottle/maintenance_pill/PopulateContents()
	for(var/i in 1 to rand(1,7))
		new /obj/item/reagent_containers/pill/maintenance(src)

/obj/item/storage/pill_bottle/maintenance_pill/full/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/pill/maintenance(src)

///////////////////////////////////////// Psychologist inventory pillbottles
/obj/item/storage/pill_bottle/happinesspsych
	name = "баночка с таблетками стабилизатора настроения"
	desc = "Используется для временного облегчения тревоги и депрессии, принимать только по назначению врача. ВНИМАНИЕ! Может вызывать: дрожь, заикание и зависимость."

/obj/item/storage/pill_bottle/happinesspsych/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/happinesspsych(src)

/obj/item/storage/pill_bottle/lsdpsych
	name = "баночка с таблетками галюциногена"
	desc = "При ухудшении галлюцинаций или появлении новых галлюцинаций немедленно обратитесь к своему лечащему врачу. ВНИМАНИЕ! Применение разрешено строго под надзором лечащего врача."

/obj/item/storage/pill_bottle/lsdpsych/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/lsdpsych(src)

/obj/item/storage/pill_bottle/paxpsych
	name = "баночка с таблетками седативов"
	desc = "Используется для временного подавления агрессивного, гомицидального или суицидального поведения у пациентов."

/obj/item/storage/pill_bottle/paxpsych/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/paxpsych(src)

/obj/item/storage/organbox
	name = "контейнер для транспортировки органов"
	desc = "Усовершенствованный транспортный ящик с охлаждающим механизмом, который использует криостилан или другие холодные реагенты для сохранения органов или частей тела внутри.."
	icon_state = "organbox"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 7
	custom_premium_price = PAYCHECK_MEDIUM * 4
	/// var to prevent it freezing the same things over and over
	var/cooling = FALSE

/obj/item/storage/organbox/Initialize()
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY /// you have to remove it from your bag before opening it but I think that's fine
	atom_storage.max_total_storage = 21
	atom_storage.set_holdable(list(
		/obj/item/organ,
		/obj/item/bodypart,
		/obj/item/food/icecream
		))

/obj/item/storage/organbox/Initialize(mapload)
	. = ..()
	create_reagents(100, TRANSPARENT)
	RegisterSignal(src, COMSIG_ATOM_ENTERED, PROC_REF(freeze))
	RegisterSignal(src, COMSIG_ATOM_EXITED, PROC_REF(unfreeze))
	START_PROCESSING(SSobj, src)

/obj/item/storage/organbox/process(delta_time)
	///if there is enough coolant var
	var/cool = FALSE
	var/amount = min(reagents.get_reagent_amount(/datum/reagent/cryostylane), 0.05 * delta_time)
	if(amount > 0)
		reagents.remove_reagent(/datum/reagent/cryostylane, amount)
		cool = TRUE
	else
		amount = min(reagents.get_reagent_amount(/datum/reagent/consumable/ice), 0.1 * delta_time)
		if(amount > 0)
			reagents.remove_reagent(/datum/reagent/consumable/ice, amount)
			cool = TRUE
	if(!cooling && cool)
		cooling = TRUE
		update_icon()
		for(var/C in contents)
			freeze(C)
		return
	if(cooling && !cool)
		cooling = FALSE
		update_icon()
		for(var/C in contents)
			unfreeze(C)

/obj/item/storage/organbox/update_icon()
	. = ..()
	if(cooling)
		icon_state = "organbox-working"
	else
		icon_state = "organbox"

///freezes the organ and loops bodyparts like heads
/obj/item/storage/organbox/proc/freeze(datum/source, obj/item/I)
	if(isorgan(I))
		var/obj/item/organ/organ = I
		organ.organ_flags |= ORGAN_FROZEN
		return
	if(istype(I, /obj/item/bodypart))
		var/obj/item/bodypart/B = I
		for(var/O in B.contents)
			if(isorgan(O))
				var/obj/item/organ/organ = O
				organ.organ_flags |= ORGAN_FROZEN

///unfreezes the organ and loops bodyparts like heads
/obj/item/storage/organbox/proc/unfreeze(datum/source, obj/item/I)
	if(isorgan(I))
		var/obj/item/organ/organ = I
		organ.organ_flags  &= ~ORGAN_FROZEN
		return
	if(istype(I, /obj/item/bodypart))
		var/obj/item/bodypart/B = I
		for(var/O in B.contents)
			if(isorgan(O))
				var/obj/item/organ/organ = O
				organ.organ_flags  &= ~ORGAN_FROZEN

/obj/item/storage/organbox/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers) && I.is_open_container())
		var/obj/item/reagent_containers/RC = I
		var/units = RC.reagents.trans_to(src, RC.amount_per_transfer_from_this, transfered_by = user)
		if(units)
			to_chat(user, span_notice("You transfer [units] units of the solution to [src]."))
			return
	if(istype(I, /obj/item/plunger))
		to_chat(user, span_notice("You start furiously plunging [name]."))
		if(do_after(user, 10, target = src))
			to_chat(user, span_notice("You finish plunging the [name]."))
			reagents.clear_reagents()
		return
	return ..()

/obj/item/storage/organbox/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] is putting [user.p_theyre()] head inside the [src], it looks like [user.p_theyre()] trying to commit suicide!"))
	user.adjust_bodytemperature(-300)
	user.apply_status_effect(/datum/status_effect/freon)
	return (OXYLOSS)
