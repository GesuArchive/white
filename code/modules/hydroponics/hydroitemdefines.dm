
// Plant analyzer
/obj/item/plant_analyzer
	name = "Анализатор растений"
	desc = "Сканер, используемый для изучения содержимого растений, его состояния и генов. Присутствует режим сканирования роста растения и химического содержимого."
	icon = 'icons/obj/device.dmi'
	icon_state = "hydro"
	inhand_icon_state = "analyzer"
	worn_icon_state = "plantanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=20)
	var/scan_mode = PLANT_SCANMODE_STATS

/obj/item/plant_analyzer/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/plant_analyzer/add_item_context(
	obj/item/source,
	list/context,
	atom/target,
)

	if(isitem(target))
		// Easier to handle this here, as grown items are split across two type-paths
		var/obj/item/item_target = target
		if(!item_target.get_plant_seed())
			return NONE

		context[SCREENTIP_CONTEXT_LMB] = "Сканировать состояние"
		context[SCREENTIP_CONTEXT_RMB] = "Сканировать химикаты"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/plant_analyzer/examine()
	. = ..()
	. += "<hr><span class='notice'>Активируй [src] в руке, чтобы сменить режим между анализом роста и анализом реагентов.</span>"

/obj/item/plant_analyzer/attack_self(mob/user)
	. = ..()
	scan_mode = !scan_mode
	to_chat(user, span_notice("Меняю режим [src] в [scan_mode == PLANT_SCANMODE_CHEMICALS ? "сканирование реагентов и признаков растения" : "сканирования статистики и анализа роста"]."))

/obj/item/plant_analyzer/attack(mob/living/M, mob/living/carbon/human/user)
	//Checks if target is a podman
	if(ispodperson(M))
		user.visible_message(span_notice("[user] анализирует показатели [M].") , \
							span_notice("Анализирую показатели [M]."))
		if(scan_mode == PLANT_SCANMODE_STATS)
			healthscan(user, M, advanced = TRUE)
		else
			chemscan(user, M)
		add_fingerprint(user)
		return
	return ..()

/**
 * This proc is called when we scan a hydroponics tray or soil.
 * It formats the plant name, it's age, the plant's stats, and the tray's stats.
 *
 * - scanned_tray - the tray or soil we are scanning.
 *
 * Returns the formatted message as text.
 */
/obj/item/plant_analyzer/proc/scan_tray(obj/machinery/hydroponics/scanned_tray)
	var/returned_message = "<span class='info'>*---------*\n"
	if(scanned_tray.myseed)
		returned_message += "*** <B>[scanned_tray.myseed.plantname]</B> ***\n"
		returned_message += "- Возраст растения: <span class='notice'>[scanned_tray.age]</span></span>\n"
		returned_message += scan_plant(scanned_tray.myseed)
	else
		returned_message += "<span class='info'><B>Растение не найдено.</B></span>\n"

	returned_message += "<span class='info'>- Уровень сорняков: <span class='notice'>[scanned_tray.weedlevel] / [MAX_TRAY_WEEDS]</span>\n"
	returned_message += "- Уровень паразитов: <span class='notice'>[scanned_tray.pestlevel] / [MAX_TRAY_PESTS]</span>\n"
	returned_message += "- Уровень токсинов: <span class='notice'>[scanned_tray.toxic] / [MAX_TRAY_TOXINS]</span>\n"
	returned_message += "- Уровень воды: <span class='notice'>[scanned_tray.waterlevel] / [scanned_tray.maxwater]</span>\n"
	returned_message += "- Уровень питания: <span class='notice'>[scanned_tray.reagents.total_volume] / [scanned_tray.maxnutri]</span>\n"
	if(scanned_tray.yieldmod != 1)
		returned_message += "- Модификатор урожайности при сборе: <span class='notice'>[scanned_tray.yieldmod]x</span>\n"
	returned_message += "*---------*</span>"

	return returned_message

/**
 * This proc is called when a seed or any grown plant is scanned.
 * It formats the plant name as well as either its traits or its chemical contents.
 *
 * - scanned_object - the source objecte for what we are scanning. This can be a grown food, a grown inedible, or a seed.
 *
 * Returns the formatted output as text.
 */
