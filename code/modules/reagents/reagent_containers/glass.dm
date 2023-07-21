
/obj/item/reagent_containers/glass
	name = "стакан"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50)
	volume = 50
	reagent_flags = OPENCONTAINER | DUNKABLE
	spillable = TRUE
	resistance_flags = ACID_PROOF


/obj/item/reagent_containers/glass/attack(mob/living/M, mob/user, obj/target)
	if(!canconsume(M, user))
		return

	if(!spillable)
		return

	if(!reagents || !reagents.total_volume)
		to_chat(user, span_warning("[capitalize(src.name)] пуст!"))
		return

	if(istype(M))
		if(user.a_intent == INTENT_HARM)
			var/R
			M.visible_message(span_danger("[user] разливает содержимое [src] на [M]!") , \
							span_userdanger("[user] разливает содержимое [src] на меня!"))
			if(reagents)
				for(var/datum/reagent/A in reagents.reagent_list)
					R += "[A] ([num2text(A.volume)]),"

			if(isturf(target) && reagents.reagent_list.len && thrownby)
				log_combat(thrownby, target, "splashed (thrown) [english_list(reagents.reagent_list)]")
				message_admins("[ADMIN_LOOKUPFLW(thrownby)] splashed (thrown) [english_list(reagents.reagent_list)] on [target] at [ADMIN_VERBOSEJMP(target)].")
			reagents.expose(M, TOUCH)
			log_combat(user, M, "splashed", R)
			reagents.clear_reagents()
		else
			if(M != user)
				if(M.hydration >= HYDRATION_LEVEL_OVERHYDRATED)
					M.visible_message(span_danger("[user] не может больше напоить [M] содержимым [src.name]."), \
					span_userdanger("[user] больше не может напоить меня содержимым [src.name]."))
					return
				M.visible_message(span_danger("[user] пытается напоить [M] из [src].") , \
							span_userdanger("[user] пытается напоить меня из [src]."))
				if(!do_mob(user, M))
					return
				if(!reagents || !reagents.total_volume)
					return // The drink might be empty after the delay, such as by spam-feeding
				M.visible_message(span_danger("[user] поит [M] чем-то из [src].") , \
							span_userdanger("[user] поит меня чем-то из [src]."))
				log_combat(user, M, "fed", reagents.log_list())
			else
				if(user.hydration >= HYDRATION_LEVEL_OVERHYDRATED)
					to_chat(M, span_warning("В меня больше не лезет содержимое [src.name]!"))
					return
				to_chat(user, span_notice("Делаю глоток из [src]."))

			for(var/datum/reagent/R in reagents.reagent_list)
				if(R.type in M.known_reagent_sounds)
					continue
				LAZYADD(M.known_reagent_sounds, R.type)
				SEND_SOUND(M, R.special_sound)
				break

			SEND_SIGNAL(src, COMSIG_GLASS_DRANK, M, user)
			addtimer(CALLBACK(reagents, TYPE_PROC_REF(/datum/reagents, trans_to), M, 5, TRUE, TRUE, FALSE, user, FALSE, INGEST), 5)
			playsound(M.loc,'sound/items/drink.ogg', rand(10,50), TRUE)
			if(iscarbon(M))
				var/mob/living/carbon/carbon_drinker = M
				var/list/diseases = carbon_drinker.get_static_viruses()
				if(LAZYLEN(diseases))
					var/list/datum/disease/diseases_to_add = list()
					for(var/d in diseases)
						var/datum/disease/malady = d
						if(malady.spread_flags & DISEASE_SPREAD_CONTACT_FLUIDS)
							diseases_to_add += malady
					if(LAZYLEN(diseases_to_add))
						AddComponent(/datum/component/infective, diseases_to_add)

