#define BOOKCASE_UNANCHORED 0
#define BOOKCASE_ANCHORED 1
#define BOOKCASE_FINISHED 2

/* Library Items
 *
 * Contains:
 *		Bookcase
 *		Book
 *		Barcode Scanner
 */

/*
 * Bookcase
 */

/obj/structure/bookcase
	name = "книжный шкаф"
	icon = 'icons/obj/library.dmi'
	icon_state = "bookempty"
	desc = "Отличное место для хранения знаний."
	anchored = FALSE
	density = TRUE
	opacity = FALSE
	resistance_flags = FLAMMABLE
	max_integrity = 200
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 0)
	var/state = BOOKCASE_UNANCHORED
	/// When enabled, books_to_load number of random books will be generated for this bookcase when first interacted with.
	var/load_random_books = FALSE
	/// The category of books to pick from when populating random books.
	var/random_category = null
	/// How many random books to generate.
	var/books_to_load = 0

/obj/structure/bookcase/examine(mob/user)
	. = ..()
	if(!anchored)
		. += "<hr><span class='notice'>Ох, он <i>откручен</i> от пола.</span>"
	else
		. += "<hr><span class='notice'>Он <b>прикручен</b> к полу.</span>"
	switch(state)
		if(BOOKCASE_UNANCHORED)
			. += "<hr><span class='notice'>Здесь есть <b>небольшая щель</b> сзади.</span>"
		if(BOOKCASE_ANCHORED)
			. += "<hr><span class='notice'>Здесь есть место для <i>деревянной</i> полки внутри.</span>"
		if(BOOKCASE_FINISHED)
			. += "<hr><span class='notice'>Здесь есть <b>небольшая щель</b> с краю.</span>"

/obj/structure/bookcase/Initialize(mapload)
	. = ..()
	if(!mapload)
		return
	set_anchored(TRUE)
	state = BOOKCASE_FINISHED
	for(var/obj/item/I in loc)
		if(!isbook(I))
			continue
		I.forceMove(src)
	update_icon()

/obj/structure/bookcase/set_anchored(anchorvalue)
	. = ..()
	if(isnull(.))
		return
	state = anchorvalue
	if(!anchorvalue) //in case we were vareditted or uprooted by a hostile mob, ensure we drop all our books instead of having them disappear till we're rebuild.
		var/atom/Tsec = drop_location()
		for(var/obj/I in contents)
			if(!isbook(I))
				continue
			I.forceMove(Tsec)
	update_icon()

/obj/structure/bookcase/attackby(obj/item/I, mob/user, params)
	switch(state)
		if(BOOKCASE_UNANCHORED)
			if(I.tool_behaviour == TOOL_WRENCH)
				if(I.use_tool(src, user, 20, volume=50))
					to_chat(user, span_notice("Прикручиваю рамку шкафа."))
					set_anchored(TRUE)
			else if(I.tool_behaviour == TOOL_CROWBAR)
				if(I.use_tool(src, user, 20, volume=50))
					to_chat(user, span_notice("Разламываю рамку шкафа."))
					deconstruct(TRUE)

		if(BOOKCASE_ANCHORED)
			if(istype(I, /obj/item/stack/sheet/mineral/wood))
				var/obj/item/stack/sheet/mineral/wood/W = I
				if(W.get_amount() >= 2)
					W.use(2)
					to_chat(user, span_notice("Добавляю полку."))
					state = BOOKCASE_FINISHED
					update_icon()
			else if(I.tool_behaviour == TOOL_WRENCH)
				I.play_tool_sound(src, 100)
				to_chat(user, span_notice("Откручиваю рамку шкафа."))
				set_anchored(FALSE)

		if(BOOKCASE_FINISHED)
			if(isbook(I))
				if(!user.transferItemToLoc(I, src))
					return
				update_icon()
			else if(atom_storage)
				for(var/obj/item/T in I.contents)
					if(istype(T, /obj/item/book) || istype(T, /obj/item/spellbook))
						atom_storage.attempt_remove(T, src)
				to_chat(user, span_notice("Кладу [I.name] в <b>[src.name]</b>."))
				update_icon()
			else if(istype(I, /obj/item/pen))
				if(!user.is_literate())
					to_chat(user, span_notice("Пишу закорючки на стороне [src.name]! ХЕХ!"))
					return
				var/newname = stripped_input(user, "Как назовём этот шкаф?")
				if(!user.canUseTopic(src, BE_CLOSE))
					return
				if(!newname)
					return
				else
					name = "книжный шкаф ([sanitize(newname)])"
			else if(I.tool_behaviour == TOOL_CROWBAR)
				if(contents.len)
					to_chat(user, span_warning("Надо бы сначала вытащить все книги!"))
				else
					I.play_tool_sound(src, 100)
					to_chat(user, span_notice("Вырываю полку."))
					new /obj/item/stack/sheet/mineral/wood(drop_location(), 2)
					state = BOOKCASE_ANCHORED
					update_icon()
			else
				return ..()


