/obj/item/reagent_containers/pill
	name = "таблетка"
	desc = "Простая таблетка или пилюля."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pill"
	inhand_icon_state = "pill"
	worn_icon_state = "pen"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	possible_transfer_amounts = list()
	volume = 50
	grind_results = list()
	var/apply_type = INGEST
	var/apply_method = "проглотить"
	var/rename_with_volume = FALSE
	var/self_delay = 0 //pills are instant, this is because patches inheret their aplication from pills
	var/dissolvable = TRUE

/obj/item/reagent_containers/pill/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "pill[rand(1,20)]"
	if(reagents.total_volume && rename_with_volume)
		name += " ([reagents.total_volume]u)"


/obj/item/reagent_containers/pill/attack_self(mob/user)
	return


/obj/item/reagent_containers/pill/attack(mob/M, mob/user, def_zone)
	if(!canconsume(M, user))
		return FALSE

	if(M == user)
		M.visible_message(span_notice("[user] пытается [apply_method] [src]."))
		if(self_delay)
			if(!do_mob(user, M, self_delay))
				return FALSE
		to_chat(M, span_notice("Пытаюсь [apply_method] [src]."))

	else
		M.visible_message(span_danger("[user] пытается принудить [M] [apply_method] [src].") , \
							span_userdanger("[user] пытается принудить меня [apply_method] [src]."))
		if(!do_mob(user, M, CHEM_INTERACT_DELAY(3 SECONDS, user)))
			return FALSE
		M.visible_message(span_danger("[user] принуждает [M] [apply_method] [src].") , \
							span_userdanger("[user] принуждает меня [apply_method] [src]."))

	return on_consumption(M, user)

///Runs the consumption code, can be overriden for special effects
/obj/item/reagent_containers/pill/proc/on_consumption(mob/M, mob/user)
	if(icon_state == "pill4" && prob(5)) //you take the red pill - you stay in Wonderland, and I show you how deep the rabbit hole goes
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, M, span_notice("[pick(strings(REDPILL_FILE, "redpill_questions"))]")), 50)

	if(reagents.total_volume)
		reagents.trans_to(M, reagents.total_volume, transfered_by = user, methods = apply_type)
	qdel(src)
	return TRUE


/obj/item/reagent_containers/pill/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(!dissolvable || !target.is_refillable())
		return
	if(target.is_drainable() && !target.reagents.total_volume)
		to_chat(user, span_warning("[target] пустой! В чём я буду растворять [src]?"))
		return

	if(target.reagents.holder_full())
		to_chat(user, span_warning("[target] полон."))
		return

	user.visible_message(span_warning("[user] закидывает что-то в [target]!") , span_notice("Растворяю [src] в [target].") , null, 2)
	reagents.trans_to(target, reagents.total_volume, transfered_by = user)
	qdel(src)

/*
 * On accidental consumption, consume the pill
 */
/obj/item/reagent_containers/pill/on_accidental_consumption(mob/living/carbon/victim, mob/living/carbon/user, obj/item/source_item, discover_after = FALSE)
	to_chat(victim, span_warning("Проглатываю что-то маленькое. [source_item ? "Это было в [source_item]?" : ""]"))
	reagents?.trans_to(victim, reagents.total_volume, transfered_by = user, methods = INGEST)
	qdel(src)
	return discover_after

/obj/item/reagent_containers/pill/tox
	name = "таблетка с токсинами"
	desc = "Высокотоксичная."
	icon_state = "pill5"
	list_reagents = list(/datum/reagent/toxin = 50)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/cyanide
	name = "таблетка цианида"
	desc = "Не глотайте её."
	icon_state = "pill5"
	list_reagents = list(/datum/reagent/toxin/cyanide = 50)

/obj/item/reagent_containers/pill/adminordrazine
	name = "таблетка админодразина"
	desc = "Это волшебство. Мы не должны объяснять это."
	icon_state = "pill16"
	list_reagents = list(/datum/reagent/medicine/adminordrazine = 50)

