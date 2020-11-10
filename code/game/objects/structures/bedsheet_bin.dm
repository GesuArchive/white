/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "простыня"
	desc = "Удивительно мягкая льняная простыня."
	icon = 'icons/obj/bedsheets.dmi'
	lefthand_file = 'icons/mob/inhands/misc/bedsheet_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/bedsheet_righthand.dmi'
	icon_state = "sheetwhite"
	inhand_icon_state = "sheetwhite"
	slot_flags = ITEM_SLOT_NECK
	layer = MOB_LAYER
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	dying_key = DYE_REGISTRY_BEDSHEET

	dog_fashion = /datum/dog_fashion/head/ghost
	var/list/dream_messages = list("white")

/obj/item/bedsheet/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/surgery_initiator, null)

/obj/item/bedsheet/attack_self(mob/user)
	if(!user.CanReach(src))		//No telekenetic grabbing.
		return
	if(!user.dropItemToGround(src))
		return
	if(layer == initial(layer))
		layer = ABOVE_MOB_LAYER
		to_chat(user, "<span class='notice'>Накрываю себя простынёй.</span>")
		forceMove(loc, 0, 0)
	else
		layer = initial(layer)
		to_chat(user, "<span class='notice'>Расстелаю простыню под собой.</span>")
	add_fingerprint(user)
	return

/obj/item/bedsheet/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER || I.get_sharpness())
		if (!(flags_1 & HOLOGRAM_1))
			var/obj/item/stack/sheet/cloth/shreds = new (get_turf(src), 3)
			transfer_fingerprints_to(shreds)
			shreds.add_fingerprint(user)
		qdel(src)
		to_chat(user, "<span class='notice'>Рву простыню на части.</span>")
	else
		return ..()

/obj/item/bedsheet/blue
	icon_state = "sheetblue"
	inhand_icon_state = "sheetblue"
	dream_messages = list("blue")

/obj/item/bedsheet/green
	icon_state = "sheetgreen"
	inhand_icon_state = "sheetgreen"
	dream_messages = list("green")

/obj/item/bedsheet/grey
	icon_state = "sheetgrey"
	inhand_icon_state = "sheetgrey"
	dream_messages = list("grey")

/obj/item/bedsheet/orange
	icon_state = "sheetorange"
	inhand_icon_state = "sheetorange"
	dream_messages = list("orange")

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"
	inhand_icon_state = "sheetpurple"
	dream_messages = list("purple")

/obj/item/bedsheet/patriot
	name = "патриотическая простыня"
	desc = "Вы никогда не чувствовали себя более свободными, чем когда спите на этом."
	icon_state = "sheetUSA"
	inhand_icon_state = "sheetUSA"
	dream_messages = list("America", "freedom", "fireworks", "bald eagles")

/obj/item/bedsheet/rainbow
	name = "радужная простыня"
	desc = "Разноцветное одеяло. На самом деле это несколько разных листов, разрезанных и сшитых вместе."
	icon_state = "sheetrainbow"
	inhand_icon_state = "sheetrainbow"
	dream_messages = list("red", "orange", "yellow", "green", "blue", "purple", "a rainbow")

/obj/item/bedsheet/red
	icon_state = "sheetred"
	inhand_icon_state = "sheetred"
	dream_messages = list("red")

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"
	inhand_icon_state = "sheetyellow"
	dream_messages = list("yellow")

/obj/item/bedsheet/mime
	name = "простыня мима"
	desc = "Очень успокаивающее полосатое одеяло. Кажется, что весь шум исчезает, когда ты под одеялом в этом."
	icon_state = "sheetmime"
	inhand_icon_state = "sheetmime"
	dream_messages = list("silence", "gestures", "a pale face", "a gaping mouth", "the mime")

/obj/item/bedsheet/clown
	name = "клоунская простыня"
	desc = "Радужное одеяло с вытканной маской клоуна. Пахнет бананами."
	icon_state = "sheetclown"
	inhand_icon_state = "sheetrainbow"
	dream_messages = list("honk", "laughter", "a prank", "a joke", "a smiling face", "the clown")

/obj/item/bedsheet/captain
	name = "простыня капитана"
	desc = "На нем есть символ нанотразена, и он был соткан из революционно нового вида нити, гарантированно имеющей проницаемость 0,01% для большинства нехимических веществ, популярных среди большинства современных капитанов."
	icon_state = "sheetcaptain"
	inhand_icon_state = "sheetcaptain"
	dream_messages = list("authority", "a golden ID", "sunglasses", "a green disc", "an antique gun", "the captain")