/obj/item/plant_analyzer/proc/scan_plant(obj/item/scanned_object)
	var/returned_message = "<span class='info'>*---------*\nЭто \a <span class='name'>[scanned_object]</span>.\n"
	var/obj/item/seeds/our_seed = scanned_object
	if(!istype(our_seed)) //if we weren't passed a seed, we were passed a plant with a seed
		var/obj/item/grown/scanned_plant = scanned_object
		our_seed = scanned_plant.seed

	switch(scan_mode)
		if(PLANT_SCANMODE_STATS)
			if(our_seed && istype(our_seed))
				returned_message += get_analyzer_text_traits(our_seed)
			else
				returned_message += "*---------*\nNo genes found.\n*---------*"
		if(PLANT_SCANMODE_CHEMICALS)
			if(scanned_object.reagents) //we have reagents contents
				returned_message += get_analyzer_text_chem_contents(scanned_object)
			else if (our_seed.reagents_add?.len) //we have a seed with reagent genes
				returned_message += get_analyzer_text_chem_genes(our_seed)
			else
				returned_message += "*---------*\nNo reagents found.\n*---------*"

	returned_message += "</span>\n"
	return returned_message

/**
 * This proc is formats the traits and stats of a seed into a message.
 *
 * - scanned - the source seed for what we are scanning for traits.
 *
 * Returns the formatted output as text.
 */