/obj/item/reagent_containers/pill/morphine
	name = "таблетка морфина"
	desc = "Обычно используется для лечения бессонницы."
	icon_state = "pill8"
	list_reagents = list(/datum/reagent/medicine/morphine = 30)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/stimulant
	name = "таблетка со стимулятором"
	desc = "Часто принимается перегруженными работой сотрудниками, спортсменами и опьяневшими людьми. Вы сразу же привлечете к себе внимание!"
	icon_state = "pill19"
	list_reagents = list(/datum/reagent/medicine/ephedrine = 10, /datum/reagent/medicine/antihol = 10, /datum/reagent/consumable/coffee = 30)

/obj/item/reagent_containers/pill/salbutamol
	name = "таблетка сальбутамола"
	desc = "Используется для лечения кислородного голодания."
	icon_state = "pill16"
	list_reagents = list(/datum/reagent/medicine/salbutamol = 30)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/multiver
	name = "таблетка мультивера"
	desc = "Нейтрализует токсины и масштабирует уникальные лекарства в системе. Разбавляется с гранибиталурием."
	icon_state = "pill17"
	list_reagents = list(/datum/reagent/medicine/c2/multiver = 5, /datum/reagent/medicine/granibitaluri = 5)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/epinephrine
	name = "таблетка эпинефрина"
	desc = "Используется для стабилизации состояния пациентов."
	icon_state = "pill5"
	list_reagents = list(/datum/reagent/medicine/epinephrine = 15)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/mannitol
	name = "таблетка маннитола"
	desc = "Используется для лечения повреждений головного мозга."
	icon_state = "pill17"
	list_reagents = list(/datum/reagent/medicine/mannitol = 50)
	rename_with_volume = TRUE

//Lower quantity mannitol pills (50u pills heal 250 brain damage, 5u pills heal 25)
/obj/item/reagent_containers/pill/mannitol/braintumor
	desc = "Используется для лечения симптомов при опухолях головного мозга."
	list_reagents = list(/datum/reagent/medicine/mannitol = 5)

/obj/item/reagent_containers/pill/mutadone
	name = "таблетка мутадона"
	desc = "Используется для лечения мутаций."
	icon_state = "pill20"
	list_reagents = list(/datum/reagent/medicine/mutadone = 50)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/salicylic
	name = "таблетка салициловой кислоты"
	desc = "Используется для притупления боли."
	icon_state = "pill9"
	list_reagents = list(/datum/reagent/medicine/sal_acid = 24)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/oxandrolone
	name = "таблетка оскандролона"
	desc = "Используется для стимулирования заживления ожогов."
	icon_state = "pill11"
	list_reagents = list(/datum/reagent/medicine/oxandrolone = 24)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/insulin
	name = "таблетка инсулина"
	desc = "Лечит гипергликемическую кому."
	icon_state = "pill18"
	list_reagents = list(/datum/reagent/medicine/insulin = 50)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/psicodine
	name = "таблетка псикодина"
	desc = "Восстанавливает ясность сознания, подавляет фобии и панические атаки."
	list_reagents = list(/datum/reagent/medicine/psicodine = 10)
	icon_state = "pill22"
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/penacid
	name = "таблетка пентитовой кислоты"
	desc = "Используется для выведения радиации и токсинов."
	list_reagents = list(/datum/reagent/medicine/pen_acid = 10)
	icon_state = "pill22"
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/neurine
	name = "таблетка нейрина"
	desc = "Используется для лечения легких психических травм."
	list_reagents = list(/datum/reagent/medicine/neurine = 10)
	icon_state = "pill22"
	rename_with_volume = TRUE

///////////////////////////////////////// this pill is used only in a legion mob drop
/obj/item/reagent_containers/pill/shadowtoxin
	name = "чёрная таблетка"
	desc = "Я бы на вашем месте не ел это."
	icon_state = "pill9"
	color = "#454545"
	list_reagents = list(/datum/reagent/mutationtoxin/shadow = 5)

