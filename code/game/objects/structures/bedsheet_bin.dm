/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

#define BEDSHEET_ABSTRACT "abstract"
#define BEDSHEET_SINGLE "single"
#define BEDSHEET_DOUBLE "double"

/obj/item/bedsheet
	name = "простыня"
	desc = "Удивительно мягкая льнаная простыня."
	icon = 'icons/obj/bedsheets.dmi'
	lefthand_file = 'icons/mob/inhands/misc/bedsheet_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/bedsheet_righthand.dmi'
	icon_state = "sheetwhite"
	inhand_icon_state = "sheetwhite"
	slot_flags = ITEM_SLOT_NECK
	layer = 3.81
	plane = GAME_PLANE_FOV_HIDDEN
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	dying_key = DYE_REGISTRY_BEDSHEET

	dog_fashion = /datum/dog_fashion/head/ghost
	var/list/dream_messages = list("white")
	var/stack_amount = 3
	var/bedsheet_type = BEDSHEET_SINGLE

/obj/item/bedsheet/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/surgery_initiator)
	AddElement(/datum/element/bed_tuckable, 0, 0, 0)

/obj/item/bedsheet/attack_self(mob/user)
	if(!user.CanReach(src)) //No telekenetic grabbing.
		return
	if(!user.dropItemToGround(src))
		return
	if(layer == initial(layer))
		layer = ABOVE_MOB_LAYER
		SET_PLANE_IMPLICIT(src, GAME_PLANE_UPPER)
		to_chat(user, span_notice("Накрываю себя [src]."))
		pixel_x = 0
		pixel_y = 0
	else
		layer = initial(layer)
		SET_PLANE_IMPLICIT(src, initial(plane))
		to_chat(user, span_notice("Расстелаю [src] под собой."))
	add_fingerprint(user)
	return

/obj/item/bedsheet/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER || I.get_sharpness())
		if (!(flags_1 & HOLOGRAM_1))
			var/obj/item/stack/sheet/cloth/shreds = new (get_turf(src), stack_amount)
			if(!QDELETED(shreds)) //stacks merged
				transfer_fingerprints_to(shreds)
				shreds.add_fingerprint(user)
		qdel(src)
		to_chat(user, span_notice("You tear [src] up."))
	else
		return ..()

/obj/item/bedsheet/blue
	icon_state = "sheetblue"
	inhand_icon_state = "sheetblue"
	dream_messages = list("синий")

/obj/item/bedsheet/green
	icon_state = "sheetgreen"
	inhand_icon_state = "sheetgreen"
	dream_messages = list("зеленый")

/obj/item/bedsheet/grey
	icon_state = "sheetgrey"
	inhand_icon_state = "sheetgrey"
	dream_messages = list("серый")

/obj/item/bedsheet/orange
	icon_state = "sheetorange"
	inhand_icon_state = "sheetorange"
	dream_messages = list("оранжевый")

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"
	inhand_icon_state = "sheetpurple"
	dream_messages = list("фиолетовый")

/obj/item/bedsheet/patriot
	name = "патриотическая простыня"
	desc = "Спя на ней вы понимаете, что в жизни не ощущали большей свободы."
	icon_state = "sheetUSA"
	inhand_icon_state = "sheetUSA"
	dream_messages = list("Америка", "свобода", "фейерверки", "лысые орлы")

/obj/item/bedsheet/rainbow
	name = "радужная простыня"
	desc = "Разноцветная простыня. На самом деле это просто куча обрезков разных простыней, которые потом были сшиты вместе."
	icon_state = "sheetrainbow"
	inhand_icon_state = "sheetrainbow"
	dream_messages = list("красный", "оранжевый", "желтый", "зеленый", "синий", "пурпурный", "радуга")

/obj/item/bedsheet/red
	icon_state = "sheetred"
	inhand_icon_state = "sheetred"
	dream_messages = list("красный")

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"
	inhand_icon_state = "sheetyellow"
	dream_messages = list("желтый")

/obj/item/bedsheet/mime
	name = "одеяло мима"
	desc = "Успокаивающее полосатое одеяло. Складывается ощущение, что весь шум исчезает, когда ты им накрываешься."
	icon_state = "sheetmime"
	inhand_icon_state = "sheetmime"
	dream_messages = list("тишина", "жесты", "бледное лицо", "разинутый рот", "мим")

