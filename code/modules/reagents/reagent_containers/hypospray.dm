/obj/item/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	inhand_icon_state = "hypo"
	worn_icon_state = "hypo"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	icon_state = "hypo"
	worn_icon_state = "hypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = list()
	resistance_flags = ACID_PROOF
	reagent_flags = OPENCONTAINER
	slot_flags = ITEM_SLOT_BELT
	var/ignore_flags = NONE
	var/infinite = FALSE

/obj/item/reagent_containers/hypospray/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/reagent_containers/hypospray/attack(mob/living/M, mob/user)
	inject(M, user)

///Handles all injection checks, injection and logging.
/obj/item/reagent_containers/hypospray/proc/inject(mob/living/M, mob/user)
	if(!reagents.total_volume)
		to_chat(user, span_warning("[capitalize(src.name)] is empty!"))
		return FALSE
	if(!iscarbon(M))
		return FALSE

	//Always log attemped injects for admins
	var/list/injected = list()
	for(var/datum/reagent/R in reagents.reagent_list)
		injected += R.name
	var/contained = english_list(injected)
	log_combat(user, M, "пытается вколоть", src, "([contained])")

	if(reagents.total_volume && (ignore_flags || M.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))) // Ignore flag should be checked first or there will be an error message.
		to_chat(M, span_warning("Что-то укололо меня!"))
		to_chat(user, span_notice("Вкалываю [src] [skloname(M.name, DATELNI, M.gender)]."))
		var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)


		if(M.reagents)
			var/trans = 0
			if(!infinite)
				trans = reagents.trans_to(M, amount_per_transfer_from_this, transfered_by = user, methods = INJECT)
			else
				reagents.expose(M, INJECT, fraction)
				trans = reagents.copy_to(M, amount_per_transfer_from_this)
			to_chat(user, span_notice("Введено [trans] единиц химикатов. В [src] осталось [reagents.total_volume] единиц химикатов."))
			log_combat(user, M, "вкалывает", src, "([contained])")
		return TRUE
	return FALSE


/obj/item/reagent_containers/hypospray/cmo
	list_reagents = list(/datum/reagent/medicine/omnizine = 30)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

//combat

/obj/item/reagent_containers/hypospray/combat
	name = "combat stimulant injector"
	desc = "A modified air-needle autoinjector, used by support operatives to quickly heal injuries in combat."
	amount_per_transfer_from_this = 10
	inhand_icon_state = "combat_hypo"
	icon_state = "combat_hypo"
	volume = 90
	ignore_flags = 1 // So they can heal their comrades.
	list_reagents = list(/datum/reagent/medicine/epinephrine = 30, /datum/reagent/medicine/omnizine = 30, /datum/reagent/medicine/leporazine = 15, /datum/reagent/medicine/atropine = 15)

/obj/item/reagent_containers/hypospray/combat/nanites
	name = "experimental combat stimulant injector"
	desc = "A modified air-needle autoinjector for use in combat situations. Prefilled with experimental medical nanites and a stimulant for rapid healing and a combat boost."
	inhand_icon_state = "nanite_hypo"
	icon_state = "nanite_hypo"
	volume = 100
	list_reagents = list(/datum/reagent/medicine/adminordrazine/quantum_heal = 80, /datum/reagent/medicine/synaptizine = 20)

/obj/item/reagent_containers/hypospray/combat/nanites/update_icon_state()
	if(reagents.total_volume > 0)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/reagent_containers/hypospray/combat/heresypurge
	name = "holy water piercing injector"
	desc = "A modified air-needle autoinjector for use in combat situations. Prefilled with 5 doses of a holy water and pacifier mixture. Not for use on your teammates."
	inhand_icon_state = "holy_hypo"
	icon_state = "holy_hypo"
	volume = 250
	list_reagents = list(/datum/reagent/water/holywater = 150, /datum/reagent/peaceborg/tire = 50, /datum/reagent/peaceborg/confuse = 50)
	amount_per_transfer_from_this = 50

//MediPens

/obj/item/reagent_containers/hypospray/medipen
	name = "медипен с адреналином"
	desc = "Быстро и эффективно стабилизирует пациента находящегося в критическом состоянии. Спроектирован специально для персонала не обладающего медицинскими навыками, ввод осуществляется непосредственно в мягкие ткани. Содержит мощный бальзамический коагулянт, останавливающий кровотечения и останавливающий разложение у мертвых тел."
	icon_state = "medipen"
	inhand_icon_state = "medipen"
	worn_icon_state = "medipen"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	amount_per_transfer_from_this = 15
	volume = 15
	ignore_flags = 1 //so you can medipen through hardsuits
	reagent_flags = DRAWABLE
	flags_1 = null
	list_reagents = list(/datum/reagent/medicine/epinephrine = 10, /datum/reagent/toxin/formaldehyde = 3, /datum/reagent/medicine/coagulant = 2)
	custom_price = PAYCHECK_MEDIUM
	custom_premium_price = PAYCHECK_HARD
	var/empty_start = FALSE