/obj/structure/bookcase/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!istype(user))
		return
	if(load_random_books)
		create_random_books(books_to_load, src, FALSE, random_category)
		load_random_books = FALSE
	if(contents.len)
		var/obj/item/book/choice = tgui_input_list(user, "Какую книгу возьмём?", , sort_names(contents.Copy()))
		if(choice)
			if(!(user.mobility_flags & MOBILITY_USE) || user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) || !in_range(loc, user))
				return
			if(ishuman(user))
				if(!user.get_active_held_item())
					user.put_in_hands(choice)
			else
				choice.forceMove(drop_location())
			update_icon()


/obj/structure/bookcase/deconstruct(disassembled = TRUE)
	var/atom/Tsec = drop_location()
	new /obj/item/stack/sheet/mineral/wood(Tsec, 4)
	for(var/obj/item/I in contents)
		if(!isbook(I))
			continue
		I.forceMove(Tsec)
	return ..()


/obj/structure/bookcase/update_icon_state()
	if(state == BOOKCASE_UNANCHORED || state == BOOKCASE_ANCHORED)
		icon_state = "bookempty"
		return
	var/amount = contents.len
	if(load_random_books)
		amount += books_to_load
	icon_state = "book-[clamp(amount, 0, 5)]"


/obj/structure/bookcase/manuals/engineering
	name = "книжный шкаф с инженерными инструкциями"

/obj/structure/bookcase/manuals/engineering/Initialize(mapload)
	. = ..()
	new /obj/item/book/manual/wiki/engineering_construction(src)
	new /obj/item/book/manual/wiki/engineering_hacking(src)
	new /obj/item/book/manual/wiki/engineering_guide(src)
	new /obj/item/book/manual/wiki/engineering_singulo_tesla(src)
	new /obj/item/book/manual/wiki/robotics_cyborgs(src)
	update_icon()


/obj/structure/bookcase/manuals/research_and_development
	name = "книжный шкаф для руководств по исследованиям и разработкам"

/obj/structure/bookcase/manuals/research_and_development/Initialize(mapload)
	. = ..()
	new /obj/item/book/manual/wiki/research_and_development(src)
	update_icon()


/*
 * Book
 */
/obj/item/book
	name = "книга"
	icon = 'icons/obj/library.dmi'
	icon_state ="book"
	worn_icon_state = "book"
	desc = "Раскройте её, вдохните пыль с её страниц и узнайте что-то новое."
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb_continuous = list("колотит", "вмазывает", "учит")
	attack_verb_simple = list("колотит", "вмазывает", "учит")
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound =  'sound/items/handling/book_pickup.ogg'
	var/dat				//Actual page content
	var/due_date = 0	//Game time in 1/10th seconds
	var/author			//Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/unique = FALSE	//false - Normal book, true - Should not be treated as normal book, unable to be copied, unable to be modified
	var/title			//The real name of the book.
	var/window_size = null // Specific window size for the book, i.e: "1920x1080", Size x Width


/obj/item/book/attack_self(mob/user)
	if(!user.can_read(src))
		return
	user.visible_message(span_notice("[user] открывает \"[title ? title : name]\" и начинает внимательно её изучать."))
	SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "book_nerd", /datum/mood_event/book_nerd)
	on_read(user)

/obj/item/book/proc/on_read(mob/user)
	if(dat)
		user << browse("<meta http-equiv='Content-Type' content='text/html; charset=utf-8'><TT><I>Автор: [author].</I></TT> <BR>" + "[dat]", "window=book[window_size != null ? ";size=[window_size]" : ""]")
		onclose(user, "book")
	else
		to_chat(user, span_notice("Книга пустая!"))