/obj/item/plant_analyzer/proc/get_analyzer_text_traits(obj/item/seeds/scanned)
	var/text = ""
	if(scanned.get_gene(/datum/plant_gene/trait/plant_type/weed_hardy))
		text += "- Вид растения: <span class='notice'>Сорняк. Может вырасти в грядке с плохим питанием.</span>\n"
	else if(scanned.get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
		text += "- Вид растения: <span class='notice'>Гриб. Может вырасти в сухой грядке.</span>\n"
	else if(scanned.get_gene(/datum/plant_gene/trait/plant_type/alien_properties))
		text += "- Вид растения: <span class='warning'>НЕИЗВЕСТНЫЙ</span> \n"
	else
		text += "- Вид растения: <span class='notice'>Обычное растение</span>\n"

	if(scanned.potency != -1)
		text += "- Потенция: <span class='notice'>[scanned.potency]</span>\n"
	if(scanned.yield != -1)
		text += "- Урожайность: <span class='notice'>[scanned.yield]</span>\n"
	text += "- Скорость созревания: <span class='notice'>[scanned.maturation]</span>\n"
	if(scanned.yield != -1)
		text += "- Скорость производства: <span class='notice'>[scanned.production]</span>\n"
	text += "- Стойкость: <span class='notice'>[scanned.endurance]</span>\n"
	text += "- Продолжительность жизни: <span class='notice'>[scanned.lifespan]</span>\n"
	text += "- Нестабильность: <span class='notice'>[scanned.instability]</span>\n"
	text += "- Скорость роста сорняков: <span class='notice'>[scanned.weed_rate]</span>\n"
	text += "- Уязвимость сорняков: <span class='notice'>[scanned.weed_chance]</span>\n"
	if(scanned.rarity)
		text += "- Ценность открытия видов: <span class='notice'>[scanned.rarity]</span>\n"
	var/all_traits = ""
	for(var/datum/plant_gene/trait/traits in scanned.genes)
		if(istype(traits, /datum/plant_gene/trait/plant_type))
			continue
		all_traits += "[(all_traits == "") ? "" : ", "][traits.get_name()]"
	text += "- Особенности растений: <span class='notice'>[all_traits? all_traits : "None."]</span>\n"
	var/datum/plant_gene/scanned_graft_result = scanned.graft_gene? new scanned.graft_gene : new /datum/plant_gene/trait/repeated_harvest
	text += "- Прививка этого растения даст: <span class='notice'>[scanned_graft_result.get_name()]</span>\n"
	QDEL_NULL(scanned_graft_result) //graft genes are stored as typepaths so if we want to get their formatted name we need a datum ref - musn't forget to clean up afterwards
	text += "*---------*"
	var/unique_text = scanned.get_unique_analyzer_text()
	if(unique_text)
		text += "\n"
		text += unique_text
		text += "\n*---------*"
	return text

/**
 * This proc is formats the chemical GENES of a seed into a message.
 *
 * - scanned - the source seed for what we are scanning for chemical genes.
 *
 * Returns the formatted output as text.
 */
/obj/item/plant_analyzer/proc/get_analyzer_text_chem_genes(obj/item/seeds/scanned)
	var/text = ""
	text += "- Plant Reagent Genes -\n"
	text += "*---------*\n<span class='notice'>"
	for(var/datum/plant_gene/reagent/gene in scanned.genes)
		text += "- [gene.get_name()] -\n"
	text += "</span>*---------*"
	return text

/**
 * This proc is formats the chemical CONTENTS of a plant into a message.
 *
 * - scanned_plant - the source plant we are reading out its reagents contents.
 *
 * Returns the formatted output as text.
 */
/obj/item/plant_analyzer/proc/get_analyzer_text_chem_contents(obj/item/scanned_plant)
	var/text = ""
	var/reagents_text = ""
	text += "<br><span class='info'>- Реагенты Растения -</span>"
	text += "<br><span class='info'>Максимальное количество реагентов: [scanned_plant.reagents.maximum_volume]</span>"
	var/chem_cap = 0
	for(var/_reagent in scanned_plant.reagents.reagent_list)
		var/datum/reagent/reagent  = _reagent
		var/amount = reagent.volume
		chem_cap += reagent.volume
		reagents_text += span_info("\n- [reagent.name]: [amount]")
	if(chem_cap > 100)
		text += "<br><span class='warning'>- Производство реагентов 100%</span></br>"

	if(reagents_text)
		text += "<br><span class='info'>*---------*</span>"
		text += reagents_text
	text += "<br><span class='info'>*---------*</span>"
	return text

/**
 * This proc is formats the scan of a graft of a seed into a message.
 *
 * - scanned_graft - the graft for what we are scanning.
 *
 * Returns the formatted output as text.
 */
/obj/item/plant_analyzer/proc/get_graft_text(obj/item/graft/scanned_graft)
	var/text = "<span class='info'>*---------*</span>\n<span class='info'>- Скрещивание растения -\n"
	if(scanned_graft.parent_name)
		text += "- Материнское растение: <span class='notice'>[scanned_graft.parent_name]</span> -\n"
	if(scanned_graft.stored_trait)
		text += "- Особенности прививки: <span class='notice'>[scanned_graft.stored_trait.get_name()]</span> -\n"
	text += "*---------*\n"
	text += "- Урожайность: <span class='notice'>[scanned_graft.yield]</span>\n"
	text += "- Скорость производства: <span class='notice'>[scanned_graft.production]</span>\n"
	text += "- Стойкость: <span class='notice'>[scanned_graft.endurance]</span>\n"
	text += "- Продолжительность жизни: <span class='notice'>[scanned_graft.lifespan]</span>\n"
	text += "- Скорость роста сорняков: <span class='notice'>[scanned_graft.weed_rate]</span>\n"
	text += "- Уязвимость сорняков: <span class='notice'>[scanned_graft.weed_chance]</span>\n"
	text += "*---------*</span>"
	return text

// *************************************
// Hydroponics Tools
// *************************************

/obj/item/reagent_containers/spray/weedspray
	name = "гербицид против сорняков"
	desc = "Ядовитая смесь, в виде аэрозоля, для уничтожения мелких сорняков."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "weedspray"
	inhand_icon_state = "spraycan"
	worn_icon_state = "spraycan"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	volume = 100
	list_reagents = list(/datum/reagent/toxin/plantbgone/weedkiller = 100)

/obj/item/reagent_containers/spray/weedspray/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] впрыскивает [src]! Кажется, [user.p_theyre()] пытается покончить с собой!"))
	return (TOXLOSS)

/obj/item/reagent_containers/spray/pestspray
	name = "пестицид мягкого действия"
	desc = "Органическая смесь, используемая для убийства насекомых с более мягкими последствиями. Не употреблять внутрь!"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "pestspray"
	inhand_icon_state = "plantbgone"
	worn_icon_state = "spraycan"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	volume = 100
	list_reagents = list(/datum/reagent/toxin/pestkiller = 100)