/obj/item/reagent_containers/hypospray/medipen/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to choke on <b>[src.name]</b>! It looks like [user.p_theyre()] trying to commit suicide!"))
	return OXYLOSS//ironic. he could save others from oxyloss, but not himself.

/obj/item/reagent_containers/hypospray/medipen/inject(mob/living/M, mob/user)
	. = ..()
	if(.)
		reagents.maximum_volume = 0 //Makes them useless afterwards
		reagents.flags = NONE
		update_icon()

/obj/item/reagent_containers/hypospray/medipen/attack_self(mob/user)
	if(user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK, FALSE, FLOOR_OKAY))
		inject(user, user)

/obj/item/reagent_containers/hypospray/medipen/update_icon_state()
	if(reagents.total_volume > 0)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/reagent_containers/hypospray/medipen/examine()
	. = ..()
	if(reagents?.reagent_list.len)
		. += "<hr><span class='notice'>Медипен заряжен.</span>"
	else
		. += "<hr><span class='notice'>Медипен уже использован.</span>"

/obj/item/reagent_containers/hypospray/medipen/stimpack //goliath kiting
	name = "stimpack medipen"
	desc = "A rapid way to stimulate your body's adrenaline, allowing for freer movement in restrictive armor."
	icon_state = "stimpen"
	inhand_icon_state = "stimpen"
	volume = 20
	amount_per_transfer_from_this = 20
	list_reagents = list(/datum/reagent/medicine/ephedrine = 10, /datum/reagent/consumable/coffee = 10)

/obj/item/reagent_containers/hypospray/medipen/stimpack/traitor
	desc = "A modified stimulants autoinjector for use in combat situations. Has a mild healing effect."
	list_reagents = list(/datum/reagent/medicine/stimulants = 10, /datum/reagent/medicine/omnizine = 10)

/obj/item/reagent_containers/hypospray/medipen/stimulants
	name = "stimulant medipen"
	desc = "Contains a very large amount of an incredibly powerful stimulant, vastly increasing your movement speed and reducing stuns by a very large amount for around five minutes. Do not take if pregnant."
	icon_state = "syndipen"
	inhand_icon_state = "tbpen"
	volume = 50
	amount_per_transfer_from_this = 50
	list_reagents = list(/datum/reagent/medicine/stimulants = 50)

/obj/item/reagent_containers/hypospray/medipen/morphine
	name = "медипен с морфием"
	desc = "Поможет быстро успокоить буйного пациента."
	icon_state = "morphen"
	inhand_icon_state = "morphen"
	list_reagents = list(/datum/reagent/medicine/morphine = 10)

/obj/item/reagent_containers/hypospray/medipen/oxandrolone
	name = "медипен с оксандролоном"
	desc = "Содержит лекарство, помогающее при тяжелых ожогах, однако менее эффективно при слабых поражениях тканей."
	icon_state = "oxapen"
	inhand_icon_state = "oxapen"
	list_reagents = list(/datum/reagent/medicine/oxandrolone = 10)

/obj/item/reagent_containers/hypospray/medipen/penacid
	name = "медипен с пентетовой кислотой"
	desc = "ДТПА, она же диэтилентриаминпентауксусная кислота. Вещество выводящее из тела токсины, радиацию и химикаты."
	icon_state = "penacid"
	inhand_icon_state = "penacid"
	list_reagents = list(/datum/reagent/medicine/pen_acid = 10)

/obj/item/reagent_containers/hypospray/medipen/salacid
	name = "медипен с салициловой кислотой"
	desc = "Содержит лекарство, помогающее при тяжелых физических ранах, однако менее эффективно при слабых поражениях тканей."
	icon_state = "salacid"
	inhand_icon_state = "salacid"
	list_reagents = list(/datum/reagent/medicine/sal_acid = 10)

/obj/item/reagent_containers/hypospray/medipen/salbutamol
	name = "медипен с сальбутомолом"
	desc = "Содержит лекарство, что быстро нивелирует удушье у пациента."
	icon_state = "salpen"
	inhand_icon_state = "salpen"
	list_reagents = list(/datum/reagent/medicine/salbutamol = 10)

/obj/item/reagent_containers/hypospray/medipen/tuberculosiscure
	name = "BVAK autoinjector"
	desc = "Bio Virus Antidote Kit autoinjector. Has a two use system for yourself, and someone else. Inject when infected."
	icon_state = "tbpen"
	inhand_icon_state = "tbpen"
	volume = 20
	amount_per_transfer_from_this = 10
	list_reagents = list(/datum/reagent/vaccine/fungal_tb = 20)