/obj/item/reagent_containers/glass/afterattack(obj/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if((!proximity_flag) || !check_allowed_items(target, target_self = TRUE))
		return

	if(!spillable)
		return

	if(target.is_refillable()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, span_warning("[capitalize(src.name)] пуст!"))
			return

		if(target.reagents.holder_full())
			to_chat(user, span_warning("[target] полон."))
			return

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("Переливаю [trans] единиц в [target]."))

		playsound(get_turf(user), pick(WATER_FLOW_MINI), 50, TRUE)

	else if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target] пуст и не может быть заполнен!"))
			return

		if(reagents.holder_full())
			to_chat(user, span_warning("[capitalize(src.name)] полон."))
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("Наполняю [src] [trans] единицами из [target]."))

		playsound(get_turf(user), pick(WATER_FLOW_MINI), 50, TRUE)

	else if(reagents.total_volume)
		if(user.a_intent == INTENT_HARM)
			user.visible_message(span_danger("[user] разливает содержимое [src] на [target]!") , \
								span_notice("Разливаю содержмое [src] на [target]."))
			reagents.expose(target, TOUCH)
			reagents.clear_reagents()

/obj/item/reagent_containers/glass/attackby(obj/item/I, mob/user, params)
	var/hotness = I.get_temperature()
	if(hotness && reagents)
		reagents.expose_temperature(hotness)
		to_chat(user, span_notice("Грею [name] используя [I]!"))

	//Cooling method
	if(istype(I, /obj/item/extinguisher))
		var/obj/item/extinguisher/extinguisher = I
		if(extinguisher.safety)
			return
		if (extinguisher.reagents.total_volume < 1)
			to_chat(user, span_warning("[capitalize(extinguisher)] пуст!"))
			return
		var/cooling = (0 - reagents.chem_temp) * extinguisher.cooling_power * 2
		reagents.expose_temperature(cooling)
		to_chat(user, span_notice("Охлаждаю [name] используя [I]!"))
		playsound(loc, 'sound/effects/extinguish.ogg', 75, TRUE, -3)
		extinguisher.reagents.remove_all(1)

	if(istype(I, /obj/item/food/egg)) //breaking eggs
		var/obj/item/food/egg/E = I
		if(reagents)
			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, span_notice("[capitalize(src.name)] полон."))
			else
				to_chat(user, span_notice("Раздавливаю [E] в [src]."))
				E.reagents.trans_to(src, E.reagents.total_volume, transfered_by = user)
				qdel(E)
			return
	..()

/*
 * On accidental consumption, make sure the container is partially glass, and continue to the reagent_container proc
 */
/obj/item/reagent_containers/glass/on_accidental_consumption(mob/living/carbon/M, mob/living/carbon/user, obj/item/source_item, discover_after = TRUE)
	if(!custom_materials)
		set_custom_materials(list(GET_MATERIAL_REF(/datum/material/glass) = 5))//sets it to glass so, later on, it gets picked up by the glass catch (hope it doesn't 'break' things lol)
	return ..()

/obj/item/reagent_containers/glass/beaker
	name = "химический стакан"
	desc = "Химический стакан, вместимостью до 50 единиц."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	inhand_icon_state = "beaker"
	worn_icon_state = "beaker"
	custom_materials = list(/datum/material/glass=500)
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/glass/beaker/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/reagent_containers/glass/beaker/get_part_rating()
	return reagents.maximum_volume

/obj/item/reagent_containers/glass/beaker/jar
	name = "банка мёда"
	desc = "Банка для мёда. Она может вместить до 50 единиц сахарного наслаждения."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "vapour"

/obj/item/reagent_containers/glass/beaker/large
	name = "большой химический стакан"
	desc = "Большой химический стакан, вместимостью до 100 единиц."
	icon_state = "beakerlarge"
	custom_materials = list(/datum/material/glass=2500)
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100)
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/glass/beaker/plastic
	name = "огромный химический стакан"
	desc = "Огромный химический стакан, вместимостью до 120 единиц."
	icon_state = "beakerwhite"
	custom_materials = list(/datum/material/glass=2500, /datum/material/plastic=3000)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,60,120)
	fill_icon_thresholds = list(0, 1, 10, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/glass/beaker/meta
	name = "метаматериальный химический стакан"
	desc = "Громадный химический стакан, вместимостью до 180 единиц."
	icon_state = "beakergold"
	custom_materials = list(/datum/material/glass=2500, /datum/material/plastic=3000, /datum/material/gold=1000, /datum/material/titanium=1000)
	volume = 180
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,60,120,180)
	fill_icon_thresholds = list(0, 1, 10, 25, 35, 50, 60, 80, 100)