/obj/item/reagent_containers/spray/pestspray/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] впрыскивает в себя [src]! Кажется, [user.p_theyre()] пытается покончить с собой!"))
	return (TOXLOSS)

/obj/item/cultivator
	name = "тяпка"
	desc = "Используется для удаления сорняков и чесания спины."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "cultivator"
	inhand_icon_state = "cultivator"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=50)
	attack_verb_continuous = list("разрубает", "разрыхляет", "режет", "культивирует")
	attack_verb_simple = list("разрубает", "разрыхляет", "режет", "культивирует")
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'

/obj/item/cultivator/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] чешет [user.ru_ego()] спину насколько сильно может [user.ru_who()] ,используя, <b>[src.name]</b>! Кажется, [user.p_theyre()] пытается покончить с собой!"))
	return (BRUTELOSS)

/obj/item/cultivator/rake
	name = "Грабли"
	icon_state = "rake"
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("донатит", "вайпает", "колотит", "педалирует")
	attack_verb_simple = list("донатит", "вайпает", "колотит", "педалирует")
	hitsound = null
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 1.5)
	flags_1 = NONE
	resistance_flags = FLAMMABLE

/obj/item/cultivator/rake/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/cultivator/rake/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/H = AM
	if(has_gravity(loc) && HAS_TRAIT(H, TRAIT_CLUMSY) && !H.resting)
		H.set_confusion(max(H.get_confusion(), 10))
		H.Stun(20)
		playsound(src, 'sound/weapons/punch4.ogg', 50, TRUE)
		H.visible_message(span_warning("[H] наступает на [src], ударяя рукояткой [H.ru_na()] прямо в лицо!") , \
						  span_userdanger("Наступаю на [src], ударяя рукояткой прямо по моему лицу!"))

/obj/item/hatchet
	name = "Топорик"
	desc = "Очень острый топорик с короткой рукояткой. Имеет долгую историю, сначала он рубил много разных вещей, теперь только деревья."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "hatchet"
	inhand_icon_state = "hatchet"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 12
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 15
	throw_speed = 3
	throw_range = 4
	custom_materials = list(/datum/material/iron = 15000)
	attack_verb_continuous = list("рубит", "кромсает", "режет")
	attack_verb_simple = list("рубит", "кромсает", "режет")
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	sharpness = SHARP_EDGED

/obj/item/hatchet/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 70, 100)

/obj/item/hatchet/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] рубит [user.ru_na()]себя [src]! Кажется, [user.p_theyre()] он хочет покончить с собой!"))
	playsound(src, 'sound/weapons/sword_kill_slash_02.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/hatchet/wooden
	desc = "Грубое лезвие топора на короткой деревянной рукоятке."
	icon_state = "woodhatchet"
	custom_materials = null
	flags_1 = NONE

/obj/item/scythe
	icon_state = "scythe0"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "Коса"
	desc = "Острое, загнутое лезвие на длинной рукоятке, если вы в тёмном пальто, то вы заставите всех вокруг бояться."
	force = 13
	throwforce = 5
	throw_speed = 2
	throw_range = 3
	w_class = WEIGHT_CLASS_BULKY
	flags_1 = CONDUCT_1
	armour_penetration = 20
	slot_flags = ITEM_SLOT_BACK
	attack_verb_continuous = list("рубит", "нарезает", "режет", "разрывает")
	attack_verb_simple = list("рубит", "нарезает", "режет", "разрывает")
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'
	var/swiping = FALSE

/obj/item/scythe/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 90, 105)