/obj/item/reagent_containers/hypospray/medipen/tuberculosiscure/update_icon_state()
	if(reagents.total_volume >= volume)
		icon_state = initial(icon_state)
	else if (reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/reagent_containers/hypospray/medipen/survival
	name = "Чрезвычайный медипен"
	desc = "Содержит обширный комплекс лекарственных веществ для быстрого восстановления на поле боя. Изначально разрабатывался для военно-космических сил и в связи с технологическими особенностями быстрый ввод препаратов возможен только при пониженом давлении. В противном случае будет введена только половинная доза."
	icon_state = "stimpen"
	inhand_icon_state = "stimpen"
	volume = 30
	amount_per_transfer_from_this = 30
	list_reagents = list( /datum/reagent/medicine/epinephrine = 8, /datum/reagent/medicine/c2/aiuri = 8, /datum/reagent/medicine/c2/libital = 8 ,/datum/reagent/medicine/leporazine = 6)

/obj/item/reagent_containers/hypospray/medipen/survival/inject(mob/living/M, mob/user)
	if(lavaland_equipment_pressure_check(get_turf(user)))
		amount_per_transfer_from_this = initial(amount_per_transfer_from_this)
		return ..()

	if(DOING_INTERACTION(user, DOAFTER_SOURCE_SURVIVALPEN))
		to_chat(user,span_notice("Я слишком занят для того чтобы использовать <b>[src.name]</b>!"))
		return

	to_chat(user,span_notice("Начинаю с силой продавливать поршень клапана, но он сопротивляется при таком высоком давлении... нужно... давить... сильнее..."))
	if(!do_mob(user, M, 10 SECONDS, interaction_key = DOAFTER_SOURCE_SURVIVALPEN))
		return

	amount_per_transfer_from_this = initial(amount_per_transfer_from_this) * 0.5
	return ..()


/obj/item/reagent_containers/hypospray/medipen/survival/luxury
	name = "элитный медипен"
	desc = "Благодаря технологии блюспейса вмещает до 60 единиц лекарственных веществ. ВНИМАНИЕ! Не применять одновременно с атропином или адреналином!"
	icon_state = "luxpen"
	inhand_icon_state = "atropen"
	volume = 60
	amount_per_transfer_from_this = 60
	list_reagents = list(/datum/reagent/medicine/salbutamol = 10, /datum/reagent/medicine/c2/penthrite = 10, /datum/reagent/medicine/oxandrolone = 10, /datum/reagent/medicine/sal_acid = 10 ,/datum/reagent/medicine/omnizine = 10 ,/datum/reagent/medicine/leporazine = 10)

/obj/item/reagent_containers/hypospray/medipen/atropine
	name = "медипен с атропином"
	desc = "Быстро стабилизирует пациента, находящегося в критическом состоянии!"
	icon_state = "atropen"
	inhand_icon_state = "atropen"
	list_reagents = list(/datum/reagent/medicine/atropine = 10)

/obj/item/reagent_containers/hypospray/medipen/snail
	name = "snail shot"
	desc = "All-purpose snail medicine! Do not use on non-snails!"
	icon_state = "snail"
	inhand_icon_state = "snail"
	list_reagents = list(/datum/reagent/snail = 10)

/obj/item/reagent_containers/hypospray/medipen/magillitis
	name = "experimental autoinjector"
	desc = "A custom-frame needle injector with a small single-use reservoir, containing an experimental serum. Unlike the more common medipen frame, it cannot pierce through protective armor or hardsuits, nor can the chemical inside be extracted."
	icon_state = "gorillapen"
	inhand_icon_state = "gorillapen"
	volume = 5
	ignore_flags = 0
	reagent_flags = NONE
	list_reagents = list(/datum/reagent/magillitis = 5)

/obj/item/reagent_containers/hypospray/medipen/pumpup
	name = "самопальный адреналин"
	desc = "Кустарный автоинъектор, наполненный дешевым адреналином... Отлично подходит для снятия последствий от удара электрошоковой дубинкой."
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/drug/pumpup = 15)
	icon_state = "maintenance"

/obj/item/reagent_containers/hypospray/medipen/ekit
	name = "аварийный медипен"
	desc = "По составу схож с классическим адреналиновым медипеном, однако содержит больше останавливающего кровь коагулянта и антибиотиков, но не содержит консервант препятствующий разложению."
	icon_state = "firstaid"
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/medicine/epinephrine = 12, /datum/reagent/medicine/coagulant = 2.5, /datum/reagent/medicine/spaceacillin = 0.5)

/obj/item/reagent_containers/hypospray/medipen/blood_loss
	name = "крововосстанавливающий медипен"
	desc = "По составу схож с классическим адреналиновым медипеном, однако часть адреналина заменена на большее количество останавливающего кровь коагулянта и веществ стимулярующих выработку крови, но не содержит консервант препятствующий разложению."
	icon_state = "hypovolemic"
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/medicine/epinephrine = 5, /datum/reagent/medicine/coagulant = 2.5, /datum/reagent/iron = 3.5, /datum/reagent/medicine/salglu_solution = 4)