/obj/item/reagent_containers/glass/beaker/noreact
	name = "криостатический химический стакан"
	desc = "Химический стакан криостазиса, позволяющий хранить химикаты не начиная реакцию. Вместимость до 50 единиц."
	icon_state = "beakernoreact"
	custom_materials = list(/datum/material/iron=3000)
	reagent_flags = OPENCONTAINER | NO_REACT
	volume = 50
	amount_per_transfer_from_this = 10

/obj/item/reagent_containers/glass/beaker/bluespace
	name = "блюспейс химический стакан"
	desc = "химический стакан разработанный с использованием экспериментальной блюспейс технологии, вмещает до 300 единиц."
	icon_state = "beakerbluespace"
	custom_materials = list(/datum/material/glass = 5000, /datum/material/plasma = 3000, /datum/material/diamond = 1000, /datum/material/bluespace = 1000)
	volume = 300
	material_flags = MATERIAL_NO_EFFECTS
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100,300)

/obj/item/reagent_containers/glass/beaker/cryoxadone
	list_reagents = list(/datum/reagent/medicine/cryoxadone = 30)

/obj/item/reagent_containers/glass/beaker/sulphuric
	list_reagents = list(/datum/reagent/toxin/acid = 50)

/obj/item/reagent_containers/glass/beaker/slime
	list_reagents = list(/datum/reagent/toxin/slimejelly = 50)

/obj/item/reagent_containers/glass/beaker/large/libital
	name = "libital reserve tank (diluted)"
	list_reagents = list(/datum/reagent/medicine/c2/libital = 10,/datum/reagent/medicine/granibitaluri = 40)

/obj/item/reagent_containers/glass/beaker/large/aiuri
	name = "aiuri reserve tank (diluted)"
	list_reagents = list(/datum/reagent/medicine/c2/aiuri = 10, /datum/reagent/medicine/granibitaluri = 40)

/obj/item/reagent_containers/glass/beaker/large/multiver
	name = "multiver reserve tank (diluted)"
	list_reagents = list(/datum/reagent/medicine/c2/multiver = 10, /datum/reagent/medicine/granibitaluri = 40)

/obj/item/reagent_containers/glass/beaker/large/epinephrine
	name = "epinephrine reserve tank (diluted)"
	list_reagents = list(/datum/reagent/medicine/epinephrine = 50)

/obj/item/reagent_containers/glass/beaker/synthflesh
	list_reagents = list(/datum/reagent/medicine/c2/synthflesh = 50)

/obj/item/reagent_containers/glass/chem_canister
	name = "химическая канистра"
	desc = "Большая емкость вмещающая в себя до 300 единиц жидкости."
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "chem_canister"
	lefthand_file = 'icons/mob/inhands/equipment/tanks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tanks_righthand.dmi'
	inhand_icon_state = "an_tank"
	custom_materials = list(/datum/material/glass = 2000, /datum/material/iron=2000)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100,150,300)
	volume = 300

/obj/item/reagent_containers/glass/chem_canister/virus_food
	name = "Пища для вирусов"
	desc = "Смесь из молока и воды. Позволяет вирусам размножаться и мутировать."
	list_reagents = list(/datum/reagent/consumable/virus_food = 300)

/obj/item/reagent_containers/glass/chem_canister/phenol
	name = "Фенол"
	desc = "Ароматическое кольцо углерода с гидроксильной группой. Входит в состав множества лекарств, но сам по себе не обладает целебными свойствами."
	list_reagents = list(/datum/reagent/phenol = 300)

/obj/item/reagent_containers/glass/chem_canister/oil
	name = "Масло"
	desc = "Сгорает в небольшом дымном костре, может быть использован для получения пепла."
	list_reagents = list(/datum/reagent/fuel/oil = 300)

/obj/item/reagent_containers/glass/chem_canister/acetone
	name = "Ацетон"
	desc = "Скользкая, слегка канцерогенная жидкость. Имеет множество повседневных применений в повседневной жизни."
	list_reagents = list(/datum/reagent/acetone = 300)

/obj/item/reagent_containers/glass/chem_canister/ammonia
	name = "Аммиак"
	desc = "Едкое вещество, обычно используемое в удобрениях или бытовых чистящих средствах."
	list_reagents = list(/datum/reagent/ammonia = 300)