/obj/item/bedsheet/rd
	name = "простыня научного руководителя"
	desc = "Похоже, что на нем есть эмблема стакана, и он сделан из огнестойкого материала, хотя он, вероятно, не защитит вас в случае пожаров, с которыми вы знакомы каждый день."
	icon_state = "sheetrd"
	inhand_icon_state = "sheetrd"
	dream_messages = list("authority", "a silvery ID", "a bomb", "a mech", "a facehugger", "maniacal laughter", "the research director")

// for Free Golems.
/obj/item/bedsheet/rd/royal_cape
	name = "королевская накидка освободителя"
	desc = "Величественно."
	dream_messages = list("mining", "stone", "a golem", "freedom", "doing whatever")

/obj/item/bedsheet/medical
	name = "медицинская простыня"
	desc = "Это простерилизованное* одеяло, обычно используемое в медпункте. *Стерилизация аннулируется, если на станции присутствует вирусолог."
	icon_state = "sheetmedical"
	inhand_icon_state = "sheetmedical"
	dream_messages = list("healing", "life", "surgery", "a doctor")

/obj/item/bedsheet/cmo
	name = "простыня главного врача"
	desc = "Это простерилизованное одеяло с крестиком. На нем немного кошачьей шерсти, вероятно, Рантайма."
	icon_state = "sheetcmo"
	inhand_icon_state = "sheetcmo"
	dream_messages = list("authority", "a silvery ID", "healing", "life", "surgery", "a cat", "the chief medical officer")

/obj/item/bedsheet/hos
	name = "простыня начальника охраны"
	desc = "Он украшен гербом-щитом. Хотя преступление не спит, вы спите, но вы по-прежнему ЗАКОН!"
	icon_state = "sheethos"
	inhand_icon_state = "sheethos"
	dream_messages = list("authority", "a silvery ID", "handcuffs", "a baton", "a flashbang", "sunglasses", "the head of security")

/obj/item/bedsheet/hop
	name = "простыня главы персонала"
	desc = "Он декорирован ключевой эмблемой. Для тех редких моментов, когда вы можете отдохнуть и пообниматься с Яном, и никто не кричит вам по радио."
	icon_state = "sheethop"
	inhand_icon_state = "sheethop"
	dream_messages = list("authority", "a silvery ID", "obligation", "a computer", "an ID", "a corgi", "the head of personnel")

/obj/item/bedsheet/ce
	name = "простыня старшего инженера"
	desc = "Он украшен эмблемой гаечного ключа. Он обладает высокой отражающей способностью и устойчив к пятнам, поэтому вам не нужно беспокоиться о том, чтобы испортить его маслом."
	icon_state = "sheetce"
	inhand_icon_state = "sheetce"
	dream_messages = list("authority", "a silvery ID", "the engine", "power tools", "an APC", "a parrot", "the chief engineer")

/obj/item/bedsheet/qm
	name = "простыня завхоза"
	desc = "Он украшен эмблемой ящика на серебряной подкладке. Это довольно сложно, и на нем просто можно лежать после тяжелого дня работы с бумагой."
	icon_state = "sheetqm"
	inhand_icon_state = "sheetqm"
	dream_messages = list("a grey ID", "a shuttle", "a crate", "a sloth", "the quartermaster")

/obj/item/bedsheet/chaplain
	name = "святая простыня"
	desc = "Одеяло, сотканное из сердец самих богов... Погодите, это просто лён."
	icon_state = "sheetchap"
	inhand_icon_state = "sheetchap"
	dream_messages = list("a grey ID", "the gods", "a fulfilled prayer", "a cult", "the chaplain")

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"
	inhand_icon_state = "sheetbrown"
	dream_messages = list("brown")

/obj/item/bedsheet/black
	icon_state = "sheetblack"
	inhand_icon_state = "sheetblack"
	dream_messages = list("black")

/obj/item/bedsheet/centcom
	name = "простыня спецназа"
	desc = "Тканые из улучшенной нанонити для тепла, а также очень украшенные, необходимые для всех официальных лиц."
	icon_state = "sheetcentcom"
	inhand_icon_state = "sheetcentcom"
	dream_messages = list("a unique ID", "authority", "artillery", "an ending")

/obj/item/bedsheet/syndie
	name = "простыня синдиката"
	desc = "У него есть эмблема синдиката, и у него аура зла."
	icon_state = "sheetsyndie"
	inhand_icon_state = "sheetsyndie"
	dream_messages = list("a green disc", "a red crystal", "a glowing blade", "a wire-covered ID")

/obj/item/bedsheet/cult
	name = "простыня культиста"
	desc = "Вам может присниться Нар'Си, если вы будете спать с этим. Он кажется довольно изодранным и светится жутким присутствием."
	icon_state = "sheetcult"
	inhand_icon_state = "sheetcult"
	dream_messages = list("a tome", "a floating red crystal", "a glowing sword", "a bloody symbol", "a massive humanoid figure")