///////////////////////////////////////// Psychologist inventory pills
/obj/item/reagent_containers/pill/happinesspsych
	name = "таблетка стабилизатора настроения"
	desc = "Используется для временного облегчения тревоги и депрессии, принимать только по назначению врача."
	list_reagents = list(/datum/reagent/drug/happiness = 5)
	icon_state = "pill10"
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/paxpsych
	name = "таблетка пацификации"
	desc = "Используется для временного подавления агрессивного, гомицидального или суицидального поведения у пациентов."
	list_reagents = list(/datum/reagent/pax = 5)
	icon_state = "pill12"
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/lsdpsych
	name = "антипсихотическая таблетка"
	desc = "При ухудшении галлюцинаций или появлении новых галлюцинаций немедленно обратитесь к своему лечащему врачу."
	list_reagents = list(/datum/reagent/toxin/mindbreaker = 5)
	icon_state = "pill14"
	rename_with_volume = TRUE

//////////////////////////////////////// drugs
/obj/item/reagent_containers/pill/zoom
	name = "жёлтая таблетка"
	desc = "Плохо изготовленная таблетка канареечно-желтого цвета; она слегка крошится."
	list_reagents = list(/datum/reagent/medicine/synaptizine = 10, /datum/reagent/drug/nicotine = 10, /datum/reagent/drug/methamphetamine = 1)
	icon_state = "pill7"


/obj/item/reagent_containers/pill/happy
	name = "счастливая таблетка"
	desc = "На них маленькие счастливые лица, и они пахнут фломастерами."
	list_reagents = list(/datum/reagent/consumable/sugar = 10, /datum/reagent/drug/space_drugs = 10)
	icon_state = "pill_happy"


/obj/item/reagent_containers/pill/lsd
	name = "солнечная таблетка"
	desc = "На этой пилюле с раздвоенным цветом выгравировано полусолнце, полулуние."
	list_reagents = list(/datum/reagent/drug/mushroomhallucinogen = 15, /datum/reagent/toxin/mindbreaker = 15)
	icon_state = "pill14"


/obj/item/reagent_containers/pill/aranesp
	name = "мягкая таблетка"
	desc = "Эта голубая таблетка на ощупь слегка влажная."
	list_reagents = list(/datum/reagent/drug/aranesp = 10)
	icon_state = "pill3"

///Black and white pills that spawn in maintenance and have random reagent contents
/obj/item/reagent_containers/pill/maintenance
	name = "техническая таблетка"
	desc = "Странная таблетка, найденная в глубинах технических тоннелей."
	icon_state = "pill21"
	var/static/list/names = list("техническая таблетка", "таблетка с пола", "загадочная таблетка", "подозрительная таблетка", "странная таблетка", "таблетка везения", "зловещая таблетка", "жуткая таблетка")
	var/static/list/descs = list("Ваше чувство говорит вам \"нет\", но....","Наркотики стоят дорого, вы не можете позволить себе не есть таблетки, которые найдете."\
	, "Конечно, ничего не может пойти не так.", "Победители не употребляет нарк- о, что за черт!", "Бесплатные таблетки? Бесплатно, ведь мне нечего терять!")

/obj/item/reagent_containers/pill/maintenance/Initialize()
	list_reagents = list(get_random_reagent_id() = rand(10,50)) //list_reagents is called before init, because init generates the reagents using list_reagents
	. = ..()
	name = pick(names)
	if(prob(30))
		desc = pick(descs)

/obj/item/reagent_containers/pill/maintenance/on_consumption(mob/M, mob/user)
	. = ..()

	M.client?.give_award(/datum/award/score/maintenance_pill, M)

/obj/item/reagent_containers/pill/potassiodide
	name = "таблетка йодистого калия"
	desc = "Используется для снижения ущерба от радиоационного излучения."
	icon_state = "pill11"
	list_reagents = list(/datum/reagent/medicine/potass_iodide = 15)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/probital
	name = "таблетка пробитала"
	desc = "Используется для лечения физических повреждений различной тяжести. На резьбе в таблетке написано \"Поесть перед употреблением\". Вызывает усталость и разбавляется гранибиталурием."
	icon_state = "pill12"
	list_reagents = list(/datum/reagent/medicine/c2/probital = 5, /datum/reagent/medicine/granibitaluri = 10)
	rename_with_volume = TRUE

/obj/item/reagent_containers/pill/iron
	name = "таблетка с железом"
	desc = "Используется для снижения кровопотери."
	icon_state = "pill8"
	list_reagents = list(/datum/reagent/iron = 15)
	rename_with_volume = TRUE