/obj/item/bedsheet/clown
	name = "одеяло клоуна"
	desc = "Радужное одеяло с вышитой на нём маской клоуна. Источает слабый запах бананов."
	icon_state = "sheetclown"
	inhand_icon_state = "sheetrainbow"
	dream_messages = list("хонк", "смех", "пранк", "шутка", "улыбающееся лицо", "клоун")

/obj/item/bedsheet/captain
	name = "одеяло капитана"
	desc = "На нем виднеется символ NanoTrasen, само одеяло вышито из инновационной ткани, имеющей гарантированную проницаемость в 0.01% для большинства нехимических веществ, популярных у современных капитанов."
	icon_state = "sheetcaptain"
	inhand_icon_state = "sheetcaptain"
	dream_messages = list("власть", "золотая ID-карта", "солнечные очки", "зеленый диск", "старинный пистолет", "капитан")

/obj/item/bedsheet/rd
	name = "простыня руководителя исследований"
	desc = "Простыня, с вышитой на ней эмблемой химического стакана. Похоже, что простыня сделана из огнестойкого материала, что, вероятно, не защитит вас в случае очередного пожара."
	icon_state = "sheetrd"
	inhand_icon_state = "sheetrd"
	dream_messages = list("власть", "серебряная ID-карта", "бомба", "мех", "лицехват", "маниакальный смех", "руководитель исследований")

// for Free Golems.
/obj/item/bedsheet/rd/royal_cape
	name = "Королевский Плащ Освободителя"
	desc = "Величественный."
	dream_messages = list("добыча ископаемых", "камень", "голем", "свобода", "делать всё что угодно")

/obj/item/bedsheet/medical
	name = "медицинское одеяло"
	desc = "Cтерилизованное* одеяло, обычно используемое в МедОтсеке.  *В случае нахождения на борту станции Вирусолога стерильность обнуляется."
	icon_state = "sheetmedical"
	inhand_icon_state = "sheetmedical"
	dream_messages = list("лечение", "жизнь", "операция", "доктор")

/obj/item/bedsheet/cmo
	name = "одеяло главврача"
	desc = "Стерилизованная простыня с крестом. На ней немного кошачьей шерсти, вероятно, оставленной Рантайм."
	icon_state = "sheetcmo"
	inhand_icon_state = "sheetcmo"
	dream_messages = list("власть", "серебряная ID-карта", "лечение", "жизнь", "операция", "кот", "главный врач")

/obj/item/bedsheet/hos
	name = "простыня главы службы безопасности"
	desc = "Простыня, украшенная эмблемой щита. И пусть преступность никогда не спит, в отличии от меня, но во сне вы всё еще ЗАКОН!"
	icon_state = "sheethos"
	inhand_icon_state = "sheethos"
	dream_messages = list("власть", "серебряная ID-карта", "наручники", "дубинка", "светошумовая", "солнечные очки", "глава службы безопасности")

/obj/item/bedsheet/hop
	name = "простыня главы персонала"
	desc = "Украшена эмблемой ключа. Для редких моментов когда никто не орет на вас по радио и вы можете отдохнуть и пообниматься с Йаном."
	icon_state = "sheethop"
	inhand_icon_state = "sheethop"
	dream_messages = list("власть", "серебряная ID-карта", "обязательства", "компьютер", "ID", "корги", "глава персонала")

/obj/item/bedsheet/ce
	name = "простыня главного инженера"
	desc = "Украшена эмблемой гаечного ключа. Обладает высокой отражающей способностью и устойчивостью к пятнам, так что вам не нужно переживать о том чтобы не заляпать её маслом."
	icon_state = "sheetce"
	inhand_icon_state = "sheetce"
	dream_messages = list("authority", "a silvery ID", "the engine", "power tools", "an APC", "a parrot", "the chief engineer")

/obj/item/bedsheet/qm
	name = "простыня квартирмейстера"
	desc = "Украшена эмблемой ящика на серебряной подкладке. Довольно жесткая, на неё просто можно лечь после тяжелого дня бюрократической возни."
	icon_state = "sheetqm"
	inhand_icon_state = "sheetqm"
	dream_messages = list("серая ID-карта", "шаттл", "ящик", "лень", "квартирмейстер")