/obj/item/book/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pen))
		if(user.is_blind())
			to_chat(user, span_warning("Когда я открываю книгу, внезапно возникает ощущение того, что чего-то мне не хватает и это не только глаз!"))
			return
		if(unique)
			to_chat(user, span_warning("Страницы не принимают мои чернила совсем! Похоже, что дописать эту книгу у меня не выйдет."))
			return
		var/literate = user.is_literate()
		if(!literate)
			to_chat(user, span_notice("Выцарапываю закорючки на обложке [src.name]!"))
			return
		var/choice = tgui_input_list(usr, "Что меняем?",,list("Название", "Содержимое", "Автора", "Отмена"))
		if(!user.canUseTopic(src, BE_CLOSE, literate))
			return
		switch(choice)
			if("Название")
				var/newtitle = reject_bad_text(stripped_input(user, "Новое название:"))
				if(!user.canUseTopic(src, BE_CLOSE, literate))
					return
				if (length_char(newtitle) > 20)
					to_chat(user, span_warning("Это слишком длинное название!"))
					return
				if(!newtitle)
					to_chat(user, span_warning("Это название неправильное."))
					return
				else
					name = newtitle
					title = newtitle
			if("Содержимое")
				var/content = stripped_input(user, "Что мы сюда напишем? (HTML НЕ будет работать):","","",8192)
				if(!user.canUseTopic(src, BE_CLOSE, literate))
					return
				if(!content)
					to_chat(user, span_warning("Содержимое неправильное."))
					return
				else
					dat += content
			if("Автора")
				var/newauthor = stripped_input(user, "Автор:")
				if(!user.canUseTopic(src, BE_CLOSE, literate))
					return
				if(!newauthor)
					to_chat(user, span_warning("Имя неправильное."))
					return
				else
					author = newauthor
			else
				return

	else if(istype(I, /obj/item/barcodescanner))
		var/obj/item/barcodescanner/scanner = I
		if(!scanner.computer)
			to_chat(user, span_alert("Экран [I.name] вспыхивает: 'Не привязан компьютер!'"))
		else
			switch(scanner.mode)
				if(0)
					scanner.book = src
					to_chat(user, span_notice("Экран [I.name] вспыхивает: 'Книга сохранена в буфер.'"))
				if(1)
					scanner.book = src
					scanner.computer.buffer_book = name
					to_chat(user, span_notice("Экран [I.name] вспыхивает: 'Книга сохранена в буфер. Название книги теперь сохранено в буфере компьютера.'"))
				if(2)
					scanner.book = src
					for(var/datum/borrowbook/b in scanner.computer.checkouts)
						if(b.bookname == name)
							scanner.computer.checkouts.Remove(b)
							to_chat(user, span_notice("Экран [I.name] вспыхивает: 'Книга сохранена в буфер. Книга была зарегистрирована.'"))
							return
					to_chat(user, span_notice("Экран [I.name] вспыхивает: 'Книга сохранена в буфер. Для текущего заголовка не найдено активных записей о выдаче.'"))
				if(3)
					scanner.book = src
					for(var/obj/item/book in scanner.computer.inventory)
						if(book == src)
							to_chat(user, span_alert("Экран [I.name] вспыхивает: 'Книга сохранена в буфер. Заголовок уже присутствует в инвентаре, прерывание во избежание дублирования записи.'"))
							return
					scanner.computer.inventory.Add(src)
					to_chat(user, span_notice("Экран [I.name] вспыхивает: 'Книга сохранена в буфер. Название добавлено в общий инвентарь.'"))

	else if((istype(I, /obj/item/kitchen/knife) || I.tool_behaviour == TOOL_WIRECUTTER) && !(flags_1 & HOLOGRAM_1))
		to_chat(user, span_notice("Начинаю резать [title]..."))
		if(do_after(user, 30, target = src))
			to_chat(user, span_notice("Режу страницы [title]! Всё равно книги никто не читает."))
			var/obj/item/storage/book/B = new
			B.name = src.name
			B.title = src.title
			B.icon_state = src.icon_state
			if(user.is_holding(src))
				qdel(src)
				user.put_in_hands(B)
				return
			else
				B.forceMove(drop_location())
				qdel(src)
				return
		return
	else
		..()


/*
 * Barcode Scanner
 */
/obj/item/barcodescanner
	name = "сканер штрих-кода"
	icon = 'icons/obj/library.dmi'
	icon_state ="scanner"
	desc = "Отличный инструмент, если вам нужно отсканировать штрих-код."
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY
	var/obj/machinery/computer/bookmanagement/computer	//Associated computer - Modes 1 to 3 use this
	var/obj/item/book/book			//Currently scanned book
	var/mode = 0							//0 - Scan only, 1 - Scan and Set Buffer, 2 - Scan and Attempt to Check In, 3 - Scan and Attempt to Add to Inventory

/obj/item/barcodescanner/attack_self(mob/user)
	mode += 1
	if(mode > 3)
		mode = 0
	to_chat(user, "Дисплей [src.name] сообщает:")
	var/modedesc
	switch(mode)
		if(0)
			modedesc = "Сканировать книгу в локальный буфер."
		if(1)
			modedesc = "Сканировать книгу в локальный буфер и установить соответствующий буфер компьютера."
		if(2)
			modedesc = "Сканировать книгу в локальный буфер, попытка проверить отсканированную книгу."
		if(3)
			modedesc = "Сканировать книгу в локальный буфер, попытаться добавить книгу в общий инвентарь."
		else
			modedesc = "ОШИБКА"
	to_chat(user, " - Режим [mode] : [modedesc]")
	if(computer)
		to_chat(user, "<font color=green>Компьютер был связан с этим устройством.</font>")
	else
		to_chat(user, "<font color=red>Связанный компьютер не найден. Только локальное сканирование будет работать правильно.</font>")
	to_chat(user, "\n")


#undef BOOKCASE_UNANCHORED
#undef BOOKCASE_ANCHORED
#undef BOOKCASE_FINISHED