/obj/item/bedsheet/wiz
	name = "простыня волшебника"
	desc = "Особая ткань, зачарованная магией, чтобы вы могли провести волшебную ночь. Он даже светится!"
	icon_state = "sheetwiz"
	inhand_icon_state = "sheetwiz"
	dream_messages = list("a book", "an explosion", "lightning", "a staff", "a skeleton", "a robe", "magic")

/obj/item/bedsheet/nanotrasen
	name = "простыня Нанотрейзен"
	desc = "На нем есть логотип Нанотрейзен, и он создает ауру долга."
	icon_state = "sheetNT"
	inhand_icon_state = "sheetNT"
	dream_messages = list("authority", "an ending")

/obj/item/bedsheet/ian
	icon_state = "sheetian"
	inhand_icon_state = "sheetian"
	dream_messages = list("a dog", "a corgi", "woof", "bark", "arf")

/obj/item/bedsheet/cosmos
	name = "космическая простыня"
	desc = "Сделано из мечтаний тех, кто интересуется звездами."
	icon_state = "sheetcosmos"
	inhand_icon_state = "sheetcosmos"
	dream_messages = list("the infinite cosmos", "Hans Zimmer music", "a flight through space", "the galaxy", "being fabulous", "shooting stars")
	light_power = 2
	light_range = 1.4

/obj/item/bedsheet/random
	icon_state = "random_bedsheet"
	name = "random bedsheet"
	desc = "If you're reading this description ingame, something has gone wrong! Honk!"
	slot_flags = null

/obj/item/bedsheet/random/Initialize()
	..()
	var/type = pick(typesof(/obj/item/bedsheet) - /obj/item/bedsheet/random)
	new type(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/bedsheet/dorms
	icon_state = "random_bedsheet"
	name = "random dorms bedsheet"
	desc = "If you're reading this description ingame, something has gone wrong! Honk!"
	slot_flags = null

/obj/item/bedsheet/dorms/Initialize()
	..()
	var/type = pickweight(list("Colors" = 80, "Special" = 20))
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

/obj/structure/bedsheetbin
	name = "корзина для белья"
	desc = "Смотрится довольно уютно."
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
	. += "<hr>"
	if(amount < 1)
		. += "Внутри нет простыней."
	else if(amount == 1)
		. += "Осталась всего одна простыня."
	else
		. += "Здесь аж целых [amount] простыней."


/obj/structure/bedsheetbin/update_icon_state()
	switch(amount)
		if(0)
			icon_state = "linenbin-empty"
		if(1 to 5)
			icon_state = "linenbin-half"
		else
			icon_state = "linenbin-full"

/obj/structure/bedsheetbin/fire_act(exposed_temperature, exposed_volume)
	if(amount)
		amount = 0
		update_icon()
	..()

/obj/structure/bedsheetbin/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/bedsheet))
		if(!user.transferItemToLoc(I, src))
			return
		sheets.Add(I)
		amount++
		to_chat(user, "<span class='notice'>Закидываю [I] в [src].</span>")
		update_icon()

	else if(default_unfasten_wrench(user, I, 5))
		return

	else if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(flags_1 & NODECONSTRUCT_1)
			return
		if(amount)
			to_chat(user, "<span clas='warn'>Стоит опустошить [src] сначала!</span>")
			return
		if(I.use_tool(src, user, 5, volume=50))
			to_chat(user, "<span clas='notice'>Разбираю [src].</span>")
			new /obj/item/stack/rods(loc, 2)
			qdel(src)

	else if(amount && !hidden && I.w_class < WEIGHT_CLASS_BULKY)	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		if(!user.transferItemToLoc(I, src))
			to_chat(user, "<span class='warning'>Чёртов [I] застрял в моей руке. Не получится спрятать его среди простыней!</span>")
			return
		hidden = I
		to_chat(user, "<span class='notice'>Прячу [I] среди простыней.</span>")


/obj/structure/bedsheetbin/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/bedsheetbin/attack_hand(mob/user)
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
		to_chat(user, "<span class='notice'>Достаю [B] из [src].</span>")
		update_icon()

		if(hidden)
			hidden.forceMove(drop_location())
			to_chat(user, "<span class='notice'>[hidden] выпадает из [B]!</span>")
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
		to_chat(user, "<span class='notice'>Телекинетически достаю [B] из [src].</span>")
		update_icon()

		if(hidden)
			hidden.forceMove(drop_location())
			hidden = null

	add_fingerprint(user)
	return COMPONENT_CANCEL_ATTACK_CHAIN