/obj/item/bedsheet/chaplain
	name = "простыня капеллана"
	desc = "Простыня, сотканная из сердец самих богов... А, нет, погодите, это просто лён."
	icon_state = "sheetchap"
	inhand_icon_state = "sheetchap"
	dream_messages = list("зеленая ID-карта", "боги", "услышанная молитва", "культ", "капеллан")

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"
	inhand_icon_state = "sheetbrown"
	dream_messages = list("коричневый")

/obj/item/bedsheet/black
	icon_state = "sheetblack"
	inhand_icon_state = "sheetblack"
	dream_messages = list("черный")

/obj/item/bedsheet/centcom
	name = "простыня ЦентКома"
	desc = "Выткана из улучшенной нанонити, сохраняющей тепло, хорошо украшена, что крайне необходимо для всех официальных лиц."
	icon_state = "sheetcentcom"
	inhand_icon_state = "sheetcentcom"
	dream_messages = list("уникальная ID-карта", "власть", "артилерия", "завершение")

/obj/item/bedsheet/syndie
	name = "простыня синдиката"
	desc = "На ней вышита эмблема синдиката, а сама простыня источает ауру зла."
	icon_state = "sheetsyndie"
	inhand_icon_state = "sheetsyndie"
	dream_messages = list("зеленый диск", "красный кристалл", "светящийся меч", "перепаянная ID-карта")

/obj/item/bedsheet/cult
	name = "простыня культиста"
	desc = "Если вы будете спать на ней, то вам может присниться Нар'Си. Простыня выглядит довольно изодранной и светится от зловещего присутствия."
	icon_state = "sheetcult"
	inhand_icon_state = "sheetcult"
	dream_messages = list("том", "парящий красный кристалл", "светящийся меч", "кровавый символ", "большая гуманоидная фигура")

/obj/item/bedsheet/wiz
	name = "простыня волшебника"
	desc = "Особая зачарованная магией ткань, всё ради того чтобы вы могли провести волшебную ночь. Она даже светится!"
	icon_state = "sheetwiz"
	inhand_icon_state = "sheetwiz"
	dream_messages = list("книга", "взрыв", "молния", "посох", "скелет", "роба", "магия")

/obj/item/bedsheet/nanotrasen
	name = "Простыня NanoTrasen"
	desc = "На ней логотип NanoTrasen и она излучает ауру обязанностей."
	icon_state = "sheetNT"
	inhand_icon_state = "sheetNT"
	dream_messages = list("власть", "завершение")

/obj/item/bedsheet/ian
	icon_state = "sheetian"
	inhand_icon_state = "sheetian"
	dream_messages = list("пес", "корги", "вуф", "гаф", "аф")

/obj/item/bedsheet/cosmos
	name = "простыня космического пространства"
	desc = "Соткана из мечт тех, кто грезит о звездах."
	icon_state = "sheetcosmos"
	inhand_icon_state = "sheetcosmos"
	dream_messages = list("бесконечный космос", "Музыка Ханса Цимерра", "космические полеты", "галактика", "невозможное", "падающие звезды")
	light_power = 2
	light_range = 1.4

/obj/item/bedsheet/random
	icon_state = "random_bedsheet"
	name = "random bedsheet"
	desc = "If you're reading this description ingame, something has gone wrong! Honk!"
	bedsheet_type = BEDSHEET_ABSTRACT
	var/static/list/bedsheet_list
	var/spawn_type = BEDSHEET_SINGLE