/obj/item/reagent_containers/glass/chem_canister/fluorosurfactant
	name = "Фторовая Пена"
	desc = "Перфторированная сульфокислота, которая образует пену при смешивании с водой."
	list_reagents = list(/datum/reagent/fluorosurfactant = 300)

/obj/item/reagent_containers/glass/chem_canister/diethylamine
	name = "Диэтиламин"
	desc = "Вторичный амин, слабо вызывающий коррозию."
	list_reagents = list(/datum/reagent/diethylamine = 300)

/obj/item/reagent_containers/glass/chem_canister/basic_buffer
	name = "Щелочный буфер"
	desc = "При добавлении к составу сместит ПШ баланс в сторону щелочности."
	list_reagents = list(/datum/reagent/reaction_agent/basic_buffer = 300)

/obj/item/reagent_containers/glass/chem_canister/acidic_buffer
	name = "Кислотный буфер"
	desc = "При добавлении к составу сместит ПШ баланс в сторону кислотности."
	list_reagents = list(/datum/reagent/reaction_agent/acidic_buffer = 300)

/obj/item/reagent_containers/glass/bucket
	name = "ведро"
	desc = "Просто ведро."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	inhand_icon_state = "bucket"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	custom_materials = list(/datum/material/iron=200)
	w_class = WEIGHT_CLASS_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100)
	volume = 100
	flags_inv = HIDEHAIR
	slot_flags = ITEM_SLOT_HEAD
	resistance_flags = NONE
	armor = list(MELEE = 10, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 75, ACID = 50) //Weak melee protection, because you can wear it on your head
	slot_equipment_priority = list( \
		ITEM_SLOT_BACK, ITEM_SLOT_ID,\
		ITEM_SLOT_ICLOTHING, ITEM_SLOT_OCLOTHING,\
		ITEM_SLOT_MASK, ITEM_SLOT_HEAD, ITEM_SLOT_NECK,\
		ITEM_SLOT_FEET, ITEM_SLOT_GLOVES,\
		ITEM_SLOT_EARS, ITEM_SLOT_EYES,\
		ITEM_SLOT_BELT, ITEM_SLOT_SUITSTORE,\
		ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET,\
		ITEM_SLOT_DEX_STORAGE
	)

/obj/item/reagent_containers/glass/bucket/wooden
	name = "деревянное ведро"
	icon_state = "woodbucket"
	inhand_icon_state = "woodbucket"
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 2)
	armor = list(MELEE = 10, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 50)
	resistance_flags = FLAMMABLE

#define SQUEEZING_DISPERSAL_PERCENT 0.75

/obj/item/reagent_containers/glass/bucket/attackby(obj/O, mob/living/user, params)
	if(istype(O, /obj/item/mop))
		if(user.a_intent == INTENT_HARM)
			if(O.reagents.total_volume == 0)
				to_chat(user, span_warning("[capitalize(O.name)] сухая!"))
				return
			if(reagents.total_volume == reagents.maximum_volume)
				to_chat(user, span_warning("[capitalize(src.name)] переполнено!"))
				return
			O.reagents.remove_any(O.reagents.total_volume*SQUEEZING_DISPERSAL_PERCENT)
			O.reagents.trans_to(src, O.reagents.total_volume, transfered_by = user)
			to_chat(user, span_notice("Выживаю [O.name] в [src.name]."))
		else
			if(reagents.total_volume < 1)
				to_chat(user, span_warning("[capitalize(src.name)] пустое!"))
			else
				reagents.trans_to(O, 5, transfered_by = user)
				to_chat(user, span_notice("Окунаю [O.name] в [src.name]."))
				playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
	else if(isprox(O)) //This works with wooden buckets for now. Somewhat unintended, but maybe someone will add sprites for it soon(TM)
		to_chat(user, span_notice("Добавил [O.name] в [src.name]."))
		qdel(O)
		qdel(src)
		user.put_in_hands(new /obj/item/bot_assembly/cleanbot)
	else
		..()

#undef SQUEEZING_DISPERSAL_PERCENT