/obj/item/scythe/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] обезглавливает [user.ru_na()]себя [src]! Кажется, [user.p_theyre()] хочет покончить с собой!"))
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		var/obj/item/bodypart/BP = C.get_bodypart(BODY_ZONE_HEAD)
		if(BP)
			BP.drop_limb()
			playsound(src, "desecration" ,50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/scythe/pre_attack(atom/A, mob/living/user, params)
	if(swiping || !istype(A, /obj/structure/spacevine) || get_turf(A) == get_turf(user))
		return ..()
	var/turf/user_turf = get_turf(user)
	var/dir_to_target = get_dir(user_turf, get_turf(A))
	swiping = TRUE
	var/static/list/scythe_slash_angles = list(0, 45, 90, -45, -90)
	for(var/i in scythe_slash_angles)
		var/turf/T = get_step(user_turf, turn(dir_to_target, i))
		for(var/obj/structure/spacevine/V in T)
			if(user.Adjacent(V))
				melee_attack_chain(user, V)
	swiping = FALSE
	return TRUE

/obj/item/secateurs
	name = "Секатор"
	desc = "Инструмент, чтобы срезать лоскутки с растений."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "secateurs"
	inhand_icon_state = "secateurs"
	worn_icon_state = "cutters"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 5
	throwforce = 6
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron=4000)
	attack_verb_continuous = list("slashes", "slices", "cuts", "claws")
	attack_verb_simple = list("slash", "slice", "cut", "claw")
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'

/obj/item/geneshears
	name = "Ботаногенетические ножницы"
	desc = "Высокотехнологичные ножницы, которые позволяет вырезать гены из растения"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "genesheers"
	inhand_icon_state = "secateurs"
	worn_icon_state = "cutters"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 10
	throwforce = 8
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	material_flags = MATERIAL_NO_EFFECTS
	custom_materials = list(/datum/material/iron=4000, /datum/material/uranium=1500, /datum/material/gold=500)
	attack_verb_continuous = list("slashes", "slices", "cuts")
	attack_verb_simple = list("slash", "slice", "cut")
	hitsound = 'sound/weapons/sword_kill_slash_01.ogg'


// *************************************
// Nutrient defines for hydroponics
// *************************************


/obj/item/reagent_containers/glass/bottle/nutrient
	name = "Бутылка с удобрением"
	volume = 50
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(1,2,5,10,15,25,50)

/obj/item/reagent_containers/glass/bottle/nutrient/Initialize(mapload)
	. = ..()
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

/obj/item/reagent_containers/glass/bottle/nutrient/empty
	name = "Бутылка"

/obj/item/reagent_containers/glass/bottle/nutrient/ez
	name = "E-Z-Nutrient"
	desc = "Содержит удобрение, которое вызывает немного мутаций и обеспечивает постепенный рост с каждым сбором урожая."
	list_reagents = list(/datum/reagent/plantnutriment/eznutriment = 50)

/obj/item/reagent_containers/glass/bottle/nutrient/l4z
	name = "Left 4 Zed"
	desc = "Содержит удобрение, которое слегка лечит растение, однако, вызывает значительные и долговременные мутации в растении."
	list_reagents = list(/datum/reagent/plantnutriment/left4zednutriment = 50)

/obj/item/reagent_containers/glass/bottle/nutrient/rh
	name = "Надежный Урожай"
	desc = "Содержит удобрение, которое значительно увеличивает скорость роста растения и слегка предотвращает реакции."
	list_reagents = list(/datum/reagent/plantnutriment/robustharvestnutriment = 50)

/obj/item/reagent_containers/glass/bottle/nutrient/eg
	name = "Надежный Урожай"
	desc = "Специализированная подкормка, которая уменьшает количество продукта и их потенциал, но повышает выносливость растений."
	list_reagents = list(/datum/reagent/plantnutriment/endurogrow = 50)

/obj/item/reagent_containers/glass/bottle/nutrient/ler
	name = "Жидкая Встряска"
	desc = "Специализированная подкормка, которая увеличивает скорость роста растения, но также ухудшает его восприимчивость к сорнякам."
	list_reagents = list(/datum/reagent/plantnutriment/liquidearthquake = 50)

/obj/item/reagent_containers/glass/bottle/killer
	volume = 50
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1,2,5)

/obj/item/reagent_containers/glass/bottle/killer/weedkiller
	name = "гербицид против сорняков"
	desc = "Опасный токсин для выведения сорняков. Не употреблять внутрь!"
	list_reagents = list(/datum/reagent/toxin/plantbgone/weedkiller = 50)

/obj/item/reagent_containers/glass/bottle/killer/pestkiller
	name = "пестицид мягкого действия"
	desc = "Органическая смесь, используемая для убийства насекомых с более мягкими последствиями. Не употреблять внутрь!"
	list_reagents = list(/datum/reagent/toxin/pestkiller/organic = 50)