/obj/item/bedsheet/random/Initialize(mapload)
	..()
	if(!LAZYACCESS(bedsheet_list, spawn_type))
		var/list/spawn_list = list()
		var/list/possible_types = typesof(/obj/item/bedsheet)
		for(var/obj/item/bedsheet/sheet as anything in possible_types)
			if(initial(sheet.bedsheet_type) == spawn_type)
				spawn_list += sheet
		LAZYSET(bedsheet_list, spawn_type, spawn_list)
	var/chosen_type = pick(bedsheet_list[spawn_type])
	new chosen_type(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/bedsheet/random/double
	icon_state = "random_bedsheet"
	spawn_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/dorms
	icon_state = "random_bedsheet"
	name = "random dorms bedsheet"
	desc = "If you're reading this description ingame, something has gone wrong! Honk!"
	bedsheet_type = BEDSHEET_DOUBLE
	slot_flags = null

/obj/item/bedsheet/dorms/Initialize(mapload)
	..()
	var/type = pick_weight(list("Colors" = 80, "Special" = 20))
	switch(type)
		if("Colors")
			type = pick(list(/obj/item/bedsheet,
				/obj/item/bedsheet/blue,
				/obj/item/bedsheet/green,
				/obj/item/bedsheet/grey,
				/obj/item/bedsheet/orange,
				/obj/item/bedsheet/purple,
				/obj/item/bedsheet/red,
				/obj/item/bedsheet/yellow,
				/obj/item/bedsheet/brown,
				/obj/item/bedsheet/black))
		if("Special")
			type = pick(list(/obj/item/bedsheet/patriot,
				/obj/item/bedsheet/rainbow,
				/obj/item/bedsheet/ian,
				/obj/item/bedsheet/cosmos,
				/obj/item/bedsheet/nanotrasen))
	new type(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/bedsheet/double
	icon_state = "double_sheetwhite"
	worn_icon_state = "sheetwhite"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/blue/double
	icon_state = "double_sheetblue"
	worn_icon_state = "sheetblue"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/green/double
	icon_state = "double_sheetgreen"
	worn_icon_state = "sheetgreen"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/grey/double
	icon_state = "double_sheetgrey"
	worn_icon_state = "sheetgrey"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/orange/double
	icon_state = "doublesheet_orange"
	worn_icon_state = "sheetorange"
	dying_key = DYE_REGISTRY_DOUBLE_BEDSHEET
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/purple/double
	icon_state = "double_sheetpurple"
	worn_icon_state = "sheetpurple"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/patriot/double
	icon_state = "double_sheetUSA"
	worn_icon_state = "sheetUSA"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/rainbow/double
	icon_state = "double_sheetrainbow"
	worn_icon_state = "sheetrainbow"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/red/double
	icon_state = "double_sheetred"
	worn_icon_state = "sheetred"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/yellow/double
	icon_state = "double_sheetyellow"
	worn_icon_state = "sheetyellow"
	dying_key = DYE_REGISTRY_DOUBLE_BEDSHEET
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/mime/double
	icon_state = "double_sheetmime"
	worn_icon_state = "sheetmime"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/clown/double
	icon_state = "double_sheetclown"
	worn_icon_state = "sheetclown"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/captain/double
	icon_state = "double_sheetcaptain"
	worn_icon_state = "sheetcaptain"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/rd/double
	icon_state = "double_sheetrd"
	worn_icon_state = "sheetrd"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/medical/double
	icon_state = "double_sheetmedical"
	worn_icon_state = "sheetmedical"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/cmo/double
	icon_state = "double_sheetcmo"
	worn_icon_state = "sheetcmo"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/hos/double
	icon_state = "double_sheethos"
	worn_icon_state = "sheethos"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/hop/double
	icon_state = "double_sheethop"
	worn_icon_state = "sheethop"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/ce/double
	icon_state = "double_sheetce"
	worn_icon_state = "sheetce"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/qm/double
	icon_state = "double_sheetqm"
	worn_icon_state = "sheetqm"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/chaplain/double
	icon_state = "double_sheetchap"
	worn_icon_state = "sheetchap"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/brown/double
	icon_state = "double_sheetbrown"
	worn_icon_state = "sheetbrown"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/black/double
	icon_state = "double_sheetblack"
	worn_icon_state = "sheetblack"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/centcom/double
	icon_state = "double_sheetcentcom"
	worn_icon_state = "sheetcentcom"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/syndie/double
	icon_state = "double_sheetsyndie"
	worn_icon_state = "sheetsyndie"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/cult/double
	icon_state = "double_sheetcult"
	worn_icon_state = "sheetcult"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/wiz/double
	icon_state = "double_sheetwiz"
	worn_icon_state = "sheetwiz"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/nanotrasen/double
	icon_state = "double_sheetNT"
	worn_icon_state = "sheetNT"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/ian/double
	icon_state = "double_sheetian"
	worn_icon_state = "sheetian"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/cosmos/double
	icon_state = "double_sheetcosmos"
	worn_icon_state = "sheetcosmos"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/dorms_double
	icon_state = "random_bedsheet"
	bedsheet_type = BEDSHEET_ABSTRACT

/obj/item/bedsheet/dorms_double/Initialize(mapload)
	..()
	var/type = pick_weight(list("Colors" = 80, "Special" = 20))
	switch(type)
		if("Colors")
			type = pick(list(/obj/item/bedsheet,
				/obj/item/bedsheet/blue/double,
				/obj/item/bedsheet/green/double,
				/obj/item/bedsheet/grey/double,
				/obj/item/bedsheet/orange/double,
				/obj/item/bedsheet/purple/double,
				/obj/item/bedsheet/red/double,
				/obj/item/bedsheet/yellow/double,
				/obj/item/bedsheet/brown/double,
				/obj/item/bedsheet/black/double))
		if("Special")
			type = pick(list(/obj/item/bedsheet/patriot/double,
				/obj/item/bedsheet/rainbow/double,
				/obj/item/bedsheet/ian/double,
				/obj/item/bedsheet/cosmos/double,
				/obj/item/bedsheet/nanotrasen/double))
	new type(loc)
	return INITIALIZE_HINT_QDEL

/obj/structure/bedsheetbin
	name = "корзина для белья"
	desc = "Выглядит уютно."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	anchored = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 70
	var/amount = 10
	var/list/sheets = list()
	var/obj/item/hidden = null

/obj/structure/bedsheetbin/empty
	amount = 0
	icon_state = "linenbin-empty"
	anchored = FALSE


/obj/structure/bedsheetbin/examine(mob/user)
	. = ..()
	if(amount < 1)
		. += "Внутри корзины нет простыней."
	else if(amount == 1)
		. += "Внутри корзины одна простыня."
	else
		. += "Внутри корзины [amount] простыни."


/obj/structure/bedsheetbin/update_icon_state()
	switch(amount)
		if(0)
			icon_state = "linenbin-empty"
		if(1 to 5)
			icon_state = "linenbin-half"
		else
			icon_state = "linenbin-full"
	return ..()

/obj/structure/bedsheetbin/fire_act(exposed_temperature, exposed_volume)
	if(amount)
		amount = 0
		update_appearance()
	..()

/obj/structure/bedsheetbin/screwdriver_act(mob/living/user, obj/item/tool)
	if(flags_1 & NODECONSTRUCT_1)
		return FALSE
	if(amount)
		to_chat(user, span_warning("Сначала [src] нужно освободить!"))
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if(tool.use_tool(src, user, 0.5 SECONDS, volume=50))
		to_chat(user, span_notice("Разбираю [src]."))
		new /obj/item/stack/rods(loc, 2)
		qdel(src)
		return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/bedsheetbin/wrench_act(mob/living/user, obj/item/tool)
	return default_unfasten_wrench(user, tool, 5)

/obj/structure/bedsheetbin/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/bedsheet))
		if(!user.transferItemToLoc(I, src))
			return
		sheets.Add(I)
		amount++
		to_chat(user, span_notice("Засунул [I] в [src]."))
		update_appearance()

	else if(amount && !hidden && I.w_class < WEIGHT_CLASS_BULKY) //make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		if(!user.transferItemToLoc(I, src))
			to_chat(user, span_warning("[I] застрял в моей руке, я не могу спрятать его среди просыней!"))
			return
		hidden = I
		to_chat(user, span_notice("Спрятал [I] среди простыней."))


/obj/structure/bedsheetbin/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/bedsheetbin/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(drop_location())
		user.put_in_hands(B)
		to_chat(user, span_notice("Вытащил [B] из [src]."))
		update_appearance()

		if(hidden)
			hidden.forceMove(drop_location())
			to_chat(user, span_notice("[hidden] выпадает из [B]!"))
			hidden = null

	add_fingerprint(user)


/obj/structure/bedsheetbin/attack_tk(mob/user)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(drop_location())
		to_chat(user, span_notice("Телекинетически вытащил [B] из [src]."))
		update_appearance()

		if(hidden)
			hidden.forceMove(drop_location())
			hidden = null

	add_fingerprint(user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

#undef BEDSHEET_ABSTRACT
#undef BEDSHEET_SINGLE
#undef BEDSHEET_DOUBLE