/obj/item/reagent_containers/glass/bucket/equipped(mob/user, slot)
	..()
	if (slot == ITEM_SLOT_HEAD)
		if(reagents.total_volume)
			to_chat(user, span_userdanger("Содержимое [capitalize(src.name)] разлилось на меня!"))
			reagents.expose(user, TOUCH)
			reagents.clear_reagents()
		reagents.flags = NONE

/obj/item/reagent_containers/glass/bucket/dropped(mob/user)
	. = ..()
	reagents.flags = initial(reagent_flags)

/obj/item/reagent_containers/glass/bucket/equip_to_best_slot(mob/M)
	if(reagents.total_volume) //If there is water in a bucket, don't quick equip it to the head
		var/index = slot_equipment_priority.Find(ITEM_SLOT_HEAD)
		slot_equipment_priority.Remove(ITEM_SLOT_HEAD)
		. = ..()
		slot_equipment_priority.Insert(index, ITEM_SLOT_HEAD)
		return
	return ..()

/obj/item/pestle
	name = "пестик"
	desc = "Древний простой инструмент, используемый со ступкой для измельчения, или давки предметов."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pestle"
	force = 7

/obj/item/reagent_containers/glass/mortar
	name = "ступка"
	desc = "A specially formed bowl of ancient design. It is possible to crush or juice items placed in it using a pestle; however the process, unlike modern methods, is slow and physically exhausting. Alt click to eject the item."
	icon_state = "mortar"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50, 100)
	volume = 100
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT)
	reagent_flags = OPENCONTAINER
	spillable = TRUE
	var/obj/item/grinded

/obj/item/reagent_containers/glass/mortar/AltClick(mob/user)
	if(grinded)
		grinded.forceMove(drop_location())
		grinded = null
		to_chat(user, span_notice("You eject the item inside."))

/obj/item/reagent_containers/glass/mortar/attackby(obj/item/I, mob/living/carbon/human/user)
	..()
	if(istype(I,/obj/item/pestle))
		if(grinded)
			if(user.getStaminaLoss() > 50)
				to_chat(user, span_warning("You are too tired to work!"))
				return
			to_chat(user, span_notice("You start grinding..."))
			if((do_after(user, 25, target = src)) && grinded)
				user.adjustStaminaLoss(40)
				if(grinded.juice_results) //prioritize juicing
					grinded.on_juice()
					reagents.add_reagent_list(grinded.juice_results)
					to_chat(user, span_notice("You juice [grinded] into a fine liquid."))
					QDEL_NULL(grinded)
					return
				grinded.on_grind()
				reagents.add_reagent_list(grinded.grind_results)
				if(grinded.reagents) //food and pills
					grinded.reagents.trans_to(src, grinded.reagents.total_volume, transfered_by = user)
				to_chat(user, span_notice("You break [grinded] into powder."))
				QDEL_NULL(grinded)
				return
			return
		else
			to_chat(user, span_warning("There is nothing to grind!"))
			return
	if(grinded)
		to_chat(user, span_warning("There is something inside already!"))
		return
	if(I.juice_results || I.grind_results)
		I.forceMove(src)
		grinded = I
		return
	to_chat(user, span_warning("You can't grind this!"))

/obj/item/reagent_containers/glass/saline
	name = "saline canister"
	volume = 5000
	list_reagents = list(/datum/reagent/medicine/salglu_solution = 5000)

//Coffeepots: for reference, a standard cup is 30u, to allow 20u for sugar/sweetener/milk/creamer
/obj/item/reagent_containers/glass/coffeepot
	name = "кофейник"
	desc = "Большой кофейник для раздачи амброзии офисной жизни, известной смертным как кофе. Хватит на 4 стандартные чашки."
	volume = 120
	icon_state = "coffeepot"
	fill_icon_state = "coffeepot"
	fill_icon_thresholds = list(0, 1, 40, 80, 120)

/obj/item/reagent_containers/glass/coffeepot/bluespace
	name = "блюспейс кофейник"
	desc = "Самый передовой кофейник, который могли придумать ученые: современный дизайн; градуированные линии; отдельное измерение для хранения кофе; да, вот такой он. Хватит на 8 стандартных чашек."
	volume = 240
	icon_state = "coffeepot_bluespace"
	fill_icon_thresholds = list(0)
